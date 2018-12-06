﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ra_Nesootvetstvie") Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Несоответствие", ДанныеЗаполнения);
		Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Пользователи.ра_Организация КАК OrganizaciyaOtpravitel
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Ссылка = &Пользователь
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ra_Nesootvetstvie.Ссылка КАК Nesootvetstvie,
		|	ra_Nesootvetstvie.VidNesootvetstviya КАК VidNesootvetstviya,
		|	ra_Nesootvetstvie.DataVyyavleniya КАК DataVyyavleniya,
		|	ra_Nesootvetstvie.KlassBezopasnosti КАК KlassBezopasnosti,
		|	ra_Nesootvetstvie.KlassifikatorMTRiO КАК KlassifikatorMTRiO
		|ИЗ
		|	Документ.ra_Nesootvetstvie КАК ra_Nesootvetstvie
		|ГДЕ
		|	ra_Nesootvetstvie.Ссылка = &Несоответствие";
		Результат = Запрос.ВыполнитьПакет();
		
		Выборка = Результат[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		КонецЕсли;
		
		Выборка = Результат[1].Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
			KlassifikatorMTRiO = Справочники.ra_KlassifikatorMTR.ПолучитьЭлементУровняОценкиПовторяемости(KlassifikatorMTRiO);
			
			PeriodOcenkiPovtoryaemosti = РегистрыСведений.ra_PeriodOcenkiPovtoryaemosti.ПолучитьГлубинуОценкиПовторяемости(
				Справочники.Организации.ПустаяСсылка(),
				Выборка.KlassBezopasnosti,
				Выборка.VidNesootvetstviya);
			NachaloPerioda = ?(PeriodOcenkiPovtoryaemosti, DataVyyavleniya - 86400 * PeriodOcenkiPovtoryaemosti, '00010101');
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если VidOperacii = Перечисления.ra_VidyUvedomleniy.UvedomlenieVnutriOrganizacii Тогда
			OrganizaciyaPoluchatel = OrganizaciyaOtpravitel;
		КонецЕсли;
	КонецЕсли;
	
	ра_ОбщегоНазначения.ЗаполнитьВидДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ra_Uvedomlenie.АктуализироватьМассивОбязательныхРеквизитов(ПроверяемыеРеквизиты, ЭтотОбъект);
	
	Если OrganizaciyaOtpravitel = OrganizaciyaPoluchatel Тогда
		Если VidOperacii = Перечисления.ra_VidyUvedomleniy.UvedomleniePostavschiku Тогда
			ТекстОшибки = НСтр("ru = 'Допустившая организация должна отличаться от выявившей организации.'; en = 'Responsible organization must be different from organization that detected nonconformity.'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект,,, Отказ);
		ИначеЕсли VidOperacii = Перечисления.ra_VidyUvedomleniy.UvedomlenieZakazchiku Тогда
			ТекстОшибки = НСтр("ru = 'Организация-заказчик должна отличаться от выявившей организации.'; en = 'Customer organization must be different from organization that detected nonconformity.'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект,,, Отказ);
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
	
	Если ПометкаУдаления Тогда
		ДополнительныеСвойства.Вставить("НеСоздаватьФайлСВерсией");
	КонецЕсли;
	
	РаботаСРабочимиГруппами.ОтключитьПерезаписьРабочейГруппыПредметаПроцесса(ЭтотОбъект);
	
	ра_ОбщегоНазначения.ДокументыКачестваПередЗаписью(ЭтотОбъект);
	
	Povtoryaemost = PovtornyeNesootvetstviya.Найти(Истина, "") <> Неопределено;
	
	ObemRabot = РегистрыСведений.ра_ПравилаОпределенияОбъемовРабот.ОпределитьОбъемРабот(
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Nesootvetstvie, "MestoVyyavleniyaNS"),
		Povtoryaemost,
		Ложь,
		Ложь,
		Ложь);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ra_Nesootvetstvie.ПерезаписатьРабочиеГруппыОбъектов(Nesootvetstvie, Истина);
	
	ДополнительныеСвойства.Вставить("ПропуститьОпределениеДескриптораДоступаИПроверкуПрав", Истина);
	
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;
	
	// ТСК Корнюшенков А.Ю. 28.06.2018 {
	// настройка автозапуска процессов для документа "Уведомление о несоответствии"
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента);
		Иначе
			Если НЕ ра_ОбщегоНазначения.ЕстьНеЗавершенныеБизнесПроцессыПоДокументу(Ссылка) Тогда
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента);
				ДополнительныеСвойства.Вставить("СтартВыполнен", Истина);
				ДополнительныеСвойства.Вставить("Описание", "ok");
			Иначе
				ДополнительныеСвойства.Вставить("СтартВыполнен", Ложь);
				ДополнительныеСвойства.Вставить("Описание", НСтр("ru = 'Не запущен процесс согласования измененного уведомления, т.к. есть предыдущие незавершенные бизнес-процесы.'; en = 'The start of the business process is canceled. There are unfinished business processes.'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// ТСК Корнюшенков А.Ю. 28.06.2018 }
	
	Если Не ДополнительныеСвойства.Свойство("НеСоздаватьФайлСВерсией") Тогда
		Документы.ra_Nesootvetstvie.СоздатьФайлСВерсией(ЭтотОбъект);
	КонецЕсли;
	
	Движения.ra_OcenkiZnachimostiNesootvetstvij.Записывать = Истина;
	// ТСК Близнюк С.И.; 06.11.2018; task#1668{
	Движения.ra_VyyavivshayaIDopustivshayaOrganizacii.Записывать = Истина;
	// ТСК Близнюк С.И.; 06.11.2018; task#1668}

	Если Не ПометкаУдаления Тогда
		Движение = Движения.ra_OcenkiZnachimostiNesootvetstvij.Добавить();
		Движение.Период = Дата;
		Движение.Nesootvetstvie = Nesootvetstvie;
		Движение.ObemRabot = ObemRabot;
		Движение.TipNesootvetstviya = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Nesootvetstvie, "TipNesootvetstviya");
		Движение.VliyanieNaEhkspluataciyu = Ложь;
		Движение.VliyanieNaGrafik = Ложь;
		Движение.VliyanieNaByudzhet = Ложь;
		Движение.Povtoryaemost = Povtoryaemost;
		// ТСК Близнюк С.И.; 06.11.2018; task#1668{
		Движение = Движения.ra_VyyavivshayaIDopustivshayaOrganizacii.Добавить();
		Движение.Период = Дата;
		Движение.Nesootvetstvie = Nesootvetstvie;
		Движение.VyyavivshayaOrganizaciya = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Nesootvetstvie, "VyyavivshayaOrganizaciya");
		Движение.DopustivshayaOrganizaciya = OrganizaciyaPoluchatel;
		// ТСК Близнюк С.И.; 06.11.2018; task#1668}
	КонецЕсли;
	
	Движения.Записать();
	
	Если ДополнительныеСвойства.Свойство("Cancellation") И ДополнительныеСвойства.Cancellation Тогда
		
		Делопроизводство.ЗаписатьСостояниеДокумента(
			Ссылка,
			ТекущаяДатаСеанса(),
			Перечисления.СостоянияДокументов.ra_Аннулирован,
			ПользователиКлиентСервер.ТекущийПользователь());
			
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	КомплексныйПроцессПредметы.Ссылка КАК Ссылка
		|ИЗ
		|	БизнесПроцесс.КомплексныйПроцесс.Предметы КАК КомплексныйПроцессПредметы
		|ГДЕ
		|	КомплексныйПроцессПредметы.Предмет = &Предмет
		|	И КомплексныйПроцессПредметы.Ссылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Активен)";
		
		Запрос.УстановитьПараметр("Предмет", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ПричинаПрерывания = СтрШаблон("Отмена документа %1", Ссылка);
			БизнесПроцессыИЗадачиВызовСервера.ПрерватьБизнесПроцесс(Выборка.Ссылка, ПричинаПрерывания);
		КонецЦикла;
		
	КонецЕсли;
		
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
