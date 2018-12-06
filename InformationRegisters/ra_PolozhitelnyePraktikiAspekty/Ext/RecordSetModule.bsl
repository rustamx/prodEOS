﻿
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если Количество() = 1 Тогда
			
			Если ДанныеЗаполнения.Свойство("ZayavkaNaKontrolnuyuOperaciyu") Тогда
				Отбор.ZayavkaNaKontrolnuyuOperaciyu.Установить(ДанныеЗаполнения.ZayavkaNaKontrolnuyuOperaciyu);
			КонецЕсли;
			
			Если ДанныеЗаполнения.Свойство("ID") Тогда
				Отбор.ID.Установить(ДанныеЗаполнения.ID);
			КонецЕсли;
						
			Если ДанныеЗаполнения.Свойство("ZayavkaNaKontrolnuyuOperaciyu") И
					ДанныеЗаполнения.Свойство("ID") Тогда
				Прочитать();
			Иначе
				ЗаполнитьЗначенияСвойств(ЭтотОбъект[0], ДанныеЗаполнения);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаНабора.ID) Тогда
			СтрокаНабора.ID = Новый УникальныйИдентификатор();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	РегистрыСведений.ra_PolozhitelnyePraktikiAspekty.АктуализироватьМассивОбязательныхРеквизитов(ПроверяемыеРеквизиты, ЭтотОбъект[0]);
			
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Отбор.ZayavkaNaKontrolnuyuOperaciyu.Значение) Тогда
		ВызватьИсключение НСтр("ru = 'Не указана Заявка на контрольную операцию.';
					|en = 'Application for control operation is not specified.'");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отбор.ID.Значение) Тогда
		ВызватьИсключение НСтр("ru = 'Не указан уникальный идентификатор строки.';
					|en = 'Unique identificator is not specified.'");
	КонецЕсли;
	
	ПроверитьВозможностьУдаления(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьВозможностьУдаления(НаборДанных, Отказ)
	
	Если НЕ НаборДанных.ДополнительныеСвойства.Свойство("УдалениеЗаписей") Тогда
		Возврат;
	КонецЕсли;
					
КонецПроцедуры

#КонецОбласти