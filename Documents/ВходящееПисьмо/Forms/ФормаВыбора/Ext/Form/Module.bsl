﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", 
		ПользователиКлиентСервер.ТекущийПользователь());
		
	Список.Параметры.УстановитьЗначениеПараметра("ОтображатьУдаленные", ОтображатьУдаленные);
	Элементы.ФормаОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Настройки["ОтображатьУдаленные"]) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОтображатьУдаленные", ОтображатьУдаленные);
		Элементы.ФормаОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленные(Команда)
	
	ОтображатьУдаленные = Не ОтображатьУдаленные;
	Список.Параметры.УстановитьЗначениеПараметра("ОтображатьУдаленные", ОтображатьУдаленные);
	
КонецПроцедуры


