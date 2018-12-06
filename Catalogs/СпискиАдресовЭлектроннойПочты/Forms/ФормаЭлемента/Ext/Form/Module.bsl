﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И Не ЗначениеЗаполнено(Объект.УчетнаяЗапись) Тогда
		
		Если Параметры.Свойство("УчетнаяЗапись") Тогда
			Объект.УчетнаяЗапись = Параметры.УчетнаяЗапись; 
		Иначе	
			Объект.УчетнаяЗапись = ВстроеннаяПочтаСервер.ПолучитьУчетнуюЗаписьДляОтправки();	
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.УчетнаяЗапись) Тогда
			ВызватьИсключение НСтр("ru = 'Не указана учетная запись. Рекомендуется в настройках почты установить учетную запись по умолчанию.'; en = 'Account is not specified. It is recommended in your personal mail settings set one account as default account.'");
		КонецЕсли;	
		
	КонецЕсли;
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ 
			|	ЗначенияУсловийПриОбработкеПисем.Правило КАК Правило,
			|	ЗначенияУсловийПриОбработкеПисем.Правило.Наименование КАК ПравилоНаименование
			|ИЗ
			|	РегистрСведений.ЗначенияУсловийПриОбработкеПисем КАК ЗначенияУсловийПриОбработкеПисем
			|ГДЕ
			|	ЗначенияУсловийПриОбработкеПисем.ВидУсловия = &ВидУсловия
			|	И ЗначенияУсловийПриОбработкеПисем.ПараметрУсловия = &ПараметрУсловия
			|	И ЗначенияУсловийПриОбработкеПисем.Правило.УчетнаяЗапись = &УчетнаяЗапись
			|
			|УПОРЯДОЧИТЬ ПО
			|	ПравилоНаименование";
			
		Запрос.УстановитьПараметр("ВидУсловия", Перечисления.ВидыУсловийОтбораВходящихПисем.АдресОтправителяВСписке);
		Запрос.УстановитьПараметр("ПараметрУсловия", Объект.Ссылка);
		Запрос.УстановитьПараметр("УчетнаяЗапись", Объект.УчетнаяЗапись);

		МассивПравил = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Правило");
		Для Каждого Правило Из МассивПравил Цикл
			Строка = ПравилаОбработкиПисем.Добавить();
			Строка.Ссылка = Правило;
		КонецЦикла;	
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимРаботыФормы", 2);
	ПараметрыОткрытия.Вставить("ОтображатьКонтрагентов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьЛичныхАдресатов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьРоли", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьЭлектронныеАдреса", Истина);
	
	// Открытие формы для редактирования списка адресатов
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПодобратьПродолжение",
		ЭтотОбъект);
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыОткрытия, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПродолжение(Результат, Параметры) Экспорт
	
	Если (ТипЗнч(Результат) <> Тип("Массив")) И (ТипЗнч(Результат) <> Тип("Соответствие")) Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество() > 0 Тогда
		Для Каждого Строка Из Результат Цикл
			НоваяСтрока = Объект.Адреса.Добавить();
			НоваяСтрока.Адрес = Строка.Адрес;
			НоваяСтрока.Представление = Строка.Представление;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресаАдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимРаботыФормы", 1);
	ПараметрыОткрытия.Вставить("ОтображатьКонтрагентов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьЛичныхАдресатов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьРоли", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьЭлектронныеАдреса", Истина);
	
	// Открытие формы для редактирования списка адресатов
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"АдресаАдресНачалоВыбораПродолжение",
		ЭтотОбъект);
		
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыОткрытия, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресаАдресНачалоВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если (ТипЗнч(Результат) <> Тип("Массив")) И (ТипЗнч(Результат) <> Тип("Соответствие")) Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество() > 0 Тогда
		Элементы.Адреса.ТекущиеДанные.Адрес = Результат[0].Адрес;
		Элементы.Адреса.ТекущиеДанные.Представление = Результат[0].Представление;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресаАдресАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Или СтрДлина(Текст) < 2 Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		Возврат;
	#КонецЕсли
	
	ЭтоВебКлиент = Ложь;
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#КонецЕсли
	
	ДанныеВыбора = ВстроеннаяПочтаСервер.ПолучитьДанныеВыбораДляЭлектронногоПисьма(
		Текст, 
		ТекущийПользователь, 
		ЭтоВебКлиент);
	ВстроеннаяПочтаКлиент.ЗаполнитьКартинкиВСпискеВыбора(ДанныеВыбора);		

	Если ДанныеВыбора.Количество() <> 0 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресаАдресОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Элементы.Адреса.ТекущиеДанные.Адрес = ВыбранноеЗначение.Адрес;
		Элементы.Адреса.ТекущиеДанные.Представление = ВыбранноеЗначение.Представление;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда	
		
		Элементы.Адреса.ТекущиеДанные.Адрес = ВыбранноеЗначение;
		Элементы.Адреса.ТекущиеДанные.Представление = "";
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресаАдресПриИзменении(Элемент)
	
	Если Элементы.Адреса.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ЗаполнитьПредставление(Элементы.Адреса.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставление(Идентификатор)
	
	Строка = Объект.Адреса.НайтиПоИдентификатору(Идентификатор);
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Представление = "";
	Адресат = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПочтовогоАдресата(
		Строка.Адрес, Представление);	
		
	СведенияОбАдресате = ВстроеннаяПочтаСервер.ПолучитьПредставлениеИКонтактАдресата(Адресат);
	Строка.Представление = СведенияОбАдресате.Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресаАдресОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Адреса.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Контакт = ПолучитьКонтакт(Элементы.Адреса.ТекущиеДанные.ПолучитьИдентификатор());
	Если ЗначениеЗаполнено(Контакт) Тогда
		ПоказатьЗначение(, Контакт);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКонтакт(Идентификатор)
	
	Строка = Объект.Адреса.НайтиПоИдентификатору(Идентификатор);
	Если Строка = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	Представление = "";
	Адресат = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПочтовогоАдресата(
		Строка.Адрес, Представление);	
		
	СведенияОбАдресате = ВстроеннаяПочтаСервер.ПолучитьПредставлениеИКонтактАдресата(Адресат);
	Возврат СведенияОбАдресате.Контакт;
	
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ПроверкаДублей(Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаДублей(Отказ)
	
	// Проверка незаполненных и повторяющихся пользователей.
	НомерСтроки = Объект.Адреса.Количество()-1;
	
	Пока НЕ Отказ И НомерСтроки >= 0 Цикл
		
		ТекущаяСтрока = Объект.Адреса.Получить(НомерСтроки);
		
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Адрес) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен адрес.'; en = 'Address is not filled..'"),
			                                                  ,
			                                                  "Объект.Адреса[" + Формат(НомерСтроки, "ЧГ=0") + "].Адрес",
			                                                  ,
			                                                  Отказ);
			Возврат;
		КонецЕсли;
		
		// Проверка наличия повторяющихся значений.
		
		ЧислоНайденных = 0;
		Для Каждого СтрокаСписка Из Объект.Адреса Цикл
			Если СтрокаСписка.Адрес = ТекущаяСтрока.Адрес Тогда
				ЧислоНайденных = ЧислоНайденных + 1;
			КонецЕсли;	
		КонецЦикла;	
		
		Если ЧислоНайденных > 1 Тогда
			
			СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Адрес ""%1"" повторяется.'; en = 'The address ""%1"" is repeated.'"), ТекущаяСтрока.Адрес);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаОшибки,
			                                                  ,
			                                                  "Объект.Адреса[" + Формат(НомерСтроки, "ЧГ=0") + "].Адрес",
			                                                  ,
			                                                  Отказ);
			Возврат;
		КонецЕсли;
			
		НомерСтроки = НомерСтроки - 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_СпискиАдресовЭлектроннойПочты");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВнутренниеАдресаты(Команда)
	
	НоваяСтрока = Объект.Адреса.Добавить();
	НоваяСтрока.Адрес = НСтр("ru='Все внутренние адресаты'; en = 'All internal addressees'");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаОбработкиПисемПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаОбработкиПисемПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаОбработкиПисемСсылкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПравилаОбработкиПисемСсылкаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры


