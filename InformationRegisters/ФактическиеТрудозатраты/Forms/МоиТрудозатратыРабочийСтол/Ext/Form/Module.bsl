﻿
&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СпособУказанияВремени = ХранилищеОбщихНастроек.Загрузить("НастройкиУчетаВремени", "СпособУказанияВремени");
	Если Не ЗначениеЗаполнено(СпособУказанияВремени) Тогда
		СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность;
	КонецЕсли;	
	
	Если СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность Тогда 
		Элементы.Длительность.Видимость = Истина;
		Элементы.Начало.Видимость = Ложь;
		Элементы.Окончание.Видимость = Ложь;
	Иначе
		Элементы.Длительность.Видимость = Ложь;
		Элементы.Начало.Видимость = Истина;
		Элементы.Окончание.Видимость = Истина;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	Список.Параметры.УстановитьЗначениеПараметра("НачалоСегодня", НачалоДня(ТекущаяДата()));
	
КонецПроцедуры


