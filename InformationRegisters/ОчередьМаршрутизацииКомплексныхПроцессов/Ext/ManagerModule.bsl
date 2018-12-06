﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет комплексный процесс в очередь для последующей обработки рег. заданием
// ФоноваяМаршрутизацияКомплексныхПроцессов
//
// Параметры:
//   КомплексныйПроцесс - БизнесПроцессСсылка.КомплексныйПроцесс - комплексный процесс для
//                        обработки.
//   ЗавершившеесяДействие - БизнесПроцессСсылка.<тип процесса> - завершившееся действие,
//                          после которого следует запустить следующие действия комплексного
//                          процесса.
//
Процедура ДобавитьПроцесс(КомплексныйПроцесс, ЗавершившеесяДействие = Неопределено) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.ОчередьМаршрутизацииКомплексныхПроцессов.
		СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КомплексныйПроцесс = КомплексныйПроцесс;
	МенеджерЗаписи.ЗавершившеесяДействие = ЗавершившеесяДействие;
	МенеджерЗаписи.МоментВремени = ТекущаяУниверсальнаяДатаВМиллисекундах();
	МенеджерЗаписи.ЗадачаОжидания = СоздатьЗадачуОжидания(КомплексныйПроцесс, ЗавершившеесяДействие);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Удаляет комплексный процесс из очереди для последующей обработки рег. заданием
// ФоноваяМаршрутизацияКомплексныхПроцессов
//
// Параметры
//   КомплексныйПроцесс - БизнесПроцессСсылка.КомплексныйПроцесс - комплексный процесс для
//                        обработки.
//   ЗавершившеесяДействие - БизнесПроцессСсылка.<тип процесса> - завершившееся действие,
//                          после которого следует запустить следующие действия комплексного
//                          процесса.
//   ЗавершатьЗадачиОжидания - Булево - признак необходимости выполнения задач ожидания.
//                             При выполнении инициируется выполнение процесса по карте маршрута.
//
Процедура УдалитьПроцесс(КомплексныйПроцесс,
	ЗавершившеесяДействие = Неопределено, ЗавершатьЗадачиОжидания = Ложь) Экспорт
	
	НаборЗаписей = РегистрыСведений.ОчередьМаршрутизацииКомплексныхПроцессов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.КомплексныйПроцесс.Установить(КомплексныйПроцесс);
	
	Если ЗначениеЗаполнено(ЗавершившеесяДействие) Тогда
		НаборЗаписей.Отбор.ЗавершившеесяДействие.Установить(ЗавершившеесяДействие);
	КонецЕсли;
	
	Если ЗавершатьЗадачиОжидания Тогда
		НаборЗаписей.Прочитать();
		Для Каждого Запись Из НаборЗаписей Цикл
			ЗавершитьЗадачуОжидания(Запись.ЗадачаОжидания);
		КонецЦикла;
		НаборЗаписей.Очистить();
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Добавляет текст ошибки и увеличивает число попыток для записи в очереди
// по комплексному процессу
// 
// Параметры:
//   КомплексныйПроцесс - БизнесПроцессСсылка.КомплексныйПроцесс - комплексный процесс для
//                        обработки.
//   ЗавершившеесяДействие - БизнесПроцессСсылка.<тип процесса> - завершившееся действие,
//                          после которого следует запустить следующие действия комплексного
//                          процесса.
//   ТекстОшибки - Строка - текст ошибки.
//
Процедура ДобавитьИнформациюОНеудачнойОбработкеПроцесса(
	КомплексныйПроцесс, ЗавершившеесяДействие, ТекстОшибки) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.ОчередьМаршрутизацииКомплексныхПроцессов.
		СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КомплексныйПроцесс = КомплексныйПроцесс;
	МенеджерЗаписи.ЗавершившеесяДействие = ЗавершившеесяДействие;
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.ТекстОшибки = ТекстОшибки;
	МенеджерЗаписи.КоличествоПопытокОбработки = МенеджерЗаписи.КоличествоПопытокОбработки + 1;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Сбрасывает количество попыток и текст ошибки у переданных записей очереди.
//
// Параметры:
//   - КомплексныеПроцесс - Массив - массив с описанием записей в очереди
//                             - Структура - описание записи в очереди
//                                   - КомплексныйПроцесс
//                                   - ЗавершившеесяДействие
//
Процедура ПродолжитьВыполнениеПроцессов(КомплексныеПроцесс) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого КомплексныйПроцесс ИЗ КомплексныеПроцесс Цикл
		
		ПараметрыКлюча = Новый Структура;
		ПараметрыКлюча.Вставить("КомплексныйПроцесс", КомплексныйПроцесс.КомплексныйПроцесс);
		ПараметрыКлюча.Вставить("ЗавершившеесяДействие", КомплексныйПроцесс.ЗавершившеесяДействие);
		
		КлючЗаписи = СоздатьКлючЗаписи(ПараметрыКлюча);
		Если КлючЗаписи.Пустой() Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаблокироватьДанныеДляРедактирования(КлючЗаписи);
		
		Запись = СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, КомплексныйПроцесс);
		Запись.Прочитать();
		Запись.КоличествоПопытокОбработки = 0;
		Запись.ТекстОшибки = "";
		Запись.Записать();
		
		РазблокироватьДанныеДляРедактирования(КлючЗаписи);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создает и возвращает ссылку на задачу ожидания для процесса.
//
// Параметры:
//  КомплексныеПроцесс - БизнесПроцессСсылка.КомплексныйПроцесс - ссылка на процесс.
//  Действие - БизнесПроцессСсылка - ссылка на действие процесса.
//
// Возвращаемое значение:
//  ЗадачаСсылка.ЗадачаИсполнителя - задача ожидания.
//
Функция СоздатьЗадачуОжидания(КомплексныеПроцесс, Действие = Неопределено)
	
	ЗадачаОжидания = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	ЗадачаОжидания.Дата = ТекущаяДатаСеанса();
	ЗадачаОжидания.ДатаНачала = ТекущаяДатаСеанса();
	ЗадачаОжидания.БизнесПроцесс = КомплексныеПроцесс;
	
	ЗадачаОжидания.ТочкаМаршрута = 
		БизнесПроцессы.КомплексныйПроцесс.ТочкиМаршрута.ВложенныйПроцесс;
	
	Если ЗначениеЗаполнено(Действие) Тогда
		НаименованиеЗадачи = СтрШаблон(
			НСтр("ru = 'Ожидание маршрутизации процесса ""%1"" после выполнения ""%2""'; en = 'Awaiting for the routing of the process ""%1"" after execution of ""%2""'"),
			Строка(КомплексныеПроцесс),
			Строка(Действие));
	Иначе
		НаименованиеЗадачи = СтрШаблон(
			НСтр("ru = 'Ожидание маршрутизации процесса ""%1""'; en = 'Awaiting for the routing of process ""%1""'"),
			Строка(КомплексныеПроцесс));
	КонецЕсли;
	ЗадачаОжидания.Наименование = НаименованиеЗадачи;
		
	ЗадачаОжидания.Записать();
	
	Возврат ЗадачаОжидания.Ссылка
	
КонецФункции

// Выполняет задачу ожидания, тем самым инициирует выполнение процесса.
// После выполнения задача удаляется.
//
// Параметры:
//  ЗадачаОжидания - ЗадачаСсылка.ЗадачаИсполнителя - задача ожидания.
//
Процедура ЗавершитьЗадачуОжидания(ЗадачаОжидания)
	
	ЗадачаОжиданияОбъект = ЗадачаОжидания.ПолучитьОбъект();
	ЗадачаОжиданияОбъект.ОбменДанными.Загрузка = Истина;
	ЗадачаОжиданияОбъект.ВыполнитьЗадачу();
	ЗадачаОжиданияОбъект.Удалить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


