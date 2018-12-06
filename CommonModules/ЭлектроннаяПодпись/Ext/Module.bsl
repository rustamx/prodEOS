﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текущую настройку использования электронных подписей.
Функция ИспользоватьЭлектронныеПодписи() Экспорт
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ИспользоватьЭлектронныеПодписи;
	
КонецФункции

// Возвращает текущую настройку использования шифрования.
Функция ИспользоватьШифрование() Экспорт
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ИспользоватьШифрование;
	
КонецФункции

// Возвращает текущую настройку проверки электронных подписей на сервере.
Функция ПроверятьЭлектронныеПодписиНаСервере() Экспорт
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ПроверятьЭлектронныеПодписиНаСервере;
	
КонецФункции

// Возвращает текущую настройку создания электронных подписей на сервере.
// Настройка также предполагает шифрование и расшифровку на сервере.
//
Функция СоздаватьЭлектронныеПодписиНаСервере() Экспорт
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().СоздаватьЭлектронныеПодписиНаСервере;
	
КонецФункции

// Возвращает менеджер криптографии (на сервере) для указанной программы.
//
// Параметры:
//  Операция       - Строка - если не пустая, то должна содержать одну из строк, которые определяют
//                   операцию для вставки в описание ошибки: Подписание, ПроверкаПодписи, Шифрование,
//                   Расшифровка, ПроверкаСертификата, ПолучениеСертификатов.
//
//  ПоказатьОшибку - Булево - если Истина, тогда будет вызвано исключение, содержащее описание ошибки.
//
//  ОписаниеОшибки - Строка - возвращаемое описание ошибки, когда функция возвратила значение Неопределено.
//
//  Программа      - Неопределено - возвращает менеджер криптографии первой
//                   программы из справочника для которой удалось его создать.
//                 - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования - программа
//                   для которой нужно создать и вернуть менеджер криптографии.
//
// Возвращаемое значение:
//   МенеджерКриптографии - менеджер криптографии.
//   Неопределено - произошла ошибка, описание которой в параметре ОписаниеОшибки.
//
Функция МенеджерКриптографии(Операция, ПоказатьОшибку = Истина, ОписаниеОшибки = "", Программа = Неопределено) Экспорт
	
	Ошибка = "";
	Результат = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии(Операция, ПоказатьОшибку, Ошибка, Программа);
	
	Если Результат = Неопределено Тогда
		ОписаниеОшибки = Ошибка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет действительность подписи и сертификата.
//
// Параметры:
//   МенеджерКриптографии - Неопределено - получить менеджер криптографии для проверки
//                          электронных подписей, как настроил администратор.
//                        - МенеджерКриптографии - использовать указанный менеджер криптографии.
//
//   ИсходныеДанные       - ДвоичныеДанные - двоичные данные, которые были подписаны.
//                        - Строка         - адрес временного хранилища, содержащего двоичные данные.
//                        - Строка         - полное имя файла, содержащего двоичные данные,
//                                           которые были подписаны.
//
//   Подпись              - ДвоичныеДанные - двоичные данные электронной подписи.
//                        - Строка         - адрес временного хранилища, содержащего двоичные данные.
//                        - Строка         - полное имя файла, содержащего двоичные данные
//                                           электронной подписи.
//
//   ОписаниеОшибки       - Null - вызвать исключение при ошибке проверки.
//                        - Строка - содержит описание ошибки, если произошла ошибка.
// 
//   НаДату               - Дата - проверить сертификат на указанную дату,
//                          если дату не удалось извлечь из подписи.
//                          Если параметр не заполнен, тогда проверять на текущую дату сеанса,
//                          если дату не удалось извлечь из подписи.
//
// Возвращаемое значение:
//  Булево - Истина, если проверка выполнена успешно.
//         - Ложь,   если не удалось получить менеджер криптографии (когда не указан),
//                   или произошла ошибка указанная в параметре ОписаниеОшибки.
//
Функция ПроверитьПодпись(МенеджерКриптографии, ИсходныеДанные, Подпись, ОписаниеОшибки = Null, НаДату = Неопределено) Экспорт
	
	МенеджерКриптографииДляПроверки = МенеджерКриптографии;
	Если МенеджерКриптографииДляПроверки = Неопределено Тогда
		МенеджерКриптографииДляПроверки = МенеджерКриптографии("ПроверкаПодписи", ОписаниеОшибки = Null, ОписаниеОшибки);
		Если МенеджерКриптографииДляПроверки = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ИсходныеДанныеДляПроверки = ИсходныеДанные;
	Если ТипЗнч(ИсходныеДанные) = Тип("Строка") И ЭтоАдресВременногоХранилища(ИсходныеДанные) Тогда
		ИсходныеДанныеДляПроверки = ПолучитьИзВременногоХранилища(ИсходныеДанные);
	КонецЕсли;
	
	ПодписьДляПроверки = Подпись;
	Если ТипЗнч(Подпись) = Тип("Строка") И ЭтоАдресВременногоХранилища(Подпись) Тогда
		ПодписьДляПроверки = ПолучитьИзВременногоХранилища(Подпись);
	КонецЕсли;
	
	Сертификат = Неопределено;
	Попытка
		МенеджерКриптографииДляПроверки.ПроверитьПодпись(ИсходныеДанныеДляПроверки, ПодписьДляПроверки, Сертификат);
	Исключение
		Если ОписаниеОшибки = Null Тогда
			ВызватьИсключение;
		КонецЕсли;
		ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	ДатаПодписания = ДатаПодписания(ПодписьДляПроверки);
	Если Не ЗначениеЗаполнено(ДатаПодписания) Тогда
		ДатаПодписания = НаДату;
	КонецЕсли;
	
	Возврат ПроверитьСертификат(МенеджерКриптографииДляПроверки, Сертификат, ОписаниеОшибки, ДатаПодписания);
	
КонецФункции

// Проверяет действительность сертификата криптографии.
//
// Параметры:
//   МенеджерКриптографии - Неопределено - получить менеджер криптографии автоматически.
//                        - МенеджерКриптографии - использовать указанный менеджер криптографии.
//
//   Сертификат           - СертификатКриптографии - сертификат.
//                        - ДвоичныеДанные - двоичные данные сертификата.
//                        - Строка - адрес временного хранилища, содержащего двоичные данные сертификата.
//
//   ОписаниеОшибки       - Null - вызвать исключение при ошибке проверки.
//                        - Строка - содержит описание ошибки, если произошла ошибка.
//
//   НаДату               - Дата - проверить сертификат на указанную дату.
//                          Если параметр не указан или указана пустая дата,
//                          тогда проверять на текущую дату сеанса.
//
// Возвращаемое значение:
//  Булево - Истина, если проверка выполнена успешно,
//         - Ложь, если не удалось получить менеджер криптографии (когда не указан).
//
Функция ПроверитьСертификат(МенеджерКриптографии, Сертификат, ОписаниеОшибки = Null, НаДату = Неопределено) Экспорт
	
	МенеджерКриптографииДляПроверки = МенеджерКриптографии;
	
	Если МенеджерКриптографииДляПроверки = Неопределено Тогда
		МенеджерКриптографииДляПроверки = МенеджерКриптографии("ПроверкаСертификата", ОписаниеОшибки = Null, ОписаниеОшибки);
		Если МенеджерКриптографииДляПроверки = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	СертификатДляПроверки = Сертификат;
	
	Если ТипЗнч(Сертификат) = Тип("Строка") Тогда
		СертификатДляПроверки = ПолучитьИзВременногоХранилища(Сертификат);
	КонецЕсли;
	
	Если ТипЗнч(СертификатДляПроверки) = Тип("ДвоичныеДанные") Тогда
		СертификатДляПроверки = Новый СертификатКриптографии(СертификатДляПроверки);
	КонецЕсли;
	
	РежимыПроверкиСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.РежимыПроверкиСертификата(
		ЗначениеЗаполнено(НаДату));
	
	Попытка
		МенеджерКриптографииДляПроверки.ПроверитьСертификат(СертификатДляПроверки, РежимыПроверкиСертификата);
	Исключение
		ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	ОшибкаПросрочки = ЭлектроннаяПодписьСлужебныйКлиентСервер.СертификатПросрочен(СертификатДляПроверки, НаДату);
	Если ЗначениеЗаполнено(ОшибкаПросрочки) Тогда
		ОписаниеОшибки = ОшибкаПросрочки;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Находит сертификат на компьютере по строке отпечатка.
//
// Параметры:
//   Отпечаток              - Строка - Base64 кодированный отпечаток сертификата.
//   ТолькоВЛичномХранилище - Булево - если Истина, тогда искать в личном хранилище, иначе везде.
//
// Возвращаемое значение:
//   СертификатКриптографии - сертификат электронной подписи и шифрования.
//   Неопределено - сертификат не найден в хранилище.
//
Функция ПолучитьСертификатПоОтпечатку(Отпечаток, ТолькоВЛичномХранилище) Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(Отпечаток, ТолькоВЛичномХранилище);
	
КонецФункции

// Добавляет подпись в табличную часть объекта и записывает его.
// Устанавливает реквизиту ПодписанЭП значение Истина.
// 
// Параметры:
//  Объект - Ссылка - по ссылке будет получен объект, заблокирован, изменен, записан.
//                    Объект должен иметь табличную часть ЭлектронныеПодписи и реквизит ПодписанЭП.
//         - Объект - объект будет изменен без блокировки и без записи.
//
//  СвойстваПодписи - Массив - массив описанных ниже структур или адресов структур.
//                  - Строка - адрес временного хранилища, содержащий описанную ниже структуру.
//                  - Структура - развернутое описание подписи:
//     * Подпись             - ДвоичныеДанные - результат подписания.
//     * УстановившийПодпись - СправочникСсылка.Пользователи - пользователь, который
//                                подписал объект информационной базы.
//     * Комментарий         - Строка - комментарий, если он был введен при подписании.
//     * ИмяФайлаПодписи     - Строка - если подпись добавлена из файла.
//     * ДатаПодписи         - Дата   - дата, когда подпись была сделана. Имеет смысл для случая,
//                                      когда дату невозможно извлечь из данных подписи. Если не
//                                      указана или пустая, тогда используется текущая дата сеанса.
//     * ДатаПроверкиПодписи - Дата   - дата последней проверки подписи.
//     * ПодписьВерна        - Булево - результат последней проверки подписи.
//
//     Производные свойства:
//     * Сертификат          - ДвоичныеДанные - содержит выгрузку сертификата,
//                                который использовался для подписания (содержится в подписи).
//     * Отпечаток           - Строка - отпечаток сертификата в формате строки Base64.
//     * КомуВыданСертификат - Строка - представление субъекта, полученное из двоичных данных сертификата.
//
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы, используемый для блокировки,
//                       если передана ссылка на объект.
//
//  ВерсияОбъекта      - Строка - версия данных объекта, если передана ссылка на объект. Используемая
//                       для блокировки объекта перед записью, с учетом того, что подписание
//                       выполняется на клиенте и за время подписания объект мог быть изменен.
//
//  ЗаписанныйОбъект   - Объект - объект, который был получен и записан, если передавалась ссылка.
//
Процедура ДобавитьПодпись(Объект, Знач СвойстваПодписи, ИдентификаторФормы = Неопределено,
			ВерсияОбъекта = Неопределено, ЗаписанныйОбъект = Неопределено) Экспорт
	
	Если ТипЗнч(СвойстваПодписи) = Тип("Строка") Тогда
		СвойстваПодписи = ПолучитьИзВременногоХранилища(СвойстваПодписи);
		
	ИначеЕсли ТипЗнч(СвойстваПодписи) = Тип("Массив") Тогда
		ИндексПоследнего = СвойстваПодписи.Количество()-1;
		Для Индекс = 0 По ИндексПоследнего Цикл
			Если ТипЗнч(СвойстваПодписи[Индекс]) = Тип("Строка") Тогда
				СвойстваПодписи[Индекс] = ПолучитьИзВременногоХранилища(СвойстваПодписи[Индекс]);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			ЗаблокироватьДанныеДляРедактирования(Объект, ВерсияОбъекта, ИдентификаторФормы);
			ОбъектДанных = Объект.ПолучитьОбъект();
		Иначе
			ОбъектДанных = Объект;
		КонецЕсли;
		
		Если ТипЗнч(СвойстваПодписи) = Тип("Массив") Тогда
			Для каждого ТекущиеСвойства Из СвойстваПодписи Цикл
				ДобавитьСтрокуПодписи(ОбъектДанных, ТекущиеСвойства);
			КонецЦикла;
		Иначе
			ДобавитьСтрокуПодписи(ОбъектДанных, СвойстваПодписи);
		КонецЕсли;
		
		ОбъектДанных.ПодписанЭП = Истина;
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			// Чтобы определить, что это запись с целью добавления/удаления подписи.
			ОбъектДанных.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
			ОбъектДанных.Записать();
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, ИдентификаторФормы);
			ЗаписанныйОбъект = ОбъектДанных;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Помещает сертификаты шифрования в табличную часть объекта и записывает его.
// Устанавливает реквизит Зашифрован по наличию строк в табличной части.
// 
// Параметры:
//  Объект - Ссылка - по ссылке будет получен объект, заблокирован, изменен, записан.
//                    Объект должен иметь табличную часть СертификатыШифрования и реквизит Зашифрован.
//         - Объект - объект будет изменен без блокировки и без записи.
//
//  СертификатыШифрования - Строка - адрес временного хранилища, содержащий описанный ниже массив.
//                        - Массив - массив описанных ниже структур:
//                             * Отпечаток     - Строка - отпечаток сертификата в формате строки Base64.
//                             * Представление - Строка - сохраненное представление субъекта,
//                                                  полученное из двоичных данных сертификата.
//                             * Сертификат    - ДвоичныеДанные - содержит выгрузку сертификата,
//                                                  который использовался для шифрования.
//
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы, используемый для блокировки,
//                       если передана ссылка на объект.
//
//  ВерсияОбъекта      - Строка - версия данных объекта, если передана ссылка на объект. Используемая
//                       для блокировки объекта перед записью, с учетом того, что подписание
//                       выполняется на клиенте и за время подписания объект мог быть изменен.
//
//  ЗаписанныйОбъект   - Объект - объект, который был получен и записан, если передавалась ссылка.
//
Процедура ЗаписатьСертификатыШифрования(Объект, Знач СертификатыШифрования, ИдентификаторФормы = Неопределено,
			ВерсияОбъекта = Неопределено, ЗаписанныйОбъект = Неопределено) Экспорт
	
	Если ТипЗнч(СертификатыШифрования) = Тип("Строка") Тогда
		СертификатыШифрования = ПолучитьИзВременногоХранилища(СертификатыШифрования);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			ЗаблокироватьДанныеДляРедактирования(Объект, ВерсияОбъекта, ИдентификаторФормы);
			ОбъектДанных = Объект.ПолучитьОбъект();
		Иначе
			ОбъектДанных = Объект;
		КонецЕсли;
		
		ОбъектДанных.СертификатыШифрования.Очистить();
		
		Для каждого СертификатШифрования Из СертификатыШифрования Цикл
			ЗаполнитьЗначенияСвойств(ОбъектДанных.СертификатыШифрования.Добавить(), СертификатШифрования);
		КонецЦикла;
		
		ОбъектДанных.Зашифрован = ОбъектДанных.СертификатыШифрования.Количество() > 0;
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			// Чтобы определить, что это запись с целью шифрования/расшифровки.
			ОбъектДанных.ДополнительныеСвойства.Вставить("ЗаписьПриШифрованииРасшифровкеОбъекта", Истина);
			ОбъектДанных.Записать();
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, ИдентификаторФормы);
			ЗаписанныйОбъект = ОбъектДанных;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Удалят подпись из табличной части объекта и записывает его.
// 
// Параметры:
//  Объект - Ссылка - по ссылке будет получен объект, заблокирован, изменен, записан.
//                    Объект должен иметь табличную часть ЭлектронныеПодписи и реквизит ПодписанЭП.
//         - Объект - объект будет изменен без блокировки и без записи.
// 
//  ИдентификаторПодписи - Число - индекс строки табличной части.
//                       - Массив - значения указанного выше типа.
//
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы, используемый для блокировки,
//                       если передана ссылка на объект.
//
//  ВерсияОбъекта      - Строка - версия данных объекта, если передана ссылка на объект. Используемая
//                       для блокировки объекта перед записью, с учетом того, что подписание
//                       выполняется на клиенте и за время подписания объект мог быть изменен.
//
//  ЗаписанныйОбъект   - Объект - объект, который был получен и записан, если передавалась ссылка.
//
Процедура УдалитьПодпись(Объект, ИдентификаторПодписи, ИдентификаторФормы = Неопределено,
			ВерсияОбъекта = Неопределено, ЗаписанныйОбъект = Неопределено) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			ЗаблокироватьДанныеДляРедактирования(Объект, ВерсияОбъекта, ИдентификаторФормы);
			ОбъектДанных = Объект.ПолучитьОбъект();
		Иначе
			ОбъектДанных = Объект;
		КонецЕсли;
		
		Если ТипЗнч(ИдентификаторПодписи) = Тип("Массив") Тогда
			Список = Новый СписокЗначений;
			Список.ЗагрузитьЗначения(ИдентификаторПодписи);
			Список.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
			Для каждого ЭлементСписка Из Список Цикл
				УдалитьСтрокуПодписи(ОбъектДанных, ЭлементСписка.Значение);
			КонецЦикла;
		Иначе
			УдалитьСтрокуПодписи(ОбъектДанных, ИдентификаторПодписи);
		КонецЕсли;
		
		ОбъектДанных.ПодписанЭП = РаботаСЭП.КоличествоПодписей(Объект) <> 0;
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			// Чтобы определить, что это запись с целью добавления/удаления подписи.
			ОбъектДанных.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
			ОбъектДанных.Записать();
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, ИдентификаторФормы);
			ЗаписанныйОбъект = ОбъектДанных;
		КонецЕсли;
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			ОбъектПротокола = Объект;
			Если ТипЗнч(Объект) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
				ОбъектПротокола = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект, "Владелец");
			КонецЕсли;	
			ПротоколированиеРаботыПользователей.ЗаписатьУдалениеПодписиЭП(ОбъектПротокола);
		КонецЕсли;	
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Возвращает дату, извлеченную из двоичных данных подписи или Неопределено.
//
// Параметры:
//  Подпись - ДвоичныеДанные - данные подписи из которых нужно извлечь дату.
//  ПривестиКЧасовомуПоясуСеанса - Булево - привести универсальное время к времени сеанса.
//
// Возвращаемое значение:
//  Дата - успешно извлеченная дата подписи.
//  Неопределено - не удалось извлечь дату из данных подписи.
//
Функция ДатаПодписания(Подпись, ПривестиКЧасовомуПоясуСеанса = Истина) Экспорт
	
	ДатаПодписания = ЭлектроннаяПодписьСлужебныйКлиентСервер.ДатаПодписанияУниверсальная(Подпись);
	
	Если ДатаПодписания = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ПривестиКЧасовомуПоясуСеанса Тогда
		ДатаПодписания = МестноеВремя(ДатаПодписания, ЧасовойПоясСеанса());
	КонецЕсли;
	
	Возврат ДатаПодписания;
	
КонецФункции

// Позволяет заполнить справочник ПрограммыЭлектроннойПодписиИШифрования, например, при обновлении ИБ.
// Дополняет стандартный список из двух программ: ViPNet и КриптоПро.
// Если программа с указанными именем и типом уже существует, то ее свойства перезаполняются
// указанными. При заполнении не проверяется корректность указанных свойств.
//
// При заполнении можно использовать поставляемые описания программ,
// список которых находится в процедуре ПоставляемыеНастройкиПрограмм
// модуля менеджера справочника ПрограммыЭлектроннойПодписиИШифрования.
//
// Параметры:
//  ОписаниеПрограмм - Массив - содержит значения типа Структура со свойствами:
//   * ИмяПрограммы  - Строка - уникальное имя программы, присвоенное ее разработчиком,
//                       например, "Signal-COM CPGOST Cryptographic Provider".
//   * ТипПрограммы  - Число - специальное число, которое описывает тип программы и
//                       дополняет имя программы, например, 75.
//
//   Следующие параметры требуются, если указано Имя и Тип программы,
//   описание которой не поставляется, либо требуется обновить отдельные свойства.
//
//   * Представление       - Строка - наименование программы, которое увидит пользователь,
//                             например, "Сигнал-КОМ CSP (RFC 4357)".
//   * АлгоритмПодписи     - Строка - имя алгоритма подписи, который поддерживает
//                             указанная программа, например, "ECR3410-CP".
//   * АлгоритмХеширования - Строка - имя алгоритма хеширования данных, который поддерживает
//                             указанная программа, например, "RUS-HASH-CP". Используется для подготовки
//                             данных при формировании подписи с помощью алгоритма подписания.
//   * АлгоритмШифрования  - Строка - имя алгоритма шифрования, который поддерживает
//                             указанная программа, например, "GOST28147".
//
// Пример:
//	ОписаниеПрограмм = Новый Массив;
//	
//	// Заполнение дополнительной программы "Сигнал-КОМ CSP (RFC 4357)".
//	ОписаниеПрограммы = ЭлектроннаяПодпись.НовоеОписаниеПрограммы();
//	ОписаниеПрограммы.ИмяПрограммы = "Signal-COM CPGOST Cryptographic Provider";
//	ОписаниеПрограммы.ТипПрограммы = 75;
//	ОписаниеПрограмм.Добавить(ОписаниеПрограммы);
//	
//	// Изменение алгоритма поставляемой программы ViPNet CSP.
//	ОписаниеПрограммы = ЭлектроннаяПодпись.НовоеОписаниеПрограммы();
//	ОписаниеПрограммы.ИмяПрограммы = "Infotecs Cryptographic Service Provider";
//	ОписаниеПрограммы.ТипПрограммы = 2;
//	ОписаниеПрограммы.АлгоритмПодписи = "GOST 34.10-2012 512";
//	ОписаниеПрограмм.Добавить(ОписаниеПрограммы);
//	
//	ЭлектроннаяПодпись.ЗаполнитьСписокПрограмм(ОписаниеПрограмм);
//
Процедура ЗаполнитьСписокПрограмм(ОписаниеПрограмм) Экспорт
	
	ПоставляемыеНастройки = Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПоставляемыеНастройкиПрограмм();
	ВыполняетсяОбновлениеИнформационнойБазы = ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Программы.Ссылка КАК Ссылка,
	|	Программы.ИмяПрограммы,
	|	Программы.ТипПрограммы
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК Программы";
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ПрограммыЭлектроннойПодписиИШифрования");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Выгрузка = Запрос.Выполнить().Выгрузить();
		
		Для Каждого ОписаниеПрограммы Из ОписаниеПрограмм Цикл
			Отбор = Новый Структура;
			Отбор.Вставить("ИмяПрограммы", ОписаниеПрограммы.ИмяПрограммы);
			Отбор.Вставить("ТипПрограммы", ОписаниеПрограммы.ТипПрограммы);
			
			Строки = Выгрузка.НайтиСтроки(Отбор);
			Если Строки.Количество() > 0 Тогда
				ПрограммаОбъект = Строки[0].Ссылка.ПолучитьОбъект();
			Иначе
				ПрограммаОбъект = Справочники.ПрограммыЭлектроннойПодписиИШифрования.СоздатьЭлемент();
			КонецЕсли;
			ОбновитьЗначение(ПрограммаОбъект.ПометкаУдаления, Ложь);
			
			Строки = ПоставляемыеНастройки.НайтиСтроки(Отбор);
			Для Каждого КлючИЗначение Из ОписаниеПрограммы Цикл
				ИмяПоля = ?(КлючИЗначение.Ключ = "Представление", "Наименование", КлючИЗначение.Ключ);
				Если КлючИЗначение.Значение <> Неопределено Тогда
					ОбновитьЗначение(ПрограммаОбъект[ИмяПоля], КлючИЗначение.Значение, Истина);
				ИначеЕсли Строки.Количество() > 0 Тогда
					ОбновитьЗначение(ПрограммаОбъект[ИмяПоля], Строки[0][КлючИЗначение.Ключ], Истина);
				КонецЕсли;
			КонецЦикла;
			
			Если Не ПрограммаОбъект.Модифицированность() Тогда
				Продолжить;
			КонецЕсли;
			
			Если ВыполняетсяОбновлениеИнформационнойБазы Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПрограммаОбъект);
			Иначе
				ПрограммаОбъект.Записать();
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Для использования в процедуре ЗаполнитьСписокПрограмм (см. выше).
//
// Параметры:
//  ИмяПрограммы - Строка - можно указать имя программы сразу при создании описания.
//  ТипПрограммы - Строка - можно указать тип программы сразу при создании описания.
//
// Возвращаемое значение:
//  Структура со свойствами для использования в процедуре ЗаполнитьСписокПрограмм.
//
Функция НовоеОписаниеПрограммы(ИмяПрограммы = Неопределено, ТипПрограммы = Неопределено) Экспорт
	
	ОписаниеПрограммы = Новый Структура;
	ОписаниеПрограммы.Вставить("ИмяПрограммы", ИмяПрограммы);
	ОписаниеПрограммы.Вставить("ТипПрограммы", ТипПрограммы);
	ОписаниеПрограммы.Вставить("Представление");
	ОписаниеПрограммы.Вставить("АлгоритмПодписи");
	ОписаниеПрограммы.Вставить("АлгоритмХеширования");
	ОписаниеПрограммы.Вставить("АлгоритмШифрования");
	
	Возврат ОписаниеПрограммы;
	
КонецФункции

// Выполняет поиск сертификата в справочнике, возвращает ссылку, если сертификат найден.
//
// Параметры:
//  Сертификат - СертификатКриптографии - сертификат.
//             - ДвоичныеДанные - двоичные данные сертификата.
//             - Строка (28) - отпечаток сертификата в формате Base64.
//             - Строка      - адрес временного хранилища, содержащего двоичные данные сертификата.
//
// Возвращаемое значение:
//  Неопределено - сертификат не найден в справочнике.
//  СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на найденный сертификат.
//
Функция СсылкаНаСертификат(Знач Сертификат) Экспорт
	
	Если ТипЗнч(Сертификат) = Тип("Строка") И ЭтоАдресВременногоХранилища(Сертификат) Тогда
		Сертификат = ПолучитьИзВременногоХранилища(Сертификат);
	КонецЕсли;
	
	Если ТипЗнч(Сертификат) = Тип("ДвоичныеДанные") Тогда
		Сертификат = Новый СертификатКриптографии(Сертификат);
	КонецЕсли;
	
	Если ТипЗнч(Сертификат) = Тип("СертификатКриптографии") Тогда
		ОтпечатокСтрокой = Base64Строка(Сертификат.Отпечаток);
	Иначе
		ОтпечатокСтрокой = Строка(Сертификат);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Отпечаток", ОтпечатокСтрокой);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сертификаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
	|ГДЕ
	|	Сертификаты.Отпечаток = &Отпечаток";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Позволяет создать и обновить элемент справочника СертификатыКлючейЭлектроннойПодписиИШифрования по
// указанному сертификату криптографии.
//
// Параметры:
//  Сертификат - СертификатКриптографии - сертификат.
//             - ДвоичныеДанные - двоичные данные сертификата.
//             - Строка - адрес временного хранилища, содержащего двоичные данные сертификата.
//
//  ДополнительныеПараметры - Неопределено - без дополнительных параметров.
//    - Структура - со произвольным составом из следующих свойств:
//      * Наименование - Строка - представление сертификата в списке.
//
//      * Пользователь - СправочникСсылка.Пользователь - пользователь, которому принадлежит сертификат.
//                       Значение используется при получении списка личных сертификатов пользователя
//                       в формах подписания и шифрования данных.
//
//      * Организация  - СправочникСсылка.Организация - организация к которой относится сертификат.
//
//      * Программа - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования - программа, которая
//                      требуется для подписания и расшифровки.
//
//      * УсиленнаяЗащитаЗакрытогоКлюча - Булево - сертификат был установлен на компьютере с усиленной
//                      защитой закрытого ключа, которая означает поддержку только пустого пароля на
//                      уровне 1С:Предприятия (пароль у пользователя не запрашивается - это делает
//                      операционная система, которая не принимает от 1С:Предприятия непустой пароль).
//
// Возвращаемое значение:
//  СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на сертификат.
// 
Функция ЗаписатьСертификатВСправочник(Знач Сертификат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(ДополнительныеПараметры) <> Тип("Структура") Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	Если ТипЗнч(Сертификат) = Тип("Строка") И ЭтоАдресВременногоХранилища(Сертификат) Тогда
		ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(Сертификат);
	
	ИначеЕсли ТипЗнч(Сертификат) = Тип("ДвоичныеДанные") Тогда
		ДвоичныеДанныеСертификата = Сертификат;
	КонецЕсли;
	
	Если ДвоичныеДанныеСертификата = Неопределено Тогда
		СертификатКриптографии = Сертификат;
		ДвоичныеДанныеСертификата = СертификатКриптографии.Выгрузить();
	Иначе
		СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
	КонецЕсли;
	
	СертификатСсылка = СсылкаНаСертификат(Сертификат);
	
	Если ЗначениеЗаполнено(СертификатСсылка) Тогда
		СертификатОбъект = СертификатСсылка.ПолучитьОбъект();
		ОбновитьЗначение(СертификатОбъект.ПометкаУдаления, Ложь);
	Иначе
		СертификатОбъект = Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.СоздатьЭлемент();
		СертификатОбъект.ДанныеСертификата = Новый ХранилищеЗначения(ДвоичныеДанныеСертификата);
		СертификатОбъект.Отпечаток = Base64Строка(СертификатКриптографии.Отпечаток);
		
		СертификатОбъект.Добавил = ПользователиКлиентСервер.АвторизованныйПользователь();
	КонецЕсли;
	
	Если СертификатОбъект.ДанныеСертификата.Получить() <> ДвоичныеДанныеСертификата Тогда
		СертификатОбъект.ДанныеСертификата = Новый ХранилищеЗначения(ДвоичныеДанныеСертификата);
	КонецЕсли;
	
	ОбновитьЗначение(СертификатОбъект.Подписание, СертификатКриптографии.ИспользоватьДляПодписи);
	ОбновитьЗначение(СертификатОбъект.Шифрование, СертификатКриптографии.ИспользоватьДляШифрования);
	
	СтруктураСертификата = ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(СертификатКриптографии);
	ОбновитьЗначение(СертификатОбъект.КомуВыдан,      СтруктураСертификата.КомуВыдан);
	ОбновитьЗначение(СертификатОбъект.КемВыдан,       СтруктураСертификата.КемВыдан);
	ОбновитьЗначение(СертификатОбъект.ДействителенДо, СтруктураСертификата.ДействителенДо);
	
	СвойстваСубъекта = ЭлектроннаяПодписьКлиентСервер.СвойстваСубъектаСертификата(СертификатКриптографии);
	ОбновитьЗначение(СертификатОбъект.Фамилия,   СвойстваСубъекта.Фамилия,     Истина);
	ОбновитьЗначение(СертификатОбъект.Имя,       СвойстваСубъекта.Имя,         Истина);
	ОбновитьЗначение(СертификатОбъект.Отчество,  СвойстваСубъекта.Отчество,    Истина);
	ОбновитьЗначение(СертификатОбъект.Должность, СвойстваСубъекта.Должность,   Истина);
	ОбновитьЗначение(СертификатОбъект.Фирма,     СвойстваСубъекта.Организация, Истина);
	
	Для Каждого КлючИЗначение Из ДополнительныеПараметры Цикл
		ОбновитьЗначение(СертификатОбъект[КлючИЗначение.Ключ], КлючИЗначение.Значение);
	КонецЦикла;
	
	Если СертификатОбъект.Модифицированность() Тогда
		СертификатОбъект.Записать();
	КонецЕсли;
	
	Возврат СертификатОбъект.Ссылка;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает общие настройки всех пользователей для работы с электронной подписью.
//
// Возвращаемое значение: 
//   Структура - Общие настройки подсистемы для работы с электронной подписью.
//     * ИспользоватьЭлектронныеПодписи       - Булево - если Истина, то электронный подписи используются.
//     * ИспользоватьШифрование               - Булево - если Истина, то шифрование используются.
//     * ПроверятьЭлектронныеПодписиНаСервере - Булево - если Истина, то электронные подписи и
//                                                       сертификаты проверяются на сервере.
//     * СоздаватьЭлектронныеПодписиНаСервере - Булево - если Истина, то электронные подписи создаются
//                                                       сначала на сервере, а в случае неудачи на клиенте.
//
// См. также:
//   ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки() - единая точка входа.
//   ОбщаяФорма.НастройкиЭлектроннойПодписиИШифрования - место определения данных параметров и
//   их текстовые описания.
//
Функция ОбщиеНастройки() Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебныйПовтИсп.ОбщиеНастройки();
	
КонецФункции

// Извлекает сертификаты из данных подписи.
//
// Параметры:
//   Подпись - ДвоичныеДанные - Файл подписи.
//
// Возвращаемое значение:
//   Неопределено - Если при разборе возникла ошибка.
//   Структура - Данные подписи.
//       * Отпечаток                 - Строка.
//       * КомуВыданСертификат       - Строка.
//       * ДвоичныеДанныеСертификата - ДвоичныеДанные.
//       * Подпись                   - ХранилищеЗначения.
//       * Сертификат                - ХранилищеЗначения.
//
Функция ПрочитатьДанныеПодписи(Подпись) Экспорт
	
	Результат = Неопределено;
	
	МенеджерКриптографии = МенеджерКриптографии("ПолучениеСертификатов");
	Если МенеджерКриптографии = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Попытка
		Сертификаты = МенеджерКриптографии.ПолучитьСертификатыИзПодписи(Подпись);
	Исключение
		Возврат Результат;
	КонецПопытки;
	
	Если Сертификаты.Количество() > 0 Тогда
		Сертификат = Сертификаты[0];
		
		Результат = Новый Структура;
		Результат.Вставить("Отпечаток", Base64Строка(Сертификат.Отпечаток));
		Результат.Вставить("КомуВыданСертификат", ЭлектроннаяПодписьКлиентСервер.ПредставлениеСубъекта(Сертификат));
		Результат.Вставить("ДвоичныеДанныеСертификата", Сертификат.Выгрузить());
		Результат.Вставить("Подпись", Новый ХранилищеЗначения(Подпись));
		Результат.Вставить("Сертификат", Новый ХранилищеЗначения(Сертификат.Выгрузить()));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает настройки текущего пользователя для работы с электронной подписью.
//
// Возвращаемое значение:
//   Структура - Персональные настройки для работы с электронной подписью.
//       * ДействияПриСохраненииСЭП - Строка - Что делать при сохранении файлов с электронной подписью:
//           ** "Спрашивать" - Показывать диалог выбора подписей для сохранения.
//           ** "СохранятьВсеПодписи" - Всегда все подписи.
//       * ПутиКПрограммамЭлектроннойПодписиИШифрования - Соответствие - где:
//           ** Ключ     - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования - программа.
//           ** Значение - Строка - путь к программе на компьютере пользователя.
//       * РасширениеДляФайловПодписи - Строка - Расширение для файлов ЭП.
//       * РасширениеДляЗашифрованныхФайлов - Строка - Расширение для зашифрованных файлов.
//
// См. также:
//   ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки() - программный интерфейс для получения.
//   ОбщаяФорма.ПерсональныеНастройкиЭП - место ввода данных параметров и их пользовательские представления.
//
Функция ПерсональныеНастройки() Экспорт
	
	ПерсональныеНастройки = Новый Структура;
	// Начальные значения.
	ПерсональныеНастройки.Вставить("ДействияПриСохраненииСЭП", Перечисления.ДействияПриСохраненииСЭП.Спрашивать);
	ПерсональныеНастройки.Вставить("ДействияПриОтправкеПоПочтеСЭП", Перечисления.ДействияПриОтправкеПоПочтеЭП.Спрашивать);
	ПерсональныеНастройки.Вставить("ПутиКПрограммамЭлектроннойПодписиИШифрования", Новый Соответствие);
	ПерсональныеНастройки.Вставить("РасширениеДляФайловПодписи", "p7s");
	ПерсональныеНастройки.Вставить("РасширениеДляЗашифрованныхФайлов", "p7m");
	
	КлючПодсистемы = ЭлектроннаяПодписьСлужебный.КлючХраненияНастроек();
	
	Для Каждого КлючИЗначение Из ПерсональныеНастройки Цикл
		СохраненноеЗначение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючПодсистемы,
			КлючИЗначение.Ключ);
		
		Если ЗначениеЗаполнено(СохраненноеЗначение)
		   И ТипЗнч(КлючИЗначение.Значение) = ТипЗнч(СохраненноеЗначение) Тогда
			
			ПерсональныеНастройки.Вставить(КлючИЗначение.Ключ, СохраненноеЗначение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПерсональныеНастройки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Для процедуры ДобавитьПодпись.
Процедура ДобавитьСтрокуПодписи(ОбъектДанных, СвойстваПодписи)
	
	Если ОбъектДанных.Метаданные().ТабличныеЧасти.Найти("ЭлектронныеПодписи") = Неопределено Тогда
		РаботаСЭП.ЗанестиИнформациюОПодписи(ОбъектДанных.Ссылка, СвойстваПодписи);
	Иначе
		НоваяЗапись = ОбъектДанных.ЭлектронныеПодписи.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, СвойстваПодписи,, "Подпись, Сертификат");
		
		НоваяЗапись.Подпись = Новый ХранилищеЗначения(СвойстваПодписи.Подпись);
		НоваяЗапись.Сертификат = Новый ХранилищеЗначения(СвойстваПодписи.Сертификат);
		
		Если Не ЗначениеЗаполнено(НоваяЗапись.УстановившийПодпись) Тогда
			НоваяЗапись.УстановившийПодпись = Пользователи.АвторизованныйПользователь();
		КонецЕсли;
		
		ДатаПодписи = ДатаПодписания(СвойстваПодписи.Подпись);
		
		Если ДатаПодписи <> Неопределено Тогда
			НоваяЗапись.ДатаПодписи = ДатаПодписи;
			
		ИначеЕсли Не ЗначениеЗаполнено(НоваяЗапись.ДатаПодписи) Тогда
			НоваяЗапись.ДатаПодписи = ТекущаяДатаСеанса();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Для процедуры УдалитьПодпись.
Процедура УдалитьСтрокуПодписи(ПодписанныйОбъект, ИндексСтроки)
	
	Подпись = РаботаСЭП.ПолучитьЭлектроннуюПодпись(ПодписанныйОбъект,,, ИндексСтроки);
	
	Если Подпись = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Подпись не найдена.'; en = 'Signature not found.'");
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда 
		Если Подпись.УстановившийПодпись <> Пользователи.ТекущийПользователь() Тогда
			ВызватьИсключение НСтр("ru = 'Недостаточно прав на удаление подписи.'; en = 'Insufficient permissions to delete the signature.'");
		КонецЕсли;
	КонецЕсли;
	
	Подпись.Удалить();
	
КонецПроцедуры

// Для процедуры ЗаписатьСертификатВСправочник.
Процедура ОбновитьЗначение(СтароеЗначение, НовоеЗначение, ПропускатьНеопределенныеЗначения = Ложь)
	
	Если НовоеЗначение = Неопределено И ПропускатьНеопределенныеЗначения Тогда
		Возврат;
	КонецЕсли;
	
	Если СтароеЗначение <> НовоеЗначение Тогда
		СтароеЗначение = НовоеЗначение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
