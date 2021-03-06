﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "СклоненияПредставленийОбъектов".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Склоняет переданную фразу по всем падежам.
//
// Параметры:
//  Форма 			- Управляемая форма - форма объекта склонения.
//  Представление   - Строка - Строка для склонения.
//  ЭтоФИО       	- Булево - Признак склонения ФИО.
//	Пол				- Число	- Пол физического лица (в случае склонения ФИО)
//							1 - мужской 
//							2 - женский.
//  ПоказыватьСообщения - Булево - Признак, определяющий нужно ли показывать пользователю сообщения об ошибках.
//
Процедура ПросклонятьПредставлениеПоВсемПадежам(Представление, Склонения, ЭтоФИО = Ложь, Пол = Неопределено, ПоказыватьСообщения = Ложь) Экспорт
	
	СтруктураСклонений = СклонениеПредставленийОбъектов.ПросклонятьПредставлениеПоВсемПадежам(Представление, ЭтоФИО, Пол, ПоказыватьСообщения);		
	Склонения = Новый ФиксированнаяСтруктура(СтруктураСклонений);

КонецПроцедуры

#КонецОбласти
