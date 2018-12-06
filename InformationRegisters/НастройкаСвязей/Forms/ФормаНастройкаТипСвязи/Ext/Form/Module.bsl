﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"ТипСвязи",
			Параметры.ТипСвязи);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные.Предопределенная Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя удалить предопределенную настройку связей!'; en = 'You cannot delete a predefined relationship settings!'"));
		Возврат;
	КонецЕсли;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СписокПередУдалениемПродолжение",
		ЭтотОбъект,
		Новый Структура("ТекущаяСтрока", ТекущаяСтрока));
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Удалить запись?'; en = 'Delete relation?'"), 
		РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалениемПродолжение(Результат, Параметры)Экспорт 

	Если Результат = КодВозвратаДиалога.Да Тогда 
		УдалитьЗаписи(Параметры.ТекущаяСтрока);
		Элементы.Список.Обновить();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере 
Процедура УдалитьЗаписи(ТекущаяСтрока)
	
	МенеджерЗаписи = РегистрыСведений.НастройкаСвязей.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ТипСвязи = ТекущаяСтрока.ТипСвязи;
	МенеджерЗаписи.СсылкаИз = ТекущаяСтрока.СсылкаИз;
	МенеджерЗаписи.СсылкаНа = ТекущаяСтрока.СсылкаНа;
	МенеджерЗаписи.Прочитать();
	
	Если ЗначениеЗаполнено(МенеджерЗаписи.ТипОбратнойСвязи) Тогда 
		МенеджерОбратнойЗаписи = РегистрыСведений.НастройкаСвязей.СоздатьМенеджерЗаписи();
		МенеджерОбратнойЗаписи.ТипСвязи = МенеджерЗаписи.ТипОбратнойСвязи;
		МенеджерОбратнойЗаписи.СсылкаИз = МенеджерЗаписи.СсылкаНа;
		МенеджерОбратнойЗаписи.СсылкаНа = МенеджерЗаписи.СсылкаИз;
		МенеджерОбратнойЗаписи.Удалить();
	КонецЕсли;	
	МенеджерЗаписи.Удалить();
	
КонецПроцедуры


