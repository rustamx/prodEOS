﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ПоТипуПроцесса.СписокВыбора.Очистить();
	
	//Заполнение списка типов процессов
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("ВсеТипы", НСтр("ru = 'Все типы'; en = 'All types'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("Исполнение", НСтр("ru = 'Исполнение'; en = 'Performance'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("Ознакомление", НСтр("ru = 'Ознакомление'; en = 'Examination'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("Поручение", НСтр("ru = 'Поручение'; en = 'Order'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("Рассмотрение", НСтр("ru = 'Рассмотрение'; en = 'Reviewal'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("Регистрация", НСтр("ru = 'Регистрация'; en = 'Registration'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("Согласование", НСтр("ru = 'Согласование'; en = 'Approval'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("Утверждение", НСтр("ru = 'Утверждение'; en = 'Confirmation'"));
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПриглашениеНаМероприятие") Тогда 
		Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("Приглашение", НСтр("ru = 'Приглашение'; en = 'Invitation'"));
	КонецЕсли;	
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("КомплексныйПроцесс", НСтр("ru = 'Комплексный процесс'; en = 'Composite process'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("ОбработкаВнутреннегоДокумента", 
		НСтр("ru = 'Обработка внутреннего документа'; en = 'Internal document processing'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("ОбработкаВходящегоДокумента", 
		НСтр("ru = 'Обработка входящего документа'; en = 'Incoming document processing'"));
	Элементы.ПоТипуПроцесса.СписокВыбора.Добавить("ОбработкаИсходящегоДокумента", 
		НСтр("ru = 'Обработка исходящего документа'; en = 'Outgoing document processing'"));
	
	ТекущаяДата = НачалоДня(ТекущаяДатаСеанса());
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДата);
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеБизнесПроцессов(Список.УсловноеОформление);
	
	Если ЗначениеЗаполнено(Параметры.ТипПроцесса) Тогда
		ПоТипуПроцесса = Параметры.ТипПроцесса;
		ПоСостоянию = "Активные";
		Элементы.ПоТипуПроцесса.ТолькоПросмотр = Истина;
		
	Иначе
		
		ПоТипуПроцесса = ХранилищеНастроекДанныхФорм.Загрузить("СписокПроцессов", "ТекущийТипПроцесса");
		Если Не ЗначениеЗаполнено(ПоТипуПроцесса) Тогда
			ПоТипуПроцесса = "ВсеТипы";
		КонецЕсли;
		
		ПоСостоянию = ХранилищеНастроекДанныхФорм.Загрузить("СписокПроцессов", "ПоСостоянию");
		Если НЕ ЗначениеЗаполнено(ПоСостоянию) Тогда
			ПоСостоянию = "Активные";
		ИначеЕсли ПоСостоянию = "Все состояния" Тогда
			ПоСостоянию = "ВсеСостояния";
		КонецЕсли;
		
		ПоИсполнителю = ХранилищеНастроекДанныхФорм.Загрузить("СписокПроцессов", "ПоИсполнителю");
		
		Если НЕ ЗначениеЗаполнено(ПоИсполнителю) Тогда
			ПоИсполнителю = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда
			ПоПроекту = ХранилищеНастроекДанныхФорм.Загрузить("СписокПроцессов", "ПоПроекту");
		КонецЕсли;
		
	КонецЕсли;
	
	// Контроль.
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Элементы.СостояниеКонтроля.Видимость = Ложь;
	КонецЕсли;
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	ФорматДатыДляКолонок = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДФ='dd.MM.yyyy HH:mm'", "ДЛФ=D");
	Элементы.Дата.Формат = ФорматДатыДляКолонок;
	Элементы.СрокИсполнения.Формат = ФорматДатыДляКолонок;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьВидимостьЭлементовПоТипу();
	ОбновитьВидимостьКомандПоСостоянию();
	ОбновитьВидимостьКнопокОчистки();
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.ТипПроцесса) Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "БизнесПроцессИзменен"
		ИЛИ ИмяСобытия = "ЗадачаИзменена" Тогда
		
		Элементы.Список.Обновить();
		УстановитьДоступностьКоманд();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаписьКонтроля" Тогда
		Если ЗначениеЗаполнено(Параметр.Предмет) Тогда
			ОповеститьОбИзменении(Параметр.Предмет);
			ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ДанныеБизнесПроцессов"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КартаПроцесса(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Процесс = Элементы.Список.ТекущиеДанные.Ссылка;
	Если ТипЗнч(Процесс) <> Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		ОткрытьФорму("Обработка.КартаМаршрутаБизнесПроцесса.Форма", 
			Новый Структура("БизнесПроцесс", Процесс));
	Иначе
		ОткрытьФорму("БизнесПроцесс.КомплексныйПроцесс.Форма.ФормаСхемаПроцесса",
			Новый Структура("ПараметрКоманды", Процесс));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьПроцесс(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Предмет = ТекущиеДанные.Ссылка;
		КомандыРаботыСБизнесПроцессамиКлиент.ПрерватьБизнесПроцесс(ТекущиеДанные.Ссылка, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", ТекущиеДанные.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)
	
	МассивСсылок = ПолучитьМассивСсылок(Элементы.Список.ВыделенныеСтроки);
	Если МассивСсылок.Количество() > 0 Тогда
		КомандыРаботыСБизнесПроцессамиКлиент.Остановить(МассивСсылок, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс(Команда)
	
	МассивСсылок = ПолучитьМассивСсылок(Элементы.Список.ВыделенныеСтроки);
	Если МассивСсылок.Количество() > 0 Тогда
		КомандыРаботыСБизнесПроцессамиКлиент.СделатьАктивным(МассивСсылок, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПовторение(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПовторениеБизнесПроцессовКлиент.НастроитьПовторение(ТекущиеДанные.Ссылка, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Контроль(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		КонтрольКлиент.ОбработкаКомандыКонтроль(ТекущиеДанные.Ссылка, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьБыстрыеОтборы(Команда)
	
	ПоСостоянию = "ВсеСостояния";
	ПоТипуПроцесса = "ВсеТипы";
	ПоИсполнителю = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	ПоПроекту = ПредопределенноеЗначение("Справочник.Проекты.ПустаяСсылка");
	
	ОбновитьВидимостьКнопокОчистки();
	ОбновитьВидимостьКомандПоСостоянию();
	ОбновитьВидимостьЭлементовПоТипу();
	
	ПодключитьОбработчикОжидания("ОбновитьСписок", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчеты(Команда)
		
	Раздел = ПредопределенноеЗначение("Перечисление.РазделыОтчетов.ПроцессыСписок");
	
	ЗаголовокФормы = НСтр("ru = 'Отчеты по процессам'; en = 'Reports on processes'");
	
	РазделГипперссылка = НастройкиВариантовОтчетовДокументооборот.ПолучитьРазделОтчетаПоИмени("УправлениеБизнесПроцессами");
		
	ПараметрыФормы = Новый Структура("Раздел, ЗаголовокФормы, НеОтображатьИерархию, РазделГипперссылка", 
										Раздел, ЗаголовокФормы, Истина, РазделГипперссылка);
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма, 
		"ПроцессыСписок");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоТипуПроцессаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоТипуПроцесса = "ВсеТипы";
	ОбновитьВидимостьЭлементовПоТипу();
	ОбновитьВидимостьКнопокОчистки();
	ПодключитьОбработчикОжидания("ОбновитьСписок", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоТипуПроцессаПриИзменении(Элемент)
	
	ОбновитьВидимостьЭлементовПоТипу();
	ОбновитьВидимостьКнопокОчистки();
	ПодключитьОбработчикОжидания("ОбновитьСписок", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоСостояниюОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоСостоянию = "ВсеСостояния";
	ОбновитьВидимостьКомандПоСостоянию();
	ОбновитьВидимостьКнопокОчистки();
	ПодключитьОбработчикОжидания("ОбновитьСписок", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоСостояниюПриИзменении(Элемент)
	
	ОбновитьВидимостьКомандПоСостоянию();
	ОбновитьВидимостьКнопокОчистки();
	ПодключитьОбработчикОжидания("ОбновитьСписок", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПроектуПриИзменении(Элемент)
	
	ОбновитьВидимостьКнопокОчистки();
	
	ПодключитьОбработчикОжидания("ОбновитьСписок", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_ПоИсполнителю

&НаКлиенте
Процедура ПоИсполнителюПриИзменении(Элемент)
	
	ОбновитьВидимостьКнопокОчистки();
	
	ПодключитьОбработчикОжидания("ОбновитьСписок", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникНачалоВыбора(
		Элемент, ПоИсполнителю, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОчистка(Элемент, СтандартнаяОбработка)
	
	ПоИсполнителю = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьДоступностьКоманд", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "СостояниеКонтроля" Тогда
		КонтрольКлиент.ОбработкаКомандыКонтроль(ТекущиеДанные.Ссылка, ЭтаФорма);
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, 
	Группа, Параметр)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ЗначениеКопирования = ТекущиеДанные.Ссылка;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначениеКопирования", ЗначениеКопирования);
		// Получим имя формы без серверного вызова.
		Если ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.Исполнение") Тогда
			ИмяТипа = "Исполнение";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.ОбработкаВнутреннегоДокумента") Тогда
			ИмяТипа = "ОбработкаВнутреннегоДокумента";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.ОбработкаВходящегоДокумента") Тогда
			ИмяТипа = "ОбработкаВходящегоДокумента";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.ОбработкаИсходящегоДокумента") Тогда
			ИмяТипа = "ОбработкаИсходящегоДокумента";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.Ознакомление") Тогда
			ИмяТипа = "Ознакомление";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.Поручение") Тогда
			ИмяТипа = "Поручение";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.Рассмотрение") Тогда
			ИмяТипа = "Рассмотрение";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.Регистрация") Тогда
			ИмяТипа = "Регистрация";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.Согласование") Тогда
			ИмяТипа = "Согласование";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.Утверждение") Тогда
			ИмяТипа = "Утверждение";
		// КОРП.
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
			ИмяТипа = "КомплексныйПроцесс";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.Приглашение") Тогда
			ИмяТипа = "Приглашение";
		ИначеЕсли ТипЗнч(ЗначениеКопирования) = Тип("БизнесПроцессСсылка.РешениеВопросовВыполненияЗадач") Тогда
			ИмяТипа = "РешениеВопросовВыполненияЗадач";
		Иначе
			Возврат;
		КонецЕсли;
		ОткрытьФорму("БизнесПроцесс." + ИмяТипа + ".ФормаОбъекта", ПараметрыФормы, ЭтаФорма, 
			ЗначениеКопирования.УникальныйИдентификатор());
		
	Иначе // создание
			
		ПараметрыФормы = Новый Структура;
		Если ПоТипуПроцесса <> "ВсеТипы"
			и ПоТипуПроцесса <> "Поручение"
			и ПоТипуПроцесса <> "ОбработкаВходящегоДокумента"
			и ПоТипуПроцесса <> "ОбработкаВнутреннегоДокумента"
			и ПоТипуПроцесса <> "ОбработкаИсходящегоДокумента" Тогда
			ПараметрыФормы.Вставить("ТипыПроцессов", ПоТипуПроцесса);
		КонецЕсли;
		Если ЗначениеЗаполнено(ПоПроекту) Тогда
			ПараметрыФормы.Вставить("Проект", ПоПроекту);
		КонецЕсли;
		ОткрытьФорму("ОбщаяФорма.СозданиеБизнесПроцесса", ПараметрыФормы);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПроцессыДляПометкиНаУдаление = Новый Массив;
	ПроцессыДляСнятияПометкиУдаления = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		ДанныеВыделеннойСтроки = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		Если ДанныеВыделеннойСтроки.ПометкаУдаления Тогда
			ПроцессыДляСнятияПометкиУдаления.Добавить(ДанныеВыделеннойСтроки.Ссылка);
		Иначе
			ПроцессыДляПометкиНаУдаление.Добавить(ДанныеВыделеннойСтроки.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	КоличествоПроцессовДляСнятияПометкиУдаления = ПроцессыДляСнятияПометкиУдаления.Количество();
	КоличествоПроцессовДляПометкиНаУдаление = ПроцессыДляПометкиНаУдаление.Количество();
	
	ПроцессыДляОбработки = Неопределено;
	
	Если КоличествоПроцессовДляСнятияПометкиУдаления > 0 Тогда
		Если КоличествоПроцессовДляСнятияПометкиУдаления = 1 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Снять с ""%1"" пометку на удаление?'; en = 'Remove deletion mark from ""%1""?'"),
				ПроцессыДляСнятияПометкиУдаления[0]);
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Снять с выделенных процессов (%1) пометку на удаление?'; en = 'Remove deletion mark from the selected processes (%1)?'"),
				КоличествоПроцессовДляСнятияПометкиУдаления);
		КонецЕсли;
		ПроцессыДляОбработки = ПроцессыДляСнятияПометкиУдаления;
		
	ИначеЕсли КоличествоПроцессовДляПометкиНаУдаление > 0 Тогда
		Если КоличествоПроцессовДляПометкиНаУдаление = 1 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пометить ""%1"" на удаление?'; en = 'Mark ""%1"" for deletion?'"),
				ПроцессыДляПометкиНаУдаление[0]);
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пометить выделенные процессы (%1) на удаление?'; en = 'Mark selected processes (%1) for deletion?'"),
				КоличествоПроцессовДляПометкиНаУдаление);
		КонецЕсли;
		ПроцессыДляОбработки = ПроцессыДляПометкиНаУдаление;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СписокПередУдалением_Продолжение", ЭтаФорма, ПроцессыДляОбработки);
	
	ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(
		ОписаниеОповещения, ТекстВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением_Продолжение(Ответ, ПроцессыДляОбработки) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПометкиУдаления = ПометитьНаУдалениеПроцессы(ПроцессыДляОбработки);
	
	Если ЗначениеЗаполнено(РезультатПометкиУдаления) Тогда
		ПоказатьПредупреждение(, РезультатПометкиУдаления);
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДоступностьКоманд()
	
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборНаСервере(
	ПоТипуПроцесса,
	ПоСостоянию, 
	ПоИсполнителю, 
	ПоПроекту)
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоТипуПроцесса", ПоТипуПроцесса);
	ПараметрыОтбора.Вставить("ПоСостоянию", ПоСостоянию);
	ПараметрыОтбора.Вставить("ПоИсполнителю", ПоИсполнителю);
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда
		ПараметрыОтбора.Вставить("ПоПроекту", ПоПроекту);
	КонецЕсли;
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	Элементы.Список.Обновить();
	
КонецПроцедуры

// Устанавливает дополнительные параметры для динамического списка
// по которым отбираются записи
//
// Параметры:
//   - Список - динамический список формы
//   - ПараметрыОтбора - Соответствие - параметры для установки отбора:
//        - ПоСостоянию - Строка - см. допустимые значения в элементе формы
//        - ПоПроекту - СправочникСсылка.Проекты
//        - ПоИсполнителю - СправочникСсылка.Пользователи или СправочникСсылка.ПолныеРоли
//
&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	// Отбор по типу процесса
	ПоТипуПроцесса = ПараметрыОтбора["ПоТипуПроцесса"];
	ПараметрПоТипуПроцесса = Список.Параметры.Элементы.Найти("ПоТипуПроцесса");
	ПараметрПоТипуПроцесса.Использование = (ПоТипуПроцесса <> "ВсеТипы");
	ПараметрПоТипуПроцесса.Значение = ПоТипуПроцесса;
	
	// Отбор по состоянию
	ПоСостоянию = ПараметрыОтбора["ПоСостоянию"];
	ПараметрПоСостоянию = Список.Параметры.Элементы.Найти("ПоСостоянию");
	ПараметрПоСостоянию.Использование = Истина;
	ПараметрПоСостоянию.Значение = ПоСостоянию;
	ПараметрТекущаяДатаСеанса = Список.Параметры.Элементы.Найти("ТекущаяДатаСеанса");
	ПараметрТекущаяДатаСеанса.Использование = Истина;
	ПараметрТекущаяДатаСеанса.Значение = ТекущаяДатаСеанса();
	
	// Отбор по исполнителю
	ПараметрИсполнитель = Список.Параметры.Элементы.Найти("Исполнитель");
	ПоИсполнителю = ПараметрыОтбора["ПоИсполнителю"];
	
	ПараметрРольИсполнителя = Список.Параметры.Элементы.Найти("РольИсполнителя");
	
	ПараметрИсполнитель.Использование = Ложь;
	ПараметрРольИсполнителя.Использование = Ложь;
	
	Если ЗначениеЗаполнено(ПоИсполнителю) Тогда
		Если ТипЗнч(ПоИсполнителю) = Тип("СправочникСсылка.ПолныеРоли") Тогда
			ПараметрРольИсполнителя.Использование = Истина;
			ПараметрРольИсполнителя.Значение = ПоИсполнителю;
		Иначе
			ПараметрИсполнитель.Использование = Истина;
			ПараметрИсполнитель.Значение = ПоИсполнителю;
		КонецЕсли;
	КонецЕсли;

	// Отбор по проекту
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда
		ПараметрПроект = Список.Параметры.Элементы.Найти("Проект");
		Если ПараметрыОтбора["ПоПроекту"] <> Неопределено 
			И ПараметрыОтбора["ПоПроекту"].Пустая() Тогда
			ПараметрПроект.Использование = Ложь;
		Иначе
			ПараметрПроект.Использование = Истина;
			ПараметрПроект.Значение = ПараметрыОтбора["ПоПроекту"];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок()
	
	ОбновитьСписокСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокСервер()
	
	МетаданныеПроцессы = Метаданные.БизнесПроцессы;
	
	УстановитьПараметрыФункциональныхОпцийФормы(
		Новый Структура(
			"ТипФормыСДополнительнымиОтчетамиИОбработками, ТипОбъектаСДополнительнымиОтчетамиИОбработками", 
			"ФормаСписка",
			"БизнесПроцесс." + ПоТипуПроцесса));
			
	УстановитьОтборНаСервере(
		ПоТипуПроцесса,
		ПоСостоянию, 
		ПоИсполнителю, 
		ПоПроекту);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	ДоступныеДействия = Новый Структура;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ДоступныеДействия.Вставить("Остановить", Ложь);
		ДоступныеДействия.Вставить("Продолжить", Ложь);
		ДоступныеДействия.Вставить("Прервать", Ложь);
		ДоступныеДействия.Вставить("Подписаться", Ложь);
	Иначе	
		
		Если Элементы.Список.ВыделенныеСтроки.Количество() > 1 Тогда
			ДоступныеДействия.Вставить("Остановить", Истина);
			ДоступныеДействия.Вставить("Продолжить", Истина);
			ДоступныеДействия.Вставить("Прервать", Ложь);
			ДоступныеДействия.Вставить("Подписаться", Ложь);
		Иначе
			ДоступныеДействия = 
				РаботаСБизнесПроцессамиКлиент.ДоступныеДействияПоИзменениюСостоянияПроцесса(ТекущиеДанные);
			ДоступныеДействия.Вставить("Прервать", 
				ТекущиеДанные.Состояние <> ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Прерван"));
			ДоступныеДействия.Вставить("Подписаться", 
				НЕ ТекущиеДанные.Завершен
				И ТекущиеДанные.Состояние <> ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Прерван")
			);
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Остановить.Доступность = ДоступныеДействия.Остановить;
	Элементы.ОстановитьКонтекст.Доступность = ДоступныеДействия.Остановить;
	Элементы.Продолжить.Доступность = ДоступныеДействия.Продолжить;
	Элементы.ПродолжитьКонтекст.Доступность = ДоступныеДействия.Продолжить;
	Элементы.Прервать.Доступность = ДоступныеДействия.Прервать;
	Элементы.ПрерватьКонтекст.Доступность = ДоступныеДействия.Прервать;
	Элементы.Подписаться.Доступность = ДоступныеДействия.Подписаться;
	Элементы.ПодписатьсяКонтекст.Доступность = ДоступныеДействия.Подписаться;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьМассивСсылок(Знач ВыделенныеСтроки)
	
	Результат = Новый Массив;
	Для Каждого Идентификатор Из ВыделенныеСтроки Цикл
		Строка = Элементы.Список.ДанныеСтроки(Идентификатор);
		Результат.Добавить(Строка.Ссылка);
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ХранилищеНастроекДанныхФорм.Сохранить(
		"СписокПроцессов",
		"ТекущийТипПроцесса",
		ПоТипуПроцесса);
	ХранилищеНастроекДанныхФорм.Сохранить(
		"СписокПроцессов",
		"ПоСостоянию",
		ПоСостоянию);
	ХранилищеНастроекДанныхФорм.Сохранить(
		"СписокПроцессов",
		"ПоИсполнителю",
		ПоИсполнителю);
		
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда
		ХранилищеНастроекДанныхФорм.Сохранить(
			"СписокПроцессов",
			"ПоПроекту",
			ПоПроекту);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьЭлементовПоТипу()
	
	Элементы.ТипПроцесса.Видимость = (ПоТипуПроцесса = "ВсеТипы");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьКомандПоСостоянию()
	
	Элементы.Продолжить.Видимость = 
		(ПоСостоянию <> "Завершенные" И ПоСостоянию <> "Прерванные");
	Элементы.Прервать.Видимость = 
		(ПоСостоянию <> "Прерванные" И ПоСостоянию <> "Завершенные" И ПоСостоянию <> "Прерванные");
	Элементы.Остановить.Видимость = 
		(ПоСостоянию <> "Остановленные" И ПоСостоянию <> "Завершенные" И ПоСостоянию <> "Прерванные");
	Элементы.Подписаться.Видимость = 
		(ПоСостоянию <> "Завершенные" И ПоСостоянию <> "Прерванные");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПометитьНаУдалениеПроцессы(Процессы)
	
	Результат = "";
	
	ОбщееКоличествоПроцессов = Процессы.Количество();
	КоличествоУдаленныхПроцессов = 0;
	
	ПропускатьИсключения = ОбщееКоличествоПроцессов > 1;
	
	Для Каждого Процесс Из Процессы Цикл
		
		Попытка
			РаботаСБизнесПроцессамиВызовСервера.ПометитьНаУдалениеБизнесПроцесс(Процесс);
			КоличествоУдаленныхПроцессов = КоличествоУдаленныхПроцессов + 1;
		Исключение
			// Если процессов более 1го, тогда маскируем исключения, чтобы не прерывать обработку очереди.
			Если Не ПропускатьИсключения Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Если ПропускатьИсключения
		И КоличествоУдаленныхПроцессов <> ОбщееКоличествоПроцессов Тогда
		
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для %1 из %2 процессов установлена/снята пометка удаления.'; en = 'For %1 of %2 processes deletion mark is set/removed.'"),
			КоличествоУдаленныхПроцессов,
			ОбщееКоличествоПроцессов);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьВидимостьКнопокОчистки()
	
	Элементы.ПоТипуПроцесса.КнопкаОчистки = (ПоТипуПроцесса <> "ВсеТипы");
	Элементы.ПоСостоянию.КнопкаОчистки = (ПоСостоянию <> "ВсеСостояния");
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоИсполнителю, ПоИсполнителю);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоПроекту, ПоПроекту);
	
	Элементы.ОчиститьБыстрыеОтборы.Видимость = (ПоТипуПроцесса <> "ВсеТипы")
		Или (ПоСостоянию <> "ВсеСостояния")
		Или ЗначениеЗаполнено(ПоИсполнителю)
		Или ЗначениеЗаполнено(ПоПроекту);
	
КонецПроцедуры

#КонецОбласти
