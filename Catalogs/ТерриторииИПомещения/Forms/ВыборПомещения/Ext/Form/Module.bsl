﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДоступноБронирование = ПолучитьФункциональнуюОпцию("ИспользоватьБронированиеПомещений");
	Если Не ДоступноБронирование Тогда
		Элементы.ТерриторииОтветственный.Видимость = Ложь;
		Элементы.ТерриторииВместимость.Видимость = Ложь;
		Элементы.ТерриторииОписание.Видимость = Ложь;
		Элементы.Территории.Шапка = Ложь;
		Элементы.Территории.ГоризонтальныеЛинии = Ложь;
	КонецЕсли;
	
	ЗаполнитьДеревоТерриторий();
	
	// Создание территорий
	ЕстьПравоСозданияПомещений = ПравоДоступа("Добавление", Метаданные.Справочники.ТерриторииИПомещения);
	Элементы.Территории.ИзменятьСоставСтрок = ЕстьПравоСозданияПомещений;
	Элементы.ТерриторииДобавить.Видимость = ЕстьПравоСозданияПомещений;
	Элементы.ТерриторииСкопировать.Видимость = ЕстьПравоСозданияПомещений;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ТерриторииИПомещения" Тогда
		СвернутыеЭлементы = ПолучитьСвернутыеЭлементы();
		ЗаполнитьДеревоТерриторий();
		ВосстановитьСостояниеТерритории(Территории.ПолучитьЭлементы(), СвернутыеЭлементы);
		ВосстановитьТекущийЭлементДерева(Территории.ПолучитьЭлементы(), Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТерритории

&НаКлиенте
Процедура ТерриторииВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элемент.ДанныеСтроки(Значение);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если КлючНазначенияИспользования = "ВыборПомещенияДляБрони"
		И Не ДанныеСтроки.ДоступноБронирование Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Данное помещение недоступно для бронирования.'; en = 'The premises is unavailable for reservation'"));
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ДанныеСтроки.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТерриторииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДанныеСтроки = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ТерриторииДоступнаСхема Тогда
		СтандартнаяОбработка = Ложь;
		БронированиеПомещенийКлиент.ПоказатьСхемуТерритории(ДанныеСтроки.Ссылка);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТерриторииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыФормы = Новый Структура;
	ТекущиеДанные = Элементы.Территории.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Если Копирование Тогда
			ПараметрыФормы.Вставить("ЗначениеКопирования", ТекущиеДанные.Ссылка);
		Иначе
			ЗначенияЗаполнения = Новый Структура;
			ЗначенияЗаполнения.Вставить("Родитель", ТекущиеДанные.Ссылка);
			ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ТерриторииИПомещения.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТерриторииПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтображатьУдаленные(Команда)
	
	ОтображатьУдаленные = Не ОтображатьУдаленные;
	ЗаполнитьДеревоТерриторий();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	БронированиеПомещений.УстановитьУсловноеОформлениеТерритории(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоТерриторий();
	
	Дерево = РеквизитФормыВЗначение("Территории");
	БронированиеПомещений.ЗаполнитьДеревоТерриторий(
		Дерево, ОтображатьУдаленные, КлючНазначенияИспользования = "ВыборПомещенияДляБрони");
	ЗначениеВРеквизитФормы(Дерево, "Территории");
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСвернутыеЭлементы()
	
	СвернутыеЭлементы = Новый Массив;
	
	Для Каждого ЭлементДерева Из Территории.ПолучитьЭлементы() Цикл
		
		Если Не Элементы.Территории.Развернут(ЭлементДерева.ПолучитьИдентификатор()) Тогда
			СвернутыеЭлементы.Добавить(ЭлементДерева.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СвернутыеЭлементы;
	
КонецФункции

&НаКлиенте
Процедура ВосстановитьСостояниеТерритории(ЭлементыДерева, СвернутыеЭлементы)
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		
		Свернут = Ложь;
		Для Каждого СвернутыйЭлемент Из СвернутыеЭлементы Цикл
			Если ЭлементДерева.Ссылка = СвернутыйЭлемент Тогда
				Элементы.Территории.Свернуть(ЭлементДерева.ПолучитьИдентификатор());
				Свернут = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Свернут Тогда
			Элементы.Территории.Свернуть(ЭлементДерева.ПолучитьИдентификатор());
		Иначе
			Элементы.Территории.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
			ВосстановитьСостояниеТерритории(ЭлементДерева.ПолучитьЭлементы(), СвернутыеЭлементы);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьТекущийЭлементДерева(ЭлементыДерева, ТекущийЭлемент)
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		
		Если ЭлементДерева.Ссылка = ТекущийЭлемент Тогда
			Элементы.Территории.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
			Возврат;
		КонецЕсли;
		
		ВосстановитьТекущийЭлементДерева(ЭлементДерева.ПолучитьЭлементы(), ТекущийЭлемент);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
