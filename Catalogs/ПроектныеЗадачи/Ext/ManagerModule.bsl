﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПлановыеТрудозатратыИсполнителяПроектнойЗадачи(
	ПроектнаяЗадача, 
	Исполнитель) Экспорт
	
	// исполнителей нет
	Если ПроектнаяЗадача.Исполнители.Количество() = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	ТекущаяПроектнаяЗадача = ПроектнаяЗадача;
	Пока ЗначениеЗаполнено(ТекущаяПроектнаяЗадача) Цикл
	
		Для Каждого ИсполнительПроектнойЗадачи Из ТекущаяПроектнаяЗадача.Исполнители Цикл
			
			Если ТипЗнч(ИсполнительПроектнойЗадачи.Исполнитель) = Тип("СправочникСсылка.ПолныеРоли") Тогда
				
				Если Исполнитель = ИсполнительПроектнойЗадачи.Исполнитель Тогда
					
					Возврат ИсполнительПроектнойЗадачи.ТекущийПланТрудозатраты;
					
				КонецЕсли;
				
				ИсполнителиРоли = РегистрыСведений.ИсполнителиЗадач.ИсполнителиРоли(
					ИсполнительПроектнойЗадачи.Исполнитель);
					
				Если ИсполнителиРоли.Найти(Исполнитель)	<> Неопределено Тогда 
					
					Возврат ИсполнительПроектнойЗадачи.ТекущийПланТрудозатраты;
					
				КонецЕсли;
				
			Иначе	
				
				Если Исполнитель = ИсполнительПроектнойЗадачи.Исполнитель Тогда
					Возврат ИсполнительПроектнойЗадачи.ТекущийПланТрудозатраты;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
	
		ТекущаяПроектнаяЗадача = ТекущаяПроектнаяЗадача.Родитель;
	КонецЦикла;
	
	Если ПроектнаяЗадача.Владелец.Руководитель = Исполнитель Тогда 
		Возврат 0;
	КонецЕсли;	
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает имя предмета процесса по умолчанию
//
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат НСтр("ru='Проектная задача'; en = 'Project task'");
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Карточка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Справочник.ПроектныеЗадачи";
	КомандаПечати.Идентификатор = "Карточка";
	КомандаПечати.Представление = НСтр("ru = 'Печать карточки'; en = 'Form printing'");
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Карточка", "Проектная задача", ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),
			,
			"Справочник.ПроектныеЗадачи.ПФ_MXL_Карточка");
			
	КонецЕсли;
		
КонецПроцедуры

Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_КарточкаСообщения";
	
	ЗапросРеквизиты = Новый Запрос;
	ЗапросРеквизиты.Текст = 
		"ВЫБРАТЬ
		|	ПроектныеЗадачи.Ссылка,
		|	ПроектныеЗадачи.Владелец,
		|	ПроектныеЗадачи.Родитель,
		|	ПроектныеЗадачи.КодСДР,
		|	ПроектныеЗадачи.Предмет,
		|	СрокиПроектныхЗадач.ТекущийПланНачало,
		|	СрокиПроектныхЗадач.ТекущийПланОкончание,
		|	СрокиПроектныхЗадач.ТекущийПланДлительность,
		|	СрокиПроектныхЗадач.ТекущийПланЕдиницаДлительности,
		|	СрокиПроектныхЗадач.НачалоФакт,
		|	СрокиПроектныхЗадач.ОкончаниеФакт,
		|	СрокиПроектныхЗадач.ДлительностьФакт,
		|	СрокиПроектныхЗадач.ЕдиницаДлительностиФакт,
		|	ПроектныеЗадачи.Веха,
		|	ПроектныеЗадачи.Наименование,
		|	ПроектныеЗадачи.Описание
		|ИЗ
		|	Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиПроектныхЗадач КАК СрокиПроектныхЗадач
		|		ПО ПроектныеЗадачи.Ссылка = СрокиПроектныхЗадач.ПроектнаяЗадача
		|ГДЕ
		|	ПроектныеЗадачи.Ссылка В(&МассивОбъектов)";
	ЗапросРеквизиты.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаЗадачи = ЗапросРеквизиты.Выполнить().Выбрать();
	
	ЗапросИсполнители = Новый Запрос;
	ЗапросИсполнители.Текст = 
		"ВЫБРАТЬ
		|	ПроектныеЗадачиИсполнители.Ссылка,
		|	ПроектныеЗадачиИсполнители.Исполнитель,
		|	ПроектныеЗадачиИсполнители.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Справочник.ПроектныеЗадачи.Исполнители КАК ПроектныеЗадачиИсполнители
		|ГДЕ
		|	ПроектныеЗадачиИсполнители.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	ЗапросИсполнители.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаИсполнители = ЗапросИсполнители.Выполнить().Выбрать();
	
	ЗапросПредшественники = Новый Запрос;
	ЗапросПредшественники.Текст = 
		"ВЫБРАТЬ
		|	ПроектныеЗадачиПредшественники.Ссылка,
		|	ПроектныеЗадачиПредшественники.НомерСтроки КАК НомерСтроки,
		|	ПроектныеЗадачиПредшественники.Предшественник,
		|	ПроектныеЗадачиПредшественники.Задержка,
		|	ПроектныеЗадачиПредшественники.ТипЗависимости,
		|	ПроектныеЗадачиПредшественники.ЕдиницаЗадержки,
		|	ПроектныеЗадачиПредшественники.Предшественник.КодСДР КАК КодСДР
		|ИЗ
		|	Справочник.ПроектныеЗадачи.Предшественники КАК ПроектныеЗадачиПредшественники
		|ГДЕ
		|	ПроектныеЗадачиПредшественники.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	ЗапросПредшественники.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаПредшественники = ЗапросПредшественники.Выполнить().Выбрать();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ПроектныеЗадачи.ПФ_MXL_Карточка");
	ПервыйДокумент = Истина;
	
	Пока ВыборкаЗадачи.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;		
		
		ОбластьШапка = Макет.ПолучитьОбласть("ПроектнаяЗадачаШапка");
		ОбластьШапка.Параметры.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (Проектная задача)'; en = '%1 (Project task)'"),
			ВыборкаЗадачи.Наименование);
		Если ВыборкаЗадачи.Веха Тогда
			ОбластьШапка.Параметры.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (ПроектнаяЗадача), Веха'; en = '%1 (Project task), Milestone'"),
				ВыборкаЗадачи.Наименование);
		КонецЕсли;
		ОбластьШапка.Параметры.Описание = ВыборкаЗадачи.Описание;
		ОбластьШапка.Параметры.КодСДР = ВыборкаЗадачи.КодСДР;
		ОбластьШапка.Параметры.Проект = Строка(ВыборкаЗадачи.Владелец);
		ОбластьШапка.Параметры.ВышестоящаяЗадача = Строка(ВыборкаЗадачи.Родитель);
		ОбластьШапка.Параметры.Предмет = Строка(ВыборкаЗадачи.Предмет);
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ОбластьПлан = Макет.ПолучитьОбласть("ПроектнаяЗадачаПлан");
		ОбластьПлан.Параметры.НачалоПлан = ВыборкаЗадачи.ТекущийПланНачало;
		ОбластьПлан.Параметры.ДлительностьПлан = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"%1 %2",
			ВыборкаЗадачи.ТекущийПланДлительность,
			ВыборкаЗадачи.ТекущийПланЕдиницаДлительности);
		ОбластьПлан.Параметры.ОкончаниеПлан = ВыборкаЗадачи.ТекущийПланОкончание;
		ТабличныйДокумент.Вывести(ОбластьПлан);
		
		ОбластьФакт = Макет.ПолучитьОбласть("ПроектнаяЗадачаФакт");
		ОбластьФакт.Параметры.НачалоФакт = ВыборкаЗадачи.НачалоФакт;
		ОбластьФакт.Параметры.ДлительностьФакт = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"%1 %2",
			ВыборкаЗадачи.ДлительностьФакт,
			ВыборкаЗадачи.ЕдиницаДлительностиФакт);
		ОбластьФакт.Параметры.ОкончаниеФакт = ВыборкаЗадачи.ОкончаниеФакт;
		ТабличныйДокумент.Вывести(ОбластьФакт);
		
		ПервоеПолучениеИсполнителя = Истина;
		ВыборкаИсполнители.Сбросить();
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаЗадачи.Ссылка);
		Пока ВыборкаИсполнители.НайтиСледующий(СтруктураПоиска) Цикл
			Если ПервоеПолучениеИсполнителя Тогда
				ПервоеПолучениеИсполнителя = Ложь;
				ОбластьИсполнителиШапка = Макет.ПолучитьОбласть("ПроектнаяЗадачаИсполнителиШапка");
				ТабличныйДокумент.Вывести(ОбластьИсполнителиШапка);
			КонецЕсли;
			
			ОбластьИсполнителиСтрока = Макет.ПолучитьОбласть("ПроектнаяИсполнителиСтрока");
			
			ОбластьИсполнителиСтрока.Параметры.Исполнитель = ВыборкаИсполнители.Исполнитель;
			
			ТабличныйДокумент.Вывести(ОбластьИсполнителиСтрока);
		КонецЦикла;
		
		ПервоеПолучениеПредшественника = Истина;
		ВыборкаПредшественники.Сбросить();
		Пока ВыборкаПредшественники.НайтиСледующий(СтруктураПоиска) Цикл
			Если ПервоеПолучениеПредшественника Тогда
				ПервоеПолучениеПредшественника = Ложь;
				ОбластьПредшественникШапка = Макет.ПолучитьОбласть("ПредшественникиШапка");
				ТабличныйДокумент.Вывести(ОбластьПредшественникШапка);
			КонецЕсли;
			
			ОбластьПредшественник = Макет.ПолучитьОбласть("ПредшественникиСтрока");
			ОбластьПредшественник.Параметры.Номер = ВыборкаПредшественники.НомерСтроки;
			ОбластьПредшественник.Параметры.Предшественник = ВыборкаПредшественники.Предшественник;
			ОбластьПредшественник.Параметры.КодСДР = ВыборкаПредшественники.КодСДР;
			ОбластьПредшественник.Параметры.ТипЗависимости = ВыборкаПредшественники.ТипЗависимости;
			ОбластьПредшественник.Параметры.Задержка = 
				Строка(ВыборкаПредшественники.Задержка) + " " + Строка(ВыборкаПредшественники.ЕдиницаЗадержки);
				
			ТабличныйДокумент.Вывести(ОбластьПредшественник);
		КонецЦикла;
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаЗадачи.Ссылка);
	КонецЦикла;		

	Возврат ТабличныйДокумент;
	
КонецФункции

// ВерсионированиеОбъектов
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры


// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
КонецПроцедуры

#КонецЕсли
