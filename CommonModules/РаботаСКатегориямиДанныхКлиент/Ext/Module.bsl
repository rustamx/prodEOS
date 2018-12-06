﻿//Раскрывает указанные элементы дерева
//Параметры:ДеревоЭлемент - элемент формы, отображающий дерево категорий
//			ДеревоРеквизит - реквизит формы типа ДеревоЗначений, содержащий дерево категорий
//			СписокКатегорийДляРазвертывания - список категорий, которые необходимо развернуть в дереве
Процедура УстановитьРазвернутостьЭлементовДерева(ДеревоЭлемент, ДеревоРеквизит, СписокКатегорийДляРазвертывания) Экспорт
	
	Если СписокКатегорийДляРазвертывания <> Неопределено Тогда
		Для Каждого ЭлементСписка Из СписокКатегорийДляРазвертывания Цикл
			Индекс = -1;
			РаботаСКатегориямиДанныхКлиентСервер.НайтиКатегориюВДеревеПоСсылке(ДеревоРеквизит.ПолучитьЭлементы(), ЭлементСписка.Значение, Индекс);
			Если Индекс > -1 Тогда
				Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьЭлементы().Количество() > 0 Тогда
					ДеревоЭлемент.Развернуть(ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьИдентификатор(), Ложь);
				Иначе
					Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьРодителя() <> Неопределено Тогда
						ДеревоЭлемент.Развернуть(ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьРодителя().ПолучитьИдентификатор(), Ложь);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

//Формирует список раскрытых элементов дерева категорий
//Параметры:ДеревоЭлемент - элемент формы, отображающий дерево категорий
//			СписокРаскрытыхКатегорий - список, который содержит раскрытые элементы дерева категорий
Процедура ПолучитьМассивРаскрытыхКатегорий(ДеревоЭлемент, МассивСтрокОдногоУровня, СписокРаскрытыхКатегорий) Экспорт
	
	Для Каждого СтрокаОдногоУровня Из МассивСтрокОдногоУровня Цикл
		ИдКатегории = СтрокаОдногоУровня.ПолучитьИдентификатор();
		Если ДеревоЭлемент.Развернут(ИдКатегории) <> Неопределено 
			И ДеревоЭлемент.Развернут(ИдКатегории) Тогда
			СписокРаскрытыхКатегорий.Добавить(СтрокаОдногоУровня.Ссылка);
		КонецЕсли;
		ПолучитьМассивРаскрытыхКатегорий(ДеревоЭлемент, СтрокаОдногоУровня.ПолучитьЭлементы(), СписокРаскрытыхКатегорий);
	КонецЦикла;
	
КонецПроцедуры

//Устанавливает признак "выбрана" у указанных элементов дерева
//Параметры:ДеревоЭлемент - элемент формы, отображающий дерево категорий
//			ДеревоРеквизит - реквизит формы типа ДеревоЗначений, содержащий дерево категорий
//			СписокКатегорийДляВыбора - список категорий, которые необходимо выбрать в дереве
Процедура УстановитьПризнакВыбораЭлементовДерева(ДеревоЭлемент, ДеревоРеквизит, СписокКатегорийДляВыбора, ВыбранныеКатегории = Неопределено) Экспорт
	
	Если СписокКатегорийДляВыбора <> Неопределено Тогда
		Для Каждого ЭлементСписка Из СписокКатегорийДляВыбора Цикл
			Индекс = -1;
			РаботаСКатегориямиДанныхКлиентСервер.НайтиКатегориюВДеревеПоСсылке(ДеревоРеквизит.ПолучитьЭлементы(), ЭлементСписка.Значение, Индекс);
			Если Индекс > -1 Тогда
				ДеревоРеквизит.НайтиПоИдентификатору(Индекс).Выбрана = ЭлементСписка.Пометка;
				Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьЭлементы().Количество() > 0 Тогда
					ДеревоЭлемент.Развернуть(ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьИдентификатор(), Ложь);
				Иначе
					Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьРодителя() <> Неопределено Тогда
						ДеревоЭлемент.Развернуть(ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьРодителя().ПолучитьИдентификатор(), Ложь);
					КонецЕсли;
				КонецЕсли;
				Если ВыбранныеКатегории <> Неопределено Тогда
					ВыбранныеКатегории.Добавить(ЭлементСписка.Значение);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

//Открывает форму подбора категорий для списка объектов
//Параметры:Список - массив ссылок на объекты. Типы объектов могут: Файл, Внутренний документ, Входящий документ, Исходящий документ
//			ЗаписатьКатегорииПриОК - выполнять или нет запись о выбранных категориях в базу данных. 
//				Если Истина, то при закрытии формы категории будут назначены всем объектам из списка.
//				Если Ложь, то при закрытии формы вернется массив выбранных категорий
//			ОписаниеОповещения - описание процедуры, обрабатывающей результат
//Возвращает:Количество присвоенных категорий, если ЗаписатьКатегорииПриОК = Истина
//			 Массив выбранных категорий, если ЗаписатьКатегорииПриОК = Ложь		
Процедура ОткрытьФормуПодбораКатегорийДляСпискаОбъектов(Список, ЗаписатьКатегорииПриОК, ОписаниеОповещения) Экспорт
	
	Результат = Неопределено;
	ПараметрыФормы = Новый Структура("ОбъектыДляКатегорий, ЗаписатьКатегорииПриОК");
	
	Если Список.ВыделенныеСтроки.Количество() > 0 Тогда
		
		МассивОбъектов = Новый Массив;
		Для Каждого ВыделеннаяСтрока Из Список.ВыделенныеСтроки Цикл
			Если ТипЗнч(ВыделеннаяСтрока) = Тип("РегистрСведенийКлючЗаписи.ДанныеВнутреннихДокументов")
			 Или ТипЗнч(ВыделеннаяСтрока) = Тип("РегистрСведенийКлючЗаписи.ДанныеВходящихДокументов")
			 Или ТипЗнч(ВыделеннаяСтрока) = Тип("РегистрСведенийКлючЗаписи.ДанныеИсходящихДокументов") Тогда 
				ДанныеСтроки = Список.ДанныеСтроки(ВыделеннаяСтрока);
				МассивОбъектов.Добавить(ДанныеСтроки.Ссылка);
			Иначе 
				МассивОбъектов.Добавить(ВыделеннаяСтрока);	
			КонецЕсли;	
		КонецЦикла;
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ОписаниеОповещения", ОписаниеОповещения);
		
		Описание = Новый ОписаниеОповещения(
			"ОткрытьФормуПодбораКатегорий",
			ЭтотОбъект,
			ПараметрыОповещения);

		ПараметрыФормы.ОбъектыДляКатегорий = МассивОбъектов;
		ПараметрыФормы.ЗаписатьКатегорииПриОК = ЗаписатьКатегорииПриОК;
		ОткрытьФорму("Справочник.КатегорииДанных.Форма.ФормаПодбораКатегорий", ПараметрыФормы,,,,,
			Описание, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	КонецЕсли;
		
КонецПроцедуры

Процедура ОткрытьФормуПодбораКатегорий(Результат, Параметры) Экспорт

	Если Результат <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения, Результат);
	КонецЕсли;
	
КонецПроцедуры

//Открывает форму подбора категорий по списку категорий
//Параметры:СписокКатегорий - первоначальный список категорий. В него записывается измененный список.
//			ОписаниеОповещения - описание процедуры, обрабатывающей результат
//			ТолькоОбщиеКатегории - флаг, показывающий, скрывать или нет вкладку с персональными категориями.
Процедура  ОткрытьФормуПодбораКатегорийДляСпискаКатегорий(СписокКатегорий, ОписаниеОповещения = Неопределено, ТолькоОбщиеКатегории = Ложь) Экспорт
	
	ПараметрыФормы = Новый Структура("СписокКатегорий, ЗаписатьКатегорииПриОК, ТолькоОбщиеКатегории");
	
	ПараметрыФормы.СписокКатегорий = СписокКатегорий;
	ПараметрыФормы.ЗаписатьКатегорииПриОК = Ложь;
	ПараметрыФормы.ТолькоОбщиеКатегории = ТолькоОбщиеКатегории;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("СписокКатегорий", СписокКатегорий);
	ПараметрыОповещения.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	Описание = Новый ОписаниеОповещения(
		"ОткрытьФормуПодбораКатегорийПродолжение",
		ЭтотОбъект,
		ПараметрыОповещения);

	ОткрытьФорму("Справочник.КатегорииДанных.Форма.ФормаПодбораКатегорий", ПараметрыФормы,,,,,
		Описание, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		
КонецПроцедуры

Процедура ОткрытьФормуПодбораКатегорийПродолжение(СписокВыбранныхКатегорий, Параметры) Экспорт

	СписокКатегорий = Параметры.СписокКатегорий;
	
	Модифицированность = Ложь;
	Если НЕ СписокВыбранныхКатегорий = Неопределено Тогда
		СписокКатегорий.Очистить();
		Для Каждого ВыбраннаяКатегория Из СписокВыбранныхКатегорий Цикл
			НоваяСтрока = СписокКатегорий.Добавить();
			НоваяСтрока.Значение = ВыбраннаяКатегория.Значение;
			Если ТипЗнч(НоваяСтрока) <> Тип("ЭлементСпискаЗначений") Тогда
				Если НоваяСтрока.Свойство("ПолноеНаименование") Тогда
					НоваяСтрока.ПолноеНаименование = ВыбраннаяКатегория.ПолноеНаименование;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Модифицированность = Истина;
	КонецЕсли;
	
	Если Модифицированность
		И ТипЗнч(СписокКатегорий) <> Тип("СписокЗначений") Тогда
		СписокКатегорий.Сортировать("ПолноеНаименование");
	КонецЕсли;
	
	Если Параметры.ОписаниеОповещения <> Неопределено Тогда 
		ПараметрыОповещения = Параметры.ОписаниеОповещения.ДополнительныеПараметры;
		ПараметрыОповещения.Вставить("Модифицированность", Модифицированность);
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения, СписокКатегорий);
	КонецЕсли;	

КонецПроцедуры

//Устанавливает либо снимает пометку удаления у категории
//Параметры: 
//			Категория - ссылка на категорию
//			ПометкаУдаления - флаг, показывающий, установлена ли в настоящий момент пометка удаления у категории
//			ОписаниеОповещения - описание функции, обрабатывающей результат
Процедура ПометитьКатегориюНаУдаление(Категория, ПометкаУдаления, ОписаниеОповещения) Экспорт
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Категория", Категория);
	ПараметрыОповещения.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	Описание = Новый ОписаниеОповещения(
		"ПометитьКатегориюНаУдалениеПродолжение",
		ЭтотОбъект,
		ПараметрыОповещения);
	Режим = РежимДиалогаВопрос.ДаНет;

	Если НЕ ПометкаУдаления Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить категорию ""%1"" на удаление?'; en = 'Mark category ""%1"" for deletion?'"),
			Категория);
	Иначе
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Снять с ""%1"" пометку удаления?'; en = 'Remove deletion mark from ""%1"" ?'"),
			Категория);
	КонецЕсли;
	
	ПоказатьВопрос(Описание, ТекстВопроса, Режим, 0, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

Процедура ПометитьКатегориюНаУдалениеПродолжение(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
    	Возврат;
	КонецЕсли;

	РаботаСКатегориямиДанных.УстановитьСнятьПометкуУдаленияУКатегории(Параметры.Категория);
	ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения);
	
КонецПроцедуры

// Обработчик перетаскивания документов и файлов в категорию на форме списка объектов
Процедура ФормаСпискаОбъектовДеревоКатегорийПеретаскивание(Форма, ПараметрыПеретаскивания, Строка, СтандартнаяОбработка, ОписаниеОповещения) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЗначениеПеретаскивания = ПараметрыПеретаскивания.Значение;
	Если Строка = Неопределено Или ТипЗнч(ЗначениеПеретаскивания) = Тип("Файл") Тогда
		Возврат
	КонецЕсли;
	
	ЭлементДерева = Форма.ДеревоКатегорий.НайтиПоИдентификатору(Строка);
	Режим = РежимДиалогаВопрос.ДаНет;	
	
	Если НЕ ЭлементДерева.Ссылка.Пустая()
		И НЕ ЭлементДерева.Ссылка = ПредопределенноеЗначение("Справочник.КатегорииДанных.ВсеКатегории") Тогда		
		Категория = ЭлементДерева.Ссылка;
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("Категория", Категория);
		ПараметрыОповещения.Вставить("МассивОбъектов", ЗначениеПеретаскивания);
		ПараметрыОповещения.Вставить("ОписаниеОповещения", ОписаниеОповещения);
		Описание = Новый ОписаниеОповещения(
			"ДеревоКатегорийПеретаскивание",
			ЭтотОбъект,
			ПараметрыОповещения);

		Если ЗначениеПеретаскивания.Количество() > 1 Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Нстр("ru = 'Добавить документы (%1 шт.) в категорию ""%2""?'; en = 'Add the documents (%1 pcs.) to category ""%2""?'"),
				Строка(ЗначениеПеретаскивания.Количество()),
				Категория);
		Иначе
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Нстр("ru = 'Добавить документ в категорию ""%1""?'; en = 'Add the document to category ""%1""?'"),
				Категория);
		КонецЕсли;
			
		ПоказатьВопрос(Описание, Текст, Режим, 0, КодВозвратаДиалога.Нет);
				
	ИначеЕсли ЭлементДерева.Ссылка.Пустая() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Нстр("ru = 'Очистить категории у документов (%1 шт.)?'; en = 'Clear categories from documents (%1 pcs.)?'"),
			Строка(ПараметрыПеретаскивания.Значение.Количество()));
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("МассивОбъектов", ЗначениеПеретаскивания);
		ПараметрыОповещения.Вставить("ОписаниеОповещения", ОписаниеОповещения);
		Описание = Новый ОписаниеОповещения(
			"ОчисткаКатегорийПриПеретаскивании",
			ЭтотОбъект,
			ПараметрыОповещения);

		ПоказатьВопрос(Описание, Текст, Режим, 0, КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДеревоКатегорийПеретаскивание(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СтрокаСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполняется установка категории ""%1"" у документов. Пожалуйста, подождите...'; en = 'Assigning category ""%1"" to documents. Please wait...'"),
			Параметры.Категория);
        Состояние(СтрокаСостояния);
		РаботаСКатегориямиДанных.ПрисвоитьКатегориюМассивуОбъектов(
			Параметры.МассивОбъектов,
			Параметры.Категория);
			
		СтрокаСостояния = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Категория ""%1"" успешно установлена.'; en = 'Category ""%1"" was successfully assigned.'"),
			Параметры.Категория);
		Состояние(СтрокаСостояния);
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения);
	КонецЕсли;

КонецПроцедуры	

Процедура ОчисткаКатегорийПриПеретаскивании(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		РаботаСКатегориямиДанных.ЗаписатьСписокКатегорийУМассиваОбъектов(Новый СписокЗначений,
			Параметры.МассивОбъектов);
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения);
	КонецЕсли;

КонецПроцедуры	


