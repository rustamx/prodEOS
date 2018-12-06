﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ОбновитьДанныеГруппыЛичныхАдресатовВАдреснойКниге;

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыГруппыПоСсылке =  ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Родитель, ПометкаУдаления, Наименование");
	
	ПометкаИБ = РеквизитыГруппыПоСсылке.ПометкаУдаления;
	
	Если ПометкаУдаления <> ПометкаИБ И Не Ссылка.Пустая() Тогда
		
		// Отбираем адресатов и пытаемся поставить им пометку удаления
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЛичныеАдресаты.Ссылка
			|ИЗ
			|	Справочник.ЛичныеАдресаты КАК ЛичныеАдресаты
			|ГДЕ
			|	ЛичныеАдресаты.Группа = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			АдресатОбъект = Выборка.Ссылка.ПолучитьОбъект();
			АдресатОбъект.Заблокировать();
			АдресатОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Обновление адресной книги
	ОбновитьДанныеГруппыЛичныхАдресатовВАдреснойКниге = Ложь;
	Если ЭтоНовый() Тогда
		ОбновитьДанныеГруппыЛичныхАдресатовВАдреснойКниге = Истина;
	Иначе
		Если РеквизитыГруппыПоСсылке.Родитель <> Родитель
			Или РеквизитыГруппыПоСсылке.ПометкаУдаления <> ПометкаУдаления
			Или РеквизитыГруппыПоСсылке.Наименование <> Наименование Тогда
			
			ОбновитьДанныеГруппыЛичныхАдресатовВАдреснойКниге = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление адресной книги
	Если ОбновитьДанныеГруппыЛичныхАдресатовВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОбъекта(
			Ссылка, Родитель, Справочники.АдреснаяКнига.ЛичныеАдресаты, Пользователь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
