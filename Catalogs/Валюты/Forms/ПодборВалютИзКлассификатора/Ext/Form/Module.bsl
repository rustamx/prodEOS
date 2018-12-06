﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Заполнение списка валют из ОКВ.
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьТаблицуВалют();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВалют

&НаКлиенте
Процедура СписокВалютВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСпискеВалют(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	ОбработатьВыборВСпискеВалют();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуВалют()
	
	// Заполняет список валют из макета ОКВ.
	
	КлассификаторXML = Справочники.Валюты.ПолучитьМакет("ОбщероссийскийКлассификаторВалют").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого ЗаписьОКВ Из КлассификаторТаблица Цикл
		НоваяСтрока = Валюты.Добавить();
		НоваяСтрока.КодВалютыЦифровой         = ЗаписьОКВ.Code;
		НоваяСтрока.КодВалютыБуквенный        = ЗаписьОКВ.CodeSymbol;
		НоваяСтрока.Наименование              = ЗаписьОКВ.Name;
		НоваяСтрока.СтраныИТерритории         = ЗаписьОКВ.Description;
		НоваяСтрока.Загружается               = ЗаписьОКВ.RBCLoading;
		НоваяСтрока.ПараметрыПрописиНаРусском = ЗаписьОКВ.NumerationItemOptions;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки, ЕстьКурсы)
	
	ЕстьКурсы = Ложь;
	ТекущаяСсылка = Неопределено;
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = Валюты[НомерСтроки];
		
		СтрокаВБазе = Справочники.Валюты.НайтиПоКоду(ТекущиеДанные.КодВалютыЦифровой);
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Если НомерСтроки = Элементы.СписокВалют.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
				ТекущаяСсылка = СтрокаВБазе;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Справочники.Валюты.СоздатьЭлемент();
		НоваяСтрока.Код                       = ТекущиеДанные.КодВалютыЦифровой;
		НоваяСтрока.Наименование              = ТекущиеДанные.КодВалютыБуквенный;
		НоваяСтрока.НаименованиеПолное        = ТекущиеДанные.Наименование;
		Если ТекущиеДанные.Загружается Тогда
			НоваяСтрока.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета;
		Иначе
			НоваяСтрока.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
		КонецЕсли;
		НоваяСтрока.ПараметрыПрописиНаРусском = ТекущиеДанные.ПараметрыПрописиНаРусском;
		НоваяСтрока.Записать();
		
		Если НомерСтроки = Элементы.СписокВалют.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = НоваяСтрока.Ссылка;
		КонецЕсли;
		
		Если ТекущиеДанные.Загружается Тогда 
			ЕстьКурсы = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТекущаяСсылка;

КонецФункции

&НаКлиенте
Процедура ОбработатьВыборВСпискеВалют(СтандартнаяОбработка = Неопределено)
	Перем ЕстьКурсы;
	
	// Добавление элемента справочника и вывод результата пользователю.
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСсылка = СохранитьВыбранныеСтроки(Элементы.СписокВалют.ВыделенныеСтроки, ЕстьКурсы);
	
	ОповеститьОВыборе(ТекущаяСсылка);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Валюты добавлены.'; en = 'Currency added.'"), ,
		?(СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().РазделениеВключено И ЕстьКурсы, 
			НСтр("ru = 'Курсы будут загружены автоматически через непродолжительное время.'; en = 'Courses will be loaded automatically after a short time.'"), ""),
		БиблиотекаКартинок.Информация32);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
