﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьСтатус();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьИндекс(Команда)
	Состояние(
		НСтр("ru = 'Идет обновление полнотекстового индекса...
		|Пожалуйста, подождите.';
		|en = 'Full-text index is being updated... 
		|Please wait.'"));
	
	ОбновитьИндексСервер();
	
	Состояние(НСтр("ru = 'Обновление полнотекстового индекса завершено.'; en = 'Full-text search index updated.'"));
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИндекс(Команда)
	Состояние(
		НСтр("ru = 'Идет очистка полнотекстового индекса...
		|Пожалуйста, подождите.';
		|en = 'Go clean up the full-text index...
		|Please wait.'"));
	
	ОчиститьИндексСервер();
	
	Состояние(НСтр("ru = 'Очистка полнотекстового индекса завершена.'; en = 'Full-text search index cleared.'"));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусИндекса.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИндексАктуален");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина, Ложь, Ложь, Ложь, ));

КонецПроцедуры

&НаСервере
Процедура ОбновитьИндексСервер()
	ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
	ОбновитьСтатус();
КонецПроцедуры

&НаСервере
Процедура ОчиститьИндексСервер()
	ПолнотекстовыйПоиск.ОчиститьИндекс();
	ОбновитьСтатус();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатус()
	
	
	РазрешитьПолнотекстовыйПоиск = (ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить);
	Если РазрешитьПолнотекстовыйПоиск Тогда
		ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
		ИндексАктуален = ПолнотекстовыйПоискСервер.ИндексПоискаАктуален();
		Элементы.ФормаОбновитьИндекс.Доступность = НЕ ИндексАктуален;
		Если ИндексАктуален Тогда
			СтатусИндекса = НСтр("ru = 'Обновление не требуется'; en = 'No update required'");
		Иначе
			СтатусИндекса = НСтр("ru = 'Требуется обновление'; en = 'Update is required'");
		КонецЕсли;
	Иначе
		ДатаАктуальностиИндекса = '00010101';
		ИндексАктуален = Ложь;
		Элементы.ФормаОбновитьИндекс.Доступность = Ложь;
		СтатусИндекса = НСтр("ru = 'Полнотекстовый поиск отключен'; en = 'Full-text search is disabled'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
