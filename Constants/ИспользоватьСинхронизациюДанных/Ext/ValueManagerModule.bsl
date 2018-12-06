﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если Значение = Истина Тогда
		
		РазделениеВключено = ОбщегоНазначенияПовтИсп.РазделениеВключено();
		Константы.ИспользоватьСинхронизациюДанныхВЛокальномРежиме.Установить(Не РазделениеВключено);
		Константы.ИспользоватьСинхронизациюДанныхВМоделиСервиса.Установить(РазделениеВключено);
		
	Иначе
		
		Константы.ИспользоватьСинхронизациюДанныхВЛокальномРежиме.Установить(Ложь);
		Константы.ИспользоватьСинхронизациюДанныхВМоделиСервиса.Установить(Ложь);
		
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение = Истина Тогда
		ОбменДаннымиСервер.ПриВключенииСинхронизацииДанных(Отказ);
	Иначе
		ОбменДаннымиСервер.ПриОтключенииСинхронизацииДанных(Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли