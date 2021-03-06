﻿////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с мероприятиями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает подсказку следующего действия мероприятия.
//
// Параметры:
//  СостояниеМероприятия - ПеречислениеСсылка.СостоянияМероприятий - Состояние мероприятия.
//  СостояниеПрограммы - ПеречислениеСсылка.СостоянияМероприятий - Состояние программы мероприятия.
//  СостояниеПриглашений - ПеречислениеСсылка.СостоянияМероприятий - Состояние отправки приглашений на мероприятие.
//  СостояниеМатериаловВыступающих - ПеречислениеСсылка.СостоянияМероприятий - Состояние материалов мероприятия.
//  СостояниеПротокола - ПеречислениеСсылка.СостоянияМероприятий - Состояние протокола мероприятия.
//  ЗаполненыОсновныеРеквизиты - Булево - Признак заполненности основных реквизитов мероприятия.
//  УчитыватьКакПротокольноеМероприятие - Булево - Признак протокольного мероприятия.
//  Объект - ДанныеФормыСтруктура - Данные формы мероприятия.
//
// Возвращаемое значение:
//  Строка - Подсказка следующего действия.
//
Функция ПолучитьПодсказкуСледующегоДействия(
	СостояниеМероприятия, СостояниеПрограммы, СостояниеПриглашений, СостояниеМатериаловВыступающих,
	СостояниеПротокола, ЗаполненыОсновныеРеквизиты, УчитыватьКакПротокольноеМероприятие, Объект) Экспорт
	
	Если СостояниеМероприятия = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МероприятиеВСтадииПодготовки")
		Или Не ЗначениеЗаполнено(СостояниеМероприятия) Тогда
		
		Если Объект.ДатаОкончания < ТекущаяДата() И ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда 
			Возврат НСтр("ru = 'Срок проведения мероприятие прошел, и оно не отмечено как проведенное или отмененное.'; en = 'Event has passed and it is not marked as conducted or cancelled.'");
		КонецЕсли;
		
		Если Не ЗаполненыОсновныеРеквизиты Тогда
			Возврат НСтр("ru = 'Заполните основную информацию о мероприятии: тему, время и место проведения, определите состав участников.'; en = 'Fill basic event infromationt: description, date, location, attendees'");
		КонецЕсли;
		
		Если СостояниеПрограммы = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПрограммаНеУтверждена")
			Или Не ЗначениеЗаполнено(СостояниеПрограммы) Тогда
			Возврат НСтр("ru = 'Подготовьте программу мероприятия и отправьте на утверждение.'; en = 'Prepare event agenda and send it for confirmation.'");
		ИначеЕсли СостояниеПрограммы = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПрограммаНаУтверждении") Тогда
			Возврат НСтр("ru = 'Программа в процессе утверждения.'; en = 'Agenda is being confirmed.'");
		ИначеЕсли СостояниеПрограммы <> ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПрограммаУтверждена") Тогда
			Возврат "";
		КонецЕсли;
		
		Если СостояниеПриглашений = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПриглашенияНеПриняты")
			Или Не ЗначениеЗаполнено(СостояниеПриглашений) Тогда
			Возврат НСтр("ru = 'Отправьте приглашения участникам мероприятия.'; en = 'Send invitations to event attendees.'");
		ИначеЕсли СостояниеПриглашений = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПриглашенияОтправлены") Тогда
			Возврат НСтр("ru = 'Дождитесь ответа на приглашения.'; en = 'Wait for invitations response.'");
		ИначеЕсли СостояниеПриглашений <> ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПриглашенияПриняты") Тогда
			Возврат "";
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СостояниеМатериаловВыступающих) Тогда
			Возврат НСтр("ru = 'Запросите материалы выступлений у участников мероприятия.'; en = 'Request attendees materials.'");
		ИначеЕсли СостояниеМатериаловВыступающих = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МатериалыВыступающихЗапрошены") Тогда
			Возврат НСтр("ru = 'Дождитесь материалов выступлений.'; en = 'Wait for attendees materials.'");
		ИначеЕсли СостояниеМатериаловВыступающих = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПолученыМатериалыВыступающих") Тогда
			Возврат НСтр("ru = 'Ознакомьте с материалами всех участников мероприятия.'; en = 'Submit the event materials for examination to all the attendees.'");
		ИначеЕсли СостояниеМатериаловВыступающих = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МатериалыОтправленыНаОзнакомление") Тогда
			Возврат НСтр("ru = 'Убедитесь, что все участники ознакомлены с материалами выступлений.'; en = 'Make sure that all the attendees have become acquanited with event materials.'");
		ИначеЕсли СостояниеМатериаловВыступающих <> ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.СМатериаламиОзнакомились") Тогда
			Возврат "";
		КонецЕсли;
		
		Возврат НСтр("ru = 'Мероприятие можно проводить. Отметьте, кто из участников отсутствовал на мероприятии, и зафиксируйте принятые решения в отдельном файле.'; en = 'Event can be held. Mark who was absent and specify taken decisions.'");
		
	ИначеЕсли СостояниеМероприятия = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МероприятиеПроведено") Тогда
		
		Если Не УчитыватьКакПротокольноеМероприятие Тогда
			Возврат "";
		КонецЕсли;
		
		Если Объект.ТипПротокола = ПредопределенноеЗначение("Перечисление.ТипыПрограммыПротокола.ВТаблице")
			И Объект.ТипПрограммы = ПредопределенноеЗначение("Перечисление.ТипыПрограммыПротокола.ВТаблице") Тогда 
			
			ЕстьРешениеНеПринято = Ложь;
			Для Каждого Строка Из Объект.Программа Цикл
				
				Решение = "";
				Если Строка.ТребуетПринятияРешения Тогда 
					НайденныеСтроки = Объект.Протокол.НайтиСтроки(Новый Структура("НомерПунктаПрограммы", Строка.НомерПункта));
					Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
						Если ЗначениеЗаполнено(НайденнаяСтрока.Решили) Тогда 
							Решение = НСтр("ru = 'Принято'; en = 'Taken'");
							Прервать;
						КонецЕсли;	
					КонецЦикла;	
					
					Если Решение = "" Тогда 
						ЕстьРешениеНеПринято = Истина;
						Прервать;
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
			
			Если ЕстьРешениеНеПринято Тогда 
				Возврат НСтр("ru = 'Не по всем вопросам мероприятия приняты решения.'; en = 'Some agenda items has no decision taken.'");
			КонецЕсли;	
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СостояниеПротокола) Тогда
			Возврат НСтр("ru = 'Создайте задание на подготовку протокола мероприятия.'; en = 'Send event minutes for preparation.'");
		ИначеЕсли СостояниеПротокола = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколГотовиться")Тогда
			Возврат НСтр("ru = 'Дождитесь завершения подготовки протокола.'; en = 'Wait for minutes preparation.'");
		ИначеЕсли СостояниеПротокола = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколПодготовлен")
			Или СостояниеПротокола = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНеСогласован") Тогда
			Возврат НСтр("ru = 'Согласуйте протокол мероприятия с участниками.'; en = 'Approve event minutes with attendees.'");
		ИначеЕсли СостояниеПротокола = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНаСогласовании")Тогда
			Возврат НСтр("ru = 'Дождитесь завершения согласования протокола.'; en = 'Wait for minutes approval.'");
		ИначеЕсли СостояниеПротокола = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколСогласован")
			Или СостояниеПротокола = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНеУтвержден") Тогда
			Возврат НСтр("ru = 'Направьте протокол мероприятия на утверждение.'; en = 'Send minutes for confirmation.'");
		ИначеЕсли СостояниеПротокола = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНаУтверждении")Тогда
			Возврат НСтр("ru = 'Дождитесь утверждения протокола.'; en = 'Wait for minutes confirmation.'");
		ИначеЕсли СостояниеПротокола = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколУтвержден")Тогда
			Возврат НСтр("ru = 'Направьте протокол на исполнение.'; en = 'Send minutes for performance.'");
		ИначеЕсли СостояниеПротокола = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколНаИсполнении")Тогда
			Возврат НСтр("ru = 'Дождитесь исполнения протокола.'; en = 'Wait for minutes performance.'");
		ИначеЕсли СостояниеПротокола <> ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.ПротоколИсполнен")Тогда
			Возврат "";
		КонецЕсли;
		
		Возврат "";
		
	ИначеЕсли СостояниеМероприятия = ПредопределенноеЗначение("Перечисление.СостоянияМероприятий.МероприятиеОтменено") Тогда
		
		Возврат "";
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Меняет папку для массива мероприятий на новую.
//
// Параметры:
//  МассивМероприятий - Массив - Мероприятия, у которых необходимо изменить папку.
//  НоваяПапка - СправочникСсылка.ПапкиМероприятий - Новая папка мероприятий.
//
Процедура ИзменитьПапкуМероприятий(МассивМероприятий, НоваяПапка) Экспорт
	
	// Не указана новая папка
	Если Не ЗначениеЗаполнено(НоваяПапка) Тогда
		Возврат;
	КонецЕсли;
	
	// Нет элементов в массиве
	Если МассивМероприятий.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если УправлениеМероприятиямиВызовСервера.ИзменитьПапкуМероприятий(МассивМероприятий, НоваяПапка) Тогда
		
		Если МассивМероприятий.Количество() = 1 Тогда
			
			ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Мероприятие ""%1"" перенесено в папку ""%2""'; en = 'Event ""%1"" moved to folder ""%2""'"), МассивМероприятий[0], НоваяПапка);
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Мероприятие перенесено.'; en = 'Event has been moved.'"),
				ПолучитьНавигационнуюСсылку(МассивМероприятий[0]),
				ПолноеОписание,
				БиблиотекаКартинок.Информация32);
			
		Иначе
			
			ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Мероприятия (%1 шт.) перенесены в папку ""%2""'; en = 'Events (%1 pcs.) have been moved to folder ""%2""'"), МассивМероприятий.Количество(), НоваяПапка);
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Мероприятия перенесены.'; en = 'Events have been moved.'"),
				,
				ПолноеОписание,
				БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
		
		ОповеститьОбИзменении(Тип("СправочникСсылка.Мероприятия"));
		
	КонецЕсли;
	
КонецПроцедуры

// Направляет протокол мероприятия на исполнение.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//  РаздельноеИсполнениеПунктовПротокола - Булево - Использовать раздельное исполнение пунктов протокола.
//  Владелец - УправляемаяФорма - Владелец открывающихся для исполнения форм.
//  Протокол - ДанныеФормыКоллекция - Протокол мероприятия.
//
Процедура НаправитьПротоколМероприятияНаИсполнение(Мероприятие, РаздельноеИсполнениеПунктовПротокола, Владелец, Протокол = Неопределено) Экспорт
	
	Если РаздельноеИсполнениеПунктовПротокола Тогда
		НаправитьПротоколМероприятияНаИсполнениеРаздельное(Мероприятие, Протокол);
	Иначе
		
		Основание = Новый Структура;
		Основание.Вставить("ОперацияМероприятия", "ИсполнитьПротокол");
		Основание.Вставить("Мероприятие", Мероприятие);
		
		ПараметрыФормы = Новый Структура("Основание", Основание);
		ОткрытьФорму("БизнесПроцесс.Исполнение.ФормаОбъекта", ПараметрыФормы, Владелец);
		
	КонецЕсли;
	
КонецПроцедуры

// Останавливает исполнение по всем пунктам протокола мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//
Процедура ОстановитьИсполнениеПротокола(Мероприятие) Экспорт
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Остановить исполнение протокола мероприятия ""%1""?'; en = 'Event ""%1"" minutes performance has been stopped.'"),
		Мероприятие);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОстановитьИсполнениеПротоколаЗавершение",
		ЭтотОбъект,
		Мероприятие);
	
	ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
	
КонецПроцедуры

// См. ОстановитьИсполнениеПротокола.
//
Процедура ОстановитьИсполнениеПротоколаЗавершение(Результат, Мероприятие) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеМероприятиямиВызовСервера.ОстановитьИсполнениеПротокола(Мероприятие);
	
	ПоказатьОповещениеПользователя(,,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Остановлено исполнение протокола мероприятия ""%1"".'; en = 'Stop event ""%1"" minutes performance?'"),
			Мероприятие),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Продолжает исполнение по всем пунктам протокола мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//
Процедура ПродолжитьИсполнениеПротокола(Мероприятие) Экспорт
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Продолжить исполнение протокола мероприятия ""%1""?'; en = 'Continue event ""%1"" minutes performance?'"),
		Мероприятие);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжитьИсполнениеПротоколаЗавершение",
		ЭтотОбъект,
		Мероприятие);
	
	ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
	
КонецПроцедуры

// См. ПродолжитьИсполнениеПротокола.
//
Процедура ПродолжитьИсполнениеПротоколаЗавершение(Результат, Мероприятие) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеМероприятиямиВызовСервера.ПродолжитьИсполнениеПротокола(Мероприятие);
	
	ПоказатьОповещениеПользователя(,,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Продолжено исполнение протокола мероприятия ""%1"".'; en = 'Event ""%1"" minutes performance has been continued.'"),
			Мероприятие),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Прерывает исполнение по всем пунктам протокола мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//
Процедура ПрерватьИсполнениеПротокола(Мероприятие) Экспорт
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Прервать исполнение протокола мероприятия ""%1""?'; en = 'Terminate event ""%1"" minutes performance?'"),
		Мероприятие);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПрерватьИсполнениеПротоколаЗавершение",
		ЭтотОбъект,
		Мероприятие);
	
	ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
	
КонецПроцедуры

// См. ПрерватьИсполнениеПротокола.
//
Процедура ПрерватьИсполнениеПротоколаЗавершение(Результат, Мероприятие) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеМероприятиямиВызовСервера.ПрерватьИсполнениеПротокола(Мероприятие,
		НСтр("ru = 'Команда ""Прервать исполнение протокола"". Прерывание исполнения протокола мероприятия.'; en = 'Command ""Terminate minutes performance"". Terminates event minutes performance.'"));
	
	ПоказатьОповещениеПользователя(,,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Прервано исполнение протокола мероприятия ""%1"".'; en = 'Event ""%1"" minutes performance has been terminated.'"),
			Мероприятие),
		БиблиотекаКартинок.Информация32);
	
	ОповеститьОЗаписиПунктаПротокола(Мероприятие);
	
КонецПроцедуры

// Оповещает о записи пункта протокола мероприятия.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятие.
//  ПунктПротокола - СправочникСсылка.ПротоколыМероприятий - Пункт протокола мероприятия.
//
Процедура ОповеститьОЗаписиПунктаПротокола(Мероприятие, ПунктПротокола = Неопределено) Экспорт
	
	ПараметрыОповещения = Новый Структура("Мероприятие, ПунктПротокола", Мероприятие, ПунктПротокола);
	Оповестить("Запись_ПунктПротокола", ПараметрыОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Направляет протокол мероприятия на исполнение раздельное.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятия.
//  Протокол - ДанныеФормыКоллекция - Протокол мероприятия.
//
Процедура НаправитьПротоколМероприятияНаИсполнениеРаздельное(Мероприятие, Протокол = Неопределено)
	
	ПараметрыИсполнения = ПараметрыИсполнения(Мероприятие);
	Если Протокол <> Неопределено Тогда
		УправлениеМероприятиямиКлиентСервер.ОпределитьСостояниеИсполненияПротокола(Протокол, ПараметрыИсполнения);
	Иначе
		УправлениеМероприятиямиВызовСервера.ОпределитьСостояниеИсполненияПротокола(Мероприятие, ПараметрыИсполнения);
	КонецЕсли;
	
	Если ПараметрыИсполнения.СостояниеИсполненияПротокола = "НовоеИсполнение" Тогда
		ПредупреждениеПередЗапускомИсполнения(ПараметрыИсполнения);
		
	ИначеЕсли ПараметрыИсполнения.СостояниеИсполненияПротокола = "ЕстьНовыеПунктыПротокола" Тогда
		ПредупреждениеПередЗапускомИсполненияЕстьНовыеПунктыПротокола(ПараметрыИсполнения);
		
	ИначеЕсли ПараметрыИсполнения.СостояниеИсполненияПротокола = "ИсполнениеУжеЗапущено" Тогда
		ПредупреждениеПередЗапускомИсполненияИсполнениеУжеЗапущено(ПараметрыИсполнения);
		
	ИначеЕсли ПараметрыИсполнения.СостояниеИсполненияПротокола = "НетПунктовДляИсполнения" Тогда
		ПредупреждениеПередЗапускомИсполненияНетПунктовДляИсполнения(ПараметрыИсполнения);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует новую структуру параметров исполнения.
//
// Параметры:
//  Мероприятие - СправочникСсылка.Мероприятия - Мероприятия.
//
// Возвращаемое значение:
//  Структура - Параметры исполнения.
//
Функция ПараметрыИсполнения(Мероприятие)
	
	ПараметрыИсполнения = Новый Структура;
	ПараметрыИсполнения.Вставить("Мероприятие", Мероприятие);
	ПараметрыИсполнения.Вставить("СостояниеИсполненияПротокола", "НовоеИсполнение");
	ПараметрыИсполнения.Вставить("ПоВсемПунктам", Ложь);
	ПараметрыИсполнения.Вставить("ЕстьПунктыТребующиеИсполненияСИсполнителями", Ложь);
	ПараметрыИсполнения.Вставить("ЕстьПунктыТребующиеИсполненияБезИсполнителей", Ложь);
	ПараметрыИсполнения.Вставить("ЕстьПунктыНаИсполненииСИсполнителями", Ложь);
	ПараметрыИсполнения.Вставить("ЕстьПунктыНаИсполненииБезИсполнителей", Ложь);
	
	Возврат ПараметрыИсполнения;
	
КонецФункции

// Показывает предупреждение перед запуском протокола на исполнение.
//
// Параметры:
//  ПараметрыИсполнения - Структура - Параметры исполнения протокола.
//
Процедура ПредупреждениеПередЗапускомИсполнения(ПараметрыИсполнения)
	
	Если Не ПараметрыИсполнения.ЕстьПунктыТребующиеИсполненияСИсполнителями Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Невозможно запустить исполнение - для пунктов протокола не указаны исполнители или ответственные.'; en = 'It is impossible to send for performance - some minutes items have have no responsible or performers specified.'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредупреждениеПередЗапускомИсполненияЗавершение", ЭтотОбъект, ПараметрыИсполнения);
	ТекстВопроса = НСтр("ru = 'Все пункты протокола будут направлены на исполнение. Запустить исполнение?'; en = 'All minutes items will be sent for performance. Start performance?'");
	ДобавитьПредупреждениеОЗаполненииИсполнителей(ТекстВопроса, ПараметрыИсполнения);
	
	ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса, , , КодВозвратаДиалога.Да);
	
КонецПроцедуры

// См. ПредупреждениеПередЗапускомИсполнения.
//
Процедура ПредупреждениеПередЗапускомИсполненияЗавершение(Результат, ПараметрыИсполнения) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьНаправлениеПротоколМероприятияНаИсполнение(ПараметрыИсполнения);
	
КонецПроцедуры

// Показывает предупреждение перед запуском протокола на исполнение, если есть новые пункты протокола.
//
// Параметры:
//  ПараметрыИсполнения - Структура - Параметры исполнения протокола.
//
Процедура ПредупреждениеПередЗапускомИсполненияЕстьНовыеПунктыПротокола(ПараметрыИсполнения)
	
	Если Не ПараметрыИсполнения.ЕстьПунктыТребующиеИсполненияСИсполнителями
		И Не ПараметрыИсполнения.ЕстьПунктыНаИсполненииСИсполнителями Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Невозможно запустить исполнение - для пунктов протокола не указаны исполнители или ответственные.'; en = 'It is impossible to send for performance - some minutes items have have no responsible or performers specified.'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредупреждениеПередЗапускомИсполненияЕстьНовыеПунктыПротоколаЗавершение", ЭтотОбъект, ПараметрыИсполнения);
	
	ТекстВопроса = НСтр("ru = 'По некоторым пунктам протокола уже запущено исполнение.
		|Рекомендуется отправить исполнение только новым пунктам.
		|При отправке на исполнение по всем пунктам старые исполнения будут прерваны.
		|
		|Отправить протокол мероприятия на исполнение?';
		|en = 'Some minutes items have already been sent for performance.
		|It is recommended to sent for performance only new minutes items.
		|If you want to sent all event minutes items for performance
		|than all old perfromances will be terminated.
		|Send event minutes for performance?'");
	ДобавитьПредупреждениеОЗаполненииИсполнителей(ТекстВопроса, ПараметрыИсполнения);
	
	КнопкаПоУмолчанию = Неопределено;
	Кнопки = Новый СписокЗначений;
	Если ПараметрыИсполнения.ЕстьПунктыТребующиеИсполненияСИсполнителями Тогда
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Да, только по новым пунктам'; en = 'Yes, only new items'"));
		КнопкаПоУмолчанию = КодВозвратаДиалога.ОК;
	КонецЕсли;
	Если ПараметрыИсполнения.ЕстьПунктыНаИсполненииСИсполнителями Тогда
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Да, по всем пунктам'; en = 'Yes, all items'"));
	КонецЕсли;
	Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Нет'; en = 'No'"));
	Если КнопкаПоУмолчанию = Неопределено Тогда
		КнопкаПоУмолчанию = КодВозвратаДиалога.Отмена;
	КонецЕсли;
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки, , КнопкаПоУмолчанию);
	
КонецПроцедуры

// См. ПредупреждениеПередЗапускомИсполненияЕстьНовыеПунктыПротокола.
//
Процедура ПредупреждениеПередЗапускомИсполненияЕстьНовыеПунктыПротоколаЗавершение(Результат, ПараметрыИсполнения) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК И Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИсполнения.ПоВсемПунктам = (Результат = КодВозвратаДиалога.Да);
	ВыполнитьНаправлениеПротоколМероприятияНаИсполнение(ПараметрыИсполнения);
	
КонецПроцедуры

// Показывает предупреждение перед запуском протокола на исполнение, если исполнение уже запущено.
//
// Параметры:
//  ПараметрыИсполнения - Структура - Параметры исполнения протокола.
//
Процедура ПредупреждениеПередЗапускомИсполненияИсполнениеУжеЗапущено(ПараметрыИсполнения)
	
	Если Не ПараметрыИсполнения.ЕстьПунктыНаИсполненииСИсполнителями Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Невозможно запустить исполнение - по пунктам протокола запущено исполнение и для них не указаны исполнители или ответственные.'; en = 'It is impossible to send for performance - some minutes items have already been sent for performance and they have no responsible or performers specified.'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредупреждениеПередЗапускомИсполненияИсполнениеУжеЗапущеноЗавершение", ЭтотОбъект, ПараметрыИсполнения);
	ТекстВопроса = НСтр("ru = 'По всем пунктам протокола уже запущено исполнение.
		|При отправке протокола на исполнение старые исполнения будут прерваны.
		|
		|Отправить протокол мероприятия на исполнение?';
		|en = 'All minutes items have already been sent for performance.
		|If you want to sent event minutes for performance again
		|than all old perfromances will be terminated.
		|Send event minutes for performance?'");
	ДобавитьПредупреждениеОЗаполненииИсполнителей(ТекстВопроса, ПараметрыИсполнения);
	
	ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса, , , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

// См. ПредупреждениеПередЗапускомИсполненияИсполнениеУжеЗапущено.
//
Процедура ПредупреждениеПередЗапускомИсполненияИсполнениеУжеЗапущеноЗавершение(Результат, ПараметрыИсполнения) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИсполнения.ПоВсемПунктам = Истина;
	ВыполнитьНаправлениеПротоколМероприятияНаИсполнение(ПараметрыИсполнения);
	
КонецПроцедуры

// Показывает предупреждение при отказе от направления протокола на исполнение, так как нет пунктов для исполнения.
//
// Параметры:
//  ПараметрыИсполнения - Структура - Параметры исполнения протокола.
//
Процедура ПредупреждениеПередЗапускомИсполненияНетПунктовДляИсполнения(ПараметрыИсполнения)
	
	ПоказатьПредупреждение(, НСтр("ru = 'Нет пунктов протокола мероприятия, по которым требуется исполнение.'; en = 'There are no minutes items requiring performance.'"));
	
КонецПроцедуры

// Выполняет направление протокола мероприятия на исполнение.
//
// Параметры:
//  ПараметрыИсполнения - Структура - Параметры исполнения протокола.
//
Процедура ВыполнитьНаправлениеПротоколМероприятияНаИсполнение(ПараметрыИсполнения)
	
	УправлениеМероприятиямиВызовСервера.НаправитьПротоколМероприятияНаИсполнение(ПараметрыИсполнения);
	
	ПоказатьОповещениеПользователя(,,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Направлен на исполнение протокол мероприятия ""%1"".'; en = 'Event ""%1"" minutes has been sent for performance.'"),
			ПараметрыИсполнения.Мероприятие),
		БиблиотекаКартинок.Информация32);
	
	ОповеститьОЗаписиПунктаПротокола(ПараметрыИсполнения.Мероприятие);
	
КонецПроцедуры

// Добавляет к строке предупреждение о заполнении исполнителей.
//
// Параметры:
//  ТекстВопроса		 - Строка	 - Текст вопросе перед запуском исполнения.
//  ПараметрыИсполнения	 - Структура - Параметры исполнения протокола.
//
Процедура ДобавитьПредупреждениеОЗаполненииИсполнителей(ТекстВопроса, ПараметрыИсполнения)
	
	ТекстПредупрежденияОЗаполненииИсполнителей =
		Символы.ПС + Символы.ПС + НСтр("ru = 'Внимание! Не у всех пунктов указаны исполнители или ответственные.
		|Пункты без исполнителей и ответственных направлены на исполнение не будут.';
		|en = 'Attention! Not all minutes items have responsibles or performers specified.
		|Minutes items without responsibles or performers will not be sent for perfromance.'");
	
	Если ПараметрыИсполнения.СостояниеИсполненияПротокола = "НовоеИсполнение"
		И ПараметрыИсполнения.ЕстьПунктыТребующиеИсполненияБезИсполнителей Тогда
		
		ТекстВопроса = ТекстВопроса + ТекстПредупрежденияОЗаполненииИсполнителей;
		
	ИначеЕсли ПараметрыИсполнения.СостояниеИсполненияПротокола = "ЕстьНовыеПунктыПротокола"
		И ((ПараметрыИсполнения.ЕстьПунктыТребующиеИсполненияСИсполнителями
					И ПараметрыИсполнения.ЕстьПунктыТребующиеИсполненияБезИсполнителей)
				Или (ПараметрыИсполнения.ЕстьПунктыНаИсполненииСИсполнителями
					И ПараметрыИсполнения.ЕстьПунктыНаИсполненииБезИсполнителей))Тогда
		
		ТекстВопроса = ТекстВопроса + ТекстПредупрежденияОЗаполненииИсполнителей;
		
	ИначеЕсли ПараметрыИсполнения.СостояниеИсполненияПротокола = "ИсполнениеУжеЗапущено"
		И ПараметрыИсполнения.ЕстьПунктыНаИсполненииБезИсполнителей Тогда
		
		ТекстВопроса = ТекстВопроса + ТекстПредупрежденияОЗаполненииИсполнителей;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
