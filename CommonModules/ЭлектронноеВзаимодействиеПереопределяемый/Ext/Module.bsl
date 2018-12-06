﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеПереопределяемый: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Изменяет поведение элементов управляемой или обычной формы.
//
// Параметры:
//  Форма - УправляемаяФорма, ОбычнаяФорма - управляемая или обычная форма для изменения.
//  СтруктураПараметров - Структура - параметры процедуры.
//
Процедура ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров) Экспорт
	
	
	
КонецПроцедуры

// При необходимости, в функции можно определить каталог для временных файлов,
// отличный от устанавливаемого по умолчанию в библиотеке ЭД.
//
// Параметры:
//  ТекущийКаталог - Строка - путь к каталогу временных файлов.
//
Процедура ТекущийКаталогВременныхФайлов(ТекущийКаталог) Экспорт
	
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка метаданных

// Определяет соответствие функциональных опций библиотеки и прикладного решения,
// в случае различий в наименовании.
//
// Параметры:
//  СоответствиеФО - Соответствие - список функциональных опций.
//
Процедура ПолучитьСоответствиеФункциональныхОпций(СоответствиеФО) Экспорт
	
	
	
КонецПроцедуры

// Определяет соответствие справочников библиотеки и прикладного решения,
// в случае различий в наименовании справочников.
//
// Параметры:
//  СоответствиеСправочников - Соответствие - список справочников.
//
Процедура ПолучитьСоответствиеСправочников(СоответствиеСправочников) Экспорт
	
	СоответствиеСправочников.Вставить("Организации", "Организации");
	СоответствиеСправочников.Вставить("Контрагенты", "Контрагенты");
	СоответствиеСправочников.Вставить("Банки",       "КлассификаторБанковРФ");
	СоответствиеСправочников.Вставить("Валюты",      "Валюты");
	
	СоответствиеСправочников.Вставить("Номенклатура",                "Номенклатура");
	СоответствиеСправочников.Вставить("БанковскиеСчетаОрганизаций",  "БанковскиеСчета");
	СоответствиеСправочников.Вставить("БанковскиеСчетаКонтрагентов", "БанковскиеСчета");
	
КонецПроцедуры

// В процедуре формируется соответствие для сопоставления имен переменных библиотеки,
// наименованиям объектов и реквизитов метаданных прикладного решения.
// Если в прикладном решении есть документы, на основании которых формируется ЭД,
// причем названия реквизитов данных документов отличаются от общепринятых "Организация", "Контрагент", "СуммаДокумента",
// то для этих реквизитов необходимо добавить в соответствие записи виде:
// Ключ = "ДокументВМетаданных.ОбщепринятоеНазваниеРеквизита", Значение - "ДокументВМетаданных.ДругоеНазваниеРеквизита".
// Например:
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Организация", "МЗ_Покупка.Учреждение");
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Контрагент",  "МЗ_Покупка.Грузоотправитель");
//  СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданный.СуммаДокумента",  "СчетФактураВыданный.Основание.СуммаДокумента");
// 
// Параметры:
// СоответствиеРеквизитовОбъекта - Соответствие - содержит:
//    * Ключ - Строка - имя переменной, используемой в коде библиотеки;
//    * Значение - Строка - наименование объекта метаданных или реквизита объекта в прикладном решении.
//
Процедура ПолучитьСоответствиеНаименованийОбъектовМДИРеквизитов(СоответствиеРеквизитовОбъекта) Экспорт
	
	// Обмен с контрагентами начало
	СоответствиеРеквизитовОбъекта.Вставить("ДатаВыставленияВСчетеФактуреВыданном", "ДатаВыставления");
	СоответствиеРеквизитовОбъекта.Вставить("ДатаПолученияВСчетеФактуреПолученном", "ДатаПолучения");
	
	СоответствиеРеквизитовОбъекта.Вставить("НомерСчета", "НомерСчета");
	СоответствиеРеквизитовОбъекта.Вставить("ИННКонтрагента",                       "ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("КППКонтрагента",                       "КПП");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеКонтрагента",              "Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеКонтрагентаДляСообщенияПользователю", "Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("ВнешнийКодКонтрагента",                "Код");
	
	СоответствиеРеквизитовОбъекта.Вставить("ИННОрганизации",                       "ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("КППОрганизации",                       "КПП");
	СоответствиеРеквизитовОбъекта.Вставить("ОГРНОрганизации",                      "ОГРН");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеОрганизации",              "Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("СокращенноеНаименованиеОрганизации",   "Наименование");
	
	СоответствиеРеквизитовОбъекта.Вставить("ВнутренниеДокументы.СуммаДокумента",   "Сумма");
	СоответствиеРеквизитовОбъекта.Вставить("ВнутренниеДокументы.Дата",             "ДатаРегистрации");
	
	СоответствиеРеквизитовОбъекта.Вставить("ВерсииФайлов.СуммаДокумента",          "Владелец.ВладелецФайла.Сумма");
	СоответствиеРеквизитовОбъекта.Вставить("ВерсииФайлов.Дата",                    "Владелец.ВладелецФайла.ДатаРегистрации");
	// Обмен с контрагентами конец.
	
КонецПроцедуры

// Определяет соответствие кодов обязательных элементов схем электронных документов их пользовательскому представлению.
//
// Параметры:
//  СоответствиеВозврата - Соответствие - исходное соответствие для заполнения.
//
Процедура СоответствиеКодовРеквизитовИПредставлений(СоответствиеВозврата) Экспорт
	
	
	
КонецПроцедуры

// Получает ключевые реквизиты объекта по текстовому представлению.
//
// Параметры:
//  ИмяОбъекта - Строка - текстовое представление объекта, ключевые реквизиты которого необходимо получить.
//  СтруктураКлючевыхРеквизитов - Структура - перечень параметров объекта.
//
Процедура ПолучитьСтруктуруКлючевыхРеквизитовОбъекта(ИмяОбъекта, СтруктураКлючевыхРеквизитов) Экспорт
	
	Если ИмяОбъекта = "Справочник.ВнутренниеДокументы" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("ДатаРегистрации, РегистрационныйНомер, Организация, Заголовок, ПодписанЭП");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Контрагент");
		СтруктураКлючевыхРеквизитов.Вставить("Контрагенты", СтрокаРеквизитовОбъекта);
	ИначеЕсли ИмяОбъекта = "Справочник.ВходящиеДокументы" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("ДатаРегистрации, РегистрационныйНомер, Организация, Отправитель, Заголовок, ПодписанЭП ");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
	ИначеЕсли ИмяОбъекта = "Справочник.ИсходящиеДокументы" Тогда
		// Реквизиты объекта
		СтрокаРеквизитовОбъекта = ("ДатаРегистрации, РегистрационныйНомер, Организация, Заголовок, ПодписанЭП ");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		// Табличная часть
		СтрокаРеквизитовОбъекта = ("Получатель");
		СтруктураКлючевыхРеквизитов.Вставить("Получатели", СтрокаРеквизитовОбъекта);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Получение текстовых сообщений

// Определяет текст сообщения о необходимости настройки системы в зависимости от вида операции.
//
// Параметры:
//  ВидОперации    - строка - признак выполняемой операции;
//  ТекстСообщения - строка - текст сообщения.
//
Процедура ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации, ТекстСообщения) Экспорт
	
КонецПроцедуры

// Переопределяет выводимое сообщение об ошибке.
//
// Параметры:
//  КодОшибки - строка - код ошибки
//  ТекстОшибки - строка - измененный текст ошибки.
//
Процедура ИзменитьСообщениеОбОшибке(КодОшибки, ТекстОшибки) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет сообщение о нехватке прав доступа.
//
// Параметры:
//  ТекстСообщения - Строка - текст сообщения.
//
Процедура ПодготовитьТекстСообщенияОНарушенииПравДоступа(ТекстСообщения) Экспорт
	
	// При необходимости можно переопределить или дополнить текст сообщения
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Получение данных

// Находит ссылку на объект ИБ по типу, ИД и дополнительным реквизитам.
// 
// Параметры:
//  ТипОбъекта - Строка - идентификатор типа объекта, который необходимо найти;
//  ИДОбъекта - Строка - идентификатор объекта заданного типа;
//  ДополнительныеРеквизиты - Структура - набор дополнительных полей объекта для поиска;
//  ИДЭД - Строка - идентификатор электронного документа;
//
// Возвращаемое значение:
//  Ссылка - найденная ссылка.
//
Функция НайтиСсылкуНаОбъект(ТипОбъекта, ИдОбъекта = "", ДополнительныеРеквизиты = Неопределено, ИДЭД = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	Если ТипОбъекта = "Валюты"  Тогда
		ИмяПрикладногоСправочника = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ТипОбъекта);
		Результат = НайтиСсылкуНаОбъектПоРеквизиту(ИмяПрикладногоСправочника, "Код", ИдОбъекта);
		
		Если Результат = Неопределено И ТипОбъекта = "ЕдиницыИзмерения" И ЗначениеЗаполнено(ДополнительныеРеквизиты)
			И ДополнительныеРеквизиты.Свойство("Наименование") Тогда
			
			Результат = НайтиСсылкуНаОбъектПоРеквизиту(ИмяПрикладногоСправочника, "Наименование", ДополнительныеРеквизиты.Наименование);
		КонецЕсли;
	ИначеЕсли (ТипОбъекта = "Контрагенты" ИЛИ ТипОбъекта = "Организации") И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		ПараметрПоиска = "";
		ИНН = "";
		КПП = "";
		
		Если ДополнительныеРеквизиты.Свойство("ИНН") Тогда
			ИНН = ДополнительныеРеквизиты.ИНН;
		КонецЕсли;
		
		Если ДополнительныеРеквизиты.Свойство("КПП") Тогда
			КПП = ДополнительныеРеквизиты.КПП;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИНН) Тогда
			Результат = ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП(ТипОбъекта, ИНН, КПП);
		КонецЕсли;
		
		ИмяМетаданных = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ТипОбъекта);
		
		Если НЕ ЗначениеЗаполнено(Результат) И ДополнительныеРеквизиты.Свойство("Наименование", ПараметрПоиска) Тогда
			Результат = НайтиСсылкуНаОбъектПоРеквизиту(ИмяМетаданных, "Наименование", ПараметрПоиска);
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = "Номенклатура" И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		
		ПараметрПоиска = "";
		Если ДополнительныеРеквизиты.Свойство("Идентификатор", ПараметрПоиска) И ЗначениеЗаполнено(ПараметрПоиска) Тогда
			Результат = НайтиСсылкуНаНоменклатуруПоИдентификаторуНоменклатурыПоставщика(ПараметрПоиска);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Результат) И ДополнительныеРеквизиты.Свойство("Артикул", ПараметрПоиска)
			И ЗначениеЗаполнено(ПараметрПоиска) Тогда
			
			ИмяПрикладногоСправочника = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ТипОбъекта);
			Результат = НайтиСсылкуНаОбъектПоРеквизиту(ИмяПрикладногоСправочника, "Код", ПараметрПоиска);
		КонецЕсли;
	ИначеЕсли ТипОбъекта = "БанковскиеСчетаОрганизаций" Или ТипОбъекта = "БанковскиеСчетаКонтрагентов" Тогда
		
		Владелец = "";
		Если ТипЗнч(ДополнительныеРеквизиты) = Тип("Структура") И ДополнительныеРеквизиты.Свойство("Владелец") Тогда
			Владелец = ДополнительныеРеквизиты.Владелец;
		КонецЕсли;
		
		ИмяПрикладногоСправочника = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ТипОбъекта);

 		Результат = НайтиСсылкуНаОбъектПоРеквизиту(ИмяПрикладногоСправочника, "НомерСчета", ИдОбъекта, Владелец);
		
	ИначеЕсли ВРег(ТипОбъекта) = ВРег("ДоговорыКонтрагентов") Тогда
		
		Результат = ДоговорКонтрагентаПоРеквизитам(ДополнительныеРеквизиты);
		
	ИначеЕсли ТипОбъекта = "ВидыКонтактнойИнформации" Тогда
		Если ИдОбъекта = "EmailКонтрагента" Тогда
			Результат = "Почта";
		ИначеЕсли ИдОбъекта = "ТелефонКонтрагента" Тогда
			Результат = "Телефон";
		ИначеЕсли ИдОбъекта = "ФаксКонтрагента" Тогда
			Результат = "Факс";
		КонецЕсли;
	ИначеЕсли ТипОбъекта = "СтраныМира" Тогда
		Результат = "";
		
	// Обмен с банками
	ИначеЕсли ТипОбъекта = "Банки" И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		Владелец = "";
		Если ДополнительныеРеквизиты.Свойство("Код", ПараметрПоиска) И ЗначениеЗаполнено(ПараметрПоиска) Тогда
			ИмяПрикладногоСправочника = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ТипОбъекта);
			Результат = НайтиСсылкуНаОбъектПоРеквизиту(ИмяПрикладногоСправочника, "Код", ПараметрПоиска, Владелец);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает печатный номер документа.
//
// Параметры:
//  СсылкаНаОбъект - ДокументСсылка - ссылка на документ информационной базы.
//
// Возвращаемое значение:
//  НомерОбъекта - номер документа.
//
Функция ПолучитьПечатныйНомерДокумента(СсылкаНаОбъект) Экспорт
	
	Результат = "";
	
	
	
	Возврат Результат;
	
КонецФункции

// Проверяет, готовность документов ИБ для формирования ЭД, и удаляет из массива не готовые документы.
//
// Параметры:
//  ДокументыМассив - Массив   - ссылки на документы, которые должны быть проверены перед формированием ЭД.
//
Процедура ПроверитьГотовностьИсточников(ДокументыМассив) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияТипаИзМассива(
										ДокументыМассив,
										Тип("СтрокаГруппировкиДинамическогоСписка"));
	
	
	Для Каждого ЭлементМасссива Из ДокументыМассив Цикл
		
		ДокументДО = ЭлементМасссива.Владелец.ВладелецФайла;

		Если ОбменСКонтрагентамиДОВызовСервера.ДокументГотовКФормированиюЭД(ДокументДО, Истина) Тогда
			Продолжить;
		КонецЕсли; 
		
		Найденный = ДокументыМассив.Найти(ДокументДО.Ссылка);
		Если Найденный <> Неопределено Тогда
			ДокументыМассив.Удалить(Найденный);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Получает данные о физическом (юридическом) лице по ссылке.
//
// Параметры:
//  ЮрФизЛицо - Ссылка - ссылка на элемент справочника, по которому надо получить данные.
//
// Возвращаемое значение:
//  Структура - данные юридического (физического лица).
//
Функция ПолучитьДанныеЮрФизЛица(ЮрФизЛицо) Экспорт
	
	Сведения = Новый Структура("Представление, ПолноеНаименование, КодПоОКПО, ИНН, КПП, Телефоны, ЮридическийАдрес, Банк, БИК, КоррСчет, НомерСчета, Фамилия, Имя, Отчество");
	
	Если ЗначениеЗаполнено(ЮрФизЛицо)
		И (ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Организации")
		ИЛИ ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Контрагенты")) Тогда
		
		Сведения.Вставить("ЮрФизЛицо", ЮрФизЛицо.ЮрФизЛицо);
		Сведения.Вставить("ПолноеНаименование", ЮрФизЛицо.НаименованиеПолное);
		Сведения.Вставить("ОфициальноеНаименование", ЮрФизЛицо.Наименование);
		Сведения.Вставить("ИНН", ЮрФизЛицо.ИНН);
		Сведения.Вставить("КПП", ЮрФизЛицо.КПП);
		Сведения.Вставить("Телефоны", "");
		Сведения.Вставить("КодПоОКПО", "");
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	БанковскиеСчета.НомерСчета,
		|	БанковскиеСчета.Банк.Наименование КАК Банк,
		|	БанковскиеСчета.Банк.Код КАК БИК
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|	БанковскиеСчета.Владелец = &Владелец
		|	И НЕ БанковскиеСчета.ПометкаУдаления";
		Запрос.УстановитьПараметр("Владелец", ЮрФизЛицо);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(Сведения, Выборка);
		КонецЕсли;
		
		Если ЮрФизЛицо.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель
			ИЛИ ЮрФизЛицо.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
			
			ФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(ЮрФизЛицо.Наименование);
			Сведения.Вставить("Фамилия", ФИО.Фамилия);
			Сведения.Вставить("Имя", ФИО.Имя);
			Сведения.Вставить("Отчество", ФИО.Отчество);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Сведения
	
КонецФункции

// Возвращает текстовое описание организации по параметрам.
//
// Параметры:
//  СведенияОрганизации - Структура - сведения об организации, по которой надо составить описание.
//  Список - Строка - список запрашиваемых параметров организации.
//  СПрефиксом - Булево - признак вывода префикса параметра организации.
//
// Возвращаемое значение:
//  Строка - описание организации.
//
Функция ОписаниеОрганизации(СведенияОрганизации, Список = "", СПрефиксом = Истина) Экспорт
	
	Если ПустаяСтрока(Список) Тогда
		Список = "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет";
	КонецЕсли;

	Результат = "";

	СоответствиеПараметров = Новый Соответствие();
	СоответствиеПараметров.Вставить("ПолноеНаименование", " ");
	СоответствиеПараметров.Вставить("ИНН",                " ИНН ");
	СоответствиеПараметров.Вставить("КПП",                " КПП ");
	СоответствиеПараметров.Вставить("ЮридическийАдрес",   " ");
	СоответствиеПараметров.Вставить("ФактическийАдрес",   " ");
	СоответствиеПараметров.Вставить("Телефоны",           " тел.: ");
	СоответствиеПараметров.Вставить("НомерСчета",         " р/с ");
	СоответствиеПараметров.Вставить("Банк",               " в банке ");
	СоответствиеПараметров.Вставить("БИК",                " БИК ");
	СоответствиеПараметров.Вставить("КоррСчет",           " к/с ");
	СоответствиеПараметров.Вставить("КодПоОКПО",          " Код по ОКПО ");

	Список          = Список + ?(Прав(Список, 1) = ",", "", ",");
	ЧислоПараметров = СтрЧислоВхождений(Список, ",");

	Для Счетчик = 1 По ЧислоПараметров Цикл

		ПозЗапятой = СтрНайти(Список, ",");

		Если ПозЗапятой > 0  Тогда
			
			ИмяПараметра = Лев(Список, ПозЗапятой - 1);
			Список       = Сред(Список, ПозЗапятой + 1, СтрДлина(Список));

			Попытка
				СтрокаДополнения = "";
				СведенияОрганизации.Свойство(ИмяПараметра, СтрокаДополнения);

				Если ПустаяСтрока(СтрокаДополнения) Тогда
					Продолжить;
				КонецЕсли;

				Префикс = СоответствиеПараметров[ИмяПараметра];
				Если Не ПустаяСтрока(Результат)  Тогда
					Результат = Результат + ",";
				КонецЕсли; 

				Результат = Результат + ?(СПрефиксом = Истина, Префикс, "") + СтрокаДополнения;
			Исключение
				
				ТекстСообщения  = НСтр("ru='Не удалось определить значение параметра организации: %ИмяПараметра%'; en = 'Unable to determine the value of parameter %ИмяПараметра% for the company'");
				ТекстСообщения  = СтрЗаменить(ТекстСообщения,"%ИмяПараметра%",ИмяПараметра);
				Сообщение       = Новый СообщениеПользователю();
				Сообщение.Текст = ТекстСообщения;
				Сообщение.Сообщить();
				
			КонецПопытки;

		КонецЕсли;

	КонецЦикла;

	Возврат СокрЛП(Результат);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с правами

// Проверяет наличие прав обрабатывать электронный документы.
//
// Возвращаемое значение:
//  Булево - истина или ложь, в зависимости от установленных прав.
//
Функция ЕстьПравоОбработкиЭД() Экспорт
	
	Результат = Пользователи.РолиДоступны("ВыполнениеОбменаЭД, ПолныеПрава");
	
	Возврат Результат;
	
КонецФункции

// Проверяет наличие прав читать электронный документы.
//
// Возвращаемое значение:
//  Булево - истина или ложь, в зависимости от установленных прав.
//
Функция ЕстьПравоЧтенияЭД() Экспорт
	
	Результат = Пользователи.РолиДоступны("ВыполнениеОбменаЭД, ЧтениеЭД, ПолныеПрава");
	
	Возврат Результат;
	
КонецФункции

// Проверяет наличие прав на открытие журнала регистрации.
//
// Возвращаемое значение:
//  Булево - истина или ложь, в зависимости от установленных прав.
//
Функция ЕстьПравоОткрытияЖурналаРегистрации() Экспорт
	
	Результат = Истина;
	
	Результат = Пользователи.ЭтоПолноправныйПользователь(, , Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// Находит ссылку на справочник по переданному реквизиту.
//
// Параметры:
//  ИмяСправочника - Строка, имя справочника, объект которого надо найти,
//  ИмяРеквизита - Строка, имя реквизита, по которому будет проведен поиск,
//  ЗначРеквизита - произвольное значение, значение реквизита, по которому будет проведен поиск,
//  Владелец - Ссылка на владельца для поиска в иерархическом справочнике.
//
Функция НайтиСсылкуНаОбъектПоРеквизиту(ИмяСправочника, ИмяРеквизита, ЗначРеквизита, Владелец = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	Если Не ЗначениеЗаполнено(ИмяСправочника) ТОгда
		Возврат Результат;
	КонецЕсли;
	
	ОбъектМетаданных = Метаданные.Справочники[ИмяСправочника];
	Если НЕ ОбщегоНазначения.ЭтоСтандартныйРеквизит(ОбъектМетаданных.СтандартныеРеквизиты, ИмяРеквизита)
		И НЕ ОбъектМетаданных.Реквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда
		
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИскСправочник.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник." + ИмяСправочника + " КАК ИскСправочник
	|ГДЕ
	|	ИскСправочник." + ИмяРеквизита + " = &ЗначРеквизита";
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		Запрос.Текст = Запрос.Текст + " И ИскСправочник.Владелец = &Владелец";
		Запрос.УстановитьПараметр("Владелец", Владелец);
	КонецЕсли;
	Запрос.УстановитьПараметр("ЗначРеквизита", ЗначРеквизита);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиСсылкуНаНоменклатуруПоИдентификаторуНоменклатурыПоставщика(Идентификатор)
	
	Результат = Неопределено;
	
	Возврат Результат;
	
КонецФункции

Функция ДоговорКонтрагентаПоРеквизитам(РеквизитыДоговора)
	
	Возврат Неопределено;
	
КонецФункции

Процедура ПодпискаНаСобытие1ПриЗаписи(Источник, Отказ) Экспорт
	
КонецПроцедуры

#КонецОбласти


