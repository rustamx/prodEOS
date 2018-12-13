﻿
#Область ПрограммныйИнтерфейс

Процедура ОбработкаПроведенияДокументовЕОСОбработкаПроведения(Источник, Отказ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Источник) <> Тип("ДокументОбъект.ra_Nesootvetstvie") тогда
		
	ИначеЕсли ТипЗнч(Источник) <> Тип("ДокументОбъект.ra_ZayavkaNaKontrolnuyuOperaciyu") тогда
		
	Иначе
		Возврат;
	КонецЕсли;
	
	Попытка
		Движение = Источник.Движения.ра_ОборотыПоказателейОтчета;
		Движение.Записать();
		Движение.Записывать = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ра_НазначениеПоказателейОтчетов.ВидДокумента КАК ВидДокумента,
		|	ра_НазначениеПоказателейОтчетов.Показатель КАК Показатель,
		|	ра_НазначениеПоказателейОтчетов.ПравилоОбработки КАК ПравилоОбработки,
		|	ра_НазначениеПоказателейОтчетов.Параметр1 КАК Параметр1,
		|	ра_НазначениеПоказателейОтчетов.Параметр2 КАК Параметр2,
		|	ра_НазначениеПоказателейОтчетов.Параметр3 КАК Параметр3,
		|	ра_НазначениеПоказателейОтчетов.Параметр4 КАК Параметр4,
		|	ра_НазначениеПоказателейОтчетов.Параметр5 КАК Параметр5
		|ИЗ
		|	РегистрСведений.ра_НазначениеПоказателейОтчетов КАК ра_НазначениеПоказателейОтчетов
		|ГДЕ
		|	ра_НазначениеПоказателейОтчетов.ВидДокумента = &ВидДокумента";
		
		Запрос.УстановитьПараметр("ВидДокумента", Источник.ВидДокумента);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ра_ОбщийМодульСервер.ВыполнитьРасчетПоказателяИЗаписатьДвижение(Источник.Ссылка, ВыборкаДетальныеЗаписи);
		КонецЦикла;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

// ТСК Корнюшенков А.Ю. 08.06.2018 {
Процедура ПередЗаписьюПользователяПередЗаписью(Источник, Отказ) Экспорт
	
	УчетнаяЗапись = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Источник.ИдентификаторПользователяИБ);
	
	Если УчетнаяЗапись = Неопределено ИЛИ Не ЗначениеЗаполнено(УчетнаяЗапись.ПользовательОС) Тогда
		Возврат;
	КонецЕсли;
	
	Если УчетнаяЗапись <> Неопределено Тогда
		// Из строки "\\Domen.inter\Ivanov" получаем "Ivanov@Domen.inter"
		СтрокаБезДвухСлеш = СтрЗаменить(УчетнаяЗапись.ПользовательОС, "\\", "");
		
		Результат = Прав(СтрокаБезДвухСлеш, СтрДлина(СтрокаБезДвухСлеш) - Найти(СтрокаБезДвухСлеш, "\") ) + "@"+  Лев(СтрокаБезДвухСлеш, Найти(СтрокаБезДвухСлеш, "\") - 1);
		
		Источник.ra_UserAD = Результат;
	КонецЕсли;
	
	// ТСК Близнюк С.И.; 12.09.2018; task#465{
	Источник.ra_UserInter 	= ПолучитьДоменноеИмяПользователяИБ(Источник.ИдентификаторПользователяИБ);
	Источник.ra_UserGK 		= ПолучитьДоменноеИмяПользователяИБ(Источник.ра_ИдентификаторПользователяИБ);
	// ТСК Близнюк С.И.; 12.09.2018; task#465}
	
КонецПроцедуры
// ТСК Корнюшенков А.Ю. 08.06.2018 }

// ТСК Близнюк С.И.; 09.10.2018; task#1373{
Процедура ра_ЗакончитьЗамерВремениПриЗаписиПриЗаписи(Источник, Отказ) Экспорт
	
	ТипИсточника = ТипЗнч(Источник);
	
	Если ТипИсточника = Тип("ДокументОбъект.ra_AktObUstraneniiNesootvetstviya") Тогда
		КлючеваяОперация = "ra_AktObUstraneniiNesootvetstviyaЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_ItogovyjOtchetONesootvetstvii") Тогда
		КлючеваяОперация = "ra_ItogovyjOtchetONesootvetstviiЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_KorrektiruyushcheeDejstvie") Тогда
		КлючеваяОперация = "ra_KorrektiruyushcheeDejstvieЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_Nesootvetstvie") Тогда
		КлючеваяОперация = "ra_NesootvetstvieЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_OcenkaZnachimosti") Тогда
		КлючеваяОперация = "ra_OcenkaZnachimostiЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_OperaciyaOcenkiSootvetstviya") Тогда
		КлючеваяОперация = "ra_OperaciyaOcenkiSootvetstviyaЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_OtchetONesootvetstviiCHast1") Тогда
		КлючеваяОперация = "ra_OtchetONesootvetstviiCHast1Записать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_OtchetONesootvetstviiCHast2") Тогда
		КлючеваяОперация = "ra_OtchetONesootvetstviiCHast2Записать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_OtchetONesootvetstviiCHast3") Тогда
		КлючеваяОперация = "ra_OtchetONesootvetstviiCHast3Записать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_PlanProvedeniyaOcenkiSootvetstviya") Тогда
		КлючеваяОперация = "ra_PlanProvedeniyaOcenkiSootvetstviyaЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_PreduprezhdayushcheeDejstvie") Тогда
		КлючеваяОперация = "ra_PreduprezhdayushcheeDejstvieЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_Signal") Тогда
		КлючеваяОперация = "ra_SignalЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_Uvedomlenie") Тогда
		КлючеваяОперация = "ra_UvedomlenieЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_VremennyeSderzhivayushchieDejstviyaIKorrekciya") Тогда
		КлючеваяОперация = "ra_VremennyeSderzhivayushchieDejstviyaIKorrekciyaЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_ZayavkaNaKontrolnuyuOperaciyu") Тогда
		КлючеваяОперация = "ra_ZayavkaNaKontrolnuyuOperaciyuЗаписать";
	ИначеЕсли ТипИсточника = Тип("ДокументОбъект.ra_ZayavkaNaOcenkuSootvetstviya") Тогда
		КлючеваяОперация = "ra_ZayavkaNaOcenkuSootvetstviyaЗаписать";
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() 
	  И Источник.ДополнительныеСвойства.Свойство("ВремяНачала") Тогда
		ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(КлючеваяОперация, Источник.ДополнительныеСвойства.ВремяНачала);
	КонецЕсли;
	
КонецПроцедуры
// ТСК Близнюк С.И.; 09.10.2018; task#1373}

Процедура ПереопределениеОбработкиПолученияДанныхВыбора(Источник, ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Если СтандартнаяОбработка Тогда
		ра_ОбщегоНазначения.ПолучитьСтандартныеДанныеВыбора(Источник, ДанныеВыбора, Параметры, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// ТСК Близнюк С.И.; 12.09.2018; task#465{
Функция ПолучитьДоменноеИмяПользователяИБ(ИдентификаторПользователяИБ) 
	
	Результат = "";
	
	УчетнаяЗапись = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
	Если УчетнаяЗапись <> Неопределено И ЗначениеЗаполнено(УчетнаяЗапись.ПользовательОС) Тогда
		// Из строки "\\Domen.inter\Ivanov" получаем "Ivanov@Domen.inter"
		СтрокаБезДвухСлеш = СтрЗаменить(УчетнаяЗапись.ПользовательОС, "\\", "");
		Результат = Прав(СтрокаБезДвухСлеш, СтрДлина(СтрокаБезДвухСлеш) - Найти(СтрокаБезДвухСлеш, "\") ) + "@"+  Лев(СтрокаБезДвухСлеш, Найти(СтрокаБезДвухСлеш, "\") - 1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// ТСК Близнюк С.И.; 12.09.2018; task#465}

#КонецОбласти
