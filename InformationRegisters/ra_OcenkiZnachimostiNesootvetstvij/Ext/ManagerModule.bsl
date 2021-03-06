﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьОценкуНесоответствия(Несоответствие) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ObemRabot
	|ИЗ
	|	РегистрСведений.ra_OcenkiZnachimostiNesootvetstvij.СрезПоследних( , Nesootvetstvie = &Несоответствие)");
	
	Запрос.УстановитьПараметр("Несоответствие", Несоответствие);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ObemRabot;
	Иначе
		Возврат Перечисления.ra_ObemyRabot.ПустаяСсылка();
	КонецЕсли;
		
КонецФункции
	
#КонецОбласти

#КонецЕсли