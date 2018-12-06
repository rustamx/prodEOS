﻿////////////////////////////////////////////////////////////////////////////////////////////////////
// Обработка записи задачи контроля
//  
////////////////////////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

Процедура КонтрольПередЗаписьюЗадачиПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Возврат;
	КонецЕсли;
	
	Источник.ДополнительныеСвойства.Вставить("ЭтоНовый", Источник.ЭтоНовый());
	
	СтарыйСрокИсполнения = '00010101';
	Если ЗначениеЗаполнено(Источник.Ссылка) Тогда 
		СтарыйСрокИсполнения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "СрокИсполнения");
	КонецЕсли;
	Источник.ДополнительныеСвойства.Вставить("СтарыйСрокИсполнения", СтарыйСрокИсполнения);
	
	СтараяПометкаУдаления = Ложь;
	Если ЗначениеЗаполнено(Источник.Ссылка) Тогда 
		СтараяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПометкаУдаления");
	КонецЕсли;
	Источник.ДополнительныеСвойства.Вставить("СтараяПометкаУдаления", СтараяПометкаУдаления);
	
	СтароеСостояниеБизнесПроцесса = Неопределено;
	Если ЗначениеЗаполнено(Источник.Ссылка) Тогда 
		СтароеСостояниеБизнесПроцесса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Источник.Ссылка, "СостояниеБизнесПроцесса");
	КонецЕсли;
	Источник.ДополнительныеСвойства.Вставить("СтароеСостояниеБизнесПроцесса", СтароеСостояниеБизнесПроцесса);
	
КонецПроцедуры

Процедура КонтрольПриЗаписиЗадачиПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтараяПометкаУдаления = Источник.ДополнительныеСвойства.СтараяПометкаУдаления;
	СтароеСостояниеБизнесПроцесса = Источник.ДополнительныеСвойства.СтароеСостояниеБизнесПроцесса;
	
	Если СтараяПометкаУдаления <> Источник.ПометкаУдаления Тогда 
		Контроль.ОтметитьУдалениеСтрокиКонтроляПоЗадаче(Источник, Источник.ПометкаУдаления);
		
	ИначеЕсли СтароеСостояниеБизнесПроцесса <> Неопределено 
		И СтароеСостояниеБизнесПроцесса <> Источник.СостояниеБизнесПроцесса
		И Источник.СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Прерван Тогда 
		Контроль.ОтметитьУдалениеСтрокиКонтроляПоЗадаче(Источник, Истина);
		
	Иначе
		Контроль.ЗаполнитьСтрокуКонтроляПоЗадаче(Источник);
		Контроль.ЗаполнитьКонтрольПоЗадаче(Источник);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредметКонтроляПередЗаписьюПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначения.ЭтоБизнесПроцесс(Источник.Метаданные()) Тогда 
		КарточкиКонтроляСоСтандартнымиСроками = Новый Соответствие;
		
		КарточкиКонтроля = Контроль.ВсеКарточкиКонтроляПоПредмету(Источник.Ссылка);
		Для Каждого КарточкаКонтроля Из КарточкиКонтроля Цикл
			НоваяКарточкаКонтроля = Справочники.Контроль.СоздатьЭлемент();
			НоваяКарточкаКонтроля.Заполнить(Источник.Ссылка);
			
			Если КарточкаКонтроля.СрокИсполнения = НоваяКарточкаКонтроля.СрокИсполнения Тогда 
				КарточкиКонтроляСоСтандартнымиСроками.Вставить(КарточкаКонтроля, Истина);
			КонецЕсли;	
		КонецЦикла;
		
		Если КарточкиКонтроляСоСтандартнымиСроками.Количество() > 0 Тогда 
			Источник.ДополнительныеСвойства.Вставить("КарточкиКонтроляСоСтандартнымиСроками", КарточкиКонтроляСоСтандартнымиСроками);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПредметКонтроляПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// обновление контрольной карточки по исходящему письму
	Если ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(Источник) Тогда 
		
		КарточкиКонтроля = Контроль.ВсеКарточкиКонтроляПоПредмету(Источник.Ссылка);
		Для Каждого КарточкаКонтроля Из КарточкиКонтроля Цикл
			КонтрольОбъект = КарточкаКонтроля.ПолучитьОбъект();
			НужноЗаписать = Ложь;
			
			// добавленные
			Для Каждого СтрокаПолучатель Из Источник.ПолучателиПисьма Цикл 
				НайденнаяСтрока = Неопределено;
				Контроль.НайтиСтрокуКонтроляПоАдресату(КонтрольОбъект, СтрокаПолучатель.Адресат, НайденнаяСтрока);
				Если НайденнаяСтрока = Неопределено Тогда 
					Строка = КонтрольОбъект.Исполнители.Добавить();
					Строка.Исполнитель = СтрокаПолучатель.Адресат;
					Строка.Источник = Источник.Ссылка;
					НужноЗаписать = Истина;
				КонецЕсли;
			КонецЦикла;	
			
			// удаленные
			Для Каждого СтрокаИсполнитель Из КонтрольОбъект.Исполнители Цикл
				НайденнаяСтрока = Неопределено;
				Для Каждого СтрокаПолучатель Из Источник.ПолучателиПисьма Цикл
					АдресИсполнителя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаИсполнитель.Исполнитель, "Адрес");
					АдресПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаПолучатель.Адресат, "Адрес");
					Если АдресИсполнителя = АдресПолучателя Тогда 
						НайденнаяСтрока = СтрокаПолучатель;
						Прервать;
					КонецЕсли;	
				КонецЦикла;
				
				Если НайденнаяСтрока = Неопределено
					И СтрокаИсполнитель.Источник = Источник.Ссылка Тогда 
					КонтрольОбъект.Исполнители.Удалить(СтрокаИсполнитель);
					НужноЗаписать = Истина;
				КонецЕсли;	
			КонецЦикла;
			
			Если НужноЗаписать Тогда 
				КонтрольОбъект.Записать();
			КонецЕсли;
		КонецЦикла;		
			
	КонецЕсли;	
	
	// обновление контрольной карточки по процессу
	Если ОбщегоНазначения.ЭтоБизнесПроцесс(Источник.Метаданные()) Тогда 
		
		КарточкиКонтроля = Контроль.ВсеКарточкиКонтроляПоПредмету(Источник.Ссылка);
		Для Каждого КарточкаКонтроля Из КарточкиКонтроля Цикл
			КарточкаКонтроляОбъект = КарточкаКонтроля.ПолучитьОбъект();
			НужноЗаписать = Ложь;
			
			НоваяКарточкаКонтроля = Справочники.Контроль.СоздатьЭлемент();
			
			// Передадим Контролера из процесса, если он там есть.
			Попытка
				НоваяКарточкаКонтроля.Контролер = Источник.Контролер;
			Исключение
			КонецПопытки;
			
			НоваяКарточкаКонтроля.Заполнить(Источник.Ссылка);
			
			Если Источник.ДополнительныеСвойства.Свойство("КарточкиКонтроляСоСтандартнымиСроками") Тогда  
				КарточкиКонтроляСоСтандартнымиСроками = Источник.ДополнительныеСвойства.КарточкиКонтроляСоСтандартнымиСроками;
				Если КарточкиКонтроляСоСтандартнымиСроками.Получить(КарточкаКонтроля) = Истина Тогда 
					Если КарточкаКонтроляОбъект.СрокИсполнения <> НоваяКарточкаКонтроля.СрокИсполнения Тогда 
						КарточкаКонтроляОбъект.СрокИсполнения = НоваяКарточкаКонтроля.СрокИсполнения;
						НужноЗаписать = Истина;
					КонецЕсли;	
				КонецЕсли;	
			КонецЕсли;	
			
			// добавленные
			Для Каждого Строка Из НоваяКарточкаКонтроля.Исполнители Цикл 
				Если ЗначениеЗаполнено(Строка.Источник) Тогда 
					Продолжить;
				КонецЕсли;
				НайденнаяСтрока = Неопределено;
				Контроль.НайтиСтрокуКонтроляПоИсполнителю(КарточкаКонтроляОбъект, Строка, НайденнаяСтрока);
				Если НайденнаяСтрока = Неопределено Тогда 
					НоваяСтрока = КарточкаКонтроляОбъект.Исполнители.Добавить();
					НоваяСтрока.Исполнитель = Строка.Исполнитель;
					НужноЗаписать = Истина;
				КонецЕсли;
			КонецЦикла;	
			
			// удаленные
			Для Каждого Строка Из КарточкаКонтроляОбъект.Исполнители Цикл
				Если ЗначениеЗаполнено(Строка.Источник) Тогда 
					Продолжить;
				КонецЕсли;
				НайденнаяСтрока = Неопределено;
				Контроль.НайтиСтрокуКонтроляПоИсполнителю(НоваяКарточкаКонтроля, Строка, НайденнаяСтрока);	
				Если НайденнаяСтрока = Неопределено Тогда 
					КарточкаКонтроляОбъект.Исполнители.Удалить(Строка);
					НужноЗаписать = Истина;
				КонецЕсли;	
			КонецЦикла;
			
			Если НужноЗаписать Тогда 
				КарточкаКонтроляОбъект.Записать();
			КонецЕсли;
		КонецЦикла;	
		
	КонецЕсли;	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
