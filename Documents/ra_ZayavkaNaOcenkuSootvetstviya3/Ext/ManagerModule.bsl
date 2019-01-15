#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура АктуализироватьМассивОбязательныхРеквизитов(МассивРеквизитов, ДокументОбъект) Экспорт
	
	МассивРеквизитов.Очистить();
	
	//РезультатСоответствует = ДокументОбъект.RezultatProvedeniya = Перечисления.ra_SootvetstvuetIliNet.Sootvetstvuet;
	//
	//ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	//СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущийПользователь, "ра_Организация.ра_СпециализированнаяОрганизация,ра_Организация.ра_ЭксплуатирующаяОрганизация");
	//ЭтоСпециализированнаяОрганизация = СтруктураРеквизитов["ра_Организацияра_СпециализированнаяОрганизация"];
	//ЭтоЭксплуатирующаяОрганизация = СтруктураРеквизитов["ра_Организацияра_ЭксплуатирующаяОрганизация"];
	//
	//Если ДокументОбъект.Status = Перечисления.ra_StatusyZayavokNaOcenkuSootvetstviya.Zaregistrirovana Тогда
	//	
	//	//"Дата заявки" и "Дата регистрации" всегда обязательны для заполнения
	//	МассивРеквизитов.Добавить("DataZayavki");
	//			
	//	Если ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol Тогда
	//		
	//		МассивРеквизитов.Добавить("DataRegistracii");
	//		МассивРеквизитов.Добавить("DataPismaOProvedeniiIK");
	//		МассивРеквизитов.Добавить("NomerPismaOProvedeniiIK");
	//		МассивРеквизитов.Добавить("NomerSertifikata");
	//		МассивРеквизитов.Добавить("SkhemaSertifikacii");
	//		МассивРеквизитов.Добавить("DataProgrammy");
	//		МассивРеквизитов.Добавить("NomerProgrammy");
	//		
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.AttestacionnyeIspytaniya Тогда
	//		
	//		МассивРеквизитов.Добавить("Zayavitel");
	//		МассивРеквизитов.Добавить("Ispolnitel");
	//		
	//		Если ДокументОбъект.VidIspytanij = Перечисления.ra_VidyIspytanij.Attestacionnye Тогда
	//			МассивРеквизитов.Добавить("DataRegistracii");
	//			МассивРеквизитов.Добавить("ObektOcenkiSootvetstviyaObektAttestacionnyhIspytanij");
	//			МассивРеквизитов.Добавить("InformaciyaObObekteOcenkiSootvetstviya");
	//		Иначе
	//			МассивРеквизитов.Добавить("PrikazIliDokumentOsnovanie");
	//			МассивРеквизитов.Добавить("ObektOcenkiSootvetstviyaProdukciya");
	//			МассивРеквизитов.Добавить("KodOKPD2");
	//			МассивРеквизитов.Добавить("KKS_Certifikaciya");
	//			МассивРеквизитов.Добавить("VidProdukciiVSootvetstviiSNP_071_18");
	//			МассивРеквизитов.Добавить("PrikazIliDokumentOsnovanie");
	//											
	//			Если ДокументОбъект.VidIspytanij = Перечисления.ra_VidyIspytanij.PredvaritelnyeKompleksnyeAvtonomnye Тогда
	//				МассивРеквизитов.Добавить("ElementyObektaOcenkiSootvetstviya");
	//			КонецЕсли;
	//		КонецЕсли;
	//		
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.PoryadokObyazatelnojSertifikacii Тогда
	//		
	//		МассивРеквизитов.Добавить("DataRegistracii");
	//		МассивРеквизитов.Добавить("Zayavitel");
	//		МассивРеквизитов.Добавить("Ispolnitel");
	//		МассивРеквизитов.Добавить("Izgotovitel");
	//		МассивРеквизитов.Добавить("KodOKPD2");
	//		МассивРеквизитов.Добавить("PerechenProdukciiPo277Prikazu");
	//		МассивРеквизитов.Добавить("VidProdukciiVSootvetstviiSNP_071_18");
	//		МассивРеквизитов.Добавить("DataPrinyatiyaResheniya");
	//		МассивРеквизитов.Добавить("NomerResheniyaPoZayavke");
	//		МассивРеквизитов.Добавить("ResheniePoZayavkeOpisanie");
	//		МассивРеквизитов.Добавить("ObektOcenkiSootvetstviyaProdukciya_Certifikaciya");
	//		МассивРеквизитов.Добавить("PredlagaemayaZayavitelemSkhemaSertifikacii");
	//		
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.Priemka Тогда 
	//		
	//		МассивРеквизитов.Добавить("DataRegistracii");
	//		МассивРеквизитов.Добавить("Zayavitel");
	//		МассивРеквизитов.Добавить("Ispolnitel");
	//		МассивРеквизитов.Добавить("ObektOcenkiSootvetstviyaProdukciya");
	//		МассивРеквизитов.Добавить("KodOKPD2");
	//		МассивРеквизитов.Добавить("VidProdukciiVSootvetstviiSNP_071_18");
	//		МассивРеквизитов.Добавить("NomerZaprosaNaProvedenieOcenkiSootvetstviya");
	//		МассивРеквизитов.Добавить("KKS_Certifikaciya");
	//														
	//		Если ЭтоСпециализированнаяОрганизация Тогда
	//			МассивРеквизитов.Добавить("EkspluatiruyushchayaOrganizaciya");
	//			МассивРеквизитов.Добавить("NomerPorucheniyaEhkspluatiruyushchejOrganizacii");
	//			Если НЕ ЭтоЭксплуатирующаяОрганизация Тогда
	//				МассивРеквизитов.Добавить("DataPorucheniyaEhkspluatiruyushchejOrganizacii");
	//			КонецЕсли;
	//		КонецЕсли;
	//					
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.Registraciya Тогда 
	//		
	//		МассивРеквизитов.Добавить("DataRegistracii");
	//		МассивРеквизитов.Добавить("Zayavitel");
	//		МассивРеквизитов.Добавить("Ispolnitel");
	//		МассивРеквизитов.Добавить("ObektOcenkiSootvetstviyaProdukciya");
	//		МассивРеквизитов.Добавить("KodOKPD2");
	//		МассивРеквизитов.Добавить("VidProdukciiVSootvetstviiSNP_071_18");
	//		МассивРеквизитов.Добавить("KKS_Certifikaciya");
	//		
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.EkspertizaTD Тогда
	//		
	//		МассивРеквизитов.Добавить("DataRegistracii");
	//		МассивРеквизитов.Добавить("Zayavitel");
	//		МассивРеквизитов.Добавить("Ispolnitel");
	//		МассивРеквизитов.Добавить("VidProdukciiPoGostu");
	//		МассивРеквизитов.Добавить("ObektyOcenkiSootvetstviyaTD");
	//		МассивРеквизитов.Добавить("KodOKPD2");
	//		МассивРеквизитов.Добавить("UpolnomochennoeLicoOtZayavitelyaNaEkspertizuTD");
	//		МассивРеквизитов.Добавить("DolzhnostUpolnomochennogoLicaOtZayavitelyaNaEkspertizuTD");
	//		МассивРеквизитов.Добавить("RukovoditelOrganizaciiZayavitelyaNaEhkspertizuTD");
	//		МассивРеквизитов.Добавить("DolzhnostRukovoditelyaOrganizaciiZayavitelyaNaEhkspretizuTD");
	//					
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.ReshenieOPrimeneniiImportnojProdukcii Тогда
	//		
	//		МассивРеквизитов.Добавить("Zayavitel");
	//		МассивРеквизитов.Добавить("Ispolnitel");
	//		МассивРеквизитов.Добавить("DogovorPostavki");
	//		МассивРеквизитов.Добавить("ObektOcenkiSootvetstviyaProdukciya");
	//		МассивРеквизитов.Добавить("KodOKPD2");
	//		МассивРеквизитов.Добавить("VidProdukciiVSootvetstviiSNP_071_18");
	//		
	//	КонецЕсли;
	//	
	//ИначеЕсли ДокументОбъект.Status = Перечисления.ra_StatusyZayavokNaOcenkuSootvetstviya.Zakryta Тогда
	//	
	//	Запрос = Новый Запрос("
	//	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//	|	Ссылка
	//	|ИЗ
	//	|	Справочник.Пользователи
	//	|ГДЕ
	//	|	НЕ ПометкаУдаления И НЕ Недействителен И ра_ОтветственныйЗаКачествоДопустивший
	//	|	И ра_Организация = &Организация");
	//	
	//	Запрос.УстановитьПараметр("Организация", ДокументОбъект.Zayavitel);
	//	РезультатЗапроса = Запрос.Выполнить();
	//							
	//	Если Не РезультатЗапроса.Пустой() И НЕ РезультатСоответствует Тогда
	//		МассивРеквизитов.Добавить("OtvetstvennyjDopustivshij");
	//	КонецЕсли;
	//			
	//	Если ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.InspekcionnyjKontrol Тогда
	//		
	//		МассивРеквизитов.Добавить("DataPrinyatiyaResheniya");
	//		МассивРеквизитов.Добавить("RezultatProvedeniya");
	//		МассивРеквизитов.Добавить("RezultatProvedeniyaInspekcionnogoKontrolya");
	//		
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.AttestacionnyeIspytaniya Тогда
	//		
	//		МассивРеквизитов.Добавить("RezultatProvedeniya");
	//		МассивРеквизитов.Добавить("StatusDokumenta");
	//					
	//		Если ДокументОбъект.VidIspytanij = Перечисления.ra_VidyIspytanij.Attestacionnye Тогда
	//			МассивРеквизитов.Добавить("DataAttestacionnogoOtcheta");
	//			МассивРеквизитов.Добавить("NomerAttestacionnogoOtcheta");
	//			Если РезультатСоответствует Тогда
	//				МассивРеквизитов.Добавить("DataVydachiSvidetelstvaObAttestacii");
	//				МассивРеквизитов.Добавить("NomerSvidetelstvaObAttestacii");
	//			КонецЕсли;
	//		Иначе
	//			МассивРеквизитов.Добавить("DataPrinyatiyaResheniya");
	//			МассивРеквизитов.Добавить("NomerAktaIspytanij");
	//			МассивРеквизитов.Добавить("DataProtokolaIspytaniy");
	//			МассивРеквизитов.Добавить("NomerProtokolaIspytaniy");
	//		КонецЕсли;
	//		
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.PoryadokObyazatelnojSertifikacii Тогда
	//					
	//		РешениеПровестиСертификацию = ДокументОбъект.ReshenieOSertifikacii = Перечисления.ra_ResheniyaOSertifikacii.ProvestiSertifikaciyu;
	//		МассивРеквизитов.Добавить("StatusDokumenta");
	//		
	//		Если РешениеПровестиСертификацию Тогда
	//		
	//			МассивРеквизитов.Добавить("RezultatProvedeniya");
	//			МассивРеквизитов.Добавить("RezultatProvedeniyaOpisanie");
	//			МассивРеквизитов.Добавить("DataZaklucheniyaOrganizaciiPoSertifikacii");
	//			МассивРеквизитов.Добавить("NomerZaklucheniya");
	//			МассивРеквизитов.Добавить("InformaciyaObEkspertahPoSertifikaciiPodgotovivshihZaklyuchenie");
	//			МассивРеквизитов.Добавить("InformaciyaOTekhnicheskihEkspertahUchastvovavshihVRabotahPoSertifikacii");
	//			МассивРеквизитов.Добавить("InformaciyaOProvedennyhSertifikacionnyhIspytaniyah");
	//			МассивРеквизитов.Добавить("InformaciyaOPriznannyhRezultatahIspytanij");
	//			МассивРеквизитов.Добавить("InformaciyaOPolnotePredstavlennyhDokumentov"); 
	//			МассивРеквизитов.Добавить("InformaciyaOPravilnostiIPolnotePodtverzhdennyhHarakteristik");
	//			МассивРеквизитов.Добавить("ReshenieOrganaPoSertifikacii");
	//			МассивРеквизитов.Добавить("DataResheniyaOVydache");
	//			МассивРеквизитов.Добавить("NomerResheniyaOVydacheSertifikata");
	//						
	//			Если РезультатСоответствует Тогда
	//				МассивРеквизитов.Добавить("NomerSertifikata");
	//				МассивРеквизитов.Добавить("SrokSertificataS");
	//			
	//				Если ДокументОбъект.SkhemaSertifikacii <> Перечисления.ra_SkhemySertifikacii.C6_IspytaniyaPartii
	//					И ДокументОбъект.SkhemaSertifikacii <> Перечисления.ra_SkhemySertifikacii.C7_IspytanieKazhdogoObrazca Тогда
	//					МассивРеквизитов.Добавить("SrokSertificataPo");
	//				КонецЕсли;
	//			КонецЕсли;
	//			
	//		КонецЕсли;
	//		
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.Priemka Тогда
	//		
	//		МассивРеквизитов.Добавить("DataPrinyatiyaResheniya");
	//		МассивРеквизитов.Добавить("NomerDokumenta");
	//					
	//		Если РезультатСоответствует Тогда
	//			МассивРеквизитов.Добавить("NomerAktaOPriemke");
	//			МассивРеквизитов.Добавить("DataAktaOPriemke");
	//			МассивРеквизитов.Добавить("SeriynieNomera");
	//		КонецЕсли;
	//					
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.Registraciya Тогда
	//		
	//		МассивРеквизитов.Добавить("RezultatProvedeniya");
	//		МассивРеквизитов.Добавить("NomerDokumenta");
	//		МассивРеквизитов.Добавить("DataPrinyatiyaResheniya");
	//		
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.EkspertizaTD Тогда
	//		
	//		МассивРеквизитов.Добавить("RezultatProvedeniya");
	//		МассивРеквизитов.Добавить("RezultatProvedeniyaOpisanie"); // ??
	//		МассивРеквизитов.Добавить("StatusDokumenta");
	//		
	//	ИначеЕсли ДокументОбъект.FormaOS = Перечисления.ra_FormyOcenkiSootvetstviya.ReshenieOPrimeneniiImportnojProdukcii Тогда
	//		
	//		МассивРеквизитов.Добавить("DataPrinyatiyaResheniya");
	//		МассивРеквизитов.Добавить("NomerResheniyaOPrimeneniiImportnojProdukcii");
	//		МассивРеквизитов.Добавить("RezultatProvedeniya");
	//		МассивРеквизитов.Добавить("RostekhnadzorSoglasoval");
	//		
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьМассивЭтапов(FormaOS) Экспорт
	
	МассивЭтапов = Новый Массив;
	
	Если FormaOS = Перечисления.ra_FormyOS.EkspertizaTD Тогда
		МассивЭтапов.Добавить("ra_EHtapPrinyatieResheniya");
		МассивЭтапов.Добавить("ra_EHtapFormirovanieZadanij");
		МассивЭтапов.Добавить("ra_EHtapVypolnenieZadanij");
		МассивЭтапов.Добавить("ra_EHtapObsuzhdeniePredvRezultatov");
		МассивЭтапов.Добавить("ra_EHtapOformlenieEhkspZaklyucheniya");
		// ТСК Тележкин И.С.; 11.01.2019; task#2458{
	ИначеЕсли FormaOS = Перечисления.ra_FormyOS.PriemochnyeIspytaniya
		ИЛИ FormaOS = Перечисления.ra_FormyOS.KvalifikacionnyeIspytaniya
		ИЛИ FormaOS = Перечисления.ra_FormyOS.PeriodicheskieIspytaniya
		ИЛИ FormaOS = Перечисления.ra_FormyOS.TipovyeIspytaniya	Тогда
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaNaznachenieKomissii");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaFormirovanieProgrammyIMetodikiIspytanij");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaProvedenieOtboraProb");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaProvedenieIspytanij");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaFormirovanieAktaIspytanij");
		// ТСК Тележкин И.С.; 11.01.2019; task#2458}
		
		// ТСК Тележкин И.С.; 11.01.2019; task#2489{
	ИначеЕсли FormaOS = Перечисления.ra_FormyOS.PredvaritelnyeKompleksnyeIspytaniya
		ИЛИ FormaOS = Перечисления.ra_FormyOS.PredvaritelnyeAvtonomnyeIspytaniya Тогда
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaNaznachenieKomissii");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaFormirovanieProgrammyIMetodikiIspytanij");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaProvedenieIspytanij");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaFormirovanieAktaIspytanij");
		// ТСК Тележкин И.С.; 11.01.2019; task#2489}
		
		// ТСК, ovsidorov 14.01.2019 11:16:42{
	ИначеЕсли FormaOS = Перечисления.ra_FormyOS.AttestacionnyeIspytaniya Тогда
		МассивЭтапов.Добавить("ra_EHtapPrinyatieResheniya");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaNaznachenieKomissii");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaFormirovanieProgrammyIMetodikiIspytanij");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaProvedenieOtboraObrazcovDlyaIspytanij");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaProvedenieIssledovanij");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaFormirovanieAttestacionnogoOtcheta");
		МассивЭтапов.Добавить("ra_EHtapOcenkiSootvetstviyaVydachaSvidetelstvaObAttestacii");
		// ТСК, ovsidorov 14.01.2019 11:16:42}
	КонецЕсли;
	
	Возврат МассивЭтапов;
	
КонецФункции

Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат БизнесСобытияВызовСервера.ШаблонПодходитДляАвтозапускаБизнесПроцессаПоДокументу(ШаблонСсылка, 
		ПредметСсылка, Подписчик, ВидСобытия, Условие);
	
КонецФункции

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати, СтруктураПараметров = Неопределено) Экспорт
	
	ра_ОбщегоНазначения.ВыполнитьЗаполнениеКомандПечатиДокументаЕОС(КомандыПечати, СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("ВидОбъекта", ОбъектДоступа.ВидДокумента);
	//Запрос.УстановитьПараметр("Подразделение1", ОбъектДоступа.PodrazdelenieKontroler);
	//Запрос.УстановитьПараметр("Подразделение2", ОбъектДоступа.PodrazdelenieZayavitel);
	//
	//Запрос.Текст =
	//"ВЫБРАТЬ
	//|	&ВидОбъекта КАК ВидДокумента,
	//|	&Подразделение1 КАК Подразделение
	//|
	//|ОБЪЕДИНИТЬ
	//|
	//|ВЫБРАТЬ
	//|	&ВидОбъекта,
	//|	&Подразделение2";
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	ОписаниеОбъекта = Новый Структура;
	//	ОписаниеОбъекта.Вставить("Ссылка", ОбъектДоступа.Ссылка);
	//	ОписаниеОбъекта.Вставить("ВидДокумента", Выборка.ВидДокумента);
	//	ОписаниеОбъекта.Вставить("Подразделение", Выборка.Подразделение);
	//	
	//	ДокументооборотПраваДоступа.ЗаполнитьДескрипторОбъектаОсновной(ОписаниеОбъекта, ТаблицаДескрипторов);
	//	
	//	// Дескриптор для локальных администраторов.
	//	Если ПолучитьФункциональнуюОпцию("ИспользоватьЛокальныхАдминистраторов") Тогда
	//		ТипыСсылокКОбработке = ДокументооборотПраваДоступаПовтИсп.ТипыСсылокИспользующиеРазрезыДоступа();
	//		Если ТипыСсылокКОбработке.Найти(ТипЗнч(ОбъектДоступа.Ссылка)) <> Неопределено Тогда
	//			ДокументооборотПраваДоступа.ЗаполнитьДескрипторОбъектаДляЛокальныхАдминистраторов(ОписаниеОбъекта, ТаблицаДескрипторов);
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;
	//
	//ДокументооборотПраваДоступа.ЗаполнитьДескрипторыОбъектаПоРабочейГруппе(ОбъектДоступа, ТаблицаДескрипторов);
	
КонецПроцедуры

// Заполняет переданный дескриптор доступа
//
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.ВидДокумента;
	ДескрипторДоступа.Подразделение = ОбъектДоступа.Подразделение;
	
КонецПроцедуры

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка,
			|ВидДокумента";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеДоступом

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора, Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Объект) = Тип("ДокументСсылка.ra_ZayavkaNaOcenkuSootvetstviya3") Тогда
		Ссылка = Объект;
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.ra_ZayavkaNaOcenkuSootvetstviya3") Тогда
		Ссылка = Объект.Ссылка;
	Иначе // объекты производных документов
		Ссылка = Объект.ZayavkaNaOcenkuSootvetstviya;
	КонецЕсли;
	
	//Если ТипЗнч(Объект) = Тип("ДокументОбъект.ra_ZayavkaNaOcenkuSootvetstviya3") И Объект.ЭтоНовый() Тогда
	//	УчастникиПроцесса = Новый Массив;
	//	УчастникиПроцесса.Добавить(Объект.Kontroler);
	//	УчастникиПроцесса.Добавить(Объект.RukovoditelKontrolera);
	//	УчастникиПроцесса.Добавить(Объект.Zayavitel);
	//Иначе
	//	Запрос = Новый Запрос;
	//	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	//	Запрос.Текст =
	//	"ВЫБРАТЬ
	//	|	ra_UchastnikiKontrolnyhOperaciy.Otvetstvennyj КАК Участник
	//	|ИЗ
	//	|	РегистрСведений.ra_UchastnikiKontrolnyhOperaciy КАК ra_UchastnikiKontrolnyhOperaciy
	//	|ГДЕ
	//	|	ra_UchastnikiKontrolnyhOperaciy.ZayavkaNaKontrolnuyuOperaciyu = &Ссылка";
	//	УчастникиПроцесса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Участник");
	//	
	//	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Kontroler,RukovoditelKontrolera,Zayavitel");
	//	УчастникиПроцесса.Добавить(РеквизитыОбъекта.Kontroler);
	//	УчастникиПроцесса.Добавить(РеквизитыОбъекта.RukovoditelKontrolera);
	//	УчастникиПроцесса.Добавить(РеквизитыОбъекта.Zayavitel);
	//КонецЕсли;
	//
	//Для каждого УчастникПроцесса Из УчастникиПроцесса Цикл
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
	//		ТаблицаНабора,
	//		УчастникПроцесса,
	//		Истина);
	//КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДескрипторыПроизводныхДокументов(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	//УстановитьПривилегированныйРежим(Истина);
	//
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("Ссылка", ОбъектДоступа.ra_ZayavkaNaOcenkuSootvetstviya3);
	//Запрос.УстановитьПараметр("ВидОбъекта", Справочники.ВидыВнутреннихДокументов.ra_ZayavkaNaOcenkuSootvetstviya3);
	//
	//Запрос.Текст =
	//"ВЫБРАТЬ
	//|	&ВидОбъекта КАК ВидДокумента,
	//|	ТаблицаДокумент.PodrazdelenieZayavitel КАК Подразделение
	//|ИЗ
	//|	Документ.ra_ZayavkaNaKontrolnuyuOperaciyu КАК ТаблицаДокумент
	//|ГДЕ
	//|	ТаблицаДокумент.Ссылка = &Ссылка
	//|
	//|ОБЪЕДИНИТЬ
	//|
	//|ВЫБРАТЬ
	//|	&ВидОбъекта,
	//|	ТаблицаДокумент.PodrazdelenieKontroler
	//|ИЗ
	//|	Документ.ra_ZayavkaNaKontrolnuyuOperaciyu КАК ТаблицаДокумент
	//|ГДЕ
	//|	ТаблицаДокумент.Ссылка = &Ссылка";
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	ОписаниеОбъекта = Новый Структура;
	//	ОписаниеОбъекта.Вставить("Ссылка", ОбъектДоступа.Ссылка);
	//	ОписаниеОбъекта.Вставить("ВидДокумента", Выборка.ВидДокумента);
	//	ОписаниеОбъекта.Вставить("Подразделение", Выборка.Подразделение);
	//	
	//	ДокументооборотПраваДоступа.ЗаполнитьДескрипторОбъектаОсновной(ОписаниеОбъекта, ТаблицаДескрипторов);
	//	
	//	// Дескриптор для локальных администраторов.
	//	Если ПолучитьФункциональнуюОпцию("ИспользоватьЛокальныхАдминистраторов") Тогда
	//		ТипыСсылокКОбработке = ДокументооборотПраваДоступаПовтИсп.ТипыСсылокИспользующиеРазрезыДоступа();
	//		Если ТипыСсылокКОбработке.Найти(ТипЗнч(ОбъектДоступа.Ссылка)) <> Неопределено Тогда
	//			ДокументооборотПраваДоступа.ЗаполнитьДескрипторОбъектаДляЛокальныхАдминистраторов(ОписаниеОбъекта, ТаблицаДескрипторов);
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;
	//
	//ДокументооборотПраваДоступа.ЗаполнитьДескрипторыОбъектаПоРабочейГруппе(ОбъектДоступа, ТаблицаДескрипторов);
	
КонецПроцедуры

Функция ПолучитьПоляДоступаПроизводногоДокумента() Экспорт
	
	Возврат "Ссылка,
			|ВидДокумента,
			|ra_ZayavkaNaOcenkuSootvetstviya3";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ИнтеграцияBitrix

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт
	
	МассивЗаголовков = Новый Массив;
	
	Возврат МассивЗаголовков;
	
КонецФункции

Функция ПолучитьМассивКолонокСписка() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ra_ZayavkaNaOcenkuSootvetstviya3;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	РеквизитыОбъекта = МетаданныеДокумента.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеДокумента.СтандартныеРеквизиты;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Дата);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Номер);
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.FormaOS);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.Zayavitel);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.Ispolnitel);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивКнопок(ДокументОбъект) Экспорт
	
	ВидФормы = "ФормаОбъекта";
	Если ТипЗнч(ДокументОбъект) = Тип("Структура") Тогда
		ВидФормы = "ФормаСписка";
	КонецЕсли;
	
	МассивКнопок = Новый Массив;
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		ИмяКнопки = "Start";
		ОписаниеКнопки = НСтр("ru = 'Начать этап'; en = 'Start stage'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		МассивКнопок.Добавить(Кнопка);
		
		ИмяКнопки = "Save";
		ОписаниеКнопки = НСтр("ru = 'Сохранить'; en = 'Save'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.Вставить("Parameters", Новый Структура("DocumentWriteMode", "Write"));
		МассивКнопок.Добавить(Кнопка);
		
		ИмяКнопки = "Complete";
		ОписаниеКнопки = НСтр("ru = 'Завершить'; en = 'Завершить'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.Вставить("Parameters", Новый Структура("DocumentWriteMode", "Posting"));
		МассивКнопок.Добавить(Кнопка);
		
	ИначеЕсли ВидФормы = "ФормаСписка" Тогда
		
	КонецЕсли;
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МассивДанных = Новый Массив;
	
	Возврат МассивДанных;
	
КонецФункции

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.Документы.ra_ZayavkaNaOcenkuSootvetstviya3;
	
	ТаблицаРеквизитов = ра_ОбменДанными.ПолучитьТаблицуРеквизитовОбъекта(ОбъектМетаданных);
	
	АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов);
	
	ТекстЗапросаВложенныеТаблицы = ПолучитьТекстЗапросаВложенныеТаблицы();
	ТекстЗапросаСоединений = ПолучитьТекстЗапросаСоединений();
	
	Запрос = ра_ОбменДанными.ПолучитьЗапрос(ТаблицаРеквизитов, ПараметрыЗапросаHTTP, ПолноеИмя, ТекстЗапросаВложенныеТаблицы, ТекстЗапросаСоединений);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
	Результат.Вставить("value", МассивДанных);
	
	НастройкаФормы = ПараметрыЗапросаHTTP.Получить("$form_settings");
	Если ЗначениеЗаполнено(НастройкаФормы) И НастройкаФормы Тогда
		МассивКолонок = ПолучитьМассивКолонокСписка();
		МассивКнопок = ПолучитьМассивКнопок(Запрос.Параметры);
		МассивФильтров = ПолучитьМассивФильтровСписка();
		Результат.Вставить("form_settings", МассивКолонок);
		Результат.Вставить("button_settings", МассивКнопок);
		Результат.Вставить("filter_settings", МассивФильтров);
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьМассивДанныхРолевойМодели(ДокументОбъект, ПараметрыФормирования = Неопределено) Экспорт
	
	Возврат Обработки.ра_ФормыБитрикс.Создать().ОписаниеФормы(ДокументОбъект.Метаданные(), ДокументОбъект);
	
КонецФункции

Процедура ЗаполнитьГлавноеМенюОбъекта(ОбъектБД, МассивПунктовМеню) Экспорт
	
	Если ТипЗнч(ОбъектБД) = Тип("ДокументОбъект.ra_ZayavkaNaOcenkuSootvetstviya3") Тогда
		ФормаОС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектБД.Ссылка,"FormaOS");	
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ОбъектБД,"ZayavkaNaOcenkuSootvetstviya") Тогда	
		ФормаОС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектБД.ZayavkaNaOcenkuSootvetstviya,"FormaOS");
	Иначе
		ФормаОС = ПредопределенноеЗначение("Перечисление.ra_FormyOS.EkspertizaTD");
	КонецЕсли;

	Если ФормаОС = ПредопределенноеЗначение("Перечисление.ra_FormyOS.EkspertizaTD") Тогда
	
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "Registration", НСтр("ru = 'РЕГИСТРАЦИЯ И АНАЛИЗ ЗАЯВКИ'; en = 'REGISTRATION AND ANALYSIS OF APPLICATION'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "DecisionMaking", НСтр("ru = 'ПРИНЯТИЕ РЕШЕНИЯ'; en = 'DECISION MAKING'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "TaskFormation", НСтр("ru = 'ФОРМИРОВАНИЕ ЗАДАНИЙ'; en = 'FORMATION OF TASKS'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "TaskExecution", НСтр("ru = 'ВЫПОЛНЕНИЕ ЗАДАНИЙ'; en = 'EXECUTION OF TASKS'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "Discussion", НСтр("ru = 'ОБСУЖДЕНИЕ ПРЕДВ. РЕЗУЛЬТАТОВ'; en = 'DISCUSSION OF PRELIMINARY RESULTS'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "ExpertOpinion", НСтр("ru = 'ОФОРМЛЕНИЕ ЭКСПЕРТНОГО ЗАКЛЮЧЕНИЯ'; en = 'REGISTRATION OF EXPERT OPINION'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "Result", НСтр("ru = 'РЕЗУЛЬТАТ'; en = 'RESULT'"), Истина, Истина));
		
	ИначеЕсли ФормаОС = ПредопределенноеЗначение("Перечисление.ra_FormyOS.AttestacionnyeIspytaniya") Тогда
		
		ДоступностьСвидетельстваОбАттестации = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	ra_EHtapOcenkiSootvetstviyaFormirovanieAttestacionnogoOtcheta.PrinyatoeReshenie КАК PrinyatoeReshenie
		               |ИЗ
		               |	Документ.ra_EHtapOcenkiSootvetstviyaFormirovanieAttestacionnogoOtcheta КАК ra_EHtapOcenkiSootvetstviyaFormirovanieAttestacionnogoOtcheta
		               |ГДЕ
		               |	ra_EHtapOcenkiSootvetstviyaFormirovanieAttestacionnogoOtcheta.ZayavkaNaOcenkuSootvetstviya = &ZayavkaNaOcenkuSootvetstviya";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда			
			ДоступностьСвидетельстваОбАттестации = Выборка.PrinyatoeReshenie;			
		КонецЕсли;
		
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "Registration", НСтр("ru = 'РЕГИСТРАЦИЯ И АНАЛИЗ ЗАЯВКИ'; en = 'REGISTRATION AND ANALYSIS OF APPLICATION'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "DecisionMaking", НСтр("ru = 'ПРИНЯТИЕ РЕШЕНИЯ'; en = 'DECISION MAKING'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "CommissionAppointment", НСтр("ru = 'НАЗНАЧЕНИЕ КОМИСИИ'; en = 'APPOINTMENT OF THE COMMISSION'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "FormationProgrammAndMethods", НСтр("ru = 'ФОРМИРОВАНИЕ ПРОГРАММЫ И МЕТОДИКИ ИСПЫТАНИЙ'; en = 'FORMATION OF THE PROGRAM AND TEST METHODS'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "SamplingForTesting", НСтр("ru = 'ПРОВЕДЕНИЕ ОТБОРА ОБРАЗЦОВ ДЛЯ ИСПЫТАНИЙ'; en = 'SAMPLING FOR TESTING'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "Researching", НСтр("ru = 'ПРОВЕДНИЕ ИССЛЕДОВАНИЙ'; en = 'RESEARCHING'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "FormationOfCertificationReport", НСтр("ru = 'ФОРМИРОВАНИЕ АТТЕСТАЦИОННОГО ОТЧЕТА'; en = 'FORMATION OF CERTIFICATION REPORT'"), Истина, Истина));
		МассивПунктовМеню.Добавить(Новый Структура("Name,Description,Availability,Visibility", "IssuanceOfCertificationCertificate", НСтр("ru = 'ВЫДАЧА СВИДЕТЕЛЬСТВА ОБ АТТЕСТАЦИИ'; en = 'ISSUANCE OF CERTIFICATION CERTIFICATE'"), ДоступностьСвидетельстваОбАттестации, Истина));
		
	КонецЕсли;
	
КонецПроцедуры

//V2

Функция ЕстьМетодДополнитьОписаниеМетаданных() Экспорт
	
	Возврат Истина;
	
КонецФункции

Процедура ДополнитьОписаниеМетаданных(ОбработкаОбъект, Данные, ПараметрыФормирования) Экспорт
	
	ОбработкаОбъект.ДобавитьИсключения("Ссылка,ПометкаУдаления,Проведен");
	
	Если Данные.FormaOS = Перечисления.ra_FormyOS.EkspertizaTD Тогда
		
		ОбработкаОбъект.УстановитьВидимость(
			"DataRegistracii,
			|DataZayavki,
			|GID_MTRIO,
			|KKS,
			|KlassBezopasnosti,
			|KodOKPD2,
			|ObektOcenkiSootvetstviyaProdukciya,
			|ObektOcenkiSootvetstviyaTekhnicheskayaDokumentaciya,
			|Razrabotchik,
			|NomerRegistraciiZayavki,
			|VhodyashchijNomer,
			|VidProdukciiPoGostu,
			|VidProdukciiVSootvetstviiSNP_071_18,
			|Zayavitel,
			|ZayavkaNaEHkspertizu", Истина);
		
		ОбработкаОбъект.УстановитьДоступность(
			"DataRegistracii,
			|DataZayavki,
			|GID_MTRIO,
			|KKS,
			|KlassBezopasnosti,
			|KodOKPD2,
			|ObektOcenkiSootvetstviyaProdukciya,
			|ObektOcenkiSootvetstviyaTekhnicheskayaDokumentaciya,
			|Razrabotchik,
			|NomerRegistraciiZayavki,
			|VhodyashchijNomer,
			|VidProdukciiPoGostu,
			|VidProdukciiVSootvetstviiSNP_071_18,
			|Zayavitel,
			|ZayavkaNaEHkspertizu", Истина);
		
		// ТСК Тележкин И.С.; 11.01.2019; task#2458{
	ИначеЕсли Данные.FormaOS = Перечисления.ra_FormyOS.PriemochnyeIspytaniya
		ИЛИ Данные.FormaOS = Перечисления.ra_FormyOS.KvalifikacionnyeIspytaniya
		ИЛИ Данные.FormaOS = Перечисления.ra_FormyOS.PeriodicheskieIspytaniya
		ИЛИ Данные.FormaOS = Перечисления.ra_FormyOS.TipovyeIspytaniya Тогда
		
		ОбработкаОбъект.УстановитьВидимость(
			"GID_MTRIO,
			|KKS,
			|KlassBezopasnosti,
			|KodOKPD2,
			|ObektOcenkiSootvetstviyaProdukciya,
			|VidProdukciiVSootvetstviiSNP_071_18,
			|Zayavitel,
			|Ispolnitel,
			|SeriynieNomera
			|SeriynieNomera.SerijnyjNomer", Истина);
		
		ОбработкаОбъект.УстановитьДоступность(
			"GID_MTRIO,
			|KKS,
			|KlassBezopasnosti,
			|KodOKPD2,
			|ObektOcenkiSootvetstviyaProdukciya,
			|VidProdukciiVSootvetstviiSNP_071_18,
			|Zayavitel,
			|Ispolnitel,
			|SeriynieNomera
			|SeriynieNomera.SerijnyjNomer", Истина);
		// ТСК Тележкин И.С.; 11.01.2019; task#2458}
		
		// ТСК Тележкин И.С.; 11.01.2019; task#2489{
	ИначеЕсли Данные.FormaOS = Перечисления.ra_FormyOS.PredvaritelnyeKompleksnyeIspytaniya
		ИЛИ Данные.FormaOS = Перечисления.ra_FormyOS.PredvaritelnyeAvtonomnyeIspytaniya Тогда
		
		ОбработкаОбъект.УстановитьВидимость(
			"DataZayavki,
			|NomerZayavki,
			|Zayavitel,
			|Ispolnitel,
			|TipIspytanij,
			|NaimenovanieAvtomatizirovannojSistemy,
			|VidProdukciiVSootvetstviiSNP_071_18,
			|KodOKPD2,
			|GID_MTRIO,
			|KKS,
			|KlassBezopasnosti", Истина);
		
		ОбработкаОбъект.УстановитьДоступность(
			"DataZayavki,
			|NomerZayavki,
			|Zayavitel,
			|Ispolnitel,
			|TipIspytanij,
			|NaimenovanieAvtomatizirovannojSistemy,
			|VidProdukciiVSootvetstviiSNP_071_18,
			|KodOKPD2,
			|GID_MTRIO,
			|KKS,
			|KlassBezopasnosti", Истина);
		// ТСК Тележкин И.С.; 11.01.2019; task#2489}
		
		// ТСК, ovsidorov 14.01.2019 11:24:29{
	ИначеЕсли Данные.FormaOS = Перечисления.ra_FormyOS.AttestacionnyeIspytaniya Тогда
		
		ОбработкаОбъект.УстановитьВидимость(
			"DataZayavki,
			|NomerZayavki,
			|DataRegistracii,
			|NomerRegistraciiZayavki,
			|Zayavitel,
			|Ispolnitel,
			|InformaciyaObObekteOcenkiSootvetstviya,
			|ZayavkaNaProvedenieAttestacionnyhIsytanij", Истина);
		
		ОбработкаОбъект.УстановитьДоступность(
			"DataZayavki,
			|NomerZayavki,
			|DataRegistracii,
			|NomerRegistraciiZayavki,
			|Zayavitel,
			|Ispolnitel,
			|InformaciyaObObekteOcenkiSootvetstviya,
			|ZayavkaNaProvedenieAttestacionnyhIsytanij", Истина);

		
		// ТСК, ovsidorov 14.01.2019 11:24:29}
	КонецЕсли;
	
	ОбязательныеРеквизиты = ОбработкаОбъект.ОбязательныеРеквизиты();
	АктуализироватьМассивОбязательныхРеквизитов(ОбязательныеРеквизиты, Данные);
	ОбработкаОбъект.УстановитьОбязательность(ОбязательныеРеквизиты, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли