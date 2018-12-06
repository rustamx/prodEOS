﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей Условия маршрутизации
//
// Возвращаемое значение:
//   Структура
//     Наименование
//     ТипОбъекта
//     СпособЗаданияУсловия
//     ВыражениеУсловия
//     НастройкаУсловия
//     НастройкаКомбинацииУсловий
//     Ответственный
//     Комментарий
//
Функция ПолучитьСтруктуруУсловияМаршрутизации() Экспорт
	
	СтруктураУсловияМаршрутизации = Новый Структура;
	СтруктураУсловияМаршрутизации.Вставить("Наименование");
	СтруктураУсловияМаршрутизации.Вставить("ТипОбъекта");
	СтруктураУсловияМаршрутизации.Вставить("СпособЗаданияУсловия");
	СтруктураУсловияМаршрутизации.Вставить("ВыражениеУсловия");
	СтруктураУсловияМаршрутизации.Вставить("НастройкаУсловия");
	СтруктураУсловияМаршрутизации.Вставить("НастройкаКомбинацииУсловий");
	СтруктураУсловияМаршрутизации.Вставить("Ответственный");
	СтруктураУсловияМаршрутизации.Вставить("Комментарий");
	
	Возврат СтруктураУсловияМаршрутизации;
	
КонецФункции

// Создает и запсывает в БД условие маршрутизации
//
// Параметры:
//   СтруктураУсловияМаршрутизации - Структура - структура полей условие маршрутизации.
//
// Возвращаемое значение:
//   СправочникСсылка.УсловияМаршрутизации
//
Функция СоздатьУсловиеМаршрутизации(СтруктураУсловияМаршрутизации) Экспорт
	
	НовоеУсловиеМаршрутизации = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовоеУсловиеМаршрутизации, СтруктураУсловияМаршрутизации);
	НовоеУсловиеМаршрутизации.Записать();
	
	Возврат НовоеУсловиеМаршрутизации.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли
