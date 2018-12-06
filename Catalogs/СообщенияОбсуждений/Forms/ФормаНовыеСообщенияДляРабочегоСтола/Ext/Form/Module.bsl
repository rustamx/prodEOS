﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Список.Параметры.УстановитьЗначениеПараметра(
		"Пользователь",
		ПользователиКлиентСервер.ТекущийПользователь());
	
	Если ОбщегоНазначенияДокументооборот.ПриложениеЯвляетсяВебКлиентом() Тогда
		Элементы.СписокКонтекстноеМенюАвтообновление.Видимость = Ложь;
	Иначе
		Автообновление.ЗагрузитьНастройкиАвтообновленияСписка(ЭтаФорма, "Список");
		Элементы.СписокКонтекстноеМенюАвтообновление.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если РаботаСПрочтениямиКлиент.ПроверитьНеобходимостьОбновления(
			ИмяСобытия, Параметр, "Обсуждения") Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Автообновление(Команда)
	
	АвтообновлениеКлиент.УстановитьПараметрыАвтообновленияСписка(ЭтаФорма, "Список");
	
КонецПроцедуры

#КонецОбласти
