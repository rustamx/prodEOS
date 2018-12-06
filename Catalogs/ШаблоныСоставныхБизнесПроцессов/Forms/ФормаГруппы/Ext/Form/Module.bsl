﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьПредставлениеТипаШаблона();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеТипаШаблонаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокТипов = СписокТиповШаблонов();
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредставлениеТипаШаблонаНачалоВыбора_Завершение", ЭтаФорма);
	
	ПоказатьВыборИзМеню(ОписаниеОповещения, СписокТипов, Элементы.ПредставлениеТипаШаблона);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТипаШаблонаНачалоВыбора_Завершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ТипШаблона = РезультатВыбора.Значение;
	
	ЗаполнитьПредставлениеТипаШаблона();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет реквизит ПредставлениеТипаШаблона
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеТипаШаблона()
	
	СписокТипов = СписокТиповШаблонов();
	
	ЭлементСписка = СписокТипов.НайтиПоЗначению(Объект.ТипШаблона);
	
	ПредставлениеТипаШаблона = ЭлементСписка.Представление;
	
КонецПроцедуры

// Возвращает список типов шаблонов
//
// Возвращаемое значение:
//   СписокЗначений - список строковых значений
//                    ОбработкаВнутреннегоДокумента, ОбработкаВходящегоДокумента, ОбработкаИсходящегоДокумента).
//
&НаКлиенте
Функция СписокТиповШаблонов()
	
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить("ОбработкаВнутреннегоДокумента", НСтр("ru = 'Обработка внутреннего документа'; en = 'Internal document processing'"));
	СписокТипов.Добавить("ОбработкаВходящегоДокумента", НСтр("ru = 'Обработка входящего документа'; en = 'Incoming document processing'"));
	СписокТипов.Добавить("ОбработкаИсходящегоДокумента", НСтр("ru = 'Обработка исходящего документа'; en = 'Outgoing document processing'"));
	
	Возврат СписокТипов;
	
КонецФункции

#КонецОбласти
