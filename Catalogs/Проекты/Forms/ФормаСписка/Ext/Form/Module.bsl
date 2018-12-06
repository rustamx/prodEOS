﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	
	ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам;
	ПапкаПриОткрытии = Неопределено;
	Элементы.Папки.ТекущаяСтрока = ПапкаПриОткрытии;
	ПереключитьВидПросмотра();
	
	ПоказыватьУдаленные = Ложь;
	ПоказатьУдаленные();
	
	ЗаполнитьДеревоЗаказчиков();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// Контроль
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Элементы.СостояниеКонтроля.Видимость = Ложь;
	КонецЕсли;
	
	// Контрольные точки
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольныеТочки") Тогда 
		Элементы.ИндексКартинкиОценки.Видимость = Ложь;
	КонецЕсли;
	
	// Учет трудозатрат
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Неопределено,
		ВидыРабот,
		СпособУказанияВремени,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		ЭтаФорма.Элементы.УказатьТрудозатраты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменение_Проект" Тогда
		Элементы.Список.ТекущаяСтрока = Параметр;
	КонецЕсли;
		
	Если ИмяСобытия = "ЗаписьКонтроля" Тогда
		Если ЗначениеЗаполнено(Параметр.Предмет)
			И ТипЗнч(Параметр.Предмет) = Тип("СправочникСсылка.Проекты") Тогда 
			ОповеститьОбИзменении(Параметр.Предмет);
		КонецЕсли;	
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ОценкаКТ"
		И ЗначениеЗаполнено(Параметр)
		И ТипЗнч(Параметр) = Тип("СправочникСсылка.Проекты") Тогда 
			ОповеститьОбИзменении(Параметр);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборСписка(Список, Настройки);
	
	ВидПросмотра = Настройки["ВидПросмотра"];
	Если Не ЗначениеЗаполнено(ВидПросмотра) Тогда
		ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам;
	КонецЕсли;
	
	ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
	ПоказатьУдаленные();
	
	ТекущаяПапка = Настройки["ТекущаяПапка"];
	ТекущийВидПроекта = Настройки["ТекущийВидПроекта"];
	ТекущийЗаказчик = Настройки["ТекущийЗаказчик"];
	ТекущийРуководитель = Настройки["ТекущийРуководитель"]; 
	
	ПереключитьВидПросмотра();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборПапка, ОтборПапка);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборСостояние, ОтборСостояние);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборРуководитель, ОтборРуководитель);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборЗаказчик, ОтборЗаказчик);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборОрганизация, ОтборОрганизация);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ОтборВидПроекта, ОтборВидПроекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПерехода(ОбъектПерехода, СтандартнаяОбработка)
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.Списком") Тогда
		Возврат;
	Иначе 
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам") Тогда
		
		ТекущаяПапка = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			ОбъектПерехода, "Папка");
		Элементы.Папки.ТекущаяСтрока = ТекущаяПапка;
		Список.Параметры.УстановитьЗначениеПараметра("Папка", Элементы.Папки.ТекущаяСтрока);
		
	ИначеЕсли ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоВидамДокументов") Тогда
		
		ТекущийВидПроекта = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			ОбъектПерехода, "ВидПроекта");
		Элементы.ВидыПроектов.ТекущаяСтрока = ТекущийВидПроекта;
		Список.Параметры.УстановитьЗначениеПараметра("ВидПроекта", Элементы.ВидыПроектов.ТекущаяСтрока);
		
	ИначеЕсли ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПользователям") Тогда
		
		ТекущийРуководитель = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			ОбъектПерехода, "Руководитель");
		Элементы.Руководители.ТекущаяСтрока = ТекущийРуководитель;
		Список.Параметры.УстановитьЗначениеПараметра("Руководитель", Элементы.Руководители.ТекущаяСтрока);
		
	ИначеЕсли ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоКонтрагентам") Тогда
		
		ТекущийЗаказчик = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(
			ОбъектПерехода, "Заказчик");
		ЗаполнитьДеревоЗаказчиков();
		
		Элементы.Заказчики.ТекущаяСтрока = ТекущийЗаказчик;
		Список.Параметры.УстановитьЗначениеПараметра("Заказчик", ТекущийЗаказчик);
		
		Для Каждого ЭлементДерева Из Заказчики.ПолучитьЭлементы() Цикл
			Элементы.Заказчики.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
		КонецЦикла;
		
		Если ТекущийЗаказчик <> Неопределено Тогда 
			Идентификатор = Неопределено;
			ДелопроизводствоКлиент.НайтиСтрокуДереваПоСсылке(ТекущийЗаказчик, Заказчики, Идентификатор);
			Если Идентификатор <> Неопределено Тогда 
				ТекущийЗаказчик = Неопределено;
				Элементы.Заказчики.ТекущаяСтрока = Идентификатор;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Список.ТекущаяСтрока = ОбъектПерехода;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПапкаПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("Папка", ОтборПапка);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборПапка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("Состояние", ОтборСостояние);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборСостояние);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборРуководительПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("Руководитель", ОтборРуководитель);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборРуководитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЗаказчикПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	
	Если ОтборЗаказчик = Неопределено Тогда
		ОтборЗаказчик = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	КонецЕсли;
	
	ПараметрыОтбора.Вставить("Заказчик", ОтборЗаказчик);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборЗаказчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидПроектаПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("ВидПроекта", ОтборВидПроекта);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборВидПроекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("Организация", ОтборОрганизация);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ОтборОрганизация);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПапки

&НаКлиенте
Процедура ПапкиПриАктивизацииСтроки(Элемент)
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам")
		И Элементы.СтраницаПапки.Видимость 
		И ТекущаяПапка <> Элементы.Папки.ТекущаяСтрока Тогда 
		
		ТекущаяПапка = Элементы.Папки.ТекущаяСтрока;
		
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	// Запрет перетаскивания в пустую папку
	Если Не ЗначениеЗаполнено(Строка) Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") 
		И ПараметрыПеретаскивания.Значение.Количество() > 0 
		И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.Проекты") Тогда
		
		РаботаСПроектамиКлиент.ИзменитьПапкуПроектов(ПараметрыПеретаскивания.Значение, Строка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыПроектов

&НаКлиенте
Процедура ВидыПроектовПриАктивизацииСтроки(Элемент)
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоВидамДокументов")
		И Элементы.СтраницаВиды.Видимость 
		И ТекущийВидПроекта <> Элементы.ВидыПроектов.ТекущаяСтрока Тогда 
		
		ТекущийВидПроекта = Элементы.ВидыПроектов.ТекущаяСтрока;
		
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРуководители

&НаКлиенте
Процедура РуководителиПриАктивизацииСтроки(Элемент)
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПользователям")
		И Элементы.СтраницаРуководители.Видимость 
		И ТекущийРуководитель <> Элементы.Руководители.ТекущаяСтрока Тогда 
		
		ТекущийРуководитель = Элементы.Руководители.ТекущаяСтрока;
		
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказчики

&НаКлиенте
Процедура ЗаказчикиПриАктивизацииСтроки(Элемент)
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоКонтрагентам")
		И Элементы.СтраницаЗаказчики.Видимость Тогда 
		
		ТекущиеДанные = Элементы.Заказчики.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Если ТекущийЗаказчик = ТекущиеДанные.Ссылка Тогда 
				Возврат;
			КонецЕсли;
			
			ТекущийЗаказчик = ТекущиеДанные.Ссылка;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СостояниеКонтроля Тогда 
		
		СтандартнаяОбработка = Ложь;
		
		КонтрольКлиент.ОбработкаКомандыКонтроль(ВыбраннаяСтрока, ЭтаФорма);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("АктивизацияСтрокиСписка", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
		
		ТекущаяСтрока = Элемент.ТекущаяСтрока;
		Если ТипЗнч(ТекущаяСтрока) <> Тип("СправочникСсылка.Проекты") Тогда 
			Возврат;
		КонецЕсли;	
		
		Если Элемент.ТекущиеДанные.ЭтоГруппа Тогда 
			Возврат;
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"СписокПередНачаломДобавленияПродолжение",
			ЭтотОбъект,
			Новый Структура("ТекущаяСтрока", ТекущаяСтрока));	
			
		//+копирование КТ с задачами. в дин списке добавлен код 			
		ЗадатьВопросКопирования = ТекущиеДанные.ЕстьПроектныеЗадачи ИЛИ ТекущиеДанные.ЕстьКонтрольныеТочки;	
		
		Если ЗадатьВопросКопирования Тогда
			
			ТекстВопроса = НСтр("ru = 'Копировать %1 проекта ""%2""?'; en = 'Copy %1 of ""%2"" project?'");
			
			ТекстПараметраВопроса = ""; 
			Если ТекущиеДанные.ЕстьПроектныеЗадачи Тогда
				ТекстПараметраВопроса = ТекстПараметраВопроса + "задачи";
			КонецЕсли;
			Если ТекущиеДанные.ЕстьКонтрольныеТочки Тогда
				Если ТекущиеДанные.ЕстьПроектныеЗадачи Тогда
					ТекстПараметраВопроса = ТекстПараметраВопроса + " и ";
				КонецЕсли;
				ТекстПараметраВопроса = ТекстПараметраВопроса + "контрольные точки";
			КонецЕсли;
			
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстВопроса,
				ТекстПараметраВопроса,
				Строка(ТекущаяСтрока));
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Нет);
		КонецЕсли;	
		
	Иначе	
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Папка", Элементы.Папки.ТекущаяСтрока);
	
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		Открытьформу("Справочник.Проекты.ФормаОбъекта", ПараметрыФормы, Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавленияПродолжение(Результат, Параметры) Экспорт 
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Папка", Элементы.Папки.ТекущаяСтрока);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("ЗначениеКопирования", Параметры.ТекущаяСтрока);
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		// + 
		//ПараметрыФормы.Вставить("КопироватьЗадачи", Истина);
		ПараметрыФормы.Вставить("КопироватьЗадачиКонтрольныеТочки", Истина);
	КонецЕсли;

	ОткрытьФорму("Справочник.Проекты.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры	

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьИзMSProject(Команда)
	
	ПараметрыФормы = Новый Структура();
	Если Элементы.Список.ТекущиеДанные <> Неопределено
		И Элементы.Список.ТекущиеДанные.ЗагруженИзMSProject Тогда
		ПараметрыФормы.Вставить("Проект", Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	ОткрытьФорму("Обработка.ИмпортПроектаИзMicrosoftProject.Форма", ПараметрыФормы, ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКТ(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектКТ", ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.КонтрольныеТочки.Форма.КТОбъекта", ПараметрыФормы, ЭтаФорма, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПланПроекта(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Проект", ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.ПроектныеЗадачи.Форма.ФормаПланаПроекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПроект(Команда)
	
	ТекущаяПапка = Элементы.Папки.ТекущаяСтрока;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Папка", ТекущаяПапка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	Открытьформу("Справочник.Проекты.ФормаОбъекта", ПараметрыФормы, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПапку(Команда)
	
	ТекущаяПапка = Элементы.Папки.ТекущаяСтрока;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Родитель", ТекущаяПапка);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Справочник.ПапкиПроектов.ФормаОбъекта", ПараметрыФормы, Элементы.Папки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПрава(Команда)
	
	Папка = Элементы.Папки.ТекущаяСтрока;
	Если Не ЗначениеЗаполнено(Папка) Тогда
		Возврат;
	КонецЕсли;
	
	// Открытие формы настройки прав
	ПараметрыФормы = Новый Структура("СсылкаНаОбъект", Папка);
	ОткрытьФорму("ОбщаяФорма.НастройкиПравПапок", ПараметрыФормы, , Папка);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотраСписком(Команда)
	
	ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.Списком");
	
	ПереключитьВидПросмотра();
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотраПоПапкам(Команда)
	
	ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам");
	
	ПереключитьВидПросмотра();
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотраПоВидам(Команда)
	
	ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоВидамДокументов");
	
	ПереключитьВидПросмотра();
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотраПоРуководителям(Команда)
	
	ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПользователям");
	
	ПереключитьВидПросмотра();
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПросмотраПоЗаказчикам(Команда)
	
	ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоКонтрагентам");
	
	ПереключитьВидПросмотра();
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьОтчеты(Команда)
		
	Раздел = ПредопределенноеЗначение("Перечисление.РазделыОтчетов.ПроектыСписок");
	
	ЗаголовокФормы = НСтр("ru = 'Отчеты по проектам'; en = 'Project reports'");
	
	РазделГипперСсылка = НастройкиВариантовОтчетовДокументооборот.ПолучитьРазделОтчетаПоИмени("СовместнаяРабота");

	ПараметрыФормы = Новый Структура("Раздел, ЗаголовокФормы, НеОтображатьИерархию, РазделГипперСсылка", 
		Раздел, ЗаголовокФормы, Истина, РазделГипперСсылка);
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма, 
		"ПроектыСписок");

КонецПроцедуры

// Учет времени

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;

	ПараметрыОповещения = Неопределено;
	НуженДиалог = УчетВремениКлиент.НуженДиалогДляХронометража(ВключенХронометраж, 
		ДатаНачалаХронометража, ВидыРабот);
	
	Если НуженДиалог = Ложь Тогда
		
		ПереключитьХронометражСервер(ПараметрыОповещения);
		УчетВремениКлиент.ПоказатьОповещение(ПараметрыОповещения, ВключенХронометраж, ТекущиеДанные.Ссылка);
	
	Иначе
		ДлительностьРаботы = УчетВремениКлиент.ПолучитьДлительностьРаботы(ДатаНачалаХронометража);
		
		ОписаниеРаботы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Работа с проектом ""%1""'; en = 'Working with project ""%1""'"),
			ТекущиеДанные.Наименование);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ДатаОтчета", ТекущаяДата());
		ПараметрыФормы.Вставить("ВидыРабот", ВидыРабот);
		ПараметрыФормы.Вставить("ОписаниеРаботы", ОписаниеРаботы);
		ПараметрыФормы.Вставить("ДлительностьРаботы", ДлительностьРаботы);
		ПараметрыФормы.Вставить("НачалоРаботы", ДатаНачалаХронометража);
		ПараметрыФормы.Вставить("Объект", ТекущиеДанные.Ссылка);
		ПараметрыФормы.Вставить("СпособУказанияВремени", СпособУказанияВремени);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПереключитьХронометражПродолжение",
			ЭтотОбъект,
			Новый Структура("Объект", ТекущиеДанные.Ссылка));
		
		ОткрытьФорму("РегистрСведений.ФактическиеТрудозатраты.Форма.ФормаДобавленияРаботы", ПараметрыФормы,,,,,
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометражПродолжение(Результат, Параметры) Экспорт 
	
	Если Результат <> Неопределено Тогда
		ДобавитьВОтчетИОбновитьФорму(Результат, ПараметрыОповещения);
		УчетВремениКлиент.ПоказатьОповещение(ПараметрыОповещения, ВключенХронометраж, Параметры.Объект);
	Иначе
		ОтключитьХронометражСервер();
	КонецЕсли;  

КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДатаОтчета = ТекущаяДата();
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		ТекущиеДанные.Ссылка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Ложь,
		ЭтаФорма); // Выполнена
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Отправить

&НаКлиенте
Процедура ПроцессИсполнение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Исполнение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОбработка(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("КомплексныйПроцесс");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникСозданияОсновныхПроцессов(ТипыОпераций)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Проект = Неопределено;
	Иначе
		Проект = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		ТипыОпераций, Проект, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура АктивизацияСтрокиСписка()
	
	Если ТекущийПроект <> Элементы.Список.ТекущаяСтрока Тогда
		ТекущийПроект = Элементы.Список.ТекущаяСтрока;
		ОбновитьПараметрыУчетаВремениВФорме();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	// Состояние 
	Состояние = ПараметрыОтбора.Получить("Состояние");
	Если Состояние <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(Состояние) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Состояние");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Состояние",
				Состояние);
		КонецЕсли;
	КонецЕсли;

	// Руководитель 
	Руководитель = ПараметрыОтбора.Получить("Руководитель");
	Если Руководитель <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(Руководитель) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Руководитель");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Руководитель",
				Руководитель);
		КонецЕсли;
	КонецЕсли;
	
	// Заказчик 
	Заказчик = ПараметрыОтбора.Получить("Заказчик");
	Если Заказчик <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(Заказчик) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Заказчик");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Заказчик",
				Заказчик);
		КонецЕсли;
	КонецЕсли;
	
	// Вид проекта 
	ВидПроекта = ПараметрыОтбора.Получить("ВидПроекта");
	Если ВидПроекта <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(ВидПроекта) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"ВидПроекта");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"ВидПроекта",
				ВидПроекта);
		КонецЕсли;
	КонецЕсли;	
	
	// Папка 
	Папка = ПараметрыОтбора.Получить("Папка");
	Если Папка <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(Папка) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Папка");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Папка",
				Папка);
		КонецЕсли;
	КонецЕсли;	
	
	// Организация
	Организация = ПараметрыОтбора.Получить("Организация");
	Если Организация <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(Организация) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Организация");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Организация",
				Организация);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Папки, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Руководители, "ПометкаУдаления");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ВидыПроектов, "ПометкаУдаления");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Папки, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Руководители, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВидыПроектов, "ПометкаУдаления", Ложь);
	КонецЕсли;	
	ЗаполнитьДеревоЗаказчиков();
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьПараметрыСписка()
	
	Если ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПапкам") Тогда 
		
		Список.Параметры.УстановитьЗначениеПараметра("Папка", Элементы.Папки.ТекущаяСтрока);
	
	ИначеЕсли ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоВидамДокументов") Тогда 
		
		Список.Параметры.УстановитьЗначениеПараметра("ВидПроекта", Элементы.ВидыПроектов.ТекущаяСтрока);
		
	ИначеЕсли ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоКонтрагентам") Тогда 
		
		ТекущиеДанные = Элементы.Заказчики.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда 
			Список.Параметры.УстановитьЗначениеПараметра("Заказчик", ТекущиеДанные.Ссылка);
		Иначе
			Список.Параметры.УстановитьЗначениеПараметра("Заказчик", Неопределено);
		КонецЕсли;	
		
	ИначеЕсли ВидПросмотра = ПредопределенноеЗначение("Перечисление.ВидыПросмотраСпискаОбъектов.ПоПользователям") Тогда 
		
		Список.Параметры.УстановитьЗначениеПараметра("Руководитель", Элементы.Руководители.ТекущаяСтрока);	
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ПереключитьВидПросмотра()

	ПараметрыКомпоновки = Новый Структура("Папка, ВидПроекта, Руководитель, Заказчик");
	Для Каждого ИмяПараметра Из ПараметрыКомпоновки Цикл
		Параметр = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра.Ключ));
		Если Параметр <> Неопределено И Параметр.Использование Тогда 
			Параметр.Использование = Ложь;
		КонецЕсли;	
	КонецЦикла;
	
	Элементы.СтраницаПапки.Видимость = Ложь;
	Элементы.СтраницаВиды.Видимость = Ложь;
	Элементы.СтраницаЗаказчики.Видимость = Ложь;
	Элементы.СтраницаРуководители.Видимость = Ложь;
	
	Элементы.ОтборПапка.Видимость = Истина;
	Элементы.ОтборРуководитель.Видимость = Истина;
	Элементы.ОтборЗаказчик.Видимость = Истина;
	Элементы.ОтборВидПроекта.Видимость = Истина;
	
	Элементы.РежимПросмотраСписком.Пометка = Ложь;
	Элементы.РежимПросмотраПоПапкам.Пометка = Ложь;
	Элементы.РежимПросмотраПоВидам.Пометка = Ложь;
	Элементы.РежимПросмотраПоЗаказчикам.Пометка = Ложь;
	Элементы.РежимПросмотраПоРуководителям.Пометка = Ложь;
	
	Если ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.Списком Тогда
		
		Элементы.РежимПросмотраСписком.Пометка = Истина;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПапкам Тогда
		
		Элементы.ОтборПапка.Видимость = Ложь;
		Элементы.СтраницаПапки.Видимость = Истина;
		Элементы.РежимПросмотраПоПапкам.Пометка = Истина;
		
		Список.Параметры.УстановитьЗначениеПараметра("Папка", Неопределено);
		Элементы.Папки.ТекущаяСтрока = ТекущаяПапка;
		ТекущаяПапка = Неопределено;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоВидамДокументов Тогда
		
		Элементы.ОтборВидПроекта.Видимость = Ложь;
		Элементы.СтраницаВиды.Видимость = Истина;
		Элементы.РежимПросмотраПоВидам.Пометка = Истина;
		
		Список.Параметры.УстановитьЗначениеПараметра("ВидПроекта", Неопределено);
		Элементы.ВидыПроектов.ТекущаяСтрока = ТекущийВидПроекта;
		ТекущийВидПроекта = Неопределено;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоКонтрагентам Тогда
		
		Элементы.ОтборЗаказчик.Видимость = Ложь;
		Элементы.СтраницаЗаказчики.Видимость = Истина;
		Элементы.РежимПросмотраПоЗаказчикам.Пометка = Истина;
		
		Список.Параметры.УстановитьЗначениеПараметра("Заказчик", Неопределено);
		Элементы.Заказчики.ТекущаяСтрока = ТекущийЗаказчик;
		ТекущийКонтрагент = Неопределено;
		
	ИначеЕсли ВидПросмотра = Перечисления.ВидыПросмотраСпискаОбъектов.ПоПользователям Тогда
		
		Элементы.ОтборРуководитель.Видимость = Ложь;
		Элементы.СтраницаРуководители.Видимость = Истина;
		Элементы.РежимПросмотраПоРуководителям.Пометка = Истина;
		
		Список.Параметры.УстановитьЗначениеПараметра("Руководитель", Неопределено);
		Элементы.Руководители.ТекущаяСтрока = ТекущийРуководитель;
		ТекущийКонтрагент = Неопределено;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	УстановитьПараметрыСписка();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЗаказчиков()
	
	ДеревоЗаказчики = РеквизитФормыВЗначение("Заказчики");
	ДеревоЗаказчики.Строки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Проекты.Заказчик КАК Ссылка,
	|	Проекты.Заказчик.ПометкаУдаления КАК ПометкаУдаления,
	|	Проекты.Заказчик.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Проекты КАК Проекты
	|ГДЕ
	|	НЕ Проекты.ЭтоГруппа
	|	И Проекты.Заказчик <> НЕОПРЕДЕЛЕНО
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(Выборка.Наименование) Тогда 
			Продолжить;
		КонецЕсли;	
		Если Не ПоказыватьУдаленные И Выборка.ПометкаУдаления Тогда 
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ДеревоЗаказчики.Строки.Добавить();
		НоваяСтрока.Ссылка = Выборка.Ссылка;
		НоваяСтрока.Наименование = Выборка.Наименование;
		НоваяСтрока.ПометкаУдаления = Выборка.ПометкаУдаления;
		НоваяСтрока.ИндексКартинки = ?(Выборка.ПометкаУдаления, 4, 3);
	КонецЦикла;	
	
	ЗначениеВРеквизитФормы(ДеревоЗаказчики,"Заказчики");
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Хронометраж

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения) Экспорт
	
	Если ТекущийПроект = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УчетВремени.ПереключитьХронометражСервер(
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ТекущийПроект,
		ВидыРабот,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
	    ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьХронометражСервер() Экспорт
	
	Если ТекущийПроект = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УчетВремени.ОтключитьХронометражСервер(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ТекущийПроект,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыУчетаВремениВФорме()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Элементы.ПереключитьХронометраж.Доступность = Ложь;
		Элементы.УказатьТрудозатраты.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	ТекущийПроект = ТекущиеДанные.Ссылка;
	
	ПараметрыУчетаВремени = ПолучитьПараметрыУчетаВремени(ТекущиеДанные.Ссылка);
	
	ДатаНачалаХронометража = ПараметрыУчетаВремени.ДатаНачалаХронометража;
	ДатаКонцаХронометража = ПараметрыУчетаВремени.ДатаКонцаХронометража;
	ВключенХронометраж = ПараметрыУчетаВремени.ВключенХронометраж;
	ОпцияИспользоватьУчетВремени = ПараметрыУчетаВремени.ОпцияИспользоватьУчетВремени;
	ВидыРабот = ПараметрыУчетаВремени.ВидыРабот;
	СпособУказанияВремени = ПараметрыУчетаВремени.СпособУказанияВремени;
	
	Для Каждого СвойствоЭлемента Из ПараметрыУчетаВремени.ПереключитьХронометраж Цикл
		Элементы.ПереключитьХронометраж[СвойствоЭлемента.Ключ] = СвойствоЭлемента.Значение;
	КонецЦикла;
	
	Для Каждого СвойствоЭлемента Из ПараметрыУчетаВремени.УказатьТрудозатраты Цикл
		Элементы.УказатьТрудозатраты[СвойствоЭлемента.Ключ] = СвойствоЭлемента.Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыУчетаВремени(Документ)
	
	Результат = Новый Структура;
	
	ДатаНачалаХронометража = Неопределено;
	ДатаКонцаХронометража = Неопределено;
	ВключенХронометраж = Неопределено;
	ОпцияИспользоватьУчетВремени = Неопределено;
	ВидыРабот = Неопределено;
	СпособУказанияВремени = Неопределено;
	
	ПереключитьХронометражНеМеняяПодсказку = Новый Структура("Имя, Подсказка");
	
	ПереключитьХронометраж = Новый Структура("Доступность, Пометка, Видимость");
	ПереключитьХронометраж.Доступность = Истина;
	
	УказатьТрудозатраты = Новый Структура("Доступность");
	УказатьТрудозатраты.Доступность = Истина;
	
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Документ,
		ВидыРабот,
		СпособУказанияВремени,
		ПереключитьХронометражНеМеняяПодсказку,
		ПереключитьХронометраж,
		УказатьТрудозатраты);
		
	Результат.Вставить("ПереключитьХронометраж", Новый Соответствие);
	Результат.Вставить("УказатьТрудозатраты", Новый Соответствие);
	
	Результат.ПереключитьХронометраж.Вставить(
		"Доступность",
		ПереключитьХронометраж.Доступность);
	Результат.ПереключитьХронометраж.Вставить(
		"Пометка",
		ПереключитьХронометраж.Пометка);
	Результат.УказатьТрудозатраты.Вставить(
		"Доступность",
		УказатьТрудозатраты.Доступность);
	
	Результат.Вставить("ДатаНачалаХронометража", ДатаНачалаХронометража);
	Результат.Вставить("ДатаКонцаХронометража", ДатаКонцаХронометража);
	Результат.Вставить("ВключенХронометраж", ВключенХронометраж);
	Результат.Вставить("ОпцияИспользоватьУчетВремени", ОпцияИспользоватьУчетВремени);
	Результат.Вставить("ВидыРабот", ВидыРабот);
	Результат.Вставить("СпособУказанияВремени", СпособУказанияВремени);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
