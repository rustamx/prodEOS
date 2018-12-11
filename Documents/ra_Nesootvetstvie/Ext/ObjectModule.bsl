#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ра_ОбщегоНазначения.ЗаполнитьВидДокумента(ЭтотОбъект);
	
	VyyavivsheeLico = ПользователиКлиентСервер.ТекущийПользователь();
	
	ЗаполнитьПоДаннымПользователя();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Свойство("OpisaniePredmetaKontrolyaID") Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект,
				РегистрыСведений.ra_OpisaniePredmetaKontrolya.ПолучитьДанныеПоИдентификатору(OpisaniePredmetaKontrolyaID));
		КонецЕсли;
		
	КонецЕсли;
	
	DataVyyavleniya = ТекущаяДатаСеанса();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ra_ZayavkaNaOcenkuSootvetstviya") Тогда
		
		EhtapVyyavleniya				= Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.ОценкаСоответствия;
		VidObektaNesootvetstviya		= Перечисления.ra_VidyPredmetovNesootvetstviya.Oborudovanie;
		Proekt 							= ДанныеЗаполнения.Proekt;
		VyyavivshayaOrganizaciya 		= ДанныеЗаполнения.Zayavitel;
		ZayavkaNaOcenkuSootvetstviya	= ДанныеЗаполнения.Ссылка;
		ZavodskojNomerOborudovaniya 	= ДанныеЗаполнения.SerijnyjNomer;
		Sertifikat 						= ДанныеЗаполнения.NomerSertifikata;
		PodrobnoeOpisanie 				= ДанныеЗаполнения.RezultatProvedeniyaOpisanie;
		NaimenovanieOborudovaniya		= ДанныеЗаполнения.InformaciyaObObekteOcenkiSootvetstviya;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ra_Signal") Тогда
		
		// ТСК Близнюк С.И.; 06.12.2018; task#1993{
		СообщениеИсключения = "";
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "EhtapVyyavleniya,VidObektaNesootvetstviya,PodrobnoeOpisanie,MestoViyavleniya");
		Если НЕ ЗначениеЗаполнено(СтруктураРеквизитов.EhtapVyyavleniya) Тогда
			СообщениеИсключения = НСтр("ru = 'Не заполнен этап выявления несоответствия'; en = 'Missing Process stage mismatches'");
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтруктураРеквизитов.VidObektaNesootvetstviya) Тогда
			СообщениеИсключения = СообщениеИсключения + ?(СообщениеИсключения = "", "", Символы.ПС) + НСтр("ru = 'Не заполнен вид объекта несоответствия'; en = 'Missing Nonconformity object kind'");
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтруктураРеквизитов.VidObektaNesootvetstviya) Тогда
			ВызватьИсключение СообщениеИсключения;
		КонецЕсли;
		EhtapVyyavleniya			= СтруктураРеквизитов.EhtapVyyavleniya;
		VidObektaNesootvetstviya 	= СтруктураРеквизитов.VidObektaNesootvetstviya;
		// ТСК Близнюк С.И.; 06.12.2018; task#1993}
		PodrobnoeOpisanie = СтруктураРеквизитов.PodrobnoeOpisanie;
		MestoVyyavleniyaNS = СтруктураРеквизитов.MestoViyavleniya;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ra_ZayavkaNaKontrolnuyuOperaciyu") Тогда
		
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.Ссылка КАК ZayavkaNaKontrolnuyuOperaciyu,
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.Proekt КАК Proekt,
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.Ploshchadka КАК Ploshchadka,
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.Obekt КАК Obekt,
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.EhtapVyyavleniya КАК EhtapVyyavleniya,
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.VidKontrolnoyOperacii КАК VidKontrolnoyOperacii,
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.VidObektaKontrolya КАК VidObektaNesootvetstviya,
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.DataPredyavleniyaNaKontrol КАК DataVyyavleniya,
		|	ВЫБОР
		|		КОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.OrganizaciyaKontroler = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|			ТОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.OrganizaciyaZayavitel
		|		ИНАЧЕ ra_ZayavkaNaKontrolnuyuOperaciyu.OrganizaciyaKontroler
		|	КОНЕЦ КАК VyyavivshayaOrganizaciya,
		|	ВЫБОР
		|		КОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.PodrazdelenieKontroler = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
		|			ТОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.PodrazdelenieZayavitel
		|		ИНАЧЕ ra_ZayavkaNaKontrolnuyuOperaciyu.PodrazdelenieKontroler
		|	КОНЕЦ КАК VyyavivsheePodrazdelenie,
		|	ВЫБОР
		|		КОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.Kontroler = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|			ТОГДА ra_ZayavkaNaKontrolnuyuOperaciyu.Zayavitel
		|		ИНАЧЕ ra_ZayavkaNaKontrolnuyuOperaciyu.Kontroler
		|	КОНЕЦ КАК VyyavivsheeLico,
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.ZdanieSooruzhenie КАК ZdanieSooruzhenie,
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.MestoVyyavleniya КАК MestoVyyavleniyaNS,
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
		|	ra_OpisaniePredmetaKontrolya.KlassBezopasnosti КАК KlassBezopasnosti
		|ИЗ
		|	Документ.ra_ZayavkaNaKontrolnuyuOperaciyu КАК ra_ZayavkaNaKontrolnuyuOperaciyu
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ra_OpisaniePredmetaKontrolya КАК ra_OpisaniePredmetaKontrolya
		|		ПО ra_ZayavkaNaKontrolnuyuOperaciyu.Ссылка = ra_OpisaniePredmetaKontrolya.ZayavkaNaKontrolnuyuOperaciyu
		|ГДЕ
		|	ra_ZayavkaNaKontrolnuyuOperaciyu.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// ТСК Близнюк С.И.; 07.11.2018; task#1698{
	Если ЗначениеЗаполнено(ID) Тогда
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
	КонецЕсли;
	// ТСК Близнюк С.И.; 07.11.2018; task#1698}
	
	Документы.ra_Nesootvetstvie.АктуализироватьМассивОбязательныхРеквизитов(ПроверяемыеРеквизиты, ЭтотОбъект);
	
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("NomerPlanaKachestva"));
	
	Если VidObektaNesootvetstviya = Перечисления.ra_VidyPredmetovNesootvetstviya.TekhnologicheskayaSistema
		ИЛИ VidObektaNesootvetstviya = Перечисления.ra_VidyPredmetovNesootvetstviya.Oborudovanie Тогда
		
		КлассыБезопасности = Перечисления.ra_KlassyBezopasnosti; 
		КлассБезопасности123 = KlassBezopasnosti = КлассыБезопасности.Klass1
		ИЛИ KlassBezopasnosti = КлассыБезопасности.Klass2
		ИЛИ KlassBezopasnosti = КлассыБезопасности.Klass3;
		
		Если КлассБезопасности123 Тогда
			Если НЕ ЗначениеЗаполнено(NomerPlanaKachestva) Тогда
				ТекстОшибки = НСтр("ru = 'Поле ""Номер плана качества"" не заполнено'; en = 'The field ""Quality plan number"" is not filled'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект,,, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ДополнительныеСвойства.Вставить("ВремяНачала", ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени());
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	Если Не ЗначениеЗаполнено(KlassifikatorMTRiO) И ЗначениеЗаполнено(NaimenovanieOborudovaniya) Тогда
		KlassifikatorMTRiO = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(NaimenovanieOborudovaniya, "KlassifikatorMTR");
	КонецЕсли;
	
	ра_ОбщегоНазначения.ДокументыКачестваПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;
	
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		
		Если VidObektaNesootvetstviya = Перечисления.ra_VidyPredmetovNesootvetstviya.Oborudovanie Тогда
		
			НовыйДокумент = Документы.ra_VremennyeSderzhivayushchieDejstviyaIKorrekciya.СоздатьДокумент();
			НовыйДокумент.Заполнить(Ссылка);
			НовыйДокумент.Дата = ТекущаяДатаСеанса();
			НовыйДокумент.VidVremennyhSderzhivayushchihDejstvijIKorrekcij = Справочники.ra_VidyPoruchenij.ПроверкаЗапасов;
			НовыйДокумент.Opisanie = НСтр("ru = 'Проверить запас аналогичной продукции, находящейся на складах, в производстве и в пути.';
				|en = 'Check of the similar products in stock, production and transportation.'");
			НовыйДокумент.Записать();
			
			НовыйДокумент = Документы.ra_VremennyeSderzhivayushchieDejstviyaIKorrekciya.СоздатьДокумент();
			НовыйДокумент.Заполнить(Ссылка);
			НовыйДокумент.Дата = ТекущаяДатаСеанса();
			НовыйДокумент.VidVremennyhSderzhivayushchihDejstvijIKorrekcij = Справочники.ra_VidyPoruchenij.ИнформированиеЗаинтересованныхСторон;
			НовыйДокумент.Opisanie = НСтр("ru = 'Оповестить заказчиков о необходимости проверки аналогичной отгруженной продукции, в т.ч. находящейся в эксплуатации.';
				|en = 'Inform customers about the need to check shipped similar products, including in service.'");
			НовыйДокумент.Записать();
			
		КонецЕсли;
		
		Делопроизводство.ЗаписатьСостояниеДокумента(
			Ссылка,
			ТекущаяДатаСеанса(),
			Перечисления.СостоянияДокументов.Зарегистрирован,
			ПользователиКлиентСервер.ТекущийПользователь());
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("Cancellation") И ДополнительныеСвойства.Cancellation Тогда
		
		ПараметрыПроверки = Новый Структура("ra_Uvedomlenie,ra_AktObUstraneniiNesootvetstviya",
			Перечисления.СостоянияДокументов.ra_Принято, Перечисления.СостоянияДокументов.ra_Утвержден);
		
		РезультатыПроверки = Документы.ra_Nesootvetstvie.ПроверитьНаличиеПроизводныхДокументов(Ссылка,
			ПараметрыПроверки);
			
		Если РезультатыПроверки.Свойство("ra_AktObUstraneniiNesootvetstviya") И РезультатыПроверки.ra_AktObUstraneniiNesootvetstviya Тогда
			ВызватьИсключение НСтр("ru = 'Акт об устранении уже утвержден. Аннулирование невозможно.';
					|en = 'Nonconformity elimination act has already been approved. Cancellation is not possible.'");
		КонецЕсли;
				
		Делопроизводство.ЗаписатьСостояниеДокумента(
			Ссылка,
			ТекущаяДатаСеанса(),
			Перечисления.СостоянияДокументов.ra_Аннулирован,
			ПользователиКлиентСервер.ТекущийПользователь());
						
		Если РезультатыПроверки.Свойство("ra_Uvedomlenie") И РезультатыПроверки.ra_Uvedomlenie Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента);
		КонецЕсли;
		
		// ТСК Близнюк С.И.; 26.11.2018; task#1869{
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ra_Uvedomlenie.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТ_Документы
		|ИЗ
		|	Документ.ra_Uvedomlenie КАК ra_Uvedomlenie
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийДокументов.СрезПоследних КАК ИсторияСостоянийДокументов
		|		ПО ra_Uvedomlenie.Ссылка = ИсторияСостоянийДокументов.Документ
		|ГДЕ
		|	ЕСТЬNULL(ИсторияСостоянийДокументов.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.Исполнен), ИСТИНА)
		|	И ЕСТЬNULL(ИсторияСостоянийДокументов.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.ra_Аннулирован), ИСТИНА)
		|	И НЕ ra_Uvedomlenie.ПометкаУдаления
		|	И ra_Uvedomlenie.Nesootvetstvie = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ra_OtchetONesootvetstviiCHast1.Ссылка
		|ИЗ
		|	Документ.ra_OtchetONesootvetstviiCHast1 КАК ra_OtchetONesootvetstviiCHast1
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийДокументов.СрезПоследних КАК ИсторияСостоянийДокументов
		|		ПО ra_OtchetONesootvetstviiCHast1.Ссылка = ИсторияСостоянийДокументов.Документ
		|ГДЕ
		|	ЕСТЬNULL(ИсторияСостоянийДокументов.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.Исполнен), ИСТИНА)
		|	И ЕСТЬNULL(ИсторияСостоянийДокументов.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.ra_Аннулирован), ИСТИНА)
		|	И НЕ ra_OtchetONesootvetstviiCHast1.ПометкаУдаления
		|	И ra_OtchetONesootvetstviiCHast1.Nesootvetstvie = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ra_AktObUstraneniiNesootvetstviya.Ссылка
		|ИЗ
		|	Документ.ra_AktObUstraneniiNesootvetstviya КАК ra_AktObUstraneniiNesootvetstviya
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийДокументов.СрезПоследних КАК ИсторияСостоянийДокументов
		|		ПО ra_AktObUstraneniiNesootvetstviya.Ссылка = ИсторияСостоянийДокументов.Документ
		|ГДЕ
		|	ЕСТЬNULL(ИсторияСостоянийДокументов.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.Исполнен), ИСТИНА)
		|	И ЕСТЬNULL(ИсторияСостоянийДокументов.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.ra_Аннулирован), ИСТИНА)
		|	И НЕ ra_AktObUstraneniiNesootvetstviya.ПометкаУдаления
		|	И ra_AktObUstraneniiNesootvetstviya.Nesootvetstvie = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ra_Nesootvetstvie.Ссылка
		|ИЗ
		|	Документ.ra_Nesootvetstvie КАК ra_Nesootvetstvie
		|ГДЕ
		|	ra_Nesootvetstvie.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА БизнесПроцессОзнакомлениеПредметы.Ссылка.ВедущаяЗадача = ЗНАЧЕНИЕ(Задача.ЗадачаИсполнителя.ПустаяСсылка)
		|			ТОГДА БизнесПроцессОзнакомлениеПредметы.Ссылка
		|		ИНАЧЕ БизнесПроцессОзнакомлениеПредметы.Ссылка.ВедущаяЗадача.БизнесПроцесс
		|	КОНЕЦ КАК БизнесПроцесс
		|ИЗ
		|	БизнесПроцесс.Ознакомление.Предметы КАК БизнесПроцессОзнакомлениеПредметы
		|ГДЕ
		|	БизнесПроцессОзнакомлениеПредметы.Ссылка.Стартован
		|	И НЕ БизнесПроцессОзнакомлениеПредметы.Ссылка.Завершен
		|	И БизнесПроцессОзнакомлениеПредметы.Предмет В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ВТ_Документы.Ссылка
		|			ИЗ
		|				ВТ_Документы)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА БизнесПроцессСогласованиеПредметы.Ссылка.ВедущаяЗадача = ЗНАЧЕНИЕ(Задача.ЗадачаИсполнителя.ПустаяСсылка)
		|			ТОГДА БизнесПроцессСогласованиеПредметы.Ссылка
		|		ИНАЧЕ БизнесПроцессСогласованиеПредметы.Ссылка.ВедущаяЗадача.БизнесПроцесс
		|	КОНЕЦ
		|ИЗ
		|	БизнесПроцесс.Согласование.Предметы КАК БизнесПроцессСогласованиеПредметы
		|ГДЕ
		|	БизнесПроцессСогласованиеПредметы.Ссылка.Стартован
		|	И НЕ БизнесПроцессСогласованиеПредметы.Ссылка.Завершен
		|	И БизнесПроцессСогласованиеПредметы.Предмет В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ВТ_Документы.Ссылка
		|			ИЗ
		|				ВТ_Документы)";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		МассивБизнесПроцессов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("БизнесПроцесс");
		
		Для Каждого БизнесПроцесс Из МассивБизнесПроцессов Цикл
			БизнесПроцессыИЗадачиВызовСервера.ПрерватьБизнесПроцесс(БизнесПроцесс, СтрШаблон("Отмена документа %1", Ссылка));
		КонецЦикла;
		// ТСК Близнюк С.И.; 26.11.2018; task#1869}
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Если ЗначениеЗаполнено(ID) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора) Экспорт
	
	Документы.ra_Nesootvetstvie.ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДаннымПользователя()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", VyyavivsheeLico);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	ra_DostupnyeProekty.Proekt КАК Проект
	|ИЗ
	|	РегистрСведений.ra_DostupnyeProekty КАК ra_DostupnyeProekty
	|ГДЕ
	|	ra_DostupnyeProekty.Polzovatel = &Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	ra_DostupnyePloshchadki.Ploshchadka КАК Площадка
	|ИЗ
	|	РегистрСведений.ra_DostupnyePloshchadki КАК ra_DostupnyePloshchadki
	|ГДЕ
	|	ra_DostupnyePloshchadki.Polzovatel = &Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Пользователи.ра_Организация КАК VyyavivshayaOrganizaciya,
	|	Пользователи.Подразделение КАК VyyavivsheePodrazdelenie
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Ссылка = &Пользователь";
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Proekt = Выборка.Проект;
	КонецЕсли;
	
	Выборка = РезультатЗапроса[1].Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Ploshchadka = Выборка.Площадка;
	КонецЕсли;
	
	Выборка = РезультатЗапроса[2].Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
