﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверкаКонтрагентовВключена = ПроверкаКонтрагентов.ПроверкаКонтрагентовВключена();
	
	ПроверкаКонтрагентов.УстановитьВидимостьИЗаголовокПредупрежденияПроТестовыйРежим(
		Элементы.ПредупреждениеПроТестовыйРежимПроверкиКонтрагента);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПроверкаКонтрагентовВызовСервера.ПриВключенииВыключенииПроверки(ПроверкаКонтрагентовВключена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
	Если ПараметрыЗаписи.Свойство("Закрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Закрыть", Истина);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДоступКСервису(Команда)
	
	ПроверкаКонтрагентовКлиент.ПроверитьДоступКСервису();
	
КонецПроцедуры


