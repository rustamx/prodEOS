﻿
// Добавляет в историю процесса переданное значение, либо замещает историю переданным значением
Процедура ЗаписатьСобытиеПоПроцессу(БизнесПроцесс, ОписаниеСобытия, Замещать = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ИсторияВыполненияЗадач.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.БизнесПроцесс = БизнесПроцесс;
	МенеджерЗаписи.Прочитать();
	
	МенеджерЗаписи.БизнесПроцесс = БизнесПроцесс;
	
	Если Замещать Или ПустаяСтрока(МенеджерЗаписи.Описание) Тогда
		МенеджерЗаписи.Описание = ОписаниеСобытия;
	Иначе
		МенеджерЗаписи.Описание = ОписаниеСобытия + Символы.ПС + Символы.ПС + МенеджерЗаписи.Описание;
	КонецЕсли;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Возвращает описание истории переданного бизнес-процесса
Функция ИсторияПоБизнесПроцессу(БизнесПроцесс) Экспорт
	
	ИсторияВыполнения = "";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		|	ИсторияВыполненияЗадач.Описание
		|ИЗ
		|	РегистрСведений.ИсторияВыполненияЗадач КАК ИсторияВыполненияЗадач
		|ГДЕ
		|	ИсторияВыполненияЗадач.БизнесПроцесс = &БизнесПроцесс");
		
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ИсторияВыполнения = Выборка.Описание;
	КонецЕсли;
	
	Возврат ИсторияВыполнения;

КонецФункции


