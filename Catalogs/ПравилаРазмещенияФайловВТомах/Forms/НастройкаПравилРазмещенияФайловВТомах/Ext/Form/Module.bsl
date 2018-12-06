﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокУсловий();
	ЕстьПустыеГруппыТомов = ЕстьПустыеГруппыТомовХраненияФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЕстьПустыеГруппыТомов Тогда
		
		Отказ = Истина;
		
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Нельзя настроить правила, т.к. некоторые группы томов пустые (%1). 
			|Создайте в пустых группах новые тома или перенесите в них тома из других групп.';
			|en = 'You cannot configure a rule, as some of volume groups are empty (%1). 
			|Create volumes in empty volume groups or move volumes there from other volume groups.'"),
			ИменаТомов);
			
		ПоказатьПредупреждение(,СтрокаСообщения);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ЕстьПустыеГруппыТомовХраненияФайлов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТомаХраненияФайлов.Родитель КАК Ссылка
		|ПОМЕСТИТЬ ВременнаяТаблицаРодителиТомов
		|ИЗ
		|	Справочник.ТомаХраненияФайлов КАК ТомаХраненияФайлов
		|ГДЕ
		|	ТомаХраненияФайлов.ЭтоГруппа = ЛОЖЬ
		|	И ТомаХраненияФайлов.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТомаХраненияФайлов.Ссылка
		|ИЗ
		|	Справочник.ТомаХраненияФайлов КАК ТомаХраненияФайлов
		|ГДЕ
		|	ТомаХраненияФайлов.ЭтоГруппа = ИСТИНА
		|	И (НЕ ТомаХраненияФайлов.Ссылка В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаРодителиТомов.Ссылка
		|				ИЗ
		|					ВременнаяТаблицаРодителиТомов))
		|	И ТомаХраненияФайлов.ПометкаУдаления = ЛОЖЬ";
		
	ТаблицаГрупп = Запрос.Выполнить().Выгрузить();
	
	ИменаТомов = "";
	Для Каждого СтрокаТаблицы Из ТаблицаГрупп Цикл
		
		Если Не ПустаяСтрока(ИменаТомов) Тогда
			ИменаТомов = ИменаТомов + ", ";
		КонецЕсли;
		
		ИменаТомов = ИменаТомов + """" + Строка(СтрокаТаблицы.Ссылка) + """";
		
	КонецЦикла;	
	
	Возврат ТаблицаГрупп.Количество() <> 0;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокУсловий()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Правила.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПравилаРазмещенияФайловВТомах.Ссылка,
		|	ПравилаРазмещенияФайловВТомах.Порядок КАК Порядок
		|ИЗ
		|	Справочник.ПравилаРазмещенияФайловВТомах КАК ПравилаРазмещенияФайловВТомах
		|ГДЕ
		|	ПравилаРазмещенияФайловВТомах.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Правило = Выборка.Ссылка.ПолучитьОбъект();
		НоваяСтрока = Правила.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Правило);
		НоваяСтрока.Изменен = Ложь;
		
		НоваяСтрока.НавигационнаяСсылкаНаУсловие = ПоместитьВоВременноеХранилище(Правило.Условие, УникальныйИдентификатор);
		
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Функция НайтиМаксимальныйПорядок()
	
	Порядок = 1;
	
	Для Каждого Условие Из Правила Цикл
		Порядок = ?(Порядок > Условие.Порядок, Порядок, Условие.Порядок);
	КонецЦикла;
	
	Возврат Порядок;
	
КонецФункции

&НаКлиенте
Функция ПорядокУникален(Порядок)
	
	Для Каждого Условие Из Правила Цикл
		Если Порядок = Условие.Порядок Тогда
			Возврат Ложь;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПравилаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	// Чтобы новое правило встало по порядку перед правилом "По умолчанию"
	Порядок = НайтиМаксимальныйПорядок() - 1; 
	Если Не ПорядокУникален(Порядок) И Правила.Количество() <> 0 Тогда
		Условие = Правила[Правила.Количество() - 1];
		Условие.Порядок = Условие.Порядок + 1;
		Условие.Изменен = Истина;
	КонецЕсли;
	
	ЕстьПравилоПоУмолчанию = ЕстьПравилоПоУмолчанию(Неопределено);
	
	ПараметрыОткрытия = Новый Структура("Ссылка, Комментарий, Наименование, ПредставлениеУсловия, ПометкаУдаления, ГруппаТомов, Порядок, НавигационнаяСсылкаНаУсловие, УникальныйИдентификаторФормыРодителя, Ответственный, ПоУмолчанию, ЕстьПравилоПоУмолчанию",
		Неопределено, "", "", "", Ложь, Неопределено,
		Порядок, "", УникальныйИдентификатор, Неопределено, Ложь, ЕстьПравилоПоУмолчанию);
		
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПравилаПередНачаломДобавленияПродолжение",
		ЭтотОбъект);
		
	ОткрытьФорму(
		"Справочник.ПравилаРазмещенияФайловВТомах.Форма.ФормаПравила",
		ПараметрыОткрытия,,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПередНачаломДобавленияПродолжение(КодВозврата, Параметры) Экспорт
	
	Если ТипЗнч(КодВозврата) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = Правила.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, КодВозврата);
	Модифицированность = Истина;
	Элементы.Правила.ТекущаяСтрока = Правила.Количество() - 2;
	НоваяСтрока.Изменен = Истина;
	СортироватьПравилаПоПорядку();
		
КонецПроцедуры

&НаКлиенте
Функция ЕстьПравилоПоУмолчанию(Ссылка)

	// Проверяем что есть правило ПоУмолчанию
	Для Каждого Строка Из Правила Цикл
		
		Если Ссылка <> Строка.Ссылка И Не Строка.ПометкаУдаления Тогда
			
			Если Строка.ПоУмолчанию Тогда
				Возврат Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;	
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура РедактированиеПравила()
	
	// Открываем форму для редактирования правила
	
	ТекущиеДанные = Элементы.Правила.ТекущиеДанные;
	
	ЕстьПравилоПоУмолчанию = ЕстьПравилоПоУмолчанию(ТекущиеДанные.Ссылка);
	
	ПараметрыОткрытия = Новый Структура("Ссылка, Комментарий, Наименование, ПредставлениеУсловия, ПометкаУдаления, ГруппаТомов, Порядок, НавигационнаяСсылкаНаУсловие, УникальныйИдентификаторФормыРодителя, Ответственный, ПоУмолчанию, ЕстьПравилоПоУмолчанию",
		ТекущиеДанные.Ссылка, ТекущиеДанные.Комментарий, ТекущиеДанные.Наименование, ТекущиеДанные.ПредставлениеУсловия, 
		ТекущиеДанные.ПометкаУдаления, ТекущиеДанные.ГруппаТомов, ТекущиеДанные.Порядок, 
		ТекущиеДанные.НавигационнаяСсылкаНаУсловие, УникальныйИдентификатор,
		ТекущиеДанные.Ответственный, ТекущиеДанные.ПоУмолчанию,
		ЕстьПравилоПоУмолчанию);
		
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РедактированиеПравилаПродолжение",
		ЭтотОбъект);
		
	ОткрытьФорму(
		"Справочник.ПравилаРазмещенияФайловВТомах.Форма.ФормаПравила",
		ПараметрыОткрытия,,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеПравилаПродолжение(КодВозврата, Параметры) Экспорт
	
	Если ТипЗнч(КодВозврата) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
		
	ЗаполнитьЗначенияСвойств(Элементы.Правила.ТекущиеДанные, КодВозврата);
	Элементы.Правила.ТекущиеДанные.Изменен = Истина;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РедактированиеПравила();
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	РедактированиеПравила();
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;	
	
	Отказ = Истина;
	
	Пометка = Элемент.ТекущиеДанные.ПометкаУдаления;
	
	Если Пометка Тогда 
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Cнять с ""%1"" пометку на удаление?'; en = 'Remove deletion mark from ""%1"" ?'"),
			Строка(Элемент.ТекущиеДанные.Наименование));
	Иначе
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить ""%1"" на удаление?'; en = 'Mark ""%1"" for deletion?'"),
			Строка(Элемент.ТекущиеДанные.Наименование));
	КонецЕсли;	
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Элемент", Элемент);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПравилаПередУдалениемПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчика);
		
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаПередУдалениемПродолжение(Результат, Параметры) Экспорт
	
	 Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;	
	
	Параметры.Элемент.ТекущиеДанные.ПометкаУдаления = НЕ Параметры.Элемент.ТекущиеДанные.ПометкаУдаления;
	Параметры.Элемент.ТекущиеДанные.Изменен = Истина;
	
	СтрокаВУдаленном = ПравилаУдаленные.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаВУдаленном, Параметры.Элемент.ТекущиеДанные);
	Строка = Правила.НайтиПоИдентификатору(Параметры.Элемент.ТекущаяСтрока);
	Правила.Удалить(Строка);
	
	Элементы.Правила.Обновить();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не Модифицированность
		Или Модифицированность И ВыполнитьЗапись() Тогда
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция ВыполнитьЗапись()
	
	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Идет заполнение очереди файлов на размещение. Пожалуйста, подождите...'; en = 'Filling of file queue is in progress. Please wait ...'"));
	
	ЕстьОшибки = Ложь;
	ЧислоВерсийПоставленныхВОчередь = ЗаписатьПравилаВБазу(ЕстьОшибки);
	
	Если ЕстьОшибки Тогда
		Состояние();
		Возврат Ложь;
	КонецЕсли;
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Закончено формирование очереди файлов (в очередь добавлено файлов: %1)'; en = 'Finished creation file queue (files added in queue: %1)'"),
		ЧислоВерсийПоставленныхВОчередь);
	Состояние(ТекстСообщения);
	Модифицированность = Ложь;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЗаписатьПравилаВБазу(ЕстьОшибки)
	
	// Проверяем что есть правило "ПоУмолчанию" и оно находится в конце списка правил
	ЕстьПравилоПоУмолчанию = Ложь;
	Порядок = -1;
	Для Каждого Строка Из Правила Цикл
		
		Если Не Строка.ПометкаУдаления И Строка.ПоУмолчанию Тогда
			ЕстьПравилоПоУмолчанию = Истина;
		КонецЕсли;
		
		Порядок = ?(Порядок > Строка.Порядок, Порядок, Строка.Порядок);
		
	КонецЦикла;	
	
	// Проверяется что правил больше одного
	ЧислоПравил = 0;
	Для Каждого Строка Из Правила Цикл
		Если Не Строка.ПометкаУдаления Тогда
			ЧислоПравил = ЧислоПравил + 1;
		КонецЕсли;
	КонецЦикла;	
	
	Если Не ЕстьПравилоПоУмолчанию И ЧислоПравил <> 0 Тогда
	
		Строка = Правила.Добавить();
		Строка.Наименование = НСтр("ru = 'По умолчанию'; en = 'Default'");
		Строка.Комментарий = НСтр("ru = 'Правило создано автоматически и используется для размещения файлов, которые не подходят ни под одно из настроенных правил'; en = 'The rule is created automatically and is used to place files that do not fit under any of the configured rules'");
		Строка.Ответственный = Пользователи.ТекущийПользователь();
		Строка.Порядок = Порядок + 1;
		Строка.ПоУмолчанию = Истина;
		
		СхемаКомпоновкиДанных = Справочники.ПравилаРазмещенияФайловВТомах.ПолучитьМакет("Версии");
		Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
		Строка.НавигационнаяСсылкаНаУсловие = ПоместитьВоВременноеХранилище(Новый ХранилищеЗначения(Настройки), УникальныйИдентификатор);
		
		ЧислоПравил = ЧислоПравил + 1;
		
	КонецЕсли;
	
	Если ЧислоПравил = 1 Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = НСтр("ru = 'Требуется указать минимум 2 правила, либо ни одного.'; en = 'You must specify at least 2 rules, or none.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Правила");
	КонецЕсли;
	
	// Проверяется, что в группе томов есть хоть один том.
	Для Каждого Строка Из Правила Цикл
		
		Если Не Строка.ПометкаУдаления Тогда
			
			Если Не ЗначениеЗаполнено(Строка.ГруппаТомов) Тогда
				ЕстьОшибки = Истина;
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для правила ""%1"" не указана группа томов.'; en = 'Volume group is not specified for rule ""%1"".'"), Строка.Наименование);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Правила");
			КонецЕсли;	
			
			ТаблицаТомов = РаботаСФайламиВызовСервера.ПолучитьТаблицуТомов(Строка.ГруппаТомов);
			Если ТаблицаТомов.Количество() = 0 Тогда
				ЕстьОшибки = Истина;
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В группе томов ""%1"" нет ни одного тома'; en = 'Volume group ""%1"" has no volumes'"), Строка.ГруппаТомов);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Правила");
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЦикла;	
	
	Если ЕстьОшибки Тогда
		Возврат 0;
	КонецЕсли;
	
	// Удаленные правила пишем отдельно
	Для Каждого Строка Из ПравилаУдаленные Цикл
		
		// Изменяем существующее правило
		Если Не Строка.Ссылка.Пустая() Тогда 
			
			Если Строка.Изменен Тогда
				
				ПравилоОбъект = Строка.Ссылка.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(ПравилоОбъект, Строка);
				
				Если ЗначениеЗаполнено(Строка.НавигационнаяСсылкаНаУсловие) Тогда
					ПравилоОбъект.Условие = ПолучитьИзВременногоХранилища(Строка.НавигационнаяСсылкаНаУсловие);
				КонецЕсли;
				
				ПравилоОбъект.Записать();
				
				Строка.Изменен = Ложь;
				
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЦикла;	
	
	Для Каждого Строка Из Правила Цикл
		
		// Создаем новое правило
		Если Строка.Ссылка.Пустая() Тогда 
			
			ПравилоОбъект = Справочники.ПравилаРазмещенияФайловВТомах.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(ПравилоОбъект, Строка);
			
			Если ЗначениеЗаполнено(Строка.НавигационнаяСсылкаНаУсловие) Тогда
				ПравилоОбъект.Условие = ПолучитьИзВременногоХранилища(Строка.НавигационнаяСсылкаНаУсловие);
			КонецЕсли;
			
			ПравилоОбъект.Записать();
			
		Иначе 
			
			// Изменяем существующее правило
			
			Если Строка.Изменен Тогда
				
				ПравилоОбъект = Строка.Ссылка.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(ПравилоОбъект, Строка);
				
				Если ЗначениеЗаполнено(Строка.НавигационнаяСсылкаНаУсловие) Тогда
					ПравилоОбъект.Условие = ПолучитьИзВременногоХранилища(Строка.НавигационнаяСсылкаНаУсловие);
				КонецЕсли;
				
				ПравилоОбъект.Записать();
				
				Строка.Изменен = Ложь;
				
			КонецЕсли;	
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат РаботаСФайламиВызовСервера.ПрименитьПравилаДляФормированияОчереди();
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПередЗакрытиемПродолжение",
			ЭтотОбъект);
		ПоказатьВопрос(
			ОписаниеОповещения,
			НСтр("ru = 'Правила были изменены. Сохранить изменения?'; en = 'The rules were changed. Save changes?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПродолжение(КодВозврата, Параметры) Экспорт
	
	Если КодВозврата <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	Если ВыполнитьЗапись() Тогда
		Закрыть();
	КонецЕсли;			
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	ДанныеСтроки = Правила.НайтиПоИдентификатору(Элементы.Правила.ТекущаяСтрока);
	
	ИндексТекущий = Правила.Индекс(ДанныеСтроки);
	Если ИндексТекущий > 0 Тогда
		
		ИндексПредыдущий = ИндексТекущий - 1;
		ДанныеСтрокиПредыдущей = Правила[ИндексПредыдущий];
		
		ПорядокПредыдущий = ДанныеСтрокиПредыдущей.Порядок;
		ДанныеСтрокиПредыдущей.Порядок = ДанныеСтроки.Порядок;
		ДанныеСтроки.Порядок = ПорядокПредыдущий;
		ДанныеСтрокиПредыдущей.Изменен = Истина;
		ДанныеСтроки.Изменен = Истина;
		
		СортироватьПравилаПоПорядку();
		Модифицированность = Истина;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	ДанныеСтроки = Правила.НайтиПоИдентификатору(Элементы.Правила.ТекущаяСтрока);
	
	ИндексТекущий = Правила.Индекс(ДанныеСтроки);
	Если ИндексТекущий < Правила.Количество()-1 Тогда
		
		ИндексСледующий = ИндексТекущий + 1;
		ДанныеСтрокиСледующей = Правила[ИндексСледующий];
		
		ПорядокСледующий = ДанныеСтрокиСледующей.Порядок;
		ДанныеСтрокиСледующей.Порядок = ДанныеСтроки.Порядок;
		ДанныеСтроки.Порядок = ПорядокСледующий;
		ДанныеСтрокиСледующей.Изменен = Истина;
		ДанныеСтроки.Изменен = Истина;
		
		СортироватьПравилаПоПорядку();
		Модифицированность = Истина;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПравилаПоПорядку()
	Правила.Сортировать("Порядок Возр");
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПравила(Команда)
	
	ПараметрыФормы = Новый Структура("Правила", Правила);
	ОткрытьФорму(
		"Справочник.ПравилаРазмещенияФайловВТомах.Форма.ПроверкаПравил",
		ПараметрыФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры


