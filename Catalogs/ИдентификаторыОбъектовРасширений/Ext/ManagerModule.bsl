﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура обновляет данные справочника по метаданным конфигурации.
//
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - в этот параметр возвращается
//                  значение Истина, если производилась запись, иначе не изменяется.
//
//  ЕстьУдаленные - Булево (возвращаемое значение) - в этот параметр возвращается
//                  значение Истина, если хотя бы один элемент справочника был помечен
//                  на удаление, иначе не изменяется.
//
//  ТолькоПроверка - Булево (возвращаемое значение) - не производит никаких изменений,
//                  а лишь выполняет установку флажков ЕстьИзменения, ЕстьУдаленные.
//
Процедура ОбновитьДанныеСправочника(ЕстьИзменения = Ложь, ЕстьУдаленные = Ложь, ТолькоПроверка = Ложь) Экспорт
	
	Справочники.ИдентификаторыОбъектовМетаданных.ВыполнитьОбновлениеДанных(ЕстьИзменения,
		ЕстьУдаленные, ТолькоПроверка, , , Истина);
	
КонецПроцедуры

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.РеквизитыРедактируемыеВГрупповойОбработке();
	
КонецФункции

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.ПоляЕстественногоКлюча();
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. описание одноименной процедуры в общем модуле ОбщегоНазначения.
Функция ОбъектРасширенияОтключен(Идентификатор) Экспорт
	
	СтандартныеПодсистемыПовтИсп.ИдентификаторыОбъектовМетаданныхПроверкаИспользования(Истина, Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Идентификатор);
	Запрос.УстановитьПараметр("ВерсияРасширений", ПараметрыСеанса.ВерсияРасширений);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовРасширений КАК Идентификаторы
	|ГДЕ
	|	Идентификаторы.Ссылка = &Ссылка
	|	И НЕ Идентификаторы.ПометкаУдаления
	|	И НЕ ИСТИНА В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					ИСТИНА
	|				ИЗ
	|					РегистрСведений.ИдентификаторыОбъектовВерсийРасширений КАК ВерсииИдентификаторов
	|				ГДЕ
	|					ВерсииИдентификаторов.Идентификатор = Идентификаторы.Ссылка
	|					И ВерсииИдентификаторов.ВерсияРасширений = &ВерсияРасширений)";
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли
