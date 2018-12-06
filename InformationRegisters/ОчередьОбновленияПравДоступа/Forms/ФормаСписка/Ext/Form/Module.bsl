﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидОчереди = "Долгая";
	ОбновитьСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСервер()
	
	Список.Отбор.Элементы.Очистить();
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = ТекущийПриоритет();
	
	Элементы.Список.Обновить();
	ОбновитьКоличество();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличество()
	
	РазмерыОчереди = РазмерыОчереди();
	Для Каждого Эл Из Элементы.ВидОчереди.СписокВыбора Цикл
		Размер = РазмерыОчереди.Получить(Эл.Значение);
		Размер = ?(Размер = Неопределено, 0, Размер);
		Эл.Представление = Эл.Значение + " (" + Размер + ")";
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция РазмерОчереди()
	
	РазмерыОчереди = РазмерыОчереди();
	Результат = РазмерыОчереди.Получить(ВидОчереди);
	Если Результат = Неопределено Тогда
		Результат = 0;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция РазмерыОчереди()
	
	РазмерыОчереди = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ОчередьОбновленияПравДоступа.Приоритет = 1
		|			ТОГДА ""Оперативная""
		|		ИНАЧЕ ""Долгая""
		|	КОНЕЦ КАК ВидОчереди,
		|	КОЛИЧЕСТВО(*) КАК ЧислоЗаписей
		|ИЗ
		|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ОчередьОбновленияПравДоступа.Приоритет = 1
		|			ТОГДА ""Оперативная""
		|		ИНАЧЕ ""Долгая""
		|	КОНЕЦ";
	
	Запрос.УстановитьПараметр("Приоритет", ТекущийПриоритет());	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		РазмерыОчереди.Вставить(Выборка.ВидОчереди, Выборка.ЧислоЗаписей);
	КонецЦикла;
	
	Возврат РазмерыОчереди;
	
КонецФункции

&НаКлиенте
Процедура Очистить(Команда)
	
	ТекстВопроса = НСтр("ru = 'Внимание! 
		|Очистка приведет к тому, что стоящие в очереди права не будут обновлены. 
		|Очистить очередь?';
		|en = 'Attention! 
		|Cleaning will have the effect that queued permissions will not be updated. 
		|Clear the queue?'");
		
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("ОчиститьПродолжение", ЭтотОбъект);
		
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПродолжение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОчиститьСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСервер()
	
	Набор = РегистрыСведений.ОчередьОбновленияПравДоступа.СоздатьНаборЗаписей();
	Набор.Отбор.Приоритет.Установить(ТекущийПриоритет());
	Набор.Записать();
	
	ОбновитьСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПорцию(Команда)
	
	ТекстПредупреждения = ПроверитьРегламентныеЗаданияНаСервере();
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ОбновитьПорциюСервер();
	
КонецПроцедуры

&НаСервере
Функция ОбновитьПорциюСервер(РазмерПорции = 10, Поэлементно = Истина)
	
	ПриоритетСеанса = ПараметрыСеанса.ПриоритетОчередиОбновленияПрав;
	ОбработанныхВсего = 0;
	
	Попытка
		
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = ТекущийПриоритет();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ %1
			|	ОчередьОбновленияПравДоступа.Объект,
			|	ОчередьОбновленияПравДоступа.ДопСведения
			|ИЗ
			|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
			|ГДЕ
			|	ОчередьОбновленияПравДоступа.Приоритет = &Приоритет
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаВМиллиСекундах,
			|	Объект";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%1", Формат(РазмерПорции, "ЧГ="));
		Запрос.УстановитьПараметр("Приоритет", ПараметрыСеанса.ПриоритетОчередиОбновленияПрав);
		
		Результат = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ОбработанныеГрупповымРасчетом = Новый Соответствие;
			
			РегистрыСведений.ОчередьОбновленияПравДоступа.ОбработатьЭлементОчереди(
				ВыборкаДетальныеЗаписи.Объект, 
				ВыборкаДетальныеЗаписи.ДопСведения,
				ОбработанныеГрупповымРасчетом,
				Поэлементно);
			
			ОбработанныхГрупповымРасчетом = ОбработанныеГрупповымРасчетом.Количество();
			Если ОбработанныхГрупповымРасчетом > 0 Тогда
				ОбработанныхВсего = ОбработанныхВсего + ОбработанныхГрупповымРасчетом;
			Иначе
				ОбработанныхВсего = ОбработанныхВсего + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = ПриоритетСеанса;
		
	Исключение	
		
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = ПриоритетСеанса;
		ВызватьИсключение;
		
	КонецПопытки;
	
	ОбновитьСервер();
	
	Возврат ОбработанныхВсего;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьВыбранные(Команда)
	
	ТекстПредупреждения = ПроверитьРегламентныеЗаданияНаСервере();
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ОбновитьВыбранныеСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВыбранныеСервер()
	
	ПриоритетСеанса = ПараметрыСеанса.ПриоритетОчередиОбновленияПрав;
	
	Попытка
		
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = ТекущийПриоритет();
		
		Для Каждого Эл Из Элементы.Список.ВыделенныеСтроки Цикл
			
			РегистрыСведений.ОчередьОбновленияПравДоступа.ОбработатьЭлементОчереди(
				Эл.Объект, Эл.ДопСведения,, Истина);
			
		КонецЦикла;	
		
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = ПриоритетСеанса;
		
	Исключение	
		
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = ПриоритетСеанса;
		ВызватьИсключение;
		
	КонецПопытки;
	
	ОбновитьСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВсе(Команда)
	
	ТекстПредупреждения = ПроверитьРегламентныеЗаданияНаСервере();
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется обработка очереди обновления прав.
		|Пожалуйста подождите ...';
		|en = 'Processing permissions update queue.
		|Please wait ...'"));
		
	ДатаНачала = ТекущаяДата();
	
	ОбщееЧисло = РазмерОчереди();
	Обработано = 0;
	РазмерПорции = 10;
	
	ОбработаноВТекущейИтерации = ОбновитьПорциюСервер(РазмерПорции, Ложь);
	Пока ОбработаноВТекущейИтерации <> 0 Цикл
		
		Обработано = Обработано + ОбработаноВТекущейИтерации;
		Если Обработано > ОбщееЧисло Тогда
			Обработано = 0;
			ОбщееЧисло = РазмерОчереди();
		КонецЕсли;	
		
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
 			НСтр("ru = 'Обработано: %1 из %2'; en = 'Processed: %1 %2'"),
			Обработано, ОбщееЧисло);
			
		Если ОбщееЧисло <> 0 Тогда	
			Процент = (Обработано*100)/ОбщееЧисло;
		Иначе	
			Процент = 100;
		КонецЕсли;
		
		Состояние(
			НСтр("ru = 'Выполняется обработка очереди обновления прав...'; en = 'Processing permissions update queue...'"),
			Процент,
			ТекстПояснения,
			БиблиотекаКартинок.Информация32);
		
		ОбработаноВТекущейИтерации = ОбновитьПорциюСервер(РазмерПорции, Ложь);
		
	КонецЦикла;	
	
	ДатаОкончания = ТекущаяДата();
	
	Состояние("");
	
	ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
 		НСтр("ru = 'Обработка очереди обновления прав завершена (%1 сек).'; en = 'Processing permissions update queue completed (%1 s).'"),
		ДатаОкончания - ДатаНачала);
		
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОчередиПриИзменении(Элемент)
	
	ОбновитьСервер();
	
КонецПроцедуры

Функция ТекущийПриоритет()
	
	Приоритет = 1;
	Если ВидОчереди <> "Оперативная" Тогда
		Приоритет = 2;
	КонецЕсли;
	
	Возврат Приоритет;
	
КонецФункции	

&НаСервере
Функция ПроверитьРегламентныеЗаданияНаСервере()
	
	ТекстПредупреждения = "";
	РеглЗадание = Неопределено;
	
	Если ТекущийПриоритет() = 1 Тогда
		РеглЗадание = РегламентныеЗадания.НайтиПредопределенное(
			Метаданные.РегламентныеЗадания.ДокументооборотОбновлениеПравДоступаОперативное);
	Иначе
		РеглЗадание = РегламентныеЗадания.НайтиПредопределенное(
			Метаданные.РегламентныеЗадания.ДокументооборотОбновлениеПравДоступаДолгое);
	КонецЕсли;
	
	Если РеглЗадание.Использование Тогда
		
		ТекстПредупреждения = СтрШаблон(НСтр("ru = 'Выполняется регламентное задание ""%1"".
			|Обработка очереди вручную запрещена.';
			|en = 'Executing scheduled job ""%1"".
			|Manual queue processing is forbidden.'"), РеглЗадание.Метаданные.Синоним);
			
	Иначе
			
		СтруктураОтбора = Новый Структура("Состояние, УникальныйИдентификатор",
			СостояниеФоновогоЗадания.Активно, РеглЗадание.УникальныйИдентификатор);
		
		НайденныеФЗ = ФоновыеЗадания.ПолучитьФоновыеЗадания(СтруктураОтбора);
		Если НайденныеФЗ.Количество() > 0 Тогда
			ТекстПредупреждения = СтрШаблон(НСтр("ru = 'Выполняется фоновое задание ""%1"".
				|Обработка очереди вручную запрещена.';
				|en = 'Executing background job ""%1"".
				|Manual queue processing is forbidden.'"), РеглЗадание.Метаданные.Синоним);
		КонецЕсли;
			
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции


