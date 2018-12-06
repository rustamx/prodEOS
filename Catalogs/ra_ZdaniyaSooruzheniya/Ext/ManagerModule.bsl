﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("KKS");
		
	Если ТекущийЯзык() = Метаданные.Языки.Английский Тогда
		Поля.Добавить("NaimenovanieEn");	
	Иначе
		Поля.Добавить("Opisanie");	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Представление = Данные.KKS + " " + ?(Данные.Свойство("Opisanie"), Данные.Opisanie, Данные.NaimenovanieEn);
	
	ра_ОбщегоНазначения.ОбработатьПустоеПредставление(Представление);
	
КонецПроцедуры

// Устанавливает параметры загрузки данных из файла
//
// Параметры:
//     Параметры - Структура - Список параметров. Поля: 
//         * Заголовок - Строка - Заголовок окна 
//         * ОбязательныеКолонки -  Массив - Список имен колонок, обязательных для заполнения
//         * ТипДанныхКолонки - Соответствие, Ключ - Имя колонки, Значение - Описание типа данных 
//
Процедура ОпределитьПараметрыЗагрузкиДанныхИзФайла(Параметры) Экспорт
	
	Параметры.Заголовок = "Здания и сооружения";	
	ОписаниеТипа = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(50));
	Параметры.ТипДанныхКолонки.Вставить("ID", ОписаниеТипа);
	
	ОписаниеТипа = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(150));
	Параметры.ТипДанныхКолонки.Вставить("Владелец", ОписаниеТипа);
	Параметры.ТипДанныхКолонки.Вставить("Obekt", ОписаниеТипа);

КонецПроцедуры
// Производит сопоставление загружаемых данных с данными в ИБ.
//
// Параметры:
//   ЗагружаемыеДанные - ТаблицаЗначений - таблица значений с загружаемыми данными:
//     * СопоставленныйОбъект - СправочникСсылка - Ссылка на сопоставленный объект. Заполняется внутри процедуры
//     * <другие колонки>     - Произвольный - Состав колонок соответствует макету "ЗагрузкаИзФайла"
//
Процедура СопоставитьЗагружаемыеДанныеИзФайла(ЗагружаемыеДанные) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗагружаемыеДанные.ID КАК ID,
	|	ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	ЗагружаемыеДанные.Владелец КАК Владелец
	|ПОМЕСТИТЬ ВТ_ЗагружаемыеДанные
	|ИЗ
	|	&ЗагружаемыеДанные КАК ЗагружаемыеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	ra_ZdaniyaSooruzheniya.Ссылка КАК Здание
	|ИЗ
	|	Справочник.ra_ZdaniyaSooruzheniya КАК ra_ZdaniyaSooruzheniya
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ЗагружаемыеДанные КАК ВТ_ЗагружаемыеДанные
	|		ПО ra_ZdaniyaSooruzheniya.ID = ВТ_ЗагружаемыеДанные.ID
	|			И ra_ZdaniyaSooruzheniya.Владелец.Наименование = ВТ_ЗагружаемыеДанные.Владелец";
	Запрос.УстановитьПараметр("ЗагружаемыеДанные", ЗагружаемыеДанные);

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Фильтр = Новый Структура("Идентификатор", Выборка.Идентификатор);
		Строки = ЗагружаемыеДанные.НайтиСтроки(Фильтр);
		Для Каждого Строка Из Строки Цикл
			Строка.ОбъектСопоставления = Выборка.Здание;
		КонецЦикла;
	КонецЦикла;	
	
КонецПроцедуры
// Загрузка данных из файла
//
// Параметры:
//   ЗагружаемыеДанные - ТаблицаЗначений с колонками:
//     * СопоставленныйОбъект         - СправочникСсылка - Ссылка на сопоставленный объект
//     * РезультатСопоставленияСтроки - Строка       - Cтатусом загрузки, возможны варианты: Создан, Обновлен, Пропущен   
//     * ОписаниеОшибки               - Строка       - расшифровка ошибки загрузки данных
//     * Идентификатор                - Число        - Уникальный номер строки 
//     * <другие колонки>             - Произвольный - Строки загружаемого файла в соответствии с макетом
// ПараметрыЗагрузки                  - Структура    - Параметры загрузки
//     * СоздаватьНовые               - Булево       - Требуется ли создавать новые элементы справочника
//     * ОбновлятьСуществующие        - Булево       - Требуется ли обновлять элементы справочника
// Отказ                              - Булево       - Отмена загрузки
Процедура ЗагрузитьИзФайла(ЗагружаемыеДанные, ПараметрыЗагрузки, Отказ) Экспорт
	
	СопоставитьЗагружаемыеДанные(ЗагружаемыеДанные);
	Для Каждого Строка Из ЗагружаемыеДанные Цикл
		НачатьТранзакцию();
		
		Если НЕ ЗначениеЗаполнено(Строка.Проект) Тогда
			Строка.РезультатСопоставленияСтроки = "Не найден проект";
			Продолжить;
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(Строка.ОбъектСопоставления) Тогда
			Если ПараметрыЗагрузки.СоздаватьНовые Тогда
		    	ЭлементСправочника = Справочники.ra_ZdaniyaSooruzheniya.СоздатьЭлемент();
				Строка.ОбъектСопоставления = ЭлементСправочника;
				Строка.РезультатСопоставленияСтроки = "Создан";
			Иначе
				Строка.РезультатСопоставленияСтроки = "Пропущен";
				Продолжить;
			КонецЕсли;
		Иначе
			Если НЕ ПараметрыЗагрузки.ОбновлятьСуществующие Тогда
				Строка.РезультатСопоставленияСтроки = "Пропущен";
				Продолжить;
			КонецЕсли;
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ra_ZdaniyaSooruzheniya");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Строка.ОбъектСопоставления);
			
			ЭлементСправочника = Строка.ОбъектСопоставления.ПолучитьОбъект();
			Строка.РезультатСопоставленияСтроки = "Обновлен";
			Если ЭлементСправочника = Неопределено Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Здания с ID: %1 не существует!'; en = 'Building ID: %1 does not exist!'"), Строка.ID);
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
		КонецЕсли;
						
		ЭлементСправочника.Наименование = Строка.Opisanie;
		ЭлементСправочника.Владелец = Строка.Проект;
		ЭлементСправочника.KKS = Строка.KKS;
		ЭлементСправочника.ID = Строка.ID;
		ЭлементСправочника.Opisanie = Строка.Opisanie;	
		ЭлементСправочника.Obekt = Строка.Объект;
		
		ЭлементСправочника.Записать();
		
		ЗафиксироватьТранзакцию();
	КонецЦикла;
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанные(ЗагружаемыеДанные)
	
	ЗагружаемыеДанные.Колонки.Добавить("Проект", Новый ОписаниеТипов("СправочникСсылка.Проекты"));
	ЗагружаемыеДанные.Колонки.Добавить("Объект", Новый ОписаниеТипов("СправочникСсылка.ra_Obekty"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	ЗагружаемыеДанные.Владелец КАК Владелец,
	|	ЗагружаемыеДанные.Obekt КАК Obekt
	|ПОМЕСТИТЬ ВТ_ЗагружаемыеДанные
	|ИЗ
	|	&ЗагружаемыеДанные КАК ЗагружаемыеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	Проекты.Ссылка КАК Проект,
	|	ra_Obekty.Ссылка КАК Объект
	|ИЗ
	|	ВТ_ЗагружаемыеДанные КАК ВТ_ЗагружаемыеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Проекты КАК Проекты
	|		ПО ВТ_ЗагружаемыеДанные.Владелец = Проекты.Наименование
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ra_Obekty КАК ra_Obekty
	|		ПО ВТ_ЗагружаемыеДанные.Obekt = ra_Obekty.Наименование
	|			И ВТ_ЗагружаемыеДанные.Владелец = ra_Obekty.Владелец.Наименование";
	
	Запрос.УстановитьПараметр("ЗагружаемыеДанные", ЗагружаемыеДанные);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Фильтр = Новый Структура("Идентификатор", Выборка.Идентификатор);
		Строки = ЗагружаемыеДанные.НайтиСтроки(Фильтр);
		Для Каждого Строка Из Строки Цикл
			Строка.Проект = Выборка.Проект;
			Строка.Объект = Выборка.Объект;
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецЕсли