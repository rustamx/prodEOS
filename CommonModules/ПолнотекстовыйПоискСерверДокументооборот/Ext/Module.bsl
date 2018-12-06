﻿// Возвращает список наименований стандартных разделов поиска
//
Функция ПолучитьСтандартныеРазделыПоиска() Экспорт
	
	НаименованияСтандартныхРазделов = ПолучитьНаименованияСтандартныхРазделовПоиска();
	Результат = Новый СписокЗначений;
	Для каждого Наименование Из НаименованияСтандартныхРазделов Цикл
		Результат.Добавить(ПолучитьСтандартныйРазделПоискаПоНаименованию(Наименование), Наименование);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает имена стандартных разделов поиска
Функция ПолучитьНаименованияСтандартныхРазделовПоиска() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(НСтр("ru = 'Документы и файлы'; en = 'Documents and files'"));
	Результат.Добавить(НСтр("ru = 'Файлы'; en = 'Files'"));
	Результат.Добавить(НСтр("ru = 'Процессы и задачи'; en = 'Processes and tasks'"));
	Результат.Добавить(НСтр("ru = 'Внутренние документы, без файлов'; en = 'Internal documents, without files'"));
	Результат.Добавить(НСтр("ru = 'Входящие документы, без файлов'; en = 'Incoming documents, without files'"));
	Результат.Добавить(НСтр("ru = 'Исходящие документы, без файлов'; en = 'Outgoing documents, without files'"));
	Результат.Добавить(НСтр("ru = 'Входящие письма, без файлов'; en = 'Incoming emails, without files'"));
	Результат.Добавить(НСтр("ru = 'Исходящие письма, без файлов'; en = 'Outgoing emails, without files'"));
	Результат.Добавить(НСтр("ru = 'Проекты'; en = 'Projects'"));
	Результат.Добавить(НСтр("ru = 'Мероприятия, без файлов'; en = 'Events, without files'"));
	Результат.Добавить(НСтр("ru = 'Форум, без файлов'; en = 'Forum, without files'"));
	Результат.Добавить(НСтр("ru = 'Календарь'; en = 'Calendar'"));
	Результат.Добавить(НСтр("ru = 'Контрагенты и контактные лица'; en = 'Counterparties and contact persons'"));
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак того, что передано наименование стандартного раздела поиска.
//
Функция ЭтоСтандартныйРазделПоиска(Наименование) Экспорт
	
	НаименованияСтандартныхРазделов = ПолучитьНаименованияСтандартныхРазделовПоиска();
	Возврат НаименованияСтандартныхРазделов.Найти(Наименование) <> Неопределено;
	
КонецФункции

// Возвращает массив метаданных для предопределенного раздела поиска
//
Функция ПолучитьСтандартныйРазделПоискаПоНаименованию(Наименование) Экспорт
	
	Результат = Новый Массив;
	Если ВРег(Наименование) = ВРег(НСтр("ru = 'Документы и файлы'; en = 'Documents and files'")) Тогда
		Результат.Добавить("Метаданные.Справочники.ВходящиеДокументы");
		Результат.Добавить("Метаданные.Справочники.ИсходящиеДокументы");
		Результат.Добавить("Метаданные.Справочники.ВнутренниеДокументы");
		Результат.Добавить("Метаданные.Справочники.Файлы");
		Результат.Добавить("Метаданные.Справочники.ВерсииФайлов");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Файлы'; en = 'Files'")) Тогда
		Результат.Добавить("Метаданные.Справочники.Файлы");
		Результат.Добавить("Метаданные.Справочники.ВерсииФайлов");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Процессы и задачи'; en = 'Processes and tasks'")) Тогда
		Результат.Добавить("Метаданные.Задачи.ЗадачаИсполнителя");
		Результат.Добавить("Метаданные.БизнесПроцессы.Исполнение");
		Результат.Добавить("Метаданные.БизнесПроцессы.КомплексныйПроцесс");
		Результат.Добавить("Метаданные.БизнесПроцессы.ОбработкаВнутреннегоДокумента");
		Результат.Добавить("Метаданные.БизнесПроцессы.ОбработкаВходящегоДокумента");
		Результат.Добавить("Метаданные.БизнесПроцессы.ОбработкаИсходящегоДокумента");
		Результат.Добавить("Метаданные.БизнесПроцессы.Ознакомление");
		Результат.Добавить("Метаданные.БизнесПроцессы.Поручение");
		Результат.Добавить("Метаданные.БизнесПроцессы.Рассмотрение");
		Результат.Добавить("Метаданные.БизнесПроцессы.Регистрация");
		Результат.Добавить("Метаданные.БизнесПроцессы.Согласование");
		Результат.Добавить("Метаданные.БизнесПроцессы.Утверждение");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Внутренние документы, без файлов'; en = 'Internal documents, without files'")) Тогда
		Результат.Добавить("Метаданные.Справочники.ВнутренниеДокументы");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Входящие документы, без файлов'; en = 'Incoming documents, without files'")) Тогда
		Результат.Добавить("Метаданные.Справочники.ВходящиеДокументы");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Исходящие документы, без файлов'; en = 'Outgoing documents, without files'")) Тогда
		Результат.Добавить("Метаданные.Справочники.ИсходящиеДокументы");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Входящие письма, без файлов'; en = 'Incoming emails, without files'")) Тогда
		Результат.Добавить("Метаданные.Документы.ВходящееПисьмо");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Исходящие письма, без файлов'; en = 'Outgoing emails, without files'")) Тогда
		Результат.Добавить("Метаданные.Документы.ИсходящееПисьмо");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Проекты'; en = 'Projects'")) Тогда
		Результат.Добавить("Метаданные.Справочники.Проекты");
		Результат.Добавить("Метаданные.Справочники.ПроектныеЗадачи");
	
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Мероприятия, без файлов'; en = 'Events, without files'")) Тогда
		Результат.Добавить("Метаданные.Справочники.Мероприятия");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Форум, без файлов'; en = 'Forum, without files'")) Тогда
		Результат.Добавить("Метаданные.Справочники.ТемыОбсуждений");
		Результат.Добавить("Метаданные.Справочники.СообщенияОбсуждений");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Календарь'; en = 'Calendar'")) Тогда
		Результат.Добавить("Метаданные.Справочники.ЗаписиРабочегоКалендаря");
		
	ИначеЕсли ВРег(Наименование) = ВРег(НСтр("ru = 'Контрагенты и контактные лица'; en = 'Counterparties and contact persons'")) Тогда
		Результат.Добавить("Метаданные.РегистрыСведений.НаименованияКонтрагентов");
		Результат.Добавить("Метаданные.Справочники.КонтактныеЛица");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру настроек поиска по умолчанию
//
Функция ПолучитьНастройкиПоискаПоУмолчанию() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИскатьСочетанияСлов", 0);
	Результат.Вставить("РезультатовНаСтранице", 20);
	Результат.Вставить("ОтображатьТекстовоеОписание", Истина);
	Результат.Вставить("ОтображатьДополнительнуюИнформацию", Истина);
	Результат.Вставить("ВыделятьСловаЦветом", Ложь);
	Результат.Вставить("ИскатьСловаСОшибками", Ложь);
	Результат.Вставить("ПорогНечеткости", 20);
	Результат.Вставить("РазделыПоиска", ПолучитьСтандартныеРазделыПоиска());
	
	Возврат Результат;
	
КонецФункции

// Возвращает строку с дополнительной информацией по объекту
//
Функция ПолучитьДополнительнуюИнформациюПоОбъекту(Ссылка) Экспорт
	
	ТипЗначения = ТипЗнч(Ссылка);
	Если Не (Справочники.ТипВсеСсылки().СодержитТип(ТипЗначения)
		Или Документы.ТипВсеСсылки().СодержитТип(ТипЗначения)
		Или Задачи.ТипВсеСсылки().СодержитТип(ТипЗначения)
		Или БизнесПроцессы.ТипВсеСсылки().СодержитТип(ТипЗначения)) Тогда
		Возврат "";
	КонецЕсли;
	
	Результат = "";
	
	Если ТипЗначения = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		Владелец = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "Владелец", "");
		Если ЗначениеЗаполнено(Владелец) Тогда
			Файл = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Файл: %1'; en = 'File: %1'"), Владелец);
			ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Файл);
		КонецЕсли;
	КонецЕсли;
	
	ИнформацияОВладельце = "";
	Папка = "";
	Владелец = "";
	Если ТипЗначения = Тип("СправочникСсылка.Файлы") Тогда
		ВладелецФайла = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "ВладелецФайла", "");
		Если ЗначениеЗаполнено(ВладелецФайла) Тогда
			Если ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
				Папка = ПолучитьПолныйПутьПапки(ВладелецФайла);
			ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоДокумент(ВладелецФайла) Тогда
				Владелец = Строка(ВладелецФайла);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипЗначения = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		ВладелецВерсии = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "Владелец", "");
		Если ЗначениеЗаполнено(ВладелецВерсии) Тогда
			ВладелецФайла = ПолучитьЗначениеРеквизитаБезопасно(ВладелецВерсии, "ВладелецФайла", "");
			Если ЗначениеЗаполнено(ВладелецФайла) Тогда
				Если ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
					Папка = ПолучитьПолныйПутьПапки(ВладелецФайла);
				ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоДокумент(ВладелецФайла) Тогда
					Владелец = Строка(ВладелецФайла);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипЗначения = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		ПапкаДокумента = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "Папка", "");
		Если ЗначениеЗаполнено(ПапкаДокумента) Тогда
			Папка = ПолучитьПолныйПутьПапки(ПапкаДокумента);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Папка) Тогда
		Папка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Папка: %1'; en = 'Folder: %1'"), Папка);
		ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Папка);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Владелец) Тогда
		Владелец = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Принадлежит документу: %1'; en = 'Belongs to document: %1'"), Владелец);
		ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Владелец);
	КонецЕсли;
	
	Если ТипЗначения = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ПредметыЗадачи = МультипредметностьКлиентСервер.ПолучитьМассивСтруктурПредметовОбъекта(Ссылка);
		
		Если ПредметыЗадачи.Количество() > 0 Тогда
			УстановитьПривилегированныйРежим(Истина);
			Предметы = МультипредметностьКлиентСервер.ПредметыСтрокой(ПредметыЗадачи, Ложь, Ложь);
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		Если Не ПустаяСтрока(Предметы) Тогда
			Если ПредметыЗадачи.Количество() = 1 Тогда
				Предметы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Предмет: %1'; en = 'Subject: %1'"), Предметы);
			Иначе
				Предметы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Предметы: %1'; en = 'Subjects: %1'"), Предметы);
			КонецЕсли;
		Иначе
			Предметы = НСтр("ru = 'Предмет не задан'; en = 'The subject is not specified'");
		КонецЕсли;
		ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Предметы);
	КонецЕсли;
	
	Если ТипЗначения = Тип("СправочникСсылка.Мероприятия") Тогда
		
		ДатаНачала = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "ДатаНачала", "");
		ДатаОкончания = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "ДатаОкончания", "");
		
		Если ЗначениеЗаполнено(ДатаНачала) Тогда
			Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Начало: %1'; en = 'Start: %1'"), Формат(ДатаНачала, "ДФ='dd.MM.yyyy hh:mm'"));
			ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Описание);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаОкончания) Тогда
			Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Окончание: %1'; en = 'Ending: %1'"), Формат(ДатаОкончания, "ДФ='dd.MM.yyyy hh:mm'"));
			ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Описание);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗначения = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
		
		Проект = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "Владелец", "");
		
		Если ЗначениеЗаполнено(Проект) Тогда
			Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Проект: ""%1"".'; en = 'Project: ""%1"".'"), Строка(Проект));
			ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Описание);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Ссылка) Тогда
		
		Тема = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "Тема", "");
		
		Если ЗначениеЗаполнено(Тема) Тогда
			Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Тема: ""%1"".'; en = 'Subject: ""%1"".'"), Строка(Тема));
			ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Описание);
		КонецЕсли;
		
		Если ТипЗначения = Тип("ДокументСсылка.ВходящееПисьмо") Тогда
			
			ОтправительАдресат = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "ОтправительАдресат", "");
			
			Если ЗначениеЗаполнено(ОтправительАдресат) Тогда
				Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'От кого: %1.'; en = 'From: %1.'"), Строка(ОтправительАдресат));
				ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Описание);
			КонецЕсли;
			
		КонецЕсли;	
		
		Если ТипЗначения = Тип("ДокументСсылка.ИсходящееПисьмо") Тогда
			
			ПолучателиПисьмаСтрокой = ПолучитьЗначениеРеквизитаБезопасно(Ссылка, "ПолучателиПисьмаСтрокой", "");
			
			Если ЗначениеЗаполнено(ПолучателиПисьмаСтрокой) Тогда
				Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Кому: %1.'; en = 'To: %1.'"), Строка(ПолучателиПисьмаСтрокой));
				ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Описание);
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКатегорииДанных") Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КатегорииОбъектов.КатегорияДанных КАК Категория
			|ИЗ
			|	РегистрСведений.КатегорииОбъектов КАК КатегорииОбъектов
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КатегорииДанных КАК КатегорииДанных
			|		ПО КатегорииОбъектов.КатегорияДанных = КатегорииДанных.Ссылка
			|ГДЕ
			|	КатегорииОбъектов.ОбъектДанных = &ОбъектДанных");
		
		Запрос.УстановитьПараметр("ОбъектДанных", Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			Категории = "";
			
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				ДобавитьЗначениеКСтрокеЧерезРазделитель(Категории, ", ", Выборка.Категория);
			КонецЦикла;
			
			Если Выборка.Количество() = 1 Тогда
				Категории = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Категория: %1'; en = 'Category: %1'"), Категории);
			Иначе
				Категории = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Категории: %1'; en = 'Categories: %1'"), Категории);
			КонецЕсли;
			
			ДобавитьЗначениеКСтрокеЧерезРазделитель(Результат, "; ", Категории);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Принимает массив ссылок на объекты - результаты поиска
// Возвращает соответствие с дополнительной информацией по объектам
//
Функция ПолучитьДополнительнуюИнформациюПоОбъектам(Массив) Экспорт
	
	Результат = Новый Соответствие;
	Для каждого Элемент Из Массив Цикл
		Результат.Вставить(Элемент, ПолучитьДополнительнуюИнформациюПоОбъекту(Элемент));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПолныйПутьПапки(Папка)
	
	Если Не ЗначениеЗаполнено(Папка) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекПапка = Папка;
	Результат = " \ " + Строка(ТекПапка);
	Родитель = ПолучитьЗначениеРеквизитаБезопасно(ТекПапка, "Родитель", "");
	Пока ЗначениеЗаполнено(Родитель) Цикл
		ТекПапка = Родитель;
		Результат = " \ " + Строка(ТекПапка) + Результат;
		Родитель = ПолучитьЗначениеРеквизитаБезопасно(ТекПапка, "Родитель", "");
	КонецЦикла;
	
	Возврат Сред(Результат, 4);
	
КонецФункции

Функция ПолучитьЗначениеРеквизитаБезопасно(Ссылка, ИмяРеквизита, ЗначениеПриОшибке = Неопределено)
	
	Попытка
		ЗначениеРеквизита = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	Исключение
		ЗначениеРеквизита = ЗначениеПриОшибке;
	КонецПопытки;
	
	Возврат ЗначениеРеквизита;
	
КонецФункции


