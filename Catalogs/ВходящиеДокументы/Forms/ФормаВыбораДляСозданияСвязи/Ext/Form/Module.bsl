﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Документ = Параметры.Документ;
	Контрагент = Параметры.Контрагент;
	Организация = Параметры.Организация;
	Проект = Параметры.Проект;
	
	ВидДокумента = Неопределено;
	Если Параметры.ОбязательныеСвязи.Количество() = 1 Тогда
		
		Строка = Параметры.ОбязательныеСвязи[0];
		
		ТипСвязи = Строка.ТипСвязи;
		СсылкаНа = Строка.СсылкаНа;
		ВидДокумента = СсылкаНа;
		
	КонецЕсли;	
	
	Элементы.ДекорацияОписание.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Чтобы завершить создание документа, необходимо указать связь ""%1"". 
			|Выберите документ для создания связи.';
			|en = 'In order to finish creation of the document it is required to establish relation ""%1"". 
			|Select a document to establish the relation.'"),
			ТипСвязи);
	
	// Виды документов
	Если ЗначениеЗаполнено(ВидДокумента) Тогда
		Если ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") И ВидДокумента.ЭтоГруппа Тогда
			Список.Параметры.УстановитьЗначениеПараметра("ГруппаВидаДокумента", ВидДокумента);
		Иначе
			Список.Параметры.УстановитьЗначениеПараметра("ВидДокумента", ВидДокумента);
		КонецЕсли;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Отправитель",
			Контрагент);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Организация",
			Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Проект) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Проект",
			Проект);
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(Список);
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВозврата = Новый Структура("ТипСвязи, СсылкаНа, СвязанныйДокумент, Комментарий", 
		ТипСвязи, СсылкаНа, Элементы.Список.ТекущаяСтрока, "");
		
	МассивВозврата = Новый Массив;
	МассивВозврата.Добавить(ПараметрыВозврата);
	
	Закрыть(МассивВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВозврата = Новый Структура("ТипСвязи, СсылкаНа, СвязанныйДокумент, Комментарий", 
		ТипСвязи, СсылкаНа, Элементы.Список.ТекущаяСтрока, "");
		
	МассивВозврата = Новый Массив;
	МассивВозврата.Добавить(ПараметрыВозврата);
	
	Закрыть(МассивВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(Организация) Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Организация");
	Иначе	
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Организация",
			Организация);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Отправитель");
	Иначе	
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Отправитель",
			Контрагент);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПроектПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Проект) Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Проект");
	Иначе	
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"Проект",
			Проект);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь);
	КонецЕсли;	
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры          

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
	ПоказатьУдаленные();
	
КонецПроцедуры

