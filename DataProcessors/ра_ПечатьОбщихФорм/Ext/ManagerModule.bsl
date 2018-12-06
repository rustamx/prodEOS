﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РезультатСогласования") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"РезультатСогласования",
			НСтр("ru = 'Результат согласования'; en = 'Result of coordination'"),
			СформироватьПечатнуюФормуЛистаСогласования(МассивОбъектов,ОбъектыПечати));
		
	КонецЕсли;
		
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуЛистаСогласования(МассивОбъектов,ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ПолеСлева = 5;
	ТабличныйДокумент.ПолеСправа = 5;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЛИСТ_СОГЛАСОВАНИЯ";
	
	НомерТипаДокумента = 0;
	
	Макет = Обработки.ра_ПечатьОбщихФорм.ПолучитьМакет("ПФ_MXL_ЛистСогласования");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	// ТСК Близнюк С.И.; 12.10.2018; task#1451{
	ДокументСсылка = МассивОбъектов[0];
	СинонимДокумента = ДокументСсылка.Метаданные().Синоним;
	СтруктураДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Номер,Дата,Nesootvetstvie.Номер");
	
	Заголовок = "Лист визирования %1 № %2 от %3 Несоответствие %4
				|Является неотъемлемой частью документа.";
	Заголовок = СтрШаблон(Заголовок, СинонимДокумента, СтруктураДокумента.Номер, Формат(СтруктураДокумента.Дата,"ДФ=dd.MM.yyyy"), СтруктураДокумента.NesootvetstvieНомер);
	
	ОбластьЗаголовок.Параметры.Заполнить(Новый Структура("Заголовок", Заголовок));
	// ТСК Близнюк С.И.; 12.10.2018; task#1451}
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);	
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ТабличныйДокумент.Вывести(ОбластьШапка);	
	
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	
	ТаблицаДанных = ра_РаботаСПроцессами.ПолучитьЭтапыСогласованияПоДокументу(МассивОбъектов[0]);
	
	Для каждого ТекСтрока Из ТаблицаДанных.НайтиСтроки(Новый Структура("Исполнитель", "DORobot")) Цикл // артефакт
		ТаблицаДанных.Удалить(ТекСтрока);
	КонецЦикла;
		
	Для Каждого ТекСтрока Из ТаблицаДанных Цикл 
		ОбластьСтрока.Параметры.Заполнить(ТекСтрока);
		ТабличныйДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
			
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
