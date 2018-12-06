﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	Если Параметры.Свойство("ТекущаяПапкаПоиска") и ЗначениеЗаполнено(Параметры.ТекущаяПапкаПоиска) Тогда
		Элементы.Список.ТекущаяСтрока = Параметры.ТекущаяПапкаПоиска;
	КонецЕсли;
	Если Параметры.Свойство("ВыборПапкиДляСохранения") Тогда
		ФормаОткрытаДляСохраненияПоиска = Параметры.ВыборПапкиДляСохранения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ФормаОткрытаДляСохраненияПоиска И Не Копирование Тогда
		Отказ = Истина;
		НаименованиеПапки = "";
		ЗаголовокДиалога = НСтр("ru = 'Введите название новой папки'; en = 'Enter the name of the new folder'");
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"СписокПередНачаломДобавленияПродолжение",
			ЭтотОбъект);
		ПоказатьВводСтроки(ОписаниеОповещения, НаименованиеПапки, ЗаголовокДиалога); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавленияПродолжение(НаименованиеПапки, Параметры) Экспорт
	
	Если Не ЗначениеЗаполнено(НаименованиеПапки) Тогда
		Возврат;
	КонецЕсли;
	НоваяПапка = СоздатьНовуюПапку(НаименованиеПапки, ПользователиКлиентСервер.ТекущийПользователь());
	ОповеститьОбИзменении(Тип("СправочникСсылка.ПапкиПоиска"));
	Закрыть(НоваяПапка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьНовуюПапку(НаименованиеПапки, Пользователь)
	
	Папка = Справочники.ПапкиПоиска.СоздатьЭлемент();
	Папка.Наименование = НаименованиеПапки;
	Папка.Ответственный = Пользователь;
	Папка.Записать();
	
	Возврат Папка.Ссылка;
	
КонецФункции


