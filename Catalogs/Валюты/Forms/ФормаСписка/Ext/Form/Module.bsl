﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДатаКурса = НачалоДня(ТекущаяДатаСеанса());
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", ДатаКурса);
	Список.Параметры.УстановитьЗначениеПараметра("ПояснениеКратности", НСтр("ru = 'руб. за'; en = 'rub. for'"));
	
	Элементы.Валюты.РежимВыбора = Параметры.РежимВыбора;
	
	Если Не Пользователи.РолиДоступны("ДобавлениеИзменениеКурсовВалют") Тогда
		Элементы.ФормаПодборИзОКВ.Видимость = Ложь;
		Элементы.ФормаЗагрузитьКурсыВалют.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Элементы.Валюты.Обновить();
	Элементы.Валюты.ТекущаяСтрока = РезультатВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КурсыВалют"
		Или ИмяСобытия = "Запись_ЗагрузкаКурсовВалют" Тогда
		Элементы.Валюты.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьВалюту(Команда)
	ОткрытьФорму("Справочник.Валюты.ФормаОбъекта", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПодборИзОКВ(Команда)
	ОткрытьФорму("Справочник.Валюты.Форма.ПодборВалютИзКлассификатора", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКурсыВалют(Команда)
	ПараметрыФормы = Новый Структура("ОткрытиеИзСписка");
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти
