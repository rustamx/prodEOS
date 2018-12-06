﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокТипов = ПолучитьТипыОбъекта();
	
	ЗаполнитьСписокСобытий();
	
	Элементы.ВидИнтерактивногоСобытия.Доступность = Запись.ИнтерактивныйЗапуск;
	Элементы.ГруппаНастройкиАвтостарта.Видимость = ЗначениеЗаполнено(Запись.ВидДокумента);
	
	Если Параметры.Ключ.Пустой() Тогда 
		Если ЗначениеЗаполнено(Запись.ВидДокумента) И Не ЗначениеЗаполнено(Запись.ШаблонБизнесПроцесса) Тогда 
			Элементы.ВидДокумента.ТолькоПросмотр = Истина;
			Элементы.ШаблонБизнесПроцесса.АктивизироватьПоУмолчанию = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.ШаблонБизнесПроцесса) И Не ЗначениеЗаполнено(Запись.ВидДокумента) Тогда 
			Элементы.ШаблонБизнесПроцесса.ТолькоПросмотр = Истина;
			Элементы.ВидДокумента.АктивизироватьПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;	
	Элементы.ГруппаАвтостарт.Заголовок = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьЗаголовокЗакладкиАвтоСтарта();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.СобытияАвтоСтарта = "";
	
	Для Каждого СтрокаТаблицы Из ВидыБизнесСобытий Цикл
		Если Не СтрокаТаблицы.Пометка Тогда
			Продолжить;
		КонецЕсли;
		Если ПустаяСтрока(ТекущийОбъект.СобытияАвтоСтарта) Тогда
			ТекущийОбъект.СобытияАвтоСтарта = СтрокаТаблицы.Представление;
		Иначе
			ТекущийОбъект.СобытияАвтоСтарта = ТекущийОбъект.СобытияАвтоСтарта + ", " + СтрокаТаблицы.Представление;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//  делается запись в регистр ПодпискиАвтоматическогоЗапускаБизнесПроцессов.
		
	Для Каждого Строка Из ВсеВидыБизнесСобытий Цикл
		
		Если ЗначениеЗаполнено(ВидДокументаПриОткрытии) И ЗначениеЗаполнено(ШаблонБизнесПроцессаПриОткрытии) Тогда
			БизнесСобытияВызовСервера.УдалитьПравилоАвтоматическогоЗапускаБизнесПроцессов(
				Строка.Значение, ШаблонБизнесПроцессаПриОткрытии, ВидДокументаПриОткрытии, ОрганизацияПриОткрытии);
		КонецЕсли;	
		
		БизнесСобытияВызовСервера.УдалитьПравилоАвтоматическогоЗапускаБизнесПроцессов(
			Строка.Значение, Запись.ШаблонБизнесПроцесса, Запись.ВидДокумента, Запись.Организация);
			
		Отбор = Новый Структура("Значение", Строка.Значение);
		МассивСтрок = ВидыБизнесСобытий.НайтиСтроки(Отбор);
		Если МассивСтрок.Количество() = 1 Тогда
			
			Если МассивСтрок[0].Пометка Тогда
				БизнесСобытияВызовСервера.СохранитьПравилоАвтоматическогоЗапускаБизнесПроцессов(
					Строка.Значение, Запись.ШаблонБизнесПроцесса, Запись.ВидДокумента, МассивСтрок[0].Условие, 
					Запись.Организация);
				Продолжить;
			КонецЕсли;	
			
		КонецЕсли;
			
	КонецЦикла;
		
	ЗаполнитьСписокСобытий();	
	
	ТекстПредупреждения = "";
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	Если ИспользоватьУчетПоОрганизациям Тогда
		
		Для Каждого Строка Из ВидыБизнесСобытий Цикл
			
			ВидСобытия = Строка.Значение;
			
			НастройкиДляПустойОрганизации = ПолучитьНастройкиАвтозапускаПроцессов(Истина, ВидСобытия);
			НастройкиДляНеПустойОрганизации = ПолучитьНастройкиАвтозапускаПроцессов(Ложь, ВидСобытия);
			
			Если НастройкиДляПустойОрганизации.Количество() <> 0 
				И НастройкиДляНеПустойОрганизации.Количество() <> 0 Тогда
				
				Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
					ТекстПредупреждения = ТекстПредупреждения + Символы.ПС;
				КонецЕсли;
				
				СтрокаПолей = "";
				МассивОрганизаций = НастройкиДляНеПустойОрганизации.ВыгрузитьКолонку("ОрганизацияИсточникаБизнесСобытия");
				Для Каждого Организация Из МассивОрганизаций Цикл
					Если ЗначениеЗаполнено(СтрокаПолей) Тогда
						СтрокаПолей = СтрокаПолей + "; ";
					КонецЕсли;
					СтрокаПолей = СтрокаПолей + Строка(Организация);
				КонецЦикла;	

				Если НастройкиДляНеПустойОрганизации.Количество() = 1 Тогда
					ТекстПредупреждения = ТекстПредупреждения 
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Автозапуск процессов уже настроен для всех организаций. 
							|Настройка для конкретной организации (""%1"") при этом недействительна. 
							|Проверьте настройки еще раз.';
							|en = 'Process autostart is already configured for all companies. 
							|Settings for one company (""%1"") are not valid. 
							|Check the settings again.'"),
							СтрокаПолей);
				Иначе
					ТекстПредупреждения = ТекстПредупреждения 
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Автозапуск процессов уже настроен для всех организаций. 
							|Настройка для конкретных организаций (""%1"") при этом недействительна. 
							|Проверьте настройки еще раз.';
							|en = 'Process autostart is already configured for all companies. 
							|Settings for some companies (""%1"") are not valid. 
							|Check the settings again.'"),
							СтрокаПолей);
				КонецЕсли;	
				
			КонецЕсли;	
			
		КонецЦикла;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		ТекстПредупреждения = "";
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ШаблонБизнесПроцессаПриОткрытии = ТекущийОбъект.ШаблонБизнесПроцесса;
	ОрганизацияПриОткрытии = ТекущийОбъект.Организация;
	ВидДокументаПриОткрытии = ТекущийОбъект.ВидДокумента;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Запись.ИнтерактивныйЗапуск И Не ЗначениеЗаполнено(Запись.ВидИнтерактивногоСобытия) Тогда	
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Действие""!'; en = 'Fiels ""Action"" is not filled in!'"),,
			"Запись.ВидИнтерактивногоСобытия",, 
			Отказ);
		
	КонецЕсли;	
	
	ЕстьПомеченные = Ложь;
	Для Каждого Строка Из ВидыБизнесСобытий Цикл
		
		Если Строка.Пометка Тогда
			ЕстьПомеченные = Истина;
			Прервать;
		КонецЕсли;	
		
	КонецЦикла;
	
	Если ЕстьПомеченные И ЗначениеЗаполнено(Запись.ШаблонБизнесПроцесса) Тогда
		
		ДоступностьШаблона = ШаблоныБизнесПроцессов.ДоступностьШаблона(Запись.ШаблонБизнесПроцесса);
		Если Не ДоступностьШаблона.АвтоматическийЗапуск Тогда
			Текст = НСтр("ru = 'Шаблон недоступен для автоматического запуска процессов.
				|Выполните проверку в карточке шаблона.';
				|en = 'The template cannot be used to start processes automatically.
				|Perform validation from the template form.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,,
				"Запись.ШаблонБизнесПроцесса");
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Запись.ШаблонБизнесПроцесса) И ЗначениеЗаполнено(Запись.ВидДокумента) Тогда
		Если Не ПроверитьСовместимостьШаблонаИВидаДокумента(
				Запись.ШаблонБизнесПроцесса, 
				Запись.ВидДокумента) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Данный предмет не может быть использован в указанном процессе.'; en = 'The specified subject cannot be used in the specified process.'"),,
				"Запись.ВидДокумента",, 
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	ЗаполнитьСписокСобытий();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокТиповДокументов = Новый СписокЗначений;
	СписокТиповДокументов.Добавить("ВидыВнутреннихДокументов", НСТр("ru = 'Вид внутреннего документа'; en = 'Internal document type'"));
	СписокТиповДокументов.Добавить("ВидыВходящихДокументов", НСТр("ru = 'Вид входящего документа'; en = 'Incoming document type'"));
	СписокТиповДокументов.Добавить("ВидыИсходящихДокументов", НСТр("ru = 'Вид исходящего документа'; en = 'Outgoing document type'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВидДокументаНачалоВыбораПродолжение",
		ЭтотОбъект,
		Новый Структура("Элемент", Элемент));
			
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТиповДокументов, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаНачалоВыбораПродолжение(ВыбранныйТип, Параметры) Экспорт 

	Если ВыбранныйТип <> Неопределено Тогда 
		
		ПараметрыОткрытияФормы = Новый Структура("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
		ОткрытьФорму("Справочник." + ВыбранныйТип.Значение + ".ФормаВыбора", ПараметрыОткрытияФормы, Параметры.Элемент);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ШаблонБизнесПроцессаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ШаблонБизнесПроцессаНачалоВыбораПродолжение",
		ЭтотОбъект,
		Новый Структура("Элемент", Элемент));
			
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонБизнесПроцессаНачалоВыбораПродолжение(ВыбранныйТип, Параметры) Экспорт 

	Если ВыбранныйТип <> Неопределено Тогда 
		ОткрытьФорму("Справочник." + ВыбранныйТип.Значение + ".ФормаВыбора", , Параметры.Элемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПредлагатьЗапускПользователюПриИзменении(Элемент)
	
	Элементы.ВидИнтерактивногоСобытия.Доступность = Запись.ИнтерактивныйЗапуск;
	Если Запись.ИнтерактивныйЗапуск Тогда 
		Если Не ЗначениеЗаполнено(Запись.ВидИнтерактивногоСобытия) Тогда 
			СписокВыбора = Элементы.ВидИнтерактивногоСобытия.СписокВыбора;
			Если СписокВыбора.Количество() > 0 Тогда 
				Запись.ВидИнтерактивногоСобытия = СписокВыбора[0].Значение;
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыБизнесСобытийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не Элементы.ВидыБизнесСобытий.ТекущиеДанные.Пометка Тогда
		Возврат;
	КонецЕсли;	
	
	Если Поле = Элементы.ВидыБизнесСобытийУсловие Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборУсловияМаршрутизации", ЭтотОбъект);
			
		ОткрытьФорму("Справочник.УсловияМаршрутизации.ФормаВыбора", , Элементы.ВидыБизнесСобытийУсловие,,,,
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
		Возврат;
		
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ВидыБизнесСобытийВыборПродолжение(Результат, Параметры) Экспорт  
	
	ЗаполнитьСписокСобытий();

КонецПроцедуры

&НаКлиенте
Процедура ВыборУсловияМаршрутизации(Результат, Параметры) Экспорт  
	
	Если ЗначениеЗаполнено(Результат) Тогда 
		Элементы.ВидыБизнесСобытий.ТекущиеДанные.Условие = Результат;
		Модифицированность = Истина;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ВидыБизнесСобытийПометкаПриИзменении(Элемент)
	
	УстановитьЗаголовокЗакладкиАвтоСтарта();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьТипыОбъекта()
	
	СписокТипов = Новый СписокЗначений;
	ТипыОбъекта = Метаданные.РегистрыСведений.НастройкаШаблоновБизнесПроцессов.Измерения.ШаблонБизнесПроцесса.Тип.Типы();
	
	Для Каждого ТипОбъекта Из ТипыОбъекта Цикл
		ОбъектСсылка = Новый(ТипОбъекта);
 		СписокТипов.Добавить(ОбъектСсылка.Метаданные().Имя, ОбъектСсылка.Метаданные().Синоним);
	КонецЦикла;	
	СписокТипов.СортироватьПоПредставлению();
	
	Возврат СписокТипов;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокСобытий()
	
	// заполним интерактивные события
	Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Очистить();
	Если ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданногоВнутреннегоДокумента);
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ИнтерактивнаяРегистрацияВнутреннегоДокумента);
	ИначеЕсли ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданногоВходящегоДокумента);
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ИнтерактивнаяРегистрацияВходящегоДокумента);
	ИначеЕсли ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданногоИсходящегоДокумента);
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ИнтерактивнаяРегистрацияИсходящегоДокумента);
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ШаблонБизнесПроцесса КАК ШаблонБизнесПроцесса,
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ВидБизнесСобытия КАК ВидБизнесСобытия,
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.Условие
		|ИЗ
		|	РегистрСведений.ПравилаАвтоматическогоЗапускаБизнесПроцессов КАК ПравилаАвтоматическогоЗапускаБизнесПроцессов
		|ГДЕ
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ШаблонБизнесПроцесса = &ШаблонБизнесПроцесса
		|	И (ПравилаАвтоматическогоЗапускаБизнесПроцессов.ОрганизацияИсточникаБизнесСобытия = &Организация
		|			ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
		|	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.КлассИсточникаБизнесСобытия = &КлассИсточникаБизнесСобытия";
				
	Запрос.УстановитьПараметр("ШаблонБизнесПроцесса", Запись.ШаблонБизнесПроцесса);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Запрос.УстановитьПараметр("Организация", Запись.Организация);
	Иначе
		Запрос.УстановитьПараметр("Организация", Неопределено);
	КонецЕсли;
	Запрос.УстановитьПараметр("КлассИсточникаБизнесСобытия", Запись.ВидДокумента);
	
	Таблица = Запрос.Выполнить().Выгрузить();	
	
	Выборка = Справочники.ВидыБизнесСобытий.Выбрать();
	
	ВидыБизнесСобытий.Очистить();
	ВсеВидыБизнесСобытий.Очистить();
	Пока Выборка.Следующий() Цикл
		
		Если Не Выборка.ЭтоГруппа Тогда
			
			ВсеВидыБизнесСобытий.Добавить(Выборка.Ссылка);
			
			ВидСобытияИмя = Выборка.Ссылка.Наименование;
			НужноДобавить = Ложь;
			
			Если ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
			 
			Если Выборка.Ссылка = Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.РегистрацияВнутреннегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ПеререгистрацияВнутреннегоДокумента Тогда
				НужноДобавить = Истина;
			КонецЕсли;	
			 
			ИначеЕсли ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда
			 
			Если Выборка.Ссылка = Справочники.ВидыБизнесСобытий.СозданиеВходящегоДокумента Тогда
				НужноДобавить = Истина;
			ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ИзменениеВходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.РегистрацияВходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ПеререгистрацияВходящегоДокумента Тогда
				НужноДобавить = Истина;
			 КонецЕсли;	
			 
			ИначеЕсли ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
			 
			Если Выборка.Ссылка = Справочники.ВидыБизнесСобытий.СозданиеИсходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ИзменениеИсходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.РегистрацияИсходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ПеререгистрацияИсходящегоДокумента Тогда
				НужноДобавить = Истина;
			 КонецЕсли;	
	 	 	  
			КонецЕсли;	
			
			Если НужноДобавить Тогда
				Строка = ВидыБизнесСобытий.Добавить();
				Строка.Значение = Выборка.Ссылка;
				Строка.Представление = Выборка.Наименование;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;		
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		
		Отбор = Новый Структура("Значение", СтрокаТаблицы.ВидБизнесСобытия);
		МассивСтрок = ВидыБизнесСобытий.НайтиСтроки(Отбор);
		Если МассивСтрок.Количество() = 1 Тогда
			МассивСтрок[0].Пометка = Истина;
			МассивСтрок[0].Загружено = Истина;
			МассивСтрок[0].Условие = СтрокаТаблицы.Условие;
		КонецЕсли;
	
	КонецЦикла;	
	
	Элементы.ГруппаНастройкиАвтостарта.Видимость = ЗначениеЗаполнено(Запись.ВидДокумента);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиАвтозапускаПроцессов(ТолькоДляПустойОрганизации, ВидСобытия)
	
	Запрос = Новый Запрос;
	
	// в запросе объединяем данные для конкретной и для пустой организации
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ОрганизацияИсточникаБизнесСобытия КАК ОрганизацияИсточникаБизнесСобытия
		|ИЗ
		|	РегистрСведений.ПравилаАвтоматическогоЗапускаБизнесПроцессов КАК ПравилаАвтоматическогоЗапускаБизнесПроцессов
		|ГДЕ
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ВидБизнесСобытия = &ВидБизнесСобытия
		|	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.ШаблонБизнесПроцесса = &ШаблонБизнесПроцесса
		|	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.КлассИсточникаБизнесСобытия = &КлассИсточникаБизнесСобытия";
		
	Если ТолькоДляПустойОрганизации = Истина Тогда
		Запрос.Текст = Запрос.Текст + 
			"	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.ОрганизацияИсточникаБизнесСобытия = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
	Иначе		
		Запрос.Текст = Запрос.Текст + 
			"	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.ОрганизацияИсточникаБизнесСобытия <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
	КонецЕсли;	
		
	Запрос.УстановитьПараметр("ВидБизнесСобытия", ВидСобытия);
	Запрос.УстановитьПараметр("ШаблонБизнесПроцесса", Запись.ШаблонБизнесПроцесса);
	Запрос.УстановитьПараметр("КлассИсточникаБизнесСобытия", Запись.ВидДокумента);
	
	РезультатЗапроса = Запрос.Выполнить();
	Таблица = РезультатЗапроса.Выгрузить();
	Возврат Таблица;
	
КонецФункции	

&НаСервереБезКонтекста
Функция ПроверитьСовместимостьШаблонаИВидаДокумента(Шаблон, ВидДокумента)
	
	МенеджерШаблонаПроцесса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Шаблон);
	ИмяПроцесса = МенеджерШаблонаПроцесса.ИмяПроцесса(Шаблон);
	МетаданныеПроцесса = Метаданные.БизнесПроцессы.Найти(ИмяПроцесса);	
	Если ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
		Возврат ПроцессМожетСоздаватьсяПоПредмету(МетаданныеПроцесса, Метаданные.Справочники.ВнутренниеДокументы);
	ИначеЕсли ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда
		Возврат ПроцессМожетСоздаватьсяПоПредмету(МетаданныеПроцесса, Метаданные.Справочники.ВходящиеДокументы);
	ИначеЕсли ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		Возврат ПроцессМожетСоздаватьсяПоПредмету(МетаданныеПроцесса, Метаданные.Справочники.ИсходящиеДокументы);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроцессМожетСоздаватьсяПоПредмету(МетаданныеПроцесса, МетаданныеДокумента)
	
	Для Каждого ЭлементМетаданных Из МетаданныеПроцесса.ВводитсяНаОсновании Цикл
		Если ЭлементМетаданных = МетаданныеДокумента Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура УстановитьЗаголовокЗакладкиАвтоСтарта()
	
	ГруппаАвтостартЗаголовок = НСтр("ru = 'Автоматический запуск'; en = 'Automatic start'");
	Количество = 0;
	Для Каждого СтрокаТаблицы Из ВидыБизнесСобытий Цикл
		Если СтрокаТаблицы.Пометка Тогда
			Количество = Количество + 1;
		КонецЕсли;
	КонецЦикла;
	Если Количество > 0 Тогда
		ГруппаАвтостартЗаголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Автоматический запуск (%1)'; en = 'Automatic start (%1)'"),
				Строка(Количество));	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
