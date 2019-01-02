#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура АктуализироватьМассивОбязательныхРеквизитов(МассивРеквизитов, ЗаписьРегистра) Экспорт
	
	ДанныеЗаявкиКО = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаписьРегистра.ZayavkaNaKontrolnuyuOperaciyu, "VidObektaKontrolya,EhtapVyyavleniya");
	
	VidObektaKontrolya				= ДанныеЗаявкиКО.VidObektaKontrolya;
	EhtapVyyavleniya				= ДанныеЗаявкиКО.EhtapVyyavleniya;
	
	//Виды объектов контроля
	PrD								= Перечисления.ra_VidyPredmetovNesootvetstviya.PrD;
	Oborudovanie					= Перечисления.ra_VidyPredmetovNesootvetstviya.Oborudovanie;
		
	//Этапы выявления
	СтроительноМонтажныеРаботы		= Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.СтроительноМонтажныеРаботы;
	ПускоНаладочныеРаботы			= Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.ПускоНаладочныеРаботы;
	Эксплуатация					= Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.Эксплуатация;
	
	МассивРеквизитов.Очистить();
	МассивРеквизитов.Добавить("OboznachenieINaimenovaniePredmeta");
	
	Если VidObektaKontrolya = PrD Тогда
		
		МассивРеквизитов.Добавить("ProektnayaDokumentaciya");
		
	ИначеЕсли VidObektaKontrolya = Oborudovanie Тогда
		
		МассивРеквизитов.Добавить("KlassBezopasnosti");
		
		Если EhtapVyyavleniya = СтроительноМонтажныеРаботы ИЛИ
			EhtapVyyavleniya = ПускоНаладочныеРаботы ИЛИ
			EhtapVyyavleniya = Эксплуатация Тогда
			
			МассивРеквизитов.Добавить("NaimenovanieOborudovaniya");
			МассивРеквизитов.Добавить("KlassifikatorMTRiO");
			МассивРеквизитов.Добавить("Oborudovanie");
			МассивРеквизитов.Добавить("ZavodskojNomerOborudovaniya");
			
		КонецЕсли;
		
	КонецЕсли;
			
КонецПроцедуры

Функция ПолучитьДанныеПоИдентификатору(Идентификатор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ra_OpisaniePredmetaKontrolya.ZayavkaNaKontrolnuyuOperaciyu КАК ZayavkaNaKontrolnuyuOperaciyu,
	|	ra_OpisaniePredmetaKontrolya.ID КАК ID,
	|	ra_OpisaniePredmetaKontrolya.OboznachenieINaimenovaniePredmeta КАК OboznachenieINaimenovaniePredmeta,
	|	ra_OpisaniePredmetaKontrolya.ProektnayaDokumentaciya КАК ProektnayaDokumentaciya,
	|	ra_OpisaniePredmetaKontrolya.ReviziyaProektnojDokumentacii КАК ReviziyaProektnojDokumentacii,
	|	ra_OpisaniePredmetaKontrolya.RabochayaDokumentaciya КАК RabochayaDokumentaciya,
	|	ra_OpisaniePredmetaKontrolya.ReviziyaRabochejDokumentacii КАК ReviziyaRabochejDokumentacii,
	|	ra_OpisaniePredmetaKontrolya.NaimenovanieTekhnologicheskojSistemy КАК NaimenovanieTekhnologicheskojSistemy,
	|	ra_OpisaniePredmetaKontrolya.NaimenovanieOborudovaniya КАК NaimenovanieOborudovaniya,
	|	ra_OpisaniePredmetaKontrolya.KlassifikatorMTRiO КАК KlassifikatorMTRiO,
	|	ra_OpisaniePredmetaKontrolya.Oborudovanie КАК Oborudovanie,
	|	ra_OpisaniePredmetaKontrolya.ZavodskojNomerOborudovaniya КАК ZavodskojNomerOborudovaniya,
	|	ra_OpisaniePredmetaKontrolya.DataIzgotovleniyaProdukcii КАК DataIzgotovleniyaProdukcii,
	|	ra_OpisaniePredmetaKontrolya.ChertezhnyjNomer КАК ChertezhnyjNomer,
	|	ra_OpisaniePredmetaKontrolya.NomerPlanaKachestva КАК NomerPlanaKachestva,
	|	ra_OpisaniePredmetaKontrolya.Sertifikat КАК Sertifikat,
	|	ra_OpisaniePredmetaKontrolya.OrganizatsiyaVydavshayaSertifikat КАК OrganizatsiyaVydavshayaSertifikat,
	|	ra_OpisaniePredmetaKontrolya.KlassBezopasnosti КАК KlassBezopasnosti,
	|	ra_OpisaniePredmetaKontrolya.NomerPartii КАК NomerPartii,
	|	ra_ZayavkaNaKontrolnuyuOperaciyu.EhtapVyyavleniya КАК EhtapVyyavleniya,
	|	ВЫБОР
	|		КОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.Kontroler = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) ИЛИ ra_ZayavkaNaKontrolnuyuOperaciyu.VvodInformaciiOZavershivshemsyaMeropriyatii
	|			ТОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.Zayavitel
	|		ИНАЧЕ ra_ZayavkaNaKontrolnuyuOperaciyu.Kontroler
	|	КОНЕЦ КАК VyyavivsheeLico,
	|	ra_ZayavkaNaKontrolnuyuOperaciyu.MestoVyyavleniya КАК MestoVyyavleniyaNS,
	|	ra_ZayavkaNaKontrolnuyuOperaciyu.Obekt КАК Obekt,
	|	ВЫБОР
	|		КОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.OrganizaciyaKontroler = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ИЛИ ra_ZayavkaNaKontrolnuyuOperaciyu.VvodInformaciiOZavershivshemsyaMeropriyatii
	|			ТОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.OrganizaciyaZayavitel
	|		ИНАЧЕ ra_ZayavkaNaKontrolnuyuOperaciyu.OrganizaciyaKontroler
	|	КОНЕЦ КАК VyyavivshayaOrganizaciya,
	|	ra_ZayavkaNaKontrolnuyuOperaciyu.Ploshchadka КАК Ploshchadka,
	|	ВЫБОР
	|		КОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.PodrazdelenieKontroler = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) ИЛИ ra_ZayavkaNaKontrolnuyuOperaciyu.VvodInformaciiOZavershivshemsyaMeropriyatii
	|			ТОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.PodrazdelenieZayavitel
	|		ИНАЧЕ ra_ZayavkaNaKontrolnuyuOperaciyu.PodrazdelenieKontroler
	|	КОНЕЦ КАК VyyavivsheePodrazdelenie,
	|	ra_ZayavkaNaKontrolnuyuOperaciyu.DataPredyavleniyaNaKontrol КАК DataVyyavleniya,
	|	ra_ZayavkaNaKontrolnuyuOperaciyu.Proekt КАК Proekt,
	|	ra_ZayavkaNaKontrolnuyuOperaciyu.VidKontrolnoyOperacii КАК VidKontrolnoyOperacii,
	|	ra_ZayavkaNaKontrolnuyuOperaciyu.VidObektaKontrolya КАК VidObektaNesootvetstviya,
	|	ra_ZayavkaNaKontrolnuyuOperaciyu.ZdanieSooruzhenie КАК ZdanieSooruzhenie
	|ИЗ
	|	РегистрСведений.ra_OpisaniePredmetaKontrolya КАК ra_OpisaniePredmetaKontrolya
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ra_ZayavkaNaKontrolnuyuOperaciyu КАК ra_ZayavkaNaKontrolnuyuOperaciyu
	|		ПО ra_OpisaniePredmetaKontrolya.ZayavkaNaKontrolnuyuOperaciyu = ra_ZayavkaNaKontrolnuyuOperaciyu.Ссылка
	|ГДЕ
	|	ra_OpisaniePredmetaKontrolya.ID = &Идентификатор";
	
	Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Запрос.Выполнить().Выгрузить()[0]);	
	
КонецФункции

#КонецОбласти

#Область ИнтеграцияBitrix

Функция ЕстьМетодЗаголовокФормы() Экспорт
	
	Возврат Истина;
	
КонецФункции

Функция ЗаголовокФормы(ДокументОбъект) Экспорт
	
	ОбластьПрименения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОбъект.ZayavkaNaKontrolnuyuOperaciyu, "KontrolnoeMeropriyatie.OblastPrimeneniya");
	Если ОбластьПрименения = Справочники.ra_OblastiPrimeneniya.АудитСМК Тогда
		Возврат НСтр("ru = 'Описание объекта аудита'; en = 'Description of audit object'");
	Иначе
		Возврат НСтр("ru = 'Описание объекта контроля'; en = 'Description of control object'");;
	КонецЕсли;
	
КонецФункции

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.РегистрыСведений.ra_OpisaniePredmetaKontrolya;
	
	ТаблицаРеквизитов = ра_ОбменДанными.ПолучитьТаблицуРеквизитовОбъекта(ОбъектМетаданных);
	
	АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов);
	
	ТекстЗапросаВложенныеТаблицы = ПолучитьТекстЗапросаВложенныеТаблицы();
	ТекстЗапросаСоединений = ПолучитьТекстЗапросаСоединений();
	
	Запрос = ра_ОбменДанными.ПолучитьЗапрос(ТаблицаРеквизитов, ПараметрыЗапросаHTTP, ПолноеИмя, ТекстЗапросаВложенныеТаблицы, ТекстЗапросаСоединений);
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	ДополнитьТаблицуДаннымиПоНесоответствиям(ТаблицаДанных);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос, , ТаблицаДанных);
	Результат.Вставить("value", МассивДанных);
	
	НастройкаФормы = ПараметрыЗапросаHTTP.Получить("$form_settings");
	Если ЗначениеЗаполнено(НастройкаФормы) И НастройкаФормы Тогда
		МассивКолонок = ПолучитьПолучитьМассивКолонокСписка(Запрос.Параметры);
		МассивКнопок = ПолучитьМассивКнопок(Запрос.Параметры);
		МассивФильтров = ПолучитьМассивФильтровСписка();
		Результат.Вставить("form_settings", МассивКолонок);
		Результат.Вставить("button_settings", МассивКнопок);
		Результат.Вставить("filter_settings", МассивФильтров);
		Если Запрос.Параметры.Свойство("ZayavkaNaKontrolnuyuOperaciyu") Тогда
			ОбластьПрименения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запрос.Параметры.ZayavkaNaKontrolnuyuOperaciyu, "KontrolnoeMeropriyatie.OblastPrimeneniya");
			Если ОбластьПрименения = Справочники.ra_OblastiPrimeneniya.АудитСМК Тогда
				Результат.Вставить("FormCaption", НСтр("ru = 'Описание объекта аудита'; en = 'Description of audit object'"));
			Иначе
				Результат.Вставить("FormCaption", ОбъектМетаданных.Синоним);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьТаблицуДаннымиПоНесоответствиям(ТаблицаДанных)
	
	КолонкаТЗ = ТаблицаДанных.Колонки.Найти("ID");
	
	Если КолонкаТЗ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокИдентификаторов = ТаблицаДанных.ВыгрузитьКолонку("ID");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("СписокИдентификаторов", СписокИдентификаторов);
		
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ra_Nesootvetstvie.OpisaniePredmetaKontrolyaID КАК ID,
	|	КОЛИЧЕСТВО(ra_Nesootvetstvie.Ссылка) КАК КоличествоНС
	|ИЗ
	|	Документ.ra_Nesootvetstvie КАК ra_Nesootvetstvie
	|ГДЕ
	|	ra_Nesootvetstvie.OpisaniePredmetaKontrolyaID В(&СписокИдентификаторов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ra_Nesootvetstvie.OpisaniePredmetaKontrolyaID";
	
	ТаблицаИдентификаторов = Запрос.Выполнить().Выгрузить();
	ТаблицаИдентификаторов.Индексы.Добавить("ID");
	
	ТаблицаДанных.Колонки.Добавить("NonconformitiesNumber____Presentation");
	
	Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
		
		СтрокаИдентификатор = ТаблицаИдентификаторов.Найти(СтрокаДанных["ID"], "ID");
		НесоответствиеТекст = НСтр("ru = 'Несоответствия'; en = 'Nonconformities'");
		
		Если СтрокаИдентификатор <> Неопределено Тогда
			СтрокаДанных["NonconformitiesNumber____Presentation"] = СтрШаблон("%1 (%2)", НесоответствиеТекст, СтрокаИдентификатор.КоличествоНС);
		Иначе
			СтрокаДанных["NonconformitiesNumber____Presentation"] = СтрШаблон("%1 (%2)", НесоответствиеТекст, 0);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
		
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "";
	
КонецФункции

Функция СформироватьМассивДанныхРолевойМодели(МенеджерЗаписи, ПараметрыФормирования = Неопределено) Экспорт
	
	Возврат Обработки.ра_ФормыБитрикс.Создать().ОписаниеФормы(Метаданные.РегистрыСведений.ra_OpisaniePredmetaKontrolya, МенеджерЗаписи, ПараметрыФормирования);
	
КонецФункции

Функция ПолучитьМассивКнопок(МенеджерЗаписи) Экспорт
	
	ВидФормы = "ФормаОбъекта";
	ЗаявкаКО = Документы.ra_ZayavkaNaKontrolnuyuOperaciyu.ПустаяСсылка();
	Если ТипЗнч(МенеджерЗаписи) = Тип("Структура") Тогда
		ВидФормы = "ФормаСписка";
		Если МенеджерЗаписи.Свойство("ZayavkaNaKontrolnuyuOperaciyu") Тогда
			ЗаявкаКО = МенеджерЗаписи.ZayavkaNaKontrolnuyuOperaciyu;
		КонецЕсли;
	Иначе
		ЗаявкаКО = МенеджерЗаписи.ZayavkaNaKontrolnuyuOperaciyu;
	КонецЕсли;
	
	МассивКнопок = Новый Массив;
	
	Если ВидФормы = "ФормаСписка" Тогда
				
		ИмяКнопки = "AddRow";
		ОписаниеКнопки = НСтр("ru = 'Добавить строку'; en = 'Add row'");
		КнопкаДобавитьСтроку = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		ИмяКнопки = "AddNonconformity";
		ОписаниеКнопки = НСтр("ru = 'Добавить Несоответствие'; en = 'Add Nonconformity'");
		КнопкаДобавитьНесоответствие = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		ИмяКнопки = "Nonconformities";
		ОписаниеКнопки = НСтр("ru = 'Несоответствия'; en = 'Nonconformities'");
		КнопкаНесоответствия = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
						
		МассивКнопок.Добавить(КнопкаДобавитьСтроку);
		МассивКнопок.Добавить(КнопкаДобавитьНесоответствие);
		МассивКнопок.Добавить(КнопкаНесоответствия);
						
	ИначеЕсли ВидФормы = "ФормаОбъекта" Тогда
		
		ИмяКнопки = "Save";
		ОписаниеКнопки = НСтр("ru = 'Сохранить'; en = 'Save'");
		КнопкаСохранить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		МассивКнопок.Добавить(КнопкаСохранить);
		
	КонецЕсли;
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка(СтруктураПараметры) Экспорт
	
	ЗаявкаКО = Документы.ra_ZayavkaNaKontrolnuyuOperaciyu.ПустаяСсылка();
	Если СтруктураПараметры.Свойство("ZayavkaNaKontrolnuyuOperaciyu") Тогда
		ЗаявкаКО = СтруктураПараметры.ZayavkaNaKontrolnuyuOperaciyu;
	КонецЕсли;
		
	МетаданныеРегистра = Метаданные.РегистрыСведений.ra_OpisaniePredmetaKontrolya;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	ИзмеренияРегистра = МетаданныеРегистра.Измерения;
	РесурсыРегистра = МетаданныеРегистра.Ресурсы;
	
	ДанныеЗаявкиКО = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаявкаКО, "VidObektaKontrolya,EhtapVyyavleniya,KontrolnoeMeropriyatie.OblastPrimeneniya");
	
	СтрокаНастроек = ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.OboznachenieINaimenovaniePredmeta);
	
	Если ДанныеЗаявкиКО.KontrolnoeMeropriyatieOblastPrimeneniya = Справочники.ra_OblastiPrimeneniya.АудитСМК Тогда
		СтрокаНастроек.Синоним = НСтр("ru = 'Описание объекта аудита'; en = 'Description of audit object'");
	КонецЕсли;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.KriteriiKontrolya);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, Новый Структура("Имя,Синоним", "NonconformitiesNumber", НСтр("ru = 'Несоответствия'; en = 'Nonconformities'")), "Buttons");
	
	VidObektaKontrolya				= ДанныеЗаявкиКО.VidObektaKontrolya;
		
	//Виды объектов контроля
	PrD								= Перечисления.ra_VidyPredmetovNesootvetstviya.PrD;
	RD								= Перечисления.ra_VidyPredmetovNesootvetstviya.RD;
	StroitelnyeKonstrukciiEhlement	= Перечисления.ra_VidyPredmetovNesootvetstviya.StroitelnyeKonstrukciiEhlement;
	NaladochnyeDokumentyRaboty		= Перечисления.ra_VidyPredmetovNesootvetstviya.NaladochnyeDokumentyRaboty;
	TekhnologicheskayaSistema		= Перечисления.ra_VidyPredmetovNesootvetstviya.TekhnologicheskayaSistema;
	Oborudovanie					= Перечисления.ra_VidyPredmetovNesootvetstviya.Oborudovanie;
				
	Если VidObektaKontrolya = PrD Тогда
		
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.ProektnayaDokumentaciya);
		
	ИначеЕсли VidObektaKontrolya = RD Тогда
		
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.RabochayaDokumentaciya);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.ReviziyaRabochejDokumentacii);
		
	ИначеЕсли VidObektaKontrolya = StroitelnyeKonstrukciiEhlement Тогда
		
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.RabochayaDokumentaciya);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.KlassBezopasnosti);
		
	ИначеЕсли VidObektaKontrolya = NaladochnyeDokumentyRaboty Тогда
		
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.NaimenovanieTekhnologicheskojSistemy);
		
	ИначеЕсли VidObektaKontrolya = TekhnologicheskayaSistema Тогда
		
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.NaimenovanieTekhnologicheskojSistemy);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.NaimenovanieOborudovaniya);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.KlassifikatorMTRiO);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.Oborudovanie);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.ZavodskojNomerOborudovaniya);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.DataIzgotovleniyaProdukcii);
		
	ИначеЕсли VidObektaKontrolya = Oborudovanie Тогда
		
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.NaimenovanieOborudovaniya);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.KlassifikatorMTRiO);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.Oborudovanie);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.ZavodskojNomerOborudovaniya);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.NomerPlanaKachestva);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.Sertifikat);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.OrganizatsiyaVydavshayaSertifikat);
		ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.KlassBezopasnosti);
		
	КонецЕсли;
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МассивДанных = Новый Массив;
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт
	
	МассивЗаголовков = Новый Массив;
	
	ТаблицаЗаголовков = Новый ТаблицаЗначений;
	ТаблицаЗаголовков.Колонки.Добавить("Name");
	ТаблицаЗаголовков.Колонки.Добавить("Description");
		
	Для Каждого ТекСтрока Из ТаблицаЗаголовков Цикл
		МассивЗаголовков.Добавить(Новый Структура("Name,Description",ТекСтрока.Name,ТекСтрока.Description));
	КонецЦикла;
	
	Возврат МассивЗаголовков;
	
КонецФункции

//V2

Функция ЕстьМетодДополнитьОписаниеМетаданных() Экспорт
	
	Возврат Истина;
	
КонецФункции

Процедура ДополнитьОписаниеМетаданных(ОбработкаОбъект, Данные, ПараметрыФормирования) Экспорт
	
	ДанныеЗаявкиКО = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Данные.ZayavkaNaKontrolnuyuOperaciyu, "VidObektaKontrolya,KontrolnoeMeropriyatie.OblastPrimeneniya,Proekt");
	
	VidObektaKontrolya				= ДанныеЗаявкиКО.VidObektaKontrolya;
	
	//Виды объектов контроля
	PrD								= Перечисления.ra_VidyPredmetovNesootvetstviya.PrD;
	RD								= Перечисления.ra_VidyPredmetovNesootvetstviya.RD;
	StroitelnyeKonstrukciiEhlement	= Перечисления.ra_VidyPredmetovNesootvetstviya.StroitelnyeKonstrukciiEhlement;
	NaladochnyeDokumentyRaboty		= Перечисления.ra_VidyPredmetovNesootvetstviya.NaladochnyeDokumentyRaboty;
	TekhnologicheskayaSistema		= Перечисления.ra_VidyPredmetovNesootvetstviya.TekhnologicheskayaSistema;
	Oborudovanie					= Перечисления.ra_VidyPredmetovNesootvetstviya.Oborudovanie;
	
	МассивПолей = Новый Массив;
	МассивПолей.Добавить("OboznachenieINaimenovaniePredmeta");
	МассивПолей.Добавить("KriteriiKontrolya");
	
	Если VidObektaKontrolya = PrD Тогда
		
		МассивПолей.Добавить("ProektnayaDokumentaciya");
		
	ИначеЕсли VidObektaKontrolya = RD Тогда
		
		МассивПолей.Добавить("RabochayaDokumentaciya");
		МассивПолей.Добавить("ReviziyaRabochejDokumentacii");
		
	ИначеЕсли VidObektaKontrolya = StroitelnyeKonstrukciiEhlement Тогда
		
		МассивПолей.Добавить("RabochayaDokumentaciya");
		МассивПолей.Добавить("KlassBezopasnosti");
		
	ИначеЕсли VidObektaKontrolya = NaladochnyeDokumentyRaboty Тогда
		
		МассивПолей.Добавить("NaimenovanieTekhnologicheskojSistemy");
		
	ИначеЕсли VidObektaKontrolya = TekhnologicheskayaSistema Тогда
		
		МассивПолей.Добавить("NaimenovanieTekhnologicheskojSistemy");
		МассивПолей.Добавить("NaimenovanieOborudovaniya");
		МассивПолей.Добавить("KlassifikatorMTRiO");
		МассивПолей.Добавить("Oborudovanie");
		МассивПолей.Добавить("ZavodskojNomerOborudovaniya");
		МассивПолей.Добавить("DataIzgotovleniyaProdukcii");
		
	ИначеЕсли VidObektaKontrolya = Oborudovanie Тогда
		
		МассивПолей.Добавить("NaimenovanieOborudovaniya");
		МассивПолей.Добавить("KlassifikatorMTRiO");
		МассивПолей.Добавить("Oborudovanie");
		МассивПолей.Добавить("ZavodskojNomerOborudovaniya");
		МассивПолей.Добавить("NomerPlanaKachestva");
		МассивПолей.Добавить("Sertifikat");
		МассивПолей.Добавить("OrganizatsiyaVydavshayaSertifikat");
		МассивПолей.Добавить("KlassBezopasnosti");
		
	КонецЕсли;
	
	ОбработкаОбъект.УстановитьДоступность(МассивПолей, Истина);
	ОбработкаОбъект.УстановитьВидимость(МассивПолей, Истина);
	
	//KlassifikatorMTRiO заполняется перед записью из NaimenovanieOborudovaniya
	ОбработкаОбъект.УстановитьДоступность("KlassifikatorMTRiO", Ложь);
		
	Если ДанныеЗаявкиКО.KontrolnoeMeropriyatieOblastPrimeneniya = Справочники.ra_OblastiPrimeneniya.АудитСМК Тогда
		ОбработкаОбъект.УстановитьСиноним("OboznachenieINaimenovaniePredmeta", НСтр("ru = 'Описание объекта аудита'; en = 'Description of audit object'"));
	КонецЕсли;
	
	//Поле Proekt из ZayavkaNaKontrolnuyuOperaciyu
	МетаданныеНС = Метаданные.Документы.ra_Nesootvetstvie;
	ОбработкаОбъект.ДобавитьПоле("", МетаданныеНС.Реквизиты.Proekt);
	ОбработкаОбъект.ЗаместитьДанные("Proekt", ДанныеЗаявкиКО.Proekt);
	
	СвязиПараметровВыбора = Новый Массив;
	СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Proekt"));
	ОбработкаОбъект.УстановитьСвязиПараметровВыбора("ProektnayaDokumentaciya", СвязиПараметровВыбора);
	ОбработкаОбъект.УстановитьСвязиПараметровВыбора("RabochayaDokumentaciya", СвязиПараметровВыбора);
	ОбработкаОбъект.УстановитьСвязиПараметровВыбора("NaimenovanieTekhnologicheskojSistemy", СвязиПараметровВыбора);
	ОбработкаОбъект.УстановитьСвязиПараметровВыбора("Oborudovanie", СвязиПараметровВыбора);
		
	ОбязательныеРеквизиты = ОбработкаОбъект.ОбязательныеРеквизиты();
	АктуализироватьМассивОбязательныхРеквизитов(ОбязательныеРеквизиты, Данные);
	ОбработкаОбъект.УстановитьОбязательность(ОбязательныеРеквизиты, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли