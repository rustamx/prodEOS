﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПредставлениеЗадачи(Ссылка, КодЯзыка) Экспорт
	
	Представление = "";
	
	Если ТипЗнч(Ссылка) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		Возврат Строка(Ссылка);
	КонецЕсли;
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Наименование,ра_НаименованиеБизнесПроцессаАнгл,Дата");
	
	Если КодЯзыка = "en" Тогда
		Представление = СтрШаблон("%1 of %2", СтруктураРеквизитов.ра_НаименованиеБизнесПроцессаАнгл, СтруктураРеквизитов.Дата);
	Иначе
		Представление = СтрШаблон("%1 от %2", СтруктураРеквизитов.Наименование, СтруктураРеквизитов.Дата);
	КонецЕсли;	
		
	Возврат Представление;
		
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Наименование");
	Поля.Добавить("Дата")
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекстПредставления = НСтр("ru = '%1 от %2'; en = '%1 of %2'");
	
	Представление = СтрШаблон(
		ТекстПредставления,
		Данные.Наименование,
		Данные.Дата);
			
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		КодВозврата = БизнесПроцессыИЗадачиВызовСервера.ПолучитьФормуВыполненияЗадачи(Параметры.Ключ);
		
		Если КодВозврата.Свойство("ИмяФормы") И ЗначениеЗаполнено(КодВозврата.ИмяФормы) Тогда
			ВыбраннаяФорма = КодВозврата.ИмяФормы;
			СтандартнаяОбработка = Ложь;
		КонецЕсли;		
	ИначеЕсли ВидФормы = "ФормаВыбора" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "Задача.ЗадачаИсполнителя.Форма.ФормаСписка";
		Параметры.Вставить("РежимВыбора", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбъектМетаданных = Метаданные.Задачи.ЗадачаИсполнителя;
	
	ТекстЗапросаПЕРВЫЕ = ПараметрыЗапросаHTTP.Получить("$top");
	ТекстЗапросаГДЕ = ПараметрыЗапросаHTTP.Получить("$filter");
	ТекстЗапросаУПОРЯДОЧИТЬ = ПараметрыЗапросаHTTP.Получить("$orderby");
	
	АнглоязычноеПредставлениеЗадач = ТекущийЯзык() = Метаданные.Языки.Английский;
	
	//ПЕРВЫЕ
	ТекстЗапросаПЕРВЫЕ = ПараметрыЗапросаHTTP.Получить("$top");
	
	Если ЗначениеЗаполнено(ТекстЗапросаПЕРВЫЕ) Тогда
		ТекстЗапросаПЕРВЫЕ = " ПЕРВЫЕ " + ТекстЗапросаПЕРВЫЕ + " ";
	КонецЕсли;
	
	//ВЫБРАТЬ
	ТекстЗапросаВЫБРАТЬ = СтрЗаменить(ТекстЗапросаВЫБРАТЬ, "Ref_Key", "Ссылка");
	
	//ГДЕ
	Если ЗначениеЗаполнено(ТекстЗапросаГДЕ) Тогда
		ТекстЗапросаГДЕ = СтрЗаменить(ТекстЗапросаГДЕ, "Perfomed", "ЗадачаИсполнителя.Выполнена");
		ТекстЗапросаГДЕ = СтрЗаменить(ТекстЗапросаГДЕ, "Presentation", ?(АнглоязычноеПредставлениеЗадач, "ЗадачаИсполнителя.ра_НаименованиеБизнесПроцессаАнгл", "ЗадачаИсполнителя.Наименование"));
		ТекстЗапросаГДЕ = СтрЗаменить(ТекстЗапросаГДЕ, "Deadline", "ЗадачаИсполнителя.СрокИсполнения");
		ТекстЗапросаГДЕ = СтрЗаменить(ТекстЗапросаГДЕ, "ExecutionDate", "ЗадачаИсполнителя.ДатаИсполнения");
		ТекстЗапросаГДЕ = СтрЗаменить(ТекстЗапросаГДЕ, "Overdue", "ЗадачаИсполнителя.СрокИсполнения < &ТекущаяДата");
		ТекстЗапросаГДЕ = СтрЗаменить(ТекстЗапросаГДЕ, "Ref_Key", "ЗадачаИсполнителя.Ссылка");
		
		ра_ОбменДанными.ЗаменитьУсловияODataУсловиямиВстроенногоЯзыка(ТекстЗапросаГДЕ);
		ра_ОбменДанными.ОбработатьУсловияОтбораДляДат(ТекстЗапросаГДЕ);
		
		ТаблицаРеквизитов = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек("Имя,Выражение,Тип,ДопПоле");
		СтруктураРеквизита = Новый Структура("Имя,Тип,Выражение", "Ссылка", "Задача.ЗадачаИсполнителя", "Ссылка");
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуРеквизитов(ТаблицаРеквизитов, СтруктураРеквизита);
		
		ПараметрыЗапроса = ра_ОбменДанными.ОбработатьУсловияОтбораДляСсылок(ТекстЗапросаГДЕ, ТаблицаРеквизитов);
		
		ТекстЗапросаГДЕ = " И " + ТекстЗапросаГДЕ;
	КонецЕсли;
	
	//УПОРЯДОЧИТЬ
	ТекстЗапросаУПОРЯДОЧИТЬ = СтрЗаменить(ТекстЗапросаУПОРЯДОЧИТЬ, "_Key", "");
	
	Если ЗначениеЗаполнено(ТекстЗапросаУПОРЯДОЧИТЬ) Тогда
		ТекстЗапросаУПОРЯДОЧИТЬ = СтрЗаменить(ТекстЗапросаУПОРЯДОЧИТЬ, "Perfomed", "ЗадачаИсполнителя.Выполнена");
		ТекстЗапросаУПОРЯДОЧИТЬ = СтрЗаменить(ТекстЗапросаУПОРЯДОЧИТЬ, "Presentation", ?(АнглоязычноеПредставлениеЗадач, "ЗадачаИсполнителя.ра_НаименованиеБизнесПроцессаАнгл", "ЗадачаИсполнителя.Наименование"));
		ТекстЗапросаУПОРЯДОЧИТЬ = СтрЗаменить(ТекстЗапросаУПОРЯДОЧИТЬ, "Deadline", "ЗадачаИсполнителя.СрокИсполнения");
		ТекстЗапросаУПОРЯДОЧИТЬ = СтрЗаменить(ТекстЗапросаУПОРЯДОЧИТЬ, "ExecutionDate", "ЗадачаИсполнителя.ДатаИсполнения");
		ТекстЗапросаУПОРЯДОЧИТЬ = СтрЗаменить(ТекстЗапросаУПОРЯДОЧИТЬ, "Ref_Key", "ЗадачаИсполнителя.Ссылка");
		
		ТекстЗапросаУПОРЯДОЧИТЬ = " УПОРЯДОЧИТЬ ПО " + ТекстЗапросаУПОРЯДОЧИТЬ;
	КонецЕсли;
	
	ТекстЗапроса =		
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИсполнителиРолейИДелегаты.РольПользователь КАК Исполнитель,
	|	МИНИМУМ(ИсполнителиРолейИДелегаты.НастройкаДелегирования) КАК НастройкаДелегирования
	|ПОМЕСТИТЬ ИсполнителиЗадач
	|ИЗ
	|	РегистрСведений.ИсполнителиРолейИДелегаты КАК ИсполнителиРолейИДелегаты
	|ГДЕ
	|	ИсполнителиРолейИДелегаты.ИсполнительДелегат = &ТекущийПользователь
	|	И ИсполнителиРолейИДелегаты.ИмяОбластиДелегирования В ("""", ""ПроцессыИЗадачи"")
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсполнителиРолейИДелегаты.РольПользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ %1
	|	ЗадачаИсполнителя.Ссылка КАК Задача,
	|	ЕСТЬNULL(ДанныеБизнесПроцессов.ОсновнойПредмет.Nesootvetstvie, ЗНАЧЕНИЕ(Документ.ra_Nesootvetstvie.ПустаяСсылка)) КАК Nesootvetstvie,
	|	ЕСТЬNULL(ДанныеБизнесПроцессов.ОсновнойПредмет, НЕОПРЕДЕЛЕНО) КАК ОсновнойПредмет,
	|	ЗадачаИсполнителя.БизнесПроцесс КАК БизнесПроцесс,
	|	ЗадачаИсполнителя.Дата КАК Date,
	|	ЗадачаИсполнителя.Выполнена КАК Perfomed,
	|	ВЫБОР
	|		КОГДА &АнглоязычноеПредставлениеЗадач
	|			ТОГДА ЗадачаИсполнителя.ра_НаименованиеБизнесПроцессаАнгл
	|		ИНАЧЕ ЗадачаИсполнителя.Наименование
	|	КОНЕЦ КАК Presentation,
	|	ЗадачаИсполнителя.ДатаИсполнения КАК ExecutionDate,
	|	ЗадачаИсполнителя.СрокИсполнения КАК Deadline,
	|	ЗадачаИсполнителя.СрокИсполнения < &ТекущаяДата КАК Overdue,
	|	ЗадачаИсполнителя.Исполнитель КАК Исполнитель,
	|	ЗадачаИсполнителя.ТочкаМаршрута КАК ТочкаМаршрута,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗадачаИсполнителя.БизнесПроцесс) = ТИП(БизнесПроцесс.Согласование)
	|			ТОГДА ВЫРАЗИТЬ(ЗадачаИсполнителя.БизнесПроцесс КАК БизнесПроцесс.Согласование).ra_EtapPrinyatiyaUvedomleniya
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтапПринятияУоН,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗадачаИсполнителя.БизнесПроцесс) = ТИП(БизнесПроцесс.Согласование)
	|			ТОГДА ВЫРАЗИТЬ(ЗадачаИсполнителя.БизнесПроцесс КАК БизнесПроцесс.Согласование).ПодписыватьЭП
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПодписыватьЭП,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗадачаИсполнителя.БизнесПроцесс) = ТИП(БизнесПроцесс.Согласование)
	|			ТОГДА ВЫРАЗИТЬ(ЗадачаИсполнителя.БизнесПроцесс КАК БизнесПроцесс.Согласование).НомерИтерации
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗадачаИсполнителя.БизнесПроцесс) = ТИП(БизнесПроцесс.Утверждение)
	|			ТОГДА ВЫРАЗИТЬ(ЗадачаИсполнителя.БизнесПроцесс КАК БизнесПроцесс.Утверждение).НомерИтерации
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗадачаИсполнителя.БизнесПроцесс) = ТИП(БизнесПроцесс.Исполнение)
	|			ТОГДА ВЫРАЗИТЬ(ЗадачаИсполнителя.БизнесПроцесс КАК БизнесПроцесс.Исполнение).НомерИтерации - 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НомерИтерации
	|ПОМЕСТИТЬ ЗадачиИсполнителя
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИсполнителиЗадач КАК ИсполнителиЗадач
	|		ПО ЗадачаИсполнителя.ТекущийИсполнитель = ИсполнителиЗадач.Исполнитель
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗадачиДляВыполнения КАК ЗадачиДляВыполнения
	|		ПО ЗадачаИсполнителя.Ссылка = ЗадачиДляВыполнения.Задача
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
	|		ПО ЗадачаИсполнителя.БизнесПроцесс = ДанныеБизнесПроцессов.БизнесПроцесс
	|ГДЕ
	|	ЗадачаИсполнителя.СостояниеБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Активен)
	|	И ЕСТЬNULL(ЗадачиДляВыполнения.СостояниеВыполнения, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.СостоянияЗадачДляВыполнения.ГотоваКВыполнению)
	|	И ЗадачаИсполнителя.ПометкаУдаления = ЛОЖЬ
	|	И ЗадачаИсполнителя.ИсключенаИзПроцесса = ЛОЖЬ
	|	%2
	|%3
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиИсполнителя.Задача КАК Задача,
	|	ПРЕДСТАВЛЕНИЕ(СогласованиеРезультатыСогласования.ЗадачаИсполнителя.РезультатВыполнения) КАК РезультатВыполнения,
	|	ПРЕДСТАВЛЕНИЕ(СогласованиеРезультатыСогласования.ЗадачаИсполнителя.Исполнитель) КАК Исполнитель
	|ИЗ
	|	ЗадачиИсполнителя КАК ЗадачиИсполнителя
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ БизнесПроцесс.Согласование.РезультатыСогласования КАК СогласованиеРезультатыСогласования
	|		ПО ЗадачиИсполнителя.БизнесПроцесс = СогласованиеРезультатыСогласования.Ссылка
	|			И (ЗадачиИсполнителя.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Согласование.ТочкаМаршрута.Ознакомиться))
	|			И (СогласованиеРезультатыСогласования.НомерИтерации = ЗадачиИсполнителя.НомерИтерации)
	|			И (СогласованиеРезультатыСогласования.РезультатСогласования = ЗНАЧЕНИЕ(Перечисление.РезультатыСогласования.НеСогласовано))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗадачиИсполнителя.Задача,
	|	ПРЕДСТАВЛЕНИЕ(УтверждениеРезультатыУтверждения.ЗадачаИсполнителя.РезультатВыполнения),
	|	ПРЕДСТАВЛЕНИЕ(УтверждениеРезультатыУтверждения.ЗадачаИсполнителя.Исполнитель)
	|ИЗ
	|	ЗадачиИсполнителя КАК ЗадачиИсполнителя
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ БизнесПроцесс.Утверждение.РезультатыУтверждения КАК УтверждениеРезультатыУтверждения
	|		ПО ЗадачиИсполнителя.БизнесПроцесс = УтверждениеРезультатыУтверждения.Ссылка
	|			И (ЗадачиИсполнителя.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Утверждение.ТочкаМаршрута.Ознакомиться))
	|			И (УтверждениеРезультатыУтверждения.НомерИтерации = ЗадачиИсполнителя.НомерИтерации)
	|			И (УтверждениеРезультатыУтверждения.РезультатУтверждения = ЗНАЧЕНИЕ(Перечисление.РезультатыУтверждения.НеУтверждено))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗадачиИсполнителя.Задача,
	|	ПРЕДСТАВЛЕНИЕ(ИсполнениеРезультатыПроверки.КомментарийПроверяющего),
	|	ПРЕДСТАВЛЕНИЕ(ИсполнениеРезультатыПроверки.ЗадачаПроверяющего.Исполнитель)
	|ИЗ
	|	ЗадачиИсполнителя КАК ЗадачиИсполнителя
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ БизнесПроцесс.Исполнение.РезультатыПроверки КАК ИсполнениеРезультатыПроверки
	|		ПО ЗадачиИсполнителя.БизнесПроцесс = ИсполнениеРезультатыПроверки.Ссылка
	|			И (ЗадачиИсполнителя.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Исполнение.ТочкаМаршрута.Исполнить))
	|			И (ИсполнениеРезультатыПроверки.НомерИтерации = ЗадачиИсполнителя.НомерИтерации)
	|			И (ИсполнениеРезультатыПроверки.ОтправленоНаДоработку)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗадачиИсполнителя.Задача,
	|	ПРЕДСТАВЛЕНИЕ(СогласованиеРезультатыОзнакомлений.ЗадачаИсполнителя.РезультатВыполнения),
	|	ПРЕДСТАВЛЕНИЕ(СогласованиеРезультатыОзнакомлений.ЗадачаИсполнителя.Исполнитель)
	|ИЗ
	|	ЗадачиИсполнителя КАК ЗадачиИсполнителя
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ БизнесПроцесс.Согласование.РезультатыОзнакомлений КАК СогласованиеРезультатыОзнакомлений
	|		ПО ЗадачиИсполнителя.БизнесПроцесс = СогласованиеРезультатыОзнакомлений.Ссылка
	|			И (ЗадачиИсполнителя.ТочкаМаршрута = ЗНАЧЕНИЕ(БизнесПроцесс.Согласование.ТочкаМаршрута.Согласовать))
	|			И (СогласованиеРезультатыОзнакомлений.ОтправленоНаПовторноеСогласование)
	|			И (СогласованиеРезультатыОзнакомлений.НомерИтерации + 1 = ЗадачиИсполнителя.НомерИтерации)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиИсполнителя.Задача КАК Ref_Key,
	|	ЗадачиИсполнителя.Nesootvetstvie КАК Nesootvetstvie_Key,
	|	ЗадачиИсполнителя.Date КАК Date,
	|	ЗадачиИсполнителя.Perfomed КАК Perfomed,
	|	ЗадачиИсполнителя.Presentation КАК Presentation,
	|	ЗадачиИсполнителя.ExecutionDate КАК ExecutionDate,
	|	ЗадачиИсполнителя.Deadline КАК Deadline,
	|	ЗадачиИсполнителя.Overdue КАК Overdue,
	|	ПРЕДСТАВЛЕНИЕ(ЗадачиИсполнителя.Исполнитель) КАК User,
	|	ПРЕДСТАВЛЕНИЕ(ЗадачиИсполнителя.Исполнитель.Подразделение) КАК Department,
	|	ЗадачиИсполнителя.БизнесПроцесс КАК БизнесПроцесс,
	|	ЗадачиИсполнителя.ОсновнойПредмет КАК ОсновнойПредмет,
	|	ЗадачиИсполнителя.ТочкаМаршрута КАК ТочкаМаршрута,
	|	ЗадачиИсполнителя.ЭтапПринятияУоН КАК ЭтапПринятияУоН,
	|	ЗадачиИсполнителя.ПодписыватьЭП КАК ПодписыватьЭП,
	|	ЗадачиИсполнителя.НомерИтерации КАК НомерИтерации
	|ИЗ
	|	ЗадачиИсполнителя КАК ЗадачиИсполнителя
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗадачиИсполнителя.Задача КАК Задача,
	|	ЗадачаИсполнителяПредметы.Предмет КАК Предмет,
	|	ПРЕДСТАВЛЕНИЕ(ЗадачаИсполнителяПредметы.Предмет) КАК ПредставлениеПредмета,
	|	Файлы.Ссылка КАК ОсновнойФайл
	|ИЗ
	|	ЗадачиИсполнителя КАК ЗадачиИсполнителя
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя.Предметы КАК ЗадачаИсполнителяПредметы
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК Файлы
	|			ПО ЗадачаИсполнителяПредметы.Предмет = Файлы.ВладелецФайла
	|				И (Файлы.ра_ОсновнойФайл)
	|		ПО ЗадачиИсполнителя.Задача = ЗадачаИсполнителяПредметы.Ссылка";
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("АнглоязычноеПредставлениеЗадач", АнглоязычноеПредставлениеЗадач);
	Если ПараметрыЗапроса <> Неопределено Тогда
		Для Каждого ЭлементСтруктуры ИЗ ПараметрыЗапроса Цикл
			Запрос.УстановитьПараметр(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Запрос.Текст = СтрШаблон(ТекстЗапроса, ТекстЗапросаПЕРВЫЕ, ТекстЗапросаГДЕ, ТекстЗапросаУПОРЯДОЧИТЬ);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаЗадача = РезультатЗапроса[РезультатЗапроса.Количество() - 2].Выбрать();
	
	ПредметыЗадач = РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выгрузить();
	ПредметыЗадач.Индексы.Добавить("Задача");
	
	ОтклоненныеЗадачи = РезультатЗапроса[РезультатЗапроса.Количество() - 3].Выгрузить();
	ОтклоненныеЗадачи.Индексы.Добавить("Задача");
	
	МассивДанных = Новый Массив;
	
	Пока ВыборкаЗадача.Следующий() Цикл
		
		СтруктураЗадача = Новый Структура("Date,Perfomed,Presentation,ExecutionDate,Ref_Key,Deadline,Overdue,User,Department,Nesootvetstvie_Key");
		ЗаполнитьЗначенияСвойств(СтруктураЗадача, ВыборкаЗадача);
		
		ЗаголовокКнопки = ПолучитьЗаголовокКнопки(ВыборкаЗадача);
		СтруктураЗадача.Вставить("Header", ЗаголовокКнопки);
		СтруктураЗадача.Вставить("ActionHead", СтрЗаменить(ЗаголовокКнопки, НСтр("ru = ' до'; en = ' until'"), ""));
		СтруктураЗадача.Вставить("Comment", НСтр("ru = 'Комментарий'; en = 'Comment'"));
		
		ДополнитьПредставлениеДляОтклоненныхЗадач(СтруктураЗадача, ВыборкаЗадача, ОтклоненныеЗадачи);
		
		ПредметыЗадачи = ПредметыЗадач.НайтиСтроки(Новый Структура("Задача", ВыборкаЗадача.Ref_Key));
		МассивПредметов = Новый Массив;
		
		Для каждого СтрокаПредметы Из ПредметыЗадачи Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаПредметы.Предмет) Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураПредмет = Новый Структура;
			СтруктураПредмет.Вставить("Ref_Key", СтрокаПредметы.Предмет);
			СтруктураПредмет.Вставить("Presentation", СтрокаПредметы.ПредставлениеПредмета);
			СтруктураПредмет.Вставить("Type", Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(СтрокаПредметы.Предмет))));
			СтруктураПредмет.Вставить("MainFile", ?(СтрокаПредметы.ОсновнойФайл = Null, "", СтрокаПредметы.ОсновнойФайл));
			
			МассивПредметов.Добавить(СтруктураПредмет);
		КонецЦикла;
		
		СтруктураЗадача.Вставить("Subjects", МассивПредметов);
		СтруктураЗадача.Вставить("Actions", ра_ОбменДанными.ПолучитьМассивДействийДляЗадачи(ВыборкаЗадача.Ref_Key, ВыборкаЗадача.ЭтапПринятияУоН, ВыборкаЗадача.ПодписыватьЭП, ВыборкаЗадача.ОсновнойПредмет));
		
		МассивДанных.Добавить(СтруктураЗадача);
	КонецЦикла;
	
	Результат.Вставить("value", МассивДанных);
	
	НастройкаФормы = ПараметрыЗапросаHTTP.Получить("$form_settings");
	Если ЗначениеЗаполнено(НастройкаФормы) И НастройкаФормы Тогда
		МассивКолонок = ПолучитьПолучитьМассивКолонокСписка();
		МассивКнопок = ПолучитьМассивКнопок(Запрос.Параметры);
		МассивФильтров = ПолучитьМассивФильтровСписка();
		Результат.Вставить("form_settings", МассивКолонок);
		Результат.Вставить("button_settings", МассивКнопок);
		Результат.Вставить("filter_settings", МассивФильтров);
		Результат.Вставить("filter_caption", НСтр("ru = 'Поиск/фильтр'; en = 'Search/filter'"));
		Результат.Вставить("FormCaption", НСтр("ru = 'Мои задачи'; en = 'My tasks'"));
	КонецЕсли;
	
КонецПроцедуры

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "";
	//Возврат "	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК СправочникФайлы
	//		|	ПО ОсновнаяТаблица.Ссылка = СправочникФайлы.ВладелецФайла
	//		|		И СправочникФайлы.ра_ОсновнойФайл
	//		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийДокументов.СрезПоследних КАК РС_ИсторияСостояний
	//		|	ПО ОсновнаяТаблица.Ссылка = РС_ИсторияСостояний.Документ
	//		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ра_ИндексыСтатусовВидовОбъектов КАК РС_ИндексыСтатусовВидовОбъектов
	//		|	ПО ОсновнаяТаблица.ВидДокумента = РС_ИндексыСтатусовВидовОбъектов.ВидДокумента
	//		|	И РС_ИсторияСостояний.Состояние = РС_ИндексыСтатусовВидовОбъектов.СостояниеДокумента";
	
КонецФункции

Функция СформироватьМассивДанныхРолевойМодели(ДокументОбъект, ПараметрыФормирования = Неопределено) Экспорт
	
	ТаблицаНастроек = ра_ОбменДанными.ПолучитьТаблицуНастроекПолейПоУмолчанию(Метаданные.Задачи.ЗадачаИсполнителя);
	
	//В данную переменную необходимо передавать удаляемые реквизиты. Разделитель - запятая.
	УдаляемыеРеквизиты = "Ссылка,ПометкаУдаления";
	ра_ОбменДанными.УдалитьСтрокиИзТаблицыНастроек(ТаблицаНастроек, УдаляемыеРеквизиты);
	
	АктуализироватьТаблицуНастроек(ТаблицаНастроек, ДокументОбъект, ПараметрыФормирования);
	
	ра_ОбменДанными.ЗаполнитьТаблицуНастроекЗначениямиИзОбъекта(ТаблицаНастроек, ДокументОбъект);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Процедура АктуализироватьТаблицуНастроек(ТаблицаНастроек, ДокументОбъект, ПараметрыФормирования)
	
	// Корнюшенков А.Ю. Искать в тексте "ОбменЛучшимиПрактиками" 22.10.2018 {
	Если ПараметрыФормирования <> Неопределено Тогда
		Если ПараметрыФормирования.Свойство("RedirectTask") Тогда
			ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
			ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, Новый Структура("Имя,Синоним", "FormCaption", НСтр("ru = 'Перенаправить задачу'; en = 'Redirect task'")), "String(20)",, Истина);
			ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, Новый Структура("Имя,Синоним,Тип", "Performer", НСтр("ru = 'Выбрать сотрудника'; en = 'Select employee'"), Новый ОписаниеТипов("СправочникСсылка.Пользователи")),,,Истина);
			// ТСК Близнюк С.И.; 06.12.2018; task#1992{
			//ра_ОбменДанными.ИзменитьСтрокуВТаблицеНастроек(ТаблицаНастроек, "Performer", Истина, Истина, Истина, , "FullTextSearch",,, Новый Структура("ChoiceParameters", Новый Структура("ра_Организация", XMLСтрока(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОбъект, "Исполнитель.ра_Организация")))));
			ра_ОбменДанными.ИзменитьСтрокуВТаблицеНастроек(ТаблицаНастроек, "Performer", Истина, Истина, Истина, , "FullTextSearch",,, Новый Структура("ChoiceParameters", Новый Структура("ра_Организация", XMLСтрока(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыСеанса.ТекущийПользователь, "ра_Организация")))));
			// ТСК Близнюк С.И.; 06.12.2018; task#1992}
			СтрокаНастроек = ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, Новый Структура("Имя,Синоним", "Comment", НСтр("ru = 'Комментарий'; en = 'Comment'")), "String(0)",, Истина);
			СтрокаНастроек.ОбязателенДляЗаполнения = Истина;
		КонецЕсли;
	КонецЕсли;
	// Корнюшенков А.Ю. Искать в тексте "ОбменЛучшимиПрактиками" 22.10.2018 }
	
КонецПроцедуры

Функция ПолучитьМассивКнопок(ДокументОбъект) Экспорт
	
	ВидФормы = "ФормаОбъекта";
	Если ТипЗнч(ДокументОбъект) = Тип("Структура") Тогда
		ВидФормы = "ФормаСписка";
	КонецЕсли;
	
	МассивКнопок = Новый Массив;
	
	Если ВидФормы = "ФормаСписка" Тогда
		
		ИмяКнопки = "ShowMore";
		ОписаниеКнопки = НСтр("ru = 'Показать еще'; en = 'Show more'");
		КнопкаПоказатьЕще = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		ИмяКнопки = "Find";
		ОписаниеКнопки = НСтр("ru = 'Найти'; en = 'Find'");
		КнопкаНайти = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		ИмяКнопки = "Reset";
		ОписаниеКнопки = НСтр("ru = 'Сброс'; en = 'Reset'");
		КнопкаСброс = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		ИмяКнопки = "InWork";
		ОписаниеКнопки = НСтр("ru = 'В работе'; en = 'In work'");
		КнопкаВРаботе = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки, "Boolean", false);
		
		ИмяКнопки = "Performed";
		ОписаниеКнопки = НСтр("ru = 'Выполненные'; en = 'Performed'");
		КнопкаВыполненные = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки, "Boolean", true);
		
		МассивКнопок.Добавить(КнопкаПоказатьЕще);
		МассивКнопок.Добавить(КнопкаНайти);
		МассивКнопок.Добавить(КнопкаСброс);
		МассивКнопок.Добавить(КнопкаВРаботе);
		МассивКнопок.Добавить(КнопкаВыполненные);
		
	ИначеЕсли ВидФормы = "ФормаОбъекта" Тогда
		
		// Корнюшенков А.Ю. Искать в тексте "ОбменЛучшимиПрактиками" 22.10.2018 {
		ИмяКнопки = "Save";
		ОписаниеКнопки = НСтр("ru = 'Сохранить'; en = 'Save'");
		КнопкаСохранить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		МассивКнопок.Добавить(КнопкаСохранить);
		// Корнюшенков А.Ю. Искать в тексте "ОбменЛучшимиПрактиками" 22.10.2018 }
		
	КонецЕсли;
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт
	
	ОбъектМетаданных = Метаданные.Задачи.ЗадачаИсполнителя;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МетаданныеДокумента = Метаданные.Задачи.ЗадачаИсполнителя;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	РеквизитыОбъекта = МетаданныеДокумента.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеДокумента.СтандартныеРеквизиты;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Дата);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт
	
	МассивЗаголовков = Новый Массив;
	
	Возврат МассивЗаголовков;
	
КонецФункции

Функция ПолучитьЗаголовокКнопки(ВыборкаЗадача)
	
	Если ТипЗнч(ВыборкаЗадача.БизнесПроцесс) = Тип("БизнесПроцессСсылка.Согласование") Тогда
		
		Если ВыборкаЗадача.ЭтапПринятияУоН 
			и НЕ ВыборкаЗадача.ТочкаМаршрута = БизнесПроцессы.Согласование.ТочкиМаршрута.Ознакомиться Тогда
			Возврат НСтр("ru = 'Рассмотрение до'; en = 'Reviewal until'");
		ИначеЕсли ВыборкаЗадача.ТочкаМаршрута = БизнесПроцессы.Согласование.ТочкиМаршрута.Ознакомиться Тогда
			Возврат НСтр("ru = 'Ознакомление до'; en = 'Examination until'");
		ИначеЕсли ВыборкаЗадача.ПодписыватьЭП Тогда
			// ТСК Близнюк С.И.; 15.10.2018; task#1455{
			//Возврат НСтр("ru = 'Утверждение'; en = 'Approval'");
			Возврат НСтр("ru = 'Подписание до'; en = 'Signature until'");
			// ТСК Близнюк С.И.; 15.10.2018; task#1455}
		Иначе
			Возврат НСтр("ru = 'Согласование до'; en = 'Approval until'");
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ВыборкаЗадача.БизнесПроцесс) = Тип("БизнесПроцессСсылка.Утверждение") Тогда
		
		Если ВыборкаЗадача.ТочкаМаршрута = БизнесПроцессы.Утверждение.ТочкиМаршрута.Ознакомиться Тогда
			Возврат НСтр("ru = 'Ознакомление до'; en = 'Examination until'");
		Иначе
			// ТСК Близнюк С.И.; 15.10.2018; task#1455{
			//Возврат НСтр("ru = 'Утверждение'; en = 'Approval'");
			Возврат НСтр("ru = 'Подписание до'; en = 'Signature until'");
			// ТСК Близнюк С.И.; 15.10.2018; task#1455}
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ВыборкаЗадача.БизнесПроцесс) = Тип("БизнесПроцессСсылка.Исполнение") Тогда
		
		Возврат НСтр("ru = 'Исполнение до'; en = 'Performance until'");
		
	ИначеЕсли ТипЗнч(ВыборкаЗадача.БизнесПроцесс) = Тип("БизнесПроцессСсылка.Ознакомление") Тогда
		Возврат НСтр("ru = 'Ознакомление до'; en = 'Examination until'");
	ИначеЕсли ТипЗнч(ВыборкаЗадача.БизнесПроцесс) = Тип("БизнесПроцессСсылка.Поручение") Тогда
		Возврат НСтр("ru = 'Поручение до'; en = 'The commission until'");
	ИначеЕсли ТипЗнч(ВыборкаЗадача.БизнесПроцесс) = Тип("БизнесПроцессСсылка.Приглашение") Тогда
		Возврат НСтр("ru = 'Приглашение до'; en = 'Invitation until'");
	КонецЕсли;
	
КонецФункции

Процедура ДополнитьПредставлениеДляОтклоненныхЗадач(СтруктураРез, ВыборкаЗадача, ОтклоненныеЗадачи)
	
	текстКомментарий_ = "";
	
	СтруктураОтбор = Новый Структура("Задача", ВыборкаЗадача.Ref_Key);
	
	Для Каждого СтрокаТЗ Из ОтклоненныеЗадачи.НайтиСтроки(СтруктураОтбор) Цикл
		
		Если ВыборкаЗадача.ТочкаМаршрута = БизнесПроцессы.Согласование.ТочкиМаршрута.Ознакомиться Тогда
			
			текстКомментарий_ = текстКомментарий_ + ?(ВыборкаЗадача.ПодписыватьЭП, НСтр("ru = 'Утверждающий '; en = 'Approver '"), НСтр("ru = 'Согласующий '; en = 'Matching '")) + СтрокаТЗ.Исполнитель + НСтр("ru = ' отклонил с комментарием: '''; en = ' rejected with comment: '''") + СтрокаТЗ.РезультатВыполнения + "'" + Символы.ПС;
			
		ИначеЕсли ВыборкаЗадача.ТочкаМаршрута = БизнесПроцессы.Утверждение.ТочкиМаршрута.Ознакомиться Тогда
			
			текстКомментарий_ = текстКомментарий_ + НСтр("ru = 'Утверждающий '; en = 'Approver '") + СтрокаТЗ.Исполнитель + НСтр("ru = ' отклонил с комментарием: '''; en = ' rejected with comment: '''") + СтрокаТЗ.РезультатВыполнения + "'" + Символы.ПС;
			
		ИначеЕсли ВыборкаЗадача.ТочкаМаршрута = БизнесПроцессы.Исполнение.ТочкиМаршрута.Исполнить Тогда
			
			текстКомментарий_ = текстКомментарий_ + НСтр("ru = 'Проверяющий '; en = 'Checking '") + СтрокаТЗ.Исполнитель + НСтр("ru = ' вернул на доработку с комментарием: '''; en = ' returned for revision with comment: '''") + СтрокаТЗ.РезультатВыполнения + "'" + Символы.ПС;
			
		ИначеЕсли ВыборкаЗадача.ТочкаМаршрута = БизнесПроцессы.Согласование.ТочкиМаршрута.Согласовать Тогда
			
			текстКомментарий_ = текстКомментарий_ + НСтр("ru = 'Проверяющий '; en = 'Checking '") + СтрокаТЗ.Исполнитель + НСтр("ru = ' вернул на повторное согласование с комментарием: '''; en = ' returned for reconciliation with comment: '''") + СтрокаТЗ.РезультатВыполнения + "'" + Символы.ПС;
		
		КонецЕсли;
		
	КонецЦикла;
	
	текстКомментарий_ = Лев(текстКомментарий_, СтрДлина(текстКомментарий_) - 1);
	
	Если Не ПустаяСтрока(текстКомментарий_) Тогда
		СтруктураРез.Presentation = СтруктураРез.Presentation + Символы.ПС + текстКомментарий_;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
