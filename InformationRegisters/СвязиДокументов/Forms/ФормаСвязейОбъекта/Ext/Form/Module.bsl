﻿//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.Документ) = Тип("СправочникСсылка.Файлы") Тогда
		Заголовок = НСтр("ru = 'Связи файла'; en = 'File relations'");
	ИначеЕсли ТипЗнч(Параметры.Документ) = Тип("СправочникСсылка.Мероприятия") Тогда 
		Заголовок = НСтр("ru = 'Связи мероприятия'; en = 'Event relations'");
	ИначеЕсли ТипЗнч(Параметры.Документ) = Тип("СправочникСсылка.Проекты") Тогда
		Заголовок = НСтр("ru = 'Связи проекта'; en = 'Project relations'");
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Параметры.Документ) Тогда
		Заголовок = НСтр("ru = 'Связи письма'; en = 'Email relations'");
	Иначе
		Заголовок = НСтр("ru = 'Связи документа'; en = 'Document relations'");
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Документ", Параметры.Документ);
	Список.Параметры.УстановитьЗначениеПараметра("ТипСвязи", Справочники.ТипыСвязей.ПустаяСсылка());
	
	ЗаполнитьСписокТиповСвязей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") Тогда 
		УникальныйИдентификаторФормыВладельца = ВладелецФормы.УникальныйИдентификатор;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СозданаСвязь" 
		И ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Документ = Параметры.Документ Тогда 
		
		НайденнаяСтрока = ТипыСвязей.НайтиПоЗначению(Параметр.ТипСвязи);
		Если НайденнаяСтрока = Неопределено Тогда 
			НайденнаяСтрока = ТипыСвязей.Добавить(Параметр.ТипСвязи);
			ТипыСвязей.СортироватьПоЗначению();
			Элементы.ТипыСвязей.Обновить();
		КонецЕсли;
		
		Элементы.ТипыСвязей.ТекущаяСтрока = НайденнаяСтрока.ПолучитьИдентификатор();
		ОбработкаОжидания();
		Элементы.Список.ТекущаяСтрока = Параметр.КлючЗаписи;
		
	ИначеЕсли ИмяСобытия = "УдаленыВсеСвязиТипа" 
		И Параметр.Документ = Параметры.Документ Тогда 
		
		НайденноеЗначение = ТипыСвязей.НайтиПоЗначению(Параметр.ТипСвязи);
		Если НайденноеЗначение <> Неопределено И ТипыСвязей.Индекс(НайденноеЗначение) > 0 Тогда 
			ТипыСвязей.Удалить(НайденноеЗначение);
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзмененыСвязиДокумента" Тогда 
		
		Если ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Документ = Параметры.Документ
		И Источник <> ЭтаФорма
		И ЗначениеЗаполнено(Параметр.ТипыСвязей[0]) Тогда
			НайденнаяСтрока = ТипыСвязей.НайтиПоЗначению(Параметр.ТипыСвязей[0]);
			
			Если НайденнаяСтрока = Неопределено Тогда 
				НайденнаяСтрока = ТипыСвязей.Добавить(Параметр.ТипыСвязей[0]);
				ТипыСвязей.СортироватьПоЗначению();
				Элементы.ТипыСвязей.Обновить();
				
			КонецЕсли;
			
			Элементы.Список.Обновить();
			Элементы.ТипыСвязей.ТекущаяСтрока = НайденнаяСтрока.ПолучитьИдентификатор();
			ОбработкаОжидания();
		
		КонецЕсли;
		
	КонецЕсли;	
		
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 

&НаКлиенте
Процедура ОбработкаОжидания()
	
	ТипСвязи = ТипыСвязей.НайтиПоИдентификатору(Элементы.ТипыСвязей.ТекущаяСтрока).Значение;
	Если ТипСвязи <> Список.Параметры.Элементы.Найти("ТипСвязи").Значение Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ТипСвязи", ТипСвязи);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокТиповСвязей()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СвязиДокументов.ТипСвязи КАК ТипСвязи,
	|	СвязиДокументов.ДатаУстановки
	|ИЗ
	|	РегистрСведений.СвязиДокументов КАК СвязиДокументов
	|ГДЕ
	|	СвязиДокументов.Документ = &Документ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТипСвязи";
	Запрос.УстановитьПараметр("Документ", Параметры.Документ);
	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Свернуть("ТипСвязи");
	
	ТипыСвязей.ЗагрузитьЗначения( Результат.ВыгрузитьКолонку("ТипСвязи") );
	ТипыСвязей.Вставить(0, Справочники.ТипыСвязей.ПустаяСсылка(), НСтр("ru = 'Все связи'; en = 'All relations'"));
	
 КонецПроцедуры	
 
 &НаСервере 
Функция УдалитьЗаписи(ТекущаяСтрока)
	
	ТекущийДокумент = ТекущаяСтрока.Документ;
	ТекущийТипСвязи = ТекущаяСтрока.ТипСвязи;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.СвязанныйДокумент) Тогда 
		ТекущийСвязанныйДокумент = ТекущаяСтрока.СвязанныйДокумент;
	ИначеЕсли ЗначениеЗаполнено(ТекущаяСтрока.СвязаннаяСтрока) Тогда 
		ТекущийСвязанныйДокумент = ТекущаяСтрока.СвязаннаяСтрока;
	КонецЕсли;
	
	// удаление связи
	СвязиДокументов.УдалитьСвязь(ТекущийДокумент, ТекущийСвязанныйДокумент, ТекущийТипСвязи);
	РеквизитыВладельцаИзменены = СвязиДокументов.УстановитьРеквизитыПриУдаленииСвязи(ТекущийДокумент,
		УникальныйИдентификаторФормыВладельца, ТекущийТипСвязи);
	
	// удалены все связи с данным типом
	НаборЗаписей = РегистрыСведений.СвязиДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(ТекущийДокумент);
	НаборЗаписей.Отбор.ТипСвязи.Установить(ТекущийТипСвязи);
	НаборЗаписей.Прочитать();
	УдаленыВсеСвязиТипа = (НаборЗаписей.Количество() = 0);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("РеквизитыВладельцаИзменены", РеквизитыВладельцаИзменены);
	СтруктураВозврата.Вставить("УдаленыВсеСвязиТипа", УдаленыВсеСвязиТипа);
	
	Возврат СтруктураВозврата;
	
КонецФункции
 

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ТипСвязи = ТипыСвязей.НайтиПоИдентификатору(Элементы.ТипыСвязей.ТекущаяСтрока).Значение;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Документ", Параметры.Документ);
	ПараметрыФормы.Вставить("ТипСвязи", ТипСвязи);
	ПараметрыФормы.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификаторФормыВладельца);
	Если Копирование Тогда 
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущаяСтрока);
		Открытьформу("РегистрСведений.СвязиДокументов.ФормаЗаписи", ПараметрыФормы, Элементы.Список);
	Иначе 
		ОчиститьСообщения();
		Открытьформу("РегистрСведений.СвязиДокументов.Форма.СозданиеСвязи", ПараметрыФормы,
			Элементы.Список,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ТекущаяСтрока);
	ПараметрыФормы.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификаторФормыВладельца);
	
	Открытьформу("РегистрСведений.СвязиДокументов.ФормаЗаписи", ПараметрыФормы, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыСвязейПриАктивизацииСтроки(Элемент)
	 
	Если Элементы.ТипыСвязей.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли;
	 
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СписокПередУдалениемПродолжение",
		ЭтотОбъект,
		Новый Структура("ТекущаяСтрока", ТекущаяСтрока));

	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Удалить запись?'; en = 'Delete relation?'"), 
		РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);	
		
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалениемПродолжение(Результат, Параметры)Экспорт 

	Если Результат = КодВозвратаДиалога.Да Тогда 
		ТекущаяСтрока = Параметры.ТекущаяСтрока;
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		ТекущийТипСвязи = ТекущиеДанные.ТипСвязи;
		ТекущийДокумент = ТекущиеДанные.Документ;
		
		СтруктураРезультата = УдалитьЗаписи(ТекущаяСтрока);
		Элементы.Список.Обновить();
		
		// удалены все связи
		Если СтруктураРезультата.УдаленыВсеСвязиТипа Тогда 
			НайденноеЗначение = ТипыСвязей.НайтиПоЗначению(ТекущийТипСвязи);
			Если НайденноеЗначение <> Неопределено И ТипыСвязей.Индекс(НайденноеЗначение) > 0 Тогда 
				ТипыСвязей.Удалить(НайденноеЗначение);
			КонецЕсли;
			
			Элементы.ТипыСвязей.ТекущаяСтрока = ТипыСвязей[0].ПолучитьИдентификатор(); 
		КонецЕсли;
		
		// оповестить документ об изменении реквизитов
		Если СтруктураРезультата.РеквизитыВладельцаИзменены Тогда 
			Оповестить("ИзмененыРеквизитыПриИзмененииСвязи", ТекущийДокумент, ЭтаФорма);
		КонецЕсли;
		
		// оповестить документ об удаленной связи
		ТипыСвязейМассив = Новый Массив;
		ТипыСвязейМассив.Добавить(ТекущийТипСвязи);
		
		ПараметрОповещения = Новый Структура;
		ПараметрОповещения.Вставить("Документ", ТекущийДокумент);
		ПараметрОповещения.Вставить("ТипыСвязей", ТипыСвязейМассив);
		
		Оповестить("ИзмененыСвязиДокумента", ПараметрОповещения, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	СвязанныйДокумент = ПараметрыПеретаскивания.Значение[0];
	
	Если ЗначениеЗаполнено(СвязанныйДокумент)
		И ДелопроизводствоКлиент.ДокументыМожноСвязать(Параметры.Документ, СвязанныйДокумент) Тогда 
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Документ", Параметры.Документ);
		ПараметрыФормы.Вставить("СвязанныйДокумент", СвязанныйДокумент);
		
		ОчиститьСообщения();
		Открытьформу("РегистрСведений.СвязиДокументов.Форма.СозданиеСвязи", ПараметрыФормы,
			Элементы.Список,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 			
	Иначе 
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя установить связь между выбранными объектами'; en = 'It is not possible to establish a relation between the selected objects'"));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСсылке(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.СвязанныйДокумент) = Тип("Строка") Тогда 
		ПерейтиПоНавигационнойСсылке(ТекущиеДанные.СвязанныйДокумент);
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.СвязанныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.СвязанныйДокумент) = Тип("Строка") Тогда 
		ПерейтиПоНавигационнойСсылке(ТекущиеДанные.СвязанныйДокумент);
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.СвязанныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктураСвязей(Команда)
	
	ПараметрыФормы = Новый Структура("Документ", Параметры.Документ);
	ОткрытьФорму("Отчет.СтруктураСвязейДокумента.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры


