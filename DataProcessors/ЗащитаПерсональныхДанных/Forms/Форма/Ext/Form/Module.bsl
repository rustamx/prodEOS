﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОтборЖурналаРегистрацииПоУмолчанию();
	ОтборЖурналаРегистрации = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ОтборЖурналаРегистрацииПоУмолчанию);
	
	КоличествоПоказываемыхСобытий = 200;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьТекущийСписок", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЖурналВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЖурналРегистрацииКлиент.СобытияВыбор(Элементы.Журнал.ТекущиеДанные, Поле, ИнтервалДат, ОтборЖурналаРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПоказываемыхСобытийПриИзменении(Элемент)
	
#Если ВебКлиент Тогда
	КоличествоПоказываемыхСобытий = ?(КоличествоПоказываемыхСобытий > 1000, 1000, КоличествоПоказываемыхСобытий);
#КонецЕсли
	
	ОбновитьТекущийСписок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьТекущийСписок() 
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ИндикаторДлительныхОпераций;
	РезультатВыполнения = ПрочитатьЖурнал(ОтборЖурналаРегистрации);
	
	Если РезультатВыполнения.Статус <> "Выполняется" Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "ФормированиеОтчета");
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьТекущийСписокЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатВыполнения, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор()
	
	ОтборЖурналаРегистрации = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ОтборЖурналаРегистрацииПоУмолчанию);
	ОбновитьТекущийСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрТекущегоСобытияВОтдельномОкне()
	
	ЖурналРегистрацииКлиент.ПросмотрТекущегоСобытияВОтдельномОкне(Элементы.Журнал.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотра()
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалДатДляПросмотраЗавершение", ЭтотОбъект);
	ЖурналРегистрацииКлиент.УстановитьИнтервалДатДляПросмотра(ИнтервалДат, ОтборЖурналаРегистрации, Оповещение)
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоЗначениюВТекущейКолонке()
	
	// Для установки отбора по значению в текущей колонке, 
	// отбор по умолчанию сначала отключается, а затем восстанавливается.
	
	УдалитьИзОтбораЗначенияПоУмолчанию();
	
	КолонкиИсключения = Новый Массив;
	КолонкиИсключения.Добавить("Дата");
	КолонкиИсключения.Добавить("СведенияОСобытии");
	
	ОбновлятьСписок = ЖурналРегистрацииКлиент.УстановитьОтборПоЗначениюВТекущейКолонке(Элементы.Журнал.ТекущиеДанные, Элементы.Журнал.ТекущийЭлемент, ОтборЖурналаРегистрации, КолонкиИсключения);
	
	ДополнитьОтборЗначениямиПоУмолчанию();
	
	Если ОбновлятьСписок Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Журнал.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Журнал.Событие");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(НСтр("ru = '_$Session$_.AuthenticationError'; en = '_$Session$_.AuthenticationError'"));
	СписокЗначений.Добавить(НСтр("ru = '_$Access$_.AccessDenied'; en = '_$Access$_.AccessDenied'"));
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.СобытиеОтказ);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотраЗавершение(ИнтервалУстановлен, ДополнительныеПараметры) Экспорт
	
	Если ИнтервалУстановлен Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОтчета(ОтборЖурналаНаКлиенте)
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Журнал", РеквизитФормыВЗначение("Журнал"));
	ПараметрыОтчета.Вставить("ОтборЖурналаРегистрации", ОтборЖурналаНаКлиенте);
	ПараметрыОтчета.Вставить("КоличествоПоказываемыхСобытий", КоличествоПоказываемыхСобытий);
	ПараметрыОтчета.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("МенеджерВладельца", Обработки.ЗащитаПерсональныхДанных);
	ПараметрыОтчета.Вставить("ДобавлятьДополнительныеКолонки", Истина);
	
	Возврат ПараметрыОтчета;
КонецФункции

&НаСервере
Функция ЗаполнитьОтборЖурналаРегистрацииПоУмолчанию()
	
	ОтборЖурналаРегистрацииПоУмолчанию = Новый Структура;
	ОтборЖурналаРегистрацииПоУмолчанию.Вставить("Событие",			ЗащитаПерсональныхДанныхПовтИсп.СписокКонтролируемыхСобытий152ФЗ());
	ОтборЖурналаРегистрацииПоУмолчанию.Вставить("ИмяПриложения", 	ЗащитаПерсональныхДанныхПовтИсп.СписокКонтролируемыхПриложений152ФЗ());
	
КонецФункции

&НаСервере
Функция ПрочитатьЖурнал(ОтборЖурналаНаКлиенте)
	
	ПараметрыОтчета = ПараметрыОтчета(ОтборЖурналаНаКлиенте);
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Защита персональных данных'; en = 'Personal data protection'");
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне("ЖурналРегистрации.ПрочитатьСобытияЖурналаРегистрации",
		ПараметрыОтчета, ПараметрыВыполнения);
		
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ЗагрузитьПодготовленныеДанные(РезультатВыполнения.АдресРезультата);
	ИначеЕсли РезультатВыполнения.Статус = "Выполняется" Тогда
		ЖурналРегистрации.СформироватьПредставлениеОтбора(ПредставлениеОтбора, ОтборЖурналаНаКлиенте, ОтборЖурналаРегистрацииПоУмолчанию);
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ВызватьИсключение РезультатВыполнения.КраткоеПредставлениеОшибки; 
	КонецЕсли;	
		

	Возврат РезультатВыполнения;
КонецФункции

&НаКлиенте
Процедура ДополнитьОтборЗначениямиПоУмолчанию()
	
	Для Каждого ЭлементОтбора Из ОтборЖурналаРегистрацииПоУмолчанию Цикл
		ЗначениеОтбораПоУмолчанию = ЭлементОтбора.Значение;
		Если НЕ ОтборЖурналаРегистрации.Свойство(ЭлементОтбора.Ключ) Тогда
			// Отбор не был установлен
			Если ТипЗнч(ЗначениеОтбораПоУмолчанию) = Тип("СписокЗначений") Тогда
				ОтборЖурналаРегистрации.Вставить(ЭлементОтбора.Ключ, ЗначениеОтбораПоУмолчанию.Скопировать());
			Иначе
				ОтборЖурналаРегистрации.Вставить(ЭлементОтбора.Ключ, ЗначениеОтбораПоУмолчанию);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзОтбораЗначенияПоУмолчанию()
	
	Для Каждого ЭлементОтбораПоУмолчанию Из ОтборЖурналаРегистрацииПоУмолчанию Цикл
		ЗначениеОтбора = "";
		Если ОтборЖурналаРегистрации.Свойство(ЭлементОтбораПоУмолчанию.Ключ, ЗначениеОтбора) Тогда
			// Отбор удаляется только в случае, если он в точности соответствует значению отбора по умолчанию.
			Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
				УдалятьОтбор = ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(ЗначениеОтбора, ЭлементОтбораПоУмолчанию.Значение);
			Иначе	
				УдалятьОтбор = ЭлементОтбораПоУмолчанию.Значение = ЗначениеОтбора;
			КонецЕсли;
			Если УдалятьОтбор Тогда
				ОтборЖурналаРегистрации.Удалить(ЭлементОтбораПоУмолчанию.Ключ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(АдресХранилища)
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	СобытияЖурнала       = РезультатВыполнения.СобытияЖурнала;
	
	ЖурналРегистрации.ПоместитьДанныеВоВременноеХранилище(СобытияЖурнала, УникальныйИдентификатор);
	
	ЗначениеВДанныеФормы(СобытияЖурнала, Журнал);
	ИдентификаторЗадания = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущийСписокЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ЗагрузитьПодготовленныеДанные(Результат.АдресРезультата);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
	Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
	ПозиционированиеВКонецСписка();
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПозиционированиеВКонецСписка()
	Если Журнал.Количество() > 0 Тогда
		Элементы.Журнал.ТекущаяСтрока = Журнал[Журнал.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры 

#КонецОбласти
