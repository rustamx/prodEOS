﻿// Формирует список для выбора стороны.
//
// Параметры:
//  Параметры - структура, по которой выполняется поиск.
//
// Возвращает:
//  СписокЗначений - Список значений, содержащий ссылки на найденные по части наименования объекты
//
Функция СформироватьДанныеВыбораСтороны(Параметры) Экспорт
	
	Возврат РаботаСПодписямиДокументов.СформироватьДанныеВыбораСтороны(Параметры);
	
КонецФункции

// Формирует список для выбора контактных лиц стороны.
//
// Параметры:
//  Параметры - структура, по которой выполняется поиск.
//
// Возвращает:
//  СписокЗначений - Список значений, содержащий ссылки на найденные по части наименования объекты
//
Функция СформироватьДанныеВыбораКонтактногоЛицаСтороны(Параметры) Экспорт

	Возврат РаботаСПодписямиДокументов.СформироватьДанныеВыбораКонтактногоЛицаСтороны(Параметры);	

КонецФункции 

// Формирует список для выбора ответственного поставившего подпись.
//
// Параметры:
//  Параметры - структура, по которой выполняется поиск.
//
// Возвращает:
//  СписокЗначений - Список значений, содержащий ссылки на найденные по части наименования объекты
//
Функция СформироватьДанныеВыбораПодписал(Параметры) Экспорт

	Возврат РаботаСПодписямиДокументов.СформироватьДанныеВыбораПодписал(Параметры);	

КонецФункции

// Устанавливает условное оформление для таблицы сторон.
//
// Параметры:
//  УсловноеОформление - УсловноеОформление - условное оформление формы.
//  Организация - СправочникСсылка.Организация - значение для отбора.
//
Процедура УстановитьУсловноеСторон(Форма, Знач Организация) Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	РаботаСПодписямиДокументов.УстановитьУсловноеСторон(УсловноеОформление, Организация);	

КонецПроцедуры

// Возвращает признак того что объект может быть подписан
//
Функция МожетБытьПодписан(Значение) Экспорт
	
	Результат = Ложь;
	ТипОбъекта = ТипЗнч(Значение);
	
	Если ТипОбъекта = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		ВидДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Значение, "ВидДокумента");
		Если ЗначениеЗаполнено(ВидДокумента) И Не ВидДокумента.ИспользоватьПодписание Тогда
			Результат = Ложь;
		Иначе
			Результат = Истина;
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Файлы") Тогда
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


