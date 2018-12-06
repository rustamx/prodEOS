﻿////////////////////////////////////////////////////////////////////////////////
// Общего назначения Документооборот (клиент).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Показывает вопрос "Да" / "Нет", принимая Esc и закрытие формы крестиком как ответ "Нет".
//
// Параметры:
//   ОписаниеОповещенияОЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия с
//     передачей параметра КодВозвратаДиалога.Да или КодВозвратаДиалога.Нет.
//   ТекстВопроса - Строка - текст задаваемого вопроса.
//   ТекстКнопкиДа - Строка - необязательный, текст кнопки "Да".
//   ТекстКнопкиНет - Строка - необязательный, текст кнопки "Нет".
//   КнопкаПоУмолчанию - РежимДиалогаВопрос - необязательный, кнопка по умолчанию.
//
Процедура ПоказатьВопросДаНет(ОписаниеОповещенияОЗавершении, ТекстВопроса,
	ТекстКнопкиДа = Неопределено, ТекстКнопкиНет = Неопределено, КнопкаПоУмолчанию = Неопределено) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьВопросДаНетЗавершение", ЭтотОбъект, ОписаниеОповещенияОЗавершении);
		
	Кнопки = Новый СписокЗначений;
	Если ТекстКнопкиДа = Неопределено Тогда
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Да'; en = 'Yes'"));
	Иначе
		Кнопки.Добавить(КодВозвратаДиалога.ОК, ТекстКнопкиДа);
	КонецЕсли;
	Если ТекстКнопкиНет = Неопределено Тогда
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Нет'; en = 'No'"));
	Иначе
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, ТекстКнопкиНет);
	КонецЕсли;
	
	Если КнопкаПоУмолчанию = Неопределено Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	ИначеЕсли КнопкаПоУмолчанию = КодВозвратаДиалога.Да Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,, КодВозвратаДиалога.ОК);
	ИначеЕсли КнопкаПоУмолчанию = КодВозвратаДиалога.Нет Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,, КодВозвратаДиалога.Отмена);
	Иначе
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение кнопки по умолчанию: %1'; en = 'Invalid value for default button: %1'"),
			КнопкаПоУмолчанию);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после закрытия окна с вопросом "Да" / "Нет" и вызывает ранее переданный обработчик
// оповещения с передачей ответа пользователя.
//
// Параметры:
//   Результат - КодВозвратаДиалога - ответ пользователя,
//     КодВозвратаДиалога.ОК или КодВозвратаДиалога.Отмена.
//   ОписаниеОповещения - ОписаниеОповещения - описание вызываемого оповещения.
//
Процедура ПоказатьВопросДаНетЗавершение(Результат, ОписаниеОповещения) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

// Удаляет строки переданной таблицы формы, в которых проверяемый реквизит не заполнен.
//
// Параметры:
//  ТаблицаФормы 			- Таблица формы - в которой осуществляется удаление не заполненых строк.
//  ИмяРеквизитаПроверки    - Строка - имя реквизита, заполненность которого проверяется.
//
Процедура УдалитьПустыеСтрокиТаблицы(ТаблицаФормы, ИмяРеквизитаПроверки) Экспорт
	
	КоличествоСтрок = ТаблицаФормы.Количество();
	Для Инд = 1 По КоличествоСтрок Цикл
		Строка = ТаблицаФормы[КоличествоСтрок - Инд];
		
		Если Не ЗначениеЗаполнено(Строка[ИмяРеквизитаПроверки]) Тогда 
			ТаблицаФормы.Удалить(Строка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ВставитьВОписаниеОповещенияОЗакрытииСсылкуНаОбъект(Форма) Экспорт
	
	Если Форма.ОписаниеОповещенияОЗакрытии <> Неопределено
		И ТипЗнч(Форма.ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры) = Тип("Структура") Тогда
		Форма.ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Вставить("СсылкаНаОбъект", Форма.Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

// В случае, если объект не записан в базу, записывает его, предварительно задвая вопрос
// и выполняет дополнительное действие
// 
// Параметры:
//  Форма - Форма - форма объекта
//  ИмяОсновногоРеквизита - Строка - имя реквизита, указывающего на объект
//  ТекстВопроса - Строка - текст вопроса, который надо задать перед записью
//  Действие - ОписаниеОповещения - описание дополнительного действия
// 
Процедура ЗаписатьОбъектЕслиНовыйИВыполнитьДействие(
		ФормаОбъекта, ИмяОсновногоРеквизита, ТекстВопроса, Действие) Экспорт
	
	СсылкаНаОбъект = ФормаОбъекта[ИмяОсновногоРеквизита].Ссылка;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗаписатьОбъектЕслиНовыйИВыполнитьДействиеЗавершение",
		ЭтотОбъект,
		Новый Структура("ФормаОбъекта, СсылкаНаОбъект, Действие", ФормаОбъекта, СсылкаНаОбъект, Действие));
	
	// Предварительная запись нового объекта
	Если СсылкаНаОбъект.Пустая() Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

// Служебная процедура
Процедура ЗаписатьОбъектЕслиНовыйИВыполнитьДействиеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда 
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.ОК Тогда
		
		Если Не Параметры.ФормаОбъекта.Записать() Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.Действие);
	
КонецПроцедуры

// Обработка события формы ПередЗакрытием.
//
// Параметры:
//  Отказ - Булево - Признак отказа от закрытия формы.
//  ЗавершениеРаботы - Булево - Признак того, что форма закрывается в процессе завершения работы приложения.
//  ТекстПредупреждения - Строка - Текст предупреждения.
//  СтандартнаяОбработка - Булево - Признак выполнения стандартной обработки события.
//  Модифицированость - Булево - Признак изменения данных в форме.
// 
// Возвращаемое значение:
//  Булево - Признак необходимости отключения дальнейшей обработки события.
//
Функция ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированость) Экспорт
	
	Если Не ЗавершениеРаботы Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Модифицированость Тогда
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'; en = 'Data was changed. All changes will be lost.'");
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Обработка события формы ПриЗакрытии.
//
// Параметры:
//  ЗавершениеРаботы - Булево - Признак того, что форма закрывается в процессе завершения работы приложения.
// 
// Возвращаемое значение:
//  Булево - Признак необходимости отключения дальнейшей обработки события.
//
Функция ПриЗакрытии(ЗавершениеРаботы) Экспорт
	
	Если Не ЗавершениеРаботы Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти
