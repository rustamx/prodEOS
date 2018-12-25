﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура АктуализироватьМассивОбязательныхРеквизитов(МассивРеквизитов, ДокументОбъект) Экспорт
	
	МассивРеквизитов.Очистить();
	МассивРеквизитов.Добавить("KharakterRezultata");
	
КонецПроцедуры

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати, СтруктураПараметров = Неопределено) Экспорт
	
	ра_ОбщегоНазначения.ВыполнитьЗаполнениеКомандПечатиДокументаЕОС(КомандыПечати, СтруктураПараметров);
	
КонецПроцедуры

// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 11.07.2018 {
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат Истина;
	
КонецФункции
// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 11.07.2018 }

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
	
	Документы.ra_ZayavkaNaKontrolnuyuOperaciyu.ЗаполнитьДескрипторыПроизводныхДокументов(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено);
	
КонецПроцедуры

// Заполняет переданный дескриптор доступа
//
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	Документы.ra_ZayavkaNaKontrolnuyuOperaciyu.ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа);
	
КонецПроцедуры

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат Документы.ra_ZayavkaNaKontrolnuyuOperaciyu.ПолучитьПоляДоступаПроизводногоДокумента();
	
КонецФункции

#КонецОбласти

Функция ДокументРезультатКОПоЗаявке(ЗаявкаКО) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	                      |	ra_RezultatKontrolnoyOperacii.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Документ.ra_RezultatKontrolnoyOperacii КАК ra_RezultatKontrolnoyOperacii
	                      |ГДЕ
	                      |	ra_RezultatKontrolnoyOperacii.ZayavkaNaKontrolnuyuOperaciyu = &ZayavkaNaKontrolnuyuOperaciyu
	                      |	И НЕ ra_RezultatKontrolnoyOperacii.ПометкаУдаления
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Ссылка УБЫВ");
	
	Запрос.УстановитьПараметр("ZayavkaNaKontrolnuyuOperaciyu", ЗаявкаКО);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Документы.ra_RezultatKontrolnoyOperacii.ПустаяСсылка();
	КонецЕсли;
		
КонецФункции

#КонецОбласти

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.Документы.ra_RezultatKontrolnoyOperacii;
	
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
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК СправочникФайлы
			|	ПО ОсновнаяТаблица.Ссылка = СправочникФайлы.ВладелецФайла
			|		И СправочникФайлы.ра_ОсновнойФайл
			|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияСостоянийДокументов.СрезПоследних КАК РС_ИсторияСостояний
			|	ПО ОсновнаяТаблица.Ссылка = РС_ИсторияСостояний.Документ";
	
КонецФункции

Функция СформироватьМассивДанныхРолевойМодели(ДокументОбъект, ПараметрыФормирования = Неопределено) Экспорт
	
	Возврат Обработки.ра_ФормыБитрикс.Создать().ОписаниеФормы(Метаданные.Документы.ra_RezultatKontrolnoyOperacii, ДокументОбъект, ПараметрыФормирования);
		
КонецФункции

Функция ПолучитьМассивКнопок(ДокументОбъект) Экспорт
		
	ВидФормы = "ФормаОбъекта";
	ЗаявкаКО = Документы.ra_ZayavkaNaKontrolnuyuOperaciyu.ПустаяСсылка();
	Если ТипЗнч(ДокументОбъект) = Тип("Структура") Тогда
		ВидФормы = "ФормаСписка";
		Если ДокументОбъект.Свойство("ZayavkaNaKontrolnuyuOperaciyu") Тогда
			ЗаявкаКО = ДокументОбъект.ZayavkaNaKontrolnuyuOperaciyu;
		КонецЕсли;
	Иначе
		ЗаявкаКО = ДокументОбъект.ZayavkaNaKontrolnuyuOperaciyu;
	КонецЕсли;
		
	МассивКнопок = Новый Массив;
	
	Если ВидФормы = "ФормаСписка" Тогда
				
		ИмяКнопки = "RegisterCOResult";
		ОписаниеКнопки = НСтр("ru = 'Зарегистрировать результат Контрольной операции'; en = 'Register Control operation result'");
		КнопкаЗарегистрироватьРезультат = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		КнопкаЗарегистрироватьРезультат.Availability = ДокументРезультатКОПоЗаявке(ЗаявкаКО).Пустая();
		КнопкаЗарегистрироватьРезультат.Visibility = КнопкаЗарегистрироватьРезультат.Availability;
				
		МассивКнопок.Добавить(КнопкаЗарегистрироватьРезультат);
		
		// ТСК Близнюк С.И.; 18.12.2018; task#2024{
		Если НЕ ДокументРезультатКОПоЗаявке(ЗаявкаКО).Пустая() Тогда
			ИмяКнопки = "DownloadResults";
			ОписаниеКнопки = НСтр("ru = 'Загрузить файл с компьютера;Перетащить с помощью Drag’n’Drop';
				|en = 'Load file from computer;Drag’n’Drop'");
			КнопкаЗагрузитьРезультат = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Иначе
			ИмяКнопки = "DownloadResults";
			ОписаниеКнопки = НСтр("ru = 'После создания документа;вы сможете прикреплять к нему файлы';
				|en = 'After creating a document;you can attach files to it'");
			КнопкаЗагрузитьРезультат = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
			КнопкаЗагрузитьРезультат.Availability = Ложь;
		КонецЕсли;
		
		МассивКнопок.Добавить(КнопкаЗагрузитьРезультат);
		// ТСК Близнюк С.И.; 18.12.2018; task#2024}
		
		// ТСК Близнюк С.И.; 18.12.2018; task#2009{
		ИмяКнопки = "StatusApproval";
		ОписаниеКнопки = НСтр("ru = 'Статус согласования'; en = 'Status of approval'");
		КнопкаСтатусСогласования = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Если ДокументРезультатКОПоЗаявке(ЗаявкаКО).Пустая() Тогда
			КнопкаСтатусСогласования.Availability = Ложь;
		КонецЕсли;
		
		МассивКнопок.Добавить(КнопкаСтатусСогласования);
		// ТСК Близнюк С.И.; 18.12.2018; task#2009}
		
	ИначеЕсли ВидФормы = "ФормаОбъекта" Тогда
		
		РезультатУжеВведен = ЗначениеЗаполнено(ДокументОбъект.Ссылка);
		
		ИмяКнопки = "Save";
		ОписаниеКнопки = НСтр("ru = 'Сохранить'; en = 'Save'");
		КнопкаСохранить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		КнопкаСохранить.Availability = Не РезультатУжеВведен;
		КнопкаСохранить.Visibility = КнопкаСохранить.Availability;
		
		МассивКнопок.Добавить(КнопкаСохранить);
		
	КонецЕсли;
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ra_RezultatKontrolnoyOperacii;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	РеквизитыОбъекта = МетаданныеДокумента.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеДокумента.СтандартныеРеквизиты;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РеквизитыОбъекта.KharakterRezultata);
	// ТСК Близнюк С.И.; 18.12.2018; task#2024{
	//ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, Новый Структура("Имя,Синоним", "NameMainFile", НСтр("ru = 'Посмотреть файл'; en = 'View fail'")), "String(10)");
	// ТСК Близнюк С.И.; 18.12.2018; task#2024}
					
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МассивДанных = Новый Массив;
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт
	
	МассивЗаголовков = Новый Массив;
	
	ТаблицаЗаголовков = Новый ТаблицаЗначений;
	ТаблицаЗаголовков.Колонки.Добавить("Name");
	ТаблицаЗаголовков.Колонки.Добавить("Description");
		
	Для Каждого ТекСтрока Из ТаблицаЗаголовков Цикл
		МассивЗаголовков.Добавить(Новый Структура("Name,Description",ТекСтрока.Name,ТекСтрока.Description));
	КонецЦикла;
	
	Возврат МассивЗаголовков;
	
КонецФункции

//V2

Функция ЕстьМетодДополнитьОписаниеМетаданных() Экспорт
	
	Возврат Истина;
	
КонецФункции

Процедура ДополнитьОписаниеМетаданных(ОбработкаОбъект, Данные, ПараметрыФормирования) Экспорт
	
	ОбработкаОбъект.ДобавитьИсключения("Ссылка,ПометкаУдаления,Проведен,ВидДокумента");
	
	РезультатУжеВведен = ЗначениеЗаполнено(Данные.Ссылка);
		
	РеквизитыРезультат = "
		|RezultatKO,
		|KharakterRezultata,
		|DataZaversheniyaKO,
		|DataVnutrennyaya,
		|NomerVnutrennij,
		|Soglasuyushchie,
		|Soglasuyushchie.Organizaciya,
		|Soglasuyushchie.Otvetstvennyj,
		|Soglasuyushchie.Podrazdelenie,
		|Soglasuyushchie.Dolzhnost,
		|Soglasuyushchie.Soglasovyvaet,
		|Soglasuyushchie.Podpisyvaet";
		
	ОбработкаОбъект.УстановитьДоступность(РеквизитыРезультат, Не РезультатУжеВведен);
	ОбработкаОбъект.УстановитьВидимость(РеквизитыРезультат, Истина);
	
	VidObektaKontrolya = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Данные.ZayavkaNaKontrolnuyuOperaciyu, "VidObektaKontrolya");
		
	Если VidObektaKontrolya = Перечисления.ra_VidyPredmetovNesootvetstviya.Oborudovanie Тогда
		ОбработкаОбъект.УстановитьДоступность("DataPostupleniyaObektaNaKontrol", Не РезультатУжеВведен);
		ОбработкаОбъект.УстановитьВидимость("DataPostupleniyaObektaNaKontrol", Истина);
	КонецЕсли;
					
	ОбязательныеРеквизиты = ОбработкаОбъект.ОбязательныеРеквизиты();
	АктуализироватьМассивОбязательныхРеквизитов(ОбязательныеРеквизиты, Данные);
	ОбработкаОбъект.УстановитьОбязательность(ОбязательныеРеквизиты, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
