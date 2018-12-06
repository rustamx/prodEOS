﻿
////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Отказ от инициализации, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьРазрешениеНаУправлениеПравами();
	// Проверка разрешения на открытие формы.
	
	ИспользоватьВнешнихПользователей = ВнешниеПользователи.ИспользоватьВнешнихПользователей() И ПравоДоступа("Просмотр", Метаданные.Справочники.ВнешниеПользователи);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокТиповПользователей.Добавить(Тип("СправочникСсылка.Пользователи"),        Метаданные.Справочники.Пользователи.Синоним);
	СписокТиповПользователей.Добавить(Тип("СправочникСсылка.ВнешниеПользователи"), Метаданные.Справочники.ВнешниеПользователи.Синоним);
	
	// Установка заголовка формы.
	Заголовок = УправлениеДоступомДокументооборот.ЗаголовокПодчиненнойФормы(НСтр("ru = 'Права доступа: %1 (%2)'"), Параметры.СсылкаНаОбъект);
	
	Элементы.НаследоватьПраваРодителей.Видимость =
		Параметры.СсылкаНаОбъект.Метаданные().Иерархический
		И ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.СсылкаНаОбъект, "Родитель"));
	
	НастройкиПрав = РегистрыСведений.НастройкиПравОбъектов.Прочитать(Параметры.СсылкаНаОбъект);
	
	ЗаполнитьПрава();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПередЗакрытиемПродолжение",
			ЭтотОбъект);
		ПоказатьВопрос(
			ОписаниеОповещения,
			НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), 
			РежимДиалогаВопрос.ДаНетОтмена,, 
			КодВозвратаДиалога.Отмена);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПродолжение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьПрава();
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий команд и элементов формы
//

// Обработчики команд

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Отказ = Ложь;
	ОбработкаПроверкиЗаполнения(Отказ);
	
	Если НЕ Отказ Тогда
		
		ЗаписатьПрава(Отказ);
		Если НЕ Отказ Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Отказ = Ложь;
	ОбработкаПроверкиЗаполнения(Отказ);
	
	Если НЕ Отказ Тогда
	
		РазрешеноУправлениеПравамиПослеЗаписи = Ложь;
		ОписаниеПредупреждения = "";
		ЗаписатьПрава(Отказ, РазрешеноУправлениеПравамиПослеЗаписи, ОписаниеПредупреждения);
		Если НЕ Отказ И НЕ РазрешеноУправлениеПравамиПослеЗаписи Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ЗаписатьПродолжение",
				ЭтотОбъект);
			ПоказатьПредупреждение(
				ОписаниеОповещения, 
				ОписаниеПредупреждения, 
				7, 
				НСтр("ru = 'После успешной записи'"));
		КонецЕсли;
		ОчиститьСообщения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьПродолжение(Параметры) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Перечитать(Команда)
	
	Если НЕ Модифицированность Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПеречитатьПродолжение",
			ЭтотОбъект);
		ПоказатьВопрос(
			ОписаниеОповещения, 
			НСтр("ru = 'Данные изменены. Прочитать без сохранения?'"), 
			РежимДиалогаВопрос.ОКОтмена, 
			5, 
			КодВозвратаДиалога.Отмена);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ПрочитатьПрава();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаследоватьПраваРодителейПриИзменении(Элемент)
	
	НаследоватьПраваРодителейПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НаследоватьПраваРодителейПриИзмененииНаСервере()
	
	Если НаследоватьПраваРодителей Тогда
		ДобавитьНаследуемыеПрава();
		ЗаполнитьНомераКартинокПользователей();
	Иначе
		// Очистка настроек, наследуемых от родителей по иерархии.
		Индекс = ГруппыПрав.Количество()-1;
		Пока Индекс >= 0 Цикл
			Если ГруппыПрав.Получить(Индекс).НастройкаРодителя Тогда
				ГруппыПрав.Удалить(Индекс);
			КонецЕсли;
			Индекс = Индекс - 1;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СнятьУстановкуПрава(Команда)
	
	УстановитьЗначениеТекущегоПрава(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗапретПрава(Команда)
	
	УстановитьЗначениеТекущегоПрава(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазрешениеПрава(Команда)
	
	УстановитьЗначениеТекущегоПрава(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеТекущегоПрава(НовоеЗначение)
	
	Отказ = Ложь;
	ПроверкаВозможностиИзмененияПрав(Отказ);
	
	Если Не Отказ Тогда
		ТекущееПраво  = Сред(Элементы.ГруппыПрав.ТекущийЭлемент.Имя, СтрДлина("ГруппыПрав") + 1);
		ТекущиеДанные = Элементы.ГруппыПрав.ТекущиеДанные;
		
		Если ВозможныеПрава.Свойство(ТекущееПраво)
		   И ТекущиеДанные <> Неопределено Тогда
			
			СтароеЗначение = ТекущиеДанные[ТекущееПраво];
			ТекущиеДанные[ТекущееПраво] = НовоеЗначение;
			
			Модифицированность = Истина;
			
			ОбновитьЗависимыеПрава(ТекущиеДанные, ТекущееПраво, СтароеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчики таблицы ГруппыПрав

&НаКлиенте
Процедура ГруппыПравВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ГруппыПравПользователь" Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ПроверкаВозможностиИзмененияПрав(Отказ);
	
	Если НЕ Отказ Тогда
		ТекущееПраво  = Сред(Поле.Имя, СтрДлина("ГруппыПрав") + 1);
		ТекущиеДанные = Элементы.ГруппыПрав.ТекущиеДанные;
		
		Если ТекущееПраво = "НаследованиеРазрешено" Тогда
			ТекущиеДанные[ТекущееПраво] = НЕ ТекущиеДанные[ТекущееПраво];
			Модифицированность = Истина;
			
		ИначеЕсли ВозможныеПрава.Свойство(ТекущееПраво) Тогда
			СтароеЗначение = ТекущиеДанные[ТекущееПраво];
			
			Если ТекущиеДанные[ТекущееПраво] = Истина Тогда
				ТекущиеДанные[ТекущееПраво] = Ложь;
				
			ИначеЕсли ТекущиеДанные[ТекущееПраво] = Ложь Тогда
				ТекущиеДанные[ТекущееПраво] = Неопределено;
			Иначе
				ТекущиеДанные[ТекущееПраво] = Истина;
			КонецЕсли;
			Модифицированность = Истина;
			
			ОбновитьЗависимыеПрава(ТекущиеДанные, ТекущееПраво, СтароеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимыеПрава(Знач Данные, Знач Право, Знач СтароеЗначение, Знач ГлубинаРекурсии = 0)
	
	Если Данные[Право] = СтароеЗначение Тогда
		Возврат;
	КонецЕсли;
	
	Если ГлубинаРекурсии > 100 Тогда
		Возврат;
	Иначе
		ГлубинаРекурсии = ГлубинаРекурсии + 1;
	КонецЕсли;
	
	ЗависимыеПрава = Неопределено;
	
	Если Данные[Право] = Истина Тогда
		
		// Увеличены разрешения (с Неопределено или Ложь на Истина)
		// Требуется повысить разрешения на ведущие права
		ПрямыеЗависимостиПрав.Свойство(Право, ЗависимыеПрава);
		ЗначениеЗависимогоПрава = Истина;
		
	ИначеЕсли Данные[Право] = Ложь Тогда
		
		// Увеличены запрещения (с Истина или Неопределено на Ложь)
		// Требуется повысить запрещения на зависимые права
		ОбратныеЗависимостиПрав.Свойство(Право, ЗависимыеПрава);
		ЗначениеЗависимогоПрава = Ложь;
	Иначе
		Если СтароеЗначение = Ложь Тогда
			// Уменьшены запрещения (с Ложь на Неопределено)
			// Требуется уменьшить запрещения на ведущие права
			ПрямыеЗависимостиПрав.Свойство(Право, ЗависимыеПрава);
			ЗначениеЗависимогоПрава = Неопределено;
		Иначе
			// Уменьшены разрешения (с Истина на Неопределено)
			// Требуется уменьшить разрешения на зависимые права
			ОбратныеЗависимостиПрав.Свойство(Право, ЗависимыеПрава);
			ЗначениеЗависимогоПрава = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗависимыеПрава <> Неопределено Тогда
		Для каждого ЗависимоеПраво Из ЗависимыеПрава Цикл
			Если ТипЗнч(ЗависимоеПраво) = Тип("Массив") Тогда
				УстановитьЗависимоеПраво = Истина;
				Для каждого ОдноИзЗависимыхПрав Из ЗависимоеПраво Цикл
					Если Данные[ОдноИзЗависимыхПрав] = ЗначениеЗависимогоПрава Тогда
						УстановитьЗависимоеПраво = Ложь;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если УстановитьЗависимоеПраво Тогда
					Если НЕ (ЗначениеЗависимогоПрава = Неопределено И Данные[ЗависимоеПраво[0]] <> СтароеЗначение) Тогда
						ТекущееСтароеЗначение = Данные[ЗависимоеПраво[0]];
						Данные[ЗависимоеПраво[0]] = ЗначениеЗависимогоПрава;
						ОбновитьЗависимыеПрава(Данные, ЗависимоеПраво[0], ТекущееСтароеЗначение);
					КонецЕсли;
				КонецЕсли;
			Иначе
				Если НЕ (ЗначениеЗависимогоПрава = Неопределено И Данные[ЗависимоеПраво] <> СтароеЗначение) Тогда
					ТекущееСтароеЗначение = Данные[ЗависимоеПраво];
					Данные[ЗависимоеПраво] = ЗначениеЗависимогоПрава;
					ОбновитьЗависимыеПрава(Данные, ЗависимоеПраво, ТекущееСтароеЗначение);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ГруппыПрав.ТекущиеДанные;
	
	ДоступностьКоманд = ?(ТекущиеДанные = Неопределено, Ложь, НЕ ТекущиеДанные.НастройкаРодителя);
	Элементы.ГруппыПравКонтекстноеМенюУдалить.Доступность = ДоступностьКоманд;
	Элементы.ФормаУдалить.Доступность                     = ДоступностьКоманд;
	Элементы.ФормаПереместитьВверх.Доступность            = ДоступностьКоманд;
	Элементы.ФормаПереместитьВниз.Доступность             = ДоступностьКоманд;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПриАктивизацииПоля(Элемент)
	
	ДоступностьКоманд = ВозможныеПрава.Свойство(Сред(Элемент.ТекущийЭлемент.Имя, СтрДлина("ГруппыПрав") + 1));
	Элементы.ГруппыПравКонтекстноеМенюСнятьУстановкуПрава.Доступность       = ДоступностьКоманд;
	Элементы.ГруппыПравКонтекстноеМенюУстановитьРазрешениеПрава.Доступность = ДоступностьКоманд;
	Элементы.ГруппыПравКонтекстноеМенюУстановитьЗапретПрава.Доступность     = ДоступностьКоманд;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПередНачаломИзменения(Элемент, Отказ)
	
	ПроверкаВозможностиИзмененияПрав(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПередУдалением(Элемент, Отказ)
	
	ПроверкаВозможностиИзмененияПрав(Отказ, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		// Установка начальных значений.
		Элементы.ГруппыПрав.ТекущиеДанные.ВладелецНастройки     = Параметры.СсылкаНаОбъект;
		Элементы.ГруппыПрав.ТекущиеДанные.НаследованиеРазрешено = Истина;
		Элементы.ГруппыПрав.ТекущиеДанные.НастройкаРодителя     = Ложь;
		
		Для каждого ДобавленныйРеквизит Из ДобавленныеРеквизиты Цикл
			Элементы.ГруппыПрав.ТекущиеДанные[ДобавленныйРеквизит.Ключ] = ДобавленныйРеквизит.Значение;
		КонецЦикла;
	КонецЕсли;
	
	Если Элементы.ГруппыПрав.ТекущиеДанные.Пользователь = Неопределено Тогда
		Элементы.ГруппыПрав.ТекущиеДанные.Пользователь  = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		Элементы.ГруппыПрав.ТекущиеДанные.НомерКартинки = -1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Элементы.ГруппыПрав.ТекущиеДанные.Пользователь) Тогда
		ЗаполнитьНомераКартинокПользователей(Элементы.ГруппыПрав.ТекущаяСтрока);
	Иначе
		Элементы.ГруппыПрав.ТекущиеДанные.НомерКартинки = ДобавленныеРеквизиты.НомерКартинки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Элементы.ГруппыПрав.ТекущиеДанные.Пользователь  = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	Элементы.ГруппыПрав.ТекущиеДанные.НомерКартинки = -1;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПользователя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПравПользовательАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПользователя(Текст);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции
//

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбораПользователя(Знач Текст, Знач ВключаяГруппы = Истина, Знач ВключаяВнешнихПользователей = Неопределено, БезПользователей = Ложь)
	
	Возврат Пользователи.СформироватьДанныеВыбораПользователя(Текст, ВключаяГруппы, ВключаяВнешнихПользователей, БезПользователей);
	
КонецФункции

&НаСервере
Процедура ДобавитьРеквизит(НовыеРеквизиты, Реквизит, НачальноеЗначение)
	
	НовыеРеквизиты.Добавить(Реквизит);
	ДобавленныеРеквизиты.Вставить(Реквизит.Имя, НачальноеЗначение);
	
КонецПроцедуры

&НаСервере
Функция ДобавитьЭлемент(Имя, Тип, Родитель)
	
	Элемент = Элементы.Добавить(Имя, Тип, Родитель);
	Элемент.ФиксацияВТаблице = ФиксацияВТаблице.Нет;
	
	Возврат Элемент;
	
КонецФункции

&НаСервере
Процедура ДобавитьРеквизитыИлиЭлементыФормы(НовыеРеквизиты = Неопределено)
	
	ОписанияВозможныхПрав = УправлениеДоступомДокументооборот.ВозможныеПраваДляНастройкиПравОбъектов(Параметры.СсылкаНаОбъект);
	
	ОписаниеТиповПсевдоФлажка = Новый ОписаниеТипов("Булево, Число",
		Новый КвалификаторыЧисла(1, 0, ДопустимыйЗнак.Неотрицательный));
	
	// Добавление возможных прав, настраиваемых по владельцу (таблице значений доступа).
	Для каждого ОписаниеПрава Из ОписанияВозможныхПрав Цикл
		
		Если НовыеРеквизиты <> Неопределено Тогда
			
			ДобавитьРеквизит(НовыеРеквизиты, Новый РеквизитФормы(ОписаниеПрава.Имя, ОписаниеТиповПсевдоФлажка,
				"ГруппыПрав", ОписаниеПрава.Синоним), ОписаниеПрава.НачальноеЗначение);
			
			ВозможныеПрава.Вставить(ОписаниеПрава.Имя);
			
			// Добавление прямых и обратных зависимостей прав.
			ПрямыеЗависимостиПрав.Вставить(ОписаниеПрава.Имя, ОписаниеПрава.ТребуемыеПрава);
			Для каждого ЗависимоеПраво Из ОписаниеПрава.ТребуемыеПрава Цикл
				Если ТипЗнч(ЗависимоеПраво) = Тип("Массив") Тогда
					ЗависимыеПрава = ЗависимоеПраво;
				Иначе
					ЗависимыеПрава = Новый Массив;
					ЗависимыеПрава.Добавить(ЗависимоеПраво);
				КонецЕсли;
				Для каждого ЗависимоеПраво Из ЗависимыеПрава Цикл
					Если ОбратныеЗависимостиПрав.Свойство(ЗависимоеПраво) Тогда
						ЗависимыеПрава = ОбратныеЗависимостиПрав[ЗависимоеПраво];
					Иначе
						ЗависимыеПрава = Новый Массив;
						ОбратныеЗависимостиПрав.Вставить(ЗависимоеПраво, ЗависимыеПрава);
					КонецЕсли;
					Если ЗависимыеПрава.Найти(ОписаниеПрава.Имя) = Неопределено Тогда
						ЗависимыеПрава.Добавить(ОписаниеПрава.Имя);
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		Иначе
			Элемент = ДобавитьЭлемент("ГруппыПрав" + ОписаниеПрава.Имя, Тип("ПолеФормы"), Элементы.ГруппыПрав);
			Элемент.ТолькоПросмотр                = Истина;
			Элемент.Формат                        = "ЧЦ=1; ЧН=; БЛ=Нет; БИ=Да";
			Элемент.ГоризонтальноеПоложениеВШапке = ГоризонтальноеПоложениеЭлемента.Центр;
			Элемент.ГоризонтальноеПоложение       = ГоризонтальноеПоложениеЭлемента.Центр;
			Элемент.ПутьКДанным                   = "ГруппыПрав." + ОписаниеПрава.Имя;
			
			Если ЗначениеЗаполнено(ОписаниеПрава.Сокращение) Тогда
				Элемент.Заголовок = ОписаниеПрава.Сокращение;
			Иначе
				Элемент.Заголовок = ОписаниеПрава.Имя;
			КонецЕсли;
			Элемент.Подсказка = ОписаниеПрава.Синоним;
			// Расчет оптимальной ширины элемента
			ШиринаЭлемента = 0;
			Для НомерСтроки = 1 По СтрЧислоСтрок(Элемент.Заголовок) Цикл
				ШиринаЭлемента = Макс(ШиринаЭлемента, СтрДлина(СтрПолучитьСтроку(Элемент.Заголовок, НомерСтроки)));
			КонецЦикла;
			Элемент.Ширина = ШиринаЭлемента;
		КонецЕсли;
	КонецЦикла;
	
	Если НовыеРеквизиты = Неопределено И Параметры.СсылкаНаОбъект.Метаданные().Иерархический Тогда
		Элемент = ДобавитьЭлемент("ГруппыПравНаследованиеРазрешено", Тип("ПолеФормы"), Элементы.ГруппыПрав);
		Элемент.ТолькоПросмотр                = Истина;
		Элемент.Формат                        = "ЧЦ=1; ЧН=; БЛ=Нет; БИ=Да";
		Элемент.ГоризонтальноеПоложениеВШапке = ГоризонтальноеПоложениеЭлемента.Центр;
		Элемент.ГоризонтальноеПоложение       = ГоризонтальноеПоложениеЭлемента.Центр;
		Элемент.ПутьКДанным                   = "ГруппыПрав.НаследованиеРазрешено";
		
		Элемент.Заголовок = НСтр("ru = 'Для
		                               |подпапок'");
		Элемент.Подсказка = НСтр("ru = 'Права не только для текущей папки,
		                               |но и для её нижестоящих папок'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрава()
	
	ПрямыеЗависимостиПрав   = Новый Структура;
	ОбратныеЗависимостиПрав = Новый Структура;
	ВозможныеПрава          = Новый Структура;
	
	ДобавленныеРеквизиты = Новый Структура;
	НовыеРеквизиты = Новый Массив;
	ДобавитьРеквизитыИлиЭлементыФормы(НовыеРеквизиты);
	
	// Добавление реквизитов формы
	ИзменитьРеквизиты(НовыеРеквизиты);
	
	// Добавление элементов формы
	ДобавитьРеквизитыИлиЭлементыФормы();
	
	ПрочитатьПрава();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПрава()
	
	ГруппыПрав.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиПрав = РегистрыСведений.НастройкиПравОбъектов.Прочитать(Параметры.СсылкаНаОбъект);
	
	НаследоватьПраваРодителей = НастройкиПрав.Наследовать;
	
	Для каждого Настройка Из НастройкиПрав.Настройки Цикл
		Если НаследоватьПраваРодителей ИЛИ НЕ Настройка.НастройкаРодителя Тогда
			ЗаполнитьЗначенияСвойств(ГруппыПрав.Добавить(), Настройка);
		КонецЕсли;
	КонецЦикла;
	ЗаполнитьНомераКартинокПользователей();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНаследуемыеПрава()
	
	УстановитьПривилегированныйРежим(Истина);
	НастройкиПрав = РегистрыСведений.НастройкиПравОбъектов.Прочитать(Параметры.СсылкаНаОбъект);
	
	Индекс = 0;
	Для каждого Настройка Из НастройкиПрав.Настройки Цикл
		Если Настройка.НастройкаРодителя Тогда
			ЗаполнитьЗначенияСвойств(ГруппыПрав.Вставить(Индекс), Настройка);
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьНомераКартинокПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПроверкиЗаполнения(Отказ)
	
	ОчиститьСообщения();
	
	НомерСтроки = ГруппыПрав.Количество()-1;
	
	Пока НЕ Отказ И НомерСтроки >= 0 Цикл
		ТекущаяСтрока = ГруппыПрав.Получить(НомерСтроки);
		
		// Проверка заполнения флажков прав.
		НетЗаполненногоПрава = Истина;
		ИмяПервогоПрава = "";
		Для каждого ВозможноеПраво Из ВозможныеПрава Цикл
			Если НЕ ЗначениеЗаполнено(ИмяПервогоПрава) Тогда
				ИмяПервогоПрава = ВозможноеПраво.Ключ;
			КонецЕсли;
			Если ТипЗнч(ТекущаяСтрока[ВозможноеПраво.Ключ]) = Тип("Булево") Тогда
				НетЗаполненногоПрава = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НетЗаполненногоПрава Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Заполните хотя бы одно право доступа.'"),
				,
				"ГруппыПрав[" + Формат(НомерСтроки, "ЧГ=0") + "]." + ИмяПервогоПрава,
				,
				Отказ);
			Возврат;
		КонецЕсли;
		
		// Проверка заполенения пользователей/групп пользователей,
		// значений доступа и их дублей
		
		// Проверка заполнения
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока["Пользователь"]) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Выберите пользователя или группу пользователей.'"),
				,
				"ГруппыПрав[" + Формат(НомерСтроки, "ЧГ=0") + "].Пользователь",
				,
				Отказ);
			Возврат;
		КонецЕсли;
		
		// Проверка дублей
		Отбор = Новый Структура("ВладелецНастройки, Пользователь",
		                        ТекущаяСтрока["ВладелецНастройки"],
		                        ТекущаяСтрока["Пользователь"]);
		Если ГруппыПрав.НайтиСтроки(Отбор).Количество() > 1 Тогда
			Если ТипЗнч(Отбор.Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
				ТекстСообщения = НСтр("ru = 'Настройка для пользователя ""%1"" уже есть.
				                            |Выберите другого пользователя или группу пользователей.';
				                            |en = 'To configure for the user ""%1"" already exists.
				                            |Select a different user or group of users.'");
			Иначе
				ТекстСообщения = НСтр("ru = 'Настройка для группы пользователей ""%1"" уже есть.
				                            |Выберите другую группу пользователей или пользователя.'");
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Отбор.Пользователь),
				,
				"ГруппыПрав[" + Формат(НомерСтроки, "ЧГ=0") + "].Пользователь",
				,
				Отказ);
			Возврат;
		КонецЕсли;
			
		НомерСтроки = НомерСтроки - 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПрава(Отказ = Ложь, РазрешеноУправлениеПравамиПослеЗаписи = Ложь, ОписаниеПредупреждения = "")
	
	ПроверитьРазрешениеНаУправлениеПравами();
	
	УстановитьПривилегированныйРежим(Истина);
	РегистрыСведений.НастройкиПравОбъектов.Записать(Параметры.СсылкаНаОбъект, ГруппыПрав, НаследоватьПраваРодителей);
	УстановитьПривилегированныйРежим(Ложь);
	
	РазрешеноУправлениеПравамиПослеЗаписи = ПроверитьРазрешениеНаУправлениеПравами(Истина, ОписаниеПредупреждения);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаВозможностиИзмененияПрав(Отказ, ПроверкаУдаления = Ложь)
	
	ТекущийВладелецНастройки = Элементы.ГруппыПрав.ТекущиеДанные["ВладелецНастройки"];
	
	Если ЗначениеЗаполнено(ТекущийВладелецНастройки)
	   И ТекущийВладелецНастройки <> Параметры.СсылкаНаОбъект Тогда
		
		Отказ = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Эти права унаследованы, их можно изменить форме прав
			           |вышестоящей папки ""%1"".'"),
			ТекущийВладелецНастройки);
		ТекстСообщения =
			ТекстСообщения +
			?(ПроверкаУдаления,
			  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '
				           |
				           |Для удаления всех унаследованных прав следует
				           |снять флажок ""%1"".'; en = 'To remove all inherited rights you should clear the flag ""%1"".'"),
				Элементы.НаследоватьПраваРодителей.Заголовок),
			  "");
	КонецЕсли;
	
	Если Отказ Тогда
		ПоказатьПредупреждение(,ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователей()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", ?(Элементы.ГруппыПрав.ТекущиеДанные = Неопределено, Неопределено, Элементы.ГруппыПрав.ТекущиеДанные.Пользователь));
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ПараметрыФормы", ПараметрыФормы);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыбратьПользователейПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчика);
			
	Если ЗначениеЗаполнено(ПараметрыФормы.ТекущаяСтрока) И
	     ( ТипЗнч(ПараметрыФормы.ТекущаяСтрока) = Тип("СправочникСсылка.Пользователи") ИЛИ
	       ТипЗнч(ПараметрыФормы.ТекущаяСтрока) = Тип("СправочникСсылка.РабочиеГруппы") ) Тогда
	
		ВыборИПодборВнешнихПользователей = Ложь;
	ИначеЕсли ИспользоватьВнешнихПользователей И
	          ЗначениеЗаполнено(ПараметрыФормы.ТекущаяСтрока) И
	          ( ТипЗнч(ПараметрыФормы.ТекущаяСтрока) = Тип("СправочникСсылка.ВнешниеПользователи") ИЛИ
	            ТипЗнч(ПараметрыФормы.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") ) Тогда
	
		ВыборИПодборВнешнихПользователей = Истина;
	Иначе
		Если ИспользоватьВнешнихПользователей Тогда
			СписокТиповПользователей.ПоказатьВыборЭлемента(ОписаниеОповещения, "Выбор типа данных", СписокТиповПользователей[0]);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, ВыборИПодборВнешнихПользователей);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователейПродолжение(ВыборИПодборВнешнихПользователей, Параметры) Экспорт
	
	Если ВыборИПодборВнешнихПользователей = Неопределено Тогда 
		Возврат;
	ИначеЕсли ТипЗнч(ВыборИПодборВнешнихПользователей) = Тип("ЭлементСпискаЗначений") Тогда
		ВыборИПодборВнешнихПользователей = ВыборИПодборВнешнихПользователей.Значение = Тип("СправочникСсылка.ВнешниеПользователи");
	КонецЕсли;
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	
	Если ВыборИПодборВнешнихПользователей Тогда
		ПараметрыФормы.Вставить("ВыборГруппВнешнихПользователей", Истина);
	Иначе
		ПараметрыФормы.Вставить("ВыборГруппПользователей", Истина);
	КонецЕсли;
	
	Если ВыборИПодборВнешнихПользователей Тогда
		ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаВыбора", ПараметрыФормы, Элементы.ГруппыПравПользователь);
	Иначе
		ОткрытьФорму("Справочник.Пользователи.ФормаВыбора",        ПараметрыФормы, Элементы.ГруппыПравПользователь);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНомераКартинокПользователей(ИдентификаторСтроки = Неопределено)
	
	Пользователи.ЗаполнитьНомераКартинокПользователей(ГруппыПрав, "Пользователь", "НомерКартинки", ИдентификаторСтроки);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьРазрешениеНаУправлениеПравами(ПропуститьВызовИсключения = Ложь, ОписаниеПредупреждения = "")
	
	РазрешеноУправлениеПравами = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Параметры.СсылкаНаОбъект).УправлениеПравами;
	
	Если НЕ РазрешеноУправлениеПравами Тогда
		ОписаниеПредупреждения = НСтр("ru = 'Вам более недоступно управление правами.'");
		
		Если НЕ ПропуститьВызовИсключения Тогда
			ВызватьИсключение НСтр("ru = 'Вам недоступно управление правами.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат РазрешеноУправлениеПравами;
	
КонецФункции


