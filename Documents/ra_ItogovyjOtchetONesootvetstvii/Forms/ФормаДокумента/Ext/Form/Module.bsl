﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаПечать);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТолькоЧтоСозданныйДокумент = Истина;
	Если ТолькоЧтоСозданныйДокумент И БылПоказанДиалогИнтерактивногоЗапускаПроцесса <> Истина Тогда
		ИнтерактивныйЗапускБизнесПроцессовКлиент.ВыполнитьИнтерактивныйЗапускБизнесПроцесса(
			ШаблоныДляАвтоЗапускаЗакрытиеКарточки,
			Объект.Ссылка,
			"ЗакрытиеКарточки",
			ЭтаФорма,
			Отказ,
			Истина);
	КонецЕсли;
	
	ОбщегоНазначенияДокументооборотКлиент.ВставитьВОписаниеОповещенияОЗакрытииСсылкуНаОбъект(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Шаблоны автозапуска
	ЗаполнитьШаблоныДляАвтоЗапуска();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура NesootvetstvieПриИзменении(Элемент)
	
	ЗаполнитьАктуальнымиДанными();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыПользователя(Знач Пользователь)
	
	РеквизитыПользователя = Новый Структура("Podrazdelenie, Dolzhnost"
		,РаботаСПользователями.ПолучитьПодразделение(Пользователь)
		,РаботаСПользователями.ПолучитьДолжность(Пользователь)
		);
	Возврат РеквизитыПользователя;
	
КонецФункции

&НаКлиенте
Процедура SoglasuyushchiePolzovatelПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Soglasuyushchie.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Polzovatel) Тогда
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПолучитьРеквизитыПользователя(ТекущиеДанные.Polzovatel));
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессСогласование(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Согласование", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 29.06.2018 {
&НаКлиенте
Процедура ПроцессИсполнение(Команда)
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Исполнение", Объект.Ссылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОзнакомление(Команда)
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Ознакомление", Объект.Ссылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПроцессУтверждение(Команда)
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Утверждение", Объект.Ссылка, ЭтаФорма);
КонецПроцедуры

// ТСК Корнюшенков А.Ю. Искать текст "МаршрутыСогласованияЕОСК" 29.06.2018 } 

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьАктуальнымиДанными()
	
	Документы.ra_ItogovyjOtchetONesootvetstvii.ЗаполнитьАктуальнымиДанными(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШаблоныДляАвтоЗапуска()
	
	ШаблоныДляАвтоЗапускаЗакрытиеКарточки = ИнтерактивныйЗапускБизнесПроцессов.ПолучитьШаблоныДляАвтоЗапуска(
		Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданногоВнутреннегоДокумента,
		Объект.ВидДокумента, Справочники.Организации.ПустаяСсылка(), Объект.Ссылка);
	ШаблоныДляАвтоЗапускаРегистрация = ИнтерактивныйЗапускБизнесПроцессов.ПолучитьШаблоныДляАвтоЗапуска(
		Перечисления.ВидыИнтерактивныхДействий.ИнтерактивнаяРегистрацияВнутреннегоДокумента,
		Объект.ВидДокумента, Справочники.Организации.ПустаяСсылка(), Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти
