﻿
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// ТСК Близнюк С.И.; 09.10.2018; task#1373{
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ВремяНачала = ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени();
		ДополнительныеСвойства.Вставить("ВремяНачала", ВремяНачала);	
	КонецЕсли;
	// ТСК Близнюк С.И.; 09.10.2018; task#1373}
	
	// ТСК Близнюк С.И.; 11.12.2018; task#2117{
	//Если Ссылка.Пустая() 
	Если ЗначениеЗаполнено(Organizaciya) И ЗначениеЗаполнено(OtvetstvenniyZaKachestvo)
		И (Ссылка.Пустая()
	// ТСК Близнюк С.И.; 11.12.2018; task#2117}
		или Organizaciya <> Ссылка.Organizaciya 
		или OtvetstvenniyZaKachestvo <> Ссылка.OtvetstvenniyZaKachestvo) Тогда
			
		СтрокаПолучатель = Poluchateli.Вставить(0);
		
		ЗаполнитьЗначенияСвойств(СтрокаПолучатель, ЭтотОбъект);
		СтрокаПолучатель.DataNapravleniya = ТекущаяДатаСеанса()
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());

	// ТСК Близнюк С.И.; 10.12.2018; task#1992{
	ра_ОбщегоНазначения.ДокументыКачестваПередЗаписью(ЭтотОбъект);
	// ТСК Близнюк С.И.; 10.12.2018; task#1992}
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента);
		Иначе
			Если НЕ ра_ОбщегоНазначения.ЕстьБизнесПроцессыПоДокументу(Ссылка) Тогда
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента);
				ДополнительныеСвойства.Вставить("СтартВыполнен", Истина);
				ДополнительныеСвойства.Вставить("Описание", "ok");
			Иначе
				ДополнительныеСвойства.Вставить("СтартВыполнен", Ложь);
				ДополнительныеСвойства.Вставить("Описание", НСтр("ru = 'Не запущен процесс согласования измененного уведомления, т.к. есть предыдущие незавершенные бизнес-процесы.'; en = 'The start of the business process is canceled. There are unfinished business processes.'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// ТСК Близнюк С.И.; 07.12.2018; task#1992{
	Если ДополнительныеСвойства.Свойство("SendingForAcquaintance") И ДополнительныеСвойства.SendingForAcquaintance 
	// ТСК Близнюк С.И.; 11.12.2018; task#2117{
		И НЕ БизнесПроцессы.Ознакомление.ЕстьНеЗавершенныеБизнесПроцессыПоДокументуИИсполнителю(Ссылка, OtvetstvenniyZaKachestvo) Тогда
	// ТСК Близнюк С.И.; 11.12.2018; task#2117}
			
		//Исполнители = Новый Массив;
		//Исполнители.Добавить(OtvetstvenniyZaKachestvo);
		//
		//ПараметрыПроцесса = Новый Структура("Исполнители", Исполнители);
		//
		//КонтекстСобытия = Новый ХранилищеЗначения(ПараметрыПроцесса);
			
		БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(
			Ссылка, 
			Справочники.ВидыБизнесСобытий.ра_ОзнакомлениеССигналом);
			//КонтекстСобытия);
				
	КонецЕсли;
	// ТСК Близнюк С.И.; 07.12.2018; task#1992}
	

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ра_ОбщегоНазначения.ЗаполнитьВидДокумента(ЭтотОбъект);
	
	VyyavivsheeLico = ПользователиКлиентСервер.ТекущийПользователь();

	ЗаполнитьПоДаннымПользователя();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ra_Signal.АктуализироватьМассивОбязательныхРеквизитов(ПроверяемыеРеквизиты, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора) Экспорт
	
	Документы.ra_Signal.ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора, ЭтотОбъект);
	
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
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
