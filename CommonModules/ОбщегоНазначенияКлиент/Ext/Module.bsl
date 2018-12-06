﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Клиентские процедуры и функции общего назначения:
// - для работы со списками в формах;
// - для работы с журналом регистрации;
// - для обработки действий пользователя в процессе редактирования
//   многострочного текста, например комментария в документах;
// - прочее.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Функции работы со списками в формах.

// Проверяет, что в параметре команды Параметр передан объект ожидаемого типа ОжидаемыйТип.
// В противном случае, выдает стандартное сообщение и возвращает Ложь.
// Такая ситуация возможна, например, если в списке выделена строка группировки.
//
// Для использования в командах, работающих с элементами динамических списков в формах.
// Пример использования:
// 
//   Если НЕ ПроверитьТипПараметраКоманды(Элементы.Список.ВыделенныеСтроки, 
//      Тип("ЗадачаСсылка.ЗадачаИсполнителя")) Тогда
//      Возврат;
//   КонецЕсли;
//   ...
// 
// Параметры:
//  Параметр     - Массив или ссылочный тип - параметр команды.
//  ОжидаемыйТип - Тип                      - ожидаемый тип параметра.
//
// Возвращаемое значение:
//  Булево - Истина, если параметр ожидаемого типа.
//
Функция ПроверитьТипПараметраКоманды(Знач Параметр, Знач ОжидаемыйТип) Экспорт
	
	Если Параметр = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	
	Если ТипЗнч(Параметр) = Тип("Массив") Тогда
		// Если в массиве один элемент и он неправильного типа...
		Результат = НЕ (Параметр.Количество() = 1 И ТипЗнч(Параметр[0]) <> ОжидаемыйТип);
	Иначе
		Результат = ТипЗнч(Параметр) = ОжидаемыйТип;
	КонецЕсли;
	
	Если НЕ Результат Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Действие не может быть выполнено для выбранного элемента.'; en = 'Command cannot be executed for the current object.'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры общего назначения.

// Возвращает текущую дату, приведенную к часовому поясу сеанса.
//
// Функция возвращает время, близкое к результату функции ТекущаяДатаСеанса() в серверном контексте.
// Погрешность обусловлена временем выполнения серверного вызова.
// Предназначена для использования вместо функции ТекущаяДата().
//
Функция ДатаСеанса() Экспорт
	Возврат ТекущаяДата() + СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПоправкаКВремениСеанса;
КонецФункции

// Возвращает универсальную дату сеанса, получаемую из текущей даты сеанса.
//
// Функция возвращает время, близкое к результату функции УниверсальноеВремя() в серверном контексте.
// Погрешность обусловлена временем выполнения серверного вызова.
// Предназначена для использования вместо функции УниверсальноеВремя().
//
Функция ДатаУниверсальная() Экспорт
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	ДатаСеанса = ТекущаяДата() + ПараметрыРаботыКлиента.ПоправкаКВремениСеанса;
	Возврат ДатаСеанса + ПараметрыРаботыКлиента.ПоправкаКУниверсальномуВремени;
КонецФункции

// Предлагает пользователю установить расширение работы с файлами в веб-клиенте.
//
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
// Например:
//
//    Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//    ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение работы с файлами.'");
//    ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстСообщения);
//
//    Процедура ПечатьДокументаЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
//      Если РасширениеПодключено Тогда
//        // код печати документа, рассчитывающий на то, что расширение подключено.
//        // ...
//      Иначе
//        // код печати документа, который работает без подключенного расширения.
//        // ...
//      КонецЕсли;
//
// Параметры:
//   ОписаниеОповещенияОЗакрытии    - ОписаниеОповещения - описание процедуры,
//                                    которая будет вызвана после закрытия формы со следующими параметрами:
//                                      РасширениеПодключено    - Булево - Истина, если расширение было подключено.
//                                      ДополнительныеПараметры - Произвольный - параметры, заданные в
//                                                                               ОписаниеОповещенияОЗакрытии.
//   ТекстПредложения                - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//   ВозможноПродолжениеБезУстановки - Булево - если Истина, будет показана кнопка ПродолжитьБезУстановки,
//                                              если Ложь, будет показана кнопка Отмена.
//
Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещенияОЗакрытии, ТекстПредложения = "", 
	ВозможноПродолжениеБезУстановки = Истина) Экспорт
	
	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиЗавершение",
		ЭтотОбъект, ОписаниеОповещенияОЗакрытии);
	
#Если Не ВебКлиент Тогда
	// В тонком и толстом клиентах расширение подключено всегда.
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
	Возврат;
#КонецЕсли
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	ДополнительныеПараметры.Вставить("ТекстПредложения", ТекстПредложения);
	ДополнительныеПараметры.Вставить("ВозможноПродолжениеБезУстановки", ВозможноПродолжениеБезУстановки);
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиПриУстановкеРасширения",
		ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

// Предлагает пользователю подключить расширение работы с файлами в веб-клиенте,
// и в случае отказа выдает предупреждение о невозможности продолжения операции.
//
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами
// только при подключенном расширении.
// Например:
//
//    Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//    ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение работы с файлами.'");
//    ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(Оповещение, ТекстСообщения);
//
//    Процедура ПечатьДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
//        // код печати документа, рассчитывающий на то, что расширение подключено.
//        // ...
//
// Параметры:
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание процедуры, которая будет вызвана, если расширение
//                                                     подключено со следующими параметрами:
//                                                      Результат               - Булево - всегда Истина.
//                                                      ДополнительныеПараметры - Неопределено
//  ТекстПредложения    - Строка - текст с предложением подключить расширение работы с файлами. 
//                                 Если не указан, то выводится текст по умолчанию.
//  ТекстПредупреждения - Строка - текст предупреждения о невозможности продолжения операции. 
//                                 Если не указан, то выводится текст по умолчанию.
//
// Возвращаемое значение:
//  Булево - Истина, если расширение подключено.
//   
Процедура ПроверитьРасширениеРаботыСФайламиПодключено(ОписаниеОповещенияОЗакрытии, Знач ТекстПредложения = "", 
	Знач ТекстПредупреждения = "") Экспорт
	
	Параметры = Новый Структура("ОписаниеОповещенияОЗакрытии,ТекстПредупреждения", 
		ОписаниеОповещенияОЗакрытии, ТекстПредупреждения, );
	Оповещение = Новый ОписаниеОповещения("ПроверитьРасширениеРаботыСФайламиПодключеноЗавершение", ЭтотОбъект, Параметры);
	ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстПредложения);
	
КонецПроцедуры

// Возвращает пользовательскую настройку "Предлагать установку расширения работы с файлами".
//
// Возвращаемое значение:
//   Булево
//
Функция ПредлагатьУстановкуРасширенияРаботыСФайлами() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	Возврат ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Истина);
	
КонецФункции

// Сохраняет персональные настройки пользователя.
//
// Параметры:
//	Структура со свойствами:
//	 * НапоминатьОбУстановкеРасширенияРаботыСФайлами  - Булево - Признак необходимости
//                                                               напоминания об установке расширения.
//	 * ЗапрашиватьПодтверждениеПриЗавершенииПрограммы - Булево - Запрашивать подтверждение по завершении работы.
//
Процедура СохранитьПерсональныеНастройки(Настройки) Экспорт
	
	Если Настройки.Свойство("НапоминатьОбУстановкеРасширенияРаботыСФайлами") Тогда
		ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами"] = 
			Настройки.НапоминатьОбУстановкеРасширенияРаботыСФайлами;
	КонецЕсли;
	
	Если Настройки.Свойство("ЗапрашиватьПодтверждениеПриЗавершенииПрограммы") Тогда
		СтандартныеПодсистемыКлиент.УстановитьПараметрКлиента("ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
			Настройки.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы);
	КонецЕсли;
	
КонецПроцедуры

// Выполняет регистрацию компоненты "comcntr.dll" для текущей версии платформы.
// В случае успешной регистрации, предлагает пользователю перезапустить клиентский сеанс 
// для того чтобы регистрация вступила в силу.
//
// Вызывается перед клиентским кодом, который использует менеджер COM-соединений (V83.COMConnector)
// и инициируется интерактивными действиями пользователя. Например:
// 
// ЗарегистрироватьCOMСоединитель();
//   // далее идет код, использующий менеджер COM-соединений (V83.COMConnector).
//   // ...
//
Процедура ЗарегистрироватьCOMСоединитель(Знач ВыполнитьПерезагрузкуСеанса = Истина) Экспорт
	
#Если Не ВебКлиент Тогда
	
	Если КлиентПодключенЧерезВебСервер() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиентаПриЗапуске.ЭтоБазоваяВерсияКонфигурации
		Или ПараметрыРаботыКлиентаПриЗапуске.ЭтоУчебнаяПлатформа Тогда
		Возврат;
	КонецЕсли;
	
	ТекстКоманды = "regsvr32.exe /n /i:user /s comcntr.dll";
	
	КодВозврата = Неопределено;
	ЗапуститьПриложение(ТекстКоманды, КаталогПрограммы(), Истина, КодВозврата);
	
	Если КодВозврата = Неопределено Или КодВозврата > 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Ошибка при регистрации компоненты comcntr.'; en = 'Error registering comcntr component.'") + Символы.ПС
			+ НСтр("ru = 'Код ошибки regsvr32:'; en = 'Regsvr32 error code:'") + " " + КодВозврата;
			
		Если КодВозврата = 5 Тогда
			ТекстСообщения = ТекстСообщения + " " + НСтр("ru = 'Недостаточно прав доступа.'; en = 'Not enough permissions.'");
		КонецЕсли;
		
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			НСтр("ru = 'Регистрация компоненты comcntr'; en = 'Registering comcntr component'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), "Ошибка", ТекстСообщения);
		ЖурналРегистрацииВызовСервера.ЗаписатьСобытияВЖурналРегистрации(ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"]);
		ПоказатьПредупреждение(,ТекстСообщения + Символы.ПС + НСтр("ru = 'Подробности см. в Журнале регистрации.'; en = 'For details, see the event log.'"));
	ИначеЕсли ВыполнитьПерезагрузкуСеанса Тогда
		Оповещение = Новый ОписаниеОповещения("ЗарегистрироватьCOMСоединительЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Для завершения перерегистрации компоненты comcntr необходимо перезапустить программу.
			|Перезапустить сейчас?';
			|en = 'To complete the registration of the comcntr component you must restart the program. 
			|Restart now?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
#КонецЕсли
	
КонецПроцедуры

// Возвращает Истина, если клиентское приложение подключено к базе через веб-сервер.
//
Функция КлиентПодключенЧерезВебСервер() Экспорт
	
	Возврат СтрНайти(ВРег(СтрокаСоединенияИнформационнойБазы()), "WS=") = 1;
	
КонецФункции

// Задает вопрос о продолжении действия, которое приведет к потере изменений:
// "Данные были изменены. Сохранить изменения?" 
// Для использования в обработчиках события ПередЗакрытием модулей форм.
//
// Параметры:
//  ОповещениеСохранитьИЗакрыть  - ОписаниеОповещения - содержит имя процедуры, вызываемой при нажатии на кнопку OK.
//  Отказ                        - Булево - возвращаемый параметр, признак отказа от выполняемого действия.
//  ЗавершениеРаботы             - Булево - признак того, что форма закрывается в процессе завершения работы приложения.
//  ТекстПредупреждения          - Строка - текст предупреждения, выводимый пользователю. По умолчанию, выводится текст
//                                          "Данные были изменены. Сохранить изменения?"
//  ТекстПредупрежденияПриЗавершении - Строка - возвращаемый параметр с текстом предупреждения, выводимым пользователю 
//                                          при завершении приложения. Если параметр указан, то возвращается текст
//                                          "Данные были изменены. Все изменения будут потеряны.".
//
// Пример:
//
//  &НаКлиенте
//  Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
//    Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
//    ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, ЗавершениеРаботы, Отказ);
//  КонецПроцедуры
//  
//  &НаКлиенте
//  Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
//     // записываем данные формы.
//     // ...
//     Модифицированность = Ложь; // не выводить подтверждение о закрытии формы еще раз.
//     Закрыть(<РезультатВыбораВФорме>);
//  КонецПроцедуры
//
Процедура ПоказатьПодтверждениеЗакрытияФормы(Знач ОповещениеСохранитьИЗакрыть, Отказ, 
	Знач ЗавершениеРаботы, Знач ТекстПредупреждения = "", ТекстПредупрежденияПриЗавершении = Неопределено) Экспорт
	
	Форма = ОповещениеСохранитьИЗакрыть.Модуль;
	Если Не Форма.Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Если ЗавершениеРаботы Тогда
		Если ТекстПредупрежденияПриЗавершении = "" Тогда // передан параметр из ПередЗакрытием
			ТекстПредупрежденияПриЗавершении = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'; en = 'Data was changed. All changes will be lost.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура();
	Параметры.Вставить("ОповещениеСохранитьИЗакрыть", ОповещениеСохранитьИЗакрыть);
	Параметры.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"] = Параметры;
	
	ПодключитьОбработчикОжидания("ПодтвердитьЗакрытиеФормыСейчас", 0.1, Истина);
	
КонецПроцедуры

// Задает вопрос о продолжении действия, которое приведет к закрытию формы.
// Для использования в обработчиках события ПередЗакрытием модулей форм.
//
// Параметры:
//  Форма                        - УправляемаяФорма - форма, которая вызывает диалог предупреждения.
//  Отказ                        - Булево - возвращаемый параметр, признак отказа от выполняемого действия.
//  ТекстПредупреждения          - Строка - текст предупреждения, выводимый пользователю.
//  ИмяРеквизитаЗакрытьФормуБезПодтверждения - Строка - имя реквизита, содержащего в себе признак того, нужно
//                                 выводить предупреждение или нет.
//  ОписаниеОповещенияЗакрыть    - ОписаниеОповещения - содержит имя процедуры, вызываемой при нажатии на кнопку да.
//
// Пример: 
//  ТекстПредупреждения = НСтр("ru = 'Закрыть помощник?'");
//  ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
//      ЭтотОбъект, Отказ, ТекстПредупреждения, "ЗакрытьФормуБезПодтверждения");
//
Процедура ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(Знач Форма, Отказ, Знач ЗавершениеРаботы, 
	Знач ТекстПредупреждения, Знач ИмяРеквизитаЗакрытьФормуБезПодтверждения, Знач ОписаниеОповещенияЗакрыть = Неопределено) Экспорт
	
	Если Форма[ИмяРеквизитаЗакрытьФормуБезПодтверждения] Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Параметры = Новый Структура();
	Параметры.Вставить("Форма", Форма);
	Параметры.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	Параметры.Вставить("ИмяРеквизитаЗакрытьФормуБезПодтверждения", ИмяРеквизитаЗакрытьФормуБезПодтверждения);
	Параметры.Вставить("ОписаниеОповещенияЗакрыть", ОписаниеОповещенияЗакрыть);
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"] = Параметры;
	
	ПодключитьОбработчикОжидания("ПодтвердитьЗакрытиеПроизвольнойФормыСейчас", 0.1, Истина);
	
КонецПроцедуры

// Функция получает цвет стиля по имени элемента стиля.
//
// Параметры:
//	ИмяЦветаСтиля - строка с именем элемента.
//
// Возвращаемое значение - цвет стиля.
//
Функция ЦветСтиля(ИмяЦветаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля(ИмяЦветаСтиля);
	
КонецФункции

// Функция получает шрифт стиля по имени элемента стиля.
//
// Параметры:
//	ИмяШрифтаСтиля - строка с именем элемента.
//
// Возвращаемое значение - шрифт стиля.
//
Функция ШрифтСтиля(ИмяШрифтаСтиля) Экспорт
	
	Возврат ОбщегоНазначенияКлиентПовтИсп.ШрифтСтиля(ИмяШрифтаСтиля);
	
КонецФункции

// Выполняет переход по ссылке на объект информационной базы или внешний объект.
// (например, ссылка на сайт или путь к папке).
//
// Параметры:
//	Ссылка - Строка - ссылка для перехода.
//
Процедура ПерейтиПоСсылке(Ссылка) Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ЗапуститьПриложение(Ссылка);
	#Иначе
		ПерейтиПоНавигационнойСсылке(Ссылка);
	#КонецЕсли
	
КонецПроцедуры

// Обновляет интерфейс программы сохраняя текущее активное окно.
//
Процедура ОбновитьИнтерфейсПрограммы() Экспорт
	
	ТекущееАктивноеОкно = АктивноеОкно();
	ОбновитьИнтерфейс();
	Если ТекущееАктивноеОкно <> Неопределено Тогда
		ТекущееАктивноеОкно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для обработки событий и вызова необязательных подсистем.

// Возвращает Истина, если "функциональная" подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема
//                        без слов "Подсистема." и с учетом регистра символов.
//                        Например: "СтандартныеПодсистемы.ВариантыОтчетов".
//
// Пример:
//
//  Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
//  	МодульВариантыОтчетовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВариантыОтчетовКлиент");
//  	МодульВариантыОтчетовКлиент.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево.
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
	ИменаПодсистем = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ИменаПодсистем;
	Возврат ИменаПодсистем.Получить(ПолноеИмяПодсистемы) <> Неопределено;
	
КонецФункции

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль.
//
Функция ОбщийМодуль(Имя) Экспорт
	
	Модуль = Вычислить(Имя);
	
#Если НЕ ВебКлиент Тогда
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Общий модуль ""%1"" не найден.'; en = 'Common module ""%1"" not found.'"), Имя);
	КонецЕсли;
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для обработки действий пользователя в процессе редактирования
// многострочного текста, например комментария в документах.

// Открывает форму редактирования произвольного многострочного текста.
//
// Параметры:
//  ОповещениеОЗакрытии     - ОписаниеОповещения - содержит описание процедуры, которая будет вызвана 
//                            после закрытия формы ввода текста с теми же параметрами, что и для метода
//                            ПоказатьВводСтроки.
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать;
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//
// Пример:
//
//   Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект);
//   ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Элемент.ТекстРедактирования);
//
//   &НаКлиенте
//   Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
//      Если ВведенныйТекст = Неопределено Тогда
//		   Возврат;
//   	КонецЕсли;	
//	
//	   Объект.МногострочныйКомментарий = ВведенныйТекст;
//	   Модифицированность = Истина;
//   КонецПроцедуры
//
Процедура ПоказатьФормуРедактированияМногострочногоТекста(Знач ОповещениеОЗакрытии, 
	Знач МногострочныйТекст, Знач Заголовок = Неопределено) Экспорт
	
	Если Заголовок = Неопределено Тогда
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст,,, Истина);
	Иначе
		ПоказатьВводСтроки(ОповещениеОЗакрытии, МногострочныйТекст, Заголовок,, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму редактирования многострочного комментария.
//
// Параметры:
//  МногострочныйТекст      - Строка - произвольный текст, который необходимо отредактировать.
//  ФормаВладелец 			- УправляемаяФорма - форма, в поле которой выполняется ввод комментария.
//  ИмяРеквизита            - Строка - имя реквизита формы, в который будет помещен введенный пользователем
//                                     комментарий.
//  Заголовок               - Строка - текст, который необходимо отобразить в заголовке формы.
//                                     По умолчанию: "Комментарий".
//
// Пример использования:
//
//	 ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
//
Процедура ПоказатьФормуРедактированияКомментария(Знач МногострочныйТекст, Знач ФормаВладелец, Знач ИмяРеквизита, 
	Знач Заголовок = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ФормаВладелец,ИмяРеквизита", ФормаВладелец, ИмяРеквизита);
	Оповещение = Новый ОписаниеОповещения("КомментарийЗавершениеВвода", ЭтотОбъект, ДополнительныеПараметры);
	ЗаголовокФормы = ?(Заголовок <> Неопределено, Заголовок, НСтр("ru='Комментарий'; en = 'Comment'"));
	ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, МногострочныйТекст, ЗаголовокФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для выполнения резервного копирования в пользовательском режиме.

// Проверяет, возможно ли выполнить резервное копирование в пользовательском режиме.
//
// Возвращаемое значение: Булево.
//
Функция ПредлагатьСоздаватьРезервныеКопии() Экспорт
	
	Результат = Ложь;
	
	ОбработчикиСобытия = ОбработчикиСлужебногоСобытия("СтандартныеПодсистемы.БазоваяФункциональность\ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме");
	
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Предлагает пользователю создать резервную копию.
//
Процедура ПредложитьПользователюСоздатьРезервнуюКопию() Экспорт
	
	ОбработчикиСобытия = ОбработчикиСлужебногоСобытия("СтандартныеПодсистемы.БазоваяФункциональность\ПриПредложенииПользователюСоздатьРезервнуюКопию");
	
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		
		Обработчик.Модуль.ПриПредложенииПользователюСоздатьРезервнуюКопию();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Получение обработчиков клиентских событий.

// Возвращает обработчики указанного клиентского служебного события.
//
// Параметры:
//  Событие  - Строка, например,
//             "СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииФормыАктивныхПользователей".
//
// Возвращаемое значение:
//  ФиксированныйМассив со значениями типа.
//    ФиксированнаяСтруктура со свойствами:
//     * Версия - Строка      - версия обработчика, например, "2.1.3.4". Пустая строка, если не указана.
//     * Модуль - ОбщийМодуль - серверный общий модуль.
// 
Функция ОбработчикиСлужебногоСобытия(Событие) Экспорт
	
	Возврат СтандартныеПодсистемыКлиентПовтИсп.ОбработчикиКлиентскогоСобытия(Событие, Истина);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиПриУстановкеРасширения(Подключено, ДополнительныеПараметры) Экспорт
	
	// Если расширение и так уже подключено, незачем про него спрашивать.
	Если Подключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
		Возврат;
	КонецЕсли;
	
	// В веб клиенте под MacOS расширение не доступно.
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоMacКлиент = (СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86
		Или СистемнаяИнформация.ТипПлатформы = ТипПлатформы.MacOS_x86_64);
	Если ЭтоMacКлиент Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
		Возврат;
	КонецЕсли;
	
	// В веб клиенте в Chrome расширение не доступно.
	Если Не ФайловыеФункцииКлиентПовтИсп.КлиентПоддерживаетСинхронныеВызовы() Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
		Возврат;
	КонецЕсли;	
	
	ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами";
	ПервоеОбращениеЗаСеанс = ПараметрыПриложения[ИмяПараметра] = Неопределено;
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, ПредлагатьУстановкуРасширенияРаботыСФайлами());
	КонецЕсли;
	ПредлагатьУстановкуРасширенияРаботыСФайлами	= ПараметрыПриложения[ИмяПараметра] Или ПервоеОбращениеЗаСеанс;
	
	Если ДополнительныеПараметры.ВозможноПродолжениеБезУстановки И Не ПредлагатьУстановкуРасширенияРаботыСФайлами Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекстПредложения", ДополнительныеПараметры.ТекстПредложения);
	ПараметрыФормы.Вставить("ВозможноПродолжениеБезУстановки", ДополнительныеПараметры.ВозможноПродолжениеБезУстановки);
	ОткрытьФорму("ОбщаяФорма.ВопросОбУстановкеРасширенияРаботыСФайлами", ПараметрыФормы,,,,,ДополнительныеПараметры.ОписаниеОповещенияЗавершение);
	
КонецПроцедуры

Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиЗавершение(Действие, ОповещениеОЗакрытии) Экспорт
	
	РасширениеПодключено = (Действие = "РасширениеПодключено" Или Действие = "ПодключениеНеТребуется");
#Если ВебКлиент Тогда
	Если Действие = "БольшеНеПредлагать"
		Или Действие = "РасширениеПодключено" Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация();
		ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
		ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьУстановкуРасширенияРаботыСФайлами"] = Ложь;
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
			"НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Ложь);
	КонецЕсли;
#КонецЕсли
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, РасширениеПодключено);
	
КонецПроцедуры

Процедура ПроверитьРасширениеРаботыСФайламиПодключеноЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗакрытии);
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = ДополнительныеПараметры.ТекстПредупреждения;
	Если ПустаяСтрока(ТекстСообщения) Тогда
		ТекстСообщения = НСтр("ru = 'Действие недоступно, так как не установлено расширение для веб-клиента 1С:Предприятие.'; en = 'The action cannot be performed because the 1C:Enterprise web client extension is not installed.'")
	КонецЕсли;
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

Процедура КомментарийЗавершениеВвода(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	РеквизитФормы = ДополнительныеПараметры.ФормаВладелец;
	
	ПутьКРеквизитуФормы = СтрРазделить(ДополнительныеПараметры.ИмяРеквизита, ".");
	// Если реквизит вида "Объект.Комментарий" и т.п.
	Если ПутьКРеквизитуФормы.Количество() > 1 Тогда
		Для Индекс = 0 По ПутьКРеквизитуФормы.Количество() - 2 Цикл 
			РеквизитФормы = РеквизитФормы[ПутьКРеквизитуФормы[Индекс]];
		КонецЦикла;
	КонецЕсли;	
	
	РеквизитФормы[ПутьКРеквизитуФормы[ПутьКРеквизитуФормы.Количество() - 1]] = ВведенныйТекст;
	ДополнительныеПараметры.ФормаВладелец.Модифицированность = Истина;
	
КонецПроцедуры

Процедура ЗарегистрироватьCOMСоединительЗавершение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
		ЗавершитьРаботуСистемы(Истина, Истина);
	КонецЕсли;

КонецПроцедуры

Процедура ПодтвердитьЗакрытиеФормы() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	
	Параметры = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"];
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"] = Неопределено;
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьЗакрытиеФормыЗавершение", ЭтотОбъект, Параметры);
	Если ПустаяСтрока(Параметры.ТекстПредупреждения) Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'; en = 'Data has been changed. Save changes?'");
	Иначе
		ТекстВопроса = Параметры.ТекстПредупреждения;
	КонецЕсли;
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, ,
		КодВозвратаДиалога.Нет);
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеФормыЗавершение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеСохранитьИЗакрыть);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Форма = Параметры.ОповещениеСохранитьИЗакрыть.Модуль;
		Форма.Модифицированность = Ложь;
		Форма.Закрыть();
	Иначе
		Форма = Параметры.ОповещениеСохранитьИЗакрыть.Модуль;
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеПроизвольнойФормы() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	
	Параметры = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"];
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"] = Неопределено;
	РежимВопроса = РежимДиалогаВопрос.ДаНет;
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьЗакрытиеПроизвольнойФормыЗавершение", ЭтотОбъект, Параметры);
	
	ПоказатьВопрос(Оповещение, Параметры.ТекстПредупреждения, РежимВопроса);
	
КонецПроцедуры

Процедура ПодтвердитьЗакрытиеПроизвольнойФормыЗавершение(Ответ, Параметры) Экспорт
	
	Форма = Параметры.Форма;
	Если Ответ = КодВозвратаДиалога.Да
		Или Ответ = КодВозвратаДиалога.ОК Тогда
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Истина;
		Если Параметры.ОписаниеОповещенияЗакрыть <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещенияЗакрыть);
		КонецЕсли;
		Форма.Закрыть();
	Иначе
		Форма[Параметры.ИмяРеквизитаЗакрытьФормуБезПодтверждения] = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
