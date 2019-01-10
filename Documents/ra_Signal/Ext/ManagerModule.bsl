﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат БизнесСобытияВызовСервера.ШаблонПодходитДляАвтозапускаБизнесПроцессаПоДокументу(ШаблонСсылка, 
		ПредметСсылка, Подписчик, ВидСобытия, Условие);
	
КонецФункции

#Область УправлениеДоступом

// Проверяет наличие метода.
//
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка,
			|ВидДокумента,
			|VyyavivsheePodrazdelenie";
	
КонецФункции

// Заполняет переданный дескриптор доступа
//
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.ВидДокумента;
	ДескрипторДоступа.Подразделение = ОбъектДоступа.VyyavivsheePodrazdelenie;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеДоступом

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора, Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Объект) = Тип("ДокументСсылка.ra_Signal") Тогда
		Ссылка = Объект;
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ra_Signal") Тогда
		Ссылка = Объект.Ссылка;
	КонецЕсли;
	
	УчастникиПроцесса = Новый Массив;
	
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.ra_Signal") И Объект.ЭтоНовый() Тогда
		УчастникиПроцесса.Добавить(Объект.OtvetstvenniyZaKachestvo);
		УчастникиПроцесса.Добавить(Объект.VyyavivsheeLico);
	Иначе
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "OtvetstvenniyZaKachestvo,VyyavivsheeLico");
		УчастникиПроцесса.Добавить(РеквизитыОбъекта.OtvetstvenniyZaKachestvo);
		УчастникиПроцесса.Добавить(РеквизитыОбъекта.VyyavivsheeLico);
	КонецЕсли;
	
	Для каждого УчастникПроцесса Из УчастникиПроцесса Цикл
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
			ТаблицаНабора,
			УчастникПроцесса,
			Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

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
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Номер);
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
		
		// ТСК Близнюк С.И.; 11.12.2018; task#2117{
		Если ТипЗнч(ДокументОбъект) = Тип("ДокументСсылка.ra_Signal") И НЕ ДокументОбъект.Пустая() Тогда
			СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОбъект,"VyyavivsheeLico,OtvetstvenniyZaKachestvo");
			VyyavivsheeLico = СтруктураРеквизитов.VyyavivsheeLico;
			OtvetstvenniyZaKachestvo = СтруктураРеквизитов.OtvetstvenniyZaKachestvo;
		Иначе
			VyyavivsheeLico = ДокументОбъект.VyyavivsheeLico;
			OtvetstvenniyZaKachestvo = ДокументОбъект.OtvetstvenniyZaKachestvo;
		КонецЕсли;			
		ЭтоВыявивший = VyyavivsheeLico = Пользователи.ТекущийПользователь();
		ЭтоПолучатель = OtvetstvenniyZaKachestvo = Пользователи.ТекущийПользователь();
		// ТСК Близнюк С.И.; 11.12.2018; task#2117}
		
		//ДоступныДействия = ДокументОбъект.Poluchateli.Количество() = 0 И ДокументОбъект.VyyavivsheeLico = Пользователи.ТекущийПользователь()
		//	Или ДокументОбъект.Poluchateli.Количество() И ДокументОбъект.OtvetstvenniyZaKachestvo = Пользователи.ТекущийПользователь();
		
		ЭтоНовыйСигнал = Не ОбщегоНазначения.СсылкаСуществует(ДокументСылка);
		
		ИмяКнопки = "Save";
		ОписаниеКнопки = НСтр("ru = 'Сохранить'; en = 'Save'");
		// ТСК Близнюк С.И.; 11.12.2018; task#2117{
		Если ЭтоВыявивший Тогда
			ОписаниеКнопки = НСтр("ru = 'Сохранить черновик'; en = 'Save draft'");
		КонецЕсли;
		// ТСК Близнюк С.И.; 11.12.2018; task#2117}
		КнопкаСохранить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		КнопкаСохранить.Вставить("ObjectTypeLink", "Document_ra_Signal");
		КнопкаСохранить.Вставить("ObjectGUID", Строка(ДокументСылка.УникальныйИдентификатор()));
		// ТСК Близнюк С.И.; 11.12.2018; task#2117{
		//КнопкаСохранить.Availability = ДоступныДействия;
		//КнопкаСохранить.Visibility   = ДоступныДействия;
		КнопкаСохранить.Availability = ЭтоВыявивший ИЛИ ЭтоПолучатель;
		КнопкаСохранить.Visibility   = ЭтоВыявивший ИЛИ ЭтоПолучатель;
		ПараметрыКнопки = Новый Структура;
		ПараметрыКнопки.Вставить("DocumentWriteMode", "Write");
		Если НЕ ЭтоВыявивший Тогда
			ПараметрыКнопки.Вставить("DocumentWriteMode", "Posting");
		КонецЕсли;
		КнопкаСохранить.Вставить("Parameters", ПараметрыКнопки);
		// ТСК Близнюк С.И.; 11.12.2018; task#2117}
		МассивКнопок.Добавить(КнопкаСохранить);
		
		ИмяКнопки = "Redirect";
		ОписаниеКнопки = НСтр("ru = 'Направить'; en = 'Send'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.Вставить("ObjectTypeLink", "Document_ra_Signal");
		Кнопка.Вставить("ObjectGUID", Строка(ДокументСылка.УникальныйИдентификатор()));
		// ТСК Близнюк С.И.; 11.12.2018; task#2117{
		//Кнопка.Availability = ДоступныДействия и Не ЭтоНовыйСигнал;
		//Кнопка.Visibility   = ДоступныДействия и Не ЭтоНовыйСигнал;
		//Кнопка.Availability = (ЭтоВыявивший ИЛИ ЭтоПолучатель) и Не ЭтоНовыйСигнал;
		//Кнопка.Visibility   = (ЭтоВыявивший ИЛИ ЭтоПолучатель) и Не ЭтоНовыйСигнал;
		Кнопка.Availability = ЭтоВыявивший ИЛИ ЭтоПолучатель;
		Кнопка.Visibility   = ЭтоВыявивший ИЛИ ЭтоПолучатель;
		ПараметрыКнопки = Новый Структура;
		ПараметрыКнопки.Вставить("DocumentWriteMode", "Posting");
		Кнопка.Вставить("Parameters", ПараметрыКнопки);
		ДополнительныеСвойстваКнопки = Новый Структура;
		ДополнительныеСвойстваКнопки.Вставить("SendingForAcquaintance", true);
		Кнопка.Вставить("AdditionalProperties", ДополнительныеСвойстваКнопки);
		// ТСК Близнюк С.И.; 11.12.2018; task#2117}
		МассивКнопок.Добавить(Кнопка);
		
		ИмяКнопки = "CreateNC";
		ОписаниеКнопки = НСтр("ru = 'Несоответствие'; en = 'Nonconformity'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.Вставить("ObjectTypeLink", "Document_ra_Signal");
		Кнопка.Вставить("ObjectGUID", Строка(ДокументСылка.УникальныйИдентификатор()));
		// ТСК Близнюк С.И.; 11.12.2018; task#2117{
		//Кнопка.Availability = ДоступныДействия и Не ЭтоНовыйСигнал;
		//Кнопка.Visibility   = ДоступныДействия и Не ЭтоНовыйСигнал;
		Кнопка.Availability = ЭтоПолучатель и Не ЭтоНовыйСигнал;
		Кнопка.Visibility   = ЭтоПолучатель и Не ЭтоНовыйСигнал;
		// ТСК Близнюк С.И.; 11.12.2018; task#2117}
		МассивКнопок.Добавить(Кнопка);

		ИмяКнопки = "CreateCO";
		ОписаниеКнопки = НСтр("ru = 'Заявка на контрольную операцию'; en = 'Application for control operation'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.Вставить("ObjectTypeLink", "Document_ra_Signal");
		Кнопка.Вставить("ObjectGUID", Строка(ДокументСылка.УникальныйИдентификатор()));
		// ТСК Близнюк С.И.; 11.12.2018; task#2117{
		//Кнопка.Availability = ДоступныДействия и Не ЭтоНовыйСигнал;
		//Кнопка.Visibility   = ДоступныДействия и Не ЭтоНовыйСигнал;
		Кнопка.Availability = ЭтоПолучатель и Не ЭтоНовыйСигнал;
		Кнопка.Visibility   = ЭтоПолучатель и Не ЭтоНовыйСигнал;
		// ТСК Близнюк С.И.; 11.12.2018; task#2117}
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
	
	// ТСК Близнюк С.И.; 11.12.2018; task#2117{
	//МассивРеквизитов.Очистить();
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументСсылка.ra_Signal") Тогда
		OtvetstvenniyZaKachestvo = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОбъект,"OtvetstvenniyZaKachestvo");
	Иначе
		OtvetstvenniyZaKachestvo = ДокументОбъект.OtvetstvenniyZaKachestvo;
	КонецЕсли;
	Если OtvetstvenniyZaKachestvo = Пользователи.ТекущийПользователь() Тогда
		МассивРеквизитов.Добавить("EhtapVyyavleniya");
		МассивРеквизитов.Добавить("VidObektaNesootvetstviya");
		МассивРеквизитов.Добавить("VidKontrolnoyOperacii");
		МассивРеквизитов.Добавить("KontrolnoeMeropriyatie");
	КонецЕсли;
	
	////запись черновика
	//Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ra_Signal") И НЕ ДокументОбъект.ДополнительныеСвойства.Свойство("SendingForAcquaintance") Тогда
	//	МассивРеквизитов.Очистить();
	//	//МассивРеквизитов.Добавить("PodrobnoeOpisanie");
	//КонецЕсли;
	// ТСК Близнюк С.И.; 11.12.2018; task#2117}
	
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
		|PodrobnoeOpisanie,
		|Proekt,
		|VyyavivshayaOrganizaciya,
		|VyyavivsheePodrazdelenie,
		|VyyavivsheeLico", Истина);
	
	ОбработкаОбъект.УстановитьДоступность(
		"MestoViyavleniya,
		|NarushennyeTrebovaniya,
		|Organizaciya,
		|OtvetstvenniyZaKachestvo,
		|PodrobnoeOpisanie,
		|Proekt", Истина);
	
	// ТСК Близнюк С.И.; 11.12.2018; task#2117{
	Если ТипЗнч(Данные) = Тип("ДокументСсылка.ra_Signal") Тогда
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Данные,"OtvetstvenniyZaKachestvo,EhtapVyyavleniya,VidKontrolnoyOperacii");
		OtvetstvenniyZaKachestvo 	= СтруктураРеквизитов.OtvetstvenniyZaKachestvo;
		EhtapVyyavleniya 			= СтруктураРеквизитов.EhtapVyyavleniya;
		VidKontrolnoyOperacii 		= СтруктураРеквизитов.VidKontrolnoyOperacii;
	Иначе
		OtvetstvenniyZaKachestvo 	= Данные.OtvetstvenniyZaKachestvo;
		EhtapVyyavleniya 			= Данные.EhtapVyyavleniya;
		VidKontrolnoyOperacii 		= Данные.VidKontrolnoyOperacii;
	КонецЕсли;
	ДоступностьПолучатель = OtvetstvenniyZaKachestvo = Пользователи.ТекущийПользователь();
			
	ОбработкаОбъект.УстановитьВидимость(
		"EhtapVyyavleniya,
		|VidObektaNesootvetstviya,
		|VidKontrolnoyOperacii,
		|KontrolnoeMeropriyatie", ДоступностьПолучатель);
		
	ОбработкаОбъект.УстановитьДоступность(
		"EhtapVyyavleniya,
		|VidObektaNesootvetstviya", ДоступностьПолучатель);
	// ТСК Близнюк С.И.; 11.12.2018; task#2117}
	
	ОбработкаОбъект.УстановитьДоступность(
		"VidKontrolnoyOperacii", ДоступностьПолучатель И ЗначениеЗаполнено(EhtapVyyavleniya));
	
	ОбработкаОбъект.УстановитьДоступность(
		"KontrolnoeMeropriyatie", ДоступностьПолучатель И ЗначениеЗаполнено(EhtapVyyavleniya) И ЗначениеЗаполнено(VidKontrolnoyOperacii) И VidKontrolnoyOperacii <> Справочники.ra_KontrolnyeMeropriyatiya.БезКонтрольнойОперации);
	
	ОбязательныеРеквизиты = ОбработкаОбъект.ОбязательныеРеквизиты();
	АктуализироватьМассивОбязательныхРеквизитов(ОбязательныеРеквизиты, Данные);
	ОбработкаОбъект.УстановитьОбязательность(ОбязательныеРеквизиты, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли