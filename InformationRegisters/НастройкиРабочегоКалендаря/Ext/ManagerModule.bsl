﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает значение настройки для пользователь
Функция ПолучитьНастройку(Пользователь, Настройка) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НастройкиРабочегоКалендаря.Значение
		|ИЗ
		|	РегистрСведений.НастройкиРабочегоКалендаря КАК НастройкиРабочегоКалендаря
		|ГДЕ
		|	НастройкиРабочегоКалендаря.Пользователь = &Пользователь
		|	И НастройкиРабочегоКалендаря.Настройка = &Настройка");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Настройка", Настройка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Значение;
	
КонецФункции

// Устанавливает настройку для пользователь
Функция УстановитьНастройку(Пользователь, Настройка, Значение) Экспорт
	
	ИзмененоЗначение = Ложь;
	
	МенеджерЗаписи = РегистрыСведений.НастройкиРабочегоКалендаря.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.Настройка = Настройка;
	
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Значение <> Значение Тогда
		
		ИзмененоЗначение = Истина;
		
		МенеджерЗаписи.Пользователь = Пользователь;
		МенеджерЗаписи.Настройка = Настройка;
		МенеджерЗаписи.Значение = Значение;
		МенеджерЗаписи.Записать();
		
	КонецЕсли;
	
	Возврат ИзмененоЗначение;
	
КонецФункции

#КонецОбласти

#КонецЕсли
