﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-процессы и задачи"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Открывает форму выбора исполнителя.
//
// Параметры:
//   ЭлементИсполнитель - элемент формы, в которой выполняется выбора исполнителя, 
//      который будет указан как владелец формы выбора исполнителя
//   РеквизитИсполнитель - выбранное ранее значение исполнителя.
//      Используется для установки текущей строки в форме выбора исполнителя
//   ТолькоПростыеРоли - Булево, если Истина, то указывает что для выбора нужно 
//      использовать только роли без объектов адресации 
//   БезВнешнихРолей	- Булево, если Истина, то указывает, что для выбора надо
//      использовать только роли, у которых не установлен признак ВнешняяРоль
//
Функция ВыбратьИсполнителя(ЭлементИсполнитель, РеквизитИсполнитель, ТолькоПростыеРоли, БезВнешнихРолей) Экспорт
	
	Возврат Ложь;
	
КонецФункции	


