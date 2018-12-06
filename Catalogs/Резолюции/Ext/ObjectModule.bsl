﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка прав на добавление или изменение. Права на добавление имеет автор, 
	// на изменение - автор и исполнитель, а также их делегаты и руководители.
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Если ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа()
		И Не ПривилегированныйРежим()
		И Не Пользователи.ЭтоПолноправныйПользователь(ТекущийПользователь) Тогда
		
		// Права на добавление/изменение документа.
		ПраваНаДокумент = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Документ);
		ОперацияРазрешена = ?(ЭтоНовый(), 
			ПраваНаДокумент.Добавление Или ПраваНаДокумент.Изменение,
			ПраваНаДокумент.Изменение);
		
		Если ОперацияРазрешена Тогда
			
			// Права на добавление/изменение резолюции
			Запрос = Новый Запрос(
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ИСТИНА КАК ЕстьЗаписи
				|ИЗ
				|	РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
				|ГДЕ
				|	СоставСубъектовПравДоступа.Пользователь = &ТекущийПользователь
				|	И СоставСубъектовПравДоступа.Субъект = &ВнесРезолюцию
				|	ИЛИ СоставСубъектовПравДоступа.Субъект = &АвторРезолюции
				|");
			
			Запрос.УстановитьПараметр("ТекущийПользователь", ТекущийПользователь);
			Запрос.УстановитьПараметр("ВнесРезолюцию", ВнесРезолюцию);
			Запрос.УстановитьПараметр("АвторРезолюции", АвторРезолюции);
			
			Результат = Запрос.Выполнить();
			ОперацияРазрешена = Не Результат.Пустой();
			
		КонецЕсли;
		
		Если Не ОперацияРазрешена Тогда
			ВызватьИсключение НСтр("ru = 'Недостаточно прав для выполнения операции. 
				|Обратитесь к администратору.';
				|en = 'Insufficient permissions to perform the operation. 
				|Please contact the administrator.'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Документ <> Неопределено Тогда
		
		// Добавление участников из самого документа.
		Если РаботаСРабочимиГруппами.ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы(Документ) Тогда 
			
			ТаблицаУчастников = РаботаСРабочимиГруппами.ПолучитьРабочуюГруппуДокумента(Документ);
			
			РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаУчастников, АвторРезолюции);
			РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаУчастников, ВнесРезолюцию);
			
			Попытка
				РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(Документ, ТаблицаУчастников, Истина);
			Исключение
				Если ЗначениеЗаполнено(Источник) Тогда
					// Если виза создана процессом или задачей, то
					// ошибку перезаписи обрабатываем особым образом.
					РаботаСРабочимиГруппами.ОбработатьИсключениеПерезаписиРабочейГруппыПредметаПроцесса(Документ);
				Иначе
					ВызватьИсключение;
				КонецЕсли;
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
