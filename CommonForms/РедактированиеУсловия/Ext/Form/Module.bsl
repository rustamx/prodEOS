﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИмяПредмета", ИмяПредмета);
	Параметры.Свойство("ИмяПредмета", ИсходноеИмяПредмета);
	Параметры.Свойство("Условие", Условие);
	Параметры.Свойство("Условие", ПредыдущееУсловие);
	
	Элементы.ИмяПредмета.СписокВыбора.ЗагрузитьЗначения(Параметры.ИменаПредметов);
	Если Элементы.ИмяПредмета.СписокВыбора.Количество() = 1 И Не ЗначениеЗаполнено(ИмяПредмета) Тогда
		ИмяПредмета = Элементы.ИмяПредмета.СписокВыбора.Получить(0);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(ИмяПредмета) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Поле ""Предмет"" не заполнено'; en = 'Field ""Subject"" is not filled in'"),, 
			"ИмяПредмета");
		Отказ = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Условие) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Поле ""Условие"" не заполнено'; en = 'Field ""Condition"" is not filled in'"),, 
			"Условие");
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	Если ИмяПредмета <> ИсходноеИмяПредмета Или Условие <> ПредыдущееУсловие Тогда
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("Условие",Условие);
		СтруктураВозврата.Вставить("ИмяПредмета",ИмяПредмета);
		Закрыть(СтруктураВозврата);
	Иначе
		Закрыть(Неопределено);
	КонецЕсли;
		
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Условие", Неопределено);
	СтруктураВозврата.Вставить("ИмяПредмета", Неопределено);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры


