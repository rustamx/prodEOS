﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращают статусы, для которых требуется запрос обновления у провайдера SMS.
//
// Возвращаемое значение:
//  Массив - Статусы.
//
Функция СтатусыТребующиеОбновления() Экспорт
	
	Статусы = Новый Массив;
	Статусы.Добавить(Передано);
	Статусы.Добавить(НеОтправлялось);
	Статусы.Добавить(Отправляется);
	Статусы.Добавить(Отправлено);
	
	Возврат Статусы;
	
КонецФункции

// Получает статус доставки SMS из строки.
//
// Параметры:
//  Строка - Строка - Строка статуса доставки.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СтатусыДоставкиSMS - Статус.
//
Функция ПолучитьИзСтроки(Строка) Экспорт
	
	Статус = Неопределено;
	
	Если Строка = "НеОтправлялось" Тогда
		Статус = НеОтправлялось;
	ИначеЕсли Строка = "Отправляется" Тогда
		Статус = Отправляется;
	ИначеЕсли Строка = "Отправлено" Тогда
		Статус = Отправлено;
	ИначеЕсли Строка = "НеОтправлено" Тогда
		Статус = НеОтправлено;
	ИначеЕсли Строка = "Доставлено" Тогда
		Статус = Доставлено;
	ИначеЕсли Строка = "НеДоставлено" Тогда
		Статус = НеДоставлено;
	КонецЕсли;
	
	Возврат Статус;
	
КонецФункции

#КонецОбласти

#КонецЕсли



