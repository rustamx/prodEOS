﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда 
	
		Если Не ЗначениеЗаполнено(Объект.ВидСчета) Тогда 
			Объект.ВидСчета = Элементы.ВидСчета.СписокВыбора.Получить(0).Значение;
		КонецЕсли;	
		
		Если Не ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) Тогда 
			Объект.ВалютаДенежныхСредств = Делопроизводство.ПолучитьВалютуПоУмолчанию();
		КонецЕсли;	
		
		ЗаполнитьТекстКорреспондента();
		
	КонецЕсли;	
	
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Организации") Тогда
		Элементы.Владелец.Заголовок = Нстр("ru = 'Организация'; en = 'Company'");
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда
		Элементы.Владелец.Заголовок = Нстр("ru = 'Контрагент'; en = 'Counterparty'");
	КонецЕсли;
	
	ОпределитьВалютныйСчет();
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаСвойства");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьАвтоНаименование();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УказатьОсновнойБанковскийСчет = Ложь;
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Организации") 
	 Или ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда
		Если Объект.Ссылка.Пустая() Тогда 
			ОсновнойБанковскийСчет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ОсновнойБанковскийСчет"); 
			УказатьОсновнойБанковскийСчет = Не ЗначениеЗаполнено(ОсновнойБанковскийСчет);
		КонецЕсли; 
	КонецЕсли;
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
		
	Если Не ЗначениеЗаполнено(Объект.ДатаОткрытия) И ЗначениеЗаполнено(Объект.ДатаЗакрытия) Тогда 
		Отказ = Истина;		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Дата открытия"" не заполнено'; en = 'Field "" opening date "" is empty'"),,"Объект.ДатаОткрытия");
	ИначеЕсли ЗначениеЗаполнено(Объект.ДатаОткрытия) И ЗначениеЗаполнено(Объект.ДатаЗакрытия)
		И Объект.ДатаОткрытия > Объект.ДатаЗакрытия Тогда 
		Отказ = Истина;		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = '""Дата открытия"" счета больше ""Даты закрытия""'; en = 'Account ""Opening date"" more than ""Closing date""'"),,"Объект.ДатаОткрытия");
	КонецЕсли;

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если УказатьОсновнойБанковскийСчет Тогда 
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ОсновнойБанковскийСчет", Объект.Ссылка);
		СтруктураПараметров.Вставить("Владелец", Объект.Владелец);
		
		Оповестить("ЗаписатьОсновнойБанковскийСчет", СтруктураПараметров, ЭтаФорма);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Владелец", Объект.Владелец);
		Оповестить("СозданБанковскийСчет", СтруктураПараметров, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура НомерСчетаПриИзменении(Элемент)
	
	Объект.НомерСчета = СокрЛП(Объект.НомерСчета);
	
	ЗаполнитьТекстКорреспондента();
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	
	ЗаполнитьТекстКорреспондента();
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура БанкДляРасчетовПриИзменении(Элемент)
	
	ЗаполнитьТекстКорреспондента();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДенежныхСредствПриИзменении(Элемент)
	
	ОпределитьВалютныйСчет();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекстКорреспондента()

	Владелец = Объект.Владелец;
	
	Если Не ЗначениеЗаполнено(Владелец) Тогда
		Возврат;
	КонецЕсли;

	СтрКорреспондента = "";
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Организации") Тогда
		СтрКорреспондента = СокрЛП(Владелец.НаименованиеПолное);
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда
		СтрКорреспондента = СокрЛП(Владелец.НаименованиеПолное);
	КонецЕсли;	

	Если ЗначениеЗаполнено(Объект.БанкДляРасчетов) Тогда
		Если ПустаяСтрока(СтрКорреспондента) Тогда 
			СтрКорреспондента = СокрЛП(Владелец.Наименование);
		КонецЕсли;	
		
		СтрКорреспондента = СтрКорреспондента + " " + СтрШаблон(
			НСтр("ru = 'р/с %1 в %2 %3'; en = 'р/с %1 в %2 %3'"),
			Объект.НомерСчета,
			Объект.Банк,
			Объект.Банк.Город);
	КонецЕсли;	

	Объект.ТекстКорреспондента = СтрКорреспондента;	

КонецПроцедуры

&НаСервере
Процедура ОпределитьВалютныйСчет()
	
	Валютный = ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) 
		И Объект.ВалютаДенежныхСредств <> Константы.ОсновнаяВалюта.Получить();
	
КонецПроцедуры	

&НаКлиенте
Процедура СформироватьАвтоНаименование()

	Элементы.Наименование.СписокВыбора.Очистить();
	
	Если ПустаяСтрока(Объект.НомерСчета) Тогда 
		Возврат;
	КонецЕсли;	
	
	СтрокаНаименования = Лев(
		Объект.НомерСчета
		+ ?(Валютный, " (" + Объект.ВалютаДенежныхСредств + ")", "")
		+ ?(Не Объект.Банк.Пустая(), " в " + Объект.Банк, ""), 
		100);

	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
	Если Объект.Банк.Пустая() Тогда 
		Возврат;
	КонецЕсли;	
		
	СтрокаНаименования = Лев(
		Строка(Объект.Банк)
		+ " (" 
		+ Объект.НомерСчета 
		+ ?(Валютный, ", " + Объект.ВалютаДенежныхСредств , "")
		+ ")", 
		100);
	
	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
	СтрокаНаименования = Лев(
		Объект.НомерСчета 
		+ ", " + Объект.Банк
		+ ?(Валютный, ", " + Объект.ВалютаДенежныхСредств , ""),
		100);
	
	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ МЕХАНИЗМА СВОЙСТВ

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры


