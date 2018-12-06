﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкаВыходаИзПрограммы = ХранилищеОбщихНастроек.Загрузить("НастройкаВыходаИзПрограммы");
	Если НастройкаВыходаИзПрограммы = Неопределено Тогда
		ЗапрашиватьПодтверждениеПриЗакрытииПрограммы = Ложь;
	Иначе
		ЗапрашиватьПодтверждениеПриЗакрытииПрограммы = НастройкаВыходаИзПрограммы;
	КонецЕсли;
	
	//Категории
	ЗапрашиватьПодтверждениеПриПроверкеКатегорий =
		ХранилищеОбщихНастроек.Загрузить(
			"ПроверкаКатегорий",
			"ПоказыватьПодтверждениеПроверкиКатегорий");
	
	ПоказыватьПодтверждениеПовторнойКатегоризации =
		ХранилищеОбщихНастроек.Загрузить(
			"ПроверкаКатегорий",
			"ПоказыватьПодтверждениеПовторнойКатегоризации");
	
	// Проект
	Проект =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСПроектами",
			"ПроектПоУмолчанию");
		
	ВидПроекта =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСПроектами",
			"ВидПроектаПоУмолчанию");
			
	НастройкаИспользоватьОбзорПроектов =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСПроектами",
			"ИспользоватьОбзорПроектов");
	Если НастройкаИспользоватьОбзорПроектов = Неопределено Тогда 
		ИспользоватьОбзорПроектов = Истина;
	Иначе
		ИспользоватьОбзорПроектов = НастройкаИспользоватьОбзорПроектов;
	КонецЕсли;	
			
			
	// Прочтение
	ПомечатьСообщенияФорумаКакПрочтенныеПриПрочтенныеПриПросмотреВОбластиЧтения =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиПрочтения",
			"ПомечатьСообщенияФорумаКакПрочтенныеПриПрочтенныеПриПросмотреВОбластиЧтения",
			Ложь);
		
	ОтображатьФотографииПерсональнаяНастройка =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы",
		"ОтображатьФотографииПерсональнаяНастройка",
		Истина);
	
	// НапоминанияПользователя
	Элементы.ГруппаНапоминания.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНапоминанияПользователя");
	ИнтервалПроверкиНапоминаний = НапоминанияПользователяСлужебный.ПолучитьИнтервалПроверкиНапоминаний();
	СрокНапоминанияПоУмолчанию =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиНапоминаний",
			"СрокНапоминанияПоУмолчанию",
			15);
	УстанавливатьНапоминаниеАвтоматически =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиНапоминаний",
			"УстанавливатьНапоминаниеАвтоматически",
			Истина);
	// Конец НапоминанияПользователя
	
	ФлагПоУмолчаниюДляЗадач = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ФлагиОбъектов",
			"ФлагПоУмолчаниюДляЗадач",
			Перечисления.ФлагиОбъектов.Красный);
		
	ОтобразитьФлагЗадачи();
	
	// Отсутствия
	ПредупреждатьОбОтсутствии =
		Отсутствия.ПолучитьПерсональнуюНастройку("ПредупреждатьОбОтсутствии");
	БудуРазбиратьЗадачи =
		Отсутствия.ПолучитьПерсональнуюНастройку("БудуРазбиратьЗадачи");
	Элементы.БудуРазбиратьЗадачи.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьЭскалациюЗадач");
	ВопросСоздатьПисьмоБольшеНеСпрашивать =
		Отсутствия.ПолучитьПерсональнуюНастройку("ВопросСоздатьПисьмоБольшеНеСпрашивать");
	ВопросСоздатьПисьмоВариантОтвета =
		Отсутствия.ПолучитьПерсональнуюНастройку("ВопросСоздатьПисьмоВариантОтвета");
	Если ВопросСоздатьПисьмоБольшеНеСпрашивать Тогда
		Если ВопросСоздатьПисьмоВариантОтвета Тогда
			ВопросСоздаватьПисьмо = 0;
		Иначе
			ВопросСоздаватьПисьмо = 2;
		КонецЕсли;
	Иначе
		ВопросСоздаватьПисьмо = 1;
	КонецЕсли;
	Элементы.ВопросСоздаватьПисьмо.Видимость =
		ПолучитьФункциональнуюОпциюФормы("ИспользованиеВстроеннойПочты")
			Или ПолучитьФункциональнуюОпциюФормы("ИспользованиеЛегкойПочты");
	ВопросСоздатьПравилоБольшеНеСпрашивать =
		Отсутствия.ПолучитьПерсональнуюНастройку("ВопросСоздатьПравилоБольшеНеСпрашивать");
	ВопросСоздатьПравилоВариантОтвета =
		Отсутствия.ПолучитьПерсональнуюНастройку("ВопросСоздатьПравилоВариантОтвета");
	Если ВопросСоздатьПравилоБольшеНеСпрашивать Тогда
		Если ВопросСоздатьПравилоВариантОтвета Тогда
			ВопросСоздатьПравило = 0;
		Иначе
			ВопросСоздатьПравило = 2;
		КонецЕсли;
	Иначе
		ВопросСоздатьПравило = 1;
	КонецЕсли;
	Элементы.ВопросСоздатьПравило.Видимость =
		ПолучитьФункциональнуюОпциюФормы("ИспользованиеВстроеннойПочты");
	
	// Мероприятия
	ЯвкаОбязательнаПоУмолчанию = УправлениеМероприятиями.ПолучитьПерсональнуюНастройку("ЯвкаОбязательнаПоУмолчанию");
	ВопросУказатьПроверяющегоБольшеНеСпрашивать =
		УправлениеМероприятиями.ПолучитьПерсональнуюНастройку("ВопросУказатьПроверяющегоБольшеНеСпрашивать");
	ВопросУказатьПроверяющегоВариантОтвета =
		УправлениеМероприятиями.ПолучитьПерсональнуюНастройку("ВопросУказатьПроверяющегоВариантОтвета");
	Если ВопросУказатьПроверяющегоБольшеНеСпрашивать Тогда
		Если ВопросУказатьПроверяющегоВариантОтвета Тогда
			ВопросУказатьПроверяющего = 0;
		Иначе
			ВопросУказатьПроверяющего = 2;
		КонецЕсли;
	Иначе
		ВопросУказатьПроверяющего = 1;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработатьЗакрытие", 
		ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения,
		НСтр("ru = 'Данные были изменены. Сохранить изменения?'; en = 'Data has been changed. Save changes?'"),
		РежимДиалогаВопрос.ДаНетОтмена,,
		КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Если НеобходимостьОбновленияИнтерфейса Тогда
		ОбновитьПовторноИспользуемыеЗначения();
		ОбновитьИнтерфейсКлиент();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВопросСоздаватьПисьмоПриИзменении(Элемент)
	
	Если ВопросСоздаватьПисьмо = 0 Тогда
		ВопросСоздатьПисьмоБольшеНеСпрашивать = Истина;
		ВопросСоздатьПисьмоВариантОтвета = Истина;
	ИначеЕсли ВопросСоздаватьПисьмо = 1 Тогда
		ВопросСоздатьПисьмоБольшеНеСпрашивать = Ложь;
		ВопросСоздатьПисьмоВариантОтвета = Истина;
	ИначеЕсли ВопросСоздаватьПисьмо = 2 Тогда
		ВопросСоздатьПисьмоБольшеНеСпрашивать = Истина;
		ВопросСоздатьПисьмоВариантОтвета = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСоздатьПравилоПриИзменении(Элемент)
	
	Если ВопросСоздатьПравило = 0 Тогда
		ВопросСоздатьПравилоБольшеНеСпрашивать = Истина;
		ВопросСоздатьПравилоВариантОтвета = Истина;
	ИначеЕсли ВопросСоздатьПравило = 1 Тогда
		ВопросСоздатьПравилоБольшеНеСпрашивать = Ложь;
		ВопросСоздатьПравилоВариантОтвета = Истина;
	ИначеЕсли ВопросСоздатьПравило = 2 Тогда
		ВопросСоздатьПравилоБольшеНеСпрашивать = Истина;
		ВопросСоздатьПравилоВариантОтвета = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросУказатьПроверяющегоПриИзменении(Элемент)
	
	Если ВопросУказатьПроверяющего = 0 Тогда
		ВопросУказатьПроверяющегоБольшеНеСпрашивать = Истина;
		ВопросУказатьПроверяющегоВариантОтвета = Истина;
	ИначеЕсли ВопросУказатьПроверяющего = 1 Тогда
		ВопросУказатьПроверяющегоБольшеНеСпрашивать = Ложь;
		ВопросУказатьПроверяющегоВариантОтвета = Истина;
	ИначеЕсли ВопросУказатьПроверяющего = 2 Тогда
		ВопросУказатьПроверяющегоБольшеНеСпрашивать = Истина;
		ВопросУказатьПроверяющегоВариантОтвета = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьНастройки();
	СтандартныеПодсистемыКлиент.УстановитьПараметрКлиента(
		"ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
		ЗапрашиватьПодтверждениеПриЗакрытииПрограммы);
	НеобходимостьОбновленияИнтерфейса = Истина;
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура КрасныйФлагЗадачи(Команда)
	
	ФлагПоУмолчаниюДляЗадач = ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный");
	Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.КрасныйФлаг;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлагЗадачи(Команда)
	
	ФлагПоУмолчаниюДляЗадач = ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий");
	Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.СинийФлаг;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЖелтыйФлагЗадачи(Команда)
	
	ФлагПоУмолчаниюДляЗадач = ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый");
	Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.ЖелтыйФлаг;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлагЗадачи(Команда)
	
	ФлагПоУмолчаниюДляЗадач = ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый");
	Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.ЗеленыйФлаг;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлагЗадачи(Команда)
	
	ФлагПоУмолчаниюДляЗадач = ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый");
	Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.ОранжевыйФлаг;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлагЗадачи(Команда)
	
	ФлагПоУмолчаниюДляЗадач = ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый");
	Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.ЛиловыйФлаг;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьФлагЗадачи()
	
	Если ФлагПоУмолчаниюДляЗадач = Перечисления.ФлагиОбъектов.ПустаяСсылка() Тогда
		Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.ПустойФлаг;
	ИначеЕсли ФлагПоУмолчаниюДляЗадач = Перечисления.ФлагиОбъектов.Красный Тогда
		Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.КрасныйФлаг;
	ИначеЕсли ФлагПоУмолчаниюДляЗадач = Перечисления.ФлагиОбъектов.Синий Тогда
		Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.СинийФлаг;
	ИначеЕсли ФлагПоУмолчаниюДляЗадач = Перечисления.ФлагиОбъектов.Желтый Тогда
		Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.ЖелтыйФлаг;
	ИначеЕсли ФлагПоУмолчаниюДляЗадач = Перечисления.ФлагиОбъектов.Зеленый Тогда
		Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.ЗеленыйФлаг;
	ИначеЕсли ФлагПоУмолчаниюДляЗадач = Перечисления.ФлагиОбъектов.Оранжевый Тогда
		Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.ОранжевыйФлаг;
	ИначеЕсли ФлагПоУмолчаниюДляЗадач = Перечисления.ФлагиОбъектов.Лиловый Тогда
		Элементы.ПодменюФлагиЗадач.Картинка = БиблиотекаКартинок.ЛиловыйФлаг;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьЗакрытие(Ответ, Параметры) Экспорт 

	Если Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьНастройки();
		СтандартныеПодсистемыКлиент.УстановитьПараметрКлиента(
			"ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
			ЗапрашиватьПодтверждениеПриЗакрытииПрограммы);
		НеобходимостьОбновленияИнтерфейса = Истина;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	МассивСтруктур = Новый Массив;
	
	// НастройкаВыходаИзПрограммы
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкаВыходаИзПрограммы",, ЗапрашиватьПодтверждениеПриЗакрытииПрограммы);
	
	// ПроверкаКатегорий
	ДобавитьСтруктуруНастройки(МассивСтруктур, "ПроверкаКатегорий", "ПоказыватьПодтверждениеПроверкиКатегорий", ЗапрашиватьПодтверждениеПриПроверкеКатегорий);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "ПроверкаКатегорий", "ПоказыватьПодтверждениеПовторнойКатегоризации", ПоказыватьПодтверждениеПовторнойКатегоризации);
	
	// Проект
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСПроектами", "ПроектПоУмолчанию", Проект);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСПроектами", "ВидПроектаПоУмолчанию", ВидПроекта);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиРаботыСПроектами", "ИспользоватьОбзорПроектов", ИспользоватьОбзорПроектов);
	
	// Прочтение
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиПрочтения", "ПомечатьСообщенияФорумаКакПрочтенныеПриПрочтенныеПриПросмотреВОбластиЧтения", ПомечатьСообщенияФорумаКакПрочтенныеПриПрочтенныеПриПросмотреВОбластиЧтения);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиПрограммы", "ОтображатьФотографииПерсональнаяНастройка", ОтображатьФотографииПерсональнаяНастройка);
	
	// НапоминанияПользователя
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиНапоминаний", "ИнтервалПроверкиНапоминаний",
		ИнтервалПроверкиНапоминаний);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиНапоминаний", "СрокНапоминанияПоУмолчанию",
		СрокНапоминанияПоУмолчанию);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиНапоминаний", "УстанавливатьНапоминаниеАвтоматически",
		УстанавливатьНапоминаниеАвтоматически);
	// Конец НапоминанияПользователя
	
	// ФлагиОбъектов
	ДобавитьСтруктуруНастройки(МассивСтруктур, "ФлагиОбъектов", "ФлагПоУмолчаниюДляЗадач", ФлагПоУмолчаниюДляЗадач);
	
	// Отсутствия
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиОтсутствий", "ПредупреждатьОбОтсутствии", ПредупреждатьОбОтсутствии);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиОтсутствий", "БудуРазбиратьЗадачи", БудуРазбиратьЗадачи);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиОтсутствий", "ВопросСоздатьПисьмоБольшеНеСпрашивать", ВопросСоздатьПисьмоБольшеНеСпрашивать);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиОтсутствий", "ВопросСоздатьПисьмоВариантОтвета", ВопросСоздатьПисьмоВариантОтвета);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиОтсутствий", "ВопросСоздатьПравилоБольшеНеСпрашивать", ВопросСоздатьПравилоБольшеНеСпрашивать);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиОтсутствий", "ВопросСоздатьПравилоВариантОтвета", ВопросСоздатьПравилоВариантОтвета);
	
	// Мероприятия
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиМероприятий", "ЯвкаОбязательнаПоУмолчанию", ЯвкаОбязательнаПоУмолчанию);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиМероприятий", "ВопросУказатьПроверяющегоБольшеНеСпрашивать", ВопросУказатьПроверяющегоБольшеНеСпрашивать);
	ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиМероприятий", "ВопросУказатьПроверяющегоВариантОтвета", ВопросУказатьПроверяющегоВариантОтвета);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтруктуруНастройки(МассивСтруктур, Объект, Настройка = Неопределено, Значение)
	
	МассивСтруктур.Добавить(Новый Структура ("Объект, Настройка, Значение", Объект, Настройка, Значение));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсКлиент()
	
	УстанавливаемыеПараметры = Новый Структура;
	УстанавливаемыеПараметры.Вставить("Пользователи", ПользователиКлиентСервер.ТекущийПользователь());
	УстановитьПараметрыФункциональныхОпцийИнтерфейса(УстанавливаемыеПараметры);
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти
