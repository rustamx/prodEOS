﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СпособОбновленияПрав = 2;
	ТекущийЭлемент = Элементы.СпособОбновленияПравВыборочное;
	
	// Добавление всех объектов в таблицу
    ТипыВладельцев = ДокументооборотПраваДоступаПовтИсп.ТипыОбъектовИспользующихДоступПоДескрипторам();
    Для Каждого Тип Из ТипыВладельцев Цикл
		
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип);
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
			МетаданныеОбъекта.ПолноеИмя());
		
		Строка = ОбъектыДляОбновленияПрав.Добавить();
		Строка.ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
		Строка.ВидОбъекта = ОбщегоНазначения.ВидОбъектаПоСсылке(МенеджерОбъекта.ПолучитьСсылку());
		Строка.ПредставлениеОбъекта = МетаданныеОбъекта.Представление() + " (" + Строка.ВидОбъекта + ")";
		
    КонецЦикла;
	
	// Добавление регистров
    ТипыВладельцев = Метаданные.ПодпискиНаСобытия.ДокументооборотПраваДоступаПередЗаписьюНабораЗаписей.Источник.Типы(); 
    Для Каждого Тип Из ТипыВладельцев Цикл 

		МетаданныеРегистра = Метаданные.НайтиПоТипу(Тип);
		
		Строка = ОбъектыДляОбновленияПрав.Добавить();
		Строка.ПолноеИмяОбъекта = МетаданныеРегистра.ПолноеИмя(); 
		Строка.ВидОбъекта = НСтр("ru = 'Регистр'; en = 'Register'");
		Строка.ПредставлениеОбъекта = МетаданныеРегистра.Представление() + " (" + Строка.ВидОбъекта + ")";
		
	КонецЦикла;
	
	ОбъектыДляОбновленияПрав.Сортировать("ПредставлениеОбъекта");
	
	// Заполнение строк отбора
	СтрОтбора = ТаблицаОтборов.Добавить();
	СтрОтбора.Имя = "Организации";
	СтрОтбора.Представление = НСтр("ru = 'Организации'; en = 'Companies'");
	ЭлементыОтбора = Новый СписокЗначений;
	ЭлементыОтбора.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
	СтрОтбора.ПравоеЗначение = ЭлементыОтбора;
	
	СтрОтбора = ТаблицаОтборов.Добавить();
	СтрОтбора.Имя = "ВидыДокументов";
	СтрОтбора.Представление = НСтр("ru = 'Виды документов'; en = 'Document types'");
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.ВидыВнутреннихДокументов"));
	МассивТипов.Добавить(Тип("СправочникСсылка.ВидыВходящихДокументов"));
	МассивТипов.Добавить(Тип("СправочникСсылка.ВидыИсходящихДокументов"));
	ЭлементыОтбора = Новый СписокЗначений;
	ЭлементыОтбора.ТипЗначения = Новый ОписаниеТипов(МассивТипов);
	СтрОтбора.ПравоеЗначение = ЭлементыОтбора;
	
	СтрОтбора = ТаблицаОтборов.Добавить();
	СтрОтбора.Имя = "ГрифыДоступа";
	СтрОтбора.Представление = НСтр("ru = 'Грифы доступа'; en = 'Security levels'");
	ЭлементыОтбора = Новый СписокЗначений;
	ЭлементыОтбора.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ГрифыДоступа");
	СтрОтбора.ПравоеЗначение = ЭлементыОтбора;
	
	СтрОтбора = ТаблицаОтборов.Добавить();
	СтрОтбора.Имя = "ГруппыДоступаКонтрагентов";
	СтрОтбора.Представление = НСтр("ru = 'Группы доступа контрагентов'; en = 'Counterparties access groups'");
	ЭлементыОтбора = Новый СписокЗначений;
	ЭлементыОтбора.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ГруппыДоступаКонтрагентов");
	СтрОтбора.ПравоеЗначение = ЭлементыОтбора;
	
	СтрОтбора = ТаблицаОтборов.Добавить();
	СтрОтбора.Имя = "ВопросыДеятельности";
	СтрОтбора.Представление = НСтр("ru = 'Вопросы деятельности'; en = 'Activity types'");
	ЭлементыОтбора = Новый СписокЗначений;
	ЭлементыОтбора.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ВопросыДеятельности");
	СтрОтбора.ПравоеЗначение = ЭлементыОтбора;
	
	СтрОтбора = ТаблицаОтборов.Добавить();
	СтрОтбора.Имя = "Папки";
	СтрОтбора.Представление = НСтр("ru = 'Папки'; en = 'Folders'");
	ЭлементыОтбора = Новый СписокЗначений;
	ЭлементыОтбора.ТипЗначения = Метаданные.ОпределяемыеТипы.Папки.Тип;
	СтрОтбора.ПравоеЗначение = ЭлементыОтбора;
	
	// ТСК Талько Э.Г.; 09.06.2018; Управление доступом {
	СтрОтбора = ТаблицаОтборов.Добавить();
	СтрОтбора.Имя = "Подразделения";
	СтрОтбора.Представление = НСтр("ru = 'Подразделения'; en = 'Departments'");
	ЭлементыОтбора = Новый СписокЗначений;
	ЭлементыОтбора.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
	СтрОтбора.ПравоеЗначение = ЭлементыОтбора;
	
	СтрОтбора = ТаблицаОтборов.Добавить();
	СтрОтбора.Имя = "ра_Организации";
	СтрОтбора.Представление = НСтр("ru = 'Организации (документы качества)'; en = 'Organizations (quality documents)'");
	ЭлементыОтбора = Новый СписокЗначений;
	ЭлементыОтбора.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	СтрОтбора.ПравоеЗначение = ЭлементыОтбора;
	// ТСК Талько Э.Г.; 09.06.2018; Управление доступом }
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ТипВыбранногоЗначения = ТипЗнч(ВыбранноеЗначение);
	Если ТипВыбранногоЗначения = Тип("СправочникСсылка.Организации") Тогда
		
		Для Каждого Стр Из ТаблицаОтборов Цикл
			Если Стр.Имя = "Организации" Тогда
				Сообщить("!");
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Стр.Элементы.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
			Стр.Элементы.Добавить(ВыбранноеЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбъектыДляОбновленияПрав

&НаКлиенте
Процедура ОбъектыДляОбновленияПравВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ОбъектыДляОбновленияПрав.ТекущиеДанные;
	ТекущиеДанные.Обновить = Не ТекущиеДанные.Обновить;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаОтборов

&НаКлиенте
Процедура ТаблицаОтборовПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаОтборов.ТекущиеДанные;
	ЗапрещеноМенятьПравоеЗначение = ТекущиеДанные.Имя = "ТолькоСРабочейГруппой";
	Если Элементы.ТаблицаОтборовПравоеЗначение.ТолькоПросмотр <> ЗапрещеноМенятьПравоеЗначение Тогда
		Элементы.ТаблицаОтборовПравоеЗначение.ТолькоПросмотр = ЗапрещеноМенятьПравоеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтборовПравоеЗначениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаОтборов.ТекущиеДанные;
	Если ТекущиеДанные.ПравоеЗначение.Количество() > 0 Тогда
		ТекущиеДанные.Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтборовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Элементы.ТаблицаОтборов.ТекущийЭлемент = Элементы.ТаблицаОтборовПравоеЗначение Тогда
		ТекущиеДанные = Элементы.ТаблицаОтборов.ТекущиеДанные;
		Если ТекущиеДанные.ПравоеЗначение.Количество() = 0 Тогда
			ТекущиеДанные.Пометка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Вперед(Команда)
	
	ПеревернутьСтраницу(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ПеревернутьСтраницу(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсеОбъекты(Команда)
	
	Для Каждого Строка Из ОбъектыДляОбновленияПрав Цикл
		Строка.Обновить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделениеСоВсехОбъектов(Команда)
	
	Для Каждого Строка Из ОбъектыДляОбновленияПрав Цикл
		Строка.Обновить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсеОтборы(Команда)
	
	Для Каждого Строка Из ТаблицаОтборов Цикл
		Строка.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделениеСоВсехОтборов(Команда)
	
	Для Каждого Строка Из ТаблицаОтборов Цикл
		Строка.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПеревернутьСтраницу(Вперед)
	
	ПоследовательностьСтраниц = Новый Массив;
	ПоследовательностьСтраниц.Добавить(Элементы.СтраницаВыборВидаОбновления);
	Если СпособОбновленияПрав = 1 Тогда
		ПоследовательностьСтраниц.Добавить(Элементы.СтраницаПолноеОбновлениеПредупреждение);
		ПоследовательностьСтраниц.Добавить(Элементы.СтраницаПолноеОбновлениеОкончание);
	Иначе
		ПоследовательностьСтраниц.Добавить(Элементы.СтраницаВыборочноеОбновлениеОбъекты);
		ПоследовательностьСтраниц.Добавить(Элементы.СтраницаВыборочноеОбновлениеОтбор);
		ПоследовательностьСтраниц.Добавить(Элементы.СтраницаВыборочноеОбновлениеПредупреждение);
		ПоследовательностьСтраниц.Добавить(Элементы.СтраницаВыборочноеОбновлениеОкончание);
	КонецЕсли;
	
	МаксимальныйИндекс = ПоследовательностьСтраниц.ВГраница();
	ИндексТекущейСтраницы = ПоследовательностьСтраниц.Найти(Элементы.СтраницыФормы.ТекущаяСтраница);
	ИндексНовойСтраницы = ИндексТекущейСтраницы + ?(Вперед, 1, -1);
	
	Если Не Вперед И ИндексТекущейСтраницы = МаксимальныйИндекс Тогда
		// При переходе с последней страницы назад не показываем страницу с предупреждением.
		ИндексНовойСтраницы = ИндексТекущейСтраницы - 2;
	КонецЕсли;
	
	Если ИндексТекущейСтраницы = МаксимальныйИндекс И Вперед Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ДействияПередСменойСтраницы(Вперед, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СтраницыФормы.ТекущаяСтраница = ПоследовательностьСтраниц[ИндексНовойСтраницы];
	
	// Заголовок формы
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборВидаОбновления Тогда
		Заголовок = НСтр("ru = 'Обновление прав доступа'; en = 'Permissions update'");
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаПолноеОбновлениеПредупреждение Тогда
		Заголовок = НСтр("ru = 'Полное обновление прав'; en = 'Complete permissions update'");
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборочноеОбновлениеОбъекты Тогда
		Заголовок = НСтр("ru = 'Объекты'; en = 'Objects'");
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборочноеОбновлениеОтбор Тогда
		Заголовок = НСтр("ru = 'Отборы'; en = 'Filters'");
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборочноеОбновлениеПредупреждение Тогда
		Заголовок = НСтр("ru = 'Выборочное обновление'; en = 'Selective updating'");
	КонецЕсли;
	
	// Вид обновления
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборВидаОбновления Тогда
		Если СпособОбновленияПрав = 1 Тогда
			ТекущийЭлемент = Элементы.СпособОбновленияПравПолное;
		Иначе
			ТекущийЭлемент = Элементы.СпособОбновленияПравВыборочное;
		КонецЕсли;
	КонецЕсли;
	
	// Кнопка Назад
	Если ИндексНовойСтраницы = 0 Тогда
		Элементы.Назад.Видимость = Ложь;
	ИначеЕсли ИндексНовойСтраницы = 1 Тогда
		Элементы.Назад.Видимость = Истина;
	КонецЕсли;
	
	// Кнопка Далее
	Если ИндексНовойСтраницы = МаксимальныйИндекс Тогда
		Элементы.Вперед.Заголовок = НСтр("ru = 'Закрыть'; en = 'Close'");
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаПолноеОбновлениеПредупреждение Тогда
		Элементы.Вперед.Заголовок = НСтр("ru = 'Я уверен'; en = 'I am sure'");
	Иначе
		Элементы.Вперед.Заголовок = НСтр("ru = 'Далее >'; en = 'Next >'");
	КонецЕсли;
		
	// Кнопка Отмена
	Если ИндексНовойСтраницы = МаксимальныйИндекс Тогда	
		Элементы.Отмена.Видимость = Ложь;
	ИначеЕсли Не Вперед И ИндексТекущейСтраницы = МаксимальныйИндекс Тогда
		Элементы.Отмена.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПередСменойСтраницы(Вперед, Отказ)
	
	Если Вперед
		И Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаПолноеОбновлениеПредупреждение Тогда
		
		ОбновитьПризнакОтложенногоОбновления();
	 	ДокументооборотПраваДоступаКлиент.ОбновитьВсеПрава(ОтложенноеОбновлениеПрав);
		
		Если ОтложенноеОбновлениеПрав Тогда
			Элементы.ПолноеОбновлениеОкончание.Заголовок = 
				НСтр("ru = 'Задания на очистку и обновление прав записаны.
					|Права будут обновлены в фоновом режиме.';
					|en = 'Tasks of cleaning up and updating of the rights has been added.
					|Permissions will be updated in the background.'");
		Иначе
			Элементы.ПолноеОбновлениеОкончание.Заголовок = 
				НСтр("ru = 'Обновление прав доступа для всех данных информационной базы завершено.'; en = 'Update permissions for all data complete.'");
		КонецЕсли;
		
	ИначеЕсли Вперед
		И Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборочноеОбновлениеОбъекты Тогда
		
	 	ЕстьВыбранныеОбъекты = 
			ОбъектыДляОбновленияПрав.НайтиСтроки(Новый Структура("Обновить", Истина)).Количество() > 0;
		
		Если Не ЕстьВыбранныеОбъекты Тогда
			
			ПоказатьПредупреждение(, НСтр("ru = 'Не отмечено ни одного объекта.'; en = 'No marked objects'"));
			Отказ = Истина;
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли Вперед
		И Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборочноеОбновлениеОтбор Тогда
		
		Если ОтложенноеОбновлениеПрав Тогда
			СкоростьРасчетаПрав = 5; // Дескр/сек
		Иначе
			СкоростьРасчетаПрав = 2; // Дескр/сек
		КонецЕсли;
		
		КоличествоДескрипторовКОбновлению = КоличествоДескрипторовКОбновлению();
		ПрогнозируемоеВремяВСекундах = Окр(КоличествоДескрипторовКОбновлению / СкоростьРасчетаПрав);
		ПрогнозируемоеВремяСтрокой = ВремяОбновленияСтрокой(ПрогнозируемоеВремяВСекундах);
		
		Если ОтложенноеОбновлениеПрав Тогда
			Элементы.ВыборочноеОбновлениеПредупреждение.Заголовок = СтрШаблон(
				НСтр("ru = 'В очередь будет записано %1 заданий на пересчет прав.
					|Расчет очереди займет около %2.';
					|en = '%1 items for permissions recalculating will be added to the queue. 
					|Calculation will take approximately %2.'"),
				КоличествоДескрипторовКОбновлению, ПрогнозируемоеВремяСтрокой);
		Иначе
			Элементы.ВыборочноеОбновлениеПредупреждение.Заголовок = СтрШаблон(
				НСтр("ru = 'Будет обработано %1 заданий на пересчет прав.
					|Расчет займет около %2.';
					|en = '%1 items for permissions recalculating will perfomed.
					|Calculation will take approximately %2.'"),
				КоличествоДескрипторовКОбновлению, ПрогнозируемоеВремяСтрокой);
		КонецЕсли;
		
	ИначеЕсли Вперед
		И Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборочноеОбновлениеПредупреждение Тогда
		
		ОбновитьПризнакОтложенногоОбновления();
		
		Состояние(НСтр("ru = 'Выполняется обновление прав доступа для выбранных объектов. 
			|Пожалуйста, подождите...';
			|en = 'Updating permissions for the selected objects. 
			|Please wait ...'"));
			
		ДатаНачала = ТекущаяДата();
		КоличествоДескрипторовКОбновлению = ВыполнитьВыборочноеОбновлениеПрав();
		ДатаОкончания = ТекущаяДата();
		
		Состояние();
		
		Если ОтложенноеОбновлениеПрав Тогда
			Элементы.ВыборочноеОбновлениеОкончание.Заголовок = СтрШаблон(
				НСтр("ru = 'Обработка выбранных объектов завершена.
					|Сформирована очередь обновления прав доступа (%2 заданий).';
					|en = 'Processing of selected objects complete.
					|Formed permissions update queue (%2).'"), 
				ДатаОкончания - ДатаНачала, КоличествоДескрипторовКОбновлению);
		Иначе
			Элементы.ВыборочноеОбновлениеОкончание.Заголовок = СтрШаблон(
				НСтр("ru = 'Обновление прав доступа выбранных объектов завершено (%1 сек).'; en = 'Permissions update to selected objects completed (%1 sec).'"),
				ДатаОкончания - ДатаНачала);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПризнакОтложенногоОбновления()
	
	ОтложенноеОбновлениеПрав = 
		Константы.ДокументооборотИспользоватьОтложенноеОбновлениеПравДоступа.Получить();
	
КонецПроцедуры

&НаСервере
Функция КоличествоДескрипторовКОбновлению()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СУММА(ВложенныйЗапрос.КолОбъектов) КАК КолОбъектов
		|ИЗ
		|	(ВЫБРАТЬ
		|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДескрипторыДоступаОбъектов.Ссылка) КАК КолОбъектов
		|	ИЗ
		|		Справочник.ДескрипторыДоступаОбъектов КАК ДескрипторыДоступаОбъектов
		|%ТекстСоединений%
		|	ГДЕ
		|		ДескрипторыДоступаОбъектов.ИдентификаторОбъектаМетаданных В(&ВыбранныеОбъекты)
		|%ТекстДопУсловий%
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДескрипторыДоступаРегистров.Ссылка)
		|	ИЗ
		|		Справочник.ДескрипторыДоступаРегистров КАК ДескрипторыДоступаРегистров
		|	ГДЕ
		|		ДескрипторыДоступаРегистров.ОбъектМетаданных В(&ВыбранныеОбъекты)) КАК ВложенныйЗапрос");
		
	ДополнитьЗапросВСоответствииСОтборами(Запрос);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.КолОбъектов;
	
КонецФункции

&НаСервере
Функция ВыполнитьВыборочноеОбновлениеПрав()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДескрипторыДоступаОбъектов.Ссылка
		|ИЗ
		|	Справочник.ДескрипторыДоступаОбъектов КАК ДескрипторыДоступаОбъектов
		|%ТекстСоединений%
		|ГДЕ
		|	ДескрипторыДоступаОбъектов.ИдентификаторОбъектаМетаданных В (&ВыбранныеОбъекты)
		|%ТекстДопУсловий%
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДескрипторыДоступаРегистров.Ссылка
		|ИЗ
		|	Справочник.ДескрипторыДоступаРегистров КАК ДескрипторыДоступаРегистров
		|ГДЕ
		|	ДескрипторыДоступаРегистров.ОбъектМетаданных В(&ВыбранныеОбъекты)");
		
	ДополнитьЗапросВСоответствииСОтборами(Запрос);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекущийПриоритетОчередиОбновленияПрав = ПараметрыСеанса.ПриоритетОчередиОбновленияПрав;
	ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = 2; // Долгая очередь
	Попытка
		
		Пока Выборка.Следующий() Цикл
			ДокументооборотПраваДоступа.ОбновитьПраваДоступаПоДескриптору(Выборка.Ссылка);
		КонецЦикла;
		
	Исключение
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = ТекущийПриоритетОчередиОбновленияПрав;
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Выборка.Количество();
	
КонецФункции

&НаСервере
Процедура ДополнитьЗапросВСоответствииСОтборами(Запрос)
	
	ТекстДопУсловий = "";
	ТекстСоединений = "";
	
	ВыбранныеСтрокиОбъектов = ОбъектыДляОбновленияПрав.НайтиСтроки(Новый Структура("Обновить", Истина));
	ВыбранныеСтрокиОтбора = ТаблицаОтборов.НайтиСтроки(Новый Структура("Пометка", Истина));
	
	ВыбранныеОбъекты = Новый Массив;
	Для Каждого СтрокаОбъекта Из ВыбранныеСтрокиОбъектов Цикл
 		ВыбранныеОбъекты.Добавить(
			ОбщегоНазначения.ИдентификаторОбъектаМетаданных(СтрокаОбъекта.ПолноеИмяОбъекта));
 	КонецЦикла;
	
	Запрос.УстановитьПараметр("ВыбранныеОбъекты", ВыбранныеОбъекты);
	
	Для Каждого СтрокаОтбора Из ВыбранныеСтрокиОтбора Цикл
		
		Если СтрокаОтбора.Имя = "Организации" Тогда
			
			ПравоеЗначение = СтрокаОтбора.ПравоеЗначение.Скопировать();
			ПравоеЗначение.Добавить(Справочники.Организации.ПустаяСсылка());
			
			ТекстДопУсловий = ТекстДопУсловий + 
				"	И (ДескрипторыДоступаОбъектов.Организация В (&Организации))";
				
			Запрос.УстановитьПараметр("Организации", ПравоеЗначение);
			
		// ТСК Талько Э.Г.; 09.06.2018; Управление доступом {
		ИначеЕсли СтрокаОтбора.Имя = "Подразделения" Тогда
			
			ПравоеЗначение = СтрокаОтбора.ПравоеЗначение.Скопировать();
			ПравоеЗначение.Добавить(Неопределено);
			
			ТекстДопУсловий = ТекстДопУсловий + 
				"	И (ДескрипторыДоступаОбъектов.Подразделение В (&Подразделения))";
				
			Запрос.УстановитьПараметр("Подразделения", ПравоеЗначение);
			
		ИначеЕсли СтрокаОтбора.Имя = "ра_Организации" Тогда
			
			ПравоеЗначение = СтрокаОтбора.ПравоеЗначение.Скопировать();
			ПравоеЗначение.Добавить(Неопределено);
			
			ТекстДопУсловий = ТекстДопУсловий + 
				"	И (ДескрипторыДоступаОбъектов.ра_Организация В (&Организации))";
				
			Запрос.УстановитьПараметр("Организации", ПравоеЗначение);
			
		// ТСК Талько Э.Г.; 09.06.2018; Управление доступом }
		ИначеЕсли СтрокаОтбора.Имя = "ВидыДокументов" Тогда
			
			ПравоеЗначение = СтрокаОтбора.ПравоеЗначение.Скопировать();
			ПравоеЗначение.Добавить(Неопределено);
			
			ТекстДопУсловий = ТекстДопУсловий + 
				"	И (ДескрипторыДоступаОбъектов.ВидОбъекта В (&ВидыДокументов))";
				
			Запрос.УстановитьПараметр("ВидыДокументов", ПравоеЗначение);
			
		ИначеЕсли СтрокаОтбора.Имя = "ГрифыДоступа" Тогда
			
			ПравоеЗначение = СтрокаОтбора.ПравоеЗначение.Скопировать();
			ПравоеЗначение.Добавить(Справочники.ГрифыДоступа.ПустаяСсылка());
			
			ТекстДопУсловий = ТекстДопУсловий + 
				"	И (ДескрипторыДоступаОбъектов.ГрифДоступа В (&ГрифыДоступа))";
				
			Запрос.УстановитьПараметр("ГрифыДоступа", ПравоеЗначение);
			
		ИначеЕсли СтрокаОтбора.Имя = "ГруппыДоступаКонтрагентов" Тогда
			
			ПравоеЗначение = СтрокаОтбора.ПравоеЗначение.Скопировать();
			ПравоеЗначение.Добавить(Неопределено);
			
			ТекстСоединений = ТекстСоединений +
				"	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДескрипторыДоступаОбъектов.Контрагенты КАК ТЧКонтрагенты
				|	ПО ТЧКонтрагенты.Ссылка = ДескрипторыДоступаОбъектов.Ссылка
				|";
				
			ТекстДопУсловий = ТекстДопУсловий + 
				"	И (ЕстьNull(ТЧКонтрагенты.ГруппаДоступа, Неопределено) В (&ГруппыДоступаКонтрагентов))";
				
			Запрос.УстановитьПараметр("ГруппыДоступаКонтрагентов", ПравоеЗначение);
			
		ИначеЕсли СтрокаОтбора.Имя = "ВопросыДеятельности" Тогда
			
			ПравоеЗначение = СтрокаОтбора.ПравоеЗначение.Скопировать();
			ПравоеЗначение.Добавить(Справочники.ВопросыДеятельности.ПустаяСсылка());
			
			ТекстДопУсловий = ТекстДопУсловий + 
				"	И (ДескрипторыДоступаОбъектов.ВопросДеятельности В (&ВопросыДеятельности))";
				
			Запрос.УстановитьПараметр("ВопросыДеятельности", ПравоеЗначение);
			
		ИначеЕсли СтрокаОтбора.Имя = "Папки" Тогда
			
			ТекстЗапросаДляОтбораПоПапкам = 
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ДескрипторыДляОбъектов.Дескриптор
				|ПОМЕСТИТЬ ДескрпиторыОтобранныеПоПапкам
				|ИЗ
				|	РегистрСведений.ДескрипторыДляОбъектов КАК ДескрипторыДляОбъектов
				|ГДЕ
				|	ДескрипторыДляОбъектов.Объект В ИЕРАРХИИ (&Папки)
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ДескрипторыДляОбъектов.Дескриптор
				|ИЗ
				|	РегистрСведений.ДескрипторыДляОбъектов КАК ДескрипторыДляОбъектов
				|ГДЕ
				|	ДескрипторыДляОбъектов.Объект.Папка В ИЕРАРХИИ (&Папки)";
			
			Запрос.Текст = 
				ТекстЗапросаДляОтбораПоПапкам + ОбщегоНазначения.РазделительПакетаЗапросов() + Запрос.Текст;
			
			ТекстСоединений = ТекстСоединений +
				"	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДескрпиторыОтобранныеПоПапкам КАК ДескрпиторыОтобранныеПоПапкам
				|	ПО ДескрпиторыОтобранныеПоПапкам.Дескриптор = ДескрипторыДоступаОбъектов.Ссылка
				|";
				
			Запрос.УстановитьПараметр("Папки", СтрокаОтбора.ПравоеЗначение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ТекстСоединений%", ТекстСоединений);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ТекстДопУсловий%", ТекстДопУсловий);
	
КонецПроцедуры

&НаКлиенте
Функция ВремяОбновленияСтрокой(СекундВсего)
	
	Часов  = Цел(СекундВсего / 3600);
	Минут  = Цел((СекундВсего - Часов * 3600) / 60);
	Секунд = СекундВсего - Часов * 3600 - Минут * 60;
	
	Если Секунд > 10 Тогда
		// Округление до минут в большую сторону.
		Минут = Минут + 1;
	КонецЕсли;
	
	Результат = ?(Часов > 0, Строка(Часов) + " " + НСтр("ru = 'ч'; en = 'h'") + " ", "") +
		Строка(Минут) + " " + НСтр("ru = 'мин'; en = 'min'");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
