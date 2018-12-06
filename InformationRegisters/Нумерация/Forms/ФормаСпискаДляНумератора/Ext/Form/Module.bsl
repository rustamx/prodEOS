﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Нумератор", Параметры.Нумератор);
	
	Элементы.ПериодНумерации.Видимость = 
		(Параметры.Нумератор.Периодичность <> Перечисления.ПериодичностьНумераторов.Непериодический);
	
	Элементы.Организация.Видимость = 
		Параметры.Нумератор.НезависимаяНумерацияПоОрганизациям;
	
	Элементы.СвязанныйДокумент.Видимость = 
		Параметры.Нумератор.НезависимаяНумерацияПоСвязанномуДокументу;
		
	Элементы.Подразделение.Видимость = 
		Параметры.Нумератор.НезависимаяНумерацияПоПодразделению;
		
	Элементы.ВидДокумента.Видимость = 
		Параметры.Нумератор.НезависимаяНумерацияПоВидуДокумента;
		
	Элементы.Проект.Видимость = 
		Параметры.Нумератор.НезависимаяНумерацияПоПроекту;
		
	Элементы.ВопросДеятельности.Видимость = 
		Параметры.Нумератор.НезависимаяНумерацияПоВопросуДеятельности;
	
КонецПроцедуры


