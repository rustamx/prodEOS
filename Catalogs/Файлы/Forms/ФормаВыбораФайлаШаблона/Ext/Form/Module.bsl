﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МаксРазмерФайла = ФайловыеФункции.ПолучитьМаксимальныйРазмерФайла();
	
	ЗаполнитьДерево(Параметры.ШаблонаДокумента, Параметры.ВладелецФайла);
	
	Список.Параметры.УстановитьЗначениеПараметра("Владелец", ТекущаяПапка);
	
	ВыборДляПравилАвтозаполнения = Параметры.ВыборДляПравилАвтозаполнения;
	Если ВыборДляПравилАвтозаполнения Тогда
		СписокРасширенийШаблонов = Новый Массив;
		СписокРасширенийШаблонов.Добавить("doc");
		СписокРасширенийШаблонов.Добавить("docx");
		СписокРасширенийШаблонов.Добавить("dot");
		СписокРасширенийШаблонов.Добавить("dotx");
		СписокРасширенийШаблонов.Добавить("txt");
		СписокРасширенийШаблонов.Добавить("odt");
		СписокРасширенийШаблонов.Добавить("html");
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, "ТекущаяВерсияРасширение", СписокРасширенийШаблонов, ВидСравненияКомпоновкиДанных.ВСписке,,Истина);
	КонецЕсли;
	
	Если Не ЭлектроннаяПодпись.ИспользоватьЭлектронныеПодписи()
		И Не ЭлектроннаяПодпись.ИспользоватьШифрование() Тогда
		
		Элементы.ПодписанЭП.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПоказыватьКомандуСоздать") Тогда
		Элементы.СписокСоздать.Видимость = (Параметры.ПоказыватьКомандуСоздать = Истина);
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	Иначе
		
		Если ВыборШаблона Тогда
			Заголовок = НСтр("ru = 'Выбор шаблона файла'; en = 'Select file template'");
		КонецЕсли;
		
	КонецЕсли;
	
	ВыбранныеФайлыНадпись = НСтр("ru = 'Выбранные файлы:'; en = 'Selected files:'");
	
	Если ЗакрыватьПриВыборе Тогда
		Элементы.ВыбранныеФайлыНадпись.Видимость = Ложь;
		Элементы.ВыбранныеЗначения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ПроверитьПредельныйРазмерФайла(МаксРазмерФайла, 
			Элементы.Список.ТекущиеДанные.ТекущаяВерсияРазмер, 
			ВыбраннаяСтрока);
	КонецЕсли;
	
	Если ЗакрыватьПриВыборе Тогда
		Если ВыборДляПравилАвтозаполнения Тогда
			СтандартнаяОбработка = Ложь;
			Результат = Новый Структура;
			Результат.Вставить("Файл", Элементы.Список.ТекущаяСтрока);
			Результат.Вставить("Расширение", Элементы.Список.ТекущиеДанные.ТекущаяВерсияРасширение);
			ОповеститьОВыборе(Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	ВыборЗначенияСервер(ВыбраннаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеЗначения

&НаКлиенте
Процедура ВыбранныеЗначенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Значение);
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("СправочникСсылка.Файлы") Тогда
		ВыборЗначенияСервер(ПараметрыПеретаскивания.Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПослеУдаления(Элемент)
	ОбновитьОтображение();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоВладельцев

&НаКлиенте
Процедура ДеревоВладельцевПриАктивизацииСтроки(Элемент)
	
	Если ТекущаяПапка = Элементы.ДеревоВладельцев.ТекущиеДанные.Ссылка Тогда
		Возврат;
	КонецЕсли;
	ТекущаяПапка = Элементы.ДеревоВладельцев.ТекущиеДанные.Ссылка;
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВладельцевВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ДеревоВладельцев.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда 
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВладельцевПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВладельцевПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ДеревоВладельцев.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда 
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВладельцевПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ПроверитьПредельныйРазмерФайла(МаксРазмерФайла, 
			Элементы.Список.ТекущиеДанные.ТекущаяВерсияРазмер, 
			Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
	Если ЗакрыватьПриВыборе Тогда
		Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Не выбрана строка.'; en = 'No row is selected.'"));
			Возврат;
		КонецЕсли;
		Если ВыборДляПравилАвтозаполнения Тогда
			Результат = Новый Структура;
			Результат.Вставить("Файл", Элементы.Список.ТекущаяСтрока);
			Результат.Вставить("Расширение", Элементы.Список.ТекущиеДанные.ТекущаяВерсияРасширение);
			ОповеститьОВыборе(Результат);
		Иначе
			ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
		КонецЕсли;
	Иначе
		Если ВыбранныеЗначения.Количество() = 0 Тогда
			Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Не выбран ни один файл.'; en = 'You have not selected any files.'"));
				Возврат;
			КонецЕсли;
			ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
		ИначеЕсли ВыбранныеЗначения.Количество() = 1 Тогда
			ОповеститьОВыборе(ВыбранныеЗначения[0].Значение);
		ИначеЕсли ВыбранныеЗначения.Количество() > 1 Тогда
			ОповеститьОВыборе(ВыбранныеЗначения.ВыгрузитьЗначения());
		КонецЕсли;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайл(Команда)
	
	Попытка
		РежимСоздания = 2; // из файла на диске
		
		ТекущиеДанные = Элементы.ДеревоВладельцев.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда 
			Возврат;
		КонецЕсли;
	
		РаботаСФайламиКлиент.ДобавитьФайл(Неопределено, ТекущиеДанные.Ссылка, ЭтотОбъект, РежимСоздания);
	Исключение
		ПоказатьПредупреждение(, ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
			ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПолныйПуть(Ссылка)
	
	УстановитьПривилегированныйРежим(Истина);
	Путь = "";
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Файлы.ВладелецФайла КАК Папка,
		|	Файлы.ВладелецФайла.Наименование КАК Наименование
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Папка = РезультатЗапроса[0].Папка;
	Пока ЗначениеЗаполнено(Папка) Цикл
		Путь = РезультатЗапроса[0].Наименование + ?(ПустаяСтрока(Путь), "", "\") + Путь;
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ПапкиФайлов.Родитель КАК Папка,
			|	ПапкиФайлов.Родитель.Наименование КАК Наименование
			|ИЗ
			|	Справочник.ПапкиФайлов КАК ПапкиФайлов
			|ГДЕ
			|	ПапкиФайлов.Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Папка);
		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		Папка = РезультатЗапроса[0].Папка;
	КонецЦикла;
	
	Возврат Путь;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьПредельныйРазмерФайла(МаксРазмерФайла, РазмерФайла, ФайлСсылка)
	
	Если РазмерФайла > МаксРазмерФайла Тогда
		
		РазмерВМб = РазмерФайла / (1024 * 1024);
		РазмерВМбМакс = МаксРазмерФайла / (1024 * 1024);
		
		ВызватьИсключение
			   СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				 НСтр("ru = 'Размер файла ""%1"" (%2 Мб) превышает максимально допустимый размер файла (%3 Мб).'; en = 'The size of file ""%1"" (%2 mb) exceeds the limit (%3 Mb).'"),
				 Строка(ФайлСсылка), 
				 ФайловыеФункцииКлиентСервер.ПолучитьСтрокуСРазмеромФайла(РазмерВМб), 
				 ФайловыеФункцииКлиентСервер.ПолучитьСтрокуСРазмеромФайла(РазмерВМбМакс));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыборЗначенияСервер(Значение)
	
	Элемент = ВыбранныеЗначения.НайтиПоЗначению(Значение);
	Если Элемент = Неопределено Тогда
		ВыбранныеЗначения.Добавить(Значение, ПолучитьПолныйПуть(Значение) + "\" + Значение);
		ВыбранныеЗначения.СортироватьПоПредставлению();
	Иначе
		ВыбранныеЗначения.Удалить(Элемент);
	КонецЕсли;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображение()
	ВыбранныеФайлыНадпись = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выбранные файлы (%1):'; en = 'Selected files (%1):'"),
			ВыбранныеЗначения.Количество());
	УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = ВыбранныеЗначения;
КонецПроцедуры

&НаСервере
Функция ПолучитьКорневуюПапку(Папка)
	
	КорневаяПапка = Папка;
	
	ПапкаРодитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Папка.Ссылка, "Родитель");
	
	Пока ЗначениеЗаполнено(ПапкаРодитель) Цикл
		
		КорневаяПапка = ПапкаРодитель;
		ПапкаРодитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПапкаРодитель, "Родитель");
		Если Не ЗначениеЗаполнено(ПапкаРодитель) Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КорневаяПапка;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДерево(ШаблонДокумента, ВладелецФайла)
	
	Дерево = РеквизитФормыВЗначение("ДеревоВладельцев");
	Дерево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(ШаблонДокумента) Тогда 
		НоваяСтрока = Дерево.Строки.Добавить();
		НоваяСтрока.Ссылка = ШаблонДокумента;
		НоваяСтрока.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ШаблонДокумента, "Наименование")
			+ " " + СтрШаблон(НСтр("ru = '(%1)'; en = '(%1)'"), ТипЗнч(ШаблонДокумента));
		НоваяСтрока.ИндексКартинки = 0;
		ТекущаяПапка = ШаблонДокумента;
	ИначеЕсли ЗначениеЗаполнено(ВладелецФайла)
		И (ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка.ВнутренниеДокументы")
			Или ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка.ИсходящиеДокументы")) Тогда
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Файлы.ВладелецФайла.Ссылка КАК Ссылка,
			|	Файлы.ВладелецФайла.ВидДокумента КАК ВидДокумента,
			|	Файлы.ВладелецФайла.Наименование КАК Наименование
			|ПОМЕСТИТЬ
			|	ШаблоныДокументов
			|ИЗ
			|	Справочник.Файлы КАК Файлы
			|ГДЕ
			|	Файлы.ВладелецФайла ССЫЛКА Справочник.ШаблоныВнутреннихДокументов
			|	ИЛИ Файлы.ВладелецФайла ССЫЛКА Справочник.ШаблоныИсходящихДокументов
			|;
			|ВЫБРАТЬ
			|	ШаблоныДокументов.Ссылка,
			|	ШаблоныДокументов.Наименование
			|ИЗ
			|	ШаблоныДокументов
			|ГДЕ
			|	ШаблоныДокументов.ВидДокумента = &ВидДокумента");
		Запрос.УстановитьПараметр("ВидДокумента", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВладелецФайла, "ВидДокумента"));
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Дерево.Строки.Добавить();
			НоваяСтрока.Ссылка = Выборка.Ссылка;
			НоваяСтрока.Наименование = СтрШаблон("%1 (%2)",
				Выборка.Наименование,
				ТипЗнч(Выборка.Ссылка));
			ТекущаяПапка = Выборка.Ссылка;
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СправочникПапкиФайлов.Ссылка КАК Ссылка,
	|	СправочникПапкиФайлов.ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА СправочникПапкиФайлов.ПометкаУдаления = ИСТИНА
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ИндексКартинки,
	|	СправочникПапкиФайлов.Родитель,
	|	СправочникПапкиФайлов.Наименование
	|ИЗ
	|	Справочник.ПапкиФайлов КАК СправочникПапкиФайлов
	|ГДЕ
	|	СправочникПапкиФайлов.Ссылка В ИЕРАРХИИ(&КорневаяПапка)
	|ИТОГИ ПО
	|	Ссылка ТОЛЬКО ИЕРАРХИЯ
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("КорневаяПапка", ПолучитьКорневуюПапку(Справочники.ПапкиФайлов.Шаблоны));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(Выборка.Ссылка) Тогда 
			Продолжить;
		КонецЕсли;
		
		Родитель = Выборка.Родитель;
		Если Родитель.Пустая() Тогда
			СтрокаРодитель = Дерево;
		Иначе
			СтрокаРодитель = Дерево.Строки.Найти(Родитель, "Ссылка", Истина);
		КонецЕсли;
		
		// Пропускаем дублирующийся
		ДубльСтроки = СтрокаРодитель.Строки.Найти(Выборка.Ссылка, "Ссылка", Истина);
		Если ДубльСтроки <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = СтрокаРодитель.Строки.Добавить();
		НоваяСтрока.Ссылка = Выборка.Ссылка;
		НоваяСтрока.Наименование = Выборка.Наименование;
		НоваяСтрока.ИндексКартинки = ?(Выборка.ПометкаУдаления, 1, 0);
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоВладельцев");
	
КонецПроцедуры	

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	Если ВыборШаблона Тогда
		ХранилищеНастроекДанныхФорм.Сохранить("ВыборФайловВПапках", "ТекущаяПапкаДляВыбораШаблона",  
			Элементы.ДеревоВладельцев.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если ТекущаяПапка <> Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", ТекущаяПапка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
