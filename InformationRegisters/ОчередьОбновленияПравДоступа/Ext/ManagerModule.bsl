﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Добавляет указанный объект в очередь отложенного обновления прав
//
// Параметры:
//  Объект - Ссылка - ссылка на объект, который необходимо записать в очередь.
//  ДатаВремя - Дата - Необязательный. Используется для сортровки при обработке очереди.
//  Приоритет - Число, Неопределено - Необязательный. Приоритет очереди, в которую нужно добавить объект. По умолчанию Неопределено.
//
Процедура Добавить(Объект, ДатаВремя = Неопределено, Приоритет = Неопределено, ДопСведения = "") Экспорт
	
	Если ДатаВремя = Неопределено Тогда
		
		ДатаВремя = ТекущаяДата();
		ДатаВМиллиСекундах = ОбщегоНазначенияДокументооборот.ТекущаяДатаВМиллисекундах();
		
	Иначе
		
		// Запись должна быть обработана после других записей с такой же датой.
		ДатаВМиллисекундах = ОбщегоНазначенияДокументооборот.ДатаВМиллисекундах(ДатаВремя);
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ЕстьNull(МАКСИМУМ(ОчередьОбновленияПравДоступа.ДатаВМиллиСекундах), 0) КАК ДатаВмс
			|ИЗ
			|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
			|ГДЕ
			|	ОчередьОбновленияПравДоступа.Дата = &ДатаВремя");
		
		Запрос.УстановитьПараметр("ДатаВремя", ДатаВремя);
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			ДатаВМиллисекундах = ДатаВМиллисекундах + Выборка.ДатаВмс + 1;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Приоритет = Неопределено Тогда
		Приоритет = ПараметрыСеанса.ПриоритетОчередиОбновленияПрав;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ОчередьОбновленияПравДоступа.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект = Объект;
	МенеджерЗаписи.Приоритет = Приоритет;
	МенеджерЗаписи.ДопСведения = ДопСведения;
	МенеджерЗаписи.Дата = ДатаВремя;
	МенеджерЗаписи.ДатаВМиллиСекундах = ДатаВМиллиСекундах;
	
	// Запись с замещением для правильного выстраивания очереди
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

// Удаляет указанный объект из очереди отложенного обновления прав
//
// Параметры:
//  Объект - Ссылка, Массив - ссылка на объект, который необходимо удалить из очереди или массив таких ссылок.
//
Процедура Удалить(Объект, ДопСведения = "") Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОчередьОбновленияПравДоступа.Объект,
		|	ОчередьОбновленияПравДоступа.Приоритет,
		|	ОчередьОбновленияПравДоступа.ДопСведения
		|ИЗ
		|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
		|ГДЕ
		|	ОчередьОбновленияПравДоступа.Объект = &Объект
		|	И ОчередьОбновленияПравДоступа.ДопСведения = &ДопСведения";
	
	Если ТипЗнч(Объект) = Тип("Массив") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "= &Объект", "В (&Объект)");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.УстановитьПараметр("ДопСведения", ДопСведения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.ОчередьОбновленияПравДоступа.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
КонецПроцедуры

// Обновляет порцию прав из очереди
//
// Параметры:
//  РазмерПорции - Число - количество записей, которые необходимо обработать.
//
// Возвращаемое значение:
//  Число - количество обарботанных записей очереди.
//
Функция ОбработатьПорцию(РазмерПорции = 10) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ %1
		|	ОчередьОбновленияПравДоступа.Объект,
		|	ОчередьОбновленияПравДоступа.ДопСведения
		|ИЗ
		|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
		|ГДЕ
		|	ОчередьОбновленияПравДоступа.Приоритет = &Приоритет
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаВМиллиСекундах,
		|	Объект";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%1", Формат(РазмерПорции, "ЧГ="));
	Запрос.УстановитьПараметр("Приоритет", ПараметрыСеанса.ПриоритетОчередиОбновленияПрав);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Количество = Выборка.Количество();
	
	ОбработанныеВТекущейИтерации = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		
		// Дескриптор мог быть обработан при групповом расчете прав запросом
		Если ОбработанныеВТекущейИтерации.Получить(Выборка.Объект) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ОбработатьЭлементОчереди(
			Выборка.Объект,
			Выборка.ДопСведения,
			ОбработанныеВТекущейИтерации);
		
	КонецЦикла;
	
	Возврат Количество;
	
КонецФункции

// Обрабатывает обновление прав по указанному элементу очереди и удаляет его 
// из очереди обновления
Процедура ОбработатьЭлементОчереди(Ссылка, ДопСведения,
			ОбработанныеВТекущейИтерации = Неопределено, ТолькоПереданныйЭлемент = Ложь) Экспорт
	
	СтарыйПриоритет = ПараметрыСеанса.ПриоритетОчередиОбновленияПрав;
	ТипЭлемента = ТипЗнч(Ссылка);
	
	ОбработанныеЭлементы = Неопределено;
	ЕстьОшибки = Ложь;
	
	Попытка
		
		Если ЭтоДескриптор(ТипЭлемента) Тогда
			
			ОбработанныеЭлементы = Новый Массив;
			ДескрипторыКРасчету = Новый Массив;
			
			ЭтоДескрипторОбъекта = ТипЭлемента = Тип("СправочникСсылка.ДескрипторыДоступаОбъектов");
			ЭтоИндивидуальныйДескриптор = Ложь;
			ЭтоДескрипторДляЛокальныхАдминистраторов = Ложь;
			
			Если ЭтоДескрипторОбъекта Тогда
				РеквизитыДескриптора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
					Ссылка, "ИдентификаторОбъектаМетаданных, КонтейнерПользователей, ДляЛокальныхАдминистраторов");
				ЭтоИндивидуальныйДескриптор = ЗначениеЗаполнено(РеквизитыДескриптора.КонтейнерПользователей);
				ЭтоДескрипторДляЛокальныхАдминистраторов = РеквизитыДескриптора.ДляЛокальныхАдминистраторов;
				ИдОбъектаМетаданных = РеквизитыДескриптора.ИдентификаторОбъектаМетаданных;
			Иначе
				// Дескриптор регистра.
				ИдОбъектаМетаданных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ОбъектМетаданных");
			КонецЕсли;
			
			// Поиск дескрипторов к расчету.
			Если Не ТолькоПереданныйЭлемент Тогда
				
				Запрос = Новый Запрос(
					"ВЫБРАТЬ ПЕРВЫЕ %1
					|	ОчередьОбновленияПравДоступа.Объект
					|ИЗ
					|	%2 КАК ДескрипторыДоступа
					|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
					|		ПО ДескрипторыДоступа.Ссылка = ОчередьОбновленияПравДоступа.Объект
					|ГДЕ
					|	ОчередьОбновленияПравДоступа.Приоритет = &Приоритет
					|	%3
					|	
					|УПОРЯДОЧИТЬ ПО
					|	ОчередьОбновленияПравДоступа.ДатаВМиллиСекундах");
				
				РазмерПорцииДескрипторов =
					ДокументооборотПраваДоступаПовтИсп.РазмерПорцииДескрипторовДляРасчета(
						ЭтоИндивидуальныйДескриптор);
						
				Если ЭтоИндивидуальныйДескриптор Тогда
					
					УсловиеПоПолямДескриптора =
						"И ДескрипторыДоступа.КонтейнерПользователей <> Неопределено";
					
				ИначеЕсли ЭтоДескрипторДляЛокальныхАдминистраторов Тогда
					
					УсловиеПоПолямДескриптора =
						"И ДескрипторыДоступа.ДляЛокальныхАдминистраторов
						|И ДескрипторыДоступа.ИдентификаторОбъектаМетаданных = &ИОМ";
					
				ИначеЕсли ЭтоДескрипторОбъекта Тогда
					
					УсловиеПоПолямДескриптора =
						"И ДескрипторыДоступа.КонтейнерПользователей = Неопределено
						|И Не ДескрипторыДоступа.ДляЛокальныхАдминистраторов
						|И ДескрипторыДоступа.ИдентификаторОбъектаМетаданных = &ИОМ";
					
				Иначе
					
					УсловиеПоПолямДескриптора =
						"И ДескрипторыДоступа.ОбъектМетаданных = &ИОМ";
					
				КонецЕсли;
				
				Запрос.Текст = СтрШаблон(Запрос.Текст,
					Формат(РазмерПорцииДескрипторов, "ЧГ="), 
					Ссылка.Метаданные().ПолноеИмя(), 
					УсловиеПоПолямДескриптора);
				
				Запрос.УстановитьПараметр("ИОМ", ИдОбъектаМетаданных);
				Запрос.УстановитьПараметр("Приоритет", СтарыйПриоритет);
				
				Результат = Запрос.Выполнить();
				ТаблицаРезультата = Результат.Выгрузить();
				
				ДескрипторыКРасчету = ТаблицаРезультата.ВыгрузитьКолонку("Объект");
				ОбработанныеЭлементы = ТаблицаРезультата.ВыгрузитьКолонку("Объект");
				
			КонецЕсли;
			
			Если ДескрипторыКРасчету.Найти(Ссылка) = Неопределено Тогда
				ДескрипторыКРасчету.Добавить(Ссылка);
				ОбработанныеЭлементы.Добавить(Ссылка);
			КонецЕсли;
			
			// Расчет прав по дескрипторам.
			Если ТипЭлемента = Тип("СправочникСсылка.ДескрипторыДоступаОбъектов") Тогда
				
				НазначениеДескриптора = Справочники.ДескрипторыДоступаОбъектов.НазначениеДескриптора(
					ЭтоИндивидуальныйДескриптор, ЭтоДескрипторДляЛокальныхАдминистраторов);
				
		 		Справочники.ДескрипторыДоступаОбъектов.РассчитатьПраваЗапросом(
					ДескрипторыКРасчету, ИдОбъектаМетаданных, НазначениеДескриптора);
				
				ДокументооборотПраваДоступа.ОбновитьПраваСвязанныхДескрипторовПоДескрипторам(
					ОбработанныеЭлементы);
				
			Иначе
				
		 		Справочники.ДескрипторыДоступаРегистров.РассчитатьПраваЗапросом(
					ДескрипторыКРасчету, ИдОбъектаМетаданных);
				
			КонецЕсли;
				
		ИначеЕсли ТипЭлемента = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
			
			Если ДопСведения = "ОпределитьПрава" Тогда
				ДокументооборотПраваДоступа.ОпределитьПраваОбъектовТаблицы(Ссылка, Истина);
				
			ИначеЕсли ДопСведения = "ОпределитьПраваДляЛокальныхАдминиистраторов" Тогда
				ДокументооборотПраваДоступа.ОпределитьПраваОбъектовТаблицыДляЛокальныхАдминиистраторов(Ссылка, Истина);
				
			ИначеЕсли ДопСведения = "РассчитатьПрава" Тогда
				ДокументооборотПраваДоступа.РассчитатьПраваОбъектовТаблицы(Ссылка, Истина);
				
			КонецЕсли;
			
		ИначеЕсли ДопСведения = "ИзменениеСоставаКонтейнера" Тогда
			
			// Все записи по изменению состава контейнеров обрабатываются вместе.
			Запрос = Новый Запрос(
				"ВЫБРАТЬ
				|	ОчередьОбновленияПравДоступа.Объект
				|ИЗ
				|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
				|ГДЕ
				|	ОчередьОбновленияПравДоступа.Приоритет = &Приоритет
				|	И ОчередьОбновленияПравДоступа.ДопСведения = &ДопСведения");
			
			Запрос.УстановитьПараметр("ДопСведения", ДопСведения);
			Запрос.УстановитьПараметр("Приоритет", СтарыйПриоритет);
			
			ТаблицаКонтейнеров = Запрос.Выполнить().Выгрузить();
			ИзмененнныеКонтейнеры = ТаблицаКонтейнеров.ВыгрузитьКолонку("Объект");
			ОбработанныеЭлементы = ТаблицаКонтейнеров.ВыгрузитьКолонку("Объект");
			
			ДокументооборотПраваДоступа.ОбновитьПраваПоСоставуКонтейнеров(
				ИзмененнныеКонтейнеры,
				Истина); // Немедленно
			
		ИначеЕсли ДопСведения = "ОбновитьПраваПоЗначениюРазрезаДоступа" Тогда
			
			ДокументооборотПраваДоступа.ОбновитьПраваПоЗначениюРазрезаДоступа(Ссылка, Истина);
			
		ИначеЕсли ДопСведения = "АктуализироватьПраваРуководителейИДелегатов" Тогда
			
			// Все записи по актуализации прав руководителей и делегатов обрабатываются вместе.
			Запрос = Новый Запрос(
				"ВЫБРАТЬ
				|	ОчередьОбновленияПравДоступа.Объект
				|ИЗ
				|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
				|ГДЕ
				|	ОчередьОбновленияПравДоступа.Приоритет = &Приоритет
				|	И ОчередьОбновленияПравДоступа.ДопСведения = &ДопСведения");
			
			Запрос.УстановитьПараметр("ДопСведения", ДопСведения);
			Запрос.УстановитьПараметр("Приоритет", СтарыйПриоритет);
			
			ТаблицаПользователей = Запрос.Выполнить().Выгрузить();
			ПользователиКОбработке = ТаблицаПользователей.ВыгрузитьКолонку("Объект");
			ОбработанныеЭлементы = ТаблицаПользователей.ВыгрузитьКолонку("Объект");
			
			ДокументооборотПраваДоступа.АктуализироватьПраваПользователейПоСоставуСубъектов(
				ПользователиКОбработке,
				Истина); // Немедленно
			
		ИначеЕсли ТипЭлемента = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
			
			Если ДопСведения = "АктуализироватьПраваРуководителей" Тогда
				ДокументооборотПраваДоступа.АктуализироватьПраваПользователейПодразделенийПоССПД(
					Ссылка,
					Истина); // Немедленно
			ИначеЕсли ДопСведения = "ОтработатьИзменениеРуководителя" Тогда
				ДокументооборотПраваДоступа.ОбновитьПраваПриИзмененииРуководителяПодразделения(
					Ссылка,
					Истина); // Немедленно
			КонецЕсли;
			
		ИначеЕсли ТипЭлемента = Тип("СправочникСсылка.Контрагенты") Тогда
			
			ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = 2;
			ДокументооборотПраваДоступа.ОбновитьПраваПоКонтрагенту(
				Ссылка, 
				Истина); // Немедленно
			
		ИначеЕсли ТипЭлемента = Тип("ПеречислениеСсылка.ЗаданияОчередиОбновленияПрав") Тогда
			
			Если Ссылка = Перечисления.ЗаданияОчередиОбновленияПрав.ОчиститьВсеПрава Тогда
				ДокументооборотПраваДоступа.УдалитьВсеДанныеОПравахДоступа(Истина);
				
			ИначеЕсли Ссылка = Перечисления.ЗаданияОчередиОбновленияПрав.РассчитатьВсеПрава Тогда
				ДокументооборотПраваДоступа.ОбновитьПраваВсехДанных(Истина);
				
			ИначеЕсли Ссылка = Перечисления.ЗаданияОчередиОбновленияПрав.ЗаполнитьСоставСубъектовПравДоступа Тогда
				РегистрыСведений.СоставСубъектовПравДоступа.ОбновитьВсеДанные(Истина);
				
			ИначеЕсли Ссылка = Перечисления.ЗаданияОчередиОбновленияПрав.РассчитатьПраваРазрезовДоступа Тогда
				ДокументооборотПраваДоступа.ОбновитьПраваВсехРазрезовДоступа(Истина);
				
			ИначеЕсли Ссылка = Перечисления.ЗаданияОчередиОбновленияПрав.ОтключитьДескрипторыЛокАдминистраторов Тогда
				ДокументооборотПраваДоступа.ОтключитьДескрипторыЛокАдминистраторов(Истина);
				
			КонецЕсли;
			
		ИначеЕсли ДокументооборотПраваДоступа.ЭтоПапка(ТипЭлемента) Тогда
			
			Если ДопСведения = "ОбновитьПраваСодержимогоПапки" Тогда
				ДокументооборотПраваДоступа.ОбновитьПраваПоПапке(
					Ссылка,
					Истина); // Немедленно
			ИначеЕсли ДопСведения = "ПереопределитьПраваСодержимогоПапки" Тогда
				ДокументооборотПраваДоступа.ПереопределитьДескрипторыЗависимыхОбъектов(
					Ссылка,
					Истина); // Немедленно
			КонецЕсли;
			
		Иначе
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Неизвестная запись очереди обновления прав.
					|Ссылка: %1'
					|Доп. сведения: %2;
					|en = 'Unrecognized permissions update queue record.
					|Reference: %1'"),
				Ссылка, ДопСведения);
			
			ВызватьИсключение ТекстОшибки
			
		КонецЕсли;
		
	Исключение
		
		ЕстьОшибки = Истина;
		
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		Если ОбработанныеЭлементы <> Неопределено Тогда
			
			ИдентификаторОМ = Неопределено;
			Если ТипЭлемента = Тип("СправочникСсылка.ДескрипторыДоступаОбъектов") Тогда
				ИдентификаторОМ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИдентификаторОбъектаМетаданных");
			Иначе
				ИдентификаторОМ = Ссылка.Метаданные();
			КонецЕсли;
			
			ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + Символы.ПС
				+ НСтр("ru = 'Объект метаданных: '; en = 'Metadata object: '") + ИдентификаторОМ + Символы.ПС
				+ НСтр("ru = 'Обрабатываемые элементы:'; en = 'Processed elements:'");
				
			Для Каждого Эл Из ОбработанныеЭлементы Цикл
				ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + Эл;
			КонецЦикла;
			
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Права доступа'; en = 'Permissions'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Ссылка.Метаданные(),
			Ссылка,
			ОписаниеОшибки);
			
	КонецПопытки;
	
	ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = СтарыйПриоритет;

	// Удаление обработанных элементов очереди
	Если ОбработанныеЭлементы = Неопределено Или ЕстьОшибки Тогда
		
		// Обработан только элемент Ссылка
		Удалить(Ссылка, ДопСведения);
		
	Иначе
		
		Удалить(ОбработанныеЭлементы, ДопСведения);
		
		Если ОбработанныеВТекущейИтерации <> Неопределено Тогда
			Для Каждого Эл Из ОбработанныеЭлементы Цикл
				ОбработанныеВТекущейИтерации.Вставить(Эл, Истина);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры	

// Очищает всю очередь - удаляет все записи,
// кроме ссылок на перечисление ЗаданияОчередиОбновленияПрав
// 
Процедура Очистить(ОставитьЗаписиСПустойДатой = Истина) Экспорт
	
	Набор = РегистрыСведений.ОчередьОбновленияПравДоступа.СоздатьНаборЗаписей();
	
	Если ОставитьЗаписиСПустойДатой Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ОчередьОбновленияПравДоступа.Объект,
			|	ОчередьОбновленияПравДоступа.Приоритет,
			|	ОчередьОбновленияПравДоступа.ДатаВМиллиСекундах,
			|	ОчередьОбновленияПравДоступа.Дата
			|ИЗ
			|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Перечисление.ЗаданияОчередиОбновленияПрав КАК ЗаданияОчередиОбновленияПрав
			|		ПО ОчередьОбновленияПравДоступа.Объект = ЗаданияОчередиОбновленияПрав.Ссылка");
		
		ТаблицаНабора = Запрос.Выполнить().Выгрузить();
		Набор.Загрузить(ТаблицаНабора);
		
	КонецЕсли;
	
	Набор.Записать();
	
КонецПроцедуры

// Возвращает Истина если указанный объект (например, дескриптор)
// стоит в очереди на обработку
Функция ОбъектВОчереди(Объект) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК ЕстьЗаписи
		|ИЗ
		|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
		|ГДЕ
		|	ОчередьОбновленияПравДоступа.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	ЕстьЗаписи = Не Результат.Пустой();
	
	Возврат ЕстьЗаписи;
	
КонецФункции	

// Возвращает размер очереди
Функция РазмерОчереди(Приоритет = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Если Приоритет = Неопределено Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(*) Как ЧислоЗаписей
			|ИЗ
			|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа";
	Иначе
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(*) Как ЧислоЗаписей
			|ИЗ
			|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
			|ГДЕ	
			|	ОчередьОбновленияПравДоступа.Приоритет = &Приоритет";
			
		Запрос.УстановитьПараметр("Приоритет", Приоритет);	
	КонецЕсли;

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ЧислоЗаписей;
	КонецЕсли;

	Возврат 0;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
	
Функция ЭтоДескриптор(ТипЭлемента)
	
	Если ТипЭлемента = Тип("СправочникСсылка.ДескрипторыДоступаОбъектов") 
		ИЛИ ТипЭлемента = Тип("СправочникСсылка.ДескрипторыДоступаРегистров") Тогда
		
		Возврат Истина;
		
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции

#КонецЕсли
