﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

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

#КонецОбласти

// Устанавливает параметры загрузки данных из файла
//
// Параметры:
//     Параметры - Структура - Список параметров. Поля: 
//         * Заголовок - Строка - Заголовок окна 
//         * ОбязательныеКолонки -  Массив - Список имен колонок, обязательных для заполнения
//         * ТипДанныхКолонки - Соответствие, Ключ - Имя колонки, Значение - Описание типа данных 
//
Процедура ОпределитьПараметрыЗагрузкиДанныхИзФайла(Параметры) Экспорт
	
	Параметры.Заголовок = "Оборудование";
	
	ОписаниеТипа = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(50));
	
	Параметры.ТипДанныхКолонки.Вставить("KKS", ОписаниеТипа);
	Параметры.ТипДанныхКолонки.Вставить("ID", ОписаниеТипа);
	Параметры.ТипДанныхКолонки.Вставить("TekhnologicheskayaSistemaID", ОписаниеТипа);
	Параметры.ТипДанныхКолонки.Вставить("ZdaniyaSooruzheniyaID", ОписаниеТипа);
	
	ОписаниеТипа = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(150));
	Параметры.ТипДанныхКолонки.Вставить("Владелец", ОписаниеТипа);
	
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
	|	ra_Oborudovanie.Ссылка КАК Оборудование
	|ИЗ
	|	ВТ_ЗагружаемыеДанные КАК ВТ_ЗагружаемыеДанные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ra_Oborudovanie КАК ra_Oborudovanie
	|		ПО (ra_Oborudovanie.ID = ВТ_ЗагружаемыеДанные.ID)
	|			И ВТ_ЗагружаемыеДанные.Владелец = ra_Oborudovanie.Владелец.Наименование";
	
	Запрос.УстановитьПараметр("ЗагружаемыеДанные", ЗагружаемыеДанные);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Фильтр = Новый Структура("Идентификатор", Выборка.Идентификатор);
		Строки = ЗагружаемыеДанные.НайтиСтроки(Фильтр);
		Для Каждого Строка Из Строки Цикл
			Строка.ОбъектСопоставления = Выборка.Оборудование;
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
		    	ЭлементСправочника = Справочники.ra_Oborudovanie.СоздатьЭлемент();
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
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ra_Oborudovanie");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Строка.ОбъектСопоставления);
			
			ЭлементСправочника = Строка.ОбъектСопоставления.ПолучитьОбъект();
			Строка.РезультатСопоставленияСтроки = "Обновлен";
			Если ЭлементСправочника = Неопределено Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Оборудования с ID: %1 и KKS: %2 не существует!'; en = 'Equipment ID: %1 and KKS: %2 does not exist!'"), Строка.ID, Строка.KKS);
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
		КонецЕсли;	
		
		ЭлементСправочника.Наименование = Строка.Opisanie;
		ЭлементСправочника.Владелец = Строка.Проект;
		ЭлементСправочника.KKS = Строка.KKS;
		ЭлементСправочника.ID = Строка.ID;
		ЭлементСправочника.Opisanie = Строка.Opisanie;		
		ЭлементСправочника.TekhnologicheskayaSistema = Строка.Система;			
		ЭлементСправочника.ZdaniyaSooruzheniya = Строка.Здание;				
		ЭлементСправочника.Записать();
		
		ЗафиксироватьТранзакцию();
	КонецЦикла;
	
КонецПроцедуры

Процедура СопоставитьЗагружаемыеДанные(ЗагружаемыеДанные)
	
	ЗагружаемыеДанные.Колонки.Добавить("Здание", Новый ОписаниеТипов("СправочникСсылка.ra_ZdaniyaSooruzheniya"));
	ЗагружаемыеДанные.Колонки.Добавить("Система", Новый ОписаниеТипов("СправочникСсылка.ra_TekhnologicheskieSistemy"));
	ЗагружаемыеДанные.Колонки.Добавить("Проект", Новый ОписаниеТипов("СправочникСсылка.Проекты"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	ЗагружаемыеДанные.TekhnologicheskayaSistemaID КАК TekhnologicheskayaSistemaID,
	|	ЗагружаемыеДанные.ZdaniyaSooruzheniyaID КАК ZdaniyaSooruzheniyaID,
	|	ЗагружаемыеДанные.Владелец КАК Владелец
	|ПОМЕСТИТЬ ВТ_ЗагружаемыеДанные
	|ИЗ
	|	&ЗагружаемыеДанные КАК ЗагружаемыеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ЗагружаемыеДанные.Идентификатор КАК Идентификатор,
	|	ra_ZdaniyaSooruzheniya.Ссылка КАК Здание,
	|	ra_TekhnologicheskieSistemy.Ссылка КАК Система,
	|	Проекты.Ссылка КАК Проект
	|ИЗ
	|	ВТ_ЗагружаемыеДанные КАК ВТ_ЗагружаемыеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ra_TekhnologicheskieSistemy КАК ra_TekhnologicheskieSistemy
	|		ПО (ra_TekhnologicheskieSistemy.Владелец.Наименование = ВТ_ЗагружаемыеДанные.Владелец)
	|			И ВТ_ЗагружаемыеДанные.TekhnologicheskayaSistemaID = ra_TekhnologicheskieSistemy.ID
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ra_ZdaniyaSooruzheniya КАК ra_ZdaniyaSooruzheniya
	|		ПО (ra_ZdaniyaSooruzheniya.Владелец.Наименование = ВТ_ЗагружаемыеДанные.Владелец)
	|			И ВТ_ЗагружаемыеДанные.ZdaniyaSooruzheniyaID = ra_ZdaniyaSooruzheniya.ID
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Проекты КАК Проекты
	|		ПО ВТ_ЗагружаемыеДанные.Владелец = Проекты.Наименование";
	
	Запрос.УстановитьПараметр("ЗагружаемыеДанные", ЗагружаемыеДанные);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Фильтр = Новый Структура("Идентификатор", Выборка.Идентификатор);
		Строки = ЗагружаемыеДанные.НайтиСтроки(Фильтр);
		Для Каждого Строка Из Строки Цикл
			Строка.Здание = Выборка.Здание;
			Строка.Система = Выборка.Система;
			Строка.Проект = Выборка.Проект;
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры


#КонецЕсли
