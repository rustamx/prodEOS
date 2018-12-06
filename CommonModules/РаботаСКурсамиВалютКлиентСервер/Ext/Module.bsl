﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Валюты"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Пересчитывает Сумму из Текущей валюты в Новую валюту по параметрам их курсов. 
//   Параметры курсов валют можно получить воспользовавшись функцией.
//   РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, ДатаКурса).
//
// Параметры:
//   Сумма                  - Число     - Сумма, которую следует пересчитать.
//   ПараметрыТекущегоКурса - Структура - Параметры курса валюты, из которой надо пересчитать.
//       * Валюта    - СправочникСсылка.Валюты - Ссылка пересчитываемой валюты.
//       * Курс      - Число - Курс пересчитываемой валюты.
//       * Кратность - Число - Кратность пересчитываемой валюты.
//   ПараметрыНовогоКурса   - Структура - Параметры курса валюты, в  которую надо пересчитать.
//       * Валюта    - СправочникСсылка.Валюты - Ссылка валюты, в которую идет пересчет.
//       * Курс      - Число - Курс валюты, в которую идет пересчет.
//       * Кратность - Число - Кратность валюты, в которую идет пересчет.
//
// Возвращаемое значение: 
//   Число - Сумма, пересчитанная по новому курсу.
//
Функция ПересчитатьПоКурсу(Сумма, ПараметрыТекущегоКурса, ПараметрыНовогоКурса) Экспорт
	Если ПараметрыТекущегоКурса.Валюта = ПараметрыНовогоКурса.Валюта
		Или (ПараметрыТекущегоКурса.Курс = ПараметрыНовогоКурса.Курс 
			И ПараметрыТекущегоКурса.Кратность = ПараметрыНовогоКурса.Кратность) Тогда
		
		Возврат Сумма;
	КонецЕсли;
	
	Если ПараметрыТекущегоКурса.Курс = 0
		Или ПараметрыТекущегоКурса.Кратность = 0
		Или ПараметрыНовогоКурса.Курс = 0
		Или ПараметрыНовогоКурса.Кратность = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При пересчете в валюту %1 сумма %2 установлена в нулевое значение, т.к. курс валюты не задан.'; en = 'Converted in currency %1 value %2 set null, because currency rates are not specified'"), 
				ПараметрыНовогоКурса.Валюта, 
				Формат(Сумма, "ЧДЦ=2; ЧН=0")));
		
		Возврат 0;
		
	КонецЕсли;
	
	Возврат Окр((Сумма * ПараметрыТекущегоКурса.Курс * ПараметрыНовогоКурса.Кратность) / (ПараметрыНовогоКурса.Курс * ПараметрыТекущегоКурса.Кратность), 2);
КонецФункции

// Устарела. Следует использовать функцию ПересчитатьПоКурсу.
//
// Пересчитывает сумму из валюты ВалютаНач по курсу ПоКурсуНач 
// в валюту ВалютаКон по курсу ПоКурсуКон.
//
// Параметры:
//   Сумма          - Число - Сумма, которую следует пересчитать.
//   ВалютаНач      - СправочникСсылка.Валюты - Валюта, из которой надо пересчитать.
//   ВалютаКон      - СправочникСсылка.Валюты - Валюта, в  которую надо пересчитать.
//   ПоКурсуНач     - Число - Курс, из которого надо пересчитать.
//   ПоКурсуКон     - Число - Курс, в  который  надо пересчитать.
//   ПоКратностьНач - Число - Кратность, из которой надо пересчитать (по умолчанию = 1).
//   ПоКратностьКон - Число - Кратность, в  которую надо пересчитать (по умолчанию = 1).
//
// Возвращаемое значение: 
//   Число - Сумма, пересчитанная в другую валюту.
//
Функция ПересчитатьИзВалютыВВалюту(Сумма, ВалютаНач, ВалютаКон, ПоКурсуНач, ПоКурсуКон, 
	ПоКратностьНач = 1, ПоКратностьКон = 1) Экспорт
	
	Возврат ПересчитатьПоКурсу(
		Сумма, 
		Новый Структура("Валюта, Курс, Кратность", ВалютаНач, ПоКурсуНач, ПоКратностьНач),
		Новый Структура("Валюта, Курс, Кратность", ВалютаКон, ПоКурсуКон, ПоКратностьКон));
	
КонецФункции

#КонецОбласти
