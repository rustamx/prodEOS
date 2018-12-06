﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ФайлОбязателенДляНовых = Объект.Ссылка.Пустая();
	
	Если Не Объект.Ссылка.Пустая() Тогда
		HTMLКодИнструкции = РаботаСИнструкциями.ТекстИнструкции(Объект.Ссылка);
		ТекстИнструкции = РаботаСИнструкциями.УстановитьСтильОформленияИнструкции(HTMLКодИнструкции);
	КонецЕсли;
	
	Если Параметры.Свойство("ПредметИнструкции") Тогда
		Объект.ПредметИнструкции = Параметры.ПредметИнструкции;
	КонецЕсли;
	
	УстановитьВидимость();
	УстановитьДоступность();
	
	Если Не Объект.Ссылка.Пустая() Тогда
		СтруктураПрав = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если ФайлОбязателенДляНовых Тогда
		ТекущийОбъект.ТекстИнструкции = Новый ХранилищеЗначения(ТекстИнструкции, Новый СжатиеДанных(9));
	КонецЕсли;
	
	// Удаление пустых строк в ТЧ ДоступНаЧтение
	ПустыеСтроки = ТекущийОбъект.ДоступНаЧтение.НайтиСтроки(
		Новый Структура("Пользователь", Справочники.Пользователи.ПустаяСсылка()));
	Для каждого СтрокаТаблицы Из ПустыеСтроки Цикл
		ТекущийОбъект.ДоступНаЧтение.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_Инструкции", Объект.Ссылка);
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУсловияОтображения

&НаКлиенте
Процедура УсловияОтображенияВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ВнутренниеДокументы") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ВидыВнутреннихДокументов.ФормаВыбора", , Элемент);
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ВходящиеДокументы") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ВидыВходящихДокументов.ФормаВыбора", , Элемент);
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ИсходящиеДокументы") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ВидыИсходящихДокументов.ФормаВыбора", , Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияОтображенияШаблонДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ВнутренниеДокументы") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныВнутреннихДокументов.ФормаВыбора", , Элемент);
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ВходящиеДокументы") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныВходящихДокументов.ФормаВыбора", , Элемент);
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ИсходящиеДокументы") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныИсходящихДокументов.ФормаВыбора", , Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияОтображенияШаблонПроцессаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессИсполнение")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессИсполнениеКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныИсполнения.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.КомплексныйПроцесс")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.КомплексныйПроцессКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныКомплексныхБизнесПроцессов.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессОзнакомление")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессОзнакомлениеКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныОзнакомления.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессПоручение")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессПоручениеКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныПоручения.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессПриглашение")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессПриглашениеКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныПриглашения.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессРассмотрение")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессРассмотрениеКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныРассмотрения.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессРегистрация")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессРегистрацияКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныРегистрации.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессСогласование")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессСогласованиеКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныСогласования.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессОбработкаВнутреннегоДокумента")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессОбработкаВнутреннегоДокументаКарточка")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессОбработкаВходящегоДокумента")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессОбработкаВходящегоДокументаКарточка")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессОбработкаИсходящегоДокумента")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессОбработкаИсходящегоДокументаКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныСоставныхБизнесПроцессов.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессУтверждение")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессУтверждениеКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныУтверждения.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.КомплексныйПроцесс")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.КомплексныйПроцессКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныКомплексныхБизнесПроцессов.ФормаВыбора", , Элемент);
		
	ИначеЕсли Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессПриглашение")
		ИЛИ Объект.ПредметИнструкции = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПроцессПриглашениеКарточка") Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.ШаблоныПриглашения.ФормаВыбора", , Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДоступНаЧтение

&НаКлиенте
Процедура ДоступНаЧтениеПодобрать(Команда)
	
	ПодобратьПользователейИмеющихДоступНаЧтение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступНаЧтениеПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ДоступНаЧтение.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Пользователь) Тогда 
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
		ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
		ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
		ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
		ПараметрыФормы.Вставить("ВыбранныеАдресаты", ТекущиеДанные.Пользователь);
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор пользователя'; en = 'User choice'"));
		
		ОткрытьФорму("Справочник.АдреснаяКнига.Форма.ФормаСписка",
			ПараметрыФормы,
			Элементы.ДоступНаЧтениеПользователь,,,,,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		
		ПодобратьПользователейИмеющихДоступНаЧтение();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступНаЧтениеПользовательАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступНаЧтениеПользовательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоступНаЧтениеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда 
		Элементы.ДоступНаЧтение.ТекущиеДанные.Пользователь = ПользователиПустаяСсылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьТиповуюИнструкцию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьТиповуюИнструкциюЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ЗагрузкаТиповыхИнструкций.Форма.ФормаВыбораМакета",,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьТиповуюИнструкциюЗавершение(ИмяМакетаТиповой, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ИмяМакетаТиповой) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ИмяМакетаТиповой = ИмяМакетаТиповой;
	
	ТекстИнструкции = РаботаСИнструкциями.ТекстТиповойИнструкции(ИмяМакетаТиповой);
	ТекстИнструкции = РаботаСИнструкциямиКлиент.ОтформатироватьТекстИнструкции(, ТекстИнструкции);
	ТекстИнструкции = РаботаСИнструкциями.УстановитьСтильОформленияИнструкции(ТекстИнструкции);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлИнструкции(Команда)

	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр = "Файлы инструкций (*.htm, *.html)|*.htm?";
	ДиалогВыбораФайла.Заголовок = "Выберите файл инструкции";
	ДиалогВыбораФайла.ПолноеИмяФайла = "";
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ПутьКФайлуИнструкции = ДиалогВыбораФайла.ПолноеИмяФайла;
		ФайлОбязателенДляНовых = Истина;
		ПолучитьТекстИнструкции(ПутьКФайлуИнструкции);
		Объект.ИмяМакетаТиповой = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлИнструкции(Команда)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогВыбораФайла.Фильтр = "Файлы инструкций (*.htm, *.html)|*.htm?";
	ДиалогВыбораФайла.Заголовок = "Сохранение файла инструкции";
	ДиалогВыбораФайла.ПолноеИмяФайла = 
		ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(Объект.Наименование, "")
		+ ".html";
	ДиалогВыбораФайла.Каталог = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы",
		"ПапкаДляСохранитьКак");
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Текст = Новый ЗаписьТекста(ДиалогВыбораФайла.ПолноеИмяФайла);
		Текст.ЗаписатьСтроку(РаботаСИнструкциямиКлиент.ТекстИнструкции(Объект.Ссылка, Ложь));
		Текст.Закрыть();
		Состояние(НСтр("ru = 'Файл инструкции успешно сохранен.'; en = 'Instruction file has been saved successfully.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьТекстИнструкции(ПутьКФайлуИнструкции)
	
	НаименованиеИнструкции = "";
	
	HTMLКодИнструкции = РаботаСИнструкциямиКлиент.ОтформатироватьТекстИнструкции(
		ПутьКФайлуИнструкции, , НаименованиеИнструкции);
	ТекстИнструкции = РаботаСИнструкциями.УстановитьСтильОформленияИнструкции(HTMLКодИнструкции);
	
	Если Объект.Наименование = "" Тогда
		Объект.Наименование = НаименованиеИнструкции;
	КонецЕсли;
	
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность()
	
	Элементы.СохранитьФайлИнструкции.Доступность = Не Объект.Ссылка.Пустая();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ПредметЯвляетсяДокументом = (Объект.ПредметИнструкции = Справочники.ПредметыИнструкций.Документы);
	ПредметЯвляетсяВнутреннимДокументом = (Объект.ПредметИнструкции = Справочники.ПредметыИнструкций.ВнутренниеДокументы);
	ПредметЯвляетсяВходящимДокументом = (Объект.ПредметИнструкции = Справочники.ПредметыИнструкций.ВходящиеДокументы);
	ПредметЯвляетсяИсходящимДокументом = (Объект.ПредметИнструкции = Справочники.ПредметыИнструкций.ИсходящиеДокументы);
	ПредметЯвляетсяПроцессом = (Объект.ПредметИнструкции = Справочники.ПредметыИнструкций.Процессы);
	
	Если Не ПредметЯвляетсяДокументом И Не ПредметЯвляетсяПроцессом Тогда 
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Предметы.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ПредметыИнструкций КАК Предметы
			|ГДЕ
			|	Предметы.Ссылка = &Предмет
			|ИТОГИ ПО
			|	Ссылка ТОЛЬКО ИЕРАРХИЯ";
		Запрос.УстановитьПараметр("Предмет", Объект.ПредметИнструкции);
		Выборка = Запрос.Выполнить().Выбрать();
		
		ПредметЯвляетсяДокументом = Ложь;
		ПредметЯвляетсяПроцессом = Ложь;
		
		Если Выборка.Следующий() Тогда
			ПредметЯвляетсяДокументом = (Выборка.Ссылка = Справочники.ПредметыИнструкций.Документы);
			ПредметЯвляетсяПроцессом = (Выборка.Ссылка = Справочники.ПредметыИнструкций.Процессы);
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.УсловияОтображенияОрганизация.Видимость =
		ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
		
	Элементы.УсловияОтображенияВидДокумента.Видимость =
		ПредметЯвляетсяДокументом
		И (
			ПредметЯвляетсяВнутреннимДокументом И ПолучитьФункциональнуюОпцию("ИспользоватьВидыВнутреннихДокументов")
			ИЛИ ПредметЯвляетсяВходящимДокументом И ПолучитьФункциональнуюОпцию("ИспользоватьВидыВходящихДокументов")
			ИЛИ ПредметЯвляетсяИсходящимДокументом И ПолучитьФункциональнуюОпцию("ИспользоватьВидыИсходящихДокументов")
		);
		
	Элементы.УсловияОтображенияСостояниеДокумента.Видимость =
		ПредметЯвляетсяДокументом
		И ПолучитьФункциональнуюОпцию("ИспользоватьСостоянияДокументов");
		
	Элементы.УсловияОтображенияГрифДоступа.Видимость =
		ПредметЯвляетсяДокументом
		И ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступа");
		
	Элементы.УсловияОтображенияВопросДеятельности.Видимость =
		ПредметЯвляетсяДокументом
		И ПолучитьФункциональнуюОпцию("ИспользоватьВопросыДеятельности");
		
	Элементы.УсловияОтображенияШаблонДокумента.Видимость =
		ПредметЯвляетсяДокументом;
	
	Элементы.УсловияОтображенияШаблонПроцесса.Видимость =
		ПредметЯвляетсяПроцессом
		И ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыИЗадачи");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПользователейИмеющихДоступНаЧтение()
	
	ПользователиИмеющиеДоступНаЧтение = ПользователиИмеющиеДоступНаЧтение();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Подбор исполнителей'; en = 'Selection of performers'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", 
		НСтр("ru = 'Выбранные пользователи и роли:'; en = 'Selected users and roles:'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", 
		НСтр("ru = 'Все пользователи и роли:'; en = 'All users and roles:'"));
	ПараметрыФормы.Вставить("РежимРаботыФормы", 2);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ПользователиИмеющиеДоступНаЧтение);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершитьПодборПользователейИмеющихДоступНаЧтение", ЭтаФорма);
		
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПодборПользователейИмеющихДоступНаЧтение(
	ВыбранныеИсполнители, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеИсполнители = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДоступНаЧтение.Очистить();
	
	Для Каждого Строка Из ВыбранныеИсполнители Цикл
		
		НоваяСтрока = Объект.ДоступНаЧтение.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.Пользователь = Строка.Контакт;
		
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция ПользователиИмеющиеДоступНаЧтение()
	
	ПользователиИмеющиеДоступНаЧтение = Новый Массив;
	
	Для Каждого СтрПользователь Из Объект.ДоступНаЧтение Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрПользователь.Пользователь) Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеПользователя = РаботаСАдреснойКнигойКлиент.СтруктураВыбранногоАдресата();
		ОписаниеПользователя.Контакт = СтрПользователь.Пользователь;
		
		ПользователиИмеющиеДоступНаЧтение.Добавить(ОписаниеПользователя);
		
	КонецЦикла;
	
	Возврат ПользователиИмеющиеДоступНаЧтение;
	
КонецФункции

#КонецОбласти
