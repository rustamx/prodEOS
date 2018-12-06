﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьОтображениеСервер();
	
	Если ОбщегоНазначенияДокументооборот.ПриложениеЯвляетсяВебКлиентом() Тогда
		Элементы.ПланДняКонтекстноеМенюАвтообновление.Видимость = Ложь;
	Иначе
		НастройкиАвтообновления = Автообновление.ПолучитьНастройкиАвтообновленияФормы(ЭтаФорма);
		Элементы.ПланДняКонтекстноеМенюАвтообновление.Видимость = Истина;
	КонецЕсли;
	
	ПериодОтображения = Перечисления.ПериодОтображенияРабочегоКалендаря.ПланДняРабочийСтол;
	
	НастройкиОтображения = РаботаСРабочимКалендаремСервер.ПолучитьНастройкиОтображения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДатаСегодня = НачалоДня(ТекущаяДата());
	
	#Если Не ВебКлиент Тогда
		УстановитьАвтообновлениеФормы();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаписьКалендаря" Тогда
		
		Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			Если Параметр.Количество() <> 0 Тогда
				ТекущаяЗаписьКалендаря = Параметр[0];
				ТекущаяДатаНачала = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		ОбновитьОтображениеКлиент();
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Отсутствие" Тогда
		
		ОбновитьОтображениеКлиент();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПланДня

&НаКлиенте
Процедура ПланДняПриАктивизацииСтроки(Элемент)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаАктивизацииОбластиПланДня(
		Элемент, ТекущаяЗаписьКалендаря, ТекущаяДатаНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланДняВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаВыбораПланДня(
		Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланДняПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаПередНачаломДобавленияПланДня(
		Элемент, Отказ, Копирование, Родитель, Группа, НастройкиОтображения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланДняПередНачаломИзменения(Элемент, Отказ)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаПередНачаломИзмененияПланДня(Элементы.ПланДня, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланДняПередУдалением(Элемент, Отказ)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаПередУдалениемПланДня(Элементы.ПланДня, ПланДня, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланДняНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаНачалаПеретаскиванияПланДня(
		Элемент, ПараметрыПеретаскивания, Выполнение, НастройкиОтображения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланДняПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка,
	Строка, Поле)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаПроверкиПеретаскиванияПланДня(
		Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле, НастройкиОтображения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланДняПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаПеретаскиванияПланДня(
		Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле, НастройкиОтображения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтработатьПланДня(Команда)
	
	РаботаСРабочимКалендаремКлиент.ОтработатьВыделенныеЗаписиКалендаряПланДня(Элементы.ПланДня, ПланДня);
	
КонецПроцедуры

&НаКлиенте
Процедура Автообновление(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"АвтообновлениеПродолжение",
		ЭтотОбъект);
	АвтообновлениеКлиент.УстановитьПараметрыАвтообновленияФормы(
		ЭтаФорма,
		НастройкиАвтообновления,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтообновлениеПродолжение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		НастройкиАвтообновления = Результат;
		УстановитьАвтообновлениеФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьОтображениеКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветЖелтый(Команда)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаИзмененияЦветаПланДня(Элементы.ПланДня, ПланДня,
		ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Желтый"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветЗеленый(Команда)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаИзмененияЦветаПланДня(Элементы.ПланДня, ПланДня,
		ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Зеленый"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветКрасный(Команда)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаИзмененияЦветаПланДня(Элементы.ПланДня, ПланДня,
		ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Красный"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветНет(Команда)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаИзмененияЦветаПланДня(Элементы.ПланДня, ПланДня,
		ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Нет"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветОранжевый(Команда)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаИзмененияЦветаПланДня(Элементы.ПланДня, ПланДня,
		ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Оранжевый"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЦветСиний(Команда)
	
	РаботаСРабочимКалендаремКлиент.ОбработкаИзмененияЦветаПланДня(Элементы.ПланДня, ПланДня,
		ПредопределенноеЗначение("Перечисление.ЦветаРабочегоКалендаря.Синий"));
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ВыделенныеЭлементы =
		РаботаСРабочимКалендаремКлиент.ВыделенныеЭлементыПланДня(Элементы.ПланДня, ПланДня, Истина);
	РаботаСРабочимКалендаремКлиент.Печать(ВыделенныеЭлементы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаАвтообновления()
	
	Если ТипЗнч(НастройкиАвтообновления) <> Тип("Структура")
		Или (ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И Не НастройкиАвтообновления.Автообновление) Тогда
		ОтключитьОбработчикОжидания("ОбработкаАвтообновления");
	Иначе
		ОбновитьОтображениеКлиент();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьАвтообновлениеФормы()
	
	Если ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И НастройкиАвтообновления.Автообновление Тогда
		ПодключитьОбработчикОжидания(
			"ОбработкаАвтообновления", 
			НастройкиАвтообновления.ПериодАвтоОбновления,
			Ложь);
	Иначе
		ОтключитьОбработчикОжидания("ОбработкаАвтообновления");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображениеСервер()
	
	НастройкиОтображения = РаботаСРабочимКалендаремСервер.ПолучитьНастройкиОтображения();
	НастройкиОтображения.ОтображаемаяДата = ТекущаяДатаСеанса();
	НастройкиОтображения.ПериодОтображения =
		Перечисления.ПериодОтображенияРабочегоКалендаря.ПланДняРабочийСтол;

	ПланДняЗначение = РеквизитФормыВЗначение("ПланДня");
	РаботаСРабочимКалендаремСервер.ОтобразитьПланДня(ПланДняЗначение, НастройкиОтображения);
	ЗначениеВРеквизитФормы(ПланДняЗначение, "ПланДня");
	
	ПараметрыОтбора = Новый Структура("ЭтоГруппа", Ложь);
	СтрокиСобытий = ПланДняЗначение.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	КоличествоСобытий = СтрокиСобытий.Количество();
	Заголовок = СтрШаблон(НСтр("ru = 'Ближайшие события (%1)'; en = 'Coming soon (%1)'"), КоличествоСобытий);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеКлиент()
	
	ДатаСегодня = НачалоДня(ТекущаяДата());
	
	СвернутыеЭлементы = РаботаСРабочимКалендаремКлиент.ПолучитьСвернутыеЭлементыПланаДня(
		Элементы.ПланДня, ПланДня);
	ОбновитьОтображениеСервер();
	РаботаСРабочимКалендаремКлиент.ВосстановитьСостояниеПланаДня(
		Элементы.ПланДня, ПланДня, СвернутыеЭлементы, ТекущаяЗаписьКалендаря, ТекущаяДатаНачала);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	РаботаСРабочимКалендаремСервер.УстановитьУсловноеОформлениеПланДня(УсловноеОформление);
	
КонецПроцедуры

#КонецОбласти
