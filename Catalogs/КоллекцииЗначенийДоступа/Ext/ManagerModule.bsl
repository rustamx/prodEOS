﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет поиск коллекции с указанными значениями доступа.
// 	Если коллекция не найдена, создает новую.
//
// Параметры:
//  ЗначенияДоступа - Массив - массив значений доступа.
//
// Возвращаемое значение:
//  СправочникСсылка.КоллекцииЗначенийДоступа - ссылка на коллекцию.
// 
Функция ПолучитьКоллекцию(ЗначенияДоступа) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Неопределено;
	
	ЗначенияДоступаСокращенные = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЗначенияДоступаСокращенные, ЗначенияДоступа, Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.Ссылка
		|ИЗ
		|	(ВЫБРАТЬ
		|		Коллекции.Ссылка КАК Ссылка,
		|		КОЛИЧЕСТВО(ТЧКоллекций.Значение) КАК КоличествоЗначений
		|	ИЗ
		|		Справочник.КоллекцииЗначенийДоступа КАК Коллекции
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КоллекцииЗначенийДоступа.ЗначенияДоступа КАК ТЧКоллекций
		|			ПО Коллекции.Ссылка = ТЧКоллекций.Ссылка
		|	ГДЕ
		|		НЕ ТЧКоллекций.Ссылка В
		|					(ВЫБРАТЬ
		|						КоллекцииЗначенийДоступаЗначенияДоступа.Ссылка
		|					ИЗ
		|						Справочник.КоллекцииЗначенийДоступа.ЗначенияДоступа КАК КоллекцииЗначенийДоступаЗначенияДоступа
		|					ГДЕ
		|						НЕ КоллекцииЗначенийДоступаЗначенияДоступа.Значение В (&МассивЗначений))
		|	
		|	СГРУППИРОВАТЬ ПО
		|		Коллекции.Ссылка) КАК ВложенныйЗапрос
		|ГДЕ
		|	ВложенныйЗапрос.КоличествоЗначений = &КоличествоЗначений");
	
	Запрос.УстановитьПараметр("МассивЗначений", ЗначенияДоступаСокращенные);
	Запрос.УстановитьПараметр("КоличествоЗначений", ЗначенияДоступаСокращенные.Количество());
	
	Выборка = Запрос.Выполнить().Выбрать();
	КоличествоНайденныхЭлементов = Выборка.Количество();
	
	Если КоличествоНайденныхЭлементов = 0 Тогда
		
		НоваяКоллекция = Справочники.КоллекцииЗначенийДоступа.СоздатьЭлемент();
		Для Каждого Эл Из ЗначенияДоступаСокращенные Цикл
			НоваяКоллекция.ЗначенияДоступа.Добавить().Значение = Эл;
		КонецЦикла;
		
		НоваяКоллекция.Записать();
		Результат = НоваяКоллекция.Ссылка;
		
	ИначеЕсли КоличествоНайденныхЭлементов = 1 Тогда
		
		Выборка.Следующий();
		Результат = Выборка.Ссылка;
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Найдено несколько идентичных коллекций значений доступа.'; en = 'Found multiple identical collections of access values.'");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Удаляет порцию устаревших данных.
// 
// Возвращаемое значение - Булево - Истина, если были найдены устаревшие данные, в противном случае Ложь.
// 
Функция УдалитьПорциюУстаревшихДанных() Экспорт
	
	ЗапросДляПроверкиСсылок = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК Поле1
		|ИЗ
		|	РегистрСведений.РазрешенияДоступаИсключительные КАК РазрешенияДоступаИсключительные
		|ГДЕ
		|	РазрешенияДоступаИсключительные.КоллекцияЗначенийДоступа = &Коллекция
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА
		|ИЗ
		|	РегистрСведений.РазрешенияДляЛокальныхАдминистраторов КАК РазрешенияДляЛокальныхАдминистраторов
		|ГДЕ
		|	РазрешенияДляЛокальныхАдминистраторов.КоллекцияЗначенийДоступа = &Коллекция");
	
	ЗапросДляУдаления = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 500
		|	КоллекцииЗначенийДоступа.Ссылка
		|ИЗ
		|	Справочник.КоллекцииЗначенийДоступа КАК КоллекцииЗначенийДоступа
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазрешенияДоступаИсключительные КАК РазрешенияДоступаИсключительные
		|		ПО КоллекцииЗначенийДоступа.Ссылка = РазрешенияДоступаИсключительные.КоллекцияЗначенийДоступа
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазрешенияДляЛокальныхАдминистраторов КАК РазрешенияДляЛокальныхАдминистраторов
		|		ПО КоллекцииЗначенийДоступа.Ссылка = РазрешенияДляЛокальныхАдминистраторов.КоллекцияЗначенийДоступа
		|ГДЕ
		|	РазрешенияДляЛокальныхАдминистраторов.КоллекцияЗначенийДоступа ЕСТЬ NULL 
		|	И РазрешенияДоступаИсключительные.КоллекцияЗначенийДоступа ЕСТЬ NULL ");
	
	Результат = ЗапросДляУдаления.Выполнить();
	ЕстьЗаписиКУдалению = Не Результат.Пустой();
	Выборка = Результат.Выбрать();
	
	УдаленоУспешно = 0;
	НеУдалосьУдалить = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		Исключение
			// Объект может быть уже заблокирован
			НеУдалосьУдалить = НеУдалосьУдалить + 1;
			Продолжить;
		КонецПопытки;
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		
		// Удаление коллекции.
		НачатьТранзакцию();
		Попытка
			
			Объект.Удалить();
			ЗапросДляПроверкиСсылок.УстановитьПараметр("Коллекция", Выборка.Ссылка);
			РезультатЗапросаПроверки = ЗапросДляПроверкиСсылок.Выполнить();
			
			Если РезультатЗапросаПроверки.Пустой() Тогда
				ЗафиксироватьТранзакцию();
				УдаленоУспешно = УдаленоУспешно + 1;
			Иначе
				ОтменитьТранзакцию();
				НеУдалосьУдалить = НеУдалосьУдалить + 1;
			КонецЕсли;
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Удаление устаревших коллекций'; en = 'Purging outdated collections'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Выборка.Ссылка.Метаданные(),
				ПолучитьНавигационнуюСсылку(Выборка.Ссылка),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			НеУдалосьУдалить = НеУдалосьУдалить + 1;
			 
		КонецПопытки;
		
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru='Удаление устаревших данных'; en = 'Purging outdated data'"), 
		УровеньЖурналаРегистрации.Информация,
		Метаданные.Справочники.КоллекцииЗначенийДоступа,, 
		СтрШаблон(
			НСтр("ru = 'Процедура завершена.
				|Обработано записей: %1
				|Из них:
				|	Успешно - %2
				|	С ошибками - %3';
				|en = 'Process completed.
				|Records to delete: %1
				|Deleted successfully: %2
				|Failed to delete: %3'"),
			Выборка.Количество(), УдаленоУспешно, НеУдалосьУдалить));
	
	Возврат ЕстьЗаписиКУдалению;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли
