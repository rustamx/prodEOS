﻿
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если Количество() = 1 Тогда
			
			Если ДанныеЗаполнения.Свойство("ZayavkaNaKontrolnuyuOperaciyu") Тогда
				Отбор.ZayavkaNaKontrolnuyuOperaciyu.Установить(ДанныеЗаполнения.ZayavkaNaKontrolnuyuOperaciyu);
			КонецЕсли;
						
			Если ДанныеЗаполнения.Свойство("Otvetstvennyj") Тогда
				Отбор.Otvetstvennyj.Установить(ДанныеЗаполнения.Otvetstvennyj);
			КонецЕсли;
						
			Если ДанныеЗаполнения.Свойство("ZayavkaNaKontrolnuyuOperaciyu") И
				 ДанныеЗаполнения.Свойство("Otvetstvennyj") Тогда
				Прочитать();
			Иначе
				ЗаполнитьЗначенияСвойств(ЭтотОбъект[0], ДанныеЗаполнения);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Отбор.ZayavkaNaKontrolnuyuOperaciyu.Значение) Тогда
		ВызватьИсключение НСтр("ru = 'Не указано Заявка на контрольную операцию.';
					|en = 'Application for control operation is not specified.'");
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Отбор.Otvetstvennyj.Значение) Тогда
		ВызватьИсключение НСтр("ru = 'Не указан ответственный.';
					|en = 'Responsible person is not specified.'");
	КонецЕсли;
	
	ПроверитьВозможностьУдаления(ЭтотОбъект, Отказ);
	
	Если Количество() = 1 Тогда
		Если ЗначениеЗаполнено(ЭтотОбъект[0].Otvetstvennyj) Тогда
			ЭтотОбъект[0].Podrazdelenie = РаботаСПользователями.ПолучитьПодразделение(ЭтотОбъект[0].Otvetstvennyj);
			ЭтотОбъект[0].Dolzhnost = РаботаСПользователями.ПолучитьДолжность(ЭтотОбъект[0].Otvetstvennyj);
		КонецЕсли;
	КонецЕсли;
			
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивПользователей = ЭтотОбъект.ВыгрузитьКолонку("Otvetstvennyj");
	ПараметрыПроцесса = Новый Структура("Исполнители", МассивПользователей);
	КонтекстСобытия = Новый ХранилищеЗначения(ПараметрыПроцесса);
	
	Если ЭтотОбъект.Количество() Тогда
		БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(
			ЭтотОбъект.Отбор.ZayavkaNaKontrolnuyuOperaciyu.Значение, 
			Справочники.ВидыБизнесСобытий.ра_ИзменениеУчастниковКО,
			КонтекстСобытия);
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