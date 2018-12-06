﻿
&НаКлиенте
Процедура ТаблицаСтрокСтрокаОткрытие(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаСтрок.ТекущиеДанные;
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ТекущиеДанные.Строка) Тогда
		Если ТипЗнч(ТекущиеДанные.Строка) <> Тип("Строка") Тогда
			ПоказатьЗначение(, ТекущиеДанные.Строка);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") и ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Для Счетчик = 0 По Параметры.СписокЗначений.Количество() - 1 Цикл
		Элемент = Параметры.СписокЗначений[Счетчик];
		НоваяСтрока = ТаблицаСтрок.Добавить();
		НоваяСтрока.Строка = Элемент.Значение;
		НоваяСтрока.Представление = Параметры.СписокПредставлений[Счетчик];	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ВозвращаемыйСписок = Новый СписокЗначений();
	Для Каждого СтрокаТаблицы Из ТаблицаСтрок Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.Представление) Тогда
			ВозвращаемыйСписок.Добавить(СтрокаТаблицы.Строка);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Список", ВозвращаемыйСписок);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ТаблицаСтрок.ТекущиеДанные;
	
	ПараметрыОткрытия = Новый Структура;
	
	ПараметрыОткрытия.Вставить("РежимРаботыФормы", 2);
	ПараметрыОткрытия.Вставить("ОтображатьКонтрагентов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьЛичныхАдресатов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьРоли", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьЭлектронныеАдреса", Истина);

	// Открытие формы для редактирования списка адресатов
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ТаблицаСтрокСтрокаНачалоВыбораПродолжение",
		ЭтотОбъект);
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыОткрытия, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаНачалоВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Массив") И ТипЗнч(Результат) <> Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.ТаблицаСтрок.ТекущиеДанные;
	Если Результат.Количество() > 0 Тогда
		Если ЗначениеЗаполнено(Результат[0].Контакт) Тогда
			ТекущиеДанные.Строка = Результат[0].Контакт;
		ИначеЕсли ЗначениеЗаполнено(результат[0].Адресат) Тогда
			ТекущиеДанные.Строка = Результат[0].Контакт;
		Иначе
			ТекущиеДанные.Строка = Результат[0].Представление;
		КонецЕсли;
		ТекущиеДанные.Представление = Результат[0].Представление;
	КонецЕсли;
	Для Счетчик = 1 по Результат.Количество() - 1 Цикл
		НоваяСтрока = ТаблицаСтрок.Добавить();
		Если ЗначениеЗаполнено(Результат[Счетчик].Контакт) Тогда
			НоваяСтрока.Строка = Результат[Счетчик].Контакт;
		ИначеЕсли ЗначениеЗаполнено(результат[Счетчик].Адресат) Тогда
			НоваяСтрока.Строка = Результат[Счетчик].Контакт;
		Иначе
			НоваяСтрока.Строка = Результат[Счетчик].Представление;
		КонецЕсли;
		НоваяСтрока.Представление = Результат[Счетчик].Представление;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаСтрок.ТекущиеДанные;
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ТекущиеДанные.Представление = ВыбранноеЗначение.Представление;
		Если ЗначениеЗаполнено(ВыбранноеЗначение.Контакт) Тогда
			ТекущиеДанные.Строка = ВыбранноеЗначение.Контакт;
		ИначеЕсли ЗначениеЗаполнено(ВыбранноеЗначение.Адресат) Тогда
			ТекущиеДанные.Строка = ВыбранноеЗначение.Адресат;
		Иначе
			ТекущиеДанные.Строка = ВыбранноеЗначение.Представление;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
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
	
	ДанныеВыбора = ВстроеннаяПочтаСервер.ПолучитьДанныеВыбораДляЭлектронногоПисьма(Текст, 
		ТекущийПользователь, 
		ЭтоВебКлиент);
	ВстроеннаяПочтаКлиент.ЗаполнитьКартинкиВСпискеВыбора(ДанныеВыбора);		

	Если ДанныеВыбора.Количество() <> 0 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаСтрок.ТекущиеДанные;
	
	Если СтрДлина(Текст) < 2 Тогда
		Возврат;
	КонецЕсли;
	
	НовыйТекст = Текст;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ЭтоВебКлиент = Ложь;
		#Если ВебКлиент Тогда
			ЭтоВебКлиент = Истина;
		#КонецЕсли
		
		ДанныеВыбора = ВстроеннаяПочтаСервер.ПолучитьДанныеВыбораДляЭлектронногоПисьма(Текст, 
			ТекущийПользователь, 
			ЭтоВебКлиент);
		ВстроеннаяПочтаКлиент.ЗаполнитьКартинкиВСпискеВыбора(ДанныеВыбора);		
			
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Текст", Текст);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ТаблицаСтрокСтрокаОкончаниеВводаТекстаПродолжение",
			ЭтотОбъект, 
			ПараметрыОбработчика);
		Если ДанныеВыбора.Количество() >= 1 Тогда
			ПоказатьВыборИзСписка(ОписаниеОповещения, ДанныеВыбора);
			Возврат;
		КонецЕсли;
	    ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаОкончаниеВводаТекстаПродолжение(РезультатВыбора, Параметры) Экспорт
	
	Текст = Параметры.Текст;
	ТекущиеДанные = Элементы.ТаблицаСтрок.ТекущиеДанные;
	Если РезультатВыбора <> Неопределено Тогда
		
		ТекущиеДанные.Представление = РезультатВыбора.Значение.Представление;
		
		Если ЗначениеЗаполнено(РезультатВыбора.Значение.Контакт) Тогда
			ТекущиеДанные.Строка = РезультатВыбора.Значение.Контакт;
		ИначеЕсли ЗначениеЗаполнено(РезультатВыбора.Значение.Адресат) Тогда
			ТекущиеДанные.Строка = РезультатВыбора.Значение.Адресат;
		Иначе
			ТекущиеДанные.Строка = РезультатВыбора.Значение.Представление;
		КонецЕсли;
		
		Возврат;
	Иначе
		ТекущиеДанные.Представление = Текст;
		ТекущиеДанные.Строка = Текст;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаСтрок.ТекущиеДанные;
	Если ТекущиеДанные.Представление = "" Тогда
		ТекущиеДанные.Строка = Неопределено;
	КонецЕсли;
	
КонецПроцедуры


