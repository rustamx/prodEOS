﻿
// Записывает личные контакты в информационную базу
Функция ЗаписатьКонтакты(МассивКонтактов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЧислоЗагруженных = 0;
	
	Для Каждого Описание Из МассивКонтактов Цикл
		
		Элемент = Справочники.ЛичныеАдресаты.СоздатьЭлемент();
		
		Элемент.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
		
		Элемент.Наименование = Описание.Наименование;
		Если Не ЗначениеЗаполнено(Элемент.Наименование) Тогда
			Элемент.Наименование = Описание.ПредставлениеEmail;
		КонецЕсли;	
		
		Элемент.Организация = Описание.Организация;
		Элемент.Должность = Описание.Должность;
		
		// EmailАдресата
		Если ЗначениеЗаполнено(Описание.EmailАдресата) И Найти(Описание.EmailАдресата, "@") <> 0 Тогда
			НовСтр = Элемент.КонтактнаяИнформация.Добавить();
			НовСтр.ЗначенияПолей = Описание.EmailАдресата;
			НовСтр.АдресЭП = Описание.EmailАдресата;
			НовСтр.Представление = Описание.EmailАдресата;
			НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.EmailАдресата;
			НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
		КонецЕсли;
		
		// РабочийТелефонАдресата
		Если ЗначениеЗаполнено(Описание.РабочийТелефонАдресата) Тогда
			НовСтр = Элемент.КонтактнаяИнформация.Добавить();
			НовСтр.НомерТелефона = Описание.РабочийТелефонАдресата;
			НовСтр.Представление = Описание.РабочийТелефонАдресата;
			НовСтр.ЗначенияПолей = Описание.РабочийТелефонАдресата;
			НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.РабочийТелефонАдресата;
			НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
		КонецЕсли;
		
		// ФаксАдресата
		Если ЗначениеЗаполнено(Описание.ФаксАдресата) Тогда
			НовСтр = Элемент.КонтактнаяИнформация.Добавить();
			НовСтр.НомерТелефона = Описание.ФаксАдресата;
			НовСтр.Представление = Описание.ФаксАдресата;
			НовСтр.ЗначенияПолей = Описание.ФаксАдресата;
			НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ФаксАдресата;
			НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Факс;
		КонецЕсли;
		
		// ПочтовыйАдресАдресата
		Если ЗначениеЗаполнено(Описание.ПочтовыйАдресАдресата) Тогда
			НовСтр = Элемент.КонтактнаяИнформация.Добавить();
			НовСтр.ЗначенияПолей = Описание.ПочтовыйАдресАдресата;
			НовСтр.Представление = Описание.ПочтовыйАдресАдресата;
			НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресАдресата;
			НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
			НовСтр.Город = Описание.Город;
			НовСтр.Страна = Описание.Страна;
			НовСтр.Регион = Описание.Регион;
		КонецЕсли;
		
		Если ЕстьТакойЛичныйАдресат(Элемент) Тогда
			Продолжить;
		КонецЕсли;	
		
		Если ЕстьТакойКонтрагент(Элемент) Тогда
			Продолжить;
		КонецЕсли;	
		
		Если ЕстьТакоеКонтактноеЛицо(Элемент) Тогда
			Продолжить;
		КонецЕсли;	
		
		Элемент.Записать();
		ЧислоЗагруженных = ЧислоЗагруженных + 1;
		
	КонецЦикла;	
	
	Возврат ЧислоЗагруженных;
	
КонецФункции

Функция ЕстьТакойЛичныйАдресат(Элемент) 
	
	Запрос = Новый Запрос;
	Запрос.Текст
	 = "ВЫБРАТЬ
	   |	ЛичныеАдресаты.Наименование,
	   |	ЛичныеАдресаты.КонтактнаяИнформация.(
	   |		Ссылка,
	   |		НомерСтроки,
	   |		АдресЭП,
	   |		Вид,
	   |		Город,
	   |		ДоменноеИмяСервера,
	   |		ЗначенияПолей,
	   |		НомерТелефона,
	   |		НомерТелефонаБезКодов,
	   |		Представление,
	   |		Регион,
	   |		Страна,
	   |		Тип
	   |	)
	   |ИЗ
	   |	Справочник.ЛичныеАдресаты КАК ЛичныеАдресаты
	   |ГДЕ
	   |	ЛичныеАдресаты.Пользователь = &Пользователь";
	   
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Таблица Цикл
		
		Наименование = Строка.Наименование;
		АдресПочты = ПолучитьАдресПочты(Строка.КонтактнаяИнформация);
		Телефон = ПолучитьТелефон(Строка.КонтактнаяИнформация);
		
		НаименованиеНовое = Элемент.Наименование;
		АдресПочтыНовый = ПолучитьАдресПочты(Элемент.КонтактнаяИнформация);
		ТелефонНовый = ПолучитьТелефон(Элемент.КонтактнаяИнформация);
		
		Если Наименование = НаименованиеНовое 
			И АдресПочты = АдресПочтыНовый
			И Телефон = ТелефонНовый Тогда
			Возврат Истина;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Ложь;
	
КонецФункции

Функция ЕстьТакойКонтрагент(Элемент) 
	
	Запрос = Новый Запрос;
	Запрос.Текст
	 = "ВЫБРАТЬ
	   |	Контрагенты.Наименование,
	   |	Контрагенты.КонтактнаяИнформация.(
	   |		Ссылка,
	   |		НомерСтроки,
	   |		АдресЭП,
	   |		Вид,
	   |		Город,
	   |		ДоменноеИмяСервера,
	   |		ЗначенияПолей,
	   |		НомерТелефона,
	   |		НомерТелефонаБезКодов,
	   |		Представление,
	   |		Регион,
	   |		Страна,
	   |		Тип
	   |	)
	   |ИЗ
	   |	Справочник.Контрагенты КАК Контрагенты";
	   
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Таблица Цикл
		
		АдресПочты = ПолучитьАдресПочты(Строка.КонтактнаяИнформация);
		Телефон = ПолучитьТелефон(Строка.КонтактнаяИнформация);
		
		АдресПочтыНовый = ПолучитьАдресПочты(Элемент.КонтактнаяИнформация);
		ТелефонНовый = ПолучитьТелефон(Элемент.КонтактнаяИнформация);
		
		Если (АдресПочты = АдресПочтыНовый И ЗначениеЗаполнено(АдресПочты))
			ИЛИ (Телефон = ТелефонНовый И ЗначениеЗаполнено(Телефон)) Тогда
			Возврат Истина;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Ложь;
	
КонецФункции

Функция ЕстьТакоеКонтактноеЛицо(Элемент) 
	
	Запрос = Новый Запрос;
	Запрос.Текст
	 = "ВЫБРАТЬ
	   |	КонтактныеЛица.Наименование,
	   |	КонтактныеЛица.КонтактнаяИнформация.(
	   |		Ссылка,
	   |		НомерСтроки,
	   |		АдресЭП,
	   |		Вид,
	   |		Город,
	   |		ДоменноеИмяСервера,
	   |		ЗначенияПолей,
	   |		НомерТелефона,
	   |		НомерТелефонаБезКодов,
	   |		Представление,
	   |		Регион,
	   |		Страна,
	   |		Тип
	   |	)
	   |ИЗ
	   |	Справочник.КонтактныеЛица КАК КонтактныеЛица";
	   
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого Строка Из Таблица Цикл
		
		АдресПочты = ПолучитьАдресПочты(Строка.КонтактнаяИнформация);
		Телефон = ПолучитьТелефон(Строка.КонтактнаяИнформация);
		
		АдресПочтыНовый = ПолучитьАдресПочты(Элемент.КонтактнаяИнформация);
		ТелефонНовый = ПолучитьТелефон(Элемент.КонтактнаяИнформация);
		
		Если (АдресПочты = АдресПочтыНовый И ЗначениеЗаполнено(АдресПочты))
			ИЛИ (Телефон = ТелефонНовый И ЗначениеЗаполнено(Телефон)) Тогда
			Возврат Истина;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучитьАдресПочты(КонтактнаяИнформация)
	
	Для Каждого СтрокаКонтактнойИнформации Из КонтактнаяИнформация Цикл
		Если СтрокаКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
			Возврат СтрокаКонтактнойИнформации.АдресЭП;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТелефон(КонтактнаяИнформация)
	
	Для Каждого СтрокаКонтактнойИнформации Из КонтактнаяИнформация Цикл
		Если СтрокаКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			Возврат СтрокаКонтактнойИнформации.Представление;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

// Заполнить контрагента или контактное лицо данными личного адресата и заменить ссылки в письмах
Функция ЗаполнитьКонтактИЗаменитьСсылки(ЛичныйАдресат, Контакт, УникальныйИдентификатор = Неопределено,
	СтрокаОшибки = "") Экспорт
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Контрагенты") Тогда
		// Заполним контрагента
		
		// если Наименование и Ответственный совпадают - считаем что только что создали контрагента и копировать не надо
		Если Контакт.Наименование <> ЛичныйАдресат.Наименование
			Или Контакт.Ответственный <> ЛичныйАдресат.Пользователь Тогда
			
			ЗаблокироватьДанныеДляРедактирования(Контакт);
			КонтрагентОбъект = Контакт.ПолучитьОбъект();
			
			НеиспользованныеПоля = ЛичныйАдресат.Комментарий;
			
			Для Каждого КонтактИнфоАдресата Из ЛичныйАдресат.КонтактнаяИнформация Цикл
				
				ЕстьПолеТакогоВида = Ложь;
				Для Каждого КонтактИнфоКонтрагента Из КонтрагентОбъект.КонтактнаяИнформация Цикл
					
					Если Строка(КонтактИнфоКонтрагента.Вид) = Строка(КонтактИнфоАдресата.Вид) Тогда
						
						ЕстьПолеТакогоВида = Истина;
						
						Если НРег(КонтактИнфоКонтрагента.Представление) <> НРег(КонтактИнфоАдресата.Представление) Тогда
							СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Нельзя выполнить преобразование, т.к. у личного адресата и контрагента
									|разные адреса Email (%1 и %2).
									|Выберите другого контрагента или создайте нового.';
									|en = 'The conversion cannot be performed because of different email of personal contact and counterparty (%1 and %2). 
									|Select another counterparty or create a new one.'"),
									КонтактИнфоАдресата.Представление, КонтактИнфоКонтрагента.Представление);
							Возврат Ложь;
						КонецЕсли;	
						
						Прервать;
						
					КонецЕсли;	
					
				КонецЦикла;	
				
				Если ЕстьПолеТакогоВида = Ложь Тогда
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.EmailАдресата Тогда
						
						НовСтр = КонтрагентОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.АдресЭП = КонтактИнфоАдресата.АдресЭП;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтрагента;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
						
					КонецЕсли;	
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.РабочийТелефонАдресата Тогда
						
						НовСтр = КонтрагентОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.НомерТелефона = КонтактИнфоАдресата.НомерТелефона;
						НовСтр.НомерТелефонаБезКодов = КонтактИнфоАдресата.НомерТелефонаБезКодов;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
						
					КонецЕсли;	
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресАдресата Тогда
						
						НовСтр = КонтрагентОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.Страна = КонтактИнфоАдресата.Страна;
						НовСтр.Регион = КонтактИнфоАдресата.Регион;
						НовСтр.Город = КонтактИнфоАдресата.Город;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
						
					КонецЕсли;	
					
				Иначе	
					
					НеиспользованныеПоля = НеиспользованныеПоля + " "
						+ Строка(КонтактИнфоАдресата.Вид) + ": " + КонтактИнфоАдресата.ЗначенияПолей + 
						" " + КонтактИнфоАдресата.Представление;
					
				КонецЕсли;	
				
			КонецЦикла;	
			
			КонтрагентОбъект.Комментарий = КонтрагентОбъект.Комментарий + " " + НеиспользованныеПоля;
			КонтрагентОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(Контакт);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛица") Тогда	
		// заполним контактное лицо
		
		// если Наименование и Должность совпадают - считаем что только что создали контактное лицо и копировать не надо
		Если Контакт.Наименование <> ЛичныйАдресат.Наименование
			Или Контакт.Должность <> ЛичныйАдресат.Должность Тогда
		
			ЗаблокироватьДанныеДляРедактирования(Контакт);
			КонтактноеЛицоОбъект = Контакт.ПолучитьОбъект();
			
			НеиспользованныеПоля = ЛичныйАдресат.Комментарий;
			
			Для Каждого КонтактИнфоАдресата Из ЛичныйАдресат.КонтактнаяИнформация Цикл
				
				ЕстьПолеТакогоВида = Ложь;
				Для Каждого КонтактИнфоКонтрагента Из КонтактноеЛицоОбъект.КонтактнаяИнформация Цикл
					
					Если Строка(КонтактИнфоКонтрагента.Вид) = Строка(КонтактИнфоАдресата.Вид) Тогда
						
						ЕстьПолеТакогоВида = Истина;
						
						Если НРег(КонтактИнфоКонтрагента.Представление) <> НРег(КонтактИнфоАдресата.Представление) Тогда
							СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Нельзя выполнить преобразование, т.к. у личного адресата и контактного лица
									|разные адреса Email (%1 и %2).
									|Выберите другое контактное лицо или создайте новое.';
									|en = 'The conversion cannot be performed because of different email of personal contact and contact person (%1 and %2). 
									|Select another contact person or create a new one.'"),
									КонтактИнфоАдресата.Представление, КонтактИнфоКонтрагента.Представление);
							Возврат Ложь;
						КонецЕсли;	
						
						Прервать;
						
					КонецЕсли;	
					
				КонецЦикла;	
				
				Если ЕстьПолеТакогоВида = Ложь Тогда
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.EmailАдресата Тогда
						
						НовСтр = КонтактноеЛицоОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.АдресЭП = КонтактИнфоАдресата.АдресЭП;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
						
					КонецЕсли;	
					
					Если КонтактИнфоАдресата.Вид = Справочники.ВидыКонтактнойИнформации.РабочийТелефонАдресата Тогда
						
						НовСтр = КонтактноеЛицоОбъект.КонтактнаяИнформация.Добавить();
						НовСтр.ЗначенияПолей = КонтактИнфоАдресата.ЗначенияПолей;
						НовСтр.Представление = КонтактИнфоАдресата.Представление;
						НовСтр.НомерТелефона = КонтактИнфоАдресата.НомерТелефона;
						НовСтр.НомерТелефонаБезКодов = КонтактИнфоАдресата.НомерТелефонаБезКодов;
						НовСтр.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица;
						НовСтр.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
						
					КонецЕсли;	
					
				Иначе	
					
					НеиспользованныеПоля = НеиспользованныеПоля + " "
						+ Строка(КонтактИнфоАдресата.Вид) + ": " + КонтактИнфоАдресата.ЗначенияПолей;
					
				КонецЕсли;	
				
			КонецЦикла;	
			
			КонтактноеЛицоОбъект.Комментарий = КонтактноеЛицоОбъект.Комментарий + " " + НеиспользованныеПоля;
			КонтактноеЛицоОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(Контакт);
			
		КонецЕсли;	
		
	КонецЕсли;	
	
	// Пометим на удаление личный адресат
	ПометитьНаУдаление(ЛичныйАдресат, Истина, УникальныйИдентификатор);
	
	Возврат Истина;
	
КонецФункции

// Пометить на удаление личного адресата
Процедура ПометитьНаУдаление(Ссылка, Пометка, УникальныйИдентификатор = Неопределено) Экспорт
	
	ЗаблокироватьДанныеДляРедактирования(Ссылка, , УникальныйИдентификатор);
	СправочникОбъект = Ссылка.ПолучитьОбъект();
	СправочникОбъект.УстановитьПометкуУдаления(Пометка, Истина);
	РазблокироватьДанныеДляРедактирования(Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

