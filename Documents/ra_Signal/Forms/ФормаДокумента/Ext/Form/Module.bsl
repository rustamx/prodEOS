﻿
#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Объект.Ссылка.Пустая() Тогда
		УстановитьВысотуПолучателей();
    КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьВысотуПолучателей();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	УстановитьВысотуПолучателей();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Направить(Команда)
	
	ОткрытьФорму("Документ.ra_Signal.Форма.ФормаВыбораПолучателя",,ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВысотуПолучателей()

	Элементы.Poluchateli.ВысотаВСтрокахТаблицы = Макс(Мин(Объект.Poluchateli.Количество(), 7), 1);
	
КонецПроцедуры

#КонецОбласти
