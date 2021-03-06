﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура АктуализироватьМассивОбязательныхРеквизитов(МассивРеквизитов, ДокументОбъект) Экспорт
	
	Если ТипЗнч(ДокументОбъект) = Тип("РегистрСведенийНаборЗаписей.ra_PrichinyNesootvetstvij")
		И ДокументОбъект.Количество() = 1
		И Не ДокументОбъект[0].KorennayaPrichina Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(МассивРеквизитов, "TipPrichiny");
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("РегистрСведенийМенеджерЗаписи.ra_PrichinyNesootvetstvij")
		И Не ДокументОбъект.KorennayaPrichina Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(МассивРеквизитов, "TipPrichiny");
	КонецЕсли;
	
КонецПроцедуры

Функция ДоступностьКнопкиОтчетПоНерезультативнымМероприятиям(Несоответствие) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ДокументОценкаЗначимости.Povtornoe КАК Povtornoe
	|ИЗ
	|	РегистрСведений.ra_OcenkiZnachimostiNesootvetstvij.СрезПоследних(, Nesootvetstvie = &Nesootvetstvie) КАК РС_ОценкиЗначимости
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ra_OcenkaZnachimosti.PovtornyeNesootvetstviya КАК ДокументОценкаЗначимости
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ra_KorrektiruyushcheeDejstvie КАК ra_KorrektiruyushcheeDejstvie
	|			ПО ДокументОценкаЗначимости.Nesootvetstvie = ra_KorrektiruyushcheeDejstvie.Nesootvetstvie
	|		ПО РС_ОценкиЗначимости.Регистратор = ДокументОценкаЗначимости.Ссылка
	|			И (РС_ОценкиЗначимости.Регистратор ССЫЛКА Документ.ra_OcenkaZnachimosti)
	|ГДЕ
	|	ДокументОценкаЗначимости.Povtornoe");
	
	Запрос.УстановитьПараметр("Nesootvetstvie", Несоответствие);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ПрочитатьДеревоПричинНаСервере(Несоответствие, Корень, ВыводитьКД = Истина, ВыводитьПредставления = Ложь) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(ra_PrichinyNesootvetstvij.TipPrichiny) КАК TipPrichiny____Presentation,
	|	ra_PrichinyNesootvetstvij.Nesootvetstvie КАК Nesootvetstvie,
	|	ra_PrichinyNesootvetstvij.KodPrichiny КАК KodPrichiny,
	|	ra_PrichinyNesootvetstvij.KodPrichinyRoditel КАК KodPrichinyRoditel,
	|	ra_PrichinyNesootvetstvij.TipPrichiny КАК TipPrichiny,
	|	ra_PrichinyNesootvetstvij.Opisanie КАК Opisanie,
	|	ra_PrichinyNesootvetstvij.KorennayaPrichina КАК KorennayaPrichina,
	|	ЗНАЧЕНИЕ(Документ.ra_KorrektiruyushcheeDejstvie.ПустаяСсылка) КАК KorrektiruyushcheeDejstvie,
	|	НЕ ra_KorrektiruyushcheeDejstvie.KodPrichiny ЕСТЬ NULL КАК VvedenoKD
	|ИЗ
	|	РегистрСведений.ra_PrichinyNesootvetstvij КАК ra_PrichinyNesootvetstvij
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			ra_KorrektiruyushcheeDejstvie.KodPrichiny КАК KodPrichiny
	|		ИЗ
	|			Документ.ra_KorrektiruyushcheeDejstvie КАК ra_KorrektiruyushcheeDejstvie
	|		ГДЕ
	|			ra_KorrektiruyushcheeDejstvie.Nesootvetstvie = &Несоответствие) КАК ra_KorrektiruyushcheeDejstvie
	|		ПО ra_PrichinyNesootvetstvij.KodPrichiny = ra_KorrektiruyushcheeDejstvie.KodPrichiny
	|ГДЕ
	|	ra_PrichinyNesootvetstvij.Nesootvetstvie = &Несоответствие" + ?(ВыводитьКД, "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(ra_PrichinyNesootvetstvij.TipPrichiny) КАК TipPrichiny____Presentation,
	|	ra_PrichinyNesootvetstvij.Nesootvetstvie,
	|	НЕОПРЕДЕЛЕНО,
	|	ra_PrichinyNesootvetstvij.KodPrichiny,
	|	ra_PrichinyNesootvetstvij.TipPrichiny,
	|	ra_PrichinyNesootvetstvij.Opisanie,
	|	ra_PrichinyNesootvetstvij.KorennayaPrichina,
	|	ra_KorrektiruyushcheeDejstvie.Ссылка,
	|	ИСТИНА КАК VvedenoKD
	|ИЗ
	|	РегистрСведений.ra_PrichinyNesootvetstvij КАК ra_PrichinyNesootvetstvij
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ra_KorrektiruyushcheeDejstvie КАК ra_KorrektiruyushcheeDejstvie
	|		ПО ra_PrichinyNesootvetstvij.Nesootvetstvie = ra_KorrektiruyushcheeDejstvie.Nesootvetstvie
	|			И ra_PrichinyNesootvetstvij.KodPrichiny = ra_KorrektiruyushcheeDejstvie.KodPrichiny
	|ГДЕ
	|	ra_PrichinyNesootvetstvij.Nesootvetstvie = &Несоответствие", "");
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "local";
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.ИсточникДанных = "ИсточникДанных1";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	НаборДанных.Запрос = ТекстЗапроса;
	НаборДанных.Имя = "НаборДанных1";
	
	СвязьНаборовДанных = СхемаКомпоновкиДанных.СвязиНаборовДанных.Добавить();
	СвязьНаборовДанных.НаборДанныхИсточник = "НаборДанных1";
	СвязьНаборовДанных.НаборДанныхПриемник = "НаборДанных1";
	СвязьНаборовДанных.ВыражениеИсточник = "KodPrichiny";
	СвязьНаборовДанных.ВыражениеПриемник = "KodPrichinyRoditel";
	СвязьНаборовДанных.НачальноеВыражение = Строка(Корень);
	СвязьНаборовДанных.Обязательная = Истина;
	
	ГруппировкаКомпоновкиДанных = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ГруппировкаКомпоновкиДанных.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	ГруппировкаКомпоновкиДанных.Использование = Истина;
	
	ВыбранноеПоле = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("Nesootvetstvie");
	
	ВыбранноеПоле = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("KodPrichiny");
	
	ВыбранноеПоле = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("KodPrichinyRoditel");
	
	ВыбранноеПоле = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("TipPrichiny");
	
	ВыбранноеПоле = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("Opisanie");
	
	ВыбранноеПоле = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("KorennayaPrichina");
	
	ВыбранноеПоле = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("VvedenoKD");
	
	Если ВыводитьКД Тогда
		ВыбранноеПоле = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("KorrektiruyushcheeDejstvie");
	КонецЕсли;
	
	Если ВыводитьПредставления Тогда
		ВыбранноеПоле = СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("TipPrichiny____Presentation");
	КонецЕсли;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Несоответствие"), Несоответствие);
	
	НастройкиКомпоновки = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Новый ДеревоЗначений);
	
	Возврат ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.РегистрыСведений.ra_PrichinyNesootvetstvij;
	
	ТаблицаРеквизитов = ра_ОбменДанными.ПолучитьТаблицуРеквизитовОбъекта(ОбъектМетаданных);
	
	АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов);
	
	ТекстЗапросаВложенныеТаблицы = ПолучитьТекстЗапросаВложенныеТаблицы();
	ТекстЗапросаСоединений = ПолучитьТекстЗапросаСоединений();
	
	Запрос = ра_ОбменДанными.ПолучитьЗапрос(ТаблицаРеквизитов, ПараметрыЗапросаHTTP, ПолноеИмя, ТекстЗапросаВложенныеТаблицы, ТекстЗапросаСоединений);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
	Результат.Вставить("value", МассивДанных);
	
	НастройкаФормы = ПараметрыЗапросаHTTP.Получить("$form_settings");
	Если ЗначениеЗаполнено(НастройкаФормы) И НастройкаФормы Тогда
		МассивКолонок = ПолучитьПолучитьМассивКолонокСписка();
		МассивКнопок = ПолучитьМассивКнопок(Запрос.Параметры);
		МассивФильтров = ПолучитьМассивФильтровСписка(Запрос.Параметры);
		Результат.Вставить("form_settings", МассивКолонок);
		Результат.Вставить("button_settings", МассивКнопок);
		Результат.Вставить("filter_settings", МассивФильтров);
		
		Если Запрос.Параметры.Свойство("Nesootvetstvie") Тогда
			Несоответствие = Запрос.Параметры.Nesootvetstvie;
			
			Полномочия = РегистрыСведений.ra_KomandyNesootvetstvij.ПолномочияТекущегоПользователя(Несоответствие);
			
			РезультатыПроверки = Документы.ra_Nesootvetstvie.ПроверитьНаличиеПроизводныхДокументов(Несоответствие,
				Новый Структура("ra_OtchetONesootvetstviiCHast2"));
			
			ЕстьПравоРедактирования = Полномочия.ПервыйЛидер И Не РезультатыПроверки.Свойство("ra_OtchetONesootvetstviiCHast2");
			
			Дерево = РегистрыСведений.ra_PrichinyNesootvetstvij.ПрочитатьДеревоПричинНаСервере(Несоответствие, 0, Ложь, Истина);
			
			Корень = Новый Структура;
			Корень.Вставить("Caption", НСтр("ru = 'ОПИСАНИЕ НЕСООТВЕТСТВИЯ'; en = 'DESCRIPTION OF NONCONFORMITY'"));
			Корень.Вставить("Nesootvetstvie", Несоответствие);
			Корень.Вставить("KodPrichiny", 0);
			Корень.Вставить("KodPrichinyRoditel", 0);
			Корень.Вставить("TipPrichiny", Справочники.ra_TipyPrichinNesootvetstvij.ПустаяСсылка());
			Корень.Вставить("TipPrichiny____Presentation", "");
			Корень.Вставить("Opisanie", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запрос.Параметры.Nesootvetstvie, "PodrobnoeOpisanie"));
			Корень.Вставить("KorennayaPrichina", false);
			
			Кнопки = Новый Массив;
			
			ИмяКнопки = "AddRow0";
			ОписаниеКнопки = НСтр("ru = 'Почему? (Укажите причину)'; en = 'Why? (Specify the cause)'");
			Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
			Кнопка.ObjectGUID = 0;
			Кнопка.Availability = ЕстьПравоРедактирования;
			Кнопка.Visibility = Кнопка.Availability;
			
			Кнопки.Добавить(Кнопка);
			
			Корень.Вставить("Buttons", Кнопки);
			
			Корень.Вставить("DescendantNodes", ПреобразоватьДеревоВМассивыМассивов(Дерево, Дерево, ЕстьПравоРедактирования));
			
			Результат.Вставить("value", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Корень));
		Иначе
			МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
			Результат.Вставить("value", МассивДанных);
		КонецЕсли;
	Иначе
		МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
		Результат.Вставить("value", МассивДанных);
	КонецЕсли;
	
КонецПроцедуры

Функция ПреобразоватьДеревоВМассивыМассивов(Коллекция, Дерево, ЕстьПравоРедактирования)
	
	Результат = Новый Массив;
	
	Для каждого Строка Из Коллекция.Строки Цикл
		Узел = ра_ОбщегоНазначения.ЭлементВыборкиВСтруктуру(Строка, Дерево);
		Узел.Вставить("TipPrichiny____Presentation", Строка(Узел.TipPrichiny));
		Узел.Вставить("Caption", ?(Узел.KorennayaPrichina, НСтр("ru = 'Коренная причина'; en = 'Root cause'"), НСтр("ru = 'Причина'; en = 'Cause'")));
		
		УзлыПотомки = ПреобразоватьДеревоВМассивыМассивов(Строка, Дерево, ЕстьПравоРедактирования);
		
		Кнопки = Новый Массив;
		
		ИмяКнопки = "AddRow" + Формат(Узел.KodPrichiny, "ЧГ=");
		ОписаниеКнопки = НСтр("ru = 'Почему? (Укажите причину)'; en = 'Why? (Specify the cause)'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.ObjectGUID = Узел.KodPrichiny;
		Кнопка.Availability = ЕстьПравоРедактирования И Не Узел.KorennayaPrichina;
		Кнопка.Visibility = Кнопка.Availability;
		
		Кнопки.Добавить(Кнопка);
		
		ИмяКнопки = "EditRow" + Формат(Узел.KodPrichiny, "ЧГ=");
		ОписаниеКнопки = НСтр("ru = 'Редактировать причину'; en = 'Edit cause'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.ObjectGUID = Узел.KodPrichiny;
		Кнопка.Availability = ЕстьПравоРедактирования;
		Кнопка.Visibility = Кнопка.Availability;
		
		Кнопки.Добавить(Кнопка);
		
		ИмяКнопки = "DeleteRow" + Формат(Узел.KodPrichiny, "ЧГ=");
		ОписаниеКнопки = НСтр("ru = 'Удалить причину'; en = 'Delete cause'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.ObjectGUID = Узел.KodPrichiny;
		Кнопка.Availability = ЕстьПравоРедактирования И Не Строка.VvedenoKD;
		Кнопка.Visibility = Кнопка.Availability;
		
		Кнопки.Добавить(Кнопка);
		
		Узел.Вставить("Buttons", Кнопки);
		
		Если УзлыПотомки.Количество() Тогда
			Узел.Вставить("DescendantNodes", УзлыПотомки);
		КонецЕсли;
		
		Результат.Добавить(Узел);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "";
	
КонецФункции

Функция СформироватьМассивДанныхРолевойМодели(ДокументОбъект, ПараметрыФормирования = Неопределено) Экспорт
	
	Возврат Обработки.ра_ФормыБитрикс.Создать().ОписаниеФормы(Метаданные.РегистрыСведений.ra_PrichinyNesootvetstvij, ДокументОбъект, ПараметрыФормирования);
	
КонецФункции

Функция ПолучитьМассивКнопок(МенеджерЗаписи) Экспорт
	
	ВидФормы = "ФормаОбъекта";
	Несоответствие = Документы.ra_Nesootvetstvie.ПустаяСсылка();
	Если ТипЗнч(МенеджерЗаписи) = Тип("Структура") Тогда
		ВидФормы = "ФормаСписка";
		Если МенеджерЗаписи.Свойство("Nesootvetstvie") Тогда
			Несоответствие = МенеджерЗаписи.Nesootvetstvie;
		КонецЕсли;
	Иначе
		Несоответствие = МенеджерЗаписи.Nesootvetstvie;
	КонецЕсли;
		
	МассивКнопок = Новый Массив;
	
	Полномочия = РегистрыСведений.ra_KomandyNesootvetstvij.ПолномочияТекущегоПользователя(Несоответствие);
	
	Если ВидФормы = "ФормаСписка" Тогда
		
		ИмяКнопки = "IneffectiveMeasuresReport";
		ОписаниеКнопки = НСтр("ru = 'Отчет по нерезультативным мероприятиям'; en = 'Ineffective measures report'");
		КнопкаОтчетПоНерезМероприятиям = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		КнопкаОтчетПоНерезМероприятиям.Availability = ДоступностьКнопкиОтчетПоНерезультативнымМероприятиям(Несоответствие);
		КнопкаОтчетПоНерезМероприятиям.Visibility = КнопкаОтчетПоНерезМероприятиям.Availability;
		
		МассивКнопок.Добавить(КнопкаОтчетПоНерезМероприятиям);
		
		ИмяКнопки = "Print";
		ОписаниеКнопки = НСтр("ru = 'Печать'; en = 'Print'");
		Кнопка = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		Кнопка.Availability = Истина;
		Кнопка.Visibility = Истина;
		
		МассивКнопок.Добавить(Кнопка);
		
	ИначеЕсли ВидФормы = "ФормаОбъекта" Тогда
		
		ИмяКнопки = "Save";
		ОписаниеКнопки = НСтр("ru = 'Сохранить'; en = 'Save'");
		КнопкаСохранить = ра_ОбменДанными.ПолучитьСтруктуруНастроекКнопки(ИмяКнопки, ОписаниеКнопки);
		КнопкаСохранить.Availability = Полномочия.ПервыйЛидер;
		КнопкаСохранить.Visibility = КнопкаСохранить.Availability;
		
		МассивКнопок.Добавить(КнопкаСохранить);
		
	КонецЕсли;
	
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.ra_PrichinyNesootvetstvij;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	ИзмеренияРегистра = МетаданныеРегистра.Измерения;
	РесурсыРегистра = МетаданныеРегистра.Ресурсы;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, ИзмеренияРегистра.KodPrichiny);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.TipPrichiny);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРегистра.Opisanie);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка(МенеджерЗаписи) Экспорт
	
	ВидФормы = "ФормаОбъекта";
	Несоответствие = Документы.ra_Nesootvetstvie.ПустаяСсылка();
	Если ТипЗнч(МенеджерЗаписи) = Тип("Структура") Тогда
		ВидФормы = "ФормаСписка";
		Если МенеджерЗаписи.Свойство("Nesootvetstvie") Тогда
			Несоответствие = МенеджерЗаписи.Nesootvetstvie;
		КонецЕсли;
	Иначе
		Несоответствие = МенеджерЗаписи.Nesootvetstvie;
	КонецЕсли;
	
	Полномочия = РегистрыСведений.ra_KomandyNesootvetstvij.ПолномочияТекущегоПользователя(Несоответствие);
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.ra_PrichinyNesootvetstvij;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	ИзмеренияРС = МетаданныеРегистра.Измерения;
	РесурсыРС = МетаданныеРегистра.Ресурсы;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, ИзмеренияРС.Nesootvetstvie);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, ИзмеренияРС.KodPrichiny);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРС.KodPrichinyRoditel);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРС.TipPrichiny);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРС.Opisanie);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, РесурсыРС.KorennayaPrichina);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, Новый Структура("Имя,Синоним", "NeposredstvennayaPrichina", НСтр("ru = 'Непосредственная причина'; en = 'Immediate cause'")), "String(0)");
	
	ра_ОбменДанными.ИзменитьСтрокуВТаблицеНастроек(ТаблицаНастроек, "NeposredstvennayaPrichina", Полномочия.ПервыйЛидер, Полномочия.ПервыйЛидер);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт
	
	МассивЗаголовков = Новый Массив;
	
	Возврат МассивЗаголовков;
	
КонецФункции

//V2

Функция ЕстьМетодДополнитьОписаниеМетаданных() Экспорт
	
	Возврат Истина;
	
КонецФункции

Процедура ДополнитьОписаниеМетаданных(ОбработкаОбъект, Данные, ПараметрыФормирования) Экспорт
	
	Полномочия = РегистрыСведений.ra_KomandyNesootvetstvij.ПолномочияТекущегоПользователя(Данные.Nesootvetstvie);
	
	Если ПараметрыФормирования <> Неопределено Тогда
		Если ПараметрыФормирования.Свойство("НепосредственнаяПричина") Тогда
			
			ОбработкаОбъект.ДобавитьПоле("", Новый Структура("Имя,Синоним,Тип", "FormCaption", НСтр("ru = 'Указание непосредственной причины'; en = 'Specifying of immediate cause'"), Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(30))));
			
		ИначеЕсли ПараметрыФормирования.Свойство("КореннаяПричина") Тогда
			
			ОбработкаОбъект.ДобавитьПоле("", Новый Структура("Имя,Синоним,Тип", "FormCaption", НСтр("ru = 'Добавление коренной причины'; en = 'Adding a root cause'"), Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(30))));
			
		КонецЕсли;
	КонецЕсли;
	
	ОбработкаОбъект.УстановитьВидимость("Opisanie,TipPrichiny", Истина);
	
	ОбработкаОбъект.УстановитьДоступность("Opisanie", Полномочия.ПервыйЛидер);
	ОбработкаОбъект.УстановитьДоступность("TipPrichiny", Полномочия.ПервыйЛидер И Данные.KorennayaPrichina);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Nesootvetstvie", Данные.Nesootvetstvie);
	Запрос.УстановитьПараметр("KodPrichinyRoditel", ?(Данные.KodPrichiny, Данные.KodPrichiny, -1));
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ra_PrichinyNesootvetstvij.KodPrichiny КАК KodPrichiny
	|ИЗ
	|	РегистрСведений.ra_PrichinyNesootvetstvij КАК ra_PrichinyNesootvetstvij
	|ГДЕ
	|	ra_PrichinyNesootvetstvij.Nesootvetstvie = &Nesootvetstvie
	|	И ra_PrichinyNesootvetstvij.KodPrichinyRoditel = &KodPrichinyRoditel";
	ЭтоЛист = Запрос.Выполнить().Пустой();
	
	ОбработкаОбъект.УстановитьВидимость("KorennayaPrichina", Полномочия.ПервыйЛидер И ЭтоЛист);
	ОбработкаОбъект.УстановитьДоступность("KorennayaPrichina", Полномочия.ПервыйЛидер И ЭтоЛист);
	
	ОбязательныеРеквизиты = ОбработкаОбъект.ОбязательныеРеквизиты();
	АктуализироватьМассивОбязательныхРеквизитов(ОбязательныеРеквизиты, Данные);
	ОбработкаОбъект.УстановитьОбязательность(ОбязательныеРеквизиты, Истина);
	
КонецПроцедуры

#КонецОбласти