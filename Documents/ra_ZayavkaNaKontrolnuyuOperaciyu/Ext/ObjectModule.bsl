﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ра_ОбщегоНазначения.ЗаполнитьВидДокумента(ЭтотОбъект);
		
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ra_Signal") Тогда
		
		EhtapVyyavleniya			= ДанныеЗаполнения.EhtapVyyavleniya;
		VidObektaNesootvetstviya 	= ДанныеЗаполнения.VidObektaNesootvetstviya;
		VidKontrolnoyOperacii       = ДанныеЗаполнения.VidKontrolnoyOperacii;
		Proekt                      = ДанныеЗаполнения.Proekt;
		KontrolnoeMeropriyatie      = ДанныеЗаполнения.KontrolnoeMeropriyatie;
		
	КонецЕсли;
	
	VidObektaKontrolya = KontrolnoeMeropriyatie.VidPredmetaNesootvetstviya;
	
	Zayavitel = ПользователиКлиентСервер.ТекущийПользователь();
	OrganizaciyaZayavitel = Zayavitel.ра_Организация;
	PodrazdelenieZayavitel = Zayavitel.Подразделение;
	
	ЗаполнитьПоДаннымПользователя();
	
	PodrazdelenieKontroler = RukovoditelKontrolera.Подразделение;
					
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ra_ZayavkaNaKontrolnuyuOperaciyu.АктуализироватьМассивОбязательныхРеквизитов(ПроверяемыеРеквизиты, ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(PredshestvuyushchayaKO) Тогда
		PoryadkovyjNomerPredyavleniya = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			PredshestvuyushchayaKO, "PoryadkovyjNomerPredyavleniya") + 1;
	Иначе
		PoryadkovyjNomerPredyavleniya = 1;
	КонецЕсли;
	
	// ТСК Близнюк С.И.; 09.10.2018; task#1373{
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ВремяНачала = ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени();
		ДополнительныеСвойства.Вставить("ВремяНачала", ВремяНачала);	
	КонецЕсли;
	// ТСК Близнюк С.И.; 09.10.2018; task#1373}
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
	ра_ОбщегоНазначения.ДокументыКачестваПередЗаписью(ЭтотОбъект);
	
	//Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
	//	
	//	ПредыдущийКонтролер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Kontroler");
	//	ТекущийКонтролер = Kontroler;
	//	
	//	Если ПредыдущийКонтролер <> ТекущийКонтролер И ЗначениеЗаполнено(ТекущийКонтролер) Тогда
	//		
	//		ДополнительныеСвойства.Вставить("ИзменениеКонтролера", Истина);
	//								
	//	КонецЕсли;
	//			
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;
		
	Если ДополнительныеСвойства.ЭтоНовый Тогда
			
		Делопроизводство.ЗаписатьСостояниеДокумента(
			Ссылка,
			ТекущаяДатаСеанса(),
			Перечисления.СостоянияДокументов.ra_Проект,
			ПользователиКлиентСервер.ТекущийПользователь());
		
	КонецЕсли;
	
	//Если ДополнительныеСвойства.Свойство("ИзменениеКонтролера") И ДополнительныеСвойства.ИзменениеКонтролера Тогда
	//	
	//	Исполнители = Новый Массив;
	//	Исполнители.Добавить(Kontroler);
	//	
	//	ПараметрыПроцесса = Новый Структура("Исполнители", Исполнители);
	//	
	//	КонтекстСобытия = Новый ХранилищеЗначения(ПараметрыПроцесса);
	//	
	//	БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(
	//		Ссылка, 
	//		Справочники.ВидыБизнесСобытий.ра_ИзменениеКонтролераКО,
	//		КонтекстСобытия);
	//		
	//КонецЕсли;
	//
	//Если ДополнительныеСвойства.Свойство("SendingForApproval") И ДополнительныеСвойства.SendingForApproval Тогда
	//	
	//	Исполнители = РегистрыСведений.ra_UchastnikiKontrolnyhOperaciy.УчастникиКонтрольнойОперации(Ссылка);
	//	
	//	ПараметрыПроцесса = Новый Структура("Исполнители", Исполнители);
	//	
	//	КонтекстСобытия = Новый ХранилищеЗначения(ПараметрыПроцесса);
	//		
	//	БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(
	//		Ссылка, 
	//		Справочники.ВидыБизнесСобытий.ра_СогласованиеКО,
	//		КонтекстСобытия);
	//			
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора) Экспорт
	
	//Если ЗначениеЗаполнено(Ссылка) Тогда
	//	
	//	ИсходныеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
	//		"ВидДокумента, Ответственный, Зарегистрировал, Подготовил, Адресат, Создал, Подписал, ГрифыУтверждения, Стороны");
	//		
	//	Если ИсходныеРеквизиты.ВидДокумента = ВидДокумента Тогда
	//		ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты);
	//	Иначе
	//		ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
	//	КонецЕсли;
	//	
	//Иначе	
	//	
	//	ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
	//	
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДаннымПользователя()
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Zayavitel);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ra_DostupnyeProekty.Proekt КАК Проект
	|ИЗ
	|	РегистрСведений.ra_DostupnyeProekty КАК ra_DostupnyeProekty
	|ГДЕ
	|	ra_DostupnyeProekty.Polzovatel = &Пользователь
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ra_DostupnyePloshchadki.Ploshchadka КАК Площадка
	|ИЗ
	|	РегистрСведений.ra_DostupnyePloshchadki КАК ra_DostupnyePloshchadki
	|ГДЕ
	|	ra_DostupnyePloshchadki.Polzovatel = &Пользователь";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Proekt = Выборка.Проект;
	КонецЕсли;
	
	Выборка = РезультатЗапроса[1].Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Ploshchadka = Выборка.Площадка;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Proekt) Тогда
	
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
		|	ra_Obekty.Ссылка КАК Obekt
		|ИЗ
		|	Справочник.ra_Obekty КАК ra_Obekty
		|ГДЕ
		|	Владелец = &Proekt
		|	И НЕ ПометкаУдаления");
		
		Запрос.УстановитьПараметр("Proekt", Proekt);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
			Obekt = Выборка.Obekt;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты)
	
	//// Добавление реквизита Ответственный
	//Если ИсходныеРеквизиты.Ответственный <> Ответственный Тогда
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Ответственный);
	//КонецЕсли;
	//
	//// Добавление реквизита Зарегистрировал
	//Если ИсходныеРеквизиты.Зарегистрировал <> Зарегистрировал Тогда
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Зарегистрировал);
	//КонецЕсли;
	//
	//// Добавление реквизита Подготовил
	//Если ИсходныеРеквизиты.Подготовил <> Подготовил Тогда
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подготовил);
	//КонецЕсли;
	//
	//// Добавление реквизита Подписал
	//Если ИсходныеРеквизиты.Подписал <> Подписал Тогда
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подписал);
	//КонецЕсли;
	//
	//// Добавление реквизита Адресат
	//Если ИсходныеРеквизиты.Адресат <> Адресат Тогда
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Адресат);
	//КонецЕсли;
	//
	//// Добавление реквизита Создал
	//Если ИсходныеРеквизиты.Создал <> Создал Тогда
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Создал);
	//КонецЕсли;
	//
	//// Добавление подписантов сторон
	//Если ОбщегоНазначенияДокументооборотКлиентСервер.ЕстьОтличияВТаблицах(
	//		ИсходныеРеквизиты.Стороны.Выгрузить(), Стороны, "Подписал") Тогда
	//
	//	ПодписантыСторон = РаботаСПодписямиДокументов.ПодписантыСторонДокумента(Стороны);
	//	Для каждого Подписант Из ПодписантыСторон Цикл
	//		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
	//			ТаблицаНабора, 
	//			Подписант);
	//	КонецЦикла;
	//КонецЕсли;
	//
	//// Добавление авторов утверждений
	//Если ОбщегоНазначенияДокументооборотКлиентСервер.ЕстьОтличияВТаблицах(
	//		ИсходныеРеквизиты.ГрифыУтверждения.Выгрузить(), ГрифыУтверждения, "АвторУтверждения") Тогда
	//		
	//	АвторыУтверждения = РаботаСГрифамиУтверждений.АвторыУтвержденийДокумента(ГрифыУтверждения);
	//	Для каждого Автор Из АвторыУтверждения Цикл
	//		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
	//			ТаблицаНабора, 
	//			Автор);
	//	КонецЦикла;
	//КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	//РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Ответственный);
	//РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Зарегистрировал);
	//РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подготовил);
	//РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подписал);
	//РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Адресат);
	//РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Создал);
	//
	//ПодписантыСторон = РаботаСПодписямиДокументов.ПодписантыСторонДокумента(Стороны);
	//Для каждого Подписант Из ПодписантыСторон Цикл
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
	//		ТаблицаНабора, 
	//		Подписант);
	//КонецЦикла;
	//	
	//АвторыУтверждения = РаботаСГрифамиУтверждений.АвторыУтвержденийДокумента(ГрифыУтверждения);
	//Для каждого Автор Из АвторыУтверждения Цикл
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
	//		ТаблицаНабора, 
	//		Автор);
	//КонецЦикла;
	//
	//Если Ссылка.Пустая() Тогда 
	//	Возврат;
	//КонецЕсли;
	//
	//// Добавление авторов виз согласования
	//АвторыВиз = Справочники.ВизыСогласования.ПолучитьМассивАвторовВизПоДокументу(Ссылка);
	//Для каждого Автор Из АвторыВиз Цикл
	//	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
	//		ТаблицаНабора, 
	//		Автор);
	//КонецЦикла;
	//
	//// Добавление контролеров
	//Контроль.ДобавитьКонтролеровВТаблицу(ТаблицаНабора, Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
