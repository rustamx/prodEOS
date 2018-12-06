﻿
#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.Подсистемы.НастройкаИАдминистрирование));
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.Подсистемы.НСИ));

	Если КлючВариантаОтчета = "СписокКатегорий" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Администрирование);
		
	ИначеЕсли КлючВариантаОтчета = "ТОП10Категорий" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "ТОП10Авторов" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
