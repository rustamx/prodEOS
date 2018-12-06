﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Параметры.ТекстПредложения) Тогда
		Элементы.ДекорацияПояснение.Заголовок = Параметры.ТекстПредложения
			+ Символы.ПС
			+ НСтр("ru = 'Установить?'; en = 'Install?'");
		
	ИначеЕсли Не Параметры.ВозможноПродолжениеБезУстановки Тогда
		Элементы.ДекорацияПояснение.Заголовок =
			НСтр("ru = 'Для выполнения действия требуется установить расширение для веб-клиента 1С:Предприятие.
			           |Установить?';
			           |en = 'To perform the action you want to install the Web client extension for 1 c: enterprise.
			           |Install?'");
	КонецЕсли;
	
	Если Не Параметры.ВозможноПродолжениеБезУстановки Тогда
		Элементы.ПродолжитьБезУстановки.Заголовок = НСтр("ru = 'Отмена'; en = 'Cancel'");
		Элементы.БольшеНеНапоминать.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьИПродолжить(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИПродолжитьЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБезУстановки(Команда)
	Закрыть("ПродолжитьБезУстановки");
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеНапоминать(Команда)
	Закрыть("БольшеНеПредлагать");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьИПродолжитьЗавершение(ДополнительныеПараметры) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИПродолжитьПослеПодключенияРасширения", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИПродолжитьПослеПодключенияРасширения(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		Результат = "РасширениеПодключено";
	Иначе
		Результат = "ПродолжитьБезУстановки";
	КонецЕсли;
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
