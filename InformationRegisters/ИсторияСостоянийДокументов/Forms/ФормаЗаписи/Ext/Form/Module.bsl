﻿//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Запись.Установил = Неопределено Тогда 
		Запись.Установил = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;	
	
	Если Не РольДоступна("ПолныеПрава") Тогда 
		Если (ТипЗнч(Запись.Установил) <> Тип("СправочникСсылка.Пользователи"))
		 Или (Запись.Установил <> ПользователиКлиентСервер.ТекущийПользователь()) Тогда 
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
		
		Если Не Константы.РазрешитьРучноеИзменениеСостоянияДокументов.Получить() 
			 И Константы.ИспользоватьБизнесПроцессыИЗадачи.Получить() Тогда 
			ЭтаФорма.ТолькоПросмотр = Истина;
		КонецЕсли;
		
		ЭтаФорма.Элементы.Установил.ТолькоПросмотр = Истина;
		ЭтаФорма.Элементы.Документ.ТолькоПросмотр = Истина;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсторияСостоянийДокументов.Период
		|ИЗ
		|	РегистрСведений.ИсторияСостоянийДокументов.СрезПоследних(, Документ = &Документ) КАК ИсторияСостоянийДокументов";
		Запрос.УстановитьПараметр("Документ", Запись.Документ);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		Если Выборка.Период <> Запись.Период Тогда 
			ЭтаФорма.ТолькоПросмотр = Истина;	
		КонецЕсли;
	КонецЕсли;	
	
	НачальныеЗначения = Новый Структура("Период, Документ, Состояние, Установил");
	Для Каждого Строка Из НачальныеЗначения Цикл
		НачальныеЗначения[Строка.Ключ] = Запись[Строка.Ключ];
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТекущиеСостоянияДокументов.Документ,
	|	ТекущиеСостоянияДокументов.Состояние
	|ИЗ
	|	РегистрСведений.ТекущиеСостоянияДокументов КАК ТекущиеСостоянияДокументов
	|ГДЕ
	|	ТекущиеСостоянияДокументов.Документ = &Документ
	|	И ТекущиеСостоянияДокументов.Состояние = &Состояние
	|	И ТекущиеСостоянияДокументов.Установил = &Установил
	|	И ТекущиеСостоянияДокументов.ДатаУстановки = &Период";
	
	Запрос.УстановитьПараметр("Документ", НачальныеЗначения.Документ);
	Запрос.УстановитьПараметр("Состояние", НачальныеЗначения.Состояние);
	Запрос.УстановитьПараметр("Установил", НачальныеЗначения.Установил);
	Запрос.УстановитьПараметр("Период", НачальныеЗначения.Период);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		МенеджерЗаписи = РегистрыСведений.ТекущиеСостоянияДокументов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Документ = Выборка.Документ;
		МенеджерЗаписи.Состояние = Выборка.Состояние;
		МенеджерЗаписи.Прочитать();
		
		МенеджерЗаписи.Документ = ТекущийОбъект.Документ;
		МенеджерЗаписи.Состояние = ТекущийОбъект.Состояние;
		МенеджерЗаписи.Установил = ТекущийОбъект.Установил;
		МенеджерЗаписи.ДатаУстановки = ТекущийОбъект.Период;
		МенеджерЗаписи.Записать();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	НачальныеЗначения = Новый Структура("Период, Документ, Состояние, Установил");
	Для Каждого Строка Из НачальныеЗначения Цикл
		НачальныеЗначения[Строка.Ключ] = Запись[Строка.Ключ];
	КонецЦикла;
	
	Оповестить("ИзмененаИсторияСостояний", Запись.Документ, ЭтаФорма)
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СостояниеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	// ТСК Талько Э.Г.; 26.07.2018; Статусы {
	Если ра_ОбщегоНазначенияКлиентСервер.ЭтоДокументКачества(Запись.Документ) Тогда
		Возврат;
	КонецЕсли;
	// ТСК Талько Э.Г.; 26.07.2018; Статусы }
	
	РегистрационныйНомер = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
		Запись.Документ, "РегистрационныйНомер");
	
	Если Не ЗначениеЗаполнено(РегистрационныйНомер) И ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.СостоянияДокументов.Зарегистрирован") Тогда 
		СтандартнаяОбработка = Ложь;
		ТекстСообщения = НСтр("ru = 'Состояние ""Зарегистрирован"" не может быть установлено вручную. Воспользуйтесь кнопкой ""Зарегистрировать"".'; en = 'State of ""Registered"" cannot be set manually. Use the ""Register"" button.'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

