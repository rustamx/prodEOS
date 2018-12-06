﻿
// Возвращает строку, содержащую перечисление полей доступа через запятую.
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат	"Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
		
КонецПроцедуры

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.Документы.Document1;
	
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

Функция СформироватьМассивДанныхРолевойМодели(ДокументОбъект, ПараметрыФормирования = Неопределено) Экспорт
	
	ТаблицаНастроек = ра_ОбменДанными.ПолучитьТаблицуНастроекПолейПоУмолчанию(Метаданные.Документы.Document1);
	
	//В данную переменную необходимо передавать удаляемые реквизиты. Разделитель - запятая.
	УдаляемыеРеквизиты = "Ссылка,ПометкаУдаления,Проведен";
	ра_ОбменДанными.УдалитьСтрокиИзТаблицыНастроек(ТаблицаНастроек, УдаляемыеРеквизиты);
	
	АктуализироватьТаблицуНастроек(ТаблицаНастроек, ДокументОбъект);
	
	ра_ОбменДанными.ЗаполнитьТаблицуНастроекЗначениямиИзОбъекта(ТаблицаНастроек, ДокументОбъект);
		
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
	//Возврат Обработки.ра_ФормыБитрикс.Создать().ОписаниеФормы(Метаданные.Документы.Document1, ДокументОбъект);
	
КонецФункции

Процедура АктуализироватьТаблицуНастроек(ТаблицаНастроек, ДокументОбъект)
	
	ра_ОбменДанными.ИзменитьСтрокуВТаблицеНастроек(ТаблицаНастроек, "KlassifikatorMTR", , , , , "SelectionForm", , , , "ФормаСписка");
	
КонецПроцедуры

Функция ПолучитьМассивКнопок(ДокументОбъект) Экспорт
		
	МассивКнопок = Новый Массив;
		
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.Document1;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	РеквизитыОбъекта = МетаданныеДокумента.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеДокумента.СтандартныеРеквизиты;
		
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МассивДанных = Новый Массив;
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт
	
	МассивЗаголовков = Новый Массив;
		
	Возврат МассивЗаголовков;
	
КонецФункции

//V2

Функция ЕстьМетодДополнитьОписаниеМетаданных() Экспорт
	
	Возврат Истина;
	
КонецФункции

Процедура ДополнитьОписаниеМетаданных(ОбработкаОбъект, Данные) Экспорт
		
КонецПроцедуры

#КонецОбласти
