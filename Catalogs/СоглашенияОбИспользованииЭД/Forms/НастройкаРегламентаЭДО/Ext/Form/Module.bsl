﻿&НаКлиенте
Перем мПрофиль;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИсходящийДокумент = Параметры.ИсходящийДокумент;
	СпособОбменаЭД = Параметры.СпособОбменаЭД;
	ПрофильНастроекЭДО = Параметры.ПрофильНастроекЭДО;
	ИдентификаторОрганизации = Параметры.ИдентификаторОрганизации;
	ИспользоватьЭП = Параметры.ИспользоватьЭП;
	ТребуетсяИзвещениеОПолучении = Параметры.ТребуетсяИзвещениеОПолучении;
	ТребуетсяОтветнаяПодпись = Параметры.ТребуетсяОтветнаяПодпись;
	Организация = Параметры.Организация;
	ЗаполнитьТекстПоясняющейНадписи();
	УстановитьДоступность(Параметры.НастройкиРегламентаЭДО);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	мПрофиль = ПрофильНастроекЭДО;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура ИспользоватьЭППриИзменении(Элемент)
	
	ТребуетсяОтветнаяПодпись = ИспользоватьЭП;
	
	ЗаполнитьТекстПоясняющейНадписи();

КонецПроцедуры

&НаКлиенте
Процедура ОжидатьИзвещениеОПолученииПриИзменении(Элемент)
	
	ЗаполнитьТекстПоясняющейНадписи();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	Если Не ЗначениеЗаполнено(ПрофильНастроекЭДО) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ЭлектронноеВзаимодействиеКлиентСервер.ТекстСообщения("Поле", "Заполнение", НСтр("ru = 'Профиль настроек ЭДО'; en = 'EDI settings profile'")),
			,
			"ПрофильНастроекЭДО");
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = ОбменСКонтрагентамиСлужебныйКлиент.СвойстваДокументооборотаЭД();
	
	ПараметрыЗакрытия.ИсходящийДокумент = ИсходящийДокумент;
	ПараметрыЗакрытия.ИспользоватьЭП = ИспользоватьЭП;
	ПараметрыЗакрытия.ПрофильНастроекЭДО = ПрофильНастроекЭДО;
	ПараметрыЗакрытия.СпособОбменаЭД = СпособОбменаЭД;
	ПараметрыЗакрытия.ИдентификаторОрганизации = ИдентификаторОрганизации;
	ПараметрыЗакрытия.ТребуетсяИзвещениеОПолучении = ТребуетсяИзвещениеОПолучении;
	ПараметрыЗакрытия.ТребуетсяОтветнаяПодпись = ТребуетсяОтветнаяПодпись;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТекстПоясняющейНадписи()
	
	ТекстНадписи = "";
	
	Если ИспользоватьЭП Тогда
		ТекстНадписи = НСтр("ru = 'Документ будет подписываться электронной подписью;'; en = 'The document will be signed using digital signature;'");
	Иначе
		ТекстНадписи = НСтр("ru = 'Документ не будет подписываться электронной подписью;'; en = 'The document will not be signed with digital signature;'");
	КонецЕсли;
	
	Если ТребуетсяИзвещениеОПолучении Тогда
		ТекстНадписи = ТекстНадписи + Символы.ПС + НСтр("ru = 'ожидается извещение о получении документа;'; en = 'It is expected the notice of receipt of the document;'");
	Иначе
		ТекстНадписи = ТекстНадписи + Символы.ПС + НСтр("ru = 'извещение о получении документа не требуется;'; en = 'notice of receipt of a document is not required;'");
	КонецЕсли;
	
	Если ТребуетсяОтветнаяПодпись Тогда
		ТекстНадписи = ТекстНадписи + Символы.ПС + НСтр("ru = 'ожидается ответная подпись документа.'; en = 'Expected response signature of the document.'");
	Иначе
		ТекстНадписи = ТекстНадписи + Символы.ПС + НСтр("ru = 'ответная подпись документа не требуется.'; en = 'response signature is not requred'");
	КонецЕсли;
	
	Элементы.ДекорацияПоясняющийТекст.Заголовок = ТекстНадписи;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрофильПриИзменении(Элемент)
	
	Отказ = Ложь;
	ПрофильПриИзмененииНаСервере(Отказ);
	Если Отказ Тогда
		ПрофильНастроекЭДО = мПрофиль;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрофильПриИзмененииНаСервере(Отказ)
	
	// Если выбранный профиль прямого обмена
	// и э.д. счет фактура или корректировочный счет фактура,
	// то при выборе такого профиля необходимо показать предупреждение.
	
	Если ИсходящийДокумент = Перечисления.ВидыЭД.СчетФактура
		Или ИсходящийДокумент = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
		
		
		СпособОбмена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПрофильНастроекЭДО, "СпособОбменаЭД");
		Если ОбменСКонтрагентамиСлужебныйВызовСервера.ЭтоПрямойОбмен(СпособОбмена) Тогда
			
			ШаблонСообщения = НСтр("ru='Отправка документа %1 возможна только через оператора ЭДО.'; en = 'Sending document %1 is only possible through the operator of EDI.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИсходящийДокумент);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			Отказ = Истина;
			
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	// Ищет исходящий документ в выбранном профиле
	// и заполняет регламент ЭДО из нового профиля.
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИспользоватьЭП КАК ИспользоватьЭП,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяОтветнаяПодпись КАК ТребуетсяОтветнаяПодпись,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяИзвещениеОПолучении КАК ТребуетсяИзвещениеОПолучении,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ВерсияФормата КАК ВерсияФормата,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка.СпособОбменаЭД КАК СпособОбменаЭД,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка.ИдентификаторОрганизации КАК ИдентификаторОрганизации
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка = &Ссылка
	|	И ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент = &ИсходящийДокумент";
	Запрос.УстановитьПараметр("Ссылка", ПрофильНастроекЭДО);
	Запрос.УстановитьПараметр("ИсходящийДокумент", ИсходящийДокумент);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ИспользоватьЭП = Выборка.ИспользоватьЭП;
		ТребуетсяОтветнаяПодпись = Выборка.ТребуетсяОтветнаяПодпись;
		ТребуетсяИзвещениеОПолучении = Выборка.ТребуетсяИзвещениеОПолучении;
		ВерсияФормата = Выборка.ВерсияФормата;
		СпособОбменаЭД = Выборка.СпособОбменаЭД;
		ИдентификаторОрганизации = Выборка.ИдентификаторОрганизации;
		
	КонецЦикла;
	
	СпособОбменаЭД = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПрофильНастроекЭДО, "СпособОбменаЭД");

	НастройкиРегламентаЭДО = ОбменСКонтрагентамиСлужебныйВызовСервера.РегламентПрофиляЭДО(ИсходящийДокумент, ВерсияФормата, СпособОбменаЭД);
	УстановитьДоступность(НастройкиРегламентаЭДО);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(НастройкиРегламента)
	
	Элементы.ИспользоватьЭП.Доступность = НастройкиРегламента.РедактироватьПодпись;
	Элементы.ОжидатьИзвещениеОПолучении.Доступность = НастройкиРегламента.РедактироватьИзвещение;
	Элементы.ОжидатьОтветнуюПодпись.Доступность = НастройкиРегламента.РедактироватьОтветнуюПодпись;
	
КонецПроцедуры

#КонецОбласти








