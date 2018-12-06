﻿
#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.ДокументыИФайлы));

	Если КлючВариантаОтчета = "СписокНеподписанныхВнутреннихДокументов" Тогда
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоВнутреннимДокументам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоКонтрагентам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоДоговорам);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
