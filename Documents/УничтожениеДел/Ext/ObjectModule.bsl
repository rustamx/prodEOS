﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	
	Для Каждого Строка Из ДелаХраненияДокументов Цикл
		Если ЗначениеЗаполнено(Строка.ДелоХраненияДокументов) Тогда 
			РеквизитыДела = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Строка.ДелоХраненияДокументов,
				"Организация, ДелоЗакрыто, ДатаОкончания, 
				|НоменклатураДел.СрокХранения, НоменклатураДел.СрокХранения, НоменклатураДел.КатегорияДела");
				
			Если ИспользоватьУчетПоОрганизациям 
				И РеквизитыДела.Организация <> Организация Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело ""%1"" не относится к организации ""%2"".'; en = 'Case ""%1"" does not belong to company ""%2"".'"),
					Строка.ДелоХраненияДокументов,
					Организация);
					
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ДелаХраненияДокументов[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДелоХраненияДокументов",, 
					Отказ);
			КонецЕсли;
			
			Если РеквизитыДела.ДелоЗакрыто = Ложь Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело ""%1"" не является закрытым.'; en = 'Case ""%1"" is not closed.'"),
					Строка.ДелоХраненияДокументов);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ДелаХраненияДокументов[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДелоХраненияДокументов",, 
					Отказ);
			КонецЕсли;
			
			СрокХранения = РеквизитыДела.НоменклатураДелСрокХранения;
			Если ТипЗнч(СрокХранения) = Тип("Число") Тогда 
				ХранитсяПолныхЛет = Год(Дата) - Год(РеквизитыДела.ДатаОкончания) - 1;
				Если ХранитсяПолныхЛет < СрокХранения Тогда 
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Для дела ""%1"" не истек срок хранения.'; en = 'Case file ""%1"" is not expired and must be retained.'"),
						Строка.ДелоХраненияДокументов);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ТекстСообщения,
						ЭтотОбъект,
						"ДелаХраненияДокументов[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДелоХраненияДокументов",, 
						Отказ);
				КонецЕсли;	
			КонецЕсли;	
			
			КатегорияДела = РеквизитыДела.НоменклатураДелКатегорияДела;
			Если КатегорияДела = Перечисления.КатегорииДел.Постоянное Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело ""%1"" имеет постоянный срок хранения.'; en = 'Case ""%1"" has a permanent shelf life.'"),
					Строка.ДелоХраненияДокументов);
					
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ДелаХраненияДокументов[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДелоХраненияДокументов",, 
					Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда 
		
		Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
		
		Если Не ЗначениеЗаполнено(Организация) Тогда 
			Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Массив") Тогда 
		Для Каждого Дело Из ДанныеЗаполнения Цикл
			НоваяСтрока = ДелаХраненияДокументов.Добавить();
			НоваяСтрока.ДелоХраненияДокументов = Дело;
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Движения.СостоянияДелХраненияДокументов.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДелаХраненияДокументов.НомерСтроки КАК НомерСтроки,
	|	ДелаХраненияДокументов.Ссылка.Дата КАК Период,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов КАК ДелоХраненияДокументов,
	|	ЗНАЧЕНИЕ(Перечисление.СостоянияДелХраненияДокументов.Уничтожено) КАК Состояние,
	|	СостоянияСрезПоследних.Состояние КАК СостояниеРанее
	|ИЗ
	|	Документ.УничтожениеДел.ДелаХраненияДокументов КАК ДелаХраненияДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияДелХраненияДокументов.СрезПоследних(&Период, ДелоХраненияДокументов В (&ДелаХраненияДокументов)) КАК СостоянияСрезПоследних
	|		ПО ДелаХраненияДокументов.ДелоХраненияДокументов = СостоянияСрезПоследних.ДелоХраненияДокументов
	|ГДЕ
	|	ДелаХраненияДокументов.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ДелаХраненияДокументов", ДелаХраненияДокументов.ВыгрузитьКолонку("ДелоХраненияДокументов"));
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.СостояниеРанее = Перечисления.СостоянияДелХраненияДокументов.Уничтожено Тогда 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Дело ""%1"" было уничтожено ранее.'; en = 'Case ""%1"" was destroyed earlier.'"),
				Выборка.ДелоХраненияДокументов);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ДелаХраненияДокументов[" + Формат(Выборка.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДелоХраненияДокументов",, 
				Отказ);
		КонецЕсли;
		
		Движение = Движения.СостоянияДелХраненияДокументов.Добавить();
		Движение.Период = Выборка.Период;
		Движение.ДелоХраненияДокументов = Выборка.ДелоХраненияДокументов;
		Движение.Состояние = Выборка.Состояние;
		Движение.Активность = Не Ссылка.ПометкаУдаления;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
