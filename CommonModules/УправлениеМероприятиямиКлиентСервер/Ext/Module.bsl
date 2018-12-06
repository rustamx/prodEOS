﻿////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с мероприятиями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет сортировку протокола.
//
// Параметры:
//  Протокол - ДанныеФормыКоллекция - Протокол.
//
Процедура СортироватьПротокол(Протокол) Экспорт
	
	Для Каждого ПунктПротокола Из Протокол Цикл
		ПунктПротокола.НомерСортировки = ПунктПротокола.НомерСтроки;
	КонецЦикла;
	Протокол.Сортировать("НомерПунктаПрограммы, НомерСортировки");
	ВывестиНомераПунктовПротокола(Протокол);
	
КонецПроцедуры

// Рассчитывает номера пунктов для протокола.
//
// Параметры:
//  Протокол - ДанныеФормыКоллекция - Протокол.
//
Процедура ВывестиНомераПунктовПротокола(Протокол) Экспорт
	
	Для Каждого Строка Из Протокол Цикл
		Строка.НомерПунктаПротокола = ПолучитьНомерПунктаСтрокиПротокола(Строка, Протокол);
	КонецЦикла;
	
КонецПроцедуры

// Рассчитывает решения для строки программы.
//
// Параметры:
//  СтрокаПрограммы - ДанныеФормыСтруктура - Строка программы.
//  Протокол - ДанныеФормыКоллекция - Протокол.
//
// Возвращаемое значение:
//  Строка - Решение по пункту программы.
//
Функция ПолучитьРешениеВСтрокеПрограммы(СтрокаПрограммы, Протокол) Экспорт
	
	Решение = "";
	
	Если Не СтрокаПрограммы.ТребуетПринятияРешения Тогда 
		Решение = НСтр("ru = 'Не требуется'; en = 'Not required'");
	Иначе	
		НайденныеСтроки = Протокол.НайтиСтроки(Новый Структура("НомерПунктаПрограммы", СтрокаПрограммы.НомерПункта));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если ЗначениеЗаполнено(НайденнаяСтрока.Решили) Тогда 
				Решение = НСтр("ru = 'Принято'; en = 'Taken'");
				Прервать;
			КонецЕсли;	
		КонецЦикла;
		
		Если Решение = "" Тогда 
			Решение = НСтр("ru = 'Не принято'; en = 'Not taken'");
		КонецЕсли;	
	КонецЕсли;
	
	Возврат Решение;
	
КонецФункции

// Рассчитывает решения для программы.
// Если передан номер пункта программы, то рассчитывает решения только для данного пункта.
//
// Параметры:
//  Программа - ДанныеФормыКоллекция - Программа.
//  Протокол - ДанныеФормыКоллекция - Протокол.
//
Процедура ВывестиРешенияПрограммы(Программа, Протокол) Экспорт
	
	Для Каждого Строка Из Программа Цикл
		Строка.Решение = ПолучитьРешениеВСтрокеПрограммы(Строка, Протокол);
	КонецЦикла;
	
КонецПроцедуры

// Рассчитывает номер пункта для пункта протокола.
//
// Параметры:
//  ПунктПротокола - ДанныеФормыСтруктура - Строка пункта протокол.
//  Протокол - ДанныеФормыКоллекция - Протокол.
//
// Возвращаемое значение:
//  Строка - Номер пункта протокола.
//
Функция ПолучитьНомерПунктаПротокола(ПунктПротокола, Протокол) Экспорт
	
	// Если не указан номер пункта программы, то нет возможности сформировать номер пункта протокола.
	Если Не ЗначениеЗаполнено(ПунктПротокола.НомерПунктаПрограммы) Тогда 
		Возврат "";
	КонецЕсли;
	
	// Если пункт протокола не записан, то его еще нет в протоколе, требуется особая обработка.
	Если Не ЗначениеЗаполнено(ПунктПротокола.Ссылка) Тогда 
		
		Строки = Новый Массив;
		Для Каждого Строка Из Протокол Цикл
			Если ПунктПротокола.НомерПунктаПрограммы = Строка.НомерПунктаПрограммы Тогда 
				Строки.Добавить(Строка);
			КонецЕсли;
		КонецЦикла;
		
		Если Строки.Количество() = 0 Тогда 
			Возврат СформироватьНомерПунктаПротокола(ПунктПротокола.НомерПунктаПрограммы);
		КонецЕсли;
		
		НомерПодпункта = Строки.Количество() + 1;
		
		Возврат СформироватьНомерПунктаПротокола(ПунктПротокола.НомерПунктаПрограммы, НомерПодпункта);
		
	КонецЕсли;
	
	// Формирование номера пункта протокола.
	Строки = Новый Массив;
	Для Каждого Строка Из Протокол Цикл
		Если ПунктПротокола.НомерПунктаПрограммы = Строка.НомерПунктаПрограммы Тогда 
			Строки.Добавить(Строка.НомерСтроки);
		КонецЕсли;
	КонецЦикла;
	
	// Если нет строк - значит данный пункт протокола перенесли из другого номера пункта программы в пустой пункт программы.
	Если Строки.Количество() = 0 Тогда
		Возврат СформироватьНомерПунктаПротокола(ПунктПротокола.НомерПунктаПрограммы);
	КонецЕсли;
	
	// Если не можем найти строку в протоколе - не сможем рассчитать номер пункта протокола, т.к. он удален.
	СтрокиПротокола = Протокол.НайтиСтроки(Новый Структура("ПунктПротокола", ПунктПротокола.Ссылка));
	Если СтрокиПротокола.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	СтрокаПротокола = СтрокиПротокола[0];
	
	// Если строку перенесли из другого пункта программы - она будет добавлена последней.
	Инд = Строки.Найти(СтрокаПротокола.НомерСтроки);
	Если Инд = Неопределено Тогда
		Строки.Добавить(СтрокаПротокола.НомерСтроки);
	КонецЕсли;
	
	Если Строки.Количество() = 1 Тогда 
		Возврат СформироватьНомерПунктаПротокола(ПунктПротокола.НомерПунктаПрограммы);
	КонецЕсли;
	
	НомерПодпункта = Строки.Найти(СтрокаПротокола.НомерСтроки) + 1;
	
	Возврат СформироватьНомерПунктаПротокола(ПунктПротокола.НомерПунктаПрограммы, НомерПодпункта);
	
КонецФункции

// Заполняет реквизит Слушали по строке программы, если изменился начальный номер пункта программы.
//
// Параметры:
//  ПунктПротокола - ДанныеФормыСтруктура - Пункта протокол.
//  Программа - ДанныеФормыКоллекция - Программа.
//  НачальныйНомерПунктаПрограммы - Число - Начальный номер пункта программы.
//
Процедура ЗаполнитьСлушалиПунктаПротокола(ПунктПротокола, Программа, НачальныйНомерПунктаПрограммы = Неопределено) Экспорт
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("НомерПункта", ПунктПротокола.НомерПунктаПрограммы);
	НайденныеСтроки = Программа.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = НайденныеСтроки[0];
	Если ПунктПротокола.НомерПунктаПрограммы = НачальныйНомерПунктаПрограммы Тогда
		Возврат;
	КонецЕсли;
	
	ПунктПротокола.Слушали = СформироватьТекстСлушали(НайденнаяСтрока);
	
КонецПроцедуры

// Формирует заголовок пункта протокола.
//
// Параметры:
//  ПунктПротокола - ДанныеФормыСтруктура - Строка пункта протокол.
//  Протокол - ДанныеФормыКоллекция - Протокол.
//
// Возвращаемое значение:
//  Строка - Заголовок пункта протокола.
//
Функция СформироватьЗаголовокПунктаПротокола(ПунктПротокола, Протокол) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Пункт протокола №%1'; en = 'Minutes item №%1'"),
		ПолучитьНомерПунктаПротокола(ПунктПротокола, Протокол));
	
КонецФункции

// Формирует текстовое описание строки программы для реквизита слушали протокола.
//
// Параметры:
//  СтрокаПрограммы - СтрокаТабличнойЧасти - Строка программы.
//
// Возвращаемое значение:
//  Строка - Текст Слушали для протокола.
//
Функция СформироватьТекстСлушали(СтрокаПрограммы) Экспорт
	
	Слушали = "";
	Если ЗначениеЗаполнено(СтрокаПрограммы.Исполнитель) Тогда 
		ПредставлениеОтветственного = Строка(СтрокаПрограммы.Исполнитель);
		Слушали = Слушали + ПредставлениеОтветственного + Символы.ПС;
	КонецЕсли;	
	Слушали = Слушали + СтрокаПрограммы.Содержание;
	
	Возврат Слушали;
	
КонецФункции

// Определяет вариант исполнения протокола, в зависимости от состояния протокола.
//
// Параметры:
//  Протокол - ДанныеФормыКоллекция - Протокол мероприятия.
//  ПараметрыИсполнения - Структура - Параметры исполнения протокола.
//
Процедура ОпределитьСостояниеИсполненияПротокола(Протокол, ПараметрыИсполнения) Экспорт
	
	СостояниеИсполненияПротокола = "";
	
	ЕстьПунктыТребующиеИсполнения = Ложь;
	ЕстьПунктыТребующиеИсполненияСИсполнителями = Ложь;
	ЕстьПунктыТребующиеИсполненияБезИсполнителей = Ложь;
	ЕстьПунктыНаИсполнении = Ложь;
	ЕстьПунктыНаИсполненииСИсполнителями = Ложь;
	ЕстьПунктыНаИсполненииБезИсполнителей = Ложь;
	
	Для Каждого ПунктПротокола Из Протокол Цикл
		
		Если ПунктПротокола.СостояниеИсполнения = ПредопределенноеЗначение("Перечисление.СостоянияПротоколовМероприятий.ТребуетсяИсполнение") Тогда
			ЕстьПунктыТребующиеИсполнения = Истина;
			Если Не ЗначениеЗаполнено(ПунктПротокола.Ответственный) И ПунктПротокола.Исполнители.Количество() = 0 Тогда
				ЕстьПунктыТребующиеИсполненияБезИсполнителей = Истина;
			Иначе
				ЕстьПунктыТребующиеИсполненияСИсполнителями = Истина;
			КонецЕсли;
		ИначеЕсли ПунктПротокола.СостояниеИсполнения = ПредопределенноеЗначение("Перечисление.СостоянияПротоколовМероприятий.НаИсполнении") Тогда
			ЕстьПунктыНаИсполнении = Истина;
			Если Не ЗначениеЗаполнено(ПунктПротокола.Ответственный) И ПунктПротокола.Исполнители.Количество() = 0 Тогда
				ЕстьПунктыНаИсполненииБезИсполнителей = Истина;
			Иначе
				ЕстьПунктыНаИсполненииСИсполнителями = Истина
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьПунктыТребующиеИсполнения И Не ЕстьПунктыНаИсполнении Тогда
		СостояниеИсполненияПротокола = "НовоеИсполнение";
	ИначеЕсли ЕстьПунктыТребующиеИсполнения И ЕстьПунктыНаИсполнении Тогда
		СостояниеИсполненияПротокола = "ЕстьНовыеПунктыПротокола";
	ИначеЕсли Не ЕстьПунктыТребующиеИсполнения И ЕстьПунктыНаИсполнении Тогда
		СостояниеИсполненияПротокола = "ИсполнениеУжеЗапущено";
	ИначеЕсли Не ЕстьПунктыТребующиеИсполнения И Не ЕстьПунктыНаИсполнении Тогда
		СостояниеИсполненияПротокола = "НетПунктовДляИсполнения";
	КонецЕсли;
	
	ПараметрыИсполнения.ЕстьПунктыТребующиеИсполненияСИсполнителями = ЕстьПунктыТребующиеИсполненияСИсполнителями;
	ПараметрыИсполнения.ЕстьПунктыТребующиеИсполненияБезИсполнителей = ЕстьПунктыТребующиеИсполненияБезИсполнителей;
	ПараметрыИсполнения.ЕстьПунктыНаИсполненииСИсполнителями = ЕстьПунктыНаИсполненииСИсполнителями;
	ПараметрыИсполнения.ЕстьПунктыНаИсполненииБезИсполнителей = ЕстьПунктыНаИсполненииБезИсполнителей;
	
	ПараметрыИсполнения.СостояниеИсполненияПротокола = СостояниеИсполненияПротокола;
	
КонецПроцедуры

// Рассчитывает номер пункта для строки пункта протокола.
//
// Параметры:
//  СтрокаПротокола - ДанныеФормыСтруктура - Строка пункта протокол.
//  Протокол - ДанныеФормыКоллекция - Протокол.
//
// Возвращаемое значение:
//  Строка - Номер пункта протокола.
//
Функция ПолучитьНомерПунктаСтрокиПротокола(СтрокаПротокола, Протокол) Экспорт
	
	Строки = Новый Массив;
	Для Каждого Строка Из Протокол Цикл
		Если СтрокаПротокола.НомерПунктаПрограммы = Строка.НомерПунктаПрограммы Тогда 
			Строки.Добавить(Строка);
		КонецЕсли;
	КонецЦикла;
	
	Если Строки.Количество() = 1 Тогда 
		Возврат СформироватьНомерПунктаПротокола(СтрокаПротокола.НомерПунктаПрограммы);
	КонецЕсли;
	
	НомерПодпункта = Строки.Найти(СтрокаПротокола) + 1;
	
	Возврат СформироватьНомерПунктаПротокола(СтрокаПротокола.НомерПунктаПрограммы, НомерПодпункта);
	
КонецФункции

// Получает текстовое представление массива состояний мероприятия.
//
// Параметры:
//  МассивСостояний - Массив - Массив состояний мероприятия.
//
// Возвращаемое значение:
//  Строка - Текстовое представление актуальных состояний мероприятия.
//
Функция ПолучитьСтроковоеПредставлениеСостояний(МассивСостояний) Экспорт
	
	СтроковоеПредставление = "";
	
	ТипыСостояний = ПолучитьТипыСостояний();
	СоответствиеСостояний = ПолучитьСоответствиеСостояний();
	
	Для Каждого Тип Из ТипыСостояний Цикл
		Для Каждого Состояние Из МассивСостояний Цикл
			Если ЗначениеЗаполнено(Состояние) И СоответствиеСостояний.Получить(Состояние) = Тип.Ключ Тогда 
				ДобавитьЗначениеКСтрокеЧерезРазделитель(СтроковоеПредставление, ", ", Строка(Состояние));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(СтроковоеПредставление) Тогда
		СтроковоеПредставление = "<...>";
	КонецЕсли;
	
	Возврат СтроковоеПредставление;
	
КонецФункции

// Возвращает соответствие состояний мероприятия.
//
// Возвращаемое значение:
//  Соответствие - Соответствие состояний мероприятий и типов состояний.
//
Функция ПолучитьСоответствиеСостояний() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПриглашенияОтправлены"),
		"СостояниеПриглашений");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПриглашенияНеПриняты"),
		"СостояниеПриглашений");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПриглашенияПриняты"),
		"СостояниеПриглашений");
	
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПрограммаНаУтверждении"),
		"СостояниеПрограммы");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПрограммаУтверждена"),
		"СостояниеПрограммы");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПрограммаНеУтверждена"),
		"СостояниеПрограммы");
	
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МатериалыВыступающихЗапрошены"),
		"СостояниеМатериаловВыступающих");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МатериалыОтправленыНаОзнакомление"),
		"СостояниеМатериаловВыступающих");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПолученыМатериалыВыступающих"),
		"СостояниеМатериаловВыступающих");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.СМатериаламиОзнакомились"),
		"СостояниеМатериаловВыступающих");
	
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколГотовиться"),
		"СостояниеПротокола");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколПодготовлен"),
		"СостояниеПротокола");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНаСогласовании"),
		"СостояниеПротокола");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколСогласован"),
		"СостояниеПротокола");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНеСогласован"),
		"СостояниеПротокола");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНаУтверждении"),
		"СостояниеПротокола");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНеУтвержден"),
		"СостояниеПротокола");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколУтвержден"),
		"СостояниеПротокола");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНаИсполнении"),
		"СостояниеПротокола");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколИсполнен"),
		"СостояниеПротокола");
	
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МероприятиеВСтадииПодготовки"),
		"СостояниеМероприятия");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МероприятиеОтменено"),
		"СостояниеМероприятия");
	Соответствие.Вставить(
		ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МероприятиеПроведено"),
		"СостояниеМероприятия");
	
	Возврат Соответствие;
	
КонецФункции

// Выполняет пересчет начала и окончания пунктов программы мероприятия.
//
// Параметры:
//  Мероприятие - ДанныеФормыКоллекция, СправочникОбъект.Мероприятия - Мероприятие с программой.
//
Процедура ПересчитатьНачалоОкончаниеПунктовПрограммы(Мероприятие) Экспорт
	
	Если Не ЗначениеЗаполнено(Мероприятие.ДатаНачала) Тогда
		Для Каждого ПунктПрограммы Из Мероприятие.Программа Цикл
			ПунктПрограммы.Начало = Неопределено;
			ПунктПрограммы.Окончание = Неопределено;
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Если Мероприятие.Программа.Количество() > 0 Тогда 
		Строка = Мероприятие.Программа[0];
		Строка.Начало = Мероприятие.ДатаНачала;
		Строка.Окончание = Строка.Начало + Строка.ВремяПлан;
	КонецЕсли;
	
	Для Инд = 1 По Мероприятие.Программа.Количество()-1 Цикл
		
		Строка = Мероприятие.Программа[Инд];
		
		Если ЗначениеЗаполнено(Мероприятие.Программа[Инд-1].Окончание) Тогда 
			Строка.Начало = Мероприятие.Программа[Инд-1].Окончание;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Начало) Тогда 
			Строка.Окончание = Строка.Начало + Строка.ВремяПлан
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует номер пункта протокола по номеру пункта программы и подпункту.
//
// Параметры:
//  НомерПунктаПрограммы - Число - Номер пункта программы.
//  НомерПодпункта - Число - Номер пункта протокола среди других пунктов протокола по пункту программы.
//
// Возвращаемое значение:
//  Строка - Номер пункта протокола.
//
Функция СформироватьНомерПунктаПротокола(НомерПунктаПрограммы, НомерПодпункта = Неопределено)
	
	Если НомерПодпункта = Неопределено Тогда
		Возврат Строка(НомерПунктаПрограммы);
	КонецЕсли;
	
	Возврат Строка(НомерПунктаПрограммы) + "." + Строка(НомерПодпункта);
	
КонецФункции

// Возвращает структуру типов состояний мероприятия.
//
// Возвращаемое значение:
//  Структура - Структура типов состояний мероприятия.
//
Функция ПолучитьТипыСостояний()
	
	ТипыСостояний = Новый Структура(
		"СостояниеМероприятия,
		|СостояниеПриглашений, 
		|СостояниеПрограммы, 
		|СостояниеМатериаловВыступающих, 
		|СостояниеПротокола");
	
	Возврат ТипыСостояний;
	
КонецФункции

#КонецОбласти
