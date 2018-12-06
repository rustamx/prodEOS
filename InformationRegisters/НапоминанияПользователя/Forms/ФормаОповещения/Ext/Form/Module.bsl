﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда 
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СрокПовторногоОповещения = НСтр("ru = '15м'; en = '15m'");
	СрокПовторногоОповещения = НапоминанияПользователяКлиентСервер.ОформитьВремя(СрокПовторногоОповещения);
	
	ОбновитьТаблицуНапоминаний();
	
	ЗаполнитьСрокиПовторногоОповещения();
	
	ОбновитьВремяВТаблицеНапоминаний();
	ПодключитьОбработчикОжидания("ОбновитьВремяВТаблицеНапоминаний", 5);
	Активизировать();
	
	Оповестить("ОткрытаФормаОповещения");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	ОбновитьТаблицуНапоминаний();
	ЭтотОбъект.ТекущийЭлемент = Элементы.СрокПовторногоОповещения;
	Активизировать();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	ОтложитьАктивныеНапоминания();
	НапоминанияПользователяКлиент.СброситьТаймерПроверкиТекущихОповещений();
	ОтключитьОбработчикОжидания("ОбновитьВремяВТаблицеНапоминаний");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СрокПовторногоОповещенияПриИзменении(Элемент)
	СрокПовторногоОповещения = НапоминанияПользователяКлиентСервер.ОформитьВремя(СрокПовторногоОповещения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНапоминания

&НаКлиенте
Процедура НапоминанияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура НапоминанияПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Источник = ТекущиеДанные.Источник;
	ЕстьИсточник = ЗначениеЗаполнено(Источник);
	Элементы.НапоминанияКонтекстноеМенюОткрыть.Доступность = ЕстьИсточник;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	ОткрытьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОткрыть(Команда)
	ОткрытьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура Отложить(Команда)
	ОтложитьАктивныеНапоминания();
КонецПроцедуры

&НаКлиенте
Процедура Прекратить(Команда)
	Если Элементы.Напоминания.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ИндексСтроки Из Элементы.Напоминания.ВыделенныеСтроки Цикл
		ДанныеСтроки = Напоминания.НайтиПоИдентификатору(ИндексСтроки);
		
		ПараметрыНапоминания = НапоминанияПользователяКлиентСервер.ПолучитьСтруктуруНапоминания(ДанныеСтроки, Истина);
		
		УдалитьЗаписьИзКэшаОповещений = ОтключитьНапоминание(ПараметрыНапоминания);
		
		Если УдалитьЗаписьИзКэшаОповещений Тогда
			НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ДанныеСтроки);
			Оповестить("Удаление_НапоминанияПользователя_Документооборот", , ДанныеСтроки.Источник);
			ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.НапоминанияПользователя"));
		Иначе
			НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ДанныеСтроки);
			НапоминанияПользователяКлиент.ОбновитьЗаписьВКэшеОповещений(НапоминаниеНовое);
		КонецЕсли;
		
	КонецЦикла;
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.НапоминанияПользователя"));
	
	ОбновитьТаблицуНапоминаний();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодключитьНапоминание(ПараметрыНапоминания)
	НапоминанияПользователяСлужебный.ПодключитьНапоминание(ПараметрыНапоминания, Истина);
КонецПроцедуры

&НаСервере
Функция ОтключитьНапоминание(ПараметрыНапоминания)
	
	Если ТипЗнч(ПараметрыНапоминания.Источник) <> Тип("СправочникСсылка.ЗаписиРабочегоКалендаря") Тогда
		НапоминанияПользователяСлужебный.ОтключитьНапоминание(ПараметрыНапоминания);
		Возврат Ложь;
	КонецЕсли;
	
	ЗаписьКалендаря = ПараметрыНапоминания.Источник;
	ЗаписьКалендаряТипЗаписиКалендаря = ЗаписьКалендаря.ТипЗаписиКалендаря;
	
	ПодключеноНовоеНапоминание = Ложь;
	Если ЗаписьКалендаряТипЗаписиКалендаря = Перечисления.ТипЗаписиКалендаря.ПовторяющеесяСобытие
		И ПараметрыНапоминания.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ОтносительноВремениПредмета 
		И ПараметрыНапоминания.ИмяРеквизитаИсточника = "ДатаНачала" Тогда
		
		ЗаписьКалендаряОбъект = ЗаписьКалендаря.ПолучитьОбъект();
		СледующаяДатаНачала = ЗаписьКалендаряОбъект.ПолучитьСледующуюДатуНачала(ПараметрыНапоминания.ВремяСобытия);
		Если ЗначениеЗаполнено(СледующаяДатаНачала) Тогда
			ПодключеноНовоеНапоминание = Истина;
			НапоминаниеНовое = НапоминанияПользователяСлужебный.ПодключитьНапоминаниеДоВремениПредмета(
				Строка(ЗаписьКалендаря), ПараметрыНапоминания.ИнтервалВремениНапоминания, ЗаписьКалендаря,
				"ДатаНачала", СледующаяДатаНачала);
		КонецЕсли;
		
	КонецЕсли;
	
	НапоминанияПользователяСлужебный.ОтключитьНапоминание(ПараметрыНапоминания);
	
	Возврат Не ПодключеноНовоеНапоминание;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьТаблицуНапоминаний() 

	ОтключитьОбработчикОжидания("ОбновитьТаблицуНапоминаний");
	
	ВремяБлижайшего = Неопределено;
	ТаблицаНапоминаний = НапоминанияПользователяКлиент.ПолучитьТекущиеОповещения(ВремяБлижайшего);
	Для Каждого Напоминание из ТаблицаНапоминаний Цикл
		НайденныеСтроки = Напоминания.НайтиСтроки(Новый Структура("Источник,ВремяСобытия", Напоминание.Источник, Напоминание.ВремяСобытия));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(НайденныеСтроки[0], Напоминание, , "СрокНапоминания");
		Иначе
			НоваяСтрока = Напоминания.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Напоминание);
		КонецЕсли;
	КонецЦикла;
	
	СтрокиНаУдаление = Новый Массив;
	Для Каждого Напоминание из Напоминания Цикл
		Если ЗначениеЗаполнено(Напоминание.Источник) и ПустаяСтрока(Напоминание.ИсточникСтрокой) Тогда
			ОбновитьПредставленияПредметов();
		КонецЕсли;
			
		СтрокаНайдена = Ложь;
		Для Каждого СтрокаКэша Из ТаблицаНапоминаний Цикл
			Если СтрокаКэша.Источник = Напоминание.Источник Тогда
				СтрокаНайдена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если не СтрокаНайдена Тогда 
			СтрокиНаУдаление.Добавить(Напоминание);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Строка Из СтрокиНаУдаление Цикл
		Напоминания.Удалить(Строка);
	КонецЦикла;
	
	УстановитьВидимость();
	
	Интервал = 15; // обновление таблицы не реже чем 1 раз в 15 сек.
	Если ВремяБлижайшего <> Неопределено Тогда 
		Интервал = Макс(Мин(Интервал, ВремяБлижайшего - ОбщегоНазначенияКлиент.ДатаСеанса()), 1); 
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбновитьТаблицуНапоминаний", Интервал, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставленияПредметов()
	
	Для Каждого Напоминание Из Напоминания Цикл
		Если ЗначениеЗаполнено(Напоминание.Источник) Тогда
			Напоминание.ИсточникСтрокой = ОбщегоНазначения.ПредметСтрокой(Напоминание.Источник);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВремяВТаблицеНапоминаний()
	Для Каждого СтрокаТаблицы Из Напоминания Цикл
		ПредставлениеВремени = "";
		
		Время = ОбщегоНазначенияКлиент.ДатаСеанса() - СтрокаТаблицы.ВремяСобытия;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.ВремяСобытия) Тогда
			Если Время > -60 и Время < 60 Тогда
				ПредставлениеВремени = НСтр("ru = 'сейчас'; en = 'now'");
			Иначе
				ПредставлениеВремени = НапоминанияПользователяКлиентСервер.ПредставлениеВремени(Время, Ложь, Ложь);
				
				Если Время > 0 Тогда
					ПредставлениеВремени = НСтр("ru = 'просрочено'; en = 'overdue'") + " " + ПредставлениеВремени;
				Иначе
					ПредставлениеВремени = НСтр("ru = 'через'; en = 'through'") + " " + ПредставлениеВремени;
				КонецЕсли;
			КонецЕсли;
		Иначе
			ПредставлениеВремени = НСтр("ru = 'срок не определен'; en = 'the term is not defined'");
		КонецЕсли;
		
		Если СтрокаТаблицы.ВремяСобытияСтрока <> ПредставлениеВремени Тогда
			СтрокаТаблицы.ВремяСобытияСтрока = ПредставлениеВремени;
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьАктивныеНапоминания()
	ИнтервалВремени = НапоминанияПользователяКлиентСервер.ПолучитьИнтервалВремениИзСтроки(СрокПовторногоОповещения);
	Для Каждого СтрокаТаблицы Из Напоминания Цикл
		СтрокаТаблицы.СрокНапоминания = ОбщегоНазначенияКлиент.ДатаСеанса() + ИнтервалВремени;
		
		ПараметрыНапоминания = НапоминанияПользователяКлиентСервер.ПолучитьСтруктуруНапоминания(СтрокаТаблицы, Истина);
		
		ПодключитьНапоминание(ПараметрыНапоминания);
		НапоминанияПользователяКлиент.ОбновитьЗаписьВКэшеОповещений(СтрокаТаблицы);
		Оповестить("Запись_НапоминанияПользователя_Документооборот", ПараметрыНапоминания, ПараметрыНапоминания.Источник);
	КонецЦикла;
	ОбновитьТаблицуНапоминаний();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНапоминание()
	Если Элементы.Напоминания.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Источник = Элементы.Напоминания.ТекущиеДанные.Источник;
	Если ЗначениеЗаполнено(Источник) Тогда
		ПоказатьЗначение(, Источник);
	Иначе
		РедактироватьНапоминание();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНапоминание()
	ПараметрыНапоминания = Новый Структура("Пользователь,Источник,ВремяСобытия");
	ЗаполнитьЗначенияСвойств(ПараметрыНапоминания, Элементы.Напоминания.ТекущиеДанные);
	
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание", Новый Структура("Ключ", ПолучитьКлючЗаписи(ПараметрыНапоминания)));
КонецПроцедуры

&НаСервере
Функция ПолучитьКлючЗаписи(ПараметрыНапоминания)
	Возврат РегистрыСведений.НапоминанияПользователя.СоздатьКлючЗаписи(ПараметрыНапоминания);
КонецФункции

&НаКлиенте
Процедура УстановитьВидимость()
	ЕстьДанныеВТаблице = Напоминания.Количество() > 0;
	
	Если Не ЕстьДанныеВТаблице и ЭтотОбъект.Открыта() Тогда
		ЭтотОбъект.Закрыть();
	КонецЕсли;
	
	Элементы.ПанельКнопок.Доступность = ЕстьДанныеВТаблице;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_НапоминанияПользователя" Тогда 
		ОбновитьТаблицуНапоминаний();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСрокиПовторногоОповещения()
	
	Элементы.СрокПовторногоОповещения.СписокВыбора.Очистить();
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '5 минут'; en = '5 minutes'; en = '5 minutes'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '10 минут'; en = '10 minutes'; en = '10 minutes'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '15 минут'; en = '15 minutes'; en = '15 minutes'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '20 минут'; en = '20 minutes'; en = '20 minutes'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '30 минут'; en = '30 minutes'; en = '30 minutes'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '45 минут'; en = '45 minutes'; en = '45 minutes'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '1 час'; en = '1 hour'; en = '1 hour'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '2 часа'; en = '2 hours'; en = '2 hours'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '3 часа'; en = '3 hours'; en = '3 hours'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '6 часов'; en = '6 hours'; en = '6 hours'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '12 часов'; en = '12 hours'; en = '12 hours'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '1 день'; en = '1 day'; en = '1 day'"));
	Элементы.СрокПовторногоОповещения.СписокВыбора.Добавить(НСтр("ru = '3 дня'; en = '3 days'; en = '3 days'"));
	
	Если Элементы.СрокПовторногоОповещения.СписокВыбора.НайтиПоЗначению(СрокПовторногоОповещения) = Неопределено Тогда
		Элементы.СрокПовторногоОповещения.СписокВыбора.Вставить(0, СрокПовторногоОповещения);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
