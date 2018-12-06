﻿
#Область СлужебныеПроцедурыИФункции

Функция Put(Сообщение,ТаблицаВложеннийXDTO)
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыДокумента = Новый Структура;
	ПользовательОтКогоСтр = Сообщение.Header.Sender.Contact.Organization.ShortName;
	ПользовательОтКого  = Справочники.Пользователи.НайтиПоНаименованию(ПользовательОтКогоСтр);
	ПользовательКомуСтр = Сообщение.Header.Recipient.Contact[0].Organization.ShortName;
	ПользовательКому    = Справочники.Пользователи.НайтиПоНаименованию(ПользовательКомуСтр);
	ИдентификаторСообщения = Сообщение.Header.ReturnID; 
	
	// Если получатель не найден, формируется и сразу отправляется сообщение об ошибке
	Если Не ЗначениеЗаполнено(ПользовательКому) Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получатель ""%1"" не найден среди абонентов сервера СВД'; en = 'Recipient ""%1"" is not found among the subscribers of EDES Server'"),
			ПользовательКомуСтр);
			
		СообщениеОбОшибке = СформироватьСообщениеОбОшибке(
			Сообщение, 
			10, // Получатель не найден (ГОСТ)
			ТекстОшибки, 
			ПользовательОтКогоСтр);	
			
		Возврат СообщениеОбОшибке;	
			
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		//Если получатель найден, то записываем сообщение в справочник СерверныеСообщенияСВД
		НовоеСообщение = Справочники.СерверныеСообщенияСВД.СоздатьЭлемент();
		НовоеСообщение.ДатаПолученияСервером = ТекущаяДатаСеанса();
		НовоеСообщение.ОтКого = ПользовательОтКого;
		НовоеСообщение.Кому = ПользовательКому;	
		НовоеСообщение.Отправлено = Ложь;
		НовоеСообщение.ИдентификаторСообщения = ИдентификаторСообщения;
		НовоеСообщение.ФорматСообщения = Справочники.ФорматыСообщенийСВД.СообщениеПоГОСТ538982013ВложенныеФайлы;
		НовоеСообщение.Записать();
		
		ТаблицаВложенний =  СериализаторXDTO.ПрочитатьXDTO(ТаблицаВложеннийXDTO);
		Для Каждого ОбъектXDTOФайл Из Сообщение.Header.ResourceList.Resource Цикл
			СтрокаТЗФайлов = ТаблицаВложенний.Найти(Нрег(ОбъектXDTOФайл.UniqueName),"ИмяФайлаНрег"); 
			Если  СтрокаТЗФайлов <> Неопределено Тогда 
				ФайлСсылка = РаботаССВД.ДобавитьФайл2013(НовоеСообщение.Ссылка, СтрокаТЗФайлов);
			КонецЕсли;    
		КонецЦикла;	
		
		Ответ = СоздатьОбъект("PutResponse");
		Ответ.errorQuantity = 0;
		
		ЗафиксироватьТранзакцию();
		
		Возврат Ответ;
		
	Исключение
		
		ОтменитьТранзакцию();
		Информация = ИнформацияОбОшибке();
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В процессе обработки сообщения на сервере произошла ошибка ""%1""'; en = 'In the course of processing a message, an error ""%1"" occurred on the server.'"),
			ПодробноеПредставлениеОшибки(Информация));
			
		СообщениеОбОшибке = СформироватьСообщениеОбОшибке(
			Сообщение, 
			1001,	// Собственные коды ошибок (будут уточняться) 
			ТекстОшибки, 
			ПользовательОтКогоСтр);
			
		Возврат СообщениеОбОшибке;
		
	КонецПопытки;
	
КонецФункции

Функция Get()
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|   СерверныеСообщенияСВД.Ссылка
		|ИЗ
		|   Справочник.СерверныеСообщенияСВД КАК СерверныеСообщенияСВД
		|       ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПравилаПересылкиСообщений КАК ПравилаПересылкиСообщений
		|       ПО СерверныеСообщенияСВД.Кому = ПравилаПересылкиСообщений.Пользователь
		|ГДЕ
		|   СерверныеСообщенияСВД.Кому = &Кому
		|   И СерверныеСообщенияСВД.Отправлено = ЛОЖЬ
		|   И СерверныеСообщенияСВД.ПометкаУдаления = ЛОЖЬ
		|   И ПравилаПересылкиСообщений.ТранспортОтправки ЕСТЬ NULL 
		|   И СерверныеСообщенияСВД.ФорматСообщения = ЗНАЧЕНИЕ(Справочник.ФорматыСообщенийСВД.СообщениеПоГОСТ538982013ВложенныеФайлы)
		|
		|УПОРЯДОЧИТЬ ПО
		|   СерверныеСообщенияСВД.ДатаПолученияСервером";
		
	Запрос.УстановитьПараметр("Кому", ПользователиКлиентСервер.ТекущийПользователь());
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			
			// Получаем объект для отправки
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("XML");
			НачатьТранзакцию();
			Попытка
				
				МассивФайлов = РаботаСФайламиВызовСервера.ПолучитьВсеПодчиненныеФайлы(Выборка.Ссылка);
				Если МассивФайлов.Количество() = 0 Тогда
					ЗаписьЖурналаРегистрации(
					НСтр("ru = 'СВД.ОтравкаПолучателю.WS'; en = 'EDES.Sending to recipient.WS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Справочники.СерверныеСообщенияСВД,
					Выборка.Ссылка,
					НСтр("ru = 'Отсутствует файл сообщения.'; en = 'Message file is missing.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
				КонецЕсли;
				
				ИмяФайлаСПутем = "";ИмяКорневогоЭлемента="";
				ТаблицаВложенний = РаботаССВД.СоздатьТаблицуВложений(МассивФайлов,ИмяФайлаСПутем,ИмяКорневогоЭлемента);
				
				Если Не ЗначениеЗаполнено(ИмяФайлаСПутем) Тогда
					
					ЗаписьЖурналаРегистрации(
					НСтр("ru = 'СВД.ОтравкаПолучателю.WS'; en = 'EDES.Sending to recipient.WS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
					УровеньЖурналаРегистрации.Ошибка, 
					Метаданные.Справочники.СерверныеСообщенияСВД, 
					Выборка.Ссылка, 
					НСтр("ru = 'Отсутствует файл сообщения.'; en = 'Message file is missing.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
					
				Иначе
					
					ТипОбъектаXDTO = ФабрикаXDTO.Тип("http://www.eos.ru/2010/sev", ИмяКорневогоЭлемента);
					
					ЧтениеXML = Новый ЧтениеXML;
					ЧтениеXML.ОткрытьФайл(ИмяФайлаСПутем);
					Сообщение = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипОбъектаXDTO);
					Сообщение.Проверить();
					ЧтениеXML.Закрыть();
					
					
					ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
					СообщениеОбъект = Выборка.Ссылка.ПолучитьОбъект();
					СообщениеОбъект.Отправлено = Истина;
					СообщениеОбъект.ДатаОтправкиПолучателю = ТекущаяДатаСеанса();
					СообщениеОбъект.Записать();
					РазблокироватьДанныеДляРедактирования(Выборка.Ссылка);
					
					Ответ = СоздатьОбъект("GetResponse");
					Ответ.messagesQuantity = 1;
					Если  НРег(ИмяКорневогоЭлемента) = "docinfo" Тогда
						Ответ.DocInfo = Сообщение;
					Иначе    
						Ответ.Report = Сообщение;
					КонецЕсли;    
					Ответ.TableFiles = СериализаторXDTO.ЗаписатьXDTO(ТаблицаВложенний);
					
					УдалитьФайлы(ИмяФайлаСПутем);
					
					ЗафиксироватьТранзакцию();
					
					Возврат Ответ;
				КонецЕсли;	
				Если ТранзакцияАктивна() Тогда
					ЗафиксироватьТранзакцию();
				КонецЕсли;
			Исключение
				
				ОтменитьТранзакцию();
				Информация = ИнформацияОбОшибке();
				ИмяСобытия = НСтр("ru = 'СВД.ОтравкаПолучателю.WS'; en = 'EDES.Sending to recipient.WS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				Уровень = УровеньЖурналаРегистрации.Ошибка;
				ОбъектМетаданных = Метаданные.Справочники.СерверныеСообщенияСВД;
				Данные = Выборка.Ссылка;
				Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'При передаче сообщения получателю возникла ошибка ""%1""'; en = 'While sending the message to recipient an error occurred: ""%1""'",
						ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					ПодробноеПредставлениеОшибки(Информация));
				ЗаписьЖурналаРегистрации(ИмяСобытия, Уровень, ОбъектМетаданных, Данные, Комментарий);
				
			КонецПопытки
			
		КонецЕсли;
	КонецЕсли;
	
	// Если сообщений нет или при отправке произошла ошибка, получателю возвращается ответ, что сообщений нет. 
	Ответ = СоздатьОбъект("GetResponse");
	Ответ.messagesQuantity = 0;				
	Возврат Ответ;

КонецФункции

// Создает XDTO объект указанного типа из пространства имен "http://www.eos.ru/2010/sev"
Функция СоздатьОбъект(ТипОбъекта) Экспорт
	
	Возврат ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.eos.ru/2010/sev", ТипОбъекта));
	
КонецФункции

Функция СформироватьСообщениеОбОшибке(ВходящееСообщениеXDTO, КодОшибки, ТекстОшибки, Кому)

	ОбъектXDTOReport = РаботаССВД.СформироватьСообщениеОбОшибкеСВД2013(ВходящееСообщениеXDTO,КодОшибки, ТекстОшибки, Кому);
	Ответ = СоздатьОбъект("PutResponse");
	Ответ.errorQuantity = 1;
	Ответ.Report = ОбъектXDTOReport;
	
	Возврат Ответ;
	
КонецФункции

Функция TestConnection()
	
	Возврат Истина;
	
КонецФункции
#КонецОбласти
