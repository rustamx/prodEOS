﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Не ДополнительныеСвойства.Свойство("Работы") Тогда 
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФактическиеТрудозатраты.Подразделение,
		|	ФактическиеТрудозатраты.Пользователь,
		|	ФактическиеТрудозатраты.Источник,
		|	ФактическиеТрудозатраты.Проект,
		|	ФактическиеТрудозатраты.ПроектнаяЗадача,
		|	ФактическиеТрудозатраты.ВидРабот,
		|	ФактическиеТрудозатраты.ДатаДобавления,
		|	ФактическиеТрудозатраты.НомерДобавления,
		|	ФактическиеТрудозатраты.УдалитьОписаниеРаботы,
		|	ФактическиеТрудозатраты.Начало,
		|	ФактическиеТрудозатраты.Окончание
		|ИЗ
		|	РегистрСведений.ФактическиеТрудозатраты КАК ФактическиеТрудозатраты
		|ГДЕ
		|	ФактическиеТрудозатраты.ЕжедневныйОтчет = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
			МенеджерЗаписи.Прочитать();
			
			МенеджерЗаписи.Удалена = Ложь;
			МенеджерЗаписи.Записать();
		КонецЦикла;
		
		Возврат;
	КонецЕсли;
	
	Результат = ДополнительныеСвойства.Работы;
	Результат.Колонки.Добавить("НомерДобавления", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("ДлительностьСверхурочно", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("ДлительностьВВыходные", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("ДлительностьРабочееВремя", Новый ОписаниеТипов("Число"));
	
	Для Каждого Строка Из Результат Цикл
		Если Не ЗначениеЗаполнено(Строка.ДатаДобавления) 
		 Или НачалоДня(Строка.ДатаДобавления) <> НачалоДня(ЭтотОбъект.Дата) Тогда 
			Строка.ДатаДобавления = ЭтотОбъект.Дата;
		КонецЕсли;	
		
		Если Не ЗначениеЗаполнено(Строка.Источник) Тогда 
			Строка.Источник = ЭтотОбъект.Ссылка;
		КонецЕсли;	
		
		Если Строка.ВидРабот.ВидВремени = Перечисления.ВидыВремени.Рабочее Тогда 
			Строка.ДлительностьРабочееВремя = Строка.Длительность;
		КонецЕсли;	
		
		Строка.НомерДобавления = Результат.Индекс(Строка)+1;
	КонецЦикла;	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда 
		ГрафикРаботы = ГрафикиРаботы.ПолучитьГрафикРаботыПользователя(Пользователь);
		РабочийДень = ГрафикиРаботы.ЭтоРабочийДень(Дата, ГрафикРаботы);
		Если РабочийДень Тогда 
			ДлительностьРабочегоДня = ГрафикиРаботы.ПолучитьДлительностьРабочегоДня(Дата, ГрафикРаботы);
			ДлительностьРабочееВремя = Результат.Итог("ДлительностьРабочееВремя");
			Если ДлительностьРабочееВремя > ДлительностьРабочегоДня Тогда // сверхурочно
				ДлительностьСверхурочно = ДлительностьРабочееВремя - ДлительностьРабочегоДня;
				
				Инд = Результат.Количество() - 1;
				Пока ДлительностьСверхурочно > 0 Цикл
					Строка = Результат[Инд];
					Если Строка.ДлительностьРабочееВремя > 0 Тогда 
						Если Строка.ДлительностьРабочееВремя >= ДлительностьСверхурочно Тогда 
							Строка.ДлительностьСверхурочно = ДлительностьСверхурочно;
							ДлительностьСверхурочно = 0;
						Иначе
							Строка.ДлительностьСверхурочно = Строка.ДлительностьРабочееВремя;
							ДлительностьСверхурочно = ДлительностьСверхурочно - Строка.ДлительностьСверхурочно;
						КонецЕсли;	
					КонецЕсли;
					Инд = Инд - 1;
				КонецЦикла;	
			КонецЕсли;	
		Иначе	
			Для Каждого Строка Из Результат Цикл
				Строка.ДлительностьВВыходные = Строка.Длительность;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФактическиеТрудозатраты.Подразделение,
	|	ФактическиеТрудозатраты.Пользователь,
	|	ФактическиеТрудозатраты.Источник,
	|	ФактическиеТрудозатраты.Проект,
	|	ФактическиеТрудозатраты.ПроектнаяЗадача,
	|	ФактическиеТрудозатраты.ВидРабот,
	|	ФактическиеТрудозатраты.ДатаДобавления,
	|	ФактическиеТрудозатраты.НомерДобавления,
	|	ФактическиеТрудозатраты.УдалитьОписаниеРаботы,
	|	ФактическиеТрудозатраты.Начало,
	|	ФактическиеТрудозатраты.Окончание
	|ИЗ
	|	РегистрСведений.ФактическиеТрудозатраты КАК ФактическиеТрудозатраты
	|ГДЕ
	|	ФактическиеТрудозатраты.ЕжедневныйОтчет = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Прочитать();
		
		МенеджерЗаписи.ЕжедневныйОтчет = Неопределено;
		МенеджерЗаписи.Записать();
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФактическиеТрудозатраты.Подразделение,
	|	ФактическиеТрудозатраты.Пользователь,
	|	ФактическиеТрудозатраты.Источник,
	|	ФактическиеТрудозатраты.Проект,
	|	ФактическиеТрудозатраты.ПроектнаяЗадача,
	|	ФактическиеТрудозатраты.ВидРабот,
	|	ФактическиеТрудозатраты.ДатаДобавления,
	|	ФактическиеТрудозатраты.НомерДобавления,
	|	ФактическиеТрудозатраты.УдалитьОписаниеРаботы,
	|	ФактическиеТрудозатраты.Начало,
	|	ФактическиеТрудозатраты.Окончание
	|ИЗ
	|	РегистрСведений.ФактическиеТрудозатраты КАК ФактическиеТрудозатраты
	|ГДЕ
	|	(НАЧАЛОПЕРИОДА(ФактическиеТрудозатраты.ДатаДобавления, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)  
	|	И ФактическиеТрудозатраты.Пользователь = &Пользователь)
	|	Или (ФактическиеТрудозатраты.Источник = &Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("ДатаОтчета", ЭтотОбъект.Дата);
	Запрос.УстановитьПараметр("Пользователь", ЭтотОбъект.Пользователь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
	КонецЦикла;	
	
	Для Каждого Строка Из Результат Цикл
		
		МенеджерЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.Подразделение = ЭтотОбъект.Подразделение;
		МенеджерЗаписи.Пользователь = ЭтотОбъект.Пользователь;
		
		МенеджерЗаписи.ОписаниеРаботы = Строка.Работа;
		МенеджерЗаписи.ВидРабот = Строка.ВидРабот;
		МенеджерЗаписи.Источник = Строка.Источник;
		
		МенеджерЗаписи.Проект = Строка.Проект;
		МенеджерЗаписи.ПроектнаяЗадача = Строка.ПроектнаяЗадача;
			
		МенеджерЗаписи.Длительность = Строка.Длительность;
		МенеджерЗаписи.ДлительностьСверхурочно = Строка.ДлительностьСверхурочно;
		МенеджерЗаписи.ДлительностьВВыходные = Строка.ДлительностьВВыходные;
		
		Если СпособУказанияВремени = Перечисления.СпособыУказанияВремени.ВремяНачала Тогда 
			МенеджерЗаписи.Начало = Строка.Начало;
			МенеджерЗаписи.Окончание = Строка.Окончание;
		КонецЕсли;
		
		МенеджерЗаписи.ДатаДобавления = Строка.ДатаДобавления;
		МенеджерЗаписи.НомерДобавления = Строка.НомерДобавления;
		
		МенеджерЗаписи.ЕжедневныйОтчет = ЭтотОбъект.Ссылка;
		МенеджерЗаписи.Удалена = Ложь;
		МенеджерЗаписи.Записать();
	КонецЦикла;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Запись Тогда 
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("Работы") Тогда 
		Возврат;
	КонецЕсли;	
	
	Работы = ДополнительныеСвойства.Работы;
	
	// заполнение поля длительность
	Если (СпособУказанияВремени = Перечисления.СпособыУказанияВремени.ВремяНачала) И (Работы.Количество() > 0) Тогда
		
		Для Каждого Строка Из Работы Цикл
			Если Строка.Окончание > Строка.Начало Тогда 
				Строка.Длительность = Строка.Окончание - Строка.Начало;
			Иначе
				Строка.Длительность = 0;
			КонецЕсли;	
		КонецЦикла;	
		
	КонецЕсли;
	
	// общая длительность работ для вывода в журнал
	ДлительностьРаботСек = Работы.Итог("Длительность");
	ДлительностьРабот = УчетВремениКлиентСервер.ЧислоВСтроку(ДлительностьРаботСек);
	
	// проверка суммарной длительности для вывода в журнал
	Если Не ЗначениеЗаполнено(НачалоДня) Или Не ЗначениеЗаполнено(ОкончаниеДня) Или (НачалоДня > ОкончаниеДня) Тогда 
		НекорректнаяДлительность = Истина;
	Иначе    	
		ПродолжительностьДняСек = ОкончаниеДня - НачалоДня;
		
		НекорректнаяДлительность = (ДлительностьРаботСек <> ПродолжительностьДняСек);
	КонецЕсли;
	
	// Проверка пропусков интервалов
	Если СпособУказанияВремени = Перечисления.СпособыУказанияВремени.ВремяНачала Тогда 
		
		Для Каждого Строка1 Из Работы Цикл
			ЕстьПозднее = Ложь;
			ЕстьПропуски = Истина;
			
			Для Каждого Строка2 Из Работы Цикл
				Если Работы.Индекс(Строка1) = Работы.Индекс(Строка2) Тогда 
					Продолжить;
				КонецЕсли;	
				
				Если Строка2.Начало >= Строка1.Окончание Тогда 
					ЕстьПозднее = Истина;
				КонецЕсли;	
				
				Если Строка2.Начало = Строка1.Окончание Тогда 
					ЕстьПропуски = Ложь;
				КонецЕсли;	
			КонецЦикла;
			
			Если ЕстьПозднее И ЕстьПропуски Тогда 
				НекорректнаяДлительность = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Работы", Работы);
	
КонецПроцедуры

Функция ЕстьЕжедневныеОтчетыТекущейДаты()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕжедневныйОтчет.Ссылка
	|ИЗ
	|	Документ.ЕжедневныйОтчет КАК ЕжедневныйОтчет
	|ГДЕ
	|	ЕжедневныйОтчет.Пользователь = &Пользователь
	|	И НАЧАЛОПЕРИОДА(ЕжедневныйОтчет.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
	|	И ЕжедневныйОтчет.Проведен
	|	И ЕжедневныйОтчет.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Дата", 	 Дата);
	Запрос.УстановитьПараметр("Ссылка",  Ссылка);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЕстьЕжедневныеОтчетыТекущейДаты() Тогда 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ежедневный отчет на дату %1 уже был введен ранее!'; en = 'Daily report for date %1 has already been entered before!'"),
			Формат(Дата, "ДЛФ=D"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		    ТекстСообщения,
			ЭтотОбъект,
			"Дата",, 
			Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для пользователя %1 не указано Подразделение!'; en = 'Department is not specified for user %1!'"),
			Строка(Пользователь));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		    ТекстСообщения,
			ЭтотОбъект,
			"Пользователь",,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФактическиеТрудозатраты.Подразделение,
	|	ФактическиеТрудозатраты.Пользователь,
	|	ФактическиеТрудозатраты.Источник,
	|	ФактическиеТрудозатраты.Проект,
	|	ФактическиеТрудозатраты.ПроектнаяЗадача,
	|	ФактическиеТрудозатраты.ВидРабот,
	|	ФактическиеТрудозатраты.ДатаДобавления,
	|	ФактическиеТрудозатраты.НомерДобавления,
	|	ФактическиеТрудозатраты.УдалитьОписаниеРаботы,
	|	ФактическиеТрудозатраты.Начало,
	|	ФактическиеТрудозатраты.Окончание
	|ИЗ
	|	РегистрСведений.ФактическиеТрудозатраты КАК ФактическиеТрудозатраты
	|ГДЕ
	|	ФактическиеТрудозатраты.ЕжедневныйОтчет = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Прочитать();
		
		МенеджерЗаписи.Удалена = Истина;
		МенеджерЗаписи.Записать();
	КонецЦикла;	
	
КонецПроцедуры

