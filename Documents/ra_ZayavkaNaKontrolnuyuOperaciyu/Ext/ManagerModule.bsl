﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура АктуализироватьМассивОбязательныхРеквизитов(МассивРеквизитов, ДокументОбъект) Экспорт
		
	VidObektaKontrolya				= ДокументОбъект.VidObektaKontrolya;
	EhtapVyyavleniya				= ДокументОбъект.EhtapVyyavleniya;
	
	//Виды объектов контроля
	PrD								= Перечисления.ra_VidyPredmetovNesootvetstviya.PrD;
	RD								= Перечисления.ra_VidyPredmetovNesootvetstviya.RD;
	StroitelnyeKonstrukciiEhlement	= Перечисления.ra_VidyPredmetovNesootvetstviya.StroitelnyeKonstrukciiEhlement;
	NaladochnyeDokumentyRaboty		= Перечисления.ra_VidyPredmetovNesootvetstviya.NaladochnyeDokumentyRaboty;
	TekhnologicheskayaSistema		= Перечисления.ra_VidyPredmetovNesootvetstviya.TekhnologicheskayaSistema;
	Oborudovanie					= Перечисления.ra_VidyPredmetovNesootvetstviya.Oborudovanie;
	Materialy						= Перечисления.ra_VidyPredmetovNesootvetstviya.Materialy;
	Processy						= Перечисления.ra_VidyPredmetovNesootvetstviya.Processy;
	Dokumentaciya					= Перечисления.ra_VidyPredmetovNesootvetstviya.Dokumentaciya;
	TekhDokumentaciya				= Перечисления.ra_VidyPredmetovNesootvetstviya.TekhDokumentaciya;
	
	//Этапы выявления
	СтроительноМонтажныеРаботы	= Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.СтроительноМонтажныеРаботы;
	ПускоНаладочныеРаботы		= Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.ПускоНаладочныеРаботы;
	Эксплуатация				= Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.Эксплуатация;
	Изготовление				= Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.Изготовление;
	
	МассивРеквизитов.Очистить();
	МассивРеквизитов.Добавить("EhtapVyyavleniya");
	МассивРеквизитов.Добавить("KontrolnoeMeropriyatie");
	МассивРеквизитов.Добавить("VidKontrolnoyOperacii");
	МассивРеквизитов.Добавить("VidObektaKontrolya");
	МассивРеквизитов.Добавить("PlanovayaDataPnK");
	МассивРеквизитов.Добавить("PoryadkovyjNomerPredyavleniya");
	
	Если НЕ ДокументОбъект.TekstovyjVvodOKontrolere Тогда
		МассивРеквизитов.Добавить("OrganizaciyaKontroler");
		МассивРеквизитов.Добавить("PodrazdelenieKontroler");
		МассивРеквизитов.Добавить("RukovoditelKontrolera");
	Иначе
		МассивРеквизитов.Добавить("OrganizaciyaKontrolerStroka");
		МассивРеквизитов.Добавить("PodrazdelenieKontrolerStroka");
		МассивРеквизитов.Добавить("RukovoditelKontroleraStroka");
	КонецЕсли;
	
	МассивРеквизитов.Добавить("OrganizaciyaZayavitel");
	МассивРеквизитов.Добавить("PodrazdelenieZayavitel");
	МассивРеквизитов.Добавить("Zayavitel");
	
	OblastPrimeneniya = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		ДокументОбъект.KontrolnoeMeropriyatie, "OblastPrimeneniya");
	
	Если OblastPrimeneniya = Справочники.ra_OblastiPrimeneniya.АудитСМК Тогда
		МассивРеквизитов.Добавить("Ploshchadka");
	КонецЕсли;
		
	Если Не VidObektaKontrolya = Processy Тогда
		МассивРеквизитов.Добавить("Proekt");
		МассивРеквизитов.Добавить("Obekt");
		МассивРеквизитов.Добавить("DogovorSPostavshchikom");
	КонецЕсли;
		
	Если (VidObektaKontrolya = RD И (EhtapVyyavleniya = СтроительноМонтажныеРаботы ИЛИ 
			EhtapVyyavleniya = ПускоНаладочныеРаботы ИЛИ EhtapVyyavleniya = Эксплуатация)) ИЛИ
			VidObektaKontrolya = StroitelnyeKonstrukciiEhlement ИЛИ
			VidObektaKontrolya = NaladochnyeDokumentyRaboty ИЛИ
			VidObektaKontrolya = TekhnologicheskayaSistema Тогда
		МассивРеквизитов.Добавить("ZdanieSooruzhenie");
	КонецЕсли;
		
КонецПроцедуры

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати, СтруктураПараметров = Неопределено) Экспорт
	
	ра_ОбщегоНазначения.ВыполнитьЗаполнениеКомандПечатиДокументаЕОС(КомандыПечати, СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка,
			|ВидДокумента";
	
КонецФункции

// Заполняет переданный дескриптор доступа
//
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.ВидДокумента;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.Документы.ra_ZayavkaNaKontrolnuyuOperaciyu;
	
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

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
	
	СтруктураРеквизита = Новый Структура("Имя,Тип,Выражение", "DocStatus", "Перечисление.СостоянияДокументов", "ЕСТЬNULL(РС_ИсторияСостояний.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.ПустаяСсылка))");
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуРеквизитов(ТаблицаРеквизитов, СтруктураРеквизита);
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийДокументов.СрезПоследних КАК РС_ИсторияСостояний
			|	ПО ОсновнаяТаблица.Ссылка = РС_ИсторияСостояний.Документ";
	
КонецФункции

Функция СформироватьМассивДанныхРолевойМодели(ДокументОбъект, ПараметрыФормирования = Неопределено) Экспорт
		
	Возврат Обработки.ра_ФормыБитрикс.Создать().ОписаниеФормы(Метаданные.Документы.ra_ZayavkaNaKontrolnuyuOperaciyu, ДокументОбъект, ПараметрыФормирования);
	
КонецФункции

Процедура АктуализироватьТаблицуНастроек(ТаблицаНастроек, ДокументОбъект)
	
	
	
КонецПроцедуры

Функция ПолучитьМассивКнопок(ДокументОбъект) Экспорт
		
	ВидФормы = "ФормаОбъекта";
	ДокументСсылка = Документы.ra_ZayavkaNaKontrolnuyuOperaciyu.ПустаяСсылка();
	Если ТипЗнч(ДокументОбъект) = Тип("Структура") Тогда
		ВидФормы = "ФормаСписка";
		Если ДокументОбъект.Свойство("ZayavkaNaKontrolnuyuOperaciyu") Тогда
			ДокументСсылка = ДокументОбъект.ZayavkaNaKontrolnuyuOperaciyu;
		КонецЕсли;
	Иначе
		ДокументСсылка = ДокументОбъект.Ссылка;
	КонецЕсли;
	
	МассивКнопок = Новый Массив;
	
	Если ВидФормы = "ФормаСписка" Тогда
		
	ИначеЕсли ВидФормы = "ФормаОбъекта" Тогда
		
		ИмяКнопки = "Save";
		ОписаниеКнопки = НСтр("ru = 'Сохранить'; en = 'Save'");
		КнопкаСохранить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		КнопкаСохранить.Вставить("ObjectTypeLink", "Document_ra_ZayavkaNaKontrolnuyuOperaciyu");
		КнопкаСохранить.Вставить("ObjectGUID", Строка(ДокументСсылка.УникальныйИдентификатор()));
		
		МассивКнопок.Добавить(КнопкаСохранить);
		
		Если ОбщегоНазначения.СсылкаСуществует(ДокументСсылка) Тогда
			ИмяКнопки = "Download";
			ОписаниеКнопки = НСтр("ru = 'Загрузить файл с компьютера;Перетащить с помощью Drag’n’Drop';
				|en = 'Load file from computer;Drag’n’Drop'");
			КнопкаЗагрузить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Иначе
			ИмяКнопки = "Download";
			ОписаниеКнопки = НСтр("ru = 'После создания документа;вы сможете прикреплять к нему файлы';
				|en = 'After creating a document;you can attach files to it'");
			КнопкаЗагрузить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
			КнопкаЗагрузить.Availability = Ложь;
		КонецЕсли;
		
		МассивКнопок.Добавить(КнопкаЗагрузить);
		
		ИмяКнопки = "SendForApproval";
		ОписаниеКнопки = НСтр("ru = 'На согласование'; en = ' Send for approval'");
		КнопкаНаСогласование = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		МассивКнопок.Добавить(КнопкаНаСогласование);

	КонецЕсли;
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ra_ZayavkaNaKontrolnuyuOperaciyu;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	РеквизитыОбъекта = МетаданныеДокумента.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеДокумента.СтандартныеРеквизиты;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Номер);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.VidKontrolnoyOperacii);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, Новый Структура("Имя,Синоним", "DocStatus", НСтр("ru = 'Статус'; en = 'Status'")), "String(20)");
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.OrganizaciyaKontroler);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.OrganizaciyaZayavitel);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.PodtverzhdennayaDataPnK);	
			
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МассивДанных = Новый Массив;
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт
	
	МассивЗаголовков = Новый Массив;
	
	ИмяЗаголовка = "Applicant";
	ОписаниеЗаголовка = НСтр("ru = 'ЗАЯВИТЕЛЬ'; en = 'APPLICANT'");
	МассивЗаголовков.Добавить(Новый Структура("Name,Description", ИмяЗаголовка, ОписаниеЗаголовка));
	
	ИмяЗаголовка = "Controller";
	ОписаниеЗаголовка = НСтр("ru = 'КОНТРОЛЕР'; en = 'CONTROLLER'");
	МассивЗаголовков.Добавить(Новый Структура("Name,Description", ИмяЗаголовка, ОписаниеЗаголовка));
	
	ИмяЗаголовка = "Location";
	ОписаниеЗаголовка = НСтр("ru = 'МЕСТО ПРОВЕДЕНИЯ'; en = 'LOCATION'");
	МассивЗаголовков.Добавить(Новый Структура("Name,Description", ИмяЗаголовка, ОписаниеЗаголовка));
	
	ИмяЗаголовка = "ControlObject";
	ОписаниеЗаголовка = НСтр("ru = 'ПРЕДМЕТ КОНТРОЛЯ'; en = 'CONTROL OBJECT'");
	МассивЗаголовков.Добавить(Новый Структура("Name,Description", ИмяЗаголовка, ОписаниеЗаголовка));
		
	Возврат МассивЗаголовков;
	
КонецФункции

Процедура ЗаполнитьГлавноеМенюОбъекта(ОбъектБД, МассивПунктовМеню) Экспорт
	
	МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "Main", НСтр("ru = 'ОБЩЕЕ ОПИСАНИЕ'; en = 'GENERAL DESCRIPTION'"), Истина, Истина));
	МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "Participants", НСтр("ru = 'УЧАСТНИКИ'; en = 'PARTICIPANTS'"), Истина, Истина));
	МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "ControlObjectsResults", НСтр("ru = 'ОБЪЕКТЫ И РЕЗУЛЬТАТЫ КОНТРОЛЯ'; en = 'OBJECTS AND RESULTS OF CONTROL'"), Истина, Истина));
		
КонецПроцедуры

//V2

Функция ЕстьМетодДополнитьОписаниеМетаданных() Экспорт
	
	Возврат Истина;
	
КонецФункции

Процедура ДополнитьОписаниеМетаданных(ОбработкаОбъект, Данные, ПараметрыФормирования) Экспорт
		
	ОбработкаОбъект.ДобавитьИсключения("Ссылка,ПометкаУдаления,Проведен");
	
	СостояниеКО = РегистрыСведений.ИсторияСостоянийДокументов.ПолучитьСостояниеДокумента(Данные.Ссылка);
	
	ОбработкаОбъект.ДобавитьПоле("",
		Новый Структура("Имя,Синоним,Тип", "DocStatus", НСтр("ru = 'Статус'; en = 'Status'"), Новый ОписаниеТипов("ПеречислениеСсылка.СостоянияДокументов")));
	ОбработкаОбъект.ЗаместитьДанные("DocStatus", СостояниеКО);
				
	РеквизитыОсновная = "
		|Номер,
		|Дата,
		|VidObektaKontrolya,
		|Proekt,
		|Ploshchadka,
		|Obekt,
		|PlanovayaDataPnK,
		|PodtverzhdennayaDataPnK,
		|DlitelnostKO,
		|DogovorSPostavshchikom,
		|PredshestvuyushchayaKO,
		|OrganizaciyaZayavitel,
		|PodrazdelenieZayavitel,
		|Zayavitel,
		|OrganizaciyaKontroler,
		|PodrazdelenieKontroler,
		|RukovoditelKontrolera,
		|Kontroler,
		|TekstovyjVvodOKontrolere,
		|OrganizaciyaKontrolerStroka,
		|PodrazdelenieKontrolerStroka,
		|RukovoditelKontroleraStroka,
		|KontrolerStroka,
		|ZdanieSooruzhenie,
		|MestoVyyavleniya";
			
	ОбработкаОбъект.УстановитьВидимость(РеквизитыОсновная, Истина);
	ОбработкаОбъект.УстановитьДоступность(РеквизитыОсновная, Истина);
					
	ОбязательныеРеквизиты = ОбработкаОбъект.ОбязательныеРеквизиты();
	АктуализироватьМассивОбязательныхРеквизитов(ОбязательныеРеквизиты, Данные);
	ОбработкаОбъект.УстановитьОбязательность(ОбязательныеРеквизиты, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли