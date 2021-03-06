﻿
// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда 
		Возврат;
	КонецЕсли;
	
	// Создание структуры с реквизитами обработки.
	
	Элементы.НадписьЛогина.Заголовок = НСтр("ru = 'Логин:'; en = 'Login:'") + " " + Параметры.login;
	
	СтатусФормы      = Параметры.statusApplicationFormED;
	НомерЗаявки      = Параметры.numberRequestED;
	СтрокаДатаЗаявки = Параметры.dateRequestED;
	СтатусЗаявки     = Параметры.applicationStatusED;
	
	Если НЕ ПустаяСтрока(СтрокаДатаЗаявки) Тогда
		Попытка
			ДатаЗаявки = Дата(СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрокаДатаЗаявки, "-", "")," ",""), ":",""));
		Исключение
			ДатаЗаявки = Дата(1,1,1);
		КонецПопытки;
	Иначе
		ДатаЗаявки = Дата(1,1,1);
	КонецЕсли;
	
	Если СтатусФормы = "new" ИЛИ НЕ ЗначениеЗаполнено(СтатусФормы) Тогда
		
		Элементы.НадписьЗаголовкаФормы.Заголовок = НСтр("ru = 'Заявка на регистрацию участника обмена ЭД'; en = 'Request for registration of EDI participant'");
		Элементы.НадписьСтатусаЗаявки.Заголовок = НСтр("ru = 'Новая заявка'; en = 'New request'");
		Элементы.ОтправитьЗаявку.Видимость = Истина;
		
		Элементы.СтраницыЗаявкиНаРегистрацию.ТекущаяСтраница = Элементы.СтраницаЗаявкиНаРегистрацию;
		
	ИначеЕсли СтатусФормы = "change" Тогда
		
		Элементы.НадписьЗаголовкаФормы.Заголовок = НСтр("ru = 'Изменение данных участника обмена ЭД'; en = 'Changing data of EDI participant'");
		Элементы.НадписьСтатусаЗаявки.Заголовок = НСтр("ru = 'Новая заявка'; en = 'New request'");
		Элементы.ОтправитьЗаявку.Видимость = Истина;
		
		Элементы.СтраницыЗаявкиНаРегистрацию.ТекущаяСтраница = Элементы.СтраницаЗаявкиНаИзменение;
		
	ИначеЕсли СтатусФормы = "show" Тогда
		
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Заявка №%1 от %2'; en = 'Request №%1 of %2'"),
			НомерЗаявки,
			Формат(ДатаЗаявки, "ДЛФ=DDT"));
		
		Элементы.НадписьЗаголовкаФормы.Заголовок = ТекстЗаголовка;
		
		Элементы.ОтправитьЗаявку.Видимость = Ложь;
		Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
		
		СертификатЭП = Параметры.nameCertificateED;
		
		Если НЕ ЗначениеЗаполнено(СертификатЭП) Тогда
			Элементы.СертификатЭП.Видимость = Ложь;
		КонецЕсли;
		
		Элементы.СертификатЭП.КнопкаВыбора = Ложь;
		Элементы.СтраницыЗаявкиНаРегистрацию.ТекущаяСтраница = Элементы.СтраницаЗаявкиНаИзменение;
		ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтатусЗаявки) ИЛИ СтатусЗаявки = "none" Тогда
		
		ТекстСтатуса = НСтр("ru='Новая заявка.'; en = 'New request.'");
		Элементы.НадписьПричина.Видимость = Ложь;
		
	ИначеЕсли СтатусЗаявки = "notconsidered" Тогда
		
		ТекстСтатуса = НСтр("ru='Заявка оператором еще не рассмотрена.'; en = 'Request is not yet considered by the operator.'");
		Элементы.НадписьПричина.Видимость = Ложь;
		
	ИначеЕсли СтатусЗаявки = "rejected" Тогда
		
		ТекстСтатуса = НСтр("ru='Заявка оператором отклонена.'; en = 'Operator rejected request.'");
		Элементы.НадписьПричина.Видимость = Истина;
		
	Иначе
		
		// Статус заявки - "obtained".
		ТекстСтатуса = НСтр("ru='Заявка успешно выполнена оператором'; en = 'Operator performed request successfully'");
		Элементы.НадписьПричина.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.НадписьСтатусаЗаявки.Заголовок = ТекстСтатуса;
	
	// Обновление сведений об организации
	ОбновитьСведенияОбОрганизации();
	
	Если ТолькоПросмотр Тогда
		Элементы.Адрес.КнопкаВыбора   = Ложь;
		Элементы.Адрес.КнопкаОткрытия = Истина;
	Иначе
		Элементы.Адрес.КнопкаВыбора   = Истина;
		Элементы.Адрес.КнопкаОткрытия = Ложь;
	КонецЕсли;
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаПояснение.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаСведенийОбОрганизации.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.ГруппаКонтактнойИнформации.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.ГруппаСведенийОРуководителеОрганизации.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ПрограммноеЗакрытие Тогда
		
		Если Модифицированность Тогда
			
			Отказ = Истина;
			Если ЗавершениеРаботы Тогда
				ТекстПредупреждения =
					НСтр("ru = 'Заявка на регистрацию данных участника обмена электронными документами не отправлена.'; en = 'Application for registration of the EDI participant was not sent.'");
			Иначе
				ОписаниеОповещения = Новый ОписаниеОповещения(
					"ПриОтветеНаВопросОЗакрытииМодифицированнойФормы",
					ЭтотОбъект);
				
				ТекстВопроса = НСтр("ru = 'Данные заявки изменены. Закрыть форму без сохранения данных?'; en = 'Application data was changed. Close the form without saving any data?'");
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
			Возврат;
			
		КонецЕсли;
		
		Если Не ЗавершениеРаботы И СтатусФормы <> "show" И Не НажатаКнопкаОтправить Тогда
			// Обработать закрытие формы в бизнес-процессе.
			
			ПараметрыЗапроса = Новый Массив;
			ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "endForm", "close"));
			ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(
				КонтекстВзаимодействия,
				ЭтотОбъект,
				ПараметрыЗапроса);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Подготовка данных и открытие формы для ввода адреса
	СтандартнаяОбработка = Ложь;
	ВыбратьАдрес(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьАдрес(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПричинаНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ПоказатьПричинуОтклоненияЗаявкиЭДО(КонтекстВзаимодействия);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыходНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	
	НастройкиПоЮрФизЛицу();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияТехПоддержкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = '%1.
			|
			|%2';
			|en = '%1.
			|
			|%2'");
		
		Если СтатусФормы = "new" ИЛИ ПустаяСтрока(СтатусФормы) Тогда
			ЧтоНеПолучилось = НСтр("ru = 'Не получается отправить заявку на регистрацию участника обмена ЭД'; en = 'Unable to send application for EDI participant registration'");
		ИначеЕсли СтатусФормы = "change" Тогда
			ЧтоНеПолучилось = НСтр("ru = 'Не получается отправить заявку на изменение данных участника обмена ЭД'; en = 'Unable to send application to change EDI participant data'");
		ИначеЕсли СтатусФормы = "show" Тогда
			ЧтоНеПолучилось = НСтр("ru = 'Возникли проблемы с заявкой участника обмена ЭД'; en = 'There were problems with the application of EDI participant'");
		КонецЕсли;
		
		ЛогинПользователя = ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
			КонтекстВзаимодействия.КСКонтекст,
			"login");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			ЧтоНеПолучилось,
			Подключение1СТакскомКлиент.ТекстТехническихПараметровЭДО(КонтекстВзаимодействия, СертификатЭП));
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка. Заявка на регистрацию участника обмена ЭД в 1С-Такском'; en = 'Online support. Application for registration of the EDI participant in 1C-Taxcom'"),
			ТекстСообщения,
			"taxcom",
			,
			Новый Структура("Логин, Пароль",
				ЛогинПользователя,
				ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"password")));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьЗаявку(Команда)
	
	// Проверка заполнения необходимых полей
	Ошибка = Ложь;
	
	Если ПустаяСтрока(Организация) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Организация""'; en = '""Company"" field is not filled in'");
		Сообщение.Поле = "Организация";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(Адрес) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Адрес""'; en = '""Address"" field is not filled in'");
		Сообщение.Поле = "Адрес";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(Телефон) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Телефон""'; en = '""Phone"" field is not filled in'");
		Сообщение.Поле = "Телефон";
		Сообщение.Сообщить();
	КонецЕсли;
	
	// Проверка адреса
	
	Если ПустаяСтрока(КодРегиона) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст =
			НСтр("ru ='Не указан ""Код региона"" (Код региона нужно указать в форме ""Адрес участника обмена ЭД"")'; en = '""Region code"" field is not filled in (the region code must be specified in the form ""Address of EDI participant"")'");
		Сообщение.Поле = "Адрес";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(ИНН) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""ИНН""'; en = '""TIN"" field is not filled in'");
		Сообщение.Поле = "ИНН";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ЮрФизЛицо <> "ЮрЛицо" И ЮрФизЛицо <> "ФизЛицо" Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не выбран тип организации (юридическое или физическое лицо)'; en = 'Company type, legal or natural entity, is not specified'");
		Сообщение.Поле = "ЮрФизЛицо";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(КПП) И ЮрФизЛицо = "ЮрЛицо" Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""КПП""'; en = '""TRRC"" field is not filled in'");
		Сообщение.Поле = "КПП";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(ОГРН) И ЮрФизЛицо = "ЮрЛицо" Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""ОГРН""'; en = '""PSRN"" field is not filled in'");
		Сообщение.Поле = "ОГРН";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(КодНалоговогоОргана) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Код налогового органа""'; en = '""Tax authority code"" field is not filled in'");
		Сообщение.Поле = "КодНалоговогоОргана";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(Фамилия) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Фамилия""'; en = '""Surname"" field is not filled in'");
		Сообщение.Поле = "Фамилия";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(Имя) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Имя""'; en = '""Name"" field is not filled in'");
		Сообщение.Поле = "Имя";
		Сообщение.Сообщить();
	КонецЕсли;
	
	// Дополнительные проверки
	
	Если НЕ ПустаяСтрока(Телефон) Тогда
		Если СтрДлина(Телефон) > 20 Тогда
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='""Телефон"" должен содержать не более 20 символов'; en = '""Phone"" should contain no more than 20 characters'");
			Сообщение.Поле = "Телефон";
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(КодРегиона) Тогда
		Попытка
			КодРегионаЧисло = Число(СокрЛП(КодРегиона));
			Если СтрДлина(СокрЛП(КодРегиона)) <> 2 Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='""Код региона"" должен содержать 2 цифры'; en = '""Region code"" must contain 2 digits'");
				Сообщение.Поле = "Адрес";
				Сообщение.Сообщить();
			Иначе
				Если КодРегионаЧисло > 99 ИЛИ КодРегионаЧисло < 1 Тогда
					Ошибка    = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = НСтр("ru ='""Код региона"" должен быть от 01 до 99'; en = '""Region code"" must be between 01 to 99'");
					Сообщение.Поле = "КодРегиона";
					Сообщение.Сообщить();
				КонецЕсли;
			КонецЕсли;
		Исключение
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='В ""Коде региона"" использованы недопустимые символы'; en = '""Region code"" contains invalid characters'");
			Сообщение.Поле = "Адрес";
			Сообщение.Сообщить();
		КонецПопытки;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИНН) Тогда
		Попытка
			ИННЧисло = Число(СокрЛП(ИНН));
			Если СтрДлина(СокрЛП(ИНН)) <> 12 И ЮрФизЛицо = "ФизЛицо" Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='""ИНН"" должен содержать 12 цифр'; en = '""TIN"" must contain 12 digits'");
				Сообщение.Поле = "ИНН";
				Сообщение.Сообщить();
			ИначеЕсли СтрДлина(СокрЛП(ИНН)) <> 10 И ЮрФизЛицо = "ЮрЛицо" Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='""ИНН"" должен содержать 10 цифр'; en = '""TIN"" must contain 10 digits'");
				Сообщение.Поле = "ИНН";
				Сообщение.Сообщить();
			КонецЕсли;
		Исключение
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='В ""ИНН"" использованы недопустимые символы'; en = '""TIN"" contains invalid characters'");
			Сообщение.Поле = "ИНН";
			Сообщение.Сообщить();
		КонецПопытки;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(КПП) Тогда
		Попытка
			КППЧисло = Число(СокрЛП(КПП));
			Если СтрДлина(СокрЛП(КПП)) <> 9 Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='""КПП"" должен содержать 9 цифр'; en = '""TRRC"" must contain 9 digits'");
				Сообщение.Поле = "КПП";
				Сообщение.Сообщить();
			КонецЕсли;
		Исключение
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='В ""КПП"" использованы недопустимые символы'; en = '""TRRC"" contains invalid characters'");
			Сообщение.Поле = "КПП";
			Сообщение.Сообщить();
		КонецПопытки;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ОГРН) Тогда
		Попытка
			ОГРНЧисло = Число(СокрЛП(ОГРН));
			Если СтрДлина(СокрЛП(ОГРН)) <> 13  И ЮрФизЛицо = "ЮрЛицо" Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='""ОГРН"" должен содержать 13 цифр'; en = '""PSRN"" must contain 13 digits'");
				Сообщение.Поле = "ОГРН";
				Сообщение.Сообщить();
			ИначеЕсли СтрДлина(СокрЛП(ОГРН)) <> 15  И ЮрФизЛицо = "ФизЛицо" Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='""ОГРН"" должен содержать 15 цифр'; en = '""PSRN"" must contain 15 digits'");
				Сообщение.Поле = "ОГРН";
				Сообщение.Сообщить();
			КонецЕсли;
		Исключение
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='В ""ОГРН"" использованы недопустимые символы'; en = '""PSRN"" contains invalid characters'");
			Сообщение.Поле = "ОГРН";
			Сообщение.Сообщить();
		КонецПопытки;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(КодНалоговогоОргана) Тогда
		Попытка
			КодНалоговогоОрганаЧисло = Число(СокрЛП(КодНалоговогоОргана));
			Если СтрДлина(СокрЛП(КодНалоговогоОргана)) <> 4 Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='""Код налогового органа"" должен содержать 4 цифры'; en = '""ax authority code"" must contain 4 digits'");
				Сообщение.Поле = "КодНалоговогоОргана";
				Сообщение.Сообщить();
			КонецЕсли;
		Исключение
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='В ""Коде налогового органа"" использованы недопустимые символы'; en = '""Tax authority code"" contains invalid characters'");
			Сообщение.Поле = "КодНалоговогоОргана";
			Сообщение.Сообщить();
		КонецПопытки;
	КонецЕсли;
	
	Если Ошибка Тогда
		Возврат;
	КонецЕсли;
	
	// Передача данных на сервер
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "endForm"           , "send"));
	// Это признак нажатия кнопки "Отправить"
	
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "postindexED"       , Индекс));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressregionED"   , Регион));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "codregionED"       , КодРегиона));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addresstownshipED" , Район));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addresscityED"     , Город));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addresslocalityED" , НаселенныйПункт));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressstreetED"   , Улица));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressbuildingED" , Дом));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addresshousingED"  , Корпус));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressapartmentED", Квартира));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressphoneED"    , Телефон));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "agencyED"          , Организация));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "innED"             , ИНН));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "kppED"             , КПП));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "ogrnED"            , ОГРН));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "codeimnsED"        , КодНалоговогоОргана));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "lastnameED"        , Фамилия));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "firstnameED"       , Имя));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "middlenameED"      , Отчество));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "identifierTaxcomED", ИдентификаторОрганизации));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "orgindED"          , ЮрФизЛицо));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressED"         , Адрес));
	
	Если СтатусФормы <> "show" Тогда
		
		Если ЗначениеЗаполнено(СертификатЭП) Тогда
			
			ПрежнийСертификат = ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
				КонтекстВзаимодействия.КСКонтекст,
				"IDCertificateED");
			
			ПредставлениеСертификата = "";
			ДвоичныеДанныеСертификата = ДвоичныеДанныеСертификата(СертификатЭП, ПредставлениеСертификата);
			
			Если СертификатЭП <> ПрежнийСертификат Тогда
				
				ИнтернетПоддержкаПользователейКлиентСервер.ЗаписатьПараметрКонтекста(
					КонтекстВзаимодействия.КСКонтекст,
					"IDCertificateED_Dop",
					СертификатЭП);
				
			КонецЕсли;
			
			ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "nameCertificateED", ПредставлениеСертификата));
			
			Если ДвоичныеДанныеСертификата <> Неопределено Тогда
				
				СтрокаBase64 = Base64Строка(ДвоичныеДанныеСертификата);
				ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "certificateED", СтрокаBase64));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЭтотОбъект.Модифицированность = Ложь;
	НажатаКнопкаОтправить = Истина;
	
	// Отправить параметры на сервер
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура, которая получает сведения об организации
// из конфигурации по данным организации.
&НаСервере
Процедура ОбновитьСведенияОбОрганизации()
	
	ЮрФизЛицо                = Параметры.orgindED;
	Индекс                   = Параметры.postindexED;
	Регион                   = Параметры.addressregionED;
	КодРегиона               = Параметры.coderegionED;
	Район                    = Параметры.addresstownshipED;
	Город                    = Параметры.addresscityED;
	НаселенныйПункт          = Параметры.addresslocalityED;
	Улица                    = Параметры.addressstreetED;
	Дом                      = Параметры.addressbuildingED;
	Корпус                   = Параметры.addresshousingED;
	Квартира                 = Параметры.addressapartmentED;
	Телефон                  = Параметры.addressphoneED;
	Организация              = Параметры.agencyED;
	ИНН                      = Параметры.innED;
	КПП                      = Параметры.kppED;
	ОГРН                     = Параметры.ogrnED;
	КодНалоговогоОргана      = Параметры.codeimnsED;
	Фамилия                  = Параметры.lastnameED;
	Имя                      = Параметры.firstnameED;
	Отчество                 = Параметры.middlenameED;
	ИдентификаторОрганизации = Параметры.identifierTaxcomED;
	
	Если СтатусФормы <> "show" Тогда
		СертификатЭП = Параметры.IDCertificateED;
	КонецЕсли;
	
	СформироватьАдрес();
	
	ЮрФизЛицо = ?(ПустаяСтрока(ЮрФизЛицо), "ЮрЛицо", ЮрФизЛицо);
	
	НастройкиПоЮрФизЛицу();
	
КонецПроцедуры

// Процедура настройки доступности элементов формы
// в зависимости от переключателя ЮрФизЛицо.
&НаСервере
Процедура НастройкиПоЮрФизЛицу()
	
	Если ЮрФизЛицо = "ЮрЛицо" Тогда
		Элементы.КПП.Доступность = Истина;
		Элементы.КПП.АвтоОтметкаНезаполненного = Истина;
		Элементы.ОГРН.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.КПП.Доступность = Ложь;
		Элементы.КПП.АвтоОтметкаНезаполненного  = Ложь;
		Элементы.ОГРН.АвтоОтметкаНезаполненного = Ложь;
		КПП = "";
	КонецЕсли;
	
КонецПроцедуры

// Выполняет формирование строки адреса по реквизитам адреса
&НаСервере
Процедура СформироватьАдрес()
	
	Адр = "";
	
	ДобавитьПодстроку(Адр, Индекс);
	ДобавитьПодстроку(Адр, Регион);
	ДобавитьПодстроку(Адр, КодРегиона, "регион ");
	ДобавитьПодстроку(Адр, Район);
	ДобавитьПодстроку(Адр, Город);
	ДобавитьПодстроку(Адр, НаселенныйПункт);
	ДобавитьПодстроку(Адр, Улица);
	ДобавитьПодстроку(Адр, Дом     , "д. ");
	ДобавитьПодстроку(Адр, Корпус  , "корп. ");
	ДобавитьПодстроку(Адр, Квартира, "кв. ");
	
	Адрес = Адр;
	
КонецПроцедуры

// Процедура добавления подстроки к строке
// Параметры:
// - ИсходнаяСтрока - Строка - исходная строка;
// - Подстрока      - Строка - строка, которая должна быть добавлена в конец исходной строки;
// - Префикс        - Строка - строка, которая добавляется перед подстрокой;
// - Разделитель    - строка - строка, которая служит разделителем между строкой и подстрокой.
//
&НаСервере
Процедура ДобавитьПодстроку(ИсходнаяСтрока, Знач Подстрока, Префикс = "", Разделитель = ", ")
	
	Если НЕ ПустаяСтрока(ИсходнаяСтрока) И НЕ ПустаяСтрока(Подстрока) Тогда
		ИсходнаяСтрока = ИсходнаяСтрока + Разделитель;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Подстрока) Тогда
		ИсходнаяСтрока = ИсходнаяСтрока + Префикс + Подстрока;
	КонецЕсли;
	
КонецПроцедуры

// Получает двоичные данные сертификата путем вызова соответствующей функции серверного
// переопределяемого модуля.
//
// Параметры:
// - СертификатСсылка (ЛюбаяСсылка) - ссылка на объект данных, содержащий данные сертификата.
//
// Возвращаемое значение: ДвоичныеДанные - если удалось получить двоичные данные сертификата,
//						  Неопределено - в противном случае.
//
&НаСервереБезКонтекста
Функция ДвоичныеДанныеСертификата(Знач СертификатСсылка, ПредставлениеСертификата)
	
	ПредставлениеСертификата = Строка(СертификатСсылка);
	ДвоичныеДанныеСертификата = Подключение1СТакском.ДвоичныеДанныеСертификата(СертификатСсылка);
	
	Возврат ДвоичныеДанныеСертификата;
	
КонецФункции

// Открывает форму выбора адреса в модальном режиме и возвращает
// реквизиты адреса в виде структуры с соответствующими полями.
//
// Параметры:
// - ТолькоДляПросмотра (Булево): Истина - открыть форму выбора адреса только для просмотра.
//
// Возвращаемое значение: Структура с полями - реквизитами адреса;
//						  Неопределено, если на форме адреса при закрытии не была нажата кнопка "ОК".
//
&НаКлиенте
Процедура ВыбратьАдрес(ТолькоДляПросмотра = Ложь)
	
	ПараметрыФормы = Новый Структура("ТолькоПросмотр", ТолькоДляПросмотра);
	
	Если ТолькоДляПросмотра Тогда
		ОповещениеОЗакрытии = Неопределено;
	Иначе
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПриВыбореАдреса", ЭтотОбъект);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Индекс"    , Индекс);
	ПараметрыФормы.Вставить("Регион"    , Регион);
	ПараметрыФормы.Вставить("Район"     , Район);
	ПараметрыФормы.Вставить("Город"     , Город);
	ПараметрыФормы.Вставить("НасПункт"  , НаселенныйПункт);
	ПараметрыФормы.Вставить("Улица"     , Улица);
	ПараметрыФормы.Вставить("Дом"       , Дом);
	ПараметрыФормы.Вставить("Корпус"    , Корпус);
	ПараметрыФормы.Вставить("Квартира"  , Квартира);
	ПараметрыФормы.Вставить("КодРегиона", КодРегиона);
	
	ФормаВводаАдреса = ОткрытьФорму("Обработка.Подключение1СТакском.Форма.АдресУчастникаОбменаЭД",
		ПараметрыФормы,
		,
		,
		,
		,
		ОповещениеОЗакрытии);
	
	ФормаВводаАдреса.КонтекстВзаимодействия = КонтекстВзаимодействия;
	ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ФормаВводаАдреса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореАдреса(ПараметрыАдреса, ДопПараметры) Экспорт
	
	Если ТипЗнч(ПараметрыАдреса) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	// Установка модифицированности по переданным данным
	Если НЕ ЭтотОбъект.Модифицированность Тогда
		Если    Индекс          <> ПараметрыАдреса.Индекс
			ИЛИ Регион          <> ПараметрыАдреса.Регион
			ИЛИ Район           <> ПараметрыАдреса.Район
			ИЛИ Город           <> ПараметрыАдреса.Город
			ИЛИ НаселенныйПункт <> ПараметрыАдреса.НаселенныйПункт
			ИЛИ Улица           <> ПараметрыАдреса.Улица
			ИЛИ Дом             <> ПараметрыАдреса.Дом
			ИЛИ Корпус          <> ПараметрыАдреса.Корпус
			ИЛИ Квартира        <> ПараметрыАдреса.Квартира
			ИЛИ КодРегиона      <> ПараметрыАдреса.КодРегиона Тогда
			
			ЭтотОбъект.Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Если адрес изменен, то применение изменений
	Индекс          = ПараметрыАдреса.Индекс;
	Регион          = ПараметрыАдреса.Регион;
	Район           = ПараметрыАдреса.Район;
	Город           = ПараметрыАдреса.Город;
	НаселенныйПункт = ПараметрыАдреса.НаселенныйПункт;
	Улица           = ПараметрыАдреса.Улица;
	Дом             = ПараметрыАдреса.Дом;
	Корпус          = ПараметрыАдреса.Корпус;
	Квартира        = ПараметрыАдреса.Квартира;
	КодРегиона      = ПараметрыАдреса.КодРегиона;
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОЗакрытииМодифицированнойФормы(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
