﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Очистить(Команда)
	ОчиститьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ОчиститьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегистрыСведений.ра_ПротоколОбменаСБитрикс.СоздатьНаборЗаписей().Записать();
	
КонецПроцедуры

#КонецОбласти
