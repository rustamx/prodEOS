﻿//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Ключ.Пустая() Тогда

		Объект.БитДанных = 8;
		Объект.Скорость  = 9600;
		Объект.Порт      = "COM1";

	КонецЕсли;

КонецПроцедуры


