﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверяет что заполнены поля шаблона
Функция ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта() Экспорт
	
	МассивПолей = Новый Массив;
	
	Если Исполнители.Количество() = 0 Тогда
		МассивПолей.Добавить("Исполнители");
	КонецЕсли;	
	
	Возврат МассивПолей;
	
КонецФункции	

//Формирует текстовое представление бизнес-процесса, создаваемого по шаблону
Функция СформироватьСводкуПоШаблону() Экспорт
	
	Результат = ШаблоныБизнесПроцессов.ПолучитьОбщуюЧастьОписанияШаблона(Ссылка);
	
	Если ЗначениеЗаполнено(НаименованиеБизнесПроцесса) Тогда
		Результат = Результат + НСтр("ru = 'Заголовок'; en = 'Title'") + ": " + НаименованиеБизнесПроцесса + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Описание) Тогда
		Результат = Результат + НСтр("ru = 'Описание'; en = 'Details'") + ": " + Описание + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Важность) Тогда
		Результат = Результат + НСтр("ru = 'Важность'; en = 'Importance'") + ": " + Строка(Важность) + Символы.ПС;
	КонецЕсли;
	
	Если Исполнители.Количество() > 0 Тогда
		Результат = Результат + НСтр("ru = 'Согласующие'; en = 'Approved by'") + ": ";
		Для Каждого Исполнитель Из Исполнители Цикл
			Результат = Результат + Исполнитель.Исполнитель
				+ ";" + Символы.ПС;
		КонецЦикла;
		Результат = Сред(Результат, 1, СтрДлина(Результат) - 2);
		Результат = Результат + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВариантСогласования) Тогда
		Результат = Результат + Нстр("ru = 'Порядок согласования'; en = 'Approval order'") + ": " + Строка(ВариантСогласования) + Символы.ПС;
	КонецЕсли;
	
	ДлительностьПроцесса = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(ЭтотОбъект);
	ДлительностьПроцессаСтрокой = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеДлительности(
		ДлительностьПроцесса.СрокИсполненияПроцессаДни,
		ДлительностьПроцесса.СрокИсполненияПроцессаЧасы,
		ДлительностьПроцесса.СрокИсполненияПроцессаМинуты);
		
	Если ЗначениеЗаполнено(ДлительностьПроцессаСтрокой) Тогда
		Результат = Результат + Нстр("ru = 'Срок'; en = 'Due date'") + ": "
			+ ДлительностьПроцессаСтрокой;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_ПоддержкаМеханизмаОтсутствий

// Получает исполнителей
Функция ПолучитьИсполнителей() Экспорт
	
	МассивИсполнителей = Новый Массив;
	
	Для Каждого СтрокаИсполнитель Из Исполнители Цикл
		ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(СтрокаИсполнитель.Исполнитель);
		МассивИсполнителей.Добавить(ДанныеИсполнителя);
	КонецЦикла;
	
	Возврат МассивИсполнителей;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ШаблоныБизнесПроцессов.НачальноеЗаполнениеШаблона(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	// Проверка согласующих на дубли
	КоличествоИсполнителей = Исполнители.Количество();
	Для Инд1 = 0 По КоличествоИсполнителей-2 Цикл
		Строка1 = Исполнители[Инд1];
		Если Не ЗначениеЗаполнено(Строка1.Исполнитель) Тогда 
			Продолжить;
		КонецЕсли;

		Для Инд2 = Инд1+1 По КоличествоИсполнителей-1 Цикл
			Строка2 = Исполнители[Инд2];
			
			Если Строка1.Исполнитель = Строка2.Исполнитель 
				И (ТипЗнч(Строка1.Исполнитель) = Тип("СправочникСсылка.Пользователи")
					Или ТипЗнч(Строка1.Исполнитель) = Тип("СправочникСсылка.ПолныеРоли")) Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Исполнитель ""%1"" указан дважды в списке согласующих!'; en = 'Performer ""%1"" is specified twice in the list of approving persons!'"),
					Строка(Строка2.Исполнитель));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"Исполнители[" + Формат(Строка2.НомерСтроки-1, "ЧГ=0") + "].Исполнитель",, 
					Отказ);
					
			ИначеЕсли Строка1.Исполнитель = Строка2.Исполнитель 
				И ТипЗнч(Строка1.Исполнитель) = Тип("Строка") Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Автоподстановка ""%1"" указана дважды в списке согласующих!'; en = 'Auto-substitution ""%1"" is specified twice in the approving persons list!'"),
					Строка(Строка2.Исполнитель));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"Исполнители[" + Формат(Строка2.НомерСтроки-1, "ЧГ=0") + "].Исполнитель",, 
					Отказ);
		
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШаблоныБизнесПроцессов.ШаблонПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
