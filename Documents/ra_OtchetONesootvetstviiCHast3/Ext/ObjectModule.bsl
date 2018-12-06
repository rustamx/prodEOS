﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ra_Nesootvetstvie") Тогда
		Nesootvetstvie = ДанныеЗаполнения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Nesootvetstvie) Тогда
		Документы.ra_OtchetONesootvetstviiCHast3.ЗаполнитьАктуальнымиДанными(ЭтотОбъект);
	КонецЕсли;
	
	ра_ОбщегоНазначения.ЗаполнитьВидДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ra_OtchetONesootvetstviiCHast3.АктуализироватьМассивОбязательныхРеквизитов(ПроверяемыеРеквизиты, ЭтотОбъект);
	
	ра_ОбщегоНазначения.ПроверитьЗаполнениеТабличнойЧастиСогласующие(ЭтотОбъект, Отказ);
	
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
	
	Если НЕ DejstviyaPD.Количество() Тогда
		Документы.ra_OtchetONesootvetstviiCHast3.ЗаполнитьАктуальнымиДанными(ЭтотОбъект, Ложь);
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
	
	Если ДополнительныеСвойства.Свойство("Cancellation") И ДополнительныеСвойства.Cancellation Тогда
					
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ra_OtchetONesootvetstviiCHast3DejstviyaPD.PreduprezhdayushcheeDejstvie КАК Ссылка
		|ПОМЕСТИТЬ ВТ_Документы
		|ИЗ
		|	Документ.ra_OtchetONesootvetstviiCHast3.DejstviyaPD КАК ra_OtchetONesootvetstviiCHast3DejstviyaPD
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийДокументов.СрезПоследних КАК ИсторияСостоянийДокументов
		|		ПО ra_OtchetONesootvetstviiCHast3DejstviyaPD.PreduprezhdayushcheeDejstvie = ИсторияСостоянийДокументов.Документ
		|ГДЕ
		|	ИсторияСостоянийДокументов.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.Исполнен)
		|	И НЕ ra_OtchetONesootvetstviiCHast3DejstviyaPD.PreduprezhdayushcheeDejstvie.ПометкаУдаления
		|	И ra_OtchetONesootvetstviiCHast3DejstviyaPD.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ra_OtchetONesootvetstviiCHast3.Ссылка
		|ИЗ
		|	Документ.ra_OtchetONesootvetstviiCHast3 КАК ra_OtchetONesootvetstviiCHast3
		|ГДЕ
		|	ra_OtchetONesootvetstviiCHast3.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
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
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВЫБОР
		|		КОГДА БизнесПроцессСогласованиеПредметы.Ссылка.ВедущаяЗадача = ЗНАЧЕНИЕ(Задача.ЗадачаИсполнителя.ПустаяСсылка)
		|			ТОГДА БизнесПроцессСогласованиеПредметы.Ссылка
		|		ИНАЧЕ БизнесПроцессСогласованиеПредметы.Ссылка.ВедущаяЗадача.БизнесПроцесс
		|	КОНЕЦ КАК БизнесПроцесс
		|ИЗ
		|	БизнесПроцесс.Согласование.Предметы КАК БизнесПроцессСогласованиеПредметы
		|ГДЕ
		|	БизнесПроцессСогласованиеПредметы.Ссылка.Стартован
		|	И НЕ БизнесПроцессСогласованиеПредметы.Ссылка.Завершен
		|	И БизнесПроцессСогласованиеПредметы.Предмет В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ВТ_Документы.Ссылка
		|			ИЗ
		|				ВТ_Документы)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_Документы.Ссылка КАК Документ
		|ИЗ
		|	ВТ_Документы КАК ВТ_Документы";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
				
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		МассивБизнесПроцессов = РезультатЗапроса[1].Выгрузить().ВыгрузитьКолонку("БизнесПроцесс");
		
		Для Каждого БизнесПроцесс Из МассивБизнесПроцессов Цикл
			ПричинаПрерывания = СтрШаблон("Отмена документа %1", Ссылка);
			БизнесПроцессыИЗадачиВызовСервера.ПрерватьБизнесПроцесс(БизнесПроцесс, ПричинаПрерывания);
		КонецЦикла;
				
		ВыборкаДокументы = РезультатЗапроса[2].Выбрать();
		
		Пока ВыборкаДокументы.Следующий() Цикл
			
			Если ТипЗнч(ВыборкаДокументы.Документ) = Тип("ДокументСсылка.ra_OtchetONesootvetstviiCHast3") Тогда
				
				Делопроизводство.ЗаписатьСостояниеДокумента(
					ВыборкаДокументы.Документ,
					ТекущаяДатаСеанса(),
					Перечисления.СостоянияДокументов.ra_Аннулирован,
					ПользователиКлиентСервер.ТекущийПользователь());
					
			ИначеЕсли ТипЗнч(ВыборкаДокументы.Документ) = Тип("ДокументСсылка.ra_PreduprezhdayushcheeDejstvie") Тогда
				
				Делопроизводство.ЗаписатьСостояниеДокумента(
					ВыборкаДокументы.Документ,
					ТекущаяДатаСеанса(),
					Перечисления.СостоянияДокументов.ra_Проект,
					ПользователиКлиентСервер.ТекущийПользователь());
					
			КонецЕсли;
			
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
