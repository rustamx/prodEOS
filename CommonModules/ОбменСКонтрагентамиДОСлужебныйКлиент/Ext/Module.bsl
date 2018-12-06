﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиСлужебныйКлиент: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Только для внутреннего использования
Процедура ОбработатьОтклонениеАннулированиеДокументаДО(ДокументДО, ПараметрыЭД, ОтклонитьАннулирование = Ложь) Экспорт
	
	МассивФайловЭД = ОбменСКонтрагентамиДОВызовСервера.ВернутьМассивФайловЭДПоДокументДО(ДокументДО);
	Если МассивФайловЭД.Количество() > 0 Тогда
		СсылкаНаЭД = МассивФайловЭД[0].ФайлЭД;
		ПараметрыЭД.Вставить("МасивФайловЭД", МассивФайловЭД);
	Иначе
		Возврат;
	КонецЕсли; 

	
	Если ПараметрыЭД.Отклонить Тогда
		ФормироватьЭД = Ложь;
		ПродолжитьОбработку = ОбменСКонтрагентамиСлужебныйВызовСервера.МожноОтклонитьЭтотЭД(СсылкаНаЭД, ФормироватьЭД);
		Если ОтклонитьАннулирование Тогда
			Заголовок = НСтр("ru = 'Укажите причины отклонения предложения об аннулировании'; en = 'Specify the reason for the rejection of the proposal of cancellation'");
		Иначе
			
			Если ОбменСКонтрагентамиСлужебныйВызовСервера.ЭтоСчетФактура(СсылкаНаЭД) Тогда
				Заголовок = НСтр("ru = 'Укажите текст запроса на уточнение'; en = 'Specify the text of request for clarification'");
			Иначе
				Заголовок = НСтр("ru = 'Укажите причины отклонения документа'; en = 'Specify the reason for the rejection of the document'");
			КонецЕсли;
			
		КонецЕсли;
	Иначе
		ФормироватьЭД = Истина;
		ПродолжитьОбработку = ОбменСКонтрагентамиСлужебныйВызовСервера.МожноАннулироватьЭтотЭД(СсылкаНаЭД);
		Заголовок = НСтр("ru = 'Укажите причины аннулирования документа'; en = 'Specify the reasons for cancellation of the document'");
	КонецЕсли;
	Если ПродолжитьОбработку Тогда
		ТекстУточнения = "";
		ПараметрыЭД.Вставить("ФормироватьЭД", ФормироватьЭД);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьОтклонениеАннулированиеЭДЗавершить", ЭтотОбъект, ПараметрыЭД);
		ПоказатьВводСтроки(ОписаниеОповещения, ТекстУточнения, Заголовок, , Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение процедуры ОбработатьОтклонениеАннулированиеЭД.
Процедура ОбработатьОтклонениеАннулированиеЭДЗавершить(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Текст = НСтр("ru = '%1, %2:
			|%3';
			|en = '%1, %2:
			|%3'");
		ТекстУточнения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Текст,
			ДополнительныеПараметры.Организация, ПользователиКлиентСервер.ТекущийПользователь(), Результат);
		
		Если ДополнительныеПараметры.Отклонить Тогда
			ВидСлужебногоЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.УведомлениеОбУточнении");
		Иначе
			ВидСлужебногоЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.ПредложениеОбАннулировании");
		КонецЕсли;
		// При аннулировании параметр ФормироватьЭД всегда имеет значение Истина,
		// при отклонении может иметь значение как Истина, так и Ложь.
		ОписаниеОповещения = Неопределено;
		ДополнительныеПараметры.Свойство("ОписаниеОповещения", ОписаниеОповещения);
		ФормироватьЭД = Ложь;
		Для каждого СтруктураМассиваФайловЭД Из ДополнительныеПараметры.МасивФайловЭД Цикл
			
			Если НЕ (ДополнительныеПараметры.Свойство("ФормироватьЭД", ФормироватьЭД) И ФормироватьЭД = Истина) Тогда
				НовыйСтатусЭД = ПредопределенноеЗначение("Перечисление.СтатусыЭД.Отклонен");
				СтруктураПараметров = Новый Структура("СтатусЭД, ПричинаОтклонения", НовыйСтатусЭД, Результат);
				ОбменСКонтрагентамиСлужебныйВызовСервера.ИзменитьПоСсылкеПрисоединенныйФайл(
					СтруктураМассиваФайловЭД.ФайлЭД, СтруктураПараметров, Ложь);
			Иначе
				ОбменСКонтрагентамиСлужебныйКлиент.СформироватьПодписатьСлужебныйЭД(СтруктураМассиваФайловЭД.ФайлЭД,
					ВидСлужебногоЭД, ТекстУточнения);
			КонецЕсли;
		
		КонецЦикла;
		
		Если ТипЗнч(ОписаниеОповещения) = Тип("ОписаниеОповещения") Тогда
				ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
		КонецЕсли;
		
	ИначеЕсли Результат <> Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Причина не указана, действие отменено.'; en = 'Reason is not specified, action is canceled.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗапроситьСогласиеСформироватьДокументЭДО(Объект, Отказ, ЭтаФорма) Экспорт
	
	Если ЭтаФорма.ЕстьЭДО Тогда
		
		СостояниеВерсииДокументаПоЭДО = ОбменСКонтрагентамиДОВызовСервера.ДанныеСостоянияДокументаПоЭДО(Объект.Ссылка);
		Если СостояниеВерсииДокументаПоЭДО = Неопределено Тогда
			
			КонтрагентыГотовыеКЭДО = Неопределено;
			Если ОбменСКонтрагентамиДОВызовСервера.ДокументГотовКФормированиюЭД(Объект.Ссылка, Ложь, КонтрагентыГотовыеКЭДО) Тогда
				
				ПараметрыОбработчика = Новый Структура();
				ПараметрыОбработчика.Вставить("ЭтаФорма", ЭтаФорма);
				ПараметрыОбработчика.Вставить("Объект", Объект);
				ПараметрыОбработчика.Вставить("КонтрагентыГотовыеКЭДО", КонтрагентыГотовыеКЭДО);
				
				Оповещение = Новый ОписаниеОповещения("ВопросОтправкиПоЭДОЗавершение", ЭтотОбъект, ПараметрыОбработчика);
				Отказ = Истина;
				ТекстВопроса = НСтр("ru = 'Документ готов к отправке по ЭДО. 
					|Поставить в очередь на отправку по ЭДО сейчас?';
					|en = 'The document is ready to be sent via EDI. 
					|Put it into the EDI queue?'");
				ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоставитьДокументВОчередьНаОтправкуПоЭДО(Документ, КонтрагентыГотовыеКЭДО = Неопределено, НаправлениеЭД, 
	ПроверятьПодписанДокумент = Истина) Экспорт
	
	Если КонтрагентыГотовыеКЭДО = Неопределено Тогда
		Если Не ОбменСКонтрагентамиДОВызовСервера.ДокументГотовКФормированиюЭД(Документ, Истина, 
			КонтрагентыГотовыеКЭДО, ПроверятьПодписанДокумент) Тогда
			Возврат Ложь;
		КонецЕсли; 
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(КонтрагентыГотовыеКЭДО) Тогда
		Для каждого КонтрагентГотовыйКЭДО Из КонтрагентыГотовыеКЭДО Цикл
			ОбменСКонтрагентамиДОВызовСервера.УстановитьСостояниеДокументаЭДО(
				Документ, 
				КонтрагентГотовыйКЭДО,
				ПредопределенноеЗначение("Перечисление.СостоянияВерсийЭДДО.ПоставленВОчередьНаОтправку"),
				НаправлениеЭД);
		КонецЦикла; 
		
		Текст = НСтр("ru = 'Документ поставлен в очередь на отправку контрагентам по ЭДО.'; en = 'The document was put to a queue to send via EDI.'");
		Состояние(Текст, , , БиблиотекаКартинок.ЭмблемаСервиса1СЭДО);
		Возврат Истина;
	КонецЕсли; 
	
	Возврат Ложь;

КонецФункции
	
&НаКлиенте
Функция ДокументГотовКФормированиюЭД(Документ, ВыводитьСообщение = Ложь, КонтрагентыГотовыеКЭДО = Неопределено, 
	ПроверятьПодписанДокумент = Истина) Экспорт
	
		Возврат ОбменСКонтрагентамиДОВызовСервера.ДокументГотовКФормированиюЭД(Документ, ВыводитьСообщение, КонтрагентыГотовыеКЭДО, 
			ПроверятьПодписанДокумент);

КонецФункции
	
&НаКлиенте
Процедура ВопросОтправкиПоЭДОЗавершение(Результат, ПараметрыОбработчика) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПоставитьДокументВОчередьНаОтправкуПоЭДО(
			ПараметрыОбработчика.Объект.Ссылка, 
			ПараметрыОбработчика.КонтрагентыГотовыеКЭДО, 
			ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий"));
			
		
		ПараметрыОбработчика.ЭтаФорма.ПоказанВопросОбОтправкеПоЭДО = Истина;
		ПараметрыОбработчика.ЭтаФорма.Закрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ПараметрыОбработчика.ЭтаФорма.ПоказанВопросОбОтправкеПоЭДО = Истина;
		ОбменСКонтрагентамиДОВызовСервера.УдалитьСостояниеДокументаЭДО( ПараметрыОбработчика.Объект.Ссылка);
		ПараметрыОбработчика.ЭтаФорма.Закрыть();
	КонецЕсли;
		
КонецПроцедуры


&НаКлиенте
Процедура ПодписатьЭДНаСторонеПолучателя(ДокументДО, ОбработчикЗавершения) Экспорт
	
	МассивФайловЭД = ОбменСКонтрагентамиДОВызовСервера.ВернутьМассивФайловЭДПоДокументДО(ДокументДО);
	
	Если МассивФайловЭД.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	Для каждого СтруктураМассиваФайловЭД Из МассивФайловЭД Цикл
		//ОбменСКонтрагентамиСлужебныйКлиент.УтвердитьЭД(ДокументДО, ФайлЭД, Истина, ДопПараметры);
		//ОбменСКонтрагентамиКлиент.СформироватьПодписатьОтправитьЭД(СтруктураМассиваФайловЭД.ЭД, СтруктураМассиваФайловЭД.ФайлЭД);
		
		МассивСсылок = ЭлектронноеВзаимодействиеСлужебныйКлиент.МассивПараметров(СтруктураМассиваФайловЭД.ЭД);
		Если МассивСсылок = Неопределено Тогда
			Если СтруктураМассиваФайловЭД.ФайлЭД = Неопределено Тогда
				Возврат;
			Иначе
				МассивСсылок = Новый Массив;
			КонецЕсли;
		КонецЕсли;
	
		ОбменСКонтрагентамиСлужебныйКлиент.ОбработатьЭД(МассивСсылок, "УтвердитьПодписатьОтправить", , 
			СтруктураМассиваФайловЭД.ФайлЭД, ОбработчикЗавершения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УтвердитьЭД(ДокументДО) Экспорт
	
	МассивФайловЭД = ОбменСКонтрагентамиДОВызовСервера.ВернутьМассивФайловЭДПоДокументДО(ДокументДО);
	
	Если МассивФайловЭД.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	Для каждого СтруктураМассиваФайловЭД Из МассивФайловЭД Цикл
	
		МассивСсылок = ЭлектронноеВзаимодействиеСлужебныйКлиент.МассивПараметров(СтруктураМассиваФайловЭД.ЭД);
		Если МассивСсылок = Неопределено Тогда
			Если СтруктураМассиваФайловЭД.ФайлЭД = Неопределено Тогда
				Возврат;
			Иначе
				МассивСсылок = Новый Массив;
			КонецЕсли;
		КонецЕсли;
	
		ОбменСКонтрагентамиСлужебныйКлиент.ОбработатьЭД(МассивСсылок, "Утвердить", , 
			СтруктураМассиваФайловЭД.ФайлЭД);
		
	КонецЦикла;
	
КонецПроцедуры



#КонецОбласти
