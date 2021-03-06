﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске.
	Элементы.ГруппаПрименитьНастройки.Видимость = РежимРаботы.ЭтоВебКлиент;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура КакПрименитьНастройкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбновитьИнтерфейс = Истина;
	ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Банки
&НаКлиенте
Процедура ЗагрузитьКлассификаторБанков(Команда)
	
	ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ЗагрузкаКлассификатора");
	
КонецПроцедуры


// СтандартныеПодсистемы.Валюты
&НаКлиенте
Процедура ОбработкаЗагрузкаКурсовВалют(Команда)
	
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма");
	
КонецПроцедуры


// СтандартныеПодсистемы.АдресныйКлассификатор
&НаКлиенте
Процедура АдресныйКлассификаторПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, НеобходимоОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если НеобходимоОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		#Если Не ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую.
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
	// Используется для тех реквизитов формы, которые связаны с константами напрямую.
	
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	// СтандартныеПодсистемы.АдресныйКлассификатор
	Если РеквизитПутьКДанным = "НаборКонстант.ИсточникДанныхАдресногоКлассификатора"
	 Или РеквизитПутьКДанным = "" Тогда
	 
		Элементы.ГруппаАдресныйКлассификаторКоманды.Доступность = ПустаяСтрока(НаборКонстант.ИсточникДанныхАдресногоКлассификатора);
		
	КонецЕсли; 
	// Конец СтандартныеПодсистемы.АдресныйКлассификатор
	
КонецПроцедуры


