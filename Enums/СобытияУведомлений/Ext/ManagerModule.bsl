﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Преобразует событие уведомление в вид бизнес события, если возможно.
//
// Параметры:
//  СобытиеУведомления - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Событие уведомления.
//
// Возвращаемое значение:
//  СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Приведенный вид события.
//
Функция ВидБизнесСобытия(СобытиеУведомления) Экспорт
	
	ВидБизнесСобытия = СобытиеУведомления;
	Если СобытиеУведомления = ВыполнениеМоейЗадачи Тогда
		ВидБизнесСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи;
		
	ИначеЕсли СобытиеУведомления = ПеренаправлениеМоейЗадачи Тогда
		ВидБизнесСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи;
		
	КонецЕсли;
	
	Возврат ВидБизнесСобытия;
	
КонецФункции

// Формирует список доступных видов событий по объекту.
//
// Параметры:
//  Объект - ЛюбаяСсылка - Объект.
//
// Возвращаемое значение:
//  СписокЗначений - Виды событий по объекту.
//
Функция ВидыСобытийПоОбъекту(Объект) Экспорт
	
	СписокВидовБизнесСобытий = Новый СписокЗначений;
	Если ТипЗнч(Объект) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокЗадачи);
		СписокВидовБизнесСобытий.Добавить(ПросроченаЗадача);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ОтменаВыполненияЗадачи);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Файлы") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ОсвобождениеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ЗахватФайлаДляРедактирования);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеВходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеререгистрацияВходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.РегистрацияВходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеререгистрацияВнутреннегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.РегистрацияВнутреннегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеСоставаКомплекта);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПапкиВнутреннихДокументов") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыВнутреннихДокументов")
		Или ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыВходящихДокументов")
		Или ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.НазначениеОтветственного);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеИсходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеререгистрацияИсходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.РегистрацияИсходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли РаботаСУведомлениями.ЭтоПоддерживаемыйБизнесПроцесс(Объект) Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ВозобновлениеБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ЗавершениеБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ОстановкаБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СтартБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПрерываниеБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Пользователи") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеЗадачи);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи);
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокЗадачи);
		СписокВидовБизнесСобытий.Добавить(ПросроченаЗадача);
		СписокВидовБизнесСобытий.Добавить(ПросроченаЗадачаАвтора);
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокКонтроля);
		СписокВидовБизнесСобытий.Добавить(ПросроченКонтроль);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеОтсутствия);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеОтсутствия);
		СписокВидовБизнесСобытий.Добавить(СозданиеЗаписиКалендаря);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.СообщенияОбсуждений") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ТемыОбсуждений") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Проекты") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеПроекта);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеПроектнойЗадачи);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Контроль") Тогда
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокКонтроля);
		СписокВидовБизнесСобытий.Добавить(ПросроченКонтроль);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Отсутствие") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеОтсутствия);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Мероприятия") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеМероприятия);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.КатегорииДанных") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ДобавлениеВКатегорию);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.УдалениеИзКатегории);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Бронь") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеБрони);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ТерриторииИПомещения") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеБрони);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеБрони);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПоказателиПроцессов") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеЗначенияПоказателяПроцесса);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.КонтрольныеТочки") Тогда
		СписокВидовБизнесСобытий.Добавить(ПросроченаКонтрольнаяТочка);
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокКонтрольнойТочки);
		СписокВидовБизнесСобытий.Добавить(ПросроченаОценкаКонтрольнойТочки);
		
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из СписокВидовБизнесСобытий Цикл
		ЭлементСписка.Представление = ПредставлениеВидаСобытия(ЭлементСписка.Значение, Объект);
	КонецЦикла;
	СписокВидовБизнесСобытий.СортироватьПоПредставлению();
	
	Возврат СписокВидовБизнесСобытий;
	
КонецФункции

// Формирует список видов событий подписки на бизнес-событие.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//
// Возвращаемое значение:
//  Массив - Виды событий подписки.
//
Функция ВидыСобытийПодписки(ВидСобытия) Экспорт
	
	ВидыСобытий = Новый Массив;
	ВидыСобытий.Добавить(ВидСобытия);
	Если ВидСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи Тогда
		ВидыСобытий.Добавить(ВыполнениеМоейЗадачи);
		
	ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи Тогда
		ВидыСобытий.Добавить(ПеренаправлениеМоейЗадачи);
		
	КонецЕсли;
	
	Возврат ВидыСобытий;
	
КонецФункции

// Формирует представление события для конкретного объекта.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
// 
// Возвращаемое значение:
//  Строка - Представление события.
//
Функция ПредставлениеВидаСобытия(ВидСобытия, Объект, Пользователь = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КодЯзыка = РаботаСУведомлениями.КодЯзыка(Пользователь);
	Если ТипЗнч(Объект) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		
		Если ВидСобытия = ПодошелСрокЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Истекает срок исполнения задачи'; en = 'Task is about to become overdue'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Выполнена задача'; en = 'Task executed'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перенаправлена задача'; en = 'Task was forwarded'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ОтменаВыполненияЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Отменено выполнение задачи'; en = 'Task execution was cancelled'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новая задача'; en = 'New task'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ в обсуждении задачи'; en = 'New reply in task forum thread'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПрерываниеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Прервана задача '; en = 'Task was terminated '", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ОстановкаБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Остановлена задача'; en = 'Task was stopped'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ВозобновлениеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Возобновлена задача'; en = 'Task was resumed'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПеренаправлениеМоейЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перенаправлена моя задача'; en = 'My task was forwarded'", КодЯзыка);
		ИначеЕсли ВидСобытия = ВыполнениеМоейЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Выполнена моя задача'; en = 'My task executed'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Файлы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ЗахватФайлаДляРедактирования Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Захвачен файл для редактирования'; en = 'File locked for editing'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился файл'; en = 'File was modified'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ОсвобождениеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Освобожден файл'; en = 'File was unlocked'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ в обсуждении файла'; en = 'New reply in file forum thread'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Создан новый файл в папке'; en = 'New file was created in folder'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыВнутреннихДокументов")
		Или ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыВходящихДокументов")
		Или ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.НазначениеОтветственного Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Вы назначены ответственным за документ'; en = 'You were appointed as responsible for the document'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Присоединен новый файл к входящему документу'; en = 'New file was attached to an incoming document'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеВходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился входящий документ'; en = 'Incoming document was modified'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеререгистрацияВходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перерегистрирован входящий документ'; en = 'Incoming document was re-registered'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.РегистрацияВходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Зарегистрирован входящий документ'; en = 'Incoming document was registered'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Получен новый ответ в обсуждении входящего документа'; en = 'New reply in incoming document forum thread'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Присоединен новый файл к внутреннему документу'; en = 'New file was attached to an internal document'", КодЯзыка)
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился внутренний документ'; en = 'Internal document was modified'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеСоставаКомплекта Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился состав комплекта'; en = 'Set contents was modified'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеререгистрацияВнутреннегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перерегистрирован внутренний документ'; en = 'Internal document was re-registered'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.РегистрацияВнутреннегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Зарегистрирован внутренний документ'; en = 'Internal document was registered'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Получен новый ответ в обсуждении внутреннего документа'; en = 'New reply in internal document forum thread'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПапкиВнутреннихДокументов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Создан новый внутренний документ в папке'; en = 'New internal document was created in folder'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Присоединен новый файл к исходящему документу'; en = 'New file was attached to an outgoing document'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеИсходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился исходящий документ'; en = 'Outgoing document was modified'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеререгистрацияИсходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перерегистрирован исходящий документ'; en = 'Outgoing document was re-registered'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.РегистрацияИсходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Зарегистрирован исходящий документ'; en = 'Outgoing document was registered'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Получен новый ответ в обсуждении исходящего документа'; en = 'New reply in outgoing document forum thread'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли РаботаСУведомлениями.ЭтоПоддерживаемыйБизнесПроцесс(Объект) Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ВозобновлениеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Возобновлен процесс'; en = 'Process was resumed'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ЗавершениеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Завершен процесс'; en = 'Process completed'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ОстановкаБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Остановлен процесс'; en = 'Process was stopped'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СтартБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Стартован процесс'; en = 'Procoess started'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Ход выполнения процесса'; en = 'Process execution progress'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПрерываниеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Прерван процесс'; en = 'Process was terminated'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Поступила новая задача пользователю'; en = 'New task for user'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перенаправлена задача пользователю'; en = 'Task was forwarded to user'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПодошелСрокЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Подошел срок задачи пользователя'; en = 'User''s task due date is approaching'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченаЗадача Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Просрочена задача пользователя'; en = 'User''s task is overdue'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченаЗадачаАвтора Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Просрочена задача автора'; en = 'Author''s task is overdue'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПодошелСрокКонтроля Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Подошел срок контроля пользователя'; en = 'User''s monitoring due date is approaching'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченКонтроль Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Истек срок контроля'; en = 'Monitoring is overdue'", КодЯзыка);
		ИначеЕсли ВидСобытия = СозданиеЗаписиКалендаря Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новая запись в календаре пользователя'; en = 'New entry in user''s calendar'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.СообщенияОбсуждений") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ на сообщение обсуждения'; en = 'New reply to forum message'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ТемыОбсуждений") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новое сообщение в теме обсуждения'; en = 'New message in forum thread'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Проекты") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ в обсуждении проекта'; en = 'New reply in project forum thread'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеПроекта Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился проект'; en = 'Project was modified'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
			
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ в обсуждении проектной задачи'; en = 'New reply in project task forum thread'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеПроектнойЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменилась проектная задача'; en = 'Project task was modified'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Контроль") Тогда
		
		Если ВидСобытия = ПодошелСрокКонтроля Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Подходит срок контроля'; en = 'Monitoring due date is approaching'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Мероприятия") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Присоединен новый файл к мероприятию'; en = 'New file was attached to an event'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Получен новый ответ в обсуждении мероприятия'; en = 'New reply in event forum thread'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеМероприятия Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменилось мероприятие'; en = 'Event was modified'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.КатегорииДанных") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ДобавлениеВКатегорию Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Добавлен элемент в категорию'; en = 'Item was added to category'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.УдалениеИзКатегории Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Удален элемент из категории'; en = 'Item was removed from category'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Бронь") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеБрони Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменена бронь'; en = 'Reservation was modified'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ТерриторииИПомещения") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеБрони Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Создана бронь помещения'; en = 'Reservation was created'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеБрони Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменена бронь помещения'; en = 'Premises reservation was modified'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПоказателиПроцессов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеЗначенияПоказателяПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменилось значение показателя процесса'; en = 'Process metric value was changed'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ЗаписиРабочегоКалендаря") Тогда
		
		Если ВидСобытия = СозданиеЗаписиКалендаря Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новая запись календаря'; en = 'New calendar entry'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.КонтрольныеТочки") Тогда
		
		Если ВидСобытия = ПодошелСрокКонтрольнойТочки Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Подошел срок контрольной точки'; en = 'Milestone due date is approaching'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченаКонтрольнаяТочка Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Просрочена контрольная точка'; en = 'Milestone is overdue'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченаОценкаКонтрольнойТочки Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Просрочена оценка контрольной точки'; en = 'Milestone estimation is overdue'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	Иначе
		
		ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		
	КонецЕсли;
	
	Возврат ПредставлениеБизнесСобытия;
	
КонецФункции

// Формирует признак доступности подписка на событие для конкретного объекта.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
// 
// Возвращаемое значение:
//  Булево - Доступна подписка на событие.
//
Функция ДоступнаПодпискаНаСобытие(ВидСобытия, ОбъектПодписки) Экспорт
	
	ДоступнаПодпискаНаСобытие = Ложь;
	Если ТипЗнч(ОбъектПодписки) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		
		Если ВидСобытия = ПодошелСрокЗадачи
			Или ВидСобытия = ПросроченаЗадача
			Или ВидСобытия = ПросроченаЗадачаАвтора
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.ОтменаВыполненияЗадачи
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ДоступнаПодпискаНаСобытие = Истина;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВидыВнутреннихДокументов")
		Или ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВидыВходящихДокументов")
		Или ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.НазначениеОтветственного Тогда
			ДоступнаПодпискаНаСобытие = Истина;
		КонецЕсли;
		
	ИначеЕсли РаботаСУведомлениями.ЭтоПоддерживаемыйБизнесПроцесс(ОбъектПодписки) Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ДоступнаПодпискаНаСобытие = Истина;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.СообщенияОбсуждений") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ТемыОбсуждений") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Проекты") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Контроль") Тогда
		
		Если ВидСобытия = Перечисления.СобытияУведомлений.ПодошелСрокКонтроля
			Или ВидСобытия = Перечисления.СобытияУведомлений.ПросроченКонтроль Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Файлы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Мероприятия") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеОтсутствия
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеОтсутствия
			Или ВидСобытия = Перечисления.СобытияУведомлений.СозданиеЗаписиКалендаря Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ТерриторииИПомещения") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеБрони
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеБрони Тогда
			ДоступнаПодпискаНаСобытие = Истина;;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДоступнаПодпискаНаСобытие;
	
КонецФункции

// Выполняет дополнительную проверку подписки.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
// 
// Возвращаемое значение:
//  Булево - Результат проверки.
//
Функция ДополнительнаяПроверкаПодписки(Пользователь, ВидСобытия, Объект) Экспорт
	
	Результат = Истина;
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.СообщенияОбсуждений")
		И ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
		// Не посылать уведомление о создание нового сообщения автору этого сообщения.
		Результат = (Объект.Автор <> Пользователь);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПоказателиПроцессов")
		И ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеЗначенияПоказателяПроцесса Тогда
		
		НастройкаПроцентноеИзменение = РегистрыСведений.НастройкиУведомлений.ПолучитьДополнительнуюНастройку(
			Пользователь,
			Перечисления.НастройкиУведомлений.ПроцентноеИзменение);
		Если НастройкаПроцентноеИзменение <> 0 Тогда
			ТекущиеДанные = РегистрыСведений.ЗначенияПоказателейПроцессов.ТекущиеДанные(Объект);
			Результат = (ТекущиеДанные <> Неопределено)
				И (ТекущиеДанные.ИзменениеПроцент >= НастройкаПроцентноеИзменение);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Определяет вид уведомления программы.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ВидыУведомленийПрограммы - Вид уведомления программы.
//
Функция ОпределитьВидУведомления(ВидСобытия) Экспорт
	
	ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Информация;
	Если ВидСобытия = ПодошелСрокЗадачи
		Или ВидСобытия = ПросроченаЗадача
		Или ВидСобытия = ПросроченаЗадачаАвтора
		Или ВидСобытия = ПодошелСрокДействияДокумента
		Или ВидСобытия = ЗакончилсяСрокДействияДокумента
		Или ВидСобытия = ПодошелСрокКонтроля
		Или ВидСобытия = ПросроченКонтроль
		Или ВидСобытия = ПросроченаКонтрольнаяТочка
		Или ВидСобытия = ПодошелСрокКонтрольнойТочки
		Или ВидСобытия = ПросроченаОценкаКонтрольнойТочки Тогда
		ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Предупреждение;
	ИначеЕсли ВидСобытия = УведомлениеПрограммы Тогда
		ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Ошибка;
	КонецЕсли;
	
	Возврат ВидУведомления;
	
КонецФункции

#КонецОбласти

#КонецЕсли
