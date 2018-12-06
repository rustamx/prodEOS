﻿
Функция Put(Сообщение)
	
	УстановитьПривилегированныйРежим(Истина);
	ПользовательОтКого = Справочники.Пользователи.НайтиПоНаименованию(Сообщение.from_organization);
	ПользовательКому = Справочники.Пользователи.НайтиПоНаименованию(Сообщение.to_organization);
	ИдентификаторСообщения = Сообщение.msg_id; 
	
	// Если получатель не найден, формируется и сразу отправляется сообщение об ошибке
	Если Не ЗначениеЗаполнено(ПользовательКому) Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получатель ""%1"" не найден среди абонентов СВД'; en = 'Recipient ""%1"" is not found among the EDES subscribers'"),
			Сообщение.to_organization);
			
		СообщениеОбОшибке = СформироватьСообщениеОбОшибке(
			ИдентификаторСообщения, 
			10, // Получатель не найден (ГОСТ)
			ТекстОшибки, 
			Сообщение.from_organization);	
			
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
		НовоеСообщение.ФорматСообщения = Справочники.ФорматыСообщенийСВД.Сообщение1СДокументооборот;
		НовоеСообщение.Записать();
		// Получение файла XML из сообщения
		ЗаписьXML = Новый ЗаписьXML;
		ВременныйФайл = ПолучитьИмяВременногоФайла("xml");
		ЗаписьXML.ОткрытьФайл(ВременныйФайл, "UTF-8");
		ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, Сообщение);
		ЗаписьXML.Закрыть();
		
		РаботаСФайламиВнешнийВызов.СоздатьФайлНаОсновеФайлаНаДиске(
			НовоеСообщение.Ссылка,
			ВременныйФайл,
			"Сообщение_" + ИдентификаторСообщения);
			
		УдалитьФайлы(ВременныйФайл);
		
		ЗафиксироватьТранзакцию();
		
		Ответ = СоздатьОбъект("PutResponse");
		Ответ.errorQuantity = 0;
		
		Возврат Ответ;
		
	Исключение
		
		ОтменитьТранзакцию();
		Информация = ИнформацияОбОшибке();
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В процессе обработки сообщения на сервере произошла ошибка ""%1""'; en = 'In the course of processing a message, an error ""%1"" occurred on the server.'"),
			ПодробноеПредставлениеОшибки(Информация));
			
		СообщениеОбОшибке = СформироватьСообщениеОбОшибке(
			ИдентификаторСообщения, 
			1001,	// Собственные коды ошибок (будут уточняться) 
			ТекстОшибки, 
			Сообщение.from_organization);
			
		Возврат СообщениеОбОшибке;
		
	КонецПопытки;
	
КонецФункции

Функция Get()
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СерверныеСообщенияСВД.Ссылка
		|ИЗ
		|	Справочник.СерверныеСообщенияСВД КАК СерверныеСообщенияСВД
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПравилаПересылкиСообщений КАК ПравилаПересылкиСообщений
		|		ПО СерверныеСообщенияСВД.Кому = ПравилаПересылкиСообщений.Пользователь
		|ГДЕ
		|	СерверныеСообщенияСВД.Кому = &Кому
		|	И СерверныеСообщенияСВД.Отправлено = ЛОЖЬ
		|	И СерверныеСообщенияСВД.ПометкаУдаления = ЛОЖЬ
		|   И ПравилаПересылкиСообщений.ТранспортОтправки ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	СерверныеСообщенияСВД.ДатаПолученияСервером ВОЗР";
		
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
				Если МассивФайлов.Количество() <> 1 Тогда
					Если МассивФайлов.Количество() = 0 Тогда
						ЗаписьЖурналаРегистрации(
							НСтр("ru = 'СВД.ОтправкаПолучателю.WS'; en = 'EDES.ОтправкаПолучателю.WS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
							УровеньЖурналаРегистрации.Ошибка, 
							Метаданные.Справочники.СерверныеСообщенияСВД, 
							Выборка.Ссылка, 
							НСтр("ru = 'Отсутствует файл сообщения.'; en = 'Message file is missing.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
					Иначе	
						ЗаписьЖурналаРегистрации(
							НСтр("ru = 'СВД.ОтправкаПолучателю.WS'; en = 'EDES.ОтправкаПолучателю.WS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
							УровеньЖурналаРегистрации.Ошибка, 
							Метаданные.Справочники.СерверныеСообщенияСВД, 
							Выборка.Ссылка, 
							НСтр("ru = 'Количество файлов сообщения больше одного.'; en = 'The number of files in the message is more than one.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
					КонецЕсли;
				Иначе
					
					ФайлСсылка = МассивФайлов[0];
					
					ТекущаяВерсия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
						ФайлСсылка, 
						"ТекущаяВерсия");
					ТипХраненияФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
						ТекущаяВерсия, 
						"ТипХраненияФайла");
					
					ИмяФайлаСПутем = 
						РаботаСФайламиВызовСервера.ПолучитьИмяФайлаСПутемКДвоичнымДанным(ТекущаяВерсия);
					Если Не ЗначениеЗаполнено(ИмяФайлаСПутем) Тогда
						
						ЗаписьЖурналаРегистрации(
							НСтр("ru = 'СВД.ОтправкаПолучателю.WS'; en = 'EDES.ОтправкаПолучателю.WS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
							УровеньЖурналаРегистрации.Ошибка, 
							Метаданные.Справочники.СерверныеСообщенияСВД, 
							Выборка.Ссылка, 
							НСтр("ru = 'Отсутствует файл сообщения.'; en = 'Message file is missing.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
						
					Иначе	

						ТипОбъектаXDTO = ФабрикаXDTO.Тип("http://www.1c.ru/medosigned", "Header");
	
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
						Ответ.message = Сообщение;
						
						Если ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
							УдалитьФайлы(ИмяФайлаСПутем);
						КонецЕсли;
						ЗафиксироватьТранзакцию();

						Возврат Ответ;
					КонецЕсли;	
				КонецЕсли;	
				Если ТранзакцияАктивна() Тогда
					ЗафиксироватьТранзакцию();
				КонецЕсли;
			Исключение
				
				ОтменитьТранзакцию();
				Информация = ИнформацияОбОшибке();
				ИмяСобытия = НСтр("ru = 'СВД.ОтправкаПолучателю.WS'; en = 'EDES.ОтправкаПолучателю.WS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
				Уровень = УровеньЖурналаРегистрации.Ошибка;
				ОбъектМетаданных = Метаданные.Справочники.СерверныеСообщенияСВД;
				Данные = Выборка.Ссылка;
				Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'При передаче сообщения получателю возникла ошибка ""%1""'; en = 'While sendin the message the recipient an error occurred ""%1""'",
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

// Создает XDTO объект указанного типа из пространства имен "http://www.1c.ru/medosigned"
Функция СоздатьОбъект(ТипОбъекта) Экспорт
	
	Возврат ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/medosigned", ТипОбъекта));
	
КонецФункции

// Переводит уникальный идентификатор в строковое представление без разделителей
Функция ИдВСтроку(ИДДокумента)
	
	ИДДокументаСтрока = НРег(Строка(ИДДокумента));
	ИДДокументаСтрока = СтрЗаменить(ИДДокументаСтрока, "-", "");
	
	Возврат ИДДокументаСтрока;
	
КонецФункции	

Функция СформироватьСообщениеОбОшибке(ИдВходящегоСообщения, КодОшибки, ТекстОшибки, Кому)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Сообщение = СоздатьОбъект("Header");
	Сообщение.standart = "Стандарт системы управления документами"; // Вид стандарта, по которому создано данное сообщение 

	Сообщение.version = "1.0"; // Версия стандарта 
	Сообщение.time = УниверсальноеВремя(ТекущаяДатаСеанса()); // Дата и время формирования сообщения в UTC

	Сообщение.msg_type = 0; // Вид сообщения. Значение = 0 для уведомления.
	
	ИДПакета = Новый УникальныйИдентификатор;
	Сообщение.msg_id = ИдВСтроку(ИДПакета); // Уникальный служебный идентификационный номер сообщения 

	// для фонового задания тут не будет пользователя - надо его брать откуда то
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Сообщение.from_org_id = Строка(ТекущийПользователь.УникальныйИдентификатор()); // Уникальный служебный идентификационный номер отправителя
	Сообщение.from_organization = НСтр("ru = 'Сервер СВД 1С:Документооборот'; en = '1С:Document management EDES server'"); // Организация-отправитель
	
	Сообщение.from_sys_id = "from_sys_id"; //  Уникальный служебный идентификационный номер  системы отправителя
	Сообщение.from_system = "1С:Документооборот"; // Наименование системы управления  документами отправителя	
	
	// Дополнительные данные о системе управления документами отправителя
	Сообщение.from_system_details = Метаданные.Версия; //   не обязательный  
	
	// При отправке уведомлений и ответных сообщений об исполнении ранее направленного документа   
	// значения атрибутов рекомендуется брать из атрибутов from_... принятого  соответствующего сообщения
	Сообщение.to_organization = Кому; // Организация-получатель 

	ОтветнаяИнформация = СоздатьОбъект("AcknowledgementType");
	Сообщение.Acknowledgement = ОтветнаяИнформация;
	
	ОтветнаяИнформация.msg_id = ИдВходящегоСообщения;
	ОтветнаяИнформация.ack_type = 1;
	
	СообщениеОбОшибке = СоздатьОбъект("AckResult");
	ОтветнаяИнформация.AckResult.Добавить(СообщениеОбОшибке);
	СообщениеОбОшибке.errorcode = КодОшибки;
	СообщениеОбОшибке.__content = ТекстОшибки;
	
	Ответ = СоздатьОбъект("PutResponse");
	Ответ.errorQuantity = 1;
	Ответ.message = Сообщение;
	
	Возврат Ответ;
	
КонецФункции

Функция TestConnection()
	
	Возврат Истина;
	
КонецФункции


