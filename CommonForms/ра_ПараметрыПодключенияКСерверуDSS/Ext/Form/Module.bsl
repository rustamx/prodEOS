﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Хранилище = Константы.ра_ПараметрыПодключенияКСерверуDSS.Получить();
	
	Структура = Хранилище.Получить();
	
	ИдентификаторСистемы 			= Структура.ИдентификаторСистемы;
	Хост 							= Структура.Хост;
	ЗапросТокена 					= Структура.ЗапросТокена;
	ЗапросПодписиДокумента 			= Структура.ЗапросПодписиДокумента;
	ЗапросСозданиеТранзакции 		= Структура.ЗапросСозданиеТранзакции;
	ЗапросПодтверждениеТранзакции 	= Структура.ЗапросПодтверждениеТранзакции;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПараметрыПодключенияНаСервере()
	
	Структура = Новый Структура;
	Структура.Вставить("ИдентификаторСистемы", 			ИдентификаторСистемы);
	Структура.Вставить("Хост", 							Хост);
	Структура.Вставить("ЗапросТокена", 					ЗапросТокена);
	Структура.Вставить("ЗапросПодписиДокумента", 		ЗапросПодписиДокумента);
	Структура.Вставить("ЗапросСозданиеТранзакции", 		ЗапросСозданиеТранзакции);
	Структура.Вставить("ЗапросПодтверждениеТранзакции", ЗапросПодтверждениеТранзакции);
		
	Хранилище = Новый ХранилищеЗначения(Структура);
	
	Константы.ра_ПараметрыПодключенияКСерверуDSS.Установить(Хранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьПараметрыПодключения(Команда)
	
	ЗаписатьПараметрыПодключенияНаСервере()
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьПараметрыПодключенияНаСервере();
	Закрыть();
	
КонецПроцедуры
