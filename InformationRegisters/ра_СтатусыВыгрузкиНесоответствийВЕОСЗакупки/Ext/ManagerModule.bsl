﻿
Процедура ДобавитьЗапись(Несоответствие, ИмяСистемы, Статус, MessageID, ТекстОшибки) Экспорт 
	
	Если Не (ЗначениеЗаполнено(Несоответствие)
		И ЗначениеЗаполнено(ИмяСистемы)
		И ЗначениеЗаполнено(Статус)
		И ЗначениеЗаполнено(MessageID)) Тогда 
		// такого быть не должно, но проверку добавим
		Возврат;
	КонецЕсли;	
		
	Запись = РегистрыСведений.ра_СтатусыВыгрузкиНесоответствийВЕОСЗакупки.СоздатьМенеджерЗаписи();
	Запись.Период = ТекущаяДатаСеанса();
	Запись.Несоответствие = Несоответствие;
	Запись.ИмяСистемыПолучателя = ИмяСистемы;
	Запись.Статус = Статус;
	Запись.MessageID = MessageID;
	Запись.ТекстОшибки = ТекстОшибки;
	Запись.Записать();
	
КонецПроцедуры	