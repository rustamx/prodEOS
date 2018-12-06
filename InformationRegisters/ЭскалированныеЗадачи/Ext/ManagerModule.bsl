﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет запись в историю эскалации задач.
//
// Параметры:
//  Задача - ЗадачаСсылка.ЗадачаИсполнителя - Задача.
//  ПравилоЭскалации - СправочникСсылка.ПравилаЭскалацииЗадач - Правило эскалации.
//  ИнформацияОбЭскалации - Структура - Информация об эскалации. См. ЭскалацияЗадач.ИнформацияОбЭскалации().
//
Процедура Добавить(Задача, ПравилоЭскалации, ИнформацияОбЭскалации) Экспорт
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.Задача = Задача;
	МенеджерЗаписи.ПравилоЭскалации = ПравилоЭскалации;
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ИнформацияОбЭскалации);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


