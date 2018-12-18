#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ra_Nesootvetstvie") Тогда
		Nesootvetstvie = ДанныеЗаполнения;
	КонецЕсли;
	
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Nesootvetstvie,
		"VidNesootvetstviya,DataVyyavleniya,KlassBezopasnosti,KlassifikatorMTRiO");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыОбъекта);
	
	KlassifikatorMTRiO = Справочники.ra_KlassifikatorMTR.ПолучитьЭлементУровняОценкиПовторяемости(KlassifikatorMTRiO);
	
	Organizaciya = Документы.ra_Nesootvetstvie.ПоследняяДопустившаяОрганизация(Nesootvetstvie);
	
	PeriodOcenkiPovtoryaemosti = РегистрыСведений.ra_PeriodOcenkiPovtoryaemosti.ПолучитьГлубинуОценкиПовторяемости(
		Organizaciya,
		РеквизитыОбъекта.KlassBezopasnosti,
		VidNesootvetstviya);
	NachaloPerioda = ?(PeriodOcenkiPovtoryaemosti, DataVyyavleniya - 86400 * PeriodOcenkiPovtoryaemosti, '00010101');
	
	SdvigGrafikaZnachimyi = Константы.ра_ЗначимоеОтклонениеГрафика.Получить();
	StoimostUstraneniyaNesootvetstviyaZnachimaya = Константы.ра_ЗначимаяСтоимостьУстранения.Получить();
	
	ра_ОбщегоНазначения.ЗаполнитьВидДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ra_OcenkaZnachimosti.АктуализироватьМассивОбязательныхРеквизитов(ПроверяемыеРеквизиты, ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ДополнительныеСвойства.Вставить("ВремяНачала", ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени());
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	ра_ОбщегоНазначения.ДокументыКачестваПередЗаписью(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ObemRabot) Тогда
	
		VliyanieNaGrafik         = SdvigGrafika > SdvigGrafikaZnachimyi;
		VliyanieNaByudzhet       = StoimostUstraneniyaNesootvetstviya > StoimostUstraneniyaNesootvetstviyaZnachimaya;
		VliyanieNaEhkspluataciyu = TipNesootvetstviya = Перечисления.ra_TipyNesootvetstvij.Tip1 Или
			TipNesootvetstviya = Перечисления.ra_TipyNesootvetstvij.Tip2 Или
			TipNesootvetstviya = Перечисления.ra_TipyNesootvetstvij.Tip4;
		
		Povtoryaemost = PovtornyeNesootvetstviya.Найти(Истина, "") <> Неопределено;
		
		ДопустившаяОрганизация = Документы.ra_Nesootvetstvie.ПоследняяДопустившаяОрганизация(Nesootvetstvie);
		ВыявившаяОрганизация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Nesootvetstvie, "VyyavivshayaOrganizaciya");
		
		ObemRabot = РегистрыСведений.ра_ПравилаОпределенияОбъемовРабот.ОпределитьОбъемРабот(
			Перечисления.ra_MestaVyyavleniyaNesootvetstvij[?(ДопустившаяОрганизация = ВыявившаяОрганизация, "VSvoemProcesse", "UZakazchika")],
			Povtoryaemost,
			VliyanieNaEhkspluataciyu,
			VliyanieNaGrafik,
			VliyanieNaByudzhet);
			
	КонецЕсли;
			
	Если ObemRabot = Перечисления.ra_ObemyRabot.D8 Тогда
		ZnachimostNesootvetstviya = Перечисления.ra_ZnachimostiNesootvetstviya.Kriticheskoe;
	ИначеЕсли ObemRabot = Перечисления.ra_ObemyRabot.D6 Тогда
		ZnachimostNesootvetstviya = Перечисления.ra_ZnachimostiNesootvetstviya.Znachitelnoe;
	Иначе
		ZnachimostNesootvetstviya = Перечисления.ra_ZnachimostiNesootvetstviya.Neznachitelnoe;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;
	
	Движения.ra_OcenkiZnachimostiNesootvetstvij.Записывать = Истина;
	
	Если НЕ ПометкаУдаления Тогда
		Движение = Движения.ra_OcenkiZnachimostiNesootvetstvij.Добавить();
		Движение.Период = Дата;
		Движение.Nesootvetstvie = Nesootvetstvie;
		Движение.ObemRabot = ObemRabot;
		Движение.ZnachimostNesootvetstviya = ZnachimostNesootvetstviya;
		Движение.TipNesootvetstviya = TipNesootvetstviya;
		Движение.VliyanieNaEhkspluataciyu = VliyanieNaEhkspluataciyu;
		Движение.VliyanieNaGrafik = VliyanieNaGrafik;
		Движение.VliyanieNaByudzhet = VliyanieNaByudzhet;
		Движение.Povtoryaemost = Povtoryaemost;
	КонецЕсли;
	
	Движения.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора) Экспорт
	
	Документы.ra_Nesootvetstvie.ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
