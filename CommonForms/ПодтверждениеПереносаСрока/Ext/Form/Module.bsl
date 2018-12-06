﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Элементы.ПричинаПереносаСрока.Видимость = Параметры.ЗапрашиватьПричинуПереносаСроков;
	
	Заголовок = НСтр("ru = 'Перенос срока исполнения процессов'; en = 'Processes postponement'");
	
	Если ЗначениеЗаполнено(Параметры.АдресХранилищаСРассчитаннымиСроками) Тогда
		
		РассчитанныеДанные = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаСРассчитаннымиСроками);
		
		СтрВедущегоПроцессаВДереве = 
			ДобавитьВедущийПроцессВДерево(РассчитанныеДанные);
		
		ДобавитьПодчиненныеПроцессы(
			РассчитанныеДанные.Сроки, СтрВедущегоПроцессаВДереве.ПолучитьЭлементы());
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.Процесс) Тогда
		
		Элементы.ГруппаДеревоПроцессов.Видимость = Истина;
		ФорматСроков = СрокиИсполненияПроцессовКлиентСервер.ФорматДатыСроковПроцессовИЗадач(
			ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач"));
		Элементы.ПроцессыСтарыйСрок.Формат = ФорматСроков;
		Элементы.ПроцессыНовыйСрок.Формат = ФорматСроков;
		
		Если Параметры.СформироватьДеревоВышестоящихПроцессовСНовымиСроками Тогда
			ЗаполнитьДеревоПроцессов(Параметры.Процесс, Параметры.НовыйСрокИсполнения);
		Иначе
			ЭлементыДерева = Процессы.ПолучитьЭлементы();
			СтрокаДерева = ЭлементыДерева.Добавить();
			СтрокаДерева.Процесс = Параметры.Процесс;
			СтрокаДерева.СтарыйСрок = 
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Процесс, "СрокИсполненияПроцесса");
			СтрокаДерева.НовыйСрок = Параметры.НовыйСрокИсполнения;
			СтрокаДерева.СрокПроцессаИзменен = СтрокаДерева.СтарыйСрок <> СтрокаДерева.НовыйСрок;
		КонецЕсли;
		
	Иначе
		Заголовок = НСтр("ru = 'Перенос срока исполнения задач'; en = 'Tasks postponement'");
		Элементы.ГруппаДеревоПроцессов.Видимость = Ложь;
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = "";
	Если Элементы.ГруппаДеревоПроцессов.Видимость Тогда
		КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "ОтображениеДереваПроцессов";
	КонецЕсли;
	Если Параметры.ЗапрашиватьПричинуПереносаСроков Тогда
		КлючСохраненияПоложенияОкна = КлючСохраненияПоложенияОкна + "ЗапрашиватьПричинуПереносаСроков";
	КонецЕсли;
	
	// Условное оформление для дерева процессов
	Эл = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		УсловноеОформление, НСтр("ru = 'Срок процесса изменен'; en = 'Date process change'"));
	ЭлементОтбораДанных = Эл.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Процессы.СрокПроцессаИзменен");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОформления = Эл.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементОформления.Значение = ЦветаСтиля.НедоступныеДанныеЦвет;
	ЭлементОформления.Использование = Истина;
	
	Поле = Эл.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("Процессы");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Процессы

&НаКлиенте
Процедура ПроцессыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Процессы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФормыПроцесса = ИмяФормыПроцесса(ТекущиеДанные.Процесс);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.Процесс);
	ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	ОткрытьФорму(ИмяФормыПроцесса, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Процессы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФормыПроцесса = ИмяФормыПроцесса(ТекущиеДанные.Процесс);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.Процесс);
	ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	ОткрытьФорму(ИмяФормыПроцесса, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодтвердитьПереносСрока(Команда)
	
	Если Параметры.ЗапрашиватьПричинуПереносаСроков Тогда
		
		Если Не ЗначениеЗаполнено(ПричинаПереносаСрока) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не указана причина переноса срока.'; en = 'Reason for postponing is not specified.'"),,
				"ПричинаПереносаСрока");
				
			Возврат;
		КонецЕсли;
		
		Закрыть(ПричинаПереносаСрока);
	Иначе
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоПроцессов(Процесс, НовыйСрокИсполнения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЭтоШаблон = ШаблоныБизнесПроцессовКлиентСервер.ЭтоШаблонПроцесса(Процесс);
	
	ВедущийПроцесс = Неопределено;
	ВедущийПроцессЯвляетсяКомплексным = Ложь;
	
	Если ЭтоШаблон Тогда
		ВедущийПроцесс = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Процесс, "ВладелецШаблона");
		ВедущийПроцессЯвляетсяКомплексным = Истина;
	Иначе
		ВедущаяЗадача = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Процесс, "ВедущаяЗадача");
		Если ЗначениеЗаполнено(ВедущаяЗадача) Тогда
			ВедущийПроцесс = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВедущаяЗадача, "БизнесПроцесс");
		КонецЕсли;
		Если ТипЗнч(ВедущийПроцесс) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
			ВедущийПроцессЯвляетсяКомплексным = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВедущийПроцесс) Тогда
		СтрДерева = Процессы.ПолучитьЭлементы().Добавить();
		СтрДерева.Процесс = Процесс;
		СтрДерева.СтарыйСрок = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Процесс, "СрокИсполненияПроцесса");
		СтрДерева.НовыйСрок = НовыйСрокИсполнения;
	ИначеЕсли ВедущийПроцессЯвляетсяКомплексным Тогда
		
		ИдентификаторыИзмененныхДействий = Новый Массив;
		
		НовыйВедущийПроцесс = ВедущийПроцесс;
		ВедущийПроцесс = Процесс;
		
		Пока ЗначениеЗаполнено(НовыйВедущийПроцесс) Цикл
			
			РеквизитыВедущегоПроцесса = 
				ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НовыйВедущийПроцесс, "ИдентификаторСсылки, Схема, Этапы");
			
			Если ЗначениеЗаполнено(РеквизитыВедущегоПроцесса.Схема) Тогда
				ПараметрыДействий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
					РеквизитыВедущегоПроцесса.Схема, "ПараметрыДействий").Выгрузить();
				ИмяРеквизитаШаблон = "ШаблонПроцесса";
				ИмяРеквизитаПроцесс = "Процесс";
				ИмяРеквизитаИдентификатор = "Имя";
			Иначе
				ПараметрыДействий = РеквизитыВедущегоПроцесса.Этапы.Выгрузить();
				ИмяРеквизитаШаблон = "ШаблонБизнесПроцесса";
				ИмяРеквизитаПроцесс = "ЗапущенныйБизнесПроцесс";
				ИмяРеквизитаИдентификатор = "ИдентификаторЭтапа";
			КонецЕсли;
			
			Если ШаблоныБизнесПроцессовКлиентСервер.ЭтоШаблонПроцесса(ВедущийПроцесс) Тогда
				ПараметрыДействия = ПараметрыДействий.Найти(ВедущийПроцесс, ИмяРеквизитаШаблон);
			Иначе
				ПараметрыДействия = ПараметрыДействий.Найти(ВедущийПроцесс, ИмяРеквизитаПроцесс);
			КонецЕсли;
			
			Если ПараметрыДействия = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
			Если ВедущийПроцесс = Процесс Тогда
				Если ЗначениеЗаполнено(РеквизитыВедущегоПроцесса.Схема) Тогда
					ИдентификаторИзмененногоДействия = 
						Строка(РеквизитыВедущегоПроцесса.ИдентификаторСсылки)
						+ "_"
						+ ПараметрыДействия[ИмяРеквизитаИдентификатор];
				Иначе
					ИдентификаторИзмененногоДействия = ПараметрыДействия[ИмяРеквизитаИдентификатор];
				КонецЕсли;
				ИдентификаторыИзмененныхДействий.Добавить(ИдентификаторИзмененногоДействия);
			КонецЕсли;
			
			ВедущийПроцесс = НовыйВедущийПроцесс;
			
			Если ШаблоныБизнесПроцессовКлиентСервер.ЭтоШаблонПроцесса(НовыйВедущийПроцесс) Тогда
				НовыйВедущийПроцесс = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НовыйВедущийПроцесс, "ВладелецШаблона");
			Иначе
				ВедущаяЗадача = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НовыйВедущийПроцесс, "ВедущаяЗадача");
				Если ЗначениеЗаполнено(ВедущаяЗадача) Тогда
					НовыйВедущийПроцесс = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВедущаяЗадача, "БизнесПроцесс");
				Иначе
					НовыйВедущийПроцесс = Неопределено;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		ДатаОтсчета = СрокиИсполненияПроцессов.ДатаОтсчетаДляРасчетаСроковПроцесса(ВедущийПроцесс);
		
		СтруктураДляРасчетаСроков = 
			СрокиИсполненияПроцессовКОРП.СтруктураДляРасчетаСрокаКомплексногоПроцесса(ВедущийПроцесс);
		
		ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
		ПараметрыДляРасчетаСроков.ДатаОтсчета = ДатаОтсчета;
		
		ДанныеДляРасчетаСроков = СрокиИсполненияПроцессовКОРП.ДанныеДляРасчетаСроковКомплексногоПроцесса(
			СтруктураДляРасчетаСроков, ПараметрыДляРасчетаСроков, ИдентификаторыИзмененныхДействий);
		
		УстановитьНовыйСрокПроцессаВТаблицеСроков(
			ДанныеДляРасчетаСроков.Сроки, Процесс, НовыйСрокИсполнения);
		
		СрокиИсполненияПроцессов.РассчитатьСрокиИсполнения(
			ДанныеДляРасчетаСроков.Сроки, ДанныеДляРасчетаСроков.Предшественники,
			ДанныеДляРасчетаСроков.IDРассчитанногоСрок);
		
		СтрВедущегоПроцессаВДереве = 
			ДобавитьВедущийПроцессВДерево(ДанныеДляРасчетаСроков);
		
		ДобавитьПодчиненныеПроцессы(
			ДанныеДляРасчетаСроков.Сроки, СтрВедущегоПроцессаВДереве.ПолучитьЭлементы());
	Иначе
		
		ДатаОтсчета = СрокиИсполненияПроцессов.ДатаОтсчетаДляРасчетаСроковПроцесса(ВедущийПроцесс);
		
		СтруктураДляРасчетаСроков = 
			СрокиИсполненияПроцессов.СтруктураДляРасчетаСрокаСоставногоПроцесса(ВедущийПроцесс);
			
		ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
		ПараметрыДляРасчетаСроков.ДатаОтсчета = ДатаОтсчета;
			
		ДанныеДляРасчетаСроков = СрокиИсполненияПроцессов.ДанныеДляРасчетаСроковСоставногоПроцесса(
			СтруктураДляРасчетаСроков, ПараметрыДляРасчетаСроков);
		
		УстановитьНовыйСрокПроцессаВТаблицеСроков(
			ДанныеДляРасчетаСроков.Сроки, Процесс, НовыйСрокИсполнения);
		
		СрокиИсполненияПроцессов.РассчитатьСрокиИсполнения(
			ДанныеДляРасчетаСроков.Сроки, ДанныеДляРасчетаСроков.Предшественники,
			ДанныеДляРасчетаСроков.IDРассчитанногоСрок);
		
		СтрВедущегоПроцессаВДереве = 
			ДобавитьВедущийПроцессВДерево(ДанныеДляРасчетаСроков);
		
		ДобавитьПодчиненныеПроцессы(
			ДанныеДляРасчетаСроков.Сроки, СтрВедущегоПроцессаВДереве.ПолучитьЭлементы());
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНовыйСрокПроцессаВТаблицеСроков(
	Сроки, Процесс, НовыйСрок, СрокУстановлен = Ложь)
	
	Для Каждого СтрСрок Из Сроки Цикл
		
		Если СрокУстановлен Тогда
			Прервать;
		КонецЕсли;
		
		Если СтрСрок.ПодчиненныеСроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
			
		Если СтрСрок.ПодчиненныеСроки.Ссылка = Процесс Тогда
			СтрСрок.СрокИсполнения = НовыйСрок;
			СтрСрок.Пройден = Истина;
			СрокУстановлен = Истина;
		Иначе
			УстановитьНовыйСрокПроцессаВТаблицеСроков(
				СтрСрок.ПодчиненныеСроки.Сроки, Процесс, НовыйСрок, СрокУстановлен);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьВедущийПроцессВДерево(ДанныеДляРасчетаСроков)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтрДерева = Процессы.ПолучитьЭлементы().Добавить();
	СтрДерева.Процесс = ДанныеДляРасчетаСроков.Ссылка;
	СтрДерева.СтарыйСрок = ДанныеДляРасчетаСроков.ИсходныйСрокИсполнения;
	
	СрокИсполненияПроцесса = Дата(1,1,1);
	Для Каждого СтрСрок Из ДанныеДляРасчетаСроков.Сроки Цикл
		СрокИсполненияПроцесса = Макс(СрокИсполненияПроцесса, СтрСрок.СрокИсполнения);
	КонецЦикла;
	СтрДерева.НовыйСрок = СрокИсполненияПроцесса;
	
	СтрДерева.СрокПроцессаИзменен = 
		(СтрДерева.СтарыйСрок <> СтрДерева.НовыйСрок);
	
	Возврат СтрДерева;
	
КонецФункции

&НаСервере
Процедура ДобавитьПодчиненныеПроцессы(Сроки, ДеревоПроцессов)
	
	Для Каждого СтрСрок Из Сроки Цикл
		
		Если СтрСрок.ПодчиненныеСроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрДерева = ДеревоПроцессов.Добавить();
		СтрДерева.Процесс = СтрСрок.ПодчиненныеСроки.Ссылка;
		СтрДерева.СтарыйСрок = СтрСрок.ПодчиненныеСроки.ИсходныйСрокИсполнения;
		СтрДерева.НовыйСрок = СтрСрок.СрокИсполнения;
		
		СтрДерева.СрокПроцессаИзменен = 
			(СтрДерева.СтарыйСрок <> СтрДерева.НовыйСрок);
		
		ДобавитьПодчиненныеПроцессы(
			СтрСрок.ПодчиненныеСроки.Сроки, СтрДерева.ПолучитьЭлементы());
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяФормыПроцесса(Процесс)
	
	Если ОбщегоНазначения.ЭтоБизнесПроцесс(Процесс.Метаданные()) Тогда
		ТипОбъекта = "БизнесПроцесс";
	Иначе
		ТипОбъекта = "Справочник";
	КонецЕсли;
	
	ИмяФормыДляОткрытияКарточкиПроцесса = ТипОбъекта
		+ "."
		+ Процесс.Метаданные().Имя
		+ ".ФормаОбъекта";
	
	Возврат ИмяФормыДляОткрытияКарточкиПроцесса;
	
КонецФункции

#КонецОбласти
