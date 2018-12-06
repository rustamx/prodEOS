﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Справочники.ИдентификаторыОбъектовМетаданных.ФормаЭлементаПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	Элементы.ФормаВключитьВозможностьРедактирования.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяПриИзменении(Элемент)
	
	ПолноеИмя = Объект.ПолноеИмя;
	ОбновитьСвойстваИдентификатора();
	
	Если ПолноеИмя <> Объект.ПолноеИмя Тогда
		Объект.ПолноеИмя = ПолноеИмя;
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Объект метаданных не найден по полному имени:
			           |%1.'; en = 'Metadata object could not be found on the full name is: %1.'"),
			ПолноеИмя));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСвойстваИдентификатора()
	
	Справочники.ИдентификаторыОбъектовМетаданных.ОбновитьСвойстваИдентификатора(Объект);
	
КонецПроцедуры

#КонецОбласти
