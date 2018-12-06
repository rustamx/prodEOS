﻿
#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.ДокументыИФайлы));
	
	Если КлючВариантаОтчета = "СписокНеотработанныхДокументов" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ВнутренниеДокументыСписок);
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ВходящиеДокументыСписок);
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ИсходящиеДокументыСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоДокументам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.КонтрольныеОтчеты);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Просроченное);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти


