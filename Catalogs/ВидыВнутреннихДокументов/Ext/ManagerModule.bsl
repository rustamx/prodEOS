﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей ВидаВнутреннихДокументов
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруВидаВнутреннихДокументов() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Наименование");
	Параметры.Вставить("АвтоматическиВестиСоставУчастниковРабочейГруппы");
	Параметры.Вставить("ВестиУчетПоКонтрагентам");
	Параметры.Вставить("ВестиУчетПоОрганизациям");
	Параметры.Вставить("ВестиУчетПоНоменклатуреДел");
	Параметры.Вставить("ИспользоватьСрокИсполнения");
	Параметры.Вставить("ОбязателенФайлОригинала");
	Параметры.Вставить("ПодписыватьРезолюцииЭП");
	Параметры.Вставить("ОбязательноеЗаполнениеРабочихГруппДокументов");
	Параметры.Вставить("УчитыватьНедействующиеДокументы");
	Параметры.Вставить("УчитыватьСрокДействия");
	Параметры.Вставить("УчитыватьСуммуДокумента");
	Параметры.Вставить("ЯвляетсяДоговором");
	Параметры.Вставить("ЯвляетсяКомплектомДокументов");
	Параметры.Вставить("ВестиУчетПоАдресатам");
	Параметры.Вставить("Родитель");
	
	Возврат Параметры;
	
КонецФункции

// Создает и записывает в БД вид внутреннего документа
//
// Параметры:
//   СтруктураВидаВнутреннегоДокумента - Структура - структура полей видов внутренних документов.
//
Функция СоздатьВидВнутреннегоДокумента(СтруктураВидаВнутреннегоДокумента) Экспорт
	
	НовыйВидВнутреннегоДокумента = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйВидВнутреннегоДокумента, СтруктураВидаВнутреннегоДокумента);
	НовыйВидВнутреннегоДокумента.Записать();
	
	Возврат НовыйВидВнутреннегоДокумента.Ссылка;
	
КонецФункции

// Возвращает структуру полей группы видов внутренних документов
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруГруппыВидовВнутреннихДокументов() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Наименование");
	Параметры.Вставить("Комментарий");
	Параметры.Вставить("Родитель");
	
	Возврат Параметры;
	
КонецФункции

// Создает и записывает в БД группу видов внутренних документа
//
// Параметры:
//   СтруктураВидаВнутреннегоДокумента - Структура - структура полей видов внутренних документов.
//
Функция СоздатьГруппуВидовВнутреннихДокументов(СтруктураГруппыВидовВнутреннихДокументов) Экспорт
	
	НоваяГруппа = СоздатьГруппу();
	ЗаполнитьЗначенияСвойств(НоваяГруппа, СтруктураГруппыВидовВнутреннихДокументов);
	НоваяГруппа.Записать();
	
	Возврат НоваяГруппа.Ссылка;
	
КонецФункции

#КонецОбласти

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Параметры.Отбор.Вставить("ПометкаУдаления", Ложь);
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции_УправлениеДоступом

// УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка, ЭтоГруппа";
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.Ссылка;
	
КонецПроцедуры

// Возвращает признак того, что менеджер содержит метод ЗапросДляРасчетаПрав()
// 
Функция ЕстьМетодЗапросДляРасчетаПрав() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает запрос для расчета прав доступа по дескрипторам объекта
// 
// Параметры:
//  
//  Дескрипторы - Массив - массив дескрипторов, чьи права нужно рассчитать
//  ИдОбъекта - Ссылка - идентификатор объекта метаданных, назначенный переданным дескрипторам
//  МенеджерОбъектаДоступа - СправочникМенеджер, ДокументМенеджер - менеджер объекта доступа
// 
// Возвращаемое значение - Запрос - запрос, который выберет права доступа для переданного массива дескрипторов
// 
Функция ЗапросДляРасчетаПрав(Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа) Экспорт
	
	Запрос = Справочники.ДескрипторыДоступаОбъектов.ЗапросДляСтандартногоРасчетаПрав(
		Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа, Ложь, Истина);
	Запрос.Текст = ДокументооборотПраваДоступаПовтИсп.ТекстЗапросаДляРасчетаПравРазрезаДоступа();
	
	Возврат Запрос;
	
КонецФункции

// Заполняет протокол расчета прав дескрипторов
// 
// Параметры:
//  
//  ПротоколРасчетаПрав - Массив - протокол для заполнения
//  ЗапросПоПравам - Запрос - запрос, который использовался для расчета прав дескрипторов
//  Дескрипторы - Массив - массив дескрипторов, чьи права были рассчитаны
//  
Процедура ЗаполнитьПротоколРасчетаПрав(ПротоколРасчетаПрав, ЗапросПоПравам) Экспорт
	
	Справочники.ДескрипторыДоступаОбъектов.ЗаполнитьПротоколРасчетаПравСтандартно(
		ПротоколРасчетаПрав, ЗапросПоПравам);
	
КонецПроцедуры

// Конец УправлениеДоступом

#КонецОбласти

#КонецЕсли
