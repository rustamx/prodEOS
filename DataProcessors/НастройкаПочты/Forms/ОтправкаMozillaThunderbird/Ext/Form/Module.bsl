﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("Использовать", Использовать);
	Если Параметры.Свойство("Данные") Тогда
		Параметры.Данные.Свойство("PATH", PATH);
	КонецЕсли;
	СохранениеВводимыхЗначений.ЗагрузитьСписокВыбора(ЭтаФорма, "PATH");
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СохранениеВводимыхЗначенийКлиент.ОбновитьСписокВыбора(ЭтаФорма, "PATH", 20);
	
	ВидПочтовогоКлиента = ПредопределенноеЗначение("Перечисление.ВидыПочтовыхКлиентов.MozillaThunderbird");
	Наименование = Строка(ВидПочтовогоКлиента);
	
	Результат = Новый Структура;
	Результат.Вставить("Наименование", Наименование);
	Результат.Вставить("ВидПочтовогоКлиента", ВидПочтовогоКлиента);
	Результат.Вставить("Использовать", Использовать);
	Результат.Вставить("Данные", Новый Структура);
	Результат.Данные.Вставить("PATH", PATH);
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура PATHНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = НСтр("ru = 'Укажите каталог файла thunderbird.exe'; en = 'Specify thunderbird.exe file directory'");
	Диалог.Каталог = PATH;
	Если Диалог.Выбрать() Тогда
		PATH = Диалог.Каталог;
	КонецЕсли;
КонецПроцедуры


