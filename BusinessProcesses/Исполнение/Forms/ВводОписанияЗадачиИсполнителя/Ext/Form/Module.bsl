﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ОписаниеЗадачи") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОписаниеЗадачи = Параметры.ОписаниеЗадачи;
	
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	Закрыть(ОписаниеЗадачи);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры


