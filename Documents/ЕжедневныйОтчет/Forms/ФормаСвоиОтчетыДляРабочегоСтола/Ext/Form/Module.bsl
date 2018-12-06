﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователи.ТекущийПользователь());
	
	Список.Параметры.УстановитьЗначениеПараметра("Понедельник", Перечисления.ДниНедели.Понедельник);
	Список.Параметры.УстановитьЗначениеПараметра("Вторник", 	Перечисления.ДниНедели.Вторник);
	Список.Параметры.УстановитьЗначениеПараметра("Среда", 		Перечисления.ДниНедели.Среда);
	Список.Параметры.УстановитьЗначениеПараметра("Четверг", 	Перечисления.ДниНедели.Четверг);
	Список.Параметры.УстановитьЗначениеПараметра("Пятница", 	Перечисления.ДниНедели.Пятница);
	Список.Параметры.УстановитьЗначениеПараметра("Суббота", 	Перечисления.ДниНедели.Суббота);
	Список.Параметры.УстановитьЗначениеПараметра("Воскресенье", Перечисления.ДниНедели.Воскресенье);

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

