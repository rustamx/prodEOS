﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
		ЗарегистрироватьСогласуемыеДокументы("ОбменБухгалтерияПредприятияДокументооборот20");
		ЗарегистрироватьСогласуемыеДокументы("ОбменУправлениеХолдингомДокументооборот20");
	КонецЕсли;
	
	// Корнюшенков А.Ю. Искать в тексте "ОбменНесоответствиямиСЕОСЗакупки" 02.10.2018 {
	УстановитьПривилегированныйРежим(Истина);
	ЗарегистрироватьСогласуемыеДокументы("ра_ОбменДаннымиСЕОСЗакупки");
	// Корнюшенков А.Ю. Искать в тексте "ОбменНесоответствиямиСЕОСЗакупки" 02.10.2018 } 
	
КонецПроцедуры

// Регистрирует документы при изменении состояния согласования
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена, для узлов которого следует выполнить регистрацию
//
Процедура ЗарегистрироватьСогласуемыеДокументы(ИмяПланаОбмена)
	
	УзлыПланаОбмена = ОбменДаннымиПовтИсп.УзлыПланаОбмена(ИмяПланаОбмена);
	Если УзлыПланаОбмена.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СоставПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Состав;
	
	// Корнюшенков А.Ю. Искать в тексте "ОбменНесоответствиямиСЕОСЗакупки" 03.10.2018 {
	// для обмена с ЕОС-Закупки в плане обмена добавлено 2 узла:
	// 1 - Узел, соответствующий контуру ЕОС-Закупки, находящемуся в ЦОД
	// 2 - Узел, соответствующий контуру ЕОС-Закупки, находящемуся в СБИС МБ
	// Для ЕОС-ЗАкупки регистрируем следующие изменения:
	// - Если Уведомление о несоответствии имеет статус "Принято"
	// - Если Отчет ч2 или Итоговый отчет имеет статус "Утвержден" 
	// Если Договор по НС международный, то регистрируем изменения в 2 узла, иначе только в ЦОД
	ТипДокументаУведомлениеДляОбменаСЕОСЗакупки = Новый ОписаниеТипов("ДокументСсылка.ra_Uvedomlenie"); 
	ПрочиеТипыДокументовДляОбменаСЕОСЗакупки    = Новый ОписаниеТипов("ДокументСсылка.ra_OtchetONesootvetstviiCHast2, ДокументСсылка.ra_ItogovyjOtchetONesootvetstvii");
	ДополнительныеДанныеДляРегистрации = ПолучитьДополнительныеДанныеДляРегистрацииОбъектовВПланеОбменаДляЕОСЗакупки(ЭтотОбъект.ВыгрузитьКолонку("Документ")); 
	Если ИмяПланаОбмена = "ра_ОбменДаннымиСЕОСЗакупки" Тогда 
		УзлыПланаОбменаСЕОСЗакупки = ра_ОбщегоНазначенияПовтИсп.УзлыПланаОбменаДляЕОСЗакупки();
		УзелЕОСЗакупкиВЦОД    = Неопределено;
		УзелЕОСЗакупкиВСБИСМБ = Неопределено;
		Для Каждого Узел из УзлыПланаОбменаСЕОСЗакупки Цикл 
			Если Узел.МеждународныйКонтур Тогда 
				УзелЕОСЗакупкиВСБИСМБ = Узел.ОбычныйУзел;	
			Иначе 
				УзелЕОСЗакупкиВЦОД = Узел.ОбычныйУзел;
			КонецЕсли;	
		КонецЦикла;
		
		Если УзелЕОСЗакупкиВСБИСМБ = Неопределено
			или УзелЕОСЗакупкиВЦОД = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Необходимо добавить узлы в плане обмена ""Обмен данными с ЕОС-Закупки"". Обратитесь к администратору системы'; en = 'You need to add nodes to the exchange settings with SAP SRM. You must contact the system administrator'");
		КонецЕсли;	
		
	КонецЕсли;	
		
	// Корнюшенков А.Ю. Искать в тексте "ОбменНесоответствиямиСЕОСЗакупки" 03.10.2018 } 
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		// Корнюшенков А.Ю. Искать в тексте "ОбменНесоответствиямиСЕОСЗакупки" 03.10.2018 {
		Если ИмяПланаОбмена = "ра_ОбменДаннымиСЕОСЗакупки" Тогда 
			
			УсловиеНаСтатусВыполнено = Ложь;
			Если (ТипДокументаУведомлениеДляОбменаСЕОСЗакупки.СодержитТип(ТипЗнч(Запись.Документ))
				И Запись.Состояние = Перечисления.СостоянияДокументов.ra_Принято)
				Или (ПрочиеТипыДокументовДляОбменаСЕОСЗакупки.СодержитТип(ТипЗнч(Запись.Документ))
				И Запись.Состояние = Перечисления.СостоянияДокументов.ra_Утвержден) Тогда 
				УсловиеНаСтатусВыполнено = Истина;
			КонецЕсли;
			
			Если Не УсловиеНаСтатусВыполнено Тогда 
				Продолжить;
			КонецЕсли;	
			
			// получим список узлов плана обмена для регистрации изменений
			МассивУзлов = Новый Массив;
			МассивУзлов.Добавить(УзелЕОСЗакупкиВЦОД); // в ЕОС-Закупки в ЦОД всегда выгружаем
			РегистрируемоеНесоответствие = Неопределено;
			СтрокиСДополнительнымиДанными = ДополнительныеДанныеДляРегистрации.НайтиСтроки(Новый Структура("Документ", Запись.Документ));
			Для Каждого СтрокаДополнительныхДанных Из СтрокиСДополнительнымиДанными Цикл 
				Если СтрокаДополнительныхДанных.ТребуетсяВыгрузкаВМеждународныйКонтур Тогда 
					МассивУзлов.Добавить(УзелЕОСЗакупкиВСБИСМБ);
				КонецЕсли;	
				РегистрируемоеНесоответствие = СтрокаДополнительныхДанных.ДокументНС;
			КонецЦикла;	
			
			Если РегистрируемоеНесоответствие = Неопределено Тогда 
				Продолжить;
			КонецЕсли;	
			
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, РегистрируемоеНесоответствие);
		// Корнюшенков А.Ю. Искать в тексте "ОбменНесоответствиямиСЕОСЗакупки" 03.10.2018 }
		
		ИначеЕсли (Запись.Состояние = Перечисления.СостоянияДокументов.НаСогласовании
			или Запись.Состояние = Перечисления.СостоянияДокументов.Согласован
			или Запись.Состояние = Перечисления.СостоянияДокументов.НеСогласован) 
			и СоставПланаОбмена.Содержит(Запись.Документ.Метаданные()) Тогда
			ПланыОбмена.ЗарегистрироватьИзменения(УзлыПланаОбмена, Запись.Документ);
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

Функция ПолучитьДополнительныеДанныеДляРегистрацииОбъектовВПланеОбменаДляЕОСЗакупки(СписокДокументов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.Ссылка КАК Документ,
		|	ВложенныйЗапрос.ТребуетсяВыгрузкаВМеждународныйКонтур КАК ТребуетсяВыгрузкаВМеждународныйКонтур,
		|	ВложенныйЗапрос.ДокументНС КАК ДокументНС
		|ИЗ
		|	(ВЫБРАТЬ
		|		ra_Uvedomlenie.Ссылка КАК Ссылка,
		|		ВЫБОР
		|			КОГДА ПОДСТРОКА(ra_Uvedomlenie.Dogovor.ID_SRM, 1, 1) = ""8""
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ КАК ТребуетсяВыгрузкаВМеждународныйКонтур,
		|		ra_Uvedomlenie.Nesootvetstvie КАК ДокументНС
		|	ИЗ
		|		Документ.ra_Uvedomlenie КАК ra_Uvedomlenie
		|	ГДЕ
		|		ra_Uvedomlenie.Ссылка В(&СписокДокументов)
		|		И НЕ ra_Uvedomlenie.ПометкаУдаления
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ra_OtchetONesootvetstviiCHast2.Ссылка,
		|		МАКСИМУМ(ВЫБОР
		|				КОГДА ПОДСТРОКА(ra_Uvedomlenie.Dogovor.ID_SRM, 1, 1) = ""8""
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ЛОЖЬ
		|			КОНЕЦ),
		|		ra_OtchetONesootvetstviiCHast2.Nesootvetstvie
		|	ИЗ
		|		Документ.ra_OtchetONesootvetstviiCHast2 КАК ra_OtchetONesootvetstviiCHast2
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ra_Uvedomlenie КАК ra_Uvedomlenie
		|			ПО ra_OtchetONesootvetstviiCHast2.Nesootvetstvie = ra_Uvedomlenie.Nesootvetstvie
		|	ГДЕ
		|		ra_OtchetONesootvetstviiCHast2.Ссылка В(&СписокДокументов)
		|		И НЕ ra_Uvedomlenie.ПометкаУдаления
		|		И НЕ ra_OtchetONesootvetstviiCHast2.ПометкаУдаления
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ra_OtchetONesootvetstviiCHast2.Ссылка,
		|		ra_OtchetONesootvetstviiCHast2.Nesootvetstvie
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ra_ItogovyjOtchetONesootvetstvii.Ссылка,
		|		МАКСИМУМ(ВЫБОР
		|				КОГДА ПОДСТРОКА(ra_Uvedomlenie.Dogovor.ID_SRM, 1, 1) = ""8""
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ЛОЖЬ
		|			КОНЕЦ),
		|		ra_ItogovyjOtchetONesootvetstvii.Nesootvetstvie
		|	ИЗ
		|		Документ.ra_ItogovyjOtchetONesootvetstvii КАК ra_ItogovyjOtchetONesootvetstvii
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ra_Uvedomlenie КАК ra_Uvedomlenie
		|			ПО ra_ItogovyjOtchetONesootvetstvii.Nesootvetstvie = ra_Uvedomlenie.Nesootvetstvie
		|	ГДЕ
		|		ra_ItogovyjOtchetONesootvetstvii.Ссылка В(&СписокДокументов)
		|		И НЕ ra_Uvedomlenie.ПометкаУдаления
		|		И НЕ ra_ItogovyjOtchetONesootvetstvii.ПометкаУдаления
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ra_ItogovyjOtchetONesootvetstvii.Ссылка,
		|		ra_ItogovyjOtchetONesootvetstvii.Nesootvetstvie) КАК ВложенныйЗапрос";
	
	Запрос.УстановитьПараметр("СписокДокументов", СписокДокументов);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции	

#КонецЕсли
