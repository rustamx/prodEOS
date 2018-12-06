﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки электронных документов.
//
/////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает номер версии библиотеки электронных документов.
//
// Возвращаемое значение:
//  Строка - номер сборки.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат "1.3.6.30";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Получение сведений о библиотеке (или конфигурации).

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииПодсистемы.
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаЭлектронныхДокументов";
	Описание.Версия = ВерсияБиблиотеки();
	
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	ЕстьОбменСБанками = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками");
	ЕстьОбменССайтами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменССайтами");
	ЕстьБизнесСеть = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.БизнесСеть");

	Если ЕстьОбменСКонтрагентами Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.0.4.0";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВидыДокументов";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.0.5.0";
		Обработчик.Процедура = "РегистрыСведений.УдалитьУчастникиОбменовЭДЧерезОператоровЭДО.ОбновитьВерсиюРегламентаЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.3.7";
		Обработчик.Процедура = "РегистрыСведений.ЖурналСобытийЭД.ОбновитьСтатусыЭД";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.5.1";
		Обработчик.Процедура = "ОбменСКонтрагентами.ОбработатьКорректировочныеСчетаФактуры";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.6.3";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ЗаполнитьВерсииФорматов";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.7.1";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ПеренестиСертификатАвторизацииВТЧ";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.7.4";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ЗаполнитьВерсииФорматовИсходящихЭДИПакета";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.9.1";
		Обработчик.Процедура = "Справочники.УдалитьСертификатыЭП.ЗаполнитьСрокДействия";
		Обработчик.НачальноеЗаполнение = Ложь;
			
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.13.2";
		Обработчик.Процедура = "РегистрыСведений.УдалитьУчастникиОбменовЭДЧерезОператоровЭДО.ЗаменитьС1На2ВерсиюРегламентаЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.13.4";
		Обработчик.Процедура = "Справочники.ЭДПрисоединенныеФайлы.ЗаполнитьНаименованиеФайла";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.13.6";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВерсииФорматовИсходящихЭДИПакета";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.14.2";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ЗаполнитьИспользованиеКриптографии";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.14.2";
		Обработчик.Процедура = "Документы.УдалитьПроизвольныйЭД.ЗаполнитьТипДокумента";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.2.1";
		Обработчик.Процедура = "ОбменСКонтрагентами.ЗаполнитьДанныеОПрофиляхНастроекЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.2.2";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВерсиюФорматаИсходящихЭД207_208";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.4.4";
		Обработчик.Процедура = "Справочники.УдалитьСертификатыЭП.ПеренестиНастройкиСертификатов";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.4.4";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеренестиНастройкиКонтекстаКриптографии";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.4.4";
		Обработчик.Процедура = "Справочники.ЭДПрисоединенныеФайлы.ИзменитьСтатусыПроизвольныхЭДСНеОтправленНаСформирован";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.2";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВерсиюФорматаИсходящихЭД501_502";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.8";
		Обработчик.Процедура = "РегистрыСведений.СостоянияЭД.УдалитьСостояниеУдалитьОжидаетсяИзвещение";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("a351a845-1550-45d5-af0f-b3a5739a90ee");
		Обработчик.Комментарий = НСтр("ru = 'Изменяет состояние документов с ""Ожидается извещение"" на ""Ожидается извещение о получении""'; en = 'Changes the state of documents from ""Notification expected"" to "" Notification of receipt expected""'");
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.1.9";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПроверитьКонтрагентовБЭД";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("28ce9ce8-fd89-44ed-9016-a904d4ff0990");
		Обработчик.Комментарий = НСтр("ru = 'Проверяет контрагентов на подключение к сервису 1С-ЭДО.'; en = 'Check counterparties for connections to 1C-EDI service'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.4";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.УдалитьОтветныеТитулы";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.20";
		Обработчик.Процедура = "ОбменСКонтрагентами.НастроитьАвтоПереходНаНовыеВерсииФорматовЭД";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.20";
		Обработчик.Процедура = "ОбменСКонтрагентами.УдалитьУстаревшиеОбработчики";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.4.8";
		Обработчик.Процедура = "ОбменСКонтрагентами.ДобавитьНовыеВидыЭДУПД_УКД";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.2";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеренестиПаролиВБезопасноеХранилище";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.4";
		Обработчик.Процедура = "ОбменСКонтрагентами.ЗаполнитьВходящиеДокументыНастроек";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.4";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеревестиНаНовуюАрхитектуруЭДО";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f1");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Создает входящие и исходящие ЭД'; en = 'Exchange with counterparties: Creates inbound and outbound ED'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.4";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеревестиНаНовуюАрхитектуруПроизвольныхЭД";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f2");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Создает входящие и исходящие ЭД для произвольных ЭД'; en = 'Exchange with counterparties: Creates inbound and outbound ED for arbitrary ED'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.4";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеревестиНаНовуюАрхитектуруПакетыЭД";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f3");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Удаляет полученные и отправленные пакеты ЭД'; en = 'Exchange with counterparties: deletes received and sent ED packages'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.7";
		Обработчик.Процедура = "ОбменСКонтрагентами.УдалитьНовыеВидыЭДУПД_УКД";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.7";
		Обработчик.Процедура = "Справочники.ПрофилиНастроекЭДО.ЗаполнитьРегламентЭДО";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.25";
		Обработчик.Процедура = "ОбменСКонтрагентами.УстановитьАктуальныеСостоянияЭД";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.25";
		Обработчик.Процедура = "Справочники.ПрофилиНастроекЭДО.СнятьФлагОтветнойПодписиУСчетаНаОплату";
		Обработчик.РежимВыполнения = "Монопольно";
		
	КонецЕсли;
	
	Если ЕстьБизнесСеть Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.5.3";
		Обработчик.Процедура = "РегистрыСведений.Пользователи1СБизнесСеть.ПереносЗаписейОрганизаций";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
	КонецЕсли;
	
	Если ЕстьОбменССайтами Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.6.2";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.УстановитьЗначениеРеквизитовВыгрузки";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.3";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.ЗаполнитьРеквизитФормыСоответствиеСтатусовЗаказов";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.3";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.ЗаполнитьРеквизитФормыЕдиницаИзмеренияНовойНоменклатуры";
		Обработчик.НачальноеЗаполнение = Ложь;
		
	КонецЕсли;
	
	Если ЕстьОбменСБанками И ЕстьОбменСКонтрагентами Тогда
	
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.1.1";
		Обработчик.Процедура = "ОбменСБанками.ПеренестиДанныеОбменаСБанками";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f7");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Обновляет данные подсистемы Обмен с банками'; en = '1C:DirectBank: updates data of bank exchange subsystem'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.1.1";
		Обработчик.Процедура = "ОбменСБанками.ОбработатьРегистрПодписываемыеВидыЭД";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("72fa8a62-3f99-4606-a4eb-92bcf23b6d8d");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Обновляет данные регистра Подписываемые виды ЭД'; en = '1C:DirectBank: updates data of register ED types to be signed'");
		
	КонецЕсли;
	
	Если ЕстьОбменСБанками Тогда
	
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.3.4";
		Обработчик.Процедура = "ОбменСБанками.ПеренестиДанныеДополнительныхОбработокВКонстанту";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("c008fa2f-33a5-4c51-b00f-25fbe916fb1a");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Переносит данные дополнительных обработок в константу'; en = '1C:DirectBank: transfers additional processors data to a constant'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.3";
		Обработчик.Процедура = "ОбменСБанками.ПеренестиСтатусыЭлектронныхПодписей";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("704454cb-bfa5-44ba-a9f0-8638aafa7efe");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Переносит статусы проверки подписей в присоединенные файлы'; en = '1C:DirectBank: transfer signature verification data to attached files'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.4.4";
		Обработчик.Процедура = "Справочники.НастройкиОбменСБанками.ЗаполнитьВерсиюФормата";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("788f991b-8283-4a84-a661-c021310a9cf9");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Заполняет версию формата.'; en = '1C:DirectBank: fills in the format version.'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.4.8";
		Обработчик.Процедура = "ОбменСБанками.ВключитьАвтоматическоеОбновлениеСпискаБанков";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("d788ef99-4874-4b3b-81ac-671856a5b183");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Включает автоматическое обновление списка банков.'; en = '1C:DirectBank: enables automatic update of banks list.'");
		
	КонецЕсли;
	
	
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПередОбновлениемИнформационнойБазы.
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПослеОбновленияИнформационнойБазы.
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриПодготовкеМакетаОписанияОбновлений.
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	

КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
 
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 
КонецПроцедуры

#КонецОбласти
