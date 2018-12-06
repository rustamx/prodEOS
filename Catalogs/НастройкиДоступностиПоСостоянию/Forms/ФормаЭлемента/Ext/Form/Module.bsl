﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДляВсехВидовДокументов = Перечисления.ВариантыНастройкиДоступностиДляВидовДокументов.ДляВсехВидовДокументов;
	
	Поставляемый = Ложь;
	Если Не Объект.Ссылка.Пустая() Тогда 
		ОписаниеНастроекДоступности = Делопроизводство.ОписанияНачальногоЗаполненияНастроекДоступностиПоСостояниям();
		Для Каждого ОписаниеНастройки Из ОписаниеНастроекДоступности Цикл
			Если ОписаниеНастройки.Идентификатор = Строка(Объект.Ссылка.УникальныйИдентификатор()) Тогда 
				Поставляемый = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;	
	Элементы.УстановитьСтандартныеНастройки.Видимость = Поставляемый;
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не ЗначениеЗаполнено(Объект.ТипДокумента) Тогда 
			Объект.ТипДокумента = Перечисления.ТипыОбъектов.ВходящиеДокументы;
		КонецЕсли;	
		Если Не ЗначениеЗаполнено(Объект.ВариантНастройкиДляВидовДокументов) Тогда 
			Объект.ВариантНастройкиДляВидовДокументов = ДляВсехВидовДокументов;
		КонецЕсли;
		Если Объект.ИспользоватьДля.Количество() = 0 Тогда 
			НоваяСтрока = Объект.ИспользоватьДля.Добавить();
			НоваяСтрока.Участник = Справочники.РабочиеГруппы.ВсеПользователи;
		КонецЕсли;
	КонецЕсли;	
	НачальныйТипДокумента = Объект.ТипДокумента;
	
	Если Объект.ТипДокумента = Перечисления.ТипыОбъектов.ВнутренниеДокументы
	 Или Объект.ТипДокумента = Перечисления.ТипыОбъектов.ИсходящиеДокументы Тогда 
		Элементы.НастройкиДоступностиПредставлениеПоляКоманды.ФиксацияВТаблице = ФиксацияВТаблице.Лево;
	КонецЕсли;
	
	Элементы.ТипДокументаДекорация.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='(%1)'; en = '(%1)'"), НРег(Объект.ТипДокумента));
	
	ЗаполнитьНастройкиДоступности();
	
	ЗаполнитьВидыДокументов(Объект.Ссылка);
	
	КоличествоВидов = ВидыДокументов.Количество();
	
	Если Объект.ВариантНастройкиДляВидовДокументов = ДляВсехВидовДокументов Тогда 
		Элементы.ВидыДокументов.Доступность = Ложь;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'; en = 'Data has been changed. Save changes?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		
		Если НачальныйТипДокумента <> Объект.ТипДокумента И Объект.Предопределенный Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(	
				НСтр("ru = 'Нельзя изменить тип документа для предопределенной настройки доступности по состоянию.'; en = 'You cannot change document type for a predefined state based availability settings'"),,
				"Объект.ТипДокумента",,
				Отказ);
			Возврат;
		КонецЕсли;
		
		Если (НачальныйТипДокумента <> Объект.ТипДокумента) 
			И ВидыДокументов.Количество() > 0 
			И Не ПараметрыЗаписи.Свойство("ПоказанВопросОбИзмененияТипаДокумента") Тогда 
			
			ТекстВопроса = НСтр("ru = 'При изменении типа документа будут очищены назначенные виды документов.
				|Продолжить?';
				|en = 'When you change the document class settings assigned to document types will be cleared. 
				|Continue?'");
			ОписаниеОповещения = Новый ОписаниеОповещения(
					"ПередЗаписьюПродолжениеПослеПоказаВопросаОбИзмененияТипаДокумента",
					ЭтотОбъект,
					ПараметрыЗаписи);
	
			ПоказатьВопрос(ОписаниеОповещения,ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;	
	
	КоличествоСтрок = Объект.ИспользоватьДля.Количество();
	Для Инд = 1 По КоличествоСтрок Цикл
		Строка = Объект.ИспользоватьДля[КоличествоСтрок - Инд];
		Если Не ЗначениеЗаполнено(Строка.Участник) Тогда 
			Объект.ИспользоватьДля.Удалить(Строка);
		КонецЕсли;	
	КонецЦикла;	
	
	КоличествоСтрок = ВидыДокументов.Количество();
	Для Инд = 1 По КоличествоСтрок Цикл
		Строка = ВидыДокументов[КоличествоСтрок - Инд];
		Если Не ЗначениеЗаполнено(Строка.ВидДокумента) Тогда 
			ВидыДокументов.Удалить(Строка);
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюПродолжениеПослеПоказаВопросаОбИзмененияТипаДокумента(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;	
	
	ВидыДокументов.Очистить();

	ПараметрыЗаписи.Вставить("ПоказанВопросОбИзмененияТипаДокумента", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СохранитьНастройкиДоступности(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьВидыДокументов(ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	НачальныйТипДокумента = Объект.ТипДокумента;
	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Изменение:'; en = 'Changed:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ВариантНастройкиДляВидовДокументов = Перечисления.ВариантыНастройкиДоступностиДляВидовДокументов.ДляВыбранныхВидовДокументов Тогда 
		ПроверяемыеРеквизиты.Добавить("ВидыДокументов");
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантыНастройкиДоступностиДляВидовДокументовПриИзменении(Элемент)
	
	Если Объект.ВариантНастройкиДляВидовДокументов = ДляВсехВидовДокументов Тогда 
		
		Элементы.ВидыДокументов.Доступность = Ложь;
		ВидыДокументов.Очистить();
		КоличествоВидов = 0;
		
	Иначе
		Элементы.ВидыДокументов.Доступность = Истина;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИспользоватьДля

&НаКлиенте
Процедура ИспользоватьДляОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		Объект.ИспользоватьДля.Очистить();
		Для Каждого ВыбранныйАдресат Из ВыбранноеЗначение Цикл
			ИспользоватьДля = Объект.ИспользоватьДля.Добавить();
			ИспользоватьДля.Участник = ВыбранныйАдресат.Контакт;
		КонецЦикла;
	Иначе
		Элементы.ИспользоватьДля.ТекущиеДанные.Участник = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДляУчастникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1); // выбор
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ОтображатьАвтоподстановкиПоДокументам", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы",
		НСтр("ru = 'Выбор пользователей для настроек доступности'; en = 'Choice users to use availability settings'"));
	
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", Элементы.ИспользоватьДля.ТекущиеДанные.Участник);
		
	ОткрытьФорму("Справочник.АдреснаяКнига.ФормаСписка",
		ПараметрыФормы,
		Элементы.ИспользоватьДля,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДляУчастникАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = СформироватьДанныеВыбораСервер(Текст);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыДокументов

&НаКлиенте
Процедура ВидыДокументовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элемент.ТекущиеДанные.ВидДокумента = Неопределено Тогда
		Если Объект.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ВходящиеДокументы") Тогда 
			Элемент.ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыВходящихДокументов.ПустаяСсылка");
		ИначеЕсли Объект.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ИсходящиеДокументы") Тогда 
			Элемент.ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыИсходящихДокументов.ПустаяСсылка");
		ИначеЕсли Объект.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ВнутренниеДокументы") Тогда 
			Элемент.ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыВнутреннихДокументов.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДокументовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	КоличествоВидов = ВидыДокументов.Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДокументовПослеУдаления(Элемент)
	
	КоличествоВидов = ВидыДокументов.Количество();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДокументовВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИмяФормыВыбора = "";
	Если Объект.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ВходящиеДокументы") Тогда 
		ИмяФормыВыбора = "Справочник.ВидыВходящихДокументов.ФормаВыбора";
	ИначеЕсли Объект.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ИсходящиеДокументы") Тогда 
		ИмяФормыВыбора = "Справочник.ВидыИсходящихДокументов.ФормаВыбора";
	ИначеЕсли Объект.ТипДокумента = ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ВнутренниеДокументы") Тогда 
		ИмяФормыВыбора = "Справочник.ВидыВнутреннихДокументов.ФормаВыбора";
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура;
	ТекущиеДанные = Элементы.ВидыДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ПараметрыФормы.Вставить("ТекущаяСтрока", ТекущиеДанные.ВидДокумента);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ИмяФормыВыбора) Тогда 
		ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, Элемент);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиДоступности

&НаКлиенте
Процедура НастройкиДоступностиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = НастройкиДоступности.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.НастройкиДоступностиПредставлениеПоляКоманды Тогда 
		Возврат;
	КонецЕсли;	
	
	ИмяКолонки = СтрЗаменить(Поле.Имя, "НастройкиДоступности", "");
	ДоступностьПоля = ТекущиеДанные[ИмяКолонки];
	
	ДоступностьПоля = ДоступностьПоля + 1;
	Если ДоступностьПоля > 2 Тогда 
		ДоступностьПоля = 0;
	КонецЕсли;	
	
	ТекущиеДанные[ИмяКолонки] = ДоступностьПоля;
	ТекущиеДанные[ИмяКолонки + "Строкой"] = ДоступностьСтрокой(ДоступностьПоля);;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиДоступностиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиДоступностиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"УстановитьСтандартныеНастройкиПродолжение",
		ЭтотОбъект);
	
	Если Объект.НастройкиДоступности.Количество() > 0 Тогда 
		
		ТекстВопроса = НСтр("ru = 'Настройки доступности будут заполнены стандартными значениями.
			|Продолжить?';
			|en = 'Availability settings will be filled with default values.
			|Do you want to continue?'");

		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДляПодобрать(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 2); // подбор
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ОтображатьАвтоподстановкиПоДокументам", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы",
		НСтр("ru = 'Выбор пользователей для настроек доступности'; en = 'Choice users to use availability settings'"));
	
	ВыбранныеАдресаты = Новый Массив;
	
	Для Каждого ИспользоватьДля Из Объект.ИспользоватьДля Цикл
		ВыбранныйАдресат = Новый Структура;
		ВыбранныйАдресат.Вставить("Контакт",
			ИспользоватьДля.Участник);
		ВыбранныеАдресаты.Добавить(ВыбранныйАдресат);
	КонецЦикла;
	
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранныеАдресаты);
		
	ОткрытьФорму("Справочник.АдреснаяКнига.ФормаСписка",
		ПараметрыФормы,
		Элементы.ИспользоватьДля,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСтандартныеНастройкиПродолжение(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда 
		ЗаполнитьНастройкиПоУмолчанию();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиДоступности()
	
	ТаблНастройкиДоступности = РеквизитФормыВЗначение("НастройкиДоступности");
	ТаблНастройкиДоступности.Очистить();
	
	ТаблицаИмен = Делопроизводство.ПолучитьИменаПолейИКомандДляНастройкиДоступности(Объект.ТипДокумента);
	Для Каждого Строка Из ТаблицаИмен Цикл
		НоваяСтрока = ТаблНастройкиДоступности.Добавить();
		НоваяСтрока.ИмяПоляКоманды = Строка.ИмяПоляКоманды;
		НоваяСтрока.ПредставлениеПоляКоманды = Строка.ПредставлениеПоляКоманды;
	КонецЦикла;	
	
	Для Каждого Строка Из Объект.НастройкиДоступности Цикл
		НайденнаяСтрока = ТаблНастройкиДоступности.Найти(Строка.ИмяПоляКоманды, "ИмяПоляКоманды");
		Если НайденнаяСтрока = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
    	Индекс = Перечисления.СостоянияДокументов.Индекс(Строка.Состояние);
    	Имя = Метаданные.Перечисления.СостоянияДокументов.ЗначенияПеречисления[Индекс].Имя;

		НайденнаяСтрока[Имя] = Строка.Доступность;
		НайденнаяСтрока[Имя + "Строкой"] = ДоступностьСтрокой(Строка.Доступность);
	КонецЦикла;	
	
	ЗначениеВРеквизитФормы(ТаблНастройкиДоступности, "НастройкиДоступности");
	
	ВсеСостояния = Новый Структура(
		"Проект, 
		|НаСогласовании, 
		|Согласован, 
		|НеСогласован, 
		|НаУтверждении, 
		|Утвержден, 
		|НеУтвержден,
		|НаПодписании, 
		|Подписан, 
		|Отклонен,
		|НаРегистрации, 
		|Зарегистрирован, 
		|НеЗарегистрирован, 
		|НаРассмотрении, 
		|Рассмотрен, 
		|НаИсполнении, 
		|Исполнен");
	
	Если Объект.ТипДокумента = Перечисления.ТипыОбъектов.ВходящиеДокументы Тогда 
		
		ДоступныеСостояния = Новый Структура(
		"НаРегистрации, 
		|Зарегистрирован, 
		|НеЗарегистрирован, 
		|НаРассмотрении, 
		|Рассмотрен, 
		|НаИсполнении, 
		|Исполнен");
		
	ИначеЕсли Объект.ТипДокумента = Перечисления.ТипыОбъектов.ИсходящиеДокументы Тогда 
		
		ДоступныеСостояния = Новый Структура(
		"Проект, 
		|НаСогласовании, 
		|Согласован, 
		|НеСогласован, 
		|НаУтверждении, 
		|Утвержден, 
		|НеУтвержден, 
		|НаРегистрации, 
		|Зарегистрирован,
		|НеЗарегистрирован");
		
	ИначеЕсли Объект.ТипДокумента = Перечисления.ТипыОбъектов.ВнутренниеДокументы Тогда 
		
		ДоступныеСостояния = Новый Структура(
		"Проект, 
		|НаСогласовании, 
		|Согласован, 
		|НеСогласован, 
		|НаУтверждении, 
		|Утвержден, 
		|НеУтвержден,
		|НаПодписании, 
		|Подписан, 
		|Отклонен,
		|НаРегистрации, 
		|Зарегистрирован, 
		|НеЗарегистрирован, 
		|НаРассмотрении, 
		|Рассмотрен, 
		|НаИсполнении, 
		|Исполнен");
		
	КонецЕсли;	
	
	Для Каждого Эл из ВсеСостояния Цикл
		Если ДоступныеСостояния.Свойство(Эл.Ключ) Тогда 
			Элементы["НастройкиДоступности" + Эл.Ключ].Видимость = Истина;
		Иначе	
			Элементы["НастройкиДоступности" + Эл.Ключ].Видимость = Ложь;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиДоступности(ТекущийОбъект)
	
	ТекущийОбъект.НастройкиДоступности.Очистить();
	
	ТаблНастройкиДоступности = РеквизитФормыВЗначение("НастройкиДоступности");
	Для Каждого Строка Из ТаблНастройкиДоступности Цикл
		
		Для Каждого Колонка Из ТаблНастройкиДоступности.Колонки Цикл
			Если Колонка.Имя = "ИмяПоляКоманды" 
			 Или Колонка.Имя = "ПредставлениеПоляКоманды" 
			 Или Найти(Колонка.Имя, "Строкой") > 0 Тогда 
				Продолжить;
			КонецЕсли;	
			
			НоваяСтрока = ТекущийОбъект.НастройкиДоступности.Добавить();
			НоваяСтрока.ИмяПоляКоманды = Строка.ИмяПоляКоманды;
			НоваяСтрока.Доступность = Строка[Колонка.Имя];
			НоваяСтрока.Состояние = Перечисления.СостоянияДокументов[Колонка.Имя];
		КонецЦикла;	
			
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьНастройкиПоУмолчанию()
	
	Объект.НастройкиДоступности.Очистить();
	
	ТаблНастройкиДоступности = Неопределено;
	
	ОписаниеНастроекДоступности = Делопроизводство.ОписанияНачальногоЗаполненияНастроекДоступностиПоСостояниям();
	Для Каждого ОписаниеНастройки Из ОписаниеНастроекДоступности Цикл
		Если ОписаниеНастройки.Идентификатор = Строка(Объект.Ссылка.УникальныйИдентификатор()) Тогда 
			
			ТаблНастройкиДоступности = Делопроизводство.ПолучитьНастройкиДоступностиПоУмолчанию(
				Объект.ТипДокумента, ОписаниеНастройки.Роль);
			
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	
	Если ТаблНастройкиДоступности = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
		
	Объект.НастройкиДоступности.Загрузить(ТаблНастройкиДоступности);
	
	ЗаполнитьНастройкиДоступности();
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьВидыДокументов(Ссылка)
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда 
		Возврат;
	КонецЕсли;	
	
	НаборЗаписей = РегистрыСведений.НастройкиДоступностиДляВидовДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.НастройкаДоступностиПоСостоянию.Установить(Ссылка);
	НаборЗаписей.Прочитать();
	
	ВидыДокументов.Очистить();
	Для Каждого Строка Из НаборЗаписей Цикл
		НоваяСтрока = ВидыДокументов.Добавить();
		НоваяСтрока.ВидДокумента = Строка.ВидДокумента;
	КонецЦикла;	
	
КонецПроцедуры	
	
&НаСервере
Процедура ЗаписатьВидыДокументов(Ссылка)
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда 
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.НастройкиДоступностиДляВидовДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.НастройкаДоступностиПоСостоянию.Установить(Ссылка);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	ТаблВидыДокументов = РеквизитФормыВЗначение("ВидыДокументов");
	Для Каждого Строка Из ТаблВидыДокументов Цикл
		НоваяСтрока = НаборЗаписей.Добавить();
		НоваяСтрока.ВидДокумента = Строка.ВидДокумента;
		НоваяСтрока.НастройкаДоступностиПоСостоянию = Ссылка;
	КонецЦикла;	
	
	НаборЗаписей.Записать();
	
КонецПроцедуры		

Функция СформироватьДанныеВыбораСервер(Текст)
	
	ДополнениеТипа = Новый ОписаниеТипов(
		"Строка, СправочникСсылка.ПолныеРоли, СправочникСсылка.СтруктураПредприятия, СправочникСсылка.РабочиеГруппы");
	Возврат РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДоступностьСтрокой(Доступность)
	
	Если Доступность = 0 Тогда
		Возврат НСтр("ru = '●'; en = '●'");
	ИначеЕсли Доступность = 1 Тогда
		Возврат НСтр("ru = '✔'; en = '✔'");
	ИначеЕсли Доступность = 2 Тогда
		Возврат НСтр("ru = '✘'; en = '✘'");
	КонецЕсли;
	
КонецФункции

Процедура УстановитьУсловноеОформление()
	
	Колонки = Новый Структура(
	"Проект, 
	|НаСогласовании, 
	|Согласован, 
	|НеСогласован, 
	|НаУтверждении, 
	|Утвержден, 
	|НеУтвержден,
	|НаПодписании, 
	|Подписан, 
	|Отклонен,
	|НаРегистрации, 
	|Зарегистрирован, 
	|НеЗарегистрирован, 
	|НаРассмотрении, 
	|Рассмотрен, 
	|НаИсполнении, 
	|Исполнен");
	
	УсловноеОформлениеФормы = ЭтаФорма.УсловноеОформление;
	ЦветКрасный = Метаданные.ЭлементыСтиля.ЗапрещенноеПравоДоступа.Значение;
	ЦветЗеленый = Метаданные.ЭлементыСтиля.РазрешенноеПравоДоступа.Значение;
	ЦветСерый = Метаданные.ЭлементыСтиля.НеустановленноеПравоДоступа.Значение;
	ШрифтОбычный = Новый Шрифт(, , );
	
	Для Каждого Колонка Из Колонки Цикл
		
		ЭлементУсловногоОформления = УсловноеОформлениеФормы.Элементы.Добавить();
		ЭлементУсловногоОформления.Использование = Истина;
		
		ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности."+Колонка.Ключ);
		ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = 1;
		ЭлементОтбораДанных.Использование = Истина;
		
		ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
		ЭлементЦветаОформления.Значение = ЦветЗеленый; 
		ЭлементЦветаОформления.Использование = Истина;
		
		Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("НастройкиДоступности"+Колонка.Ключ);
		
		ЭлементУсловногоОформления = УсловноеОформлениеФормы.Элементы.Добавить();
		ЭлементУсловногоОформления.Использование = Истина;
		
		ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности."+Колонка.Ключ);
		ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = 2;
		ЭлементОтбораДанных.Использование = Истина;
		
		ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
		ЭлементЦветаОформления.Значение = ЦветКрасный; 
		ЭлементЦветаОформления.Использование = Истина;
		
		Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("НастройкиДоступности"+Колонка.Ключ);
		
		
		ЭлементУсловногоОформления = УсловноеОформлениеФормы.Элементы.Добавить();
		ЭлементУсловногоОформления.Использование = Истина;
		
		ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиДоступности."+Колонка.Ключ);
		ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = 0;
		ЭлементОтбораДанных.Использование = Истина;
		
		ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
		ЭлементЦветаОформления.Значение = ЦветСерый; 
		ЭлементЦветаОформления.Использование = Истина;
		
		ЭлементШрифтОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Font");
		ЭлементШрифтОформления.Значение = ШрифтОбычный; 
		ЭлементШрифтОформления.Использование = Истина;
		
		Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		Поле.Поле = Новый ПолеКомпоновкиДанных("НастройкиДоступности"+Колонка.Ключ);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
