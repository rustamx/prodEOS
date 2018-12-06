﻿#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	ТипОбъекта = ТипЗнч(Объект);
	
	Если Предопределенный И Ссылка <> Справочники.АдреснаяКнига.ВсеПользователи Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.Раздел;
	ИначеЕсли Ссылка = Справочники.АдреснаяКнига.ВсеПользователи Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.РабочаяГруппа;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ГруппыКонтактовПользователей") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.ГруппаКонтактовПользователей;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.СтруктураПредприятия;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.РабочиеГруппы") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.РабочаяГруппа;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ПапкиМероприятий") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.ПапкаМероприятий;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Мероприятия") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.Мероприятие;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ПапкиПроектов") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.ПапкаПроектов;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Проекты") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.Проект;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Пользователи") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.Пользователь;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.РольИсполнителей;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Организации") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.Организация;	
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Контрагенты") Тогда
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "ЭтоГруппа") Тогда
			ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.ГруппаКонтрагентов;
		Иначе
			ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.Контрагент;
		КонецЕсли;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.КонтактноеЛицо;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ГруппыЛичныхАдресатов") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.ГруппаЛичныхАдресатов;
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ЛичныеАдресаты") Тогда
		ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.ЛичныйАдресат;
	ИначеЕсли ТипОбъекта = Тип("Строка") Тогда
		
		ЭтоАвтогруппа = Ложь;
		ФункцииАвтоГрупп = РаботаСАдреснойКнигой.ПолучитьСписокДоступныхФункций();
		Для Каждого ФункцияАвтогруппа Из ФункцииАвтоГрупп Цикл
			Если ФункцияАвтогруппа.Представление = Объект Тогда
				ЭтоАвтогруппа = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Родитель = Справочники.АдреснаяКнига.АвтоподстановкиДляДокументов Тогда
			ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.АвтоподстановкаДокументов;
		ИначеЕсли Родитель = Справочники.АдреснаяКнига.АвтоподстановкиДляПроцессов Тогда
			ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.АвтоподстановкаПроцессов;
		ИначеЕсли ЭтоАвтогруппа Тогда
			ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.Автогруппа;
		Иначе
			ТипДанныхОбъекта = Перечисления.ТипыДанныхАдреснойКниги.АдресСпискаРассылки;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
