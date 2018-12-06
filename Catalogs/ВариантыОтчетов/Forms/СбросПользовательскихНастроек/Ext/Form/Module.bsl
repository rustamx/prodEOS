﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("МассивВариантов") Или ТипЗнч(Параметры.МассивВариантов) <> Тип("Массив") Тогда
		ТекстОшибки = НСтр("ru = 'Не указаны варианты отчетов.'; en = 'Report options are not specified.'");
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьПользовательскиеНастройки(Параметры.МассивВариантов) Тогда
		ТекстОшибки = НСтр("ru = 'Пользовательские настройки выбранных вариантов отчетов (%1 шт) не заданы или уже сброшены.'; en = 'Report options (%1 pcs) custom settings are not set or has already been resetted.'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Формат(Параметры.МассивВариантов.Количество(), "ЧН=0; ЧГ=0"));
		Возврат;
	КонецЕсли;
	
	ИзменяемыеВарианты.ЗагрузитьЗначения(Параметры.МассивВариантов);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСбросить(Команда)
	КоличествоВариантов = ИзменяемыеВарианты.Количество();
	Если КоличествоВариантов = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не указаны варианты отчетов.'; en = 'Report options are not specified.'"));
		Возврат;
	КонецЕсли;
	
	СброситьНастройкиПользователейСервер(ИзменяемыеВарианты);
	Если КоличествоВариантов = 1 Тогда
		СсылкаВарианта = ИзменяемыеВарианты[0].Значение;
		ОповещениеЗаголовок = НСтр("ru = 'Сброшены пользовательские настройки варианта отчета'; en = 'Report option custom settings have been resetted'");
		ОповещениеСсылка    = ПолучитьНавигационнуюСсылку(СсылкаВарианта);
		ОповещениеТекст     = Строка(СсылкаВарианта);
		ПоказатьОповещениеПользователя(ОповещениеЗаголовок, ОповещениеСсылка, ОповещениеТекст);
	Иначе
		ОповещениеТекст = НСтр("ru = 'Сброшены пользовательские настройки
		|вариантов отчетов (%1 шт.).';
		|en = 'Report options (%1 pcs) 
		|custom settings have been resetted.'");
		ОповещениеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОповещениеТекст, Формат(КоличествоВариантов, "ЧН=0; ЧГ=0"));
		ПоказатьОповещениеПользователя(, , ОповещениеТекст);
	КонецЕсли;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервереБезКонтекста
Функция СброситьНастройкиПользователейСервер(Знач ИзменяемыеВарианты)
	НачатьТранзакцию();
	Попытка
		РегистрыСведений.НастройкиВариантовОтчетов.СброситьНастройки(ИзменяемыеВарианты.ВыгрузитьЗначения());
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция ЕстьПользовательскиеНастройки(МассивВариантов)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивВариантов", МассивВариантов);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Поле1
	|ИЗ
	|	РегистрСведений.НастройкиВариантовОтчетов КАК Настройки
	|ГДЕ
	|	Настройки.Вариант В(&МассивВариантов)";
	
	ЕстьПользовательскиеНастройки = НЕ Запрос.Выполнить().Пустой();
	Возврат ЕстьПользовательскиеНастройки;
КонецФункции

#КонецОбласти
