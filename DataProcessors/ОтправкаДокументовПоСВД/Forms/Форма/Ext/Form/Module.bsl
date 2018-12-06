﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		// Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокДокументовДляОтправкиПоСВД" Тогда
		ЗаполнитьСписокДокументов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбзорHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Лев(ДанныеСобытия.Href, 6) <> "v8doc:" Тогда 
		Возврат;
	КонецЕсли;
	НавигационнаяСсылкаПоля = Сред(ДанныеСобытия.Href, 7);
	
	ПерейтиПоНавигационнойСсылке(НавигационнаяСсылкаПоля);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументы

&НаКлиенте
Процедура ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ДокументыОтправить Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.ДокументыСостояние И Элементы.Документы.ТекущиеДанные.Состояние = 2 Тогда
		ОткрытьФорму("Справочник.ПравилаОтправкиСообщенийСВД.ФормаСписка");
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ключ", Элементы.Документы.ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикДокументыПриАктивизацииСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущийЭлемент.Имя = "ДокументыОтправить" Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Если Элементы.Документы.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ключ", Элементы.Документы.ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыФайлы

&НаКлиенте
Процедура ФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Строка = Файлы.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если Строка = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПерсональныеНастройки = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами();
	КакОткрывать = ПерсональныеНастройки.ДействиеПоДвойномуЩелчкуМыши;
	
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(, Строка.Ссылка);
		Возврат;
	КонецЕсли;
	
	ИмяКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	Если ИмяКаталога = Неопределено Или ПустаяСтрока(ИмяКаталога) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
		Строка.Ссылка,
		Неопределено,
		УникальныйИдентификатор,
		Неопределено,
		ПредыдущийАдресФайла);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	Обработчик = Новый ОписаниеОповещения("СписокВыборПослеВыбораРежимаРедактирования", 
		ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиКлиент.ВыбратьРежимИРедактироватьФайл(Обработчик, ДанныеФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеВыбораРежимаРедактирования(Результат, ПараметрыВыполнения) Экспорт
	
	РезультатОткрыть = "Открыть";
	РезультатРедактировать = "Редактировать";
	РезультатОткрытьКарточку = "ОткрытьКарточку";
	
	Если Результат = РезультатРедактировать Тогда
		Обработчик = Новый ОписаниеОповещения("СписокВыборПослеРедактированияФайла", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла);
	ИначеЕсли Результат = РезультатОткрыть Тогда
		РаботаСФайламиКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор); 
	ИначеЕсли Результат = РезультатОткрытьКарточку Тогда
		ПоказатьЗначение(, ПараметрыВыполнения.ДанныеФайла.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеРедактированияФайла(Результат, ПараметрыВыполнения) Экспорт
	
	ОповеститьОбИзменении(ПараметрыВыполнения.ДанныеФайла.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущийЭлемент.Имя = "ФайлыОтправить" Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Строка = Файлы.НайтиПоИдентификатору(Элемент.ТекущаяСтрока);
	Если Строка = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ключ", Строка.Ссылка);
	ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыОтправитьПриИзменении(Элемент)
	
	ФайлыОтправитьПриИзмененииНаСервере(
		Элементы.Файлы.ТекущиеДанные.Ссылка,
		Элементы.Документы.ТекущиеДанные.Ссылка,
		Элементы.Документы.ТекущиеДанные.Получатель,
		Элементы.Файлы.ТекущиеДанные.Отправить);
	
КонецПроцедуры

&НаСервере
Процедура ФайлыОтправитьПриИзмененииНаСервере(Файл, Документ, Получатель, Отправить)
	
	Запись = РегистрыСведений.ФайлыДокументовГотовыхКОтправкеПОСВД.СоздатьМенеджерЗаписи();
	Запись.Документ = Документ;
	Запись.Файл = Файл;
	Запись.Получатель = Получатель;
	
	Если Отправить Тогда
		Запись.Записать();
	Иначе
		Запись.Удалить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отправить(Команда)
	
	ТекстСообщения = НСтр("ru = 'Идет отправка документов по СВД...'; en = 'Sending documents via EDES...'");
	Состояние(ТекстСообщения);
	
	ДокументыНеВыбраны = Истина;
	ВозниклиОшибки = Ложь;
	
	КоличествоОтправленных = ОтправитьСервер(ДокументыНеВыбраны, ВозниклиОшибки);
	
	Если ДокументыНеВыбраны Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Отметьте хотя бы один документ.'; en = 'Mark at least one document.'"));
		Возврат;
	КонецЕсли;
	
	Если ВозниклиОшибки Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'При отправке некоторых документов возникли ошибки.
                                       |Их можно посмотреть в журнале регистрации.';
                                       |en = 'When sending some documents have any errors.
                                       |You can view in event log.'"));
	КонецЕсли;
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отправка документов по СВД завершена. Отправлено документов: %1.'; en = 'Sending documents via EDES is completed. Sent documents: %1.'"),
			КоличествоОтправленных);
	Состояние(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокДокументов(Команда)
	
	ЗаполнитьСписокДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокДокументов()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИсходящиеДокументы.Ссылка,
		|	ИсходящиеДокументы.Наименование КАК Наименование,
		|	ИсходящиеДокументы.ВидДокумента,
		|	ИсходящиеДокументы.ПодписанЭП,
		|	ИсходящиеДокументы.Организация КАК Отправитель,
		|	ИсходящиеДокументыПолучатели.Получатель КАК Получатель
		|ИЗ
		|	Справочник.ИсходящиеДокументы.Получатели КАК ИсходящиеДокументыПолучатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИсходящиеДокументы КАК ИсходящиеДокументы
		|		ПО (ИсходящиеДокументы.Ссылка = ИсходящиеДокументыПолучатели.Ссылка)
		|ГДЕ
		|	ИсходящиеДокументы.ГотовКОтправке = ИСТИНА
		|	И ИсходящиеДокументы.ПометкаУдаления = ЛОЖЬ
		|	И ИсходящиеДокументыПолучатели.СпособОтправки = ЗНАЧЕНИЕ(Справочник.СпособыДоставки.СВД)
		|	И ИсходящиеДокументыПолучатели.Отправлен = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	ТаблицаДокументов = РеквизитФормыВЗначение("Документы");
	ТаблицаДокументов.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицаДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Состояние = СКонтрагентомНастроенОбменПоСВД(Выборка.Отправитель, Выборка.Получатель, Выборка.ВидДокумента);
			
		Если Не Состояние.НастроенОбменПоСВД Тогда
			НоваяСтрока.Состояние = 2;
			НоваяСтрока.СостояниеТекст = НСтр("ru = 'Не настроен обмен.'; en = 'Not configured exchange.'");
		ИначеЕсли Состояние.ТребуетсяПодписьЭП И Не Выборка.ПодписанЭП Тогда
			НоваяСтрока.Состояние = 1;
			НоваяСтрока.СостояниеТекст = НСтр("ru = 'Не подписан ЭП уполномоченного сотрудника.'; en = 'Not signed by the DS of authorized employee.'")
		Иначе
			НоваяСтрока.Состояние = 0;
			НоваяСтрока.СостояниеТекст = НСтр("ru = 'Готов к отправке.'; en = 'Ready to send.'");
		КонецЕсли;
		
	КонецЦикла;
	
	ЭтаФорма.ЗначениеВРеквизитФормы(ТаблицаДокументов, "Документы");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СКонтрагентомНастроенОбменПоСВД(Организация, Контрагент, ВидДокумента)
	
	Результат = Новый Структура("НастроенОбменПоСВД, ТребуетсяПодписьЭП", Ложь, Ложь);
	Настройка = РаботаССВД.НайтиПравилоОтправкиСообщенийСВД(Организация, Контрагент, ВидДокумента);
	Если Настройка <> Неопределено Тогда
		Если Настройка.Транспорт.ФорматСообщения = Справочники.ФорматыСообщенийСВД.ОператорЭДО1СТакском Тогда
			Результат.НастроенОбменПоСВД = Истина;
			Если ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписи") Тогда
				Результат.ТребуетсяПодписьЭП = Истина;
			КонецЕсли;
		Иначе
			МенеджерЗаписиРегистра = РегистрыСведений.УчастникиСВД.СоздатьМенеджерЗаписи();
			МенеджерЗаписиРегистра.Адресат = Контрагент;
			МенеджерЗаписиРегистра.Транспорт = Настройка.Транспорт;
			МенеджерЗаписиРегистра.Прочитать();
			Если МенеджерЗаписиРегистра.Выбран() Тогда
				Результат.НастроенОбменПоСВД = Истина;
				Если ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписи")
					И Настройка.Транспорт.ФорматСообщения = Справочники.ФорматыСообщенийСВД.Сообщение1СДокументооборот Тогда
					Результат.ТребуетсяПодписьЭП = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ОтправитьСервер(ДокументыНеВыбраныВозврат = Истина, ВозниклиОшибкиВозврат = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаДокументов = РеквизитФормыВЗначение("Документы");
	КоличествоОтправленных = 0;
	
	Для Каждого ДанныеСтроки Из ТаблицаДокументов Цикл
		
		Если Не ДанныеСтроки.Отправить
			Или ДанныеСтроки.Отправить И ДанныеСтроки.Состояние <> 0 Тогда
			
			Продолжить;
		КонецЕсли;
		
		ДокументыНеВыбраныВозврат = Ложь;
		
		Документ = ДанныеСтроки.Ссылка;
		Получатель = ДанныеСтроки.Получатель;
		
		Получатели = Новый Массив;
		Получатели.Добавить(Получатель);
		
		ФайлыКОтправке = Новый Массив;
		
		ЗапросФайлов = Новый Запрос;
		ЗапросФайлов.Текст =
			"ВЫБРАТЬ
			|	Файлы.Файл
			|ИЗ
			|	РегистрСведений.ФайлыДокументовГотовыхКОтправкеПОСВД КАК Файлы
			|ГДЕ
			|	Файлы.Документ = &Документ
			|	И Файлы.Получатель = &Получатель";
		ЗапросФайлов.Параметры.Вставить("Документ", Документ);
		ЗапросФайлов.Параметры.Вставить("Получатель", Получатель);
		ВыборкаФайлов = ЗапросФайлов.Выполнить().Выбрать();
		
		Пока ВыборкаФайлов.Следующий() Цикл
			ФайлыКОтправке.Добавить(ВыборкаФайлов.Файл);
		КонецЦикла;
		
		// Отправка документа
		НачатьТранзакцию();
		Попытка
			
			ОтправкаПроизведена = РаботаССВД.ОтправитьПоСВД(Документ, Получатели, ФайлыКОтправке);
			
			Если ОтправкаПроизведена Тогда
				
				НаборЗаписей = РегистрыСведений.ФайлыДокументовГотовыхКОтправкеПОСВД.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Документ.Установить(Документ);
				НаборЗаписей.Отбор.Получатель.Установить(Получатель);
				НаборЗаписей.Записать();
				
				ОбработанныйДокумент = Документ.ПолучитьОбъект();
				ЗаблокироватьДанныеДляРедактирования(Документ);
				ОбработанныйДокумент.ГотовКОтправке = Ложь;
				ОбработанныйДокумент.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина); // чтобы прошла запись ранее подписанного объекта
				ОбработанныйДокумент.Записать();
				РазблокироватьДанныеДляРедактирования(Документ);
				
				КоличествоОтправленных = КоличествоОтправленных + 1;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			Инфо = ИнформацияОбОшибке();
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Отправка документа по СВД'; en = 'Sending document via EDES'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,
				Документ,
				ПодробноеПредставлениеОшибки(Инфо));
			ВозниклиОшибкиВозврат = Истина;
			
		КонецПопытки;
		
	КонецЦикла;
	
	ЗаполнитьСписокДокументов();
	
	Возврат КоличествоОтправленных;
	
КонецФункции

&НаКлиенте
Процедура ОбработчикДокументыПриАктивизацииСтроки()
	
	ТекущийДокумент = Неопределено;
	ТекущийПолучатель = Неопределено;
	
	Если Не Элементы.Документы.ТекущиеДанные = Неопределено Тогда
		ТекущийДокумент = Элементы.Документы.ТекущиеДанные.Ссылка;
		ТекущийПолучатель = Элементы.Документы.ТекущиеДанные.Получатель;
	КонецЕсли;
		
	ЗаполнитьСписокФайлов(ТекущийДокумент, ТекущийПолучатель);
	ПолучитьОбзорДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьОбзорДокумента()
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеМиникарточки = ОбзорСпискаДокументов.ПолучитьДанныеМиникарточки(ТекущийДокумент);
	ОбзорHTML = ДанныеМиникарточки.Обзор;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокФайлов(Документ = Неопределено, Получатель = Неопределено)
	
	Файлы.Очистить();
	
	Если Не ЗначениеЗаполнено(Документ) И Не ЗначениеЗаполнено(Получатель) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.Ссылка,
		|	ВЫБОР
		|		КОГДА ФайлыКОтправке.Файл ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Отправить,
		|	Файлы.Наименование КАК Наименование,
		|	ПОДСТРОКА(Файлы.Описание, 0, 140) КАК Описание,
		|	ВЫБОР
		|		КОГДА Файлы.ПометкаУдаления
		|			ТОГДА Файлы.ИндексКартинки + 1
		|		ИНАЧЕ Файлы.ИндексКартинки
		|	КОНЕЦ КАК ИндексКартинки,
		|	ВЫБОР
		|		КОГДА Файлы.Зашифрован
		|			ТОГДА ВЫБОР
		|					КОГДА КешИнформацииОбОбъектах.СтатусЭП = ЗНАЧЕНИЕ(Перечисление.СтатусПроверкиЭП.ПодписиНет)
		|						ТОГДА 0
		|					КОГДА КешИнформацииОбОбъектах.СтатусЭП = ЗНАЧЕНИЕ(Перечисление.СтатусПроверкиЭП.ПодписьНеПроверена)
		|						ТОГДА 2
		|					КОГДА КешИнформацииОбОбъектах.СтатусЭП = ЗНАЧЕНИЕ(Перечисление.СтатусПроверкиЭП.ПодписьДействительна)
		|						ТОГДА 4
		|					КОГДА КешИнформацииОбОбъектах.СтатусЭП = ЗНАЧЕНИЕ(Перечисление.СтатусПроверкиЭП.ПодписьНедействительна)
		|						ТОГДА 6
		|					ИНАЧЕ ВЫБОР
		|							КОГДА Файлы.ПодписанЭП
		|								ТОГДА 2
		|							ИНАЧЕ 0
		|						КОНЕЦ
		|				КОНЕЦ
		|		ИНАЧЕ ВЫБОР
		|				КОГДА КешИнформацииОбОбъектах.СтатусЭП = ЗНАЧЕНИЕ(Перечисление.СтатусПроверкиЭП.ПодписиНет)
		|					ТОГДА -1
		|				КОГДА КешИнформацииОбОбъектах.СтатусЭП = ЗНАЧЕНИЕ(Перечисление.СтатусПроверкиЭП.ПодписьНеПроверена)
		|					ТОГДА 1
		|				КОГДА КешИнформацииОбОбъектах.СтатусЭП = ЗНАЧЕНИЕ(Перечисление.СтатусПроверкиЭП.ПодписьДействительна)
		|					ТОГДА 3
		|				КОГДА КешИнформацииОбОбъектах.СтатусЭП = ЗНАЧЕНИЕ(Перечисление.СтатусПроверкиЭП.ПодписьНедействительна)
		|					ТОГДА 5
		|				ИНАЧЕ ВЫБОР
		|						КОГДА Файлы.ПодписанЭП
		|							ТОГДА 1
		|						ИНАЧЕ -1
		|					КОНЕЦ
		|			КОНЕЦ
		|	КОНЕЦ КАК СтатусПроверкиЭП,
		|	Файлы.Зашифрован
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФайлыДокументовГотовыхКОтправкеПоСВД КАК ФайлыКОтправке
		|		ПО (ФайлыКОтправке.Документ = Файлы.ВладелецФайла)
		|			И (ФайлыКОтправке.Получатель = &Получатель)
		|			И (ФайлыКОтправке.Файл = Файлы.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КешИнформацииОбОбъектах КАК КешИнформацииОбОбъектах
		|		ПО Файлы.Ссылка = КешИнформацииОбОбъектах.Объект
		|ГДЕ
		|	Файлы.ВладелецФайла = &ВладелецФайла
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
		
	Запрос.Параметры.Вставить("ВладелецФайла", Документ);
	Запрос.Параметры.Вставить("Получатель", Получатель);
	
	ТаблицаФайлов = РеквизитФормыВЗначение("Файлы");
	ТаблицаФайлов.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаФайлов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	ЭтаФорма.ЗначениеВРеквизитФормы(ТаблицаФайлов, "Файлы");
	
КонецПроцедуры

#КонецОбласти


