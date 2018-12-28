#Область ИнтеграцияBitrix

Функция ЕстьМетодДополнитьОписаниеМетаданных() Экспорт
	
	Возврат Истина;
	
КонецФункции

Процедура ДополнитьОписаниеМетаданных(ОбработкаОбъект, Данные, ПараметрыФормирования) Экспорт
	
	ОбработкаОбъект.ДобавитьИсключения("Ссылка,ПометкаУдаления,Проведен");
	
	
	ЗначенияРеквизитовОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Данные.ZayavkaNaOcenkuSootvetstviya,"Zayavitel,Razrabotchik,Ispolnitel");
	
	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.Zayavitel);
	ОбработкаОбъект.ЗаместитьДанные("Zayavitel", ЗначенияРеквизитовОснования.Zayavitel);

	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.Razrabotchik);
	ОбработкаОбъект.ЗаместитьДанные("Razrabotchik", ЗначенияРеквизитовОснования.Razrabotchik);
	
	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.Ispolnitel);
	ОбработкаОбъект.ЗаместитьДанные("Ispolnitel", ЗначенияРеквизитовОснования.Ispolnitel);
	
	
	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.ObektOcenkiSootvetstviyaProdukciya);
	ОбработкаОбъект.ЗаместитьДанные("ObektOcenkiSootvetstviyaProdukciya", ЗначенияРеквизитовОснования.ObektOcenkiSootvetstviyaProdukciya);
	
	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.ObektOcenkiSootvetstviyaTekhDocs);
	ОбработкаОбъект.ЗаместитьДанные("ObektOcenkiSootvetstviyaTekhDocs", ЗначенияРеквизитовОснования.ObektOcenkiSootvetstviyaTekhDocs);
	
	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.VidProdukciiPoGostu);
	ОбработкаОбъект.ЗаместитьДанные("VidProdukciiPoGostu", ЗначенияРеквизитовОснования.VidProdukciiPoGostu);
	
	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.KodOKPD2);
	ОбработкаОбъект.ЗаместитьДанные("KodOKPD2", ЗначенияРеквизитовОснования.KodOKPD2);
	
	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.KKS);
	ОбработкаОбъект.ЗаместитьДанные("KKS", ЗначенияРеквизитовОснования.KKS);
	
	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.GID_MTRIO);
	ОбработкаОбъект.ЗаместитьДанные("GID_MTRIO", ЗначенияРеквизитовОснования.GID_MTRIO);
	
	ОбработкаОбъект.ДобавитьПоле("",Метаданные.РегистрыСведений.ra_ZayavkaNaOcenkuSootvetstviya3.VidProdukciiVSootvetstviiSNP_071_18);
	ОбработкаОбъект.ЗаместитьДанные("VidProdukciiVSootvetstviiSNP_071_18", ЗначенияРеквизитовОснования.VidProdukciiVSootvetstviiSNP_071_18);
		
	ОбработкаОбъект.УстановитьВидимость(
		"Номер,
		|Дата,
		|PrinyatoeReshenie,
		|Kommentarij,
		|UvedomleniePoZayavkeNaSertifikaciyu,
		|Zayavitel,
		|Razrabotchik,
		|Ispolnitel,
		|ObektOcenkiSootvetstviyaProdukciya,
		|ObektOcenkiSootvetstviyaTekhDocs,
		|VidProdukciiPoGostu,
		|KodOKPD2,
		|GID_MTRIO,
		|VidProdukciiVSootvetstviiSNP_071_18", Истина);	
	
	Если Данные.StatusEhtapa <> Перечисления.ra_StatusyEhtapov.EhtapZavershen Тогда
		
		ОбработкаОбъект.УстановитьДоступность(
			"Номер,
			|Дата,
			|PrinyatoeReshenie,
			|UvedomleniePoZayavkeNaSertifikaciyu,
			|Kommentarij", Истина);
		
	КонецЕсли;
		
	ОбязательныеРеквизиты = ОбработкаОбъект.ОбязательныеРеквизиты();
	АктуализироватьМассивОбязательныхРеквизитов(ОбязательныеРеквизиты, Данные);
	ОбработкаОбъект.УстановитьОбязательность(ОбязательныеРеквизиты, Истина);
	
КонецПроцедуры

Процедура АктуализироватьМассивОбязательныхРеквизитов(МассивРеквизитов, ДокументОбъект) Экспорт
	
КонецПроцедуры

#КонецОбласти
