﻿
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.Объект = Неопределено Тогда 
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Объект"));
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры


