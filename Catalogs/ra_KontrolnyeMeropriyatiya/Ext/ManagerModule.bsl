﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") И
			Параметры.Отбор.Свойство("EhtapVyyavleniya") И
			Параметры.Отбор.Свойство("ЭтоГруппа") Тогда
				
		СтандартнаяОбработка = Ложь;
	
		МассивПолей = ра_ОбщегоНазначения.ПолучитьПоляВводаПоСтроке(ПустаяСсылка().Метаданные());
		
		Запрос = ра_ОбщегоНазначения.ЗапросДанныхВыбораПоТексту(
			"ВЫБРАТЬ
			|	ra_KontrolnyeMeropriyatiya.Ссылка КАК Ссылка,
			|	ra_KontrolnyeMeropriyatiya.Код КАК Код,
			|	ra_KontrolnyeMeropriyatiya.Наименование КАК Наименование,
			|	ra_KontrolnyeMeropriyatiya.ПометкаУдаления КАК ПометкаУдаления
			|ИЗ
			|	Справочник.ra_KontrolnyeMeropriyatiya.Primenenie КАК ra_KontrolnyeMeropriyatiyaPrimenenie
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ra_KontrolnyeMeropriyatiya КАК ra_KontrolnyeMeropriyatiya
			|		ПО ra_KontrolnyeMeropriyatiyaPrimenenie.Ссылка = ra_KontrolnyeMeropriyatiya.Ссылка
			|			И ra_KontrolnyeMeropriyatiyaPrimenenie.EhtapVyyavleniya = &EhtapVyyavleniya
			|ГДЕ
			|	ra_KontrolnyeMeropriyatiyaPrimenenie.Ссылка.ЭтоГруппа",
			Параметры,
			МассивПолей);
												
		ра_ОбщегоНазначения.ЗаполнитьДанныеВыбораПоЗапросу(ДанныеВыбора, Параметры, Запрос, МассивПолей, СтрСоединить(МассивПолей, ","));
		
	ИначеЕсли Параметры.Свойство("Отбор") И
			Параметры.Отбор.Свойство("VidPredmetaNesootvetstviya") И
			Параметры.Отбор.Свойство("Родитель") Тогда
						
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Для каждого КлючИЗнач из Данные Цикл
		Представление = КлючИЗнач.Значение;	
	КонецЦикла;
	
	ра_ОбщегоНазначения.ОбработатьПустоеПредставление(Представление);
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТекущийЯзык() = Метаданные.Языки.Английский Тогда
		Поля.Добавить("NaimenovanieEn");	
	Иначе
		Поля.Добавить("Наименование");	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.Справочники.ra_VidyKontrolnyhOperacij;
	
	ТаблицаРеквизитов = ра_ОбменДанными.ПолучитьТаблицуРеквизитовОбъекта(ОбъектМетаданных);
	
	АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов);
	
	ТекстЗапросаВложенныеТаблицы = ПолучитьТекстЗапросаВложенныеТаблицы();
	ТекстЗапросаСоединений = ПолучитьТекстЗапросаСоединений();
	
	Запрос = ра_ОбменДанными.ПолучитьЗапрос(ТаблицаРеквизитов, ПараметрыЗапросаHTTP, ПолноеИмя, ТекстЗапросаВложенныеТаблицы, ТекстЗапросаСоединений);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
	Результат.Вставить("value", МассивДанных);
							
КонецПроцедуры

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
		
	
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
			
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "";
			
КонецФункции

#КонецОбласти