﻿
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если Количество() = 1 Тогда
			
			Если ДанныеЗаполнения.Свойство("Nesootvetstvie") Тогда
				Отбор.Nesootvetstvie.Установить(ДанныеЗаполнения.Nesootvetstvie);
			КонецЕсли;
			Если ДанныеЗаполнения.Свойство("KodPrichiny") Тогда
				Отбор.KodPrichiny.Установить(ДанныеЗаполнения.KodPrichiny);
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект[0], ДанныеЗаполнения);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	РегистрыСведений.ra_PrichinyNesootvetstvij.АктуализироватьМассивОбязательныхРеквизитов(ПроверяемыеРеквизиты, ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ДополнительныеСвойства.Свойство("УдалениеЗаписей") Тогда
		Если ЗначениеЗаполнено(Отбор.Nesootvetstvie.Значение) Тогда
			УдалитьУзлыДерева(РегистрыСведений.ra_PrichinyNesootvetstvij.ПрочитатьДеревоПричинНаСервере(
				Отбор.Nesootvetstvie.Значение, Отбор.KodPrichiny.Значение, Ложь));
			
			Запись = РегистрыСведений.ra_PrichinyNesootvetstvij.СоздатьНаборЗаписей();
			Запись.Отбор.Nesootvetstvie.Установить(Отбор.Nesootvetstvie.Значение);
			Запись.Отбор.KodPrichiny.Установить(Отбор.KodPrichiny.Значение);
			Запись.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УдалитьУзлыДерева(Коллекция)
	
	Для каждого Строка Из Коллекция.Строки Цикл
		Запись = РегистрыСведений.ra_PrichinyNesootvetstvij.СоздатьНаборЗаписей();
		Запись.Отбор.Nesootvetstvie.Установить(Строка.Nesootvetstvie);
		Запись.Отбор.KodPrichiny.Установить(Строка.KodPrichiny);
		Запись.Записать();
		
		УдалитьУзлыДерева(Строка);
	КонецЦикла;
	
КонецФункции

#КонецОбласти
