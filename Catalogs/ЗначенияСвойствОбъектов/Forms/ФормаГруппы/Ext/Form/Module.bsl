﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
	   И Параметры.ЗначенияЗаполнения.Свойство("Наименование") Тогда
		
		Объект.Наименование = Параметры.ЗначенияЗаполнения.Наименование;
	КонецЕсли;
	
	Если НЕ Параметры.СкрытьВладельца Тогда
		Элементы.Владелец.Видимость = Истина;
	КонецЕсли;
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗаголовок()
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Объект.Владелец, "Заголовок, ЗаголовокФормыЗначения");
	
	ИмяСвойства = СокрЛП(ЗначенияРеквизитов.ЗаголовокФормыЗначения);
	
	Если НЕ ПустаяСтрока(ИмяСвойства) Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (%2)'; en = '%1 (%2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Создание)'; en = '%1 (Create)'"), ИмяСвойства);
		КонецЕсли;
	Иначе
		ИмяСвойства = Строка(ЗначенияРеквизитов.Заголовок);
		
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Группа значений свойства %2)'; en = '%1 (Group property values %2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Группа значений свойства %1 (Создание)'; en = 'Group property values %1 (Create)'"), ИмяСвойства);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
