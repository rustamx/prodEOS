﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Полнотекстовый поиск".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Изменяет дерево с разделами полнотекстового поиска.
//
// Параметры:
//   ДеревоРазделов   - ДеревоЗначений, содержащие области поиска. Колонки:
//     Раздел - Строка - Представление раздела: подсистемы или объекта метаданных.
//     Пометка - Булево, флаг выбора объекта пользователем. Если установить флаг в значение
//       Истина, то раздел по умолчанию будет отмечен в настройках.
//     ЭтоОбъектМетаданных - Булево. Устанавливается в значение Истина, если это дочерний узел дерева,
//       который не является подсистемой.
//     ПутьКДанным - Строка - Предназначена для определения точного адреса строки в дереве.
//     ОбъектМД - СправочникСсылка.ИдентификаторыОбъектовМетаданных. Задается только для объектов метаданных,
//       для подсистем остается пустым.
//   Пример:
//     НоваяОбластьПоиска = ДеревоРазделов.Строки.Добавить();
//     НоваяОбластьПоиска.Раздел = "МояОбластьПоиска";
//
//     МетаданныеПодраздела = НоваяОбластьПоиска.Строки.Добавить();
//     МетаданныеПодраздела.Раздел = "Валюты";
//     МетаданныеПодраздела.ЭтоОбъектМетаданных = Истина;
//     МетаданныеПодраздела.ПутьКДанным = НоваяОбластьПоиска.Раздел + "," + МетаданныеПодраздела.Раздел;
//     МетаданныеПодраздела.ОбъектМД = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Справочники.Валюты);
//
Процедура ПриПолученииРазделовПолнотекстовогоПоиска(ДеревоРазделов) Экспорт
	
КонецПроцедуры

#КонецОбласти


