﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий
	
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
				
	Если Параметры.Свойство("ZayavkaNaKontrolnuyuOperaciyu") Тогда
		Proekt = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ZayavkaNaKontrolnuyuOperaciyu, "Proekt");
		Параметры.Отбор.Вставить("Владелец", Proekt);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Oboznachenie");
	
	Если ТекущийЯзык() = Метаданные.Языки.Английский Тогда
		Поля.Добавить("NaimenovanieEn");	
	Иначе
		Поля.Добавить("Наименование");	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Представление = "(" + Данные.Oboznachenie + ") " + ?(Данные.Свойство("Наименование"), Данные.Наименование, Данные.NaimenovanieEn);
	
	ра_ОбщегоНазначения.ОбработатьПустоеПредставление(Представление);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли