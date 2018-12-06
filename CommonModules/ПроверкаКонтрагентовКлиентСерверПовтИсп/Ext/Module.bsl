﻿////////////////////////////////////////////////////////////////////////////////
// Проверка одного или нескольких контрагентов при помощи веб-сервиса ФНС.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определение по состоянию, является ли контрагент действующим.
//
// Параметры:
//  Состояние					 - Перечисления.СостоянияСуществованияКонтрагента - Состояние контрагента.
//  ДополнятьСостояниемСОшибкой	 - Булево - Если Истина, то контрагент с ошибкой считается действующим.
//  ДополнятьПустымСостоянием	 - Булево - Если Истина, то контрагент с пустым состоянием считается действующим.
// Возвращаемое значение:
//  Булево - Является ли контрагент действующим.
//
Функция ЭтоСостояниеДействующегоКонтрагента(Состояние, ДополнятьСостояниемСОшибкой = Истина, ДополнятьПустымСостоянием = Истина) Экспорт
	
	Состояния = ПроверкаКонтрагентовКлиентСерверПовтИсп.СостоянияДействующегоКонтрагента(
		ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием);
	Возврат Состояния.Найти(Состояние) <> Неопределено;
			
КонецФункции

// Перечень состояний действующего контрагента.
//
// Параметры:
//  ДополнятьСостояниемСОшибкой	 - Булево - Если Истина, то контрагент с ошибкой считается действующим.
//  ДополнятьПустымСостоянием	 - Булево - Если Истина, то контрагент с пустым состоянием считается действующим.
// Возвращаемое значение:
// Массив - Состояния контрагента, при которых он является действующим.
//
Функция СостоянияДействующегоКонтрагента(ДополнятьСостояниемСОшибкой = Истина, ДополнятьПустымСостоянием = Истина) Экспорт
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентЕстьВБазеФНС"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентНеПодлежитПроверке"));
	ДобавитьДополнительныеСостояния(МассивСостояний, ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием);
	
	Возврат МассивСостояний;
			
КонецФункции

// Определение по состоянию, является ли контрагент недействующим.
//
// Параметры:
//  Состояние					 - Перечисления.СостоянияСуществованияКонтрагента - Состояние контрагента.
//  ДополнятьСостояниемСОшибкой	 - Булево - Если Истина, то контрагент с ошибкой считается недействующим.
//  ДополнятьПустымСостоянием	 - Булево - Если Истина, то контрагент с пустым состоянием считается недействующим.
// Возвращаемое значение:
//  Булево - Является ли контрагент недействующим.
//
Функция ЭтоСостояниеНедействующегоКонтрагента(Состояние, ДополнятьСостояниемСОшибкой = Ложь, ДополнятьПустымСостоянием = Ложь) Экспорт
	
	Состояния = ПроверкаКонтрагентовКлиентСерверПовтИсп.СостоянияНедействующегоКонтрагента(
		ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием);
	Возврат Состояния.Найти(Состояние) <> Неопределено;
			
КонецФункции

// Перечень состояний недействующего контрагента.
//
// Параметры:
//  ДополнятьСостояниемСОшибкой	 - Булево - Если Истина, то контрагент с ошибкой считается действующим.
//  ДополнятьПустымСостоянием	 - Булево - Если Истина, то контрагент с пустым состоянием считается действующим.
// Возвращаемое значение:
// Массив - Состояния контрагента, при которых он является действующим.
//
Функция СостоянияНедействующегоКонтрагента(ДополнятьСостояниемСОшибкой = Ложь, ДополнятьПустымСостоянием = Ложь) Экспорт
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КППНеСоответствуетДаннымБазыФНС"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентОтсутствуетВБазеФНС"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП"));
	ДобавитьДополнительныеСостояния(МассивСостояний, ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием);
	
	Возврат МассивСостояний;
			
КонецФункции

// Определение по состоянию, имеет ли контрагент ошибки в данных.
//
// Параметры:
//  Состояние	 - Перечисления.СостоянияСуществованияКонтрагента - Состояние контрагента.
// 
// Возвращаемое значение:
//  Булево - Имеет ли контрагент ошибки.
//
Функция ЭтоСостояниеКонтрагентаСОшибкой(Состояние) Экспорт
	
	Состояния = ПроверкаКонтрагентовКлиентСерверПовтИсп.СостоянияКонтрагентаСОшибкой();
	Возврат Состояния.Найти(Состояние) <> Неопределено;
			
КонецФункции

// Перечень состояний контрагента с ошибками в данных.
// 
// Возвращаемое значение:
// Массив - Состояния контрагента, при которых он имеет ошибки в данных.
//
Функция СостоянияКонтрагентаСОшибкой() Экспорт
	
	Возврат ВсеОшибочныеСостоянияКонтрагента();
			
КонецФункции

// Перечень недействующих состояний и состояний с ошибками.
// 
// Возвращаемое значение:
// Массив - Состояния контрагента, при которых он имеет ошибки в данных.
//
Функция НекорректныеСостоянияКонтрагента() Экспорт
	
	МассивСостояний = Новый Массив;
	
	Состояния = ПроверкаКонтрагентовКлиентСерверПовтИсп.СостоянияНедействующегоКонтрагента(Истина);
	Для каждого Состояние Из Состояния Цикл
		МассивСостояний.Добавить(Состояние);
	КонецЦикла;
	
	Состояния = ПроверкаКонтрагентовКлиентСерверПовтИсп.СостоянияКонтрагентаСОшибкой();
	Для каждого Состояние Из Состояния Цикл
		МассивСостояний.Добавить(Состояние);
	КонецЦикла;

	Возврат МассивСостояний;
	
КонецФункции

// Является ли состояние некорректным (недействующее состояние или с ошибкой).
// 
// Возвращаемое значение:
//  Булево - Имеет ли контрагент ошибки.
//
Функция ЭтоНекорректноеСостояниеКонтрагента(Состояние) Экспорт
	
	Состояния = ПроверкаКонтрагентовКлиентСерверПовтИсп.НекорректныеСостоянияКонтрагента();
	Возврат Состояния.Найти(Состояние) <> Неопределено;
	
КонецФункции


// Ссылка на инструкцию по проверке контрагентов.
// Возвращаемое значение:
//  ФорматированнаяСтрока - Ссылка на инструкцию.
//
Функция СсылкаНаИнструкцию() Экспорт
	Возврат Новый ФорматированнаяСтрока(НСтр("ru = 'Подробнее о проверке'; en = 'Learn more about verification'"),,,, ПутьКИнструкции());
КонецФункции

// Путь к инструкции по проверке контрагентов.
// Возвращаемое значение:
//  Строка - Путь к инструкции по проверке контрагентов.
//
Функция ПутьКИнструкции() Экспорт
	Возврат "e1cib/app/Обработка.ИнструкцияПоИспользованиюПроверкиКонтрагента";
КонецФункции

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Процедура ДобавитьДополнительныеСостояния(МассивСостояний, ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием)
	
	Если ДополнятьСостояниемСОшибкой Тогда
		МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентСодержитОшибкиВДанных"));
	КонецЕсли;
	Если ДополнятьПустымСостоянием Тогда
		МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустаяСсылка"));
	КонецЕсли;
	
КонецПроцедуры

Функция ВсеОшибочныеСостоянияКонтрагента(НевернуюДатуСчитатьОшибкой = Истина) Экспорт
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентСодержитОшибкиВДанных"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НеверныйИНН"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НевернаяДлинаИНН"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НевернаяДлинаКПП"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НедопустимыеСимволыВИНН"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НедопустимыеСимволыВКПП"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ИПНеМожетИметьКПП"));
	
	Если НевернуюДатуСчитатьОшибкой Тогда
		МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НекорректныйФорматДаты"));
		МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НевернаяДата"));
	КонецЕсли;
	
	Возврат МассивСостояний;
			
КонецФункции

#КонецОбласти
