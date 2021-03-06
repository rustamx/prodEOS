﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Запускает обмен данными, используется в фоновом задании.
//
// Параметры:
//   ПараметрыЗадания - Структура - Параметры, необходимые для выполнения процедуры.
//   АдресХранилища   - Строка - Адрес временного хранилища.
//
Процедура ВыполнитьЗапускОбменаДанными(ПараметрыЗадания, АдресХранилища) Экспорт
	
	ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
	
	ЗаполнитьЗначенияСвойств(ПараметрыОбмена, ПараметрыЗадания,
		"ВидТранспортаСообщенийОбмена,ВыполнятьЗагрузку,ВыполнятьВыгрузку");
		
	Если ПараметрыЗадания.ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
		ПараметрыОбмена.ДлительнаяОперация          = ПараметрыЗадания.ДлительнаяОперация;
		ПараметрыОбмена.ДлительнаяОперацияРазрешена = Истина;
		ПараметрыОбмена.ИдентификаторОперации       = ПараметрыЗадания.ИдентификаторДлительнойОперации;
		ПараметрыОбмена.ИдентификаторФайла          = ПараметрыЗадания.ИдентификаторФайлаСообщенияВСервисе;
		ПараметрыОбмена.ПараметрыАутентификации     = ПараметрыЗадания.ПараметрыАутентификации;
	КонецЕсли;
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(
		ПараметрыЗадания.УзелИнформационнойБазы,
		ПараметрыОбмена,
		ПараметрыЗадания.Отказ);
		
	Если ПараметрыЗадания.ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
		
		ПараметрыЗадания.ДлительнаяОперация                  = ПараметрыОбмена.ДлительнаяОперация;
		ПараметрыЗадания.ИдентификаторДлительнойОперации     = ПараметрыОбмена.ИдентификаторОперации;
		ПараметрыЗадания.ПараметрыАутентификации             = ПараметрыОбмена.ПараметрыАутентификации;
		
		Если ЗначениеЗаполнено(ПараметрыЗадания.ИдентификаторДлительнойОперации) Тогда
			// Если задание выполняется на корреспонденте, то необходимо будет загрузить полученный файл в базу позднее.
			ПараметрыЗадания.ИдентификаторФайлаСообщенияВСервисе = ПараметрыОбмена.ИдентификаторФайла;
		Иначе
			// Файл с данными уже получен и загружен в базу, загружать его дополнительно нет необходимости.
			ПараметрыЗадания.ИдентификаторФайлаСообщенияВСервисе = "";
		КонецЕсли;
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ПараметрыЗадания, АдресХранилища);
	
КонецПроцедуры

// Запускает загрузку полученного из интернета файла, используется в фоновом задании.
//
// Параметры:
//   ПараметрыЗадания - Структура - Параметры, необходимые для выполнения процедуры.
//   АдресХранилища   - Строка - Адрес временного хранилища.
//
Процедура ВыполнитьЗагрузкуПолученногоИзИнтернетаФайла(ПараметрыЗадания, АдресХранилища) Экспорт
	
	ОбменДаннымиВызовСервера.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
		ПараметрыЗадания.Отказ,
		ПараметрыЗадания.УзелИнформационнойБазы,
		ПараметрыЗадания.ИдентификаторФайлаСообщенияВСервисе,
		ПараметрыЗадания.ДатаНачалаОперации,
		ПараметрыЗадания.ПараметрыАутентификации);
		
	ПараметрыЗадания.ИдентификаторФайлаСообщенияВСервисе = "";
	ПоместитьВоВременноеХранилище(ПараметрыЗадания, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
