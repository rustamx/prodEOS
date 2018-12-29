﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Отчет.URLСхемы));
	Отчет.КомпоновщикНастроек.Восстановить();
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	Для каждого Элемент Из Настройки.ДополнительныеНастройки.Элементы Цикл
		Элемент.Использование = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(
		ДанныеРасшифровки,
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(Отчет.URLСхемы)
	);
	
	ВыполненноеДействие = Неопределено;
	ПараметрВыполненногоДействия = Неопределено;
	
	ДоступныеДействия = Новый Массив;
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	
	ОбработкаРасшифровки.ВыбратьДействие(
		Расшифровка,
		ВыполненноеДействие,
		ПараметрВыполненногоДействия,
		ДоступныеДействия
	);
	
	Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
		ОткрытьЗначение(ПараметрВыполненногоДействия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры
