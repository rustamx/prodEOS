﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПроверитьСоединение(АдресВебСервиса, ИмяПользователя, Пароль) Экспорт
	
	МестоположениеWSDL = АдресВебСервиса;
	Если ЗначениеЗаполнено(МестоположениеWSDL) И 
		Прав(МестоположениеWSDL, 1) <> "/" И Прав(МестоположениеWSDL, 1) <> "\" Тогда
		МестоположениеWSDL = МестоположениеWSDL + "/";
	КонецЕсли;	
	МестоположениеWSDL = МестоположениеWSDL + "ws/medo2013.1cws?wsdl";
	
	Если ИмяПользователя = Неопределено ИЛИ ПустаяСтрока(ИмяПользователя) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнены параметры авторизации на сервере СВД'; en = 'Authorization settings for EDES server are not filled in'");
	КонецЕсли;	
	
	Определение = Новый WSОпределения(
		МестоположениеWSDL, 
		ИмяПользователя,
		Пароль);
	
	Прокси = Новый WSПрокси(
		Определение,
		"http://www.eos.ru/2010/sev",
		"MEDO2013",
		"MEDO2013Soap");
		
	Прокси.Пользователь = ИмяПользователя;
	Прокси.Пароль = Пароль;
	
	Результат = Прокси.TestConnection();
	Возврат Результат;
	
КонецФункции	

Функция ОтправитьСообщение(НастройкаПриемаОтправки, Транспорт, ИсходящееСообщениеСВД) Экспорт
	
	МассивФайлов = РаботаСФайламиВызовСервера.ПолучитьВсеПодчиненныеФайлы(ИсходящееСообщениеСВД);
	
	Если МассивФайлов.Количество() = 0 Тогда
		
		ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Отправка исходящих сообщений СВД'; en = 'Sending outgoing messages via EDES'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		Метаданные.Документы.ИсходящееСообщениеСВД,
		ИсходящееСообщениеСВД,
		НСтр("ru = 'Отсутствует файл сообщения.'; en = 'Message file is missing.'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		Возврат Ложь;
	КонецЕсли;
	ИмяФайлаСПутем = "";ИмяКорневогоЭлемента="";
	ТаблицаВложенний = РаботаССВД.СоздатьТаблицуВложений(МассивФайлов,ИмяФайлаСПутем,ИмяКорневогоЭлемента);
	
	
	Если Не ЗначениеЗаполнено(ИмяФайлаСПутем) Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Отправка исходящих сообщений СВД'; en = 'Sending outgoing messages via EDES'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Документы.ИсходящееСообщениеСВД,
			ИсходящееСообщениеСВД,
			НСтр("ru = 'Отсутствует файл сообщения.'; en = 'Message file is missing.'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		Возврат Ложь;	
		
	КонецЕсли;	
	
	Прокси = ПолучитьПрокси(НастройкаПриемаОтправки);
	
	// прочитаем XML файл в XDTO объект
	ТипОбъектаXDTO = Прокси.ФабрикаXDTO.Тип("http://www.eos.ru/2010/sev", ИмяКорневогоЭлемента);
	
	ЧтениеXML = Новый ЧтениеXML;
    ЧтениеXML.ОткрытьФайл(ИмяФайлаСПутем);
    ОбъектXDTO = Прокси.ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипОбъектаXDTO);
    ОбъектXDTO.Проверить();
	ЧтениеXML.Закрыть();
	
	Результат = Прокси.Put(ОбъектXDTO,СериализаторXDTO.ЗаписатьXDTO(ТаблицаВложенний));
	
	Попытка
		УдалитьФайлы(ИмяФайлаСПутем);
	Исключение
		ЗаписьЖурналаРегистрации(
		НСтр("ru = 'СВД. Отправить сообщение на сервер СВД.'; en = 'EDES. Send message to EDES server.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		НастройкаПриемаОтправки.Метаданные(),
		НастройкаПриемаОтправки,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если Результат.errorQuantity = 0 Тогда
		Возврат Истина;
	Иначе
			
		ТекстОшибки = "Код ошибки = "+ Строка(Результат.Report.Notification.Failure.Code)+ "; "+Результат.Report.Notification.Failure.__content;
		
		ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Отправка исходящих сообщений СВД'; en = 'Sending outgoing messages via EDES'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		Метаданные.Документы.ИсходящееСообщениеСВД,
		ИсходящееСообщениеСВД,
		ТекстОшибки);
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
		
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, "UTF-8");
		Прокси.ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, Результат.Report);
		ЗаписьXML.Закрыть();
		
		РаботаССВД.СоздатьВходящееСообщениеСВДИзXML(Транспорт, ИмяВременногоФайла,,"Report");
		
		Попытка
			УдалитьФайлы(ИмяВременногоФайла);
		Исключение
			ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СВД. Отправить сообщение на сервер СВД.'; en = 'EDES. Send message to EDES server.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			НастройкаПриемаОтправки.Метаданные(),
			НастройкаПриемаОтправки,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ОтправитьСообщения(НастройкаПриемаОтправки, Транспорт) Экспорт
	
	Выборка = РаботаССВД.ПолучитьИсходящиеСообщенияДляОтправкиПоТранспорту(Транспорт);
	
	Пока Выборка.Следующий() Цикл
		
		ИсходящееСообщениеСВД = Выборка.Ссылка;
		ИсходящееСообщениеСВДОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		Попытка
			
			Если ОтправитьСообщение(НастройкаПриемаОтправки, Транспорт, ИсходящееСообщениеСВД) Тогда
								
				ОтправляемыйДокумент = ИсходящееСообщениеСВДОбъект.Документ;
				
				// если это не уведомление - запишем в историю
				Если ЗначениеЗаполнено(ОтправляемыйДокумент) 
					И (ИсходящееСообщениеСВД.ВидСообщения = Перечисления.ВидыСообщенийСВД.ОсновнойДокумент
					Или ИсходящееСообщениеСВД.ВидСообщения = Перечисления.ВидыСообщенийСВД.ДокументОтвет) Тогда
					РаботаССВД.ЗаписатьВИсториюСостоянийСВД(ОтправляемыйДокумент, 
						ИсходящееСообщениеСВД, Справочники.ВидыСостоянийДокументовВСВД.Отправлен,
						ИсходящееСообщениеСВДОбъект.ИдентификаторСообщения);
						
					РаботаССВД.ЗафиксироватьФактОтправкиДокумента(ОтправляемыйДокумент, ИсходящееСообщениеСВДОбъект.Получатель);
				КонецЕсли;
				
				ИсходящееСообщениеСВДОбъект.ДатаОтправки = ТекущаяДатаСеанса();
				ИсходящееСообщениеСВДОбъект.Отправлено = Истина;
				ИсходящееСообщениеСВДОбъект.Записать();				
				
			КонецЕсли;
			
		Исключение
			
			СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'СВД. Отправка на сервер'; en = 'EDES. Sending to server'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Документы.ИсходящееСообщениеСВД,
				ИсходящееСообщениеСВД,
				СообщениеОбОшибке);
				
			ОтправляемыйДокумент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ИсходящееСообщениеСВД, "Документ");
			
			// если это не уведомление - запишем в историю
			Если ЗначениеЗаполнено(ОтправляемыйДокумент) Тогда
				
				РаботаССВД.ЗаписатьВИсториюСостоянийСВД(
					ОтправляемыйДокумент, 
					ИсходящееСообщениеСВД, 
					Справочники.ВидыСостоянийДокументовВСВД.Ошибка,
					ИсходящееСообщениеСВДОбъект.ИдентификаторСообщения,
					СообщениеОбОшибке);
					
			КонецЕсли;
			
		КонецПопытки;	
			
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьСообщения(НастройкаПриемаОтправки, Транспорт) Экспорт
	
	Прокси = ПолучитьПрокси(НастройкаПриемаОтправки);
	
	// В цикле получаем сообщения с веб сервиса и записываем их как ВходящееСообщениеСВД
	
	Пока Истина Цикл
		
		Результат = Прокси.Get();
		
		Если Результат.messagesQuantity = 0 Тогда
			Прервать;
		КонецЕсли;	
		
		НачатьТранзакцию();
		Попытка
			
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
			
			ЗаписьXML = Новый ЗаписьXML;
			ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, "UTF-8");
			
			Если Результат.DocInfo = Неопределено Тогда
				ПаспортXDTO = Результат.Report;
				ИмяКорневогоЭлемента = "Report";
			Иначе
				ПаспортXDTO = Результат.DocInfo;
				ИмяКорневогоЭлемента = "DocInfo";
			КонецЕсли;    
			Прокси.ФабрикаXDTO.ЗаписатьXML(ЗаписьXML,ПаспортXDTO );
			ЗаписьXML.Закрыть();
			
			ТаблицаВложенний = СериализаторXDTO.ПрочитатьXDTO(Результат.TableFiles);
			
			
			РаботаССВД.СоздатьВходящееСообщениеСВДИзXML(Транспорт, ИмяВременногоФайла,ТаблицаВложенний,ИмяКорневогоЭлемента);
			
			ЗафиксироватьТранзакцию();
			
			Попытка
				УдалитьФайлы(ИмяВременногоФайла);
			Исключение
				ЗаписьЖурналаРегистрации(
				НСтр("ru = 'СВД. Получить сообщения с сервера СВД.'; en = 'EDES. Receive messages from EDES server.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				НастройкаПриемаОтправки.Метаданные(),
				НастройкаПриемаОтправки,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		Исключение
			
			ОтменитьТранзакцию();
			СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'СВД. Получение сообщения с сервера. Веб-сервис'; en = 'EDES. Receiving message from server. Web service'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				НастройкаПриемаОтправки.Метаданные(),
				НастройкаПриемаОтправки,
				СообщениеОбОшибке);
				
		КонецПопытки;
			
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции


// Возвращает формат сообщений в данном виде доставки транспорта.
Функция ФорматСообщенияСВД() Экспорт
	
	Возврат Справочники.ФорматыСообщенийСВД.СообщениеПоГОСТ538982013ВложенныеФайлы;
	
КонецФункции	

// Возвращает Истина, если в данном виде доставки транспорта требуется заполнить участников.
Функция ТребуетсяЗаполнитьСписокУчастников() Экспорт
	
	Возврат Истина;
	
КонецФункции	

Функция ПолучитьНаименованиеКонтрагентаВСВД(Контрагент, Транспорт) Экспорт
	
	Возврат РаботаССВД.ПолучитьНаименованиеКонтрагентаВСВДКлиентСервер(Контрагент, Транспорт);
	
КонецФункции	

Функция ПолучитьНаименованиеОрганизацииВСВД(ОрганизацияДокумента, Транспорт) Экспорт
	
	Возврат РаботаССВД.ПолучитьНаименованиеОрганизацииВСВДКлиентСервер(ОрганизацияДокумента, Транспорт);
	
КонецФункции	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает прокси веб-сервиса.
// Возвращаемое значение
// Прокси веб-сервиса
// WSПрокси
//
Функция ПолучитьПрокси(НастройкаПриемаОтправки)
	
	МестоположениеWSDL = НастройкаПриемаОтправки.АдресВебСервиса;
	Если ЗначениеЗаполнено(МестоположениеWSDL) И 
		Прав(МестоположениеWSDL, 1) <> "/" И Прав(МестоположениеWSDL, 1) <> "\" Тогда
		МестоположениеWSDL = МестоположениеWSDL + "/";
	КонецЕсли;	
	МестоположениеWSDL = МестоположениеWSDL + "ws/medo2013.1cws?wsdl";
	
	ИмяПользователя = НастройкаПриемаОтправки.Логин;
	Пароль 		 	= НастройкаПриемаОтправки.Пароль;
	
	Если ИмяПользователя = Неопределено ИЛИ ПустаяСтрока(ИмяПользователя) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнены параметры авторизации на сервере СВД'; en = 'Authorization settings for EDES server are not filled in'");
	КонецЕсли;	
	
	Определение = Новый WSОпределения(
		МестоположениеWSDL, 
		ИмяПользователя,
		Пароль);
	
	Прокси = Новый WSПрокси(
		Определение,
		"http://www.eos.ru/2010/sev",
		"MEDO2013",
		"MEDO2013Soap");
		
	Прокси.Пользователь = ИмяПользователя;
	Прокси.Пароль = Пароль;
	
	Возврат Прокси;
	
КонецФункции	


#КонецОбласти

#КонецЕсли
