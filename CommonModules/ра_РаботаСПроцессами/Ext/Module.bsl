﻿
Функция ГоловнойПроцесс(Процесс)
	
	ГоловнойПроцесс = Неопределено;
	
	РеквизитыПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Процесс,
		"ВедущаяЗадача, ВедущаяЗадача.БизнесПроцесс, ГлавнаяЗадача, ГлавнаяЗадача.БизнесПроцесс");
	
	Если ЗначениеЗаполнено(РеквизитыПроцесса.ВедущаяЗадача) Тогда
		ГоловнойПроцесс = ГоловнойПроцесс(РеквизитыПроцесса.ВедущаяЗадачаБизнесПроцесс);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РеквизитыПроцесса.ГлавнаяЗадача) Тогда
		ГоловнойПроцесс = ГоловнойПроцесс(РеквизитыПроцесса.ГлавнаяЗадачаБизнесПроцесс);
	КонецЕсли;
	
	Если ГоловнойПроцесс = Неопределено Тогда
		ГоловнойПроцесс = Процесс;
	КонецЕсли;
	
	Возврат ГоловнойПроцесс;
	
КонецФункции

// Функция выполняет запуск всех связанных с документов процессов. В случае некорректности исходных данных процесс не запускается и возвращается текст ошибки.
//
// Параметры:
//  ДокументСсылка  - <Документ.Ссылка> - Документ ЕОК
//
// Возвращаемое значение:
//   Струткура   - Результат выполнения функции
//	 Струткура.Отказ - булево
//	 Струткура.СообщенияОбОшибке - массив
//
Функция ЗапускПроцессовДляНовогоДокумента(ДокументСсылка) Экспорт

	СтруктураРезультата = Новый Структура("Отказ,СообщенияОбОшибке", Ложь, Новый Массив);
	
	//1. Получим шаблон БП
	ШаблоныДляАвтоЗапускаЗакрытиеКарточки = ИнтерактивныйЗапускБизнесПроцессов.ПолучитьШаблоныДляАвтоЗапуска(
		Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданногоВнутреннегоДокумента,
		ДокументСсылка.ВидДокумента, Справочники.Организации.ПустаяСсылка(), ДокументСсылка);
		
	Если ШаблоныДляАвтоЗапускаЗакрытиеКарточки.Количество() = 0 тогда
		СтруктураРезультата.Отказ = истина;
		СтруктураРезультата.СообщенияОбОшибке.Добавить("Не определен ни один шаблон");
	КонецЕсли;
	
	Для каждого ЭлементШаблона из ШаблоныДляАвтоЗапускаЗакрытиеКарточки цикл 
		Шаблон = ЭлементШаблона.Значение;
		
		//2. Получим имя процесса
		ИмяПроцесса = Справочники[Шаблон.Метаданные().Имя].ИмяПроцесса(Шаблон);
		Если не ЗначениеЗаполнено(ИмяПроцесса) тогда
			СтруктураРезультата.Отказ = истина;
			СтруктураРезультата.СообщенияОбОшибке.Добавить("Не определен бизнесс-процесс по шаблону");
			Продолжить;
		КонецЕсли;
		
		//3. Создадим новый БП
		БП = БизнесПроцессы[ИмяПроцесса].СоздатьБизнесПроцесс();
		//БП = БизнесПроцессы.Согласование.СоздатьБизнесПроцесс();
		БП.Заполнить(Новый Структура("Предметы,Шаблон", ДокументСсылка, Шаблон));
		
		Отказ = ложь; ПроверятьПриИзменении = Ложь;
		Мультипредметность.ПроверитьПраваУчастниковПроцессаНаПредметы(БП, Отказ, ПроверятьПриИзменении);
		БП.Записать();
		БП.Старт();
		
	КонецЦикла;
	
	Возврат СтруктураРезультата;

КонецФункции // ЗапускПроцессовДляНовогоДокумента()

// Добавляет фоновый процесс согласования задачи
//
// Параметры:
//  ЗадачаСсылка  - <Задачи.ЗадачаИсполнителя> 
//
Процедура ДобавитьЗадачуДляФоновогоВыполнения(ЗадачаСсылка, ПараметрыФоновогоВыполнения) 
	
	Попытка
		
	РегистрыСведений.ЗадачиДляВыполнения.ДобавитьЗадачуДляФоновогоВыполнения(ЗадачаСсылка, ПараметрыФоновогоВыполнения);
	
	Исключение
	
	Сообщить("Ошибка запуска фонового процесса");
	
	КонецПопытки;

КонецПроцедуры // СогласоватьЗадачу()

// Получает имя процесса связанного с задачей. Использовать для определения доступных действий с задачей.
//
// Параметры:
//  ЗадачаСсылка  - <Задачи.ЗадачаИсполнителя> 
//
// Возвращаемое значение:
//   Строка   - Имя процесса (Согласование, Ознакомление и т.д.)
//
Функция ПолучитьИмяПроцессаЗадачи(ЗадачаСсылка) Экспорт

	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗадачаСсылка, "БизнесПроцесс, ТочкаМаршрута");
	Если Реквизиты.БизнесПроцесс = Неопределено Или Реквизиты.БизнесПроцесс.Пустая() Тогда
		Возврат "";
	КонецЕсли;
	
	ТипБизнесПроцесса = Метаданные.НайтиПоТипу(ТипЗнч(Реквизиты.БизнесПроцесс));
	Возврат ТипБизнесПроцесса.Имя;

КонецФункции // ПолучитьИмяПроцессаЗадачи()

// Получает струткуру данных по текущему процессу для документа
//
// Параметры:
//  <ДокументСсылка>  - <Ссылка на документ ЕОС>
//
// Возвращаемое значение:
//   <Структура>   - СтатусПроцесса, ТекущееСостояниеКартыМаршрута
//
Функция ПолучитьИнформациюПоПроцессуДляДокумента(ДокументСсылка) экспорт
	
	СтруктураВозврата = Новый Структура("СтатусПроцесса, ТекущееСостояниеКартыМаршрута", Неопределено, Неопределено);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗадачаИсполнителяПредметы.Ссылка КАК Ссылка,
		|	ТекущиеСостоянияДокументов.Состояние КАК Состояние,
		|	ЗадачаИсполнителяПредметы.Ссылка.БизнесПроцесс КАК БизнесПроцесс
		|ИЗ
		|	Задача.ЗадачаИсполнителя.Предметы КАК ЗадачаИсполнителяПредметы,
		|	РегистрСведений.ТекущиеСостоянияДокументов КАК ТекущиеСостоянияДокументов
		|ГДЕ
		|	ЗадачаИсполнителяПредметы.Предмет = &Предмет
		|	И ЗадачаИсполнителяПредметы.Ссылка.ПометкаУдаления = ЛОЖЬ
		|	И ЗадачаИсполнителяПредметы.Ссылка.Выполнена = ЛОЖЬ
		|	И ТекущиеСостоянияДокументов.Документ = &Предмет";
	
	Запрос.УстановитьПараметр("Предмет", ДокументСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ГоловнойПроцесс = Неопределено;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ГоловнойПроцесс = ГоловнойПроцесс(ВыборкаДетальныеЗаписи.БизнесПроцесс);
		СтруктураВозврата.СтатусПроцесса = ВыборкаДетальныеЗаписи.Состояние;
		Если ЗначениеЗаполнено(ГоловнойПроцесс) тогда
			СтруктураВозврата.ТекущееСостояниеКартыМаршрута = ГоловнойПроцесс.ПолучитьОбъект().ПолучитьКартуМаршрута();
		КонецЕсли;
	КонецЦикла;

	Возврат СтруктураВозврата;	

КонецФункции // ПолучитьИнформациюПоПроцессуДляДокумента()

// <Описание функции>
//
// Параметры:
//  ПользовательСсылка - Справочник.Пользователи
//
// Возвращаемое значение:
//   <ТаблицаЗначений>   
//
Функция ПолучениеСпискаАктивныхЗадачПользователя(ПользовательСсылка) экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Исполнитель",ПользовательСсылка);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачаИсполнителя.Ссылка КАК Ссылка,
		|	ЗадачаИсполнителя.Исполнитель КАК Исполнитель
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.Выполнена = ЛОЖЬ
		|	И ЗадачаИсполнителя.ПометкаУдаления = ЛОЖЬ
		|	И ЗадачаИсполнителя.Исполнитель = &Исполнитель";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции // ПолучениеСпискаАктивныхЗадачПользователя()

// <Описание функции>
//
// Параметры:
//  ЗадачаСсылка  - <Задачи.ЗадачаИсполнителя>
//
// Возвращаемое значение:
//   <Структура>   - ключи определяются по БП задачи
//
Функция ПолучениеСтруктурыВозможныхДействий(ЗадачаСсылка) экспорт
	
	СтруктураВозврата = Новый Структура;

	ИмяБП = ЗадачаСсылка.БизнесПроцесс.Метаданные().Имя;
	СтруктураВозврата.Вставить("ИмяБП", ИмяБП);

	Если ИмяБП = "Исполнение" тогда
		СтруктураВозврата.Вставить("Исполнено", ложь);
		СтруктураВозврата.Вставить("Комментарий", "");
	ИначеЕсли ИмяБП = "Ознакомление" тогда
		СтруктураВозврата.Вставить("Ознакомился", ложь);
		СтруктураВозврата.Вставить("Комментарий", "");
	ИначеЕсли ИмяБП = "Поручение" тогда
		СтруктураВозврата.Вставить("Выполнено", ложь);
		СтруктураВозврата.Вставить("Комментарий", "");
	ИначеЕсли ИмяБП = "Рассмотрение" тогда
		СтруктураВозврата.Вставить("Выполнено", ложь);
		СтруктураВозврата.Вставить("Комментарий", "");
	ИначеЕсли ИмяБП = "Регистрация" тогда
		СтруктураВозврата.Вставить("Зарегистрировано", ложь);
		СтруктураВозврата.Вставить("НеЗарегистрировано", ложь);
		СтруктураВозврата.Вставить("Комментарий", "");
	ИначеЕсли ИмяБП = "Согласование" тогда
		СтруктураВозврата.Вставить("Согласовано", ложь);
		СтруктураВозврата.Вставить("НеСогласовано", ложь);
		СтруктураВозврата.Вставить("СогласованоСЗамечаниями", ложь);
		СтруктураВозврата.Вставить("Комментарий", "");
	ИначеЕсли ИмяБП = "Утверждение" тогда
		СтруктураВозврата.Вставить("Утверждено", ложь);
		СтруктураВозврата.Вставить("НеУтверждено", ложь);
		СтруктураВозврата.Вставить("Комментарий", "");
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции // ПолучениеСтруктурыВозможныхДействий()

// <Описание функции>
//
// Параметры:
//  ЗадачаСсылка  - <Задачи.ЗадачаИсполнителя>
//
// Возвращаемое значение:
//   <Структура>   - ключи определяются по БП задачи
//
Функция ВыполнитьДействиеБП(ЗадачаСсылка, СтруктураДействия) экспорт
	
	ИмяБП = СтруктураДействия.ИмяБП;
	
	Если ЗначениеЗаполнено(СтруктураДействия.Комментарий) тогда
		ЗадачаОбъект = ЗадачаСсылка.ПолучитьОбъект();
		ЗадачаОбъект.РезультатВыполнения = СтруктураДействия.Комментарий;
		ЗадачаОбъект.Записать();
	КонецЕсли;

	Если ИмяБП = "Исполнение" тогда
		//	СтруктураВозврата.Вставить("Исполнено", ложь);
		//	СтруктураВозврата.Вставить("Комментарий", "");
		Если СтруктураДействия.Исполнено тогда
			ПараметрыФоновогоВыполнения = Новый Структура("РезультатСогласования", Перечисления.РезультатыСогласования.Согласовано);
			ДобавитьЗадачуДляФоновогоВыполнения(ЗадачаСсылка, ПараметрыФоновогоВыполнения);
		КонецЕсли;			
	ИначеЕсли ИмяБП = "Ознакомление" тогда
		//	СтруктураВозврата.Вставить("Ознакомился", ложь);
		//	СтруктураВозврата.Вставить("Комментарий", "");
		//ИначеЕсли ИмяБП = "Поручение" тогда
		//	СтруктураВозврата.Вставить("Выполнено", ложь);
		//	СтруктураВозврата.Вставить("Комментарий", "");
		//ИначеЕсли ИмяБП = "Рассмотрение" тогда
		//	СтруктураВозврата.Вставить("Выполнено", ложь);
		//	СтруктураВозврата.Вставить("Комментарий", "");
		//ИначеЕсли ИмяБП = "Регистрация" тогда
		//	СтруктураВозврата.Вставить("Зарегистрировано", ложь);
		//	СтруктураВозврата.Вставить("НеЗарегистрировано", ложь);
		//	СтруктураВозврата.Вставить("Комментарий", "");
	ИначеЕсли ИмяБП = "Согласование" тогда
		Если СтруктураДействия.Согласовано тогда
			ПараметрыФоновогоВыполнения = Новый Структура("РезультатСогласования", Перечисления.РезультатыСогласования.Согласовано);
			ДобавитьЗадачуДляФоновогоВыполнения(ЗадачаСсылка, ПараметрыФоновогоВыполнения);
		ИначеЕсли СтруктураДействия.НеСогласовано тогда
			ПараметрыФоновогоВыполнения = Новый Структура("РезультатСогласования", Перечисления.РезультатыСогласования.НеСогласовано);
			ДобавитьЗадачуДляФоновогоВыполнения(ЗадачаСсылка, ПараметрыФоновогоВыполнения);
		ИначеЕсли СтруктураДействия.СогласованоСЗамечаниями тогда
			ПараметрыФоновогоВыполнения = Новый Структура("РезультатСогласования", Перечисления.РезультатыСогласования.СогласованоСЗамечаниями);
			ДобавитьЗадачуДляФоновогоВыполнения(ЗадачаСсылка, ПараметрыФоновогоВыполнения);
		КонецЕсли;	
	ИначеЕсли ИмяБП = "Утверждение" тогда
		//	СтруктураВозврата.Вставить("Утверждено", ложь);
		//	СтруктураВозврата.Вставить("НеУтверждено", ложь);
		//	СтруктураВозврата.Вставить("Комментарий", "");
	КонецЕсли;
	
	Возврат истина;
	
КонецФункции // ПолучениеСтруктурыВозможныхДействий()

Функция ПолучитьАктивныеЗадачиПоПредмету(Предмет) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ЗадачаИсполнителя.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗадачаИсполнителя.БизнесПроцесс) = ТИП(БизнесПроцесс.СОгласование)
	|			ТОГДА ВЫРАЗИТЬ(ЗадачаИсполнителя.БизнесПроцесс КАК БизнесПроцесс.Согласование).ra_EtapPrinyatiyaUvedomleniya
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтапПринятияУоН,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ЗадачаИсполнителя.БизнесПроцесс) = ТИП(БизнесПроцесс.СОгласование)
	|			ТОГДА ВЫРАЗИТЬ(ЗадачаИсполнителя.БизнесПроцесс КАК БизнесПроцесс.Согласование).ПодписыватьЭП
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПодписыватьЭП
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|		ЛЕВОЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя.Предметы КАК ЗадачаИсполнителяПредметы
	|		ПО ЗадачаИсполнителя.Ссылка = ЗадачаИсполнителяПредметы.Ссылка
	|ГДЕ
	|	ЗадачаИсполнителя.Выполнена = ЛОЖЬ
	|	И ЗадачаИсполнителя.ПометкаУдаления = ЛОЖЬ
	|	И ЗадачаИсполнителя.СостояниеБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Активен)
	|	И ЗадачаИсполнителяПредметы.Предмет = &Предмет
	|	И ЗадачаИсполнителя.ТекущийИсполнитель В
	|			(ВЫБРАТЬ
	|				СоставСубъектовПравДоступа.Пользователь КАК Пользователь
	|			ИЗ
	|				РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
	|			ГДЕ
	|				СоставСубъектовПравДоступа.ПользовательОснование = &Пользователь
	|				И СоставСубъектовПравДоступа.ОбъектОснование ССЫЛКА Справочник.ДелегированиеПрав
	|		
	|			ОБЪЕДИНИТЬ ВСЕ
	|		
	|			ВЫБРАТЬ
	|				&Пользователь)");
	
	Запрос.УстановитьПараметр("Предмет", Предмет);
	Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьЭтапыСогласованияПоДокументу(Предмет) Экспорт 
	
	Запрос = Новый Запрос;
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КомплексныйПроцессПредметы.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ КомплексныеБППоПредмету
		|ИЗ
		|	БизнесПроцесс.КомплексныйПроцесс.Предметы КАК КомплексныйПроцессПредметы
		|ГДЕ
		|	КомплексныйПроцессПредметы.Предмет = &Предмет
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КомплексныйПроцессЭтапы.Ссылка КАК Ссылка,
		|	КомплексныйПроцессЭтапы.ЗапущенныйБизнесПроцесс КАК ЗапущенныйБизнесПроцесс,
		|	КомплексныйПроцессЭтапы.ШаблонБизнесПроцесса КАК ШаблонБизнесПроцесса,
		|	КомплексныйПроцессЭтапы.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ДанныеОКомплексномБП
		|ИЗ
		|	КомплексныеБППоПредмету КАК КомплексныеБППоПредмету
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ БизнесПроцесс.КомплексныйПроцесс.Этапы КАК КомплексныйПроцессЭтапы
		|		ПО КомплексныеБППоПредмету.Ссылка = КомплексныйПроцессЭтапы.Ссылка
		// ТСК Близнюк С.И.; 25.12.2018; task#2009{
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СхемыКомплексныхПроцессовПараметрыДействий.Ссылка,
		|	СхемыКомплексныхПроцессовПараметрыДействий.Процесс,
		|	СхемыКомплексныхПроцессовПараметрыДействий.ШаблонПроцесса,
		|	СхемыКомплексныхПроцессовПараметрыДействий.НомерСтроки
		|ИЗ
		|	КомплексныеБППоПредмету КАК КомплексныеБППоПредмету
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СхемыКомплексныхПроцессов.ПараметрыДействий КАК СхемыКомплексныхПроцессовПараметрыДействий
		|		ПО КомплексныеБППоПредмету.Ссылка = СхемыКомплексныхПроцессовПараметрыДействий.Ссылка.ВладелецСхемы
		//|			И (СхемыКомплексныхПроцессовПараметрыДействий.Процесс.Стартован)
		// ТСК Близнюк С.И.; 25.12.2018; task#2009}
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка,
		|	ЗапущенныйБизнесПроцесс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсполнениеРезультатыИсполнения.ЗадачаИсполнителя КАК ЗадачаИсполнителя,
		|	ИсполнениеРезультатыИсполнения.НомерИтерации КАК НомерИтерации,
		|	ИсполнениеРезультатыИсполнения.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ИсполнениеРезультатыИсполнения.ЗадачаИсполнителя.Выполнена
		|			ТОГДА ""Исполнено""
		|		ИНАЧЕ ""Не исполнено""
		|	КОНЕЦ КАК Результат
		|ПОМЕСТИТЬ ИтерацииОбработки
		|ИЗ
		|	БизнесПроцесс.Исполнение.РезультатыИсполнения КАК ИсполнениеРезультатыИсполнения
		|ГДЕ
		|	ИсполнениеРезультатыИсполнения.Ссылка В
		|			(ВЫБРАТЬ
		|				т.ЗапущенныйБизнесПроцесс
		|			ИЗ
		|				ДанныеОКомплексномБП КАК т
		|			СГРУППИРОВАТЬ ПО
		|				т.ЗапущенныйБизнесПроцесс)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СогласованиеРезультатыСогласования.ЗадачаИсполнителя,
		|	СогласованиеРезультатыСогласования.НомерИтерации,
		|	СогласованиеРезультатыСогласования.Ссылка,
		|	ВЫБОР
		|		КОГДА СогласованиеРезультатыСогласования.РезультатСогласования = &ПустойРезультатСогласования
		|			ТОГДА ВЫБОР
		|					КОГДА СогласованиеРезультатыСогласования.Ссылка.ra_EtapPrinyatiyaUvedomleniya
		|						ТОГДА ""На рассмотрении""
		|					КОГДА СогласованиеРезультатыСогласования.Ссылка.ПодписыватьЭП
		|						ТОГДА ""На утверждении""
		|					ИНАЧЕ ""На согласовании""
		|				КОНЕЦ
		|		КОГДА СогласованиеРезультатыСогласования.РезультатСогласования = &ПоложительныйРезультатСогласования
		|			ТОГДА ВЫБОР
		|					КОГДА СогласованиеРезультатыСогласования.Ссылка.ra_EtapPrinyatiyaUvedomleniya
		|						ТОГДА ""Принято""
		|					КОГДА СогласованиеРезультатыСогласования.Ссылка.ПодписыватьЭП
		|						ТОГДА ""Утверждено""
		|					ИНАЧЕ ПРЕДСТАВЛЕНИЕ(СогласованиеРезультатыСогласования.РезультатСогласования)
		|				КОНЕЦ
		|		ИНАЧЕ ВЫБОР
		|				КОГДА СогласованиеРезультатыСогласования.Ссылка.ra_EtapPrinyatiyaUvedomleniya
		|					ТОГДА ""Не принято""
		|				КОГДА СогласованиеРезультатыСогласования.Ссылка.ПодписыватьЭП
		|					ТОГДА ""Не утверждено""
		|				ИНАЧЕ ПРЕДСТАВЛЕНИЕ(СогласованиеРезультатыСогласования.РезультатСогласования)
		|			КОНЕЦ
		|	КОНЕЦ
		|ИЗ
		|	БизнесПроцесс.Согласование.РезультатыСогласования КАК СогласованиеРезультатыСогласования
		|ГДЕ
		|	СогласованиеРезультатыСогласования.Ссылка В
		|			(ВЫБРАТЬ
		|				т.ЗапущенныйБизнесПроцесс
		|			ИЗ
		|				ДанныеОКомплексномБП КАК т
		|			СГРУППИРОВАТЬ ПО
		|				т.ЗапущенныйБизнесПроцесс)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	УтверждениеРезультатыУтверждения.ЗадачаИсполнителя,
		|	УтверждениеРезультатыУтверждения.НомерИтерации,
		|	УтверждениеРезультатыУтверждения.Ссылка,
		|	ВЫБОР
		|		КОГДА УтверждениеРезультатыУтверждения.РезультатУтверждения = &ПустойРезультатУтверждения
		|			ТОГДА ""На утверждении""
		|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(УтверждениеРезультатыУтверждения.РезультатУтверждения)
		|	КОНЕЦ
		|ИЗ
		|	БизнесПроцесс.Утверждение.РезультатыУтверждения КАК УтверждениеРезультатыУтверждения
		|ГДЕ
		|	УтверждениеРезультатыУтверждения.Ссылка В
		|			(ВЫБРАТЬ
		|				т.ЗапущенныйБизнесПроцесс
		|			ИЗ
		|				ДанныеОКомплексномБП КАК т
		|			СГРУППИРОВАТЬ ПО
		|				т.ЗапущенныйБизнесПроцесс)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ЗадачаИсполнителя,
		|	НомерИтерации,
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеОКомплексномБП.Ссылка КАК КомплексныйБП,
		|	ДанныеОКомплексномБП.ЗапущенныйБизнесПроцесс КАК ПодчиненныйБизнесПроцесс,
		|	ДанныеОКомплексномБП.ШаблонБизнесПроцесса КАК ШаблонПодчиненногоБизнесПроцесса,
		|	ЗадачаИсполнителя.Ссылка КАК Задача,
		|	ДанныеОКомплексномБП.НомерСтроки КАК НомерСтроки,
		|	ЗадачаИсполнителя.РезультатВыполнения КАК КомментарийВыполнения,
		|	ЗадачаИсполнителя.ДатаИсполнения КАК ДатаИсполнения,
		|	ЗадачаИсполнителя.Исполнитель.ра_Организация КАК Организация
		|ПОМЕСТИТЬ БПиЗадачи
		|ИЗ
		|	ДанныеОКомплексномБП КАК ДанныеОКомплексномБП
		|		ЛЕВОЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|		ПО ДанныеОКомплексномБП.ЗапущенныйБизнесПроцесс = ЗадачаИсполнителя.БизнесПроцесс
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ПодчиненныйБизнесПроцесс,
		|	Задача
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ИтерацииОбработки.НомерИтерации) КАК НомерИтерации,
		|	ИтерацииОбработки.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ КрайниеИтерации
		|ИЗ
		|	ИтерацииОбработки КАК ИтерацииОбработки
		|
		|СГРУППИРОВАТЬ ПО
		|	ИтерацииОбработки.Ссылка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка,
		|	НомерИтерации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИтерацииОбработки.ЗадачаИсполнителя КАК ЗадачаИсполнителя,
		|	ИтерацииОбработки.НомерИтерации КАК НомерИтерации,
		|	ИтерацииОбработки.Ссылка КАК Ссылка,
		|	ИтерацииОбработки.Результат КАК Результат
		|ПОМЕСТИТЬ КрайниеИтерацииОбработки
		|ИЗ
		|	ИтерацииОбработки КАК ИтерацииОбработки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КрайниеИтерации КАК КрайниеИтерации
		|		ПО ИтерацииОбработки.НомерИтерации = КрайниеИтерации.НомерИтерации
		|			И ИтерацииОбработки.Ссылка = КрайниеИтерации.Ссылка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ЗадачаИсполнителя,
		|	НомерИтерации,
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	БПиЗадачи.КомплексныйБП КАК КомплексныйБП,
		|	БПиЗадачи.ПодчиненныйБизнесПроцесс КАК ПодчиненныйБизнесПроцесс,
		|	БПиЗадачи.ШаблонПодчиненногоБизнесПроцесса КАК ШаблонПодчиненногоБизнесПроцесса,
		|	БПиЗадачи.Задача КАК Задача,
		|	БПиЗадачи.НомерСтроки КАК НомерСтроки,
		|	""Не начато"" КАК Результат,
		|	0 КАК НомерИтерации,
		|	&ПустойПользователь КАК Исполнитель,
		|	&ПустаяДолжность КАК Должность,
		|	&ПустаяОрганизация КАК Организация
		|ИЗ
		|	БПиЗадачи КАК БПиЗадачи
		|ГДЕ
		|	БПиЗадачи.Задача ЕСТЬ NULL";
		
	Запрос.УстановитьПараметр("ПустойРезультатУтверждения", Перечисления.РезультатыУтверждения.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойРезультатСогласования", Перечисления.РезультатыСогласования.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПоложительныйРезультатСогласования", Перечисления.РезультатыСогласования.Согласовано);
	Запрос.УстановитьПараметр("Предмет", Предмет);
	Запрос.УстановитьПараметр("ПустаяДолжность", Справочники.Должности.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойПользователь", Справочники.Пользователи.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяОрганизация", Справочники.Организации.ПустаяСсылка());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗ = РезультатЗапроса.Выгрузить();
	ТЗ_Копия = тз.СкопироватьКолонки();
	
	Для Каждого СтрокаТЗ из ТЗ Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТЗ.ШаблонПодчиненногоБизнесПроцесса) Тогда 
			Продолжить;
		КонецЕсли;
		
		новСтр = ТЗ_Копия.Добавить();
		ЗаполнитьЗначенияСвойств(новСтр, СтрокаТЗ);
		
		ОбъектШаблон = СтрокаТЗ.ШаблонПодчиненногоБизнесПроцесса.ПолучитьОбъект();
		Если ОбъектШаблон.Предметы.Количество() > 0 Тогда
			СтрокаПредмета = ОбъектШаблон.Предметы[0];
			СтрокаПредмета.Предмет = Предмет;
		КонецЕсли;
		
		Если ТипЗнч(СтрокаТЗ.ШаблонПодчиненногоБизнесПроцесса) = Тип("СправочникСсылка.ШаблоныУтверждения") Тогда
			
			Исполнитель = ОбъектШаблон.Исполнитель;
			
			Если ТипЗнч(Исполнитель) = Тип("Строка") И ЗначениеЗаполнено(Исполнитель) Тогда
				
				АвтоподстановкаИсполнитель = ШаблоныБизнесПроцессов.ПолучитьЗначениеАвтоподстановки(Исполнитель, ОбъектШаблон);
				Если ТипЗнч(АвтоподстановкаИсполнитель) = тип("Массив") Тогда
					
					ПервыйПроход = Истина;
					Для Каждого ЭлементМассива из АвтоподстановкаИсполнитель Цикл
						
						Если ПервыйПроход Тогда
							новСтр.Исполнитель = ЭлементМассива;
							новСтр.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементМассива, "ра_Организация");
							ПервыйПроход = Ложь;
						Иначе
							новСтр_Сл = ТЗ_Копия.Добавить();
							ЗаполнитьЗначенияСвойств(новСтр_Сл, новСтр);
							новСтр_Сл.Исполнитель = ЭлементМассива;
							новСтр_Сл.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементМассива, "ра_Организация");
						КонецЕсли;
						
					КонецЦикла;
					
				ИначеЕсли ТипЗнч(АвтоподстановкаИсполнитель) = тип("СправочникСсылка.Пользователи") Тогда
					новСтр.Исполнитель = АвтоподстановкаИсполнитель;
					новСтр.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АвтоподстановкаИсполнитель, "ра_Организация");
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			Для Каждого Строка Из СтрокаТЗ.ШаблонПодчиненногоБизнесПроцесса.Исполнители Цикл
				
				Если ТипЗнч(Строка.Исполнитель) = Тип("Строка") И ЗначениеЗаполнено(Строка.Исполнитель) Тогда
					
					АвтоподстановкаИсполнитель = ШаблоныБизнесПроцессов.ПолучитьЗначениеАвтоподстановки(Строка.Исполнитель, ОбъектШаблон);
					Если ТипЗнч(АвтоподстановкаИсполнитель) = тип("Массив") Тогда
						
						ПервыйПроход = Истина;
						Для Каждого ЭлементМассива из АвтоподстановкаИсполнитель Цикл
							
							Если ПервыйПроход Тогда
								новСтр.Исполнитель = ЭлементМассива;
								новСтр.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементМассива, "ра_Организация");
								ПервыйПроход = Ложь;
							Иначе
								новСтр_Сл = ТЗ_Копия.Добавить();
								ЗаполнитьЗначенияСвойств(новСтр_Сл, новСтр);
								новСтр_Сл.Исполнитель = ЭлементМассива;
								новСтр_Сл.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементМассива, "ра_Организация");
							КонецЕсли;
							
						КонецЦикла;
						
					ИначеЕсли ТипЗнч(АвтоподстановкаИсполнитель) = тип("СправочникСсылка.Пользователи") Тогда
						новСтр.Исполнитель = АвтоподстановкаИсполнитель;
						новСтр.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АвтоподстановкаИсполнитель, "ра_Организация");
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТЗВрем", ТЗ_Копия);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЗВрем.КомплексныйБП КАК КомплексныйБП,
	|	ТЗВрем.ПодчиненныйБизнесПроцесс КАК ПодчиненныйБизнесПроцесс,
	|	ТЗВрем.ШаблонПодчиненногоБизнесПроцесса КАК ШаблонПодчиненногоБизнесПроцесса,
	|	ТЗВрем.Задача КАК Задача,
	|	ТЗВрем.НомерСтроки КАК НомерСтроки,
	|	ТЗВрем.Результат КАК Результат,
	|	ТЗВрем.НомерИтерации КАК НомерИтерации,
	|	ТЗВрем.Исполнитель КАК Исполнитель,
	|	ТЗВрем.Должность КАК Должность,
	|	ТЗВрем.Организация КАК Организация
	|ПОМЕСТИТЬ ВремТЗ
	|ИЗ
	|	&ТЗВрем КАК ТЗВрем
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(ВремТЗ.КомплексныйБП) КАК КомплексныйБП,
	|	ПРЕДСТАВЛЕНИЕ(ВремТЗ.ПодчиненныйБизнесПроцесс) КАК ПодчиненныйБП,
	|	ПРЕДСТАВЛЕНИЕ(ВремТЗ.ШаблонПодчиненногоБизнесПроцесса) КАК ШаблонБП,
	|	ВремТЗ.Задача КАК Задача,
	|	ВремТЗ.НомерСтроки КАК НомерСтроки,
	|	ПРЕДСТАВЛЕНИЕ(ВремТЗ.Результат) КАК Результат,
	|	ВремТЗ.НомерИтерации КАК НомерИтерации,
	|	ВремТЗ.Исполнитель КАК Исполнитель,
	|	ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(СведенияОПользователяхДокументооборот.Должность, &ПустаяДолжность)) КАК Должность,
	|	"""" КАК Комментарий,
	|	"""" КАК Дата,
	|	ПРЕДСТАВЛЕНИЕ(ВремТЗ.Организация) КАК Организация
	|ПОМЕСТИТЬ ВТ_Результат
	|ИЗ
	|	ВремТЗ КАК ВремТЗ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|		ПО ВремТЗ.Исполнитель = СведенияОПользователяхДокументооборот.Пользователь
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(БПиЗадачи.КомплексныйБП),
	|	ПРЕДСТАВЛЕНИЕ(БПиЗадачи.ПодчиненныйБизнесПроцесс),
	|	ПРЕДСТАВЛЕНИЕ(БПиЗадачи.ШаблонПодчиненногоБизнесПроцесса),
	|	БПиЗадачи.Задача,
	|	БПиЗадачи.НомерСтроки,
	|	ПРЕДСТАВЛЕНИЕ(КрайниеИтерацииОбработки.Результат),
	|	КрайниеИтерацииОбработки.НомерИтерации,
	|	ЕСТЬNULL(БПиЗадачи.Задача.Исполнитель, &ПустойПользователь),
	|	ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(СведенияОПользователяхДокументооборот.Должность, &ПустаяДолжность)),
	|	БПиЗадачи.КомментарийВыполнения,
	|	ПРЕДСТАВЛЕНИЕ(ВЫБОР
	|			КОГДА БПиЗадачи.ДатаИсполнения = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА """"
	|			ИНАЧЕ БПиЗадачи.ДатаИсполнения
	|		КОНЕЦ),
	|	ПРЕДСТАВЛЕНИЕ(БПиЗадачи.Организация)
	|ИЗ
	|	БПиЗадачи КАК БПиЗадачи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КрайниеИтерацииОбработки КАК КрайниеИтерацииОбработки
	|		ПО БПиЗадачи.ПодчиненныйБизнесПроцесс = КрайниеИтерацииОбработки.Ссылка
	|			И БПиЗадачи.Задача = КрайниеИтерацииОбработки.ЗадачаИсполнителя
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|		ПО БПиЗадачи.Задача.Исполнитель = СведенияОПользователяхДокументооборот.Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Результат.КомплексныйБП КАК КомплексныйБП,
	|	ВТ_Результат.ПодчиненныйБП КАК ПодчиненныйБП,
	|	ВТ_Результат.ШаблонБП КАК ШаблонБП,
	|	ПРЕДСТАВЛЕНИЕ(ВТ_Результат.Задача) КАК Задача,
	|	ВТ_Результат.НомерСтроки КАК НомерСтроки,
	|	ВТ_Результат.Результат КАК Результат,
	|	ВТ_Результат.НомерИтерации КАК НомерИтерации,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ра_ФактическиеИсполнителиЗадач.ПредыдущийИсполнитель, """") = """"
	|			ТОГДА ПРЕДСТАВЛЕНИЕ(ВТ_Результат.Исполнитель)
	|		ИНАЧЕ ра_ФактическиеИсполнителиЗадач.ПредставлениеИсполнителя
	|	КОНЕЦ КАК Исполнитель,
	|	ВТ_Результат.Должность КАК Должность,
	|	ВТ_Результат.Комментарий КАК Комментарий,
	|	ВТ_Результат.Дата КАК Дата,
	|	ВТ_Результат.Организация КАК Организация
	|ИЗ
	|	ВТ_Результат КАК ВТ_Результат
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ра_ФактическиеИсполнителиЗадач КАК ра_ФактическиеИсполнителиЗадач
	|		ПО ВТ_Результат.Задача = ра_ФактическиеИсполнителиЗадач.Задача";
	РезультатЗапроса = Запрос.Выполнить();
	
	Таблица = РезультатЗапроса.Выгрузить();
	Для каждого Строка Из Таблица.НайтиСтроки(Новый Структура("Исполнитель", "DORobot")) Цикл
		Таблица.Удалить(Строка);
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

Функция ПолучитьОсновнойФайлДляДокумента(СсылкаНаПредмет) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Файлы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайла
	|	И Файлы.ра_ОсновнойФайл";
	
	Запрос.УстановитьПараметр("ВладелецФайла", СсылкаНаПредмет);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	СтруктураДанныхФайла = ра_ОбменДанными.ПолучитьДвоичныеДанныеОсновногоФайла(ВыборкаДетальныеЗаписи.Ссылка);
	
	Если СтруктураДанныхФайла.Свойство("ДвоичныеДанные") Тогда
		// ТСК Близнюк С.И.; 27.09.2018; task#652{
		//Возврат СтруктураДанныхФайла.ДвоичныеДанные;
		ДанныеФайла = Новый Структура;
		ДанныеФайла.Вставить("Файл", 			ВыборкаДетальныеЗаписи.Ссылка);
		ДанныеФайла.Вставить("Версия", 			СтруктураДанныхФайла.Версия);
		ДанныеФайла.Вставить("ДвоичныеДанные", 	СтруктураДанныхФайла.ДвоичныеДанные);
		Возврат ДанныеФайла;
		// ТСК Близнюк С.И.; 27.09.2018; task#652}
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // ПолучитьОсновнойФайлДляДокумента()

Функция ПолучитьКоличествоЗадачПоВидамПредметов() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТИПЗНАЧЕНИЯ(ЗадачаИсполнителяПредметы.Предмет) КАК ВидПредмета,
	|	Количество(Ссылка) КАК Количество
	|ИЗ
	|	Задача.ЗадачаИсполнителя.Предметы КАК ЗадачаИсполнителяПредметы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗадачиДляВыполнения КАК ЗадачиДляВыполнения
	|			ПО ЗадачаИсполнителяПредметы.Ссылка = ЗадачиДляВыполнения.Задача
	|ГДЕ
	|	(ЗадачаИсполнителяПредметы.Ссылка.СостояниеБизнесПроцесса = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Активен)
	|		И ЕСТЬNULL(ЗадачиДляВыполнения.СостояниеВыполнения, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.СостоянияЗадачДляВыполнения.ГотоваКВыполнению)
	|		И ЗадачаИсполнителяПредметы.Ссылка.ПометкаУдаления = ЛОЖЬ
	|		И ЗадачаИсполнителяПредметы.Ссылка.ИсключенаИзПроцесса = ЛОЖЬ)

	|СГРУППИРОВАТЬ ПО
	|	ТИПЗНАЧЕНИЯ(ЗадачаИсполнителяПредметы.Предмет)");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 16.08.2018 {
Функция УведомлениеПоСтороннейОрганизации(БизнесПроцесс) Экспорт
	
	СтруктураРезультат = Новый Структура("ПоСтороннейОрганизации, ОтветственныйЗаКачество", Ложь, Неопределено);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ДанныеБизнесПроцессов.ОсновнойПредмет КАК Документ.ra_Uvedomlenie).OtvetstvennyjZaKachestvoOtpravitel КАК ОтветственныйЗаКачество
	|ИЗ
	|	РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
	|ГДЕ
	|	ДанныеБизнесПроцессов.БизнесПроцесс = &БизнесПроцесс
	|	И НЕ ДанныеБизнесПроцессов.Завершен
	|	И НЕ ВЫРАЗИТЬ(ДанныеБизнесПроцессов.ОсновнойПредмет КАК Документ.ra_Uvedomlenie).VidOperacii = ЗНАЧЕНИЕ(Перечисление.ra_VidyUvedomleniy.UvedomlenieVnutriOrganizacii)";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтруктураРезультат.ПоСтороннейОрганизации = Истина;
		СтруктураРезультат.ОтветственныйЗаКачество = Выборка.ОтветственныйЗаКачество;
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

Функция ПолучитьСтроковоеПредставлениеДействияБизнесПроцесса(БизнесПроцесс) Экспорт 
	
	Результат = Новый Структура("ДействиеRU, ДействиеEN", "", "");
	
	Соответствие = СоответствиеТиповБизнесПроцессовИИмениСправочникаШаблона(БизнесПроцесс);
	
	ИмяСправочникаШаблона = Соответствие.Получить(ТипЗнч(БизнесПроцесс)); 
	Если ИмяСправочникаШаблона <> Неопределено Тогда 
		
		ИмяМетаданногоБП = БизнесПроцесс.Метаданные().Имя;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ВЫРАЗИТЬ(БизнесПроцесс.Шаблон КАК Справочник." + ИмяСправочникаШаблона + ").НаименованиеБизнесПроцесса КАК ДействиеRU,
		|	ВЫРАЗИТЬ(БизнесПроцесс.Шаблон КАК Справочник." + ИмяСправочникаШаблона + ").ра_НаименованиеБизнесПроцессаАнгл КАК ДействиеEN
		|ИЗ
		|	БизнесПроцесс." + ИмяМетаданногоБП + " КАК БизнесПроцесс
		|ГДЕ
		|	БизнесПроцесс.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", БизнесПроцесс);
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда 
			ЗаполнитьЗначенияСвойств(Результат, Выборка);			
		КонецЕсли; 
			
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции	

Функция СоответствиеТиповБизнесПроцессовИИмениСправочникаШаблона(Ссылка) 
	
	СоответствиеТипов = Новый Соответствие;
	// Тип бизнес-процесса, имя справочника шаблона
	СоответствиеТипов.Вставить(Тип("БизнесПроцессСсылка.Исполнение"),   "ШаблоныИсполнения"); 
	СоответствиеТипов.Вставить(Тип("БизнесПроцессСсылка.Ознакомление"), "ШаблоныОзнакомления");
	СоответствиеТипов.Вставить(Тип("БизнесПроцессСсылка.Согласование"), "ШаблоныСогласования");
	СоответствиеТипов.Вставить(Тип("БизнесПроцессСсылка.Утверждение"),  "ШаблоныУтверждения");
	
	Возврат СоответствиеТипов;
	
КонецФункции

// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 16.08.2018 }

// ТСК Близнюк С.И.; 01.11.2018; task#1572{
Функция ПолучитьВыявившегоНесоответствие(БизнесПроцесс) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ra_Nesootvetstvie.VyyavivsheeLico КАК Выявивший
	|ИЗ
	|	Документ.ra_Nesootvetstvie КАК ra_Nesootvetstvie
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВЫРАЗИТЬ(ДанныеБизнесПроцессов.ОсновнойПредмет КАК Документ.ra_Uvedomlenie).Nesootvetstvie КАК Несоответствие
	|		ИЗ
	|			РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
	|		ГДЕ
	|			ДанныеБизнесПроцессов.БизнесПроцесс = &БизнесПроцесс
	|			И НЕ ДанныеБизнесПроцессов.Завершен
	|			И ВЫРАЗИТЬ(ДанныеБизнесПроцессов.ОсновнойПредмет КАК Документ.ra_Uvedomlenie).VidOperacii = ЗНАЧЕНИЕ(Перечисление.ra_VidyUvedomleniy.UvedomlenieVnutriOrganizacii)) КАК УоН
	|		ПО ra_Nesootvetstvie.Ссылка = УоН.Несоответствие";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Выявивший;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции
// ТСК Близнюк С.И.; 01.11.2018; task#1572}

Процедура ДобавитьЗаписьПоФактическомуИсполнителю(Задача, ПредставлениеИсполнителя) Экспорт

	МенеджерЗаписи = РегистрыСведений.ра_ФактическиеИсполнителиЗадач.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Задача = Задача.Ссылка;
	МенеджерЗаписи.ФактическийИсполнитель = Задача.Исполнитель;
	МенеджерЗаписи.ПредыдущийИсполнитель = Задача.ДополнительныеСвойства.ПредыдущийИсполнитель;
	МенеджерЗаписи.ПредставлениеИсполнителя = ПредставлениеИсполнителя;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры
