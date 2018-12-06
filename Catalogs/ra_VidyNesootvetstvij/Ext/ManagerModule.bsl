﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивПолей = ра_ОбщегоНазначения.ПолучитьПоляВводаПоСтроке(ПустаяСсылка().Метаданные());
	
	Если Параметры.Свойство("Отбор") и (Параметры.Отбор.Свойство("VidPredmetaNesootvetstviya") или Параметры.Отбор.Свойство("EhtapVyyavleniyaNesootvetstvija")) Тогда
		
		Запрос = ра_ОбщегоНазначения.ЗапросДанныхВыбораПоТексту(
			"ВЫБРАТЬ
			|	ra_VidyNesootvetstvij.Ссылка КАК Ссылка,
			|	ra_VidyNesootvetstvij.Код КАК Код,
			|	ra_VidyNesootvetstvij.Наименование КАК Наименование,
			|	ra_VidyNesootvetstvij.ПометкаУдаления КАК ПометкаУдаления
			|ИЗ
			|	Справочник.ra_VidyNesootvetstvij.Primenenie КАК ra_VidyNesootvetstvijPrimenenie
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ra_VidyNesootvetstvij КАК ra_VidyNesootvetstvij
			|		ПО ra_VidyNesootvetstvijPrimenenie.Ссылка = ra_VidyNesootvetstvij.Ссылка
			|			И ra_VidyNesootvetstvijPrimenenie.VidPredmetaNesootvetstviya = &VidPredmetaNesootvetstviya
			|			И ra_VidyNesootvetstvijPrimenenie.EhtapVyyavleniyaNesootvetstvija = &EhtapVyyavleniyaNesootvetstvija",
			Параметры,
			МассивПолей);
			
		Если Не Запрос.Параметры.Свойство("VidPredmetaNesootvetstviya") Тогда
			Запрос.УстановитьПараметр("VidPredmetaNesootvetstviya", Перечисления.ra_VidyPredmetovNesootvetstviya.ПустаяСсылка());	
		КонецЕсли;
		
		Если Не Запрос.Параметры.Свойство("EhtapVyyavleniyaNesootvetstvija") Тогда
			Запрос.УстановитьПараметр("EhtapVyyavleniyaNesootvetstvija", Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.ПустаяСсылка());	
		КонецЕсли;
					
		ра_ОбщегоНазначения.ЗаполнитьДанныеВыбораПоЗапросу(ДанныеВыбора, Параметры, Запрос, МассивПолей, СтрСоединить(МассивПолей, ","));
				
	Иначе
		
		ра_ОбщегоНазначения.ПолучитьСтандартныеДанныеВыбора(Справочники.ra_VidyNesootvetstvij, ДанныеВыбора, Параметры, СтандартнаяОбработка, МассивПолей, СтрСоединить(МассивПолей, ","));
		
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
	
	ОбъектМетаданных = Метаданные.Справочники.ra_VidyNesootvetstvij;
	
	ТаблицаРеквизитов = ра_ОбменДанными.ПолучитьТаблицуРеквизитовОбъекта(ОбъектМетаданных);
	
	АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов);
	
	ТекстЗапросаВложенныеТаблицы = ПолучитьТекстЗапросаВложенныеТаблицы();
	ТекстЗапросаСоединений = ПолучитьТекстЗапросаСоединений();
	
	Запрос = ра_ОбменДанными.ПолучитьЗапрос(ТаблицаРеквизитов, ПараметрыЗапросаHTTP, ПолноеИмя, ТекстЗапросаВложенныеТаблицы, ТекстЗапросаСоединений);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
	Результат.Вставить("value", МассивДанных);
	
	НастройкаФормы = ПараметрыЗапросаHTTP.Получить("$form_settings");
	Если ЗначениеЗаполнено(НастройкаФормы) И НастройкаФормы Тогда
		МассивКолонок = ПолучитьПолучитьМассивКолонокСписка();
		МассивКнопок = ПолучитьМассивКнопок(Запрос.Параметры);
		МассивФильтров = ПолучитьМассивФильтровСписка();
		Результат.Вставить("form_settings", МассивКолонок);
		Результат.Вставить("button_settings", МассивКнопок);
		Результат.Вставить("filter_settings", МассивФильтров);
	КонецЕсли;
							
КонецПроцедуры

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
		
	
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
			
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "";
			
КонецФункции

Функция ПолучитьМассивКнопок(ДокументОбъект) Экспорт
	
	МассивКнопок = Новый Массив;
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт
	
	МетаданныеСправочника = Метаданные.Справочники.ra_VidyNesootvetstvij;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	РеквизитыОбъекта = МетаданныеСправочника.Реквизиты;
	СтандартныеРеквизитыОбъекта = МетаданныеСправочника.СтандартныеРеквизиты;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Код);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, СтандартныеРеквизитыОбъекта.Наименование);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МассивДанных = Новый Массив;
	
	Возврат МассивДанных;
	
КонецФункции

#КонецОбласти

