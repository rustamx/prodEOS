﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТипЗаписиИндекс = 0;
	Если Запись.ТипСобытия = Перечисления.ТипыСобытийПротоколаРаботыСМобильнымКлиентом.Предупреждение Тогда
		ТипЗаписиИндекс = 1;

	ИначеЕсли Запись.ТипСобытия = Перечисления.ТипыСобытийПротоколаРаботыСМобильнымКлиентом.Ошибка Тогда
		ТипЗаписиИндекс = 2;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти
