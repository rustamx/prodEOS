﻿
#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.Справочники.ra_MTRiO;
	
	ТаблицаРеквизитов = ра_ОбменДанными.ПолучитьТаблицуРеквизитовОбъекта(ОбъектМетаданных);
	
	АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов);
	
	ТекстЗапросаВложенныеТаблицы = ПолучитьТекстЗапросаВложенныеТаблицы();
	ТекстЗапросаСоединений = ПолучитьТекстЗапросаСоединений();
	
	Запрос = ра_ОбменДанными.ПолучитьЗапрос(ТаблицаРеквизитов, ПараметрыЗапросаHTTP, ПолноеИмя, ТекстЗапросаВложенныеТаблицы, ТекстЗапросаСоединений);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
	Результат.Вставить("value", МассивДанных);
	
	НастройкаФормы = ПараметрыЗапросаHTTP.Получить("$form_settings");
	Если ЗначениеЗаполнено(НастройкаФормы) И НастройкаФормы Тогда
		МассивКолонок = ПолучитьПолучитьМассивКолонокСписка();
		МассивКнопок = ПолучитьМассивКнопок(Запрос.Параметры);
		МассивФильтров = ПолучитьМассивФильтровСписка();
		Результат.Вставить("form_settings", МассивКолонок);
		Результат.Вставить("button_settings", МассивКнопок);
		Результат.Вставить("filter_settings", МассивФильтров);
	КонецЕсли;
							
КонецПроцедуры

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
		
	
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
			
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "";
			
КонецФункции

Функция ПолучитьМассивКнопок(ДокументОбъект) Экспорт
	
	МассивКнопок = Новый Массив;
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт
	
	МетаданныеСправочника = Метаданные.Справочники.ra_MTRiO;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	РеквизитыОбъекта = МетаданныеСправочника.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеСправочника.СтандартныеРеквизиты;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Код);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Наименование);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МассивДанных = Новый Массив;
	
	Возврат МассивДанных;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
		ОбработатьПараметрыВыбора(Параметры);	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ОбработатьПараметрыВыбора(Параметры);
	
КонецПроцедуры

Процедура ОбработатьПараметрыВыбора(Параметры)
	
	Если Параметры.Свойство("Отбор")
		и Параметры.Отбор.Свойство("KlassifikatorMTR") Тогда
		
		Если ЗначениеЗаполнено(Параметры.Отбор.KlassifikatorMTR) Тогда
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ra_KlassifikatorMTR.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ra_KlassifikatorMTR КАК ra_KlassifikatorMTR
			|ГДЕ
			|	ra_KlassifikatorMTR.Ссылка В ИЕРАРХИИ(&Ссылка)");
			
			Запрос.УстановитьПараметр("Ссылка", Параметры.Отбор.KlassifikatorMTR);
			
			ФиксированныйМассивКлассификатора = Новый ФиксированныйМассив(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0));
			Параметры.Отбор.Вставить("KlassifikatorMTR", ФиксированныйМассивКлассификатора);
			
		Иначе
			Параметры.Отбор.Удалить("KlassifikatorMTR");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Для Каждого КлючИЗнач Из Данные Цикл
		Представление = КлючИЗнач.Значение;	
	КонецЦикла;
	
	ра_ОбщегоНазначения.ОбработатьПустоеПредставление(Представление);
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТекущийЯзык() = Метаданные.Языки.Английский Тогда
		Поля.Добавить("NaimenovanieEn");	
	Иначе
		Поля.Добавить("Наименование");	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти