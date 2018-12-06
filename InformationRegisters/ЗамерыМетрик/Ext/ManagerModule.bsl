﻿
#Область СлужебныеПроцедурыИФункции

// Удаляет порцию устаревших данных.
// 
// Возвращаемое значение - Булево - Истина, если были найдены устаревшие данные, в противном случае Ложь.
// 
Функция УдалитьПорциюУстаревшихДанных() Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 5000
		|	ЗамерыМетрик.Показатель КАК Показатель,
		|	ЗамерыМетрик.Дата КАК Дата
		|ИЗ
		|	РегистрСведений.ЗамерыМетрик КАК ЗамерыМетрик
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Метрики КАК Метрики
		|		ПО ЗамерыМетрик.Показатель = Метрики.Ссылка
		|ГДЕ
		|	Метрики.ПериодХранения <> 0
		|	И РАЗНОСТЬДАТ(ЗамерыМетрик.Дата, &ТекущаяДата, ДЕНЬ) > Метрики.ПериодХранения
		|
		|УПОРЯДОЧИТЬ ПО
		|	Показатель,
		|	Дата");
		
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Результат = Запрос.Выполнить();
	ЕстьДанныеКУдалению = Не Результат.Пустой();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = РегистрыСведений.ЗамерыМетрик.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		Запись.Удалить();
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru='Удаление устаревших данных'; en = 'Purging outdated data'"), 
		УровеньЖурналаРегистрации.Информация,
		Метаданные.РегистрыСведений.ЗамерыМетрик,, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура завершена успешно, обработано %1 записей'; en = 'Procedure completed successfully, processed %1 records'"), Выборка.Количество()));
	
	Возврат ЕстьДанныеКУдалению;
	
КонецФункции

#КонецОбласти
