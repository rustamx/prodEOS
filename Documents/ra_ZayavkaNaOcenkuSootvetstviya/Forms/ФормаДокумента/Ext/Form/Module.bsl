
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаПечать);
	// Конец СтандартныеПодсистемы.Печать
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТолькоЧтоСозданныйДокумент = Истина;
	Если ТолькоЧтоСозданныйДокумент И БылПоказанДиалогИнтерактивногоЗапускаПроцесса <> Истина Тогда
		ИнтерактивныйЗапускБизнесПроцессовКлиент.ВыполнитьИнтерактивныйЗапускБизнесПроцесса(
			ШаблоныДляАвтоЗапускаЗакрытиеКарточки,
			Объект.Ссылка,
			"ЗакрытиеКарточки",
			ЭтаФорма,
			Отказ,
			Истина);
	КонецЕсли;
	
	ОбщегоНазначенияДокументооборотКлиент.ВставитьВОписаниеОповещенияОЗакрытииСсылкуНаОбъект(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Шаблоны автозапуска
	ЗаполнитьШаблоныДляАвтоЗапуска();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// ТСК Ткаченко И.Л.; 15.08.2018; task#989;task#1011;task#1021{
	ПолеДоступно = Объект.InformaciyaOPolnotePredstavlennyhDokumentov = ПредопределенноеЗначение("Перечисление.ra_VidyInformaciiOPolnotePredostavlennyhDokumentov.Inoe")
		ИЛИ Объект.InformaciyaOPravilnostiIPolnotePodtverzhdennyhHarakteristik = ПредопределенноеЗначение("Перечисление.ra_VidyInformaciiOPravilnostiIPolnotyPodtverzhdennyhHarakteristik.Inoe");
		
	Элементы.KommentarijKInformacii.Видимость = ПолеДоступно;
	Элементы.ИмпортнаяПродукция.Видимость = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.ReshenieOPrimeneniiImportnojProdukcii");
	Элементы.Приемка.Видимость			 = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.Priemka");
	Элементы.АттестационныеИспытания.Видимость = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.AttestacionnyeIspytaniya");
	Элементы.Регистрация.Видимость		 = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.Registraciya");
	Элементы.ЭкспертизаТД.Видимость		 = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.EkspertizaTD");
	Элементы.ПорядокОбязательнойСертификации.Видимость  = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.PoryadokObyazatelnojSertifikacii");
	Элементы.ИнспекционныйКонтроль.Видимость 			= Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol");
	Элементы.ДополнительнаяИнформация.Видимость 		= Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol");
	Элементы.DataZayavki.Видимость				 = Объект.FormaOS <> ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol");
	Элементы.DataRegistracii.Видимость				 = Объект.FormaOS <> ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol");
	
	УстановитьВидимостьПоВидуИспытаний(ЭтаФорма);
	УстановитьВидимостьПоСхемеСертификации(ЭтаФорма);
	// ТСК Ткаченко И.Л.; 15.08.2018; task#989;task#1011;task#1021}

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// ТСК Ткаченко И.Л.; 15.08.2018; task#989;task#1011;task#1021{
&НаКлиенте
Процедура InformaciyaOPravilnostiIPolnotePodtverzhdennyhHarakteristik1ПриИзменении(Элемент)
	
	ПолеДоступно = Объект.InformaciyaOPolnotePredstavlennyhDokumentov = ПредопределенноеЗначение("Перечисление.ra_VidyInformaciiOPolnotePredostavlennyhDokumentov.Inoe")
		ИЛИ Объект.InformaciyaOPravilnostiIPolnotePodtverzhdennyhHarakteristik = ПредопределенноеЗначение("Перечисление.ra_VidyInformaciiOPravilnostiIPolnotyPodtverzhdennyhHarakteristik.Inoe");
		
	Элементы.KommentarijKInformacii.Видимость = ПолеДоступно;
	
КонецПроцедуры

&НаКлиенте
Процедура InformaciyaOPolnotePredstavlennyhDokumentov1ПриИзменении(Элемент)
	
	ПолеДоступно = Объект.InformaciyaOPolnotePredstavlennyhDokumentov = ПредопределенноеЗначение("Перечисление.ra_VidyInformaciiOPolnotePredostavlennyhDokumentov.Inoe")
		ИЛИ Объект.InformaciyaOPravilnostiIPolnotePodtverzhdennyhHarakteristik = ПредопределенноеЗначение("Перечисление.ra_VidyInformaciiOPravilnostiIPolnotyPodtverzhdennyhHarakteristik.Inoe");
		
	Элементы.KommentarijKInformacii.Видимость = ПолеДоступно;

КонецПроцедуры

&НаКлиенте
Процедура FormaOSПриИзменении(Элемент)
	
	Элементы.ИмпортнаяПродукция.Видимость		 = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.ReshenieOPrimeneniiImportnojProdukcii");
	Элементы.Приемка.Видимость					 = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.Priemka");
	Элементы.АттестационныеИспытания.Видимость	 = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.AttestacionnyeIspytaniya");
	Элементы.Регистрация.Видимость				 = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.Registraciya");
	Элементы.ЭкспертизаТД.Видимость				 = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.EkspertizaTD");
	Элементы.ПорядокОбязательнойСертификации.Видимость  = Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.PoryadokObyazatelnojSertifikacii");
	Элементы.ИнспекционныйКонтроль.Видимость 			= Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol");
	Элементы.ДополнительнаяИнформация.Видимость 		= Объект.FormaOS = ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol");
	Элементы.DataZayavki.Видимость				 = Объект.FormaOS <> ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol");
	Элементы.DataRegistracii.Видимость				 = Объект.FormaOS <> ПредопределенноеЗначение("Перечисление.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol");
	
КонецПроцедуры

&НаКлиенте
Процедура VidIspytanijПриИзменении(Элемент)

	УстановитьВидимостьПоВидуИспытаний(ЭтаФорма)
		
КонецПроцедуры

&НаКлиенте
Процедура SkhemaSertifikacii1ПриИзменении(Элемент)
	
	 УстановитьВидимостьПоСхемеСертификации(ЭтаФорма)
	
КонецПроцедуры

// ТСК Ткаченко И.Л.; 15.08.2018; task#989;task#1011;task#1021}

// ТСК Близнюк С.И.; 13.09.2018; task#470{
&НаКлиенте
Процедура DogovorPostavkiПриИзменении(Элемент)
	
	Объект.DataZayavki = ПолучитьДатуЗаявкиПоДоговору(Объект.DogovorPostavki);

КонецПроцедуры
// ТСК Близнюк С.И.; 13.09.2018; task#470}

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОзнакомления(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Ознакомление", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьШаблоныДляАвтоЗапуска()
	
	ШаблоныДляАвтоЗапускаЗакрытиеКарточки = ИнтерактивныйЗапускБизнесПроцессов.ПолучитьШаблоныДляАвтоЗапуска(
		Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданногоВнутреннегоДокумента,
		Объект.ВидДокумента, Справочники.Организации.ПустаяСсылка(), Объект.Ссылка);
	ШаблоныДляАвтоЗапускаРегистрация = ИнтерактивныйЗапускБизнесПроцессов.ПолучитьШаблоныДляАвтоЗапуска(
		Перечисления.ВидыИнтерактивныхДействий.ИнтерактивнаяРегистрацияВнутреннегоДокумента,
		Объект.ВидДокумента, Справочники.Организации.ПустаяСсылка(), Объект.Ссылка);
	
КонецПроцедуры

// ТСК Ткаченко И.Л.; 16.08.2018; task#1011;task#1021{
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПоВидуИспытаний(Форма)
	
	Модель1 = Форма.Объект.VidIspytanij = ПредопределенноеЗначение("Перечисление.ra_VidyIspytanij.Priemochnye")
		ИЛИ Форма.Объект.VidIspytanij = ПредопределенноеЗначение("Перечисление.ra_VidyIspytanij.Kvalifikacionnye")
		ИЛИ Форма.Объект.VidIspytanij = ПредопределенноеЗначение("Перечисление.ra_VidyIspytanij.Tipovye")
		ИЛИ Форма.Объект.VidIspytanij = ПредопределенноеЗначение("Перечисление.ra_VidyIspytanij.Periodicheskie");
		
	Модель2 = Форма.Объект.VidIspytanij = ПредопределенноеЗначение("Перечисление.ra_VidyIspytanij.PredvaritelnyeKompleksnyeAvtonomnye");
	Модель3 = Форма.Объект.VidIspytanij = ПредопределенноеЗначение("Перечисление.ra_VidyIspytanij.Attestacionnye");
	
	Форма.Элементы.ObektOcenkiSootvetstviyaProdukciyaTests.Видимость = Модель2;
	
	Форма.Элементы.ObektOcenkiSootvetstviyaObektAttestacionnyhIspytanij.Видимость	 = Модель3;
	//Форма.Элементы.OpisanieObektaAttestacii.Видимость								 = Модель3;
	Форма.Элементы.InformaciyaObObekteOcenkiSootvetstviya.Видимость				 = Модель3;
	Форма.Элементы.NomerDokumentaTsets.Видимость									 = Модель3;
	Форма.Элементы.ResheniePoZayavkeOpisanieTsets.Видимость						 = Модель3;
	
	Форма.Элементы.PrikazIliDokumentOsnovanie.Видимость = Модель1 ИЛИ Модель2;
	Форма.Элементы.VidProdukciiVSootvetstviiSNP_071_18Tests.Видимость = Модель1 ИЛИ Модель2;
	Форма.Элементы.KodOKPD2Tests.Видимость						 = Модель1 ИЛИ Модель2;
	Форма.Элементы.GID_Tests.Видимость							 = Модель1 ИЛИ Модель2;
	Форма.Элементы.KKS_Tests.Видимость							 = Модель1 ИЛИ Модель2;
	Форма.Элементы.SeriynieNomeraTests.Видимость					 = Модель1 ИЛИ Модель2;  
	Форма.Элементы.NomerResheniyaORegistracii.Видимость			 = Модель1 ИЛИ Модель2;
	Форма.Элементы.DataUtverzhdeniyaAkta.Видимость				 = Модель1 ИЛИ Модель2;
	Форма.Элементы.KommentarijKRezultatamIspytanij.Видимость  	 = Модель1 ИЛИ Модель2;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПоСхемеСертификации(Форма)
	
	Форма.Элементы.AnalizSostoyaniyaProizvodstvaProizveden1.Видимость = Форма.Объект.SkhemaSertifikacii = ПредопределенноеЗначение("Перечисление.ra_SkhemySertifikacii.C4_IspytaniyaObrazcovProdukcii");
	Форма.Элементы.InformaciyaORezultatahAnalizaProizvodstva1.Видимость = Форма.Объект.SkhemaSertifikacii = ПредопределенноеЗначение("Перечисление.ra_SkhemySertifikacii.C4_IspytaniyaObrazcovProdukcii");
	
	Форма.Элементы.SertifikaciyaSMKProvedena1.Видимость = Форма.Объект.SkhemaSertifikacii = ПредопределенноеЗначение("Перечисление.ra_SkhemySertifikacii.C5_IspytaniyaObrazcovProdukcii");
	Форма.Элементы.InformaciyaOSertifikaciiSMK1.Видимость = Форма.Объект.SkhemaSertifikacii = ПредопределенноеЗначение("Перечисление.ra_SkhemySertifikacii.C5_IspytaniyaObrazcovProdukcii");
	
	ОтображатьПериод = Форма.Объект.SkhemaSertifikacii <> ПредопределенноеЗначение("Перечисление.ra_SkhemySertifikacii.C6_IspytaniyaPartii")
		И Форма.Объект.SkhemaSertifikacii <> ПредопределенноеЗначение("Перечисление.ra_SkhemySertifikacii.C7_IspytanieKazhdogoObrazca");
		
	Форма.Элементы.SrokSertificataPo.Видимость = ОтображатьПериод;
	Форма.Элементы.SrokSertificataS.Заголовок = ?(ОтображатьПериод,НСтр("ru = 'Срок действия c'; en = 'Begin of validity period'"),НСтр("ru = 'Дата выдачи'; en = 'Date of issue'"));	
	
	Форма.Элементы.ReshenieOrganaPoSertifikacii.Видимость = Форма.Объект.SkhemaSertifikacii = ПредопределенноеЗначение("Перечисление.ra_SkhemySertifikacii.C3_IspytaniyaObrazcovProdukcii");
	Форма.Элементы.OtkazeVVydache.Видимость = Форма.Объект.SkhemaSertifikacii = ПредопределенноеЗначение("Перечисление.ra_SkhemySertifikacii.C3_IspytaniyaObrazcovProdukcii");
	Форма.Элементы.NomerResheniyaOVydacheSertifikata.Видимость = Форма.Объект.SkhemaSertifikacii = ПредопределенноеЗначение("Перечисление.ra_SkhemySertifikacii.C3_IspytaniyaObrazcovProdukcii");
		
КонецПроцедуры

// ТСК Ткаченко И.Л.; 16.08.2018; task#1011;task#1021}

// ТСК Близнюк С.И.; 13.09.2018; task#470{
&НаСервереБезКонтекста
Функция ПолучитьДатуЗаявкиПоДоговору(DogovorPostavki)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(DogovorPostavki, "DataPodpisaniya");

КонецФункции
// ТСК Близнюк С.И.; 13.09.2018; task#470}

#КонецОбласти
