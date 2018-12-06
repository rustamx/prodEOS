﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
// УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ОбъектДоступа = ОбъектДоступа.Ссылка;
	
КонецПроцедуры

Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Ложь;
	
КонецФункции

Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат БизнесСобытияВызовСервера.ШаблонПодходитДляАвтозапускаБизнесПроцессаПоДокументу(ШаблонСсылка, 
		ПредметСсылка, Подписчик, ВидСобытия, Условие);
	
	//Возврат Истина;
	
КонецФункции

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.Документы.ra_Signal;
	
	ТаблицаРеквизитов = ра_ОбменДанными.ПолучитьТаблицуРеквизитовОбъекта(ОбъектМетаданных);
	
	АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов);
	
	ТекстЗапросаВложенныеТаблицы = ПолучитьТекстЗапросаВложенныеТаблицы();
	ТекстЗапросаСоединений = ПолучитьТекстЗапросаСоединений();
	
	Запрос = ра_ОбменДанными.ПолучитьЗапрос(ТаблицаРеквизитов, ПараметрыЗапросаHTTP, ПолноеИмя, ТекстЗапросаВложенныеТаблицы, ТекстЗапросаСоединений);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
	Результат.Вставить("value", МассивДанных);
	
	НастройкаФормы = ПараметрыЗапросаHTTP.Получить("$form_settings");
	Если ЗначениеЗаполнено(НастройкаФормы) И НастройкаФормы Тогда
		МассивКолонок = ПолучитьПолучитьМассивКолонокСписка();
		МассивКнопок = ПолучитьМассивКнопок(Запрос.Параметры);
		МассивФильтров = ПолучитьМассивФильтровСписка();
		Результат.Вставить("form_settings", МассивКолонок);
		Результат.Вставить("button_settings", МассивКнопок);
		Результат.Вставить("filter_settings", МассивФильтров);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ra_Signal;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	РеквизитыОбъекта = МетаданныеДокумента.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеДокумента.СтандартныеРеквизиты;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Дата);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.Proekt);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.VyyavivshayaOrganizaciya);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.VyyavivsheeLico);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.Organizaciya);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.OtvetstvenniyZaKachestvo);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.MestoViyavleniya);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.PodrobnoeOpisanie);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ra_Signal;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	РеквизитыОбъекта = МетаданныеДокумента.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеДокумента.СтандартныеРеквизиты;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Дата);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Номер);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.Proekt);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.PodrobnoeOpisanie);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.VyyavivshayaOrganizaciya);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.VyyavivsheeLico);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.OtvetstvenniyZaKachestvo);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.Organizaciya);
		
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьМассивКнопок(ДокументОбъект) Экспорт
	
	ВидФормы = "ФормаОбъекта";
	ДокументСылка = Документы.ra_Signal.ПустаяСсылка();
	Если ТипЗнч(ДокументОбъект) = Тип("Структура") Тогда
		ВидФормы = "ФормаСписка";
		Если ДокументОбъект.Свойство("Signal") Тогда
			ДокументСылка = ДокументОбъект.ra_Signal;
		КонецЕсли;
	Иначе
		ДокументСылка = ДокументОбъект.Ссылка;
	КонецЕсли;
	
	МассивКнопок = Новый Массив;
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		ДоступныДействия = ДокументОбъект.Poluchateli.Количество() = 0 И ДокументОбъект.VyyavivsheeLico = Пользователи.ТекущийПользователь()
			Или ДокументОбъект.Poluchateli.Количество() И ДокументОбъект.OtvetstvenniyZaKachestvo = Пользователи.ТекущийПользователь();
		
		ЭтоНовыйСигнал = Не ОбщегоНазначения.СсылкаСуществует(ДокументСылка);
		
		ИмяКнопки = "Save";
		ОписаниеКнопки = НСтр("ru = 'Сохранить'; en = 'Save'");
		КнопкаСохранить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		КнопкаСохранить.Вставить("ObjectTypeLink", "Document_ra_Signal");
		КнопкаСохранить.Вставить("ObjectGUID", Строка(ДокументСылка.УникальныйИдентификатор()));
		КнопкаСохранить.Availability = ДоступныДействия;
		КнопкаСохранить.Visibility   = ДоступныДействия;
		МассивКнопок.Добавить(КнопкаСохранить);
		
		ИмяКнопки = "Redirect";
		ОписаниеКнопки = НСтр("ru = 'Направить'; en = 'Send'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.Вставить("ObjectTypeLink", "Document_ra_Signal");
		Кнопка.Вставить("ObjectGUID", Строка(ДокументСылка.УникальныйИдентификатор()));
		Кнопка.Availability = Ложь;
		Кнопка.Visibility   = Ложь;
		МассивКнопок.Добавить(Кнопка);
		
		ИмяКнопки = "CreateNC";
		ОписаниеКнопки = НСтр("ru = 'Несоответствие'; en = 'Nonconformity'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.Вставить("ObjectTypeLink", "Document_ra_Signal");
		Кнопка.Вставить("ObjectGUID", Строка(ДокументСылка.УникальныйИдентификатор()));
		Кнопка.Availability = ДоступныДействия и Не ЭтоНовыйСигнал;
		Кнопка.Visibility   = ДоступныДействия и Не ЭтоНовыйСигнал;
		МассивКнопок.Добавить(Кнопка);

		ИмяКнопки = "CreateCO";
		ОписаниеКнопки = НСтр("ru = 'Заявка на контрольную операцию'; en = 'Application for control operation'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.Вставить("ObjectTypeLink", "Document_ra_Signal");
		Кнопка.Вставить("ObjectGUID", Строка(ДокументСылка.УникальныйИдентификатор()));
		Кнопка.Availability = ДоступныДействия и Не ЭтоНовыйСигнал;
		Кнопка.Visibility   = ДоступныДействия и Не ЭтоНовыйСигнал;
		МассивКнопок.Добавить(Кнопка);
		
		Если ОбщегоНазначения.СсылкаСуществует(ДокументОбъект.Ссылка) Тогда
			ИмяКнопки = "Download";
			ОписаниеКнопки = НСтр("ru = 'Загрузить файл с компьютера;Перетащить с помощью Drag’n’Drop';
				|en = 'Load file from computer;Drag’n’Drop'");
			КнопкаЗагрузить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
			КнопкаЗагрузить.Availability = Истина;
			КнопкаЗагрузить.Visibility = Истина;
		Иначе
			ИмяКнопки = "Download";
			ОписаниеКнопки = НСтр("ru = 'После создания документа;вы сможете прикреплять к нему файлы';
				|en = 'After creating a document;you can attach files to it'");
			КнопкаЗагрузить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
			КнопкаЗагрузить.Availability = Ложь;
		КонецЕсли;
		МассивКнопок.Добавить(КнопкаЗагрузить);
		
	ИначеЕсли ВидФормы = "ФормаСписка" Тогда
		
		ИмяКнопки = "ShowMore";
		ОписаниеКнопки = НСтр("ru = 'Показать еще'; en = 'Show more'");
		КнопкаПоказатьЕще = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		ИмяКнопки = "Find";
		ОписаниеКнопки = НСтр("ru = 'Найти'; en = 'Find'");
		КнопкаНайти = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		ИмяКнопки = "Reset";
		ОписаниеКнопки = НСтр("ru = 'Сброс'; en = 'Reset'");
		КнопкаСброс = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		МассивКнопок.Добавить(КнопкаПоказатьЕще);
		МассивКнопок.Добавить(КнопкаНайти);
		МассивКнопок.Добавить(КнопкаСброс);
		
	КонецЕсли;
	
	Возврат МассивКнопок;
	
КонецФункции

Функция СформироватьМассивДанныхРолевойМодели(ДокументОбъект, ПараметрыФормирования = Неопределено) Экспорт
	
	Возврат Обработки.ра_ФормыБитрикс.Создать().ОписаниеФормы(ДокументОбъект.Метаданные(), ДокументОбъект);
	
КонецФункции

Процедура АктуализироватьМассивОбязательныхРеквизитов(МассивРеквизитов, ДокументОбъект = Неопределено) Экспорт
	
	МассивРеквизитов.Очистить();
	
КонецПроцедуры

Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт
	
	МассивЗаголовков = Новый Массив;
	
	ТаблицаЗаголовков = Новый ТаблицаЗначений;
	ТаблицаЗаголовков.Колонки.Добавить("Name");
	ТаблицаЗаголовков.Колонки.Добавить("Description");
	
	НоваяСтрока = ТаблицаЗаголовков.Добавить();
	НоваяСтрока.Name = "Detected";
	НоваяСтрока.Description = НСтр("ru = 'ВЫЯВИВШИЙ'; en = 'DETECTED'");
	
	НоваяСтрока = ТаблицаЗаголовков.Добавить();
	НоваяСтрока.Name = "Recipient";
	НоваяСтрока.Description = НСтр("ru = 'ПОЛУЧАТЕЛЬ'; en = 'RECIPIENT'");
	
	Для Каждого ТекЭлемент Из МассивДанных Цикл
		
	КонецЦикла;
	
	ТаблицаЗаголовков.Свернуть("Name,Description");
	
	Для Каждого ТекСтрока Из ТаблицаЗаголовков Цикл
		МассивЗаголовков.Добавить(Новый Структура("Name,Description", ТекСтрока.Name, ТекСтрока.Description));
	КонецЦикла;
	
	Возврат МассивЗаголовков;
	
КонецФункции

//V2

Функция ЕстьМетодДополнитьОписаниеМетаданных() Экспорт
	
	Возврат Истина;
	
КонецФункции

Процедура ДополнитьОписаниеМетаданных(ОбработкаОбъект, Данные, ПараметрыФормирования) Экспорт
	
	ОбработкаОбъект.ДобавитьИсключения("Ссылка,ПометкаУдаления,Проведен,ВидДокумента");
	
	ОбработкаОбъект.УстановитьВидимость(
		"Номер,
		|Дата,
		|MestoViyavleniya,
		|NarushennyeTrebovaniya,
		|Organizaciya,
		|OtvetstvenniyZaKachestvo,
		// ТСК Близнюк С.И.; 06.12.2018; task#1993{
		|EhtapVyyavleniya,
		|VidObektaNesootvetstviya,
		// ТСК Близнюк С.И.; 06.12.2018; task#1993}
		|PodrobnoeOpisanie,
		|Proekt,
		|VyyavivshayaOrganizaciya,
		|VyyavivsheePodrazdelenie,
		|VyyavivsheeLico,
		|VidKontrolnoyOperacii,
		|KontrolnoeMeropriyatie", Истина);
	
	ОбработкаОбъект.УстановитьДоступность(
		"MestoViyavleniya,
		|NarushennyeTrebovaniya,
		|Organizaciya,
		|OtvetstvenniyZaKachestvo,
		// ТСК Близнюк С.И.; 06.12.2018; task#1993{
		|EhtapVyyavleniya,
		|VidObektaNesootvetstviya,
		// ТСК Близнюк С.И.; 06.12.2018; task#1993}
		|PodrobnoeOpisanie,
		|Proekt,
		|VidKontrolnoyOperacii,
		|KontrolnoeMeropriyatie", Истина);
	
	ОбязательныеРеквизиты = ОбработкаОбъект.ОбязательныеРеквизиты();
	АктуализироватьМассивОбязательныхРеквизитов(ОбязательныеРеквизиты, Данные);
	ОбработкаОбъект.УстановитьОбязательность(ОбязательныеРеквизиты, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли