﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Из переданных имен файлов выделяются имена файлов данных и имена файлов их подписей.
// Сопоставление происходит по правилам формирования имени подписи и расширения файла подписи (p7s).
// Например:
//  Имя файла данных:  "example.txt"
//  имя файла подписи: "example-Ivanov Petr.p7s"
//  имя файла подписи: "example-Ivanov Petr (1).p7s".
//
// Параметры:
//  ИменаФайлов - Массив - имена файлов типа Строка.
//
// Возвращаемое значение:
//  Соответствие - содержит:
//   * Ключ     - Строка - имя файла.
//   * Значение - Массив - имена файлов подписей типа Строка.
// 
Функция ИменаФайловПодписейИменФайловДанных(ИменаФайлов) Экспорт
	
	ПерсональныеНастройки = ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки();
	РасширениеДляФайловПодписи = ПерсональныеНастройки.РасширениеДляФайловПодписи;
	
	Результат = Новый Соответствие;
	
	// Разделяем файлы по расширению.
	ИменаФайловДанных = Новый Массив;
	ИменаФайловПодписей = Новый Массив;
	
	Для Каждого ИмяФайла Из ИменаФайлов Цикл
		Если СтрЗаканчиваетсяНа(ИмяФайла, РасширениеДляФайловПодписи) Тогда
			ИменаФайловПодписей.Добавить(ИмяФайла);
		Иначе
			ИменаФайловДанных.Добавить(ИмяФайла);
		КонецЕсли;
	КонецЦикла;
	
	// Отсортируем имена файлов данных по убыванию числа символов в строке.
	
	Для ИндексА = 1 По ИменаФайловДанных.Количество() Цикл
		ИндексМАКС = ИндексА; // Считаем что текущий файл имеет самое большое число символов.
		Для ИндексБ = ИндексА+1 По ИменаФайловДанных.Количество() Цикл
			Если СтрДлина(ИменаФайловДанных[ИндексМАКС-1]) > СтрДлина(ИменаФайловДанных[ИндексБ-1]) Тогда
				ИндексМАКС = ИндексБ;
			КонецЕсли;
		КонецЦикла;
		своп = ИменаФайловДанных[ИндексА-1];
		ИменаФайловДанных[ИндексА-1] = ИменаФайловДанных[ИндексМАКС-1];
		ИменаФайловДанных[ИндексМАКС-1] = своп;
	КонецЦикла;
	
	// Поиск соответствий имен файлов.
	Для Каждого ИмяФайлаДанных Из ИменаФайловДанных Цикл
		Результат.Вставить(ИмяФайлаДанных, НайтиИменаФайловПодписей(ИмяФайлаДанных, ИменаФайловПодписей));
	КонецЦикла;
	
	// Оставшиеся файлы подписей не распознаны как подписи относящиеся к какому то файлу.
	Для Каждого ИмяФайлаПодписи Из ИменаФайловПодписей Цикл
		Результат.Вставить(ИмяФайлаПодписи, Новый Массив);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Функция МенеджерКриптографииОписанияПрограмм(Программа, Ошибки) Экспорт
	
	ОписанияПрограмм = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ОписанияПрограмм;
	
	Если Программа <> Неопределено Тогда
		ПрограммаНеНайдена = Истина;
		Для каждого ОписаниеПрограммы Из ОписанияПрограмм Цикл
			Если ОписаниеПрограммы.Ссылка = Программа Тогда
				ПрограммаНеНайдена = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ПрограммаНеНайдена Тогда
			МенеджерКриптографииДобавитьОшибку(Ошибки, Программа,
				НСтр("ru = 'Не предусмотрена для использования.'; en = 'Not available for use.'"), Истина);
			Возврат Неопределено;
		КонецЕсли;
		ОписанияПрограмм = Новый Массив;
		ОписанияПрограмм.Добавить(ОписаниеПрограммы);
	КонецЕсли;
	
	Возврат ОписанияПрограмм;
	
КонецФункции

// Только для внутреннего использования.
Функция МенеджерКриптографииСвойстваПрограммы(ОписаниеПрограммы, ЭтоLinux, Ошибки, ЭтоСервер,
			ПутиКПрограммамНаСерверахLinux = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ОписаниеПрограммы.ИмяПрограммы) Тогда
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
			НСтр("ru = 'Не указано имя программы.'; en = 'Program name is not specified.'"), Истина);
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОписаниеПрограммы.ТипПрограммы) Тогда
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
			НСтр("ru = 'Не указан тип программы.'; en = 'Program type is not specified.'"), Истина);
		Возврат Неопределено;
	КонецЕсли;
	
	СвойстваПрограммы = Новый Структура("ИмяПрограммы, ПутьКПрограмме, ТипПрограммы");
	
	Если ЭтоLinux Тогда
		Если ПутиКПрограммамНаСерверахLinux = Неопределено Тогда
			ПерсональныеНастройки = ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки();
			ПутьКПрограмме = ПерсональныеНастройки.ПутиКПрограммамЭлектроннойПодписиИШифрования.Получить(
				ОписаниеПрограммы.Ссылка);
		Иначе
			ПутьКПрограмме = ПутиКПрограммамНаСерверахLinux.Получить(ОписаниеПрограммы.Ссылка);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПутьКПрограмме) Тогда
			МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
				НСтр("ru = 'Не предусмотрена для использования.'; en = 'Not available for use.'"), ЭтоСервер, , , Истина);
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ПутьКПрограмме = "";
	КонецЕсли;
	
	СвойстваПрограммы = Новый Структура;
	СвойстваПрограммы.Вставить("ИмяПрограммы",   ОписаниеПрограммы.ИмяПрограммы);
	СвойстваПрограммы.Вставить("ПутьКПрограмме", ПутьКПрограмме);
	СвойстваПрограммы.Вставить("ТипПрограммы",   ОписаниеПрограммы.ТипПрограммы);
	
	Возврат СвойстваПрограммы;
	
КонецФункции

// Только для внутреннего использования.
Функция МенеджерКриптографииАлгоритмыУстановлены(ОписаниеПрограммы, Менеджер, Ошибки) Экспорт
	
	АлгоритмПодписи = Строка(ОписаниеПрограммы.АлгоритмПодписи);
	Попытка
		Менеджер.АлгоритмПодписи = АлгоритмПодписи;
	Исключение
		Менеджер = Неопределено;
		// Платформа использует обобщенное сообщение "Неизвестный алгоритм криптографии". Требуется более конкретное.
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбран неизвестный алгоритм подписи ""%1"".'; en = 'Unknown signature algorithm selected: ""%1"".'"), АлгоритмПодписи), Истина);
		Возврат Ложь;
	КонецПопытки;
	
	АлгоритмХеширования = Строка(ОписаниеПрограммы.АлгоритмХеширования);
	Попытка
		Менеджер.АлгоритмХеширования = АлгоритмХеширования;
	Исключение
		Менеджер = Неопределено;
		// Платформа использует обобщенное сообщение "Неизвестный алгоритм криптографии". Требуется более конкретное.
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбран неизвестный алгоритм хеширования ""%1"".'; en = 'Unknown hashing algorithm selected: ""%1"".'"), АлгоритмХеширования), Истина);
		Возврат Ложь;
	КонецПопытки;
	
	АлгоритмШифрования = Строка(ОписаниеПрограммы.АлгоритмШифрования);
	Попытка
		Менеджер.АлгоритмШифрования = АлгоритмШифрования;
	Исключение
		Менеджер = Неопределено;
		// Платформа использует обобщенное сообщение "Неизвестный алгоритм криптографии". Требуется более конкретное.
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбран неизвестный алгоритм шифрования ""%1"".'; en = 'Unknown encryption algorithm selected: ""%1"".'"), АлгоритмШифрования), Истина);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Процедура МенеджерКриптографииПрограммаНеНайдена(ОписаниеПрограммы, Ошибки, ЭтоСервер) Экспорт
	
	МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка,
		НСтр("ru = 'Программа не найдена на компьютере.'; en = 'Program not found on the computer.'"), ЭтоСервер, Истина);
	
КонецПроцедуры

// Только для внутреннего использования.
Функция МенеджерКриптографииИмяПрограммыСовпадает(ОписаниеПрограммы, ИмяПрограммыПолученное, Ошибки, ЭтоСервер) Экспорт
	
	Если ИмяПрограммыПолученное <> ОписаниеПрограммы.ИмяПрограммы Тогда
		МенеджерКриптографииДобавитьОшибку(Ошибки, ОписаниеПрограммы.Ссылка, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получена другая программа с именем ""%1"".'; en = 'Obtained another program named ""%1"".'"), ИмяПрограммыПолученное), ЭтоСервер, Истина);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Только для внутреннего использования.
Процедура МенеджерКриптографииДобавитьОшибку(Ошибки, Программа, Описание,
			КАдминистратору, Инструкция = Ложь, ИзИсключения = Ложь, НеУказанПуть = Ложь) Экспорт
	
	СвойстваОшибки = Новый Структура;
	СвойстваОшибки.Вставить("Программа",         Программа);
	СвойстваОшибки.Вставить("Описание",          Описание);
	СвойстваОшибки.Вставить("КАдминистратору",   КАдминистратору);
	СвойстваОшибки.Вставить("Инструкция",        Инструкция);
	СвойстваОшибки.Вставить("ИзИсключения",      ИзИсключения);
	СвойстваОшибки.Вставить("НеУказанПуть",      НеУказанПуть);
	СвойстваОшибки.Вставить("НастройкаПрограмм", Истина);
	
	Ошибки.Добавить(СвойстваОшибки);
	
КонецПроцедуры

// Только для внутреннего использования.
Функция РежимыПроверкиСертификата(ИгнорироватьВремяДействия = Ложь) Экспорт
	
	МассивРежимовПроверки = Новый Массив;
	МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.РазрешитьТестовыеСертификаты);
	
	//Если ИгнорироватьВремяДействия Тогда
	//	МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.ИгнорироватьВремяДействия);
	//КонецЕсли;
	
	Возврат МассивРежимовПроверки;
	
КонецФункции

// Только для внутреннего использования.
Функция СертификатПросрочен(Сертификат, НаДату) Экспорт
	
	Если Не ЗначениеЗаполнено(НаДату) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Сертификат.ДатаОкончания > НачалоДня(НаДату) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'На %1 просрочен сертификат.'; en = 'At %1 certificate is expired.'"), Формат(НачалоДня(НаДату), "ДЛФ=D"));
	
КонецФункции

// Только для внутреннего использования.
Функция ТипХранилищаДляПоискаСертификата(ТолькоВЛичномХранилище) Экспорт
	
	Если ТипЗнч(ТолькоВЛичномХранилище) = Тип("ТипХранилищаСертификатовКриптографии") Тогда
		ТипХранилища = ТолькоВЛичномХранилище;
	ИначеЕсли ТолькоВЛичномХранилище Тогда
		ТипХранилища = ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты;
	Иначе
		ТипХранилища = Неопределено; // Хранилище, содержащее сертификаты всех доступных типов.
	КонецЕсли;
	
	Возврат ТипХранилища;
	
КонецФункции

// Только для внутреннего использования.
Процедура ДобавитьСвойстваСертификатов(Таблица, МассивСертификатов, БезОтбора, ТолькоОтпечатки = Ложь, ВОблачномСервисе = Ложь) Экспорт
	
	#Если ВебКлиент Или ТонкийКлиент Тогда
		ДатаУниверсальная = ОбщегоНазначенияКлиент.ДатаУниверсальная();
	#Иначе
		ДатаУниверсальная = ТекущаяУниверсальнаяДата();
	#КонецЕсли
	
	Если ТолькоОтпечатки Тогда
		ОтпечаткиУжеДобавленныхСертификатов = Таблица;
		НаСервере = Ложь;
	Иначе
		ОтпечаткиУжеДобавленныхСертификатов = Новый Соответствие; // Для пропуска дублей.
		НаСервере = ТипЗнч(Таблица) <> Тип("Массив");
	КонецЕсли;
	
	Для Каждого ТекущийСертификат Из МассивСертификатов Цикл
		Отпечаток = Base64Строка(ТекущийСертификат.Отпечаток);
		
		Если ТекущийСертификат.ДатаОкончания <= ДатаУниверсальная Тогда
			Если Не БезОтбора Тогда
				Продолжить; // Пропуск просроченных сертификатов.
			КонецЕсли;
		КонецЕсли;
		
		Если ОтпечаткиУжеДобавленныхСертификатов.Получить(Отпечаток) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ОтпечаткиУжеДобавленныхСертификатов.Вставить(Отпечаток, Истина);
		
		Если ТолькоОтпечатки Тогда
			Продолжить;
		КонецЕсли;
		
		Если НаСервере Тогда
			Строка = Таблица.Найти(Отпечаток, "Отпечаток");
			Если Строка <> Неопределено Тогда
				Если ВОблачномСервисе Тогда
					Строка.ВОблачномСервисе = Истина;
				КонецЕсли;
				Продолжить; // Пропуск уже добавленных на клиенте.
			КонецЕсли;
		КонецЕсли;
		
		СвойстваСертификата = Новый Структура;
		СвойстваСертификата.Вставить("Отпечаток", Отпечаток);
		
		СвойстваСертификата.Вставить("Представление",
			ЭлектроннаяПодписьКлиентСервер.ПредставлениеСертификата(ТекущийСертификат));
		
		СвойстваСертификата.Вставить("КемВыдан",
			ЭлектроннаяПодписьКлиентСервер.ПредставлениеИздателя(ТекущийСертификат));
		
		Если ТипЗнч(Таблица) = Тип("Массив") Тогда
			Таблица.Добавить(СвойстваСертификата);
		Иначе
			Если ВОблачномСервисе Тогда
				СвойстваСертификата.Вставить("ВОблачномСервисе", Истина);
			ИначеЕсли НаСервере Тогда
				СвойстваСертификата.Вставить("НаСервере", Истина);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(Таблица.Добавить(), СвойстваСертификата);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ДобавитьОтпечаткиСертификатов(Массив, МассивСертификатов) Экспорт
	
	#Если ВебКлиент Или ТонкийКлиент Тогда
		ДатаУниверсальная = ОбщегоНазначенияКлиент.ДатаУниверсальная();
	#Иначе
		ДатаУниверсальная = ТекущаяУниверсальнаяДата();
	#КонецЕсли
	
	Для Каждого ТекущийСертификат Из МассивСертификатов Цикл
		Отпечаток = Base64Строка(ТекущийСертификат.Отпечаток);
		
		Если ТекущийСертификат.ДатаОкончания <= ДатаУниверсальная Тогда
			Продолжить; // Пропуск просроченных сертификатов.
		КонецЕсли;
		
		Массив.Добавить(Отпечаток);
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция СвойстваПодписи(ДвоичныеДанныеПодписи, СвойстваСертификата, Комментарий, ИмяФайлаПодписи = "") Экспорт
	
	СвойстваПодписи = Новый Структура;
	СвойстваПодписи.Вставить("Подпись",             ДвоичныеДанныеПодписи);
	СвойстваПодписи.Вставить("УстановившийПодпись", ПользователиКлиентСервер.АвторизованныйПользователь());
	СвойстваПодписи.Вставить("Комментарий",         Комментарий);
	СвойстваПодписи.Вставить("ИмяФайлаПодписи",     ИмяФайлаПодписи);
	СвойстваПодписи.Вставить("ДатаПодписи",         Дата('00010101')); // Устанавливается перед записью.
	СвойстваПодписи.Вставить("ДатаПроверкиПодписи", Дата('00010101')); // Дата последней проверки подписи.
	СвойстваПодписи.Вставить("ПодписьВерна",        Ложь);             // Результат последней проверки подписи.
	// Производные свойства:
	СвойстваПодписи.Вставить("Сертификат",          СвойстваСертификата.ДвоичныеДанные);
	СвойстваПодписи.Вставить("Отпечаток",           СвойстваСертификата.Отпечаток);
	СвойстваПодписи.Вставить("КомуВыданСертификат", СвойстваСертификата.КомуВыдан);
	
	Возврат СвойстваПодписи;
	
КонецФункции

// Только для внутреннего использования.
Функция ЗаголовокОшибкиПолученияДанных(Операция) Экспорт
	
	Если Операция = "Подписание" Тогда
		Возврат НСтр("ru = 'При получении данных для подписания возникла ошибка:'; en = 'When obtaining the data for signing an error occurred:'");
		
	ИначеЕсли Операция = "Шифрование" Тогда
		Возврат НСтр("ru = 'При получении данных для шифрования возникла ошибка:'; en = 'When obtaining the data for encryption an error occurred:'");
	Иначе
		Возврат НСтр("ru = 'При получении данных для расшифровки возникла ошибка:'; en = 'When obtaining the data for decryption an error occurred:'");
	КонецЕсли;
	
КонецФункции

// Только для внутреннего использования.
Функция ПустыеДанныеПодписи(ДанныеПодписи, ОписаниеОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(ДанныеПодписи) Тогда
		ОписаниеОшибки = НСтр("ru = 'Сформирована пустая подпись.'; en = 'Empty signature generated.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция ПустыеЗашифрованныеДанные(ЗашифрованныеДанные, ОписаниеОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(ЗашифрованныеДанные) Тогда
		ОписаниеОшибки = НСтр("ru = 'Сформированы пустые данные.'; en = 'Empty data generated.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция ПустыеРасшифрованныеДанные(РасшифрованныеДанные, ОписаниеОшибки) Экспорт
	
	Если Не ЗначениеЗаполнено(РасшифрованныеДанные) Тогда
		ОписаниеОшибки = НСтр("ru = 'Сформированы пустые данные.'; en = 'Empty data generated.'");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования.
Функция ДатаПодписанияУниверсальная(Подпись) Экспорт
	
#Если ВебКлиент Тогда
	
	СимволыБайт = СимволыБайтДвоичныхДанных(Подпись);
	ЗаголовокДаты = Символ(15) + Символ(23) + Символ(13);
	Позиция = СтрНайти(СимволыБайт, ЗаголовокДаты);
	
	Если Позиция = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДатаСтрокой = Сред(СимволыБайт, Позиция + 3, 12); // Дата в формате ASCII.
	ДатаПодписания = Дата("20" + ДатаСтрокой); // Универсальное время.
	
	Возврат ДатаПодписания;
	
#Иначе
	
	ДатаПодписания = Неопределено;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	Подпись.Записать(ИмяВременногоФайла);
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяВременногоФайла);
	Символ = ЧтениеТекста.Прочитать(1);
	
	Пока Символ <> Неопределено Цикл
		Если КодСимвола(Символ) = 15 Тогда
			Символ = ЧтениеТекста.Прочитать(2);
			Если КодСимвола(Символ, 1) = 23 И КодСимвола(Символ, 2) = 13 Тогда
				ДатаСтрокой = ЧтениеТекста.Прочитать(12);
				ДатаПодписания = Дата("20" + ДатаСтрокой);
				Прервать;
			КонецЕсли;
		КонецЕсли;
		Символ = ЧтениеТекста.Прочитать(1);
	КонецЦикла;
	
	ЧтениеТекста.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	
#КонецЕсли
	
	Возврат ДатаПодписания;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Для функции ПолучитьСоответствиеФайловИПодписей.
Функция НайтиИменаФайловПодписей(ИмяФайлаДанных, ИменаФайловПодписей)
	
	ИменаПодписей = Новый Массив;
	
	СтруктураИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаДанных);
	ИмяБезРасширения = СтруктураИмени.ИмяБезРасширения;
	
	Для Каждого ИмяФайлаПодписи Из ИменаФайловПодписей Цикл
		Если СтрНайти(ИмяФайлаПодписи, ИмяБезРасширения) > 0 Тогда
			ИменаПодписей.Добавить(ИмяФайлаПодписи);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ИмяФайлаПодписи Из ИменаПодписей Цикл
		ИменаФайловПодписей.Удалить(ИменаФайловПодписей.Найти(ИмяФайлаПодписи));
	КонецЦикла;
	
	Возврат ИменаПодписей;
	
КонецФункции

// Для процедуры ДатаПодписания.
Функция СимволыБайтДвоичныхДанных(ДвоичныеДанные)
	
	Строки = СтрРазделить(Base64Строка(ДвоичныеДанные), Символы.ПС, Ложь);
	СимволыБайт = "";
	
	ТекущийНомерСимвола = 0;
	
	Шаблон = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	Для Каждого Строка Из Строки Цикл
		Строка = СокрП(Строка);
		Пока СтрДлина(Строка) > 0 Цикл
			Четверка = Лев(Строка, 4);
			Строка = Сред(Строка, 5);
			
			КоличествоБайт = 1;
			
			Символ = Сред(Четверка, 1, 1);
			Позиция = СтрНайти(Шаблон, Символ);
			Если Позиция > 0 Тогда
				Старшие6БитБайта1 = (Позиция - 1) * 4;
			Иначе
				Возврат "";
			КонецЕсли;
		
			Символ = Сред(Четверка, 2, 1);
			Позиция = СтрНайти(Шаблон, Символ);
			Если Позиция > 0 Тогда
				Число2 = Позиция - 1;
			ИначеЕсли Символ <> "=" И Символ <> "" Тогда
				Возврат "";
			Иначе
				Прервать;
			КонецЕсли;
			Младшие2БитаБайта1 = Цел(Число2 / 16);
			СимволыБайт = СимволыБайт + Символ(Старшие6БитБайта1 + Младшие2БитаБайта1);
			
			Символ = Сред(Четверка, 3, 1);
			Позиция = СтрНайти(Шаблон, Символ);
			Если Позиция > 0 Тогда
				Число3 = Позиция - 1;
			ИначеЕсли Символ <> "=" И Символ <> "" Тогда
				Возврат "";
			Иначе
				Прервать;
			КонецЕсли;
			Старшие4БитаБайта2 = (Число2 - Младшие2БитаБайта1 * 16) * 16;
			Младшие4БитаБайта2 = Цел(Число3 / 4);
			СимволыБайт = СимволыБайт + Символ(Старшие4БитаБайта2 + Младшие4БитаБайта2);
			
			Символ = Сред(Четверка, 4, 1);
			Позиция = СтрНайти(Шаблон, Символ);
			Если Позиция > 0 Тогда
				Младшие6БитБайта3 = Позиция - 1;
			ИначеЕсли Символ <> "=" И Символ <> "" Тогда
				Возврат "";
			Иначе
				Прервать;
			КонецЕсли;
			Старшие2БитаБайта3 = (Число3 - Младшие4БитаБайта2 * 4) * 64;
			СимволыБайт = СимволыБайт + Символ(Старшие2БитаБайта3 + Младшие6БитБайта3);
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат СимволыБайт;
	
КонецФункции

#КонецОбласти
