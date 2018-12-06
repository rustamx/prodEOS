﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ra_Nesootvetstvie") Тогда
		Nesootvetstvie = ДанныеЗаполнения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Nesootvetstvie) Тогда
		Документы.ra_AktObUstraneniiNesootvetstviya.ЗаполнитьАктуальнымиДанными(ЭтотОбъект);
	КонецЕсли;
	
	ра_ОбщегоНазначения.ЗаполнитьВидДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ra_AktObUstraneniiNesootvetstviya.АктуализироватьМассивОбязательныхРеквизитов(ПроверяемыеРеквизиты, ЭтотОбъект);
	
	ра_ОбщегоНазначения.ПроверитьЗаполнениеТабличнойЧастиСогласующие(ЭтотОбъект, Отказ);
			
	ТаблицаДокументов = Документы.ra_VremennyeSderzhivayushchieDejstviyaIKorrekciya.ДокументыКоррекцияСоСтатусом(Nesootvetstvie, Истина);
	
	Для Каждого СтрокаТЗ Из ТаблицаДокументов Цикл
		ТекстОшибки = НСтр("ru = 'Не исполнен документ ""%1""'; en = 'Document ""%1"" is not performed'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(ТекстОшибки, СтрокаТЗ.Представление),,,, Отказ);
	КонецЦикла;
			
КонецПроцедуры

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
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	Если ПометкаУдаления Тогда
		ДополнительныеСвойства.Вставить("НеСоздаватьФайлСВерсией");
	КонецЕсли;
	
	РаботаСРабочимиГруппами.ОтключитьПерезаписьРабочейГруппыПредметаПроцесса(ЭтотОбъект);
	
	ра_ОбщегоНазначения.ДокументыКачестваПередЗаписью(ЭтотОбъект);
	
	Документы.ra_AktObUstraneniiNesootvetstviya.ЗаполнитьАктуальнымиДанными(ЭтотОбъект, Ложь);
	Если НЕ Dejstviya.Количество() И НЕ Uvedomleniya.Количество() Тогда
		Документы.ra_AktObUstraneniiNesootvetstviya.ЗаполнитьАктуальнымиДанными(ЭтотОбъект, Ложь);
	КонецЕсли;
	
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
	
	// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 29.06.2018 {
	// настройка автозапуска процессов для документа "Уведомление о несоответствии"
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента);	
		Иначе
			Если НЕ ра_ОбщегоНазначения.ЕстьНеЗавершенныеБизнесПроцессыПоДокументу(Ссылка) Тогда
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента);
				ДополнительныеСвойства.Вставить("СтартВыполнен", Истина);
				ДополнительныеСвойства.Вставить("Описание", "ok");
			Иначе
				ДополнительныеСвойства.Вставить("СтартВыполнен", Ложь);
				ДополнительныеСвойства.Вставить("Описание", НСтр("ru = 'Не запущен процесс согласования измененного уведомления, т.к. есть предыдущие незавершенные бизнес-процесы.'; en = 'The start of the business process is canceled. There are unfinished business processes'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 29.06.2018 }
	
	Если НЕ ДополнительныеСвойства.Свойство("НеСоздаватьФайлСВерсией") Тогда
		Документы.ra_Nesootvetstvie.СоздатьФайлСВерсией(ЭтотОбъект);
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