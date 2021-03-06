﻿&НаКлиенте
Перем ОписаниеДанных Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СохранятьВсеПодписи = Параметры.СохранятьВсеПодписи;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокДанных) Тогда
		Элементы.ПредставлениеДанных.Заголовок = Параметры.ЗаголовокДанных;
	Иначе
		Элементы.ПредставлениеДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЕсли;
	
	ПредставлениеДанных = Параметры.ПредставлениеДанных;
	Элементы.ПредставлениеДанных.Гиперссылка = Параметры.ПредставлениеДанныхОткрывается;
	
	Если Не ЗначениеЗаполнено(ПредставлениеДанных) Тогда
		Элементы.ПредставлениеДанных.Видимость = Ложь;
	КонецЕсли;
	
	Если Не Параметры.ПоказатьКомментарий Тогда
		Элементы.ТаблицаПодписейКомментарий.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьПодписи(Параметры.Объект);
	
	БольшеНеСпрашивать = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СохранятьВсеПодписи Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеДанныхНажатие(Элемент, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПредставлениеДанныхНажатие(ЭтотОбъект,
		Элемент, СтандартнаяОбработка, ОписаниеДанных);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПодпись(Команда)
	
	Если БольшеНеСпрашивать Тогда
		ЗапомнитьБольшеНеСпрашивать();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	Закрыть(ТаблицаПодписей);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаПодписейАвторПодписи.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаПодписейДатаПодписи.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаПодписейКомментарий.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаПодписей.Неверна");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодписи(Объект)
	
	Если ТипЗнч(Объект) = Тип("Строка") Тогда
		КоллекцияПодписей = ПолучитьИзВременногоХранилища(Объект);
	Иначе
		КоллекцияПодписей = КоллекцияПодписей(Объект);
	КонецЕсли;
	
	Для каждого ВсеСвойстваПодписи Из КоллекцияПодписей Цикл
		НоваяСтрока = ТаблицаПодписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВсеСвойстваПодписи);
		
		НоваяСтрока.АдресПодписи = ПоместитьВоВременноеХранилище(
			ВсеСвойстваПодписи.Подпись.Получить(), УникальныйИдентификатор);
		
		НоваяСтрока.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция КоллекцияПодписей(ОбъектСсылка)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЭлектронныеПодписи.Подпись КАК Подпись,
	|	ЭлектронныеПодписи.УстановившийПодпись КАК УстановившийПодпись,
	|	ЭлектронныеПодписи.Комментарий КАК Комментарий,
	|	ЭлектронныеПодписи.ИмяФайлаПодписи КАК ИмяФайлаПодписи,
	|	ЭлектронныеПодписи.ДатаПодписи КАК ДатаПодписи,
	|	ЭлектронныеПодписи.КомуВыданСертификат КАК КомуВыданСертификат,
	|	ЭлектронныеПодписи.ПодписьВерна КАК ПодписьВерна
	|ИЗ
	|	&ЭлектронныеПодписи КАК ЭлектронныеПодписи
	|ГДЕ
	|	ЭлектронныеПодписи.Ссылка = &СсылкаНаОбъект";
	
	ОбъектМетаданных = ОбъектСсылка.Метаданные();
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("СсылкаНаОбъект", ОбъектСсылка);
	
	Если Не ОбъектСсылка.Метаданные().ТабличныеЧасти.найти("ЭлектронныеПодписи") = Неопределено Тогда
		
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&ЭлектронныеПодписи",
			ОбъектМетаданных.ПолноеИмя() + ".ЭлектронныеПодписи");
	
		Если ОбъектМетаданных.ТабличныеЧасти.ЭлектронныеПодписи.Реквизиты.Найти("ПодписьВерна") = Неопределено Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "ЭлектронныеПодписи.ПодписьВерна", "ЛОЖЬ");
		КонецЕсли;
	Иначе
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&ЭлектронныеПодписи",
			"РегистрСведений.ЭлектронныеПодписи");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ЭлектронныеПодписи.Ссылка = &СсылкаНаОбъект",
			"ЭлектронныеПодписи.Объект = &СсылкаНаОбъект");
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗапомнитьБольшеНеСпрашивать()
	
	ЧастьНастроек = Новый Структура("ДействияПриСохраненииСЭП", "СохранятьВсеПодписи");
	ЭлектроннаяПодписьСлужебный.СохранитьПерсональныеНастройки(ЧастьНастроек);
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
