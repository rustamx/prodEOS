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

Процедура ЗаполнитьАктуальнымиДанными(Объект, ЗаполнятьСогласующих = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Несоответствие", Объект.Nesootvetstvie);
	Запрос.УстановитьПараметр("ЗаполнятьСогласующих", ЗаполнятьСогласующих);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ra_PreduprezhdayushcheeDejstvie.Ссылка КАК PreduprezhdayushcheeDejstvie
	|ИЗ
	|	Документ.ra_PreduprezhdayushcheeDejstvie КАК ra_PreduprezhdayushcheeDejstvie
	|ГДЕ
	|	ra_PreduprezhdayushcheeDejstvie.Nesootvetstvie = &Несоответствие
	|	И ra_PreduprezhdayushcheeDejstvie.ПометкаУдаления = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
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
	|	ra_KomandyNesootvetstvij.Nesootvetstvie = &Несоответствие
	|	И &ЗаполнятьСогласующих = ИСТИНА";
	Результат = Запрос.ВыполнитьПакет();
	
	Объект.DejstviyaPD.Загрузить(Результат[0].Выгрузить());
	Если ЗаполнятьСогласующих Тогда
		Объект.Soglasuyushchie.Загрузить(Результат[1].Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.Документы.ra_OtchetONesootvetstviiCHast3;
	
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
	
	ПараметрыПроверки = Новый Структура("ra_PreduprezhdayushcheeDejstvie");
	ПараметрыПроверки.Вставить("ra_OtchetONesootvetstviiCHast3", Перечисления.СостоянияДокументов.ra_Утвержден);
	
	РезультатыПроверки = Документы.ra_Nesootvetstvie.ПроверитьНаличиеПроизводныхДокументов(Несоответствие, ПараметрыПроверки);
	
	МассивКнопок = Новый Массив;
	
	ИмяКнопки = "GenerateReport";
	ОписаниеКнопки = НСтр("ru = 'Сформировать отчет, часть 3'; en = 'Generate report, part 3'");
	КнопкаСформироватьОтчетЧ3 = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
	КнопкаСформироватьОтчетЧ3.Availability = Полномочия.ПервыйЛидер И
		РезультатыПроверки.Свойство("ra_PreduprezhdayushcheeDejstvie") И
		НЕ РезультатыПроверки.Свойство("ra_OtchetONesootvetstviiCHast3");
	КнопкаСформироватьОтчетЧ3.Visibility = КнопкаСформироватьОтчетЧ3.Availability;
	
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
		|				ra_OtchetONesootvetstviiCHast3.Ссылка
		|			ИЗ
		|				Документ.ra_OtchetONesootvetstviiCHast3 КАК ra_OtchetONesootvetstviiCHast3
		|			ГДЕ
		|				ra_OtchetONesootvetstviiCHast3.Nesootvetstvie = &Nesootvetstvie)";
		
		Запрос.УстановитьПараметр("Nesootvetstvie", Несоответствие);
		РезультатЗапроса = Запрос.Выполнить();
		ЕстьНеЗавершенныеБизнесПроцессы = НЕ РезультатЗапроса.Пустой();
		
		Отчет3Утвержден = РезультатыПроверки.Свойство("ra_OtchetONesootvetstviiCHast3") И РезультатыПроверки.ra_OtchetONesootvetstviiCHast3;
		
		КнопкаОтменитьДокумент.Availability = Полномочия.ПервыйЛидер И
			Не Отчет3Утвержден И
			РезультатыПроверки.Свойство("ra_OtchetONesootvetstviiCHast3") И
			ЕстьНеЗавершенныеБизнесПроцессы;
		КнопкаОтменитьДокумент.Visibility = КнопкаОтменитьДокумент.Availability;
		
		МассивКнопок.Добавить(КнопкаОтменитьДокумент);
		
	КонецЕсли;
	
	МассивКнопок.Добавить(КнопкаСформироватьОтчетЧ3);
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт

	МетаданныеДокумента = Метаданные.Документы.ra_OtchetONesootvetstviiCHast3;
	
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