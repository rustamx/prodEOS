﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 29.06.2018 {
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат "ra_OtchetONesootvetstviiCHast2";
	
КонецФункции

Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат Истина;
	
КонецФункции
// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 29.06.2018 }

Процедура АктуализироватьМассивОбязательныхРеквизитов(МассивРеквизитов, ДокументОбъект) Экспорт
	
КонецПроцедуры

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
	
	Документы.ra_Nesootvetstvie.ЗаполнитьДескрипторыПроизводныхДокументов(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено);
	
КонецПроцедуры

// Заполняет переданный дескриптор доступа
//
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	Документы.ra_Nesootvetstvie.ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа);
	
КонецПроцедуры

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат Документы.ra_Nesootvetstvie.ПолучитьПоляДоступаПроизводногоДокумента();
	
КонецФункции

#КонецОбласти

Процедура ЗаполнитьАктуальнымиДанными(Объект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Несоответствие", Объект.Nesootvetstvie);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ra_KomandyNesootvetstvij.Organizaciya КАК Organizaciya,
	|	ra_KomandyNesootvetstvij.Otvetstvennyj КАК Polzovatel,
	|	ra_KomandyNesootvetstvij.Podrazdelenie КАК Podrazdelenie,
	|	ra_KomandyNesootvetstvij.Dolzhnost КАК Dolzhnost,
	|	ra_KomandyNesootvetstvij.RolOrganizacii КАК RolOrganizacii,
	|	НЕ(ra_KomandyNesootvetstvij.Otvetstvennyj.ра_ОтветственныйЗаКачествоВыявивший
	|			ИЛИ ra_KomandyNesootvetstvij.Otvetstvennyj.ра_ОтветственныйЗаКачествоДопустивший) КАК EtapSoglasovanie,
	|	ra_KomandyNesootvetstvij.Otvetstvennyj.ра_ОтветственныйЗаКачествоВыявивший
	|		ИЛИ ra_KomandyNesootvetstvij.Otvetstvennyj.ра_ОтветственныйЗаКачествоДопустивший КАК EtapPodpisaniya
	|ИЗ
	|	РегистрСведений.ra_KomandyNesootvetstvij КАК ra_KomandyNesootvetstvij
	|ГДЕ
	|	ra_KomandyNesootvetstvij.Nesootvetstvie = &Несоответствие";
	Результат = Запрос.ВыполнитьПакет();
	
	Объект.Soglasuyushchie.Загрузить(Результат[0].Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.Документы.ra_ItogovyjOtchetONesootvetstvii;
	
	ТаблицаРеквизитов = ра_ОбменДанными.ПолучитьТаблицуРеквизитовОбъекта(ОбъектМетаданных);
	
	АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов);
	
	ТекстЗапросаВложенныеТаблицы = ПолучитьТекстЗапросаВложенныеТаблицы();
	ТекстЗапросаСоединений = ПолучитьТекстЗапросаСоединений();
	
	Запрос = ра_ОбменДанными.ПолучитьЗапрос(ТаблицаРеквизитов, ПараметрыЗапросаHTTP, ПолноеИмя, ТекстЗапросаВложенныеТаблицы, ТекстЗапросаСоединений);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
	Результат.Вставить("value", МассивДанных);
	
	НастройкаФормы = ПараметрыЗапросаHTTP.Получить("$form_settings");
	Если ЗначениеЗаполнено(НастройкаФормы) И НастройкаФормы Тогда
		МассивКолонок = ПолучитьПолучитьМассивКолонокСписка();
		МассивКнопок = ПолучитьМассивКнопок(Запрос.Параметры);
		МассивФильтров = ПолучитьМассивФильтровСписка();
		Результат.Вставить("form_settings", МассивКолонок);
		Результат.Вставить("button_settings", МассивКнопок);
		Результат.Вставить("filter_settings", МассивФильтров);
	КонецЕсли;
	
КонецПроцедуры

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
	
	СтруктураРеквизита = Новый Структура("Имя,Тип,Выражение", "MainFile", "Справочник.Файлы", "ЕСТЬNULL(СправочникФайлы.Ссылка, ЗНАЧЕНИЕ(Справочник.Файлы.ПустаяСсылка))");
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуРеквизитов(ТаблицаРеквизитов, СтруктураРеквизита);
	
	СтруктураРеквизита = Новый Структура("Имя,Тип,Выражение", "DocStatus", "Перечисление.СостоянияДокументов", "ЕСТЬNULL(РС_ИсторияСостояний.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияДокументов.ПустаяСсылка))");
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуРеквизитов(ТаблицаРеквизитов, СтруктураРеквизита);
	
	СтруктураРеквизита = Новый Структура("Имя,Тип,Выражение", "StatusIndex", "Число", "ЕСТЬNULL(РС_ИндексыСтатусовВидовОбъектов.ИндексСтатуса, 0)");
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуРеквизитов(ТаблицаРеквизитов, СтруктураРеквизита);
	
	СтруктураРеквизита = Новый Структура("Имя,Тип,Выражение", "StatusTotal", "Число", "ЕСТЬNULL(РС_ИндексыСтатусовВидовОбъектов.ВсегоСтатусов, 0)");
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуРеквизитов(ТаблицаРеквизитов, СтруктураРеквизита);
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК СправочникФайлы
			|	ПО ОсновнаяТаблица.Ссылка = СправочникФайлы.ВладелецФайла
			|		И СправочникФайлы.ра_ОсновнойФайл
			|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийДокументов.СрезПоследних КАК РС_ИсторияСостояний
			|	ПО ОсновнаяТаблица.Ссылка = РС_ИсторияСостояний.Документ
			|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ра_ИндексыСтатусовВидовОбъектов КАК РС_ИндексыСтатусовВидовОбъектов
			|	ПО ОсновнаяТаблица.ВидДокумента = РС_ИндексыСтатусовВидовОбъектов.ВидДокумента
			|	И РС_ИсторияСостояний.Состояние = РС_ИндексыСтатусовВидовОбъектов.СостояниеДокумента";
	
КонецФункции

Функция СформироватьМассивДанныхРолевойМодели(ДокументОбъект, ПараметрыФормирования = Неопределено) Экспорт
	
	Возврат Обработки.ра_ФормыБитрикс.Создать().ОписаниеФормы(ДокументОбъект.Метаданные(), ДокументОбъект);
	
КонецФункции

Функция ПолучитьМассивКнопок(ДокументОбъект) Экспорт
	
	ВидФормы = "ФормаОбъекта";
	Несоответствие = Документы.ra_Nesootvetstvie.ПустаяСсылка();
	Если ТипЗнч(ДокументОбъект) = Тип("Структура") Тогда
		ВидФормы = "ФормаСписка";
		Если ДокументОбъект.Свойство("Nesootvetstvie") Тогда
			Несоответствие = ДокументОбъект.Nesootvetstvie;
		КонецЕсли;
	Иначе
		Несоответствие = ДокументОбъект.Nesootvetstvie;
	КонецЕсли;
	
	Полномочия = РегистрыСведений.ra_KomandyNesootvetstvij.ПолномочияТекущегоПользователя(Несоответствие);
	// ТСК Близнюк С.И.; 21.11.2018; task#1801{
	//РезультатыПроверки = Документы.ra_Nesootvetstvie.ПроверитьНаличиеПроизводныхДокументов(Несоответствие,
	//		Новый Структура("ra_ItogovyjOtchetONesootvetstvii"));
	ПараметрыПроверки = Новый Структура("ra_ItogovyjOtchetONesootvetstvii", Перечисления.СостоянияДокументов.ra_Утвержден);
	ПараметрыПроверки.Вставить("ra_AktObUstraneniiNesootvetstviya", Перечисления.СостоянияДокументов.ra_Утвержден);
	ПараметрыПроверки.Вставить("ra_VremennyeSderzhivayushchieDejstviyaIKorrekciya", Перечисления.СостоянияДокументов.Исполнен);
	ПараметрыПроверки.Вставить("ra_OtchetONesootvetstviiCHast2");
	ПараметрыПроверки.Вставить("ra_OtchetONesootvetstviiCHast3");
	ПараметрыПроверки.Вставить("ra_KorrektiruyushcheeDejstvie", Перечисления.СостоянияДокументов.Исполнен);
	
	РезультатыПроверки = Документы.ra_Nesootvetstvie.ПроверитьНаличиеПроизводныхДокументов(Несоответствие, ПараметрыПроверки);
	
	ВыполненыВсеВСД = РезультатыПроверки.Свойство("ra_VremennyeSderzhivayushchieDejstviyaIKorrekciya") И РезультатыПроверки.ra_VremennyeSderzhivayushchieDejstviyaIKorrekciya;
	ЕстьОтчетЧ2 = РезультатыПроверки.Свойство("ra_OtchetONesootvetstviiCHast2");
	ЕстьОтчетЧ3 = РезультатыПроверки.Свойство("ra_OtchetONesootvetstviiCHast3");
	ВыполненыВсеКД = РезультатыПроверки.Свойство("ra_KorrektiruyushcheeDejstvie") И РезультатыПроверки.ra_KorrektiruyushcheeDejstvie;
	// ТСК Близнюк С.И.; 09.01.2019; task#2374{
	ЕстьАктОбУстраненииНС = РезультатыПроверки.Свойство("ra_AktObUstraneniiNesootvetstviya");
	// ТСК Близнюк С.И.; 09.01.2019; task#2374}
	
	Д6 = Ложь;
	Д8 = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ra_OcenkiZnachimostiNesootvetstvijСрезПоследних.ObemRabot КАК ObemRabot
	|ИЗ
	|	РегистрСведений.ra_OcenkiZnachimostiNesootvetstvij.СрезПоследних(, Nesootvetstvie = &Ссылка) КАК ra_OcenkiZnachimostiNesootvetstvijСрезПоследних";
	Запрос.УстановитьПараметр("Ссылка", Несоответствие);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.ObemRabot = Перечисления.ra_ObemyRabot.D6 Тогда
			Д6 = Истина;
		ИначеЕсли Выборка.ObemRabot = Перечисления.ra_ObemyRabot.D8 Тогда
			Д8 = Истина;
		КонецЕсли;
	КонецЕсли;
	
	УсловиеД6 = ?(Д6 ИЛИ Д8, ЕстьОтчетЧ2 И ВыполненыВсеКД, Истина);
	УсловиеД8 = ?(Д8, ЕстьОтчетЧ3 И ВыполненыВсеКД, Истина);
	// ТСК Близнюк С.И.; 21.11.2018; task#1801}
	
	ЕстьИтоговыйОтчет = РезультатыПроверки.Свойство("ra_ItogovyjOtchetONesootvetstvii");
	
	МассивКнопок = Новый Массив;
	
	ИмяКнопки = "GenerateReport";
	ОписаниеКнопки = НСтр("ru = 'Сформировать итоговый отчет'; en = 'Generate a final report'");
	КнопкаСформироватьИтоговыйОтчет = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
	КнопкаСформироватьИтоговыйОтчет.ObjectTypeLink = "Document_ra_Nesootvetstvie";
	КнопкаСформироватьИтоговыйОтчет.ObjectGUID = Строка(Несоответствие.УникальныйИдентификатор());
	// ТСК Близнюк С.И.; 21.11.2018; task#1801{
	//КнопкаСформироватьИтоговыйОтчет.Availability = Полномочия.ПервыйЛидер И НЕ ЕстьИтоговыйОтчет;
	КнопкаСформироватьИтоговыйОтчет.Availability = Полномочия.ПервыйЛидер И Не ЕстьИтоговыйОтчет 
	// ТСК Близнюк С.И.; 09.01.2019; task#2374{
		И ЕстьАктОбУстраненииНС
	// ТСК Близнюк С.И.; 09.01.2019; task#2374}
		И ВыполненыВсеВСД И УсловиеД6 И УсловиеД8;
	// ТСК Близнюк С.И.; 21.11.2018; task#1801}
	КнопкаСформироватьИтоговыйОтчет.Visibility = КнопкаСформироватьИтоговыйОтчет.Availability;
	
	ИмяКнопки = "UploadItogovyjOtchetONesootvetstvii";
	ОписаниеКнопки = НСтр("ru = 'Загрузить Итоговый отчет'; en = 'Upload Final report'");
	КнопкаЗагрузитьОтчет = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
	КнопкаЗагрузитьОтчет.Availability = Полномочия.ПервыйЛидер И Ложь;
	КнопкаЗагрузитьОтчет.Visibility = КнопкаЗагрузитьОтчет.Availability;
	
	Если ВидФормы = "ФормаСписка" Тогда
		
		ИмяКнопки = "CancelDocument";
		ОписаниеКнопки = НСтр("ru = 'Отменить документ'; en = 'Cancel document'");
		КнопкаОтменитьДокумент = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
		|	БизнесПроцессКомплексныйПроцессПредметы.Ссылка КАК Ссылка
		|ИЗ
		|	БизнесПроцесс.КомплексныйПроцесс.Предметы КАК БизнесПроцессКомплексныйПроцессПредметы
		|ГДЕ
		|	БизнесПроцессКомплексныйПроцессПредметы.Ссылка.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Активен)
		|	И БизнесПроцессКомплексныйПроцессПредметы.Предмет В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ra_ItogovyjOtchetONesootvetstvii.Ссылка
		|			ИЗ
		|				Документ.ra_ItogovyjOtchetONesootvetstvii КАК ra_ItogovyjOtchetONesootvetstvii
		|			ГДЕ
		|				ra_ItogovyjOtchetONesootvetstvii.Nesootvetstvie = &Nesootvetstvie)";
		
		Запрос.УстановитьПараметр("Nesootvetstvie", Несоответствие);
		РезультатЗапроса = Запрос.Выполнить();
		ЕстьНеЗавершенныеБизнесПроцессы = НЕ РезультатЗапроса.Пустой();
		
		КнопкаОтменитьДокумент.Availability = Полномочия.ПервыйЛидер И
			ЕстьИтоговыйОтчет И
			РезультатыПроверки.ra_ItogovyjOtchetONesootvetstvii И
			ЕстьНеЗавершенныеБизнесПроцессы;
		КнопкаОтменитьДокумент.Visibility = КнопкаОтменитьДокумент.Availability;
		
		МассивКнопок.Добавить(КнопкаОтменитьДокумент);
		
	КонецЕсли;
	
	МассивКнопок.Добавить(КнопкаСформироватьИтоговыйОтчет);
	МассивКнопок.Добавить(КнопкаЗагрузитьОтчет);
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт

	МетаданныеДокумента = Метаданные.Документы.ra_OtchetONesootvetstviiCHast2;
	
	ТаблицаНастроек = ра_ОбменДанными.ПолучитьТаблицуНастроекПолейПоУмолчанию(МетаданныеДокумента);
	ТаблицаНастроек.Очистить();
	
	РеквизитыОбъекта = МетаданныеДокумента.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеДокумента.СтандартныеРеквизиты;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.Nesootvetstvie);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Дата);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Номер);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МассивДанных = Новый Массив;
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт

	МассивЗаголовков = Новый Массив;
	
	Возврат МассивЗаголовков;	
	
КонецФункции

#КонецОбласти

#КонецЕсли