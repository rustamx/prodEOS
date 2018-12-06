﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПроцессыСхемыДляПрерывания = Параметры.ПроцессыСхемыДляПрерывания;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИсключенныеДействия

&НаКлиенте
Процедура ПроцессыСхемыДляПрерыванияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = ПроцессыСхемыДляПрерывания.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ПоказатьЗначение(, СтрокаТаблицы.Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрерватьПроцессы(Команда)
	
	Закрыть(ПричинаПрерывания);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти
