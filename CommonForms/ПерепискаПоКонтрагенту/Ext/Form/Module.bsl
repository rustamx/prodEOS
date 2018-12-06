﻿
&НаСервере
Функция ПолучитьПризнакОтправлен(ИсходящийДокумент, Получатель, Адресат)
	
	Отправлен = Ложь;
	
	ПараметрыОтбора = Новый Структура("Получатель", Получатель);
	НайденныеСтроки = ИсходящийДокумент.Получатели.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() = 1 Тогда 
		Отправлен =	НайденныеСтроки[0].Отправлен;
	Иначе
		ПараметрыОтбора = Новый Структура("Получатель, Адресат", Получатель, Адресат);
		НайденныеСтроки = ИсходящийДокумент.Получатели.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 1 Тогда 
			Отправлен =	НайденныеСтроки[0].Отправлен;
		КонецЕсли;	
	КонецЕсли;
	
	Возврат Отправлен;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭлементыДерева = ДеревоДокументов.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Элементы.ДеревоДокументов.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодчиненныеДокументы(СтрокаДерева)
	
	Ссылка = СтрокаДерева.Ссылка;
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсходящиеДокументы.Ссылка КАК Ссылка,
		|	ИсходящиеДокументы.Заголовок КАК Заголовок,
		|	ИсходящиеДокументы.РегистрационныйНомер КАК РегистрационныйНомер,
		|	ИсходящиеДокументы.ДатаРегистрации КАК ДатаРегистрации,
		|	1 КАК ИндексКартинки
		|ИЗ
		|	Справочник.ИсходящиеДокументы КАК ИсходящиеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьВОтветНа
		|		ПО (СвязьВОтветНа.Документ = ИсходящиеДокументы.Ссылка)
		|			И (СвязьВОтветНа.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ОтправленВОтветНа))
		|ГДЕ
		|	СвязьВОтветНа.СвязанныйДокумент = &Ссылка
		|	И (НЕ ИсходящиеДокументы.ПометкаУдаления)";
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВходящиеДокументы.Ссылка КАК Ссылка,
		|	ВходящиеДокументы.Заголовок КАК Заголовок,
		|	ВходящиеДокументы.РегистрационныйНомер КАК РегистрационныйНомер,
		|	ВходящиеДокументы.ДатаРегистрации КАК ДатаРегистрации,
		|	0 КАК ИндексКартинки
		|ИЗ
		|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьВОтветНа
		|		ПО (СвязьВОтветНа.Документ = ВходящиеДокументы.Ссылка)
		|			И (СвязьВОтветНа.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПолученВОтветНа))
		|ГДЕ
		|	СвязьВОтветНа.СвязанныйДокумент = &Ссылка
		|	И (НЕ ВходящиеДокументы.ПометкаУдаления)";
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсходящиеДокументы.Ссылка КАК Ссылка,
		|	ИсходящиеДокументы.Заголовок КАК Заголовок,
		|	ИсходящиеДокументы.РегистрационныйНомер КАК РегистрационныйНомер,
		|	ИсходящиеДокументы.ДатаРегистрации КАК ДатаРегистрации,
		|	1 КАК ИндексКартинки
		|ИЗ
		|	Справочник.ИсходящиеДокументы КАК ИсходящиеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьВОтветНа
		|		ПО (СвязьВОтветНа.Документ = ИсходящиеДокументы.Ссылка)
		|			И (СвязьВОтветНа.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ОтправленВОтветНа))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
		|		ПО (СвязьПредметПереписки.Документ = ИсходящиеДокументы.Ссылка)
		|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
		|ГДЕ
		|	СвязьПредметПереписки.СвязанныйДокумент = &Ссылка
		|	И СвязьВОтветНа.СвязанныйДокумент ЕСТЬ NULL 
		|	И (НЕ ИсходящиеДокументы.ПометкаУдаления)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВходящиеДокументы.Ссылка,
		|	ВходящиеДокументы.Заголовок,
		|	ВходящиеДокументы.РегистрационныйНомер,
		|	ВходящиеДокументы.ДатаРегистрации,
		|	0
		|ИЗ
		|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьВОтветНа
		|		ПО (СвязьВОтветНа.Документ = ВходящиеДокументы.Ссылка)
		|			И (СвязьВОтветНа.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПолученВОтветНа))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
		|		ПО (СвязьПредметПереписки.Документ = ВходящиеДокументы.Ссылка)
		|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
		|ГДЕ
		|	СвязьПредметПереписки.СвязанныйДокумент = &Ссылка
		|	И СвязьВОтветНа.СвязанныйДокумент ЕСТЬ NULL 
		|	И (НЕ ВходящиеДокументы.ПометкаУдаления)";
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("СправочникСсылка.Мероприятия") Тогда 
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсходящиеДокументы.Ссылка КАК Ссылка,
		|	ИсходящиеДокументы.Заголовок КАК Заголовок,
		|	ИсходящиеДокументы.РегистрационныйНомер КАК РегистрационныйНомер,
		|	ИсходящиеДокументы.ДатаРегистрации КАК ДатаРегистрации,
		|	1 КАК ИндексКартинки
		|ИЗ
		|	Справочник.ИсходящиеДокументы КАК ИсходящиеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьВОтветНа
		|		ПО (СвязьВОтветНа.Документ = ИсходящиеДокументы.Ссылка)
		|			И (СвязьВОтветНа.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ОтправленВОтветНа))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
		|		ПО (СвязьПредметПереписки.Документ = ИсходящиеДокументы.Ссылка)
		|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
		|ГДЕ
		|	СвязьПредметПереписки.СвязанныйДокумент = &Ссылка
		|	И СвязьВОтветНа.СвязанныйДокумент ЕСТЬ NULL 
		|	И (НЕ ИсходящиеДокументы.ПометкаУдаления)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВходящиеДокументы.Ссылка,
		|	ВходящиеДокументы.Заголовок,
		|	ВходящиеДокументы.РегистрационныйНомер,
		|	ВходящиеДокументы.ДатаРегистрации,
		|	0
		|ИЗ
		|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьВОтветНа
		|		ПО (СвязьВОтветНа.Документ = ВходящиеДокументы.Ссылка)
		|			И (СвязьВОтветНа.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПолученВОтветНа))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
		|		ПО (СвязьПредметПереписки.Документ = ВходящиеДокументы.Ссылка)
		|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
		|ГДЕ
		|	СвязьПредметПереписки.СвязанныйДокумент = &Ссылка
		|	И СвязьВОтветНа.СвязанныйДокумент ЕСТЬ NULL 
		|	И (НЕ ВходящиеДокументы.ПометкаУдаления)";
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = СтрокаДерева.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка); 
		
		Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы")  Тогда 
			Отправлен = ПолучитьПризнакОтправлен(Выборка.Ссылка, Ссылка.Отправитель, Ссылка.Подписал);
			НоваяСтрока.ИндексКартинки = ?(Отправлен, 1, 3);
		КонецЕсли;
		
		ЗаполнитьПодчиненныеДокументы(НоваяСтрока);
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Функция ЗаполнитьДерево()
	
	Дерево = РеквизитФормыВЗначение("ДеревоДокументов");
	Дерево.Строки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВходящийДокумент.Ссылка КАК Ссылка,
	|	ВходящийДокумент.ДатаРегистрации,
	|	ВходящийДокумент.РегистрационныйНомер,
	|	ВходящийДокумент.Заголовок
	|ИЗ
	|	Справочник.ВходящиеДокументы КАК ВходящийДокумент
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьВОтветНа
	|		ПО (СвязьВОтветНа.Документ = ВходящийДокумент.Ссылка)
	|			И (СвязьВОтветНа.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПолученВОтветНа))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
	|		ПО (СвязьПредметПереписки.Документ = ВходящийДокумент.Ссылка)
	|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
	|ГДЕ
	|	ВходящийДокумент.Отправитель = &Контрагент
	|	И СвязьВОтветНа.СвязанныйДокумент ЕСТЬ NULL 
	|	И СвязьПредметПереписки.СвязанныйДокумент ЕСТЬ NULL 
	|	И (НЕ ВходящийДокумент.ПометкаУдаления)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ИсходящийДокумент.Ссылка,
	|	ИсходящийДокумент.ДатаРегистрации,
	|	ИсходящийДокумент.РегистрационныйНомер,
	|	ИсходящийДокумент.Заголовок
	|ИЗ
	|	Справочник.ИсходящиеДокументы КАК ИсходящийДокумент
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьВОтветНа
	|		ПО (СвязьВОтветНа.Документ = ИсходящийДокумент.Ссылка)
	|			И (СвязьВОтветНа.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ОтправленВОтветНа))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
	|		ПО (СвязьПредметПереписки.Документ = ИсходящийДокумент.Ссылка)
	|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
	|ГДЕ
	|	&Контрагент В
	|			(ВЫБРАТЬ
	|				ИсходящийДокументПолучатели.Получатель
	|			ИЗ
	|				Справочник.ИсходящиеДокументы.Получатели КАК ИсходящийДокументПолучатели
	|			ГДЕ
	|				ИсходящийДокументПолучатели.Ссылка = ИсходящийДокумент.Ссылка)
	|	И СвязьВОтветНа.СвязанныйДокумент ЕСТЬ NULL 
	|	И СвязьПредметПереписки.СвязанныйДокумент ЕСТЬ NULL 
	|	И (НЕ ИсходящийДокумент.ПометкаУдаления)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СвязьПредметПереписки.СвязанныйДокумент,
	|	ОбщиеРеквизитыПредметаПереписки.ДатаРегистрации,
	|	ОбщиеРеквизитыПредметаПереписки.РегистрационныйНомер,
	|	ОбщиеРеквизитыПредметаПереписки.Заголовок
	|ИЗ
	|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
	|		ПО ВходящиеДокументы.Ссылка = СвязьПредметПереписки.Документ
	|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОбщиеРеквизитыДокументов КАК ОбщиеРеквизитыПредметаПереписки
	|		ПО (ОбщиеРеквизитыПредметаПереписки.Документ = СвязьПредметПереписки.СвязанныйДокумент)
	|ГДЕ
	|	ВходящиеДокументы.Отправитель = &Контрагент
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СвязьПредметПереписки.СвязанныйДокумент,
	|	ОбщиеРеквизитыПредметаПереписки.ДатаРегистрации,
	|	ОбщиеРеквизитыПредметаПереписки.РегистрационныйНомер,
	|	ОбщиеРеквизитыПредметаПереписки.Заголовок
	|ИЗ
	|	Справочник.ИсходящиеДокументы КАК ИсходящиеДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
	|		ПО ИсходящиеДокументы.Ссылка = СвязьПредметПереписки.Документ
	|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОбщиеРеквизитыДокументов КАК ОбщиеРеквизитыПредметаПереписки
	|		ПО (ОбщиеРеквизитыПредметаПереписки.Документ = СвязьПредметПереписки.СвязанныйДокумент)
	|ГДЕ
	|	&Контрагент В
	|			(ВЫБРАТЬ
	|				ИсходящийДокументПолучатели.Получатель
	|			ИЗ
	|				Справочник.ИсходящиеДокументы.Получатели КАК ИсходящийДокументПолучатели
	|			ГДЕ
	|				ИсходящийДокументПолучатели.Ссылка = ИсходящиеДокументы.Ссылка)";
	
	Запрос.УстановитьПараметр("Контрагент", Параметры.Контрагент);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеМероприятиями")
		И ПравоДоступа("Чтение", Метаданные.Справочники.Мероприятия) Тогда
		
		Запрос.Текст = Запрос.Текст + "
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СвязьПредметПереписки.СвязанныйДокумент,
			|	Неопределено,
			|	Неопределено,
			|	Мероприятия.Наименование
			|ИЗ
			|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
			|		ПО ВходящиеДокументы.Ссылка = СвязьПредметПереписки.Документ
			|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Мероприятия КАК Мероприятия
			|		ПО (Мероприятия.Ссылка = СвязьПредметПереписки.СвязанныйДокумент)
			|ГДЕ
			|	ВходящиеДокументы.Отправитель = &Контрагент
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СвязьПредметПереписки.СвязанныйДокумент,
			|	Неопределено,
			|	Неопределено,
			|	Мероприятия.Наименование
			|ИЗ
			|	Справочник.ИсходящиеДокументы КАК ИсходящиеДокументы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязьПредметПереписки
			|		ПО ИсходящиеДокументы.Ссылка = СвязьПредметПереписки.Документ
			|			И (СвязьПредметПереписки.ТипСвязи = ЗНАЧЕНИЕ(Справочник.ТипыСвязей.ПредметПереписки))
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Мероприятия КАК Мероприятия
			|		ПО (Мероприятия.Ссылка = СвязьПредметПереписки.СвязанныйДокумент)
			|ГДЕ
			|	&Контрагент В
			|			(ВЫБРАТЬ
			|				ИсходящийДокументПолучатели.Получатель
			|			ИЗ
			|				Справочник.ИсходящиеДокументы.Получатели КАК ИсходящийДокументПолучатели
			|			ГДЕ
			|				ИсходящийДокументПолучатели.Ссылка = ИсходящиеДокументы.Ссылка)"
		
	КонецЕсли;
	
	ТаблДокументов = Запрос.Выполнить().Выгрузить();
	ТаблДокументов.Сортировать("ДатаРегистрации");
	
	Для Каждого Строка Из ТаблДокументов Цикл
		
		НоваяСтрока = Дерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка); 
		
		Если ТипЗнч(НоваяСтрока.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
			НоваяСтрока.ИндексКартинки = 0;
		ИначеЕсли ТипЗнч(НоваяСтрока.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 
			Если НоваяСтрока.Ссылка.Получатели.Найти(Истина, "Отправлен") <> Неопределено Тогда 
				НоваяСтрока.ИндексКартинки = 1;
			Иначе
				НоваяСтрока.ИндексКартинки = 3;
			КонецЕсли;
		ИначеЕсли ТипЗнч(НоваяСтрока.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
			НоваяСтрока.ИндексКартинки = 2;
		ИначеЕсли ТипЗнч(НоваяСтрока.Ссылка) = Тип("СправочникСсылка.Мероприятия") Тогда
			НоваяСтрока.ИндексКартинки = 2;
		КонецЕсли;
		
		ЗаполнитьПодчиненныеДокументы(НоваяСтрока);
		
	КонецЦикла;	
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоДокументов");
	
КонецФункции

&НаКлиенте
Процедура ДеревоДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ДеревоДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьДерево();
	
	ЭлементыДерева = ДеревоДокументов.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Элементы.ДеревоДокументов.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоДокументовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ДеревоДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры


