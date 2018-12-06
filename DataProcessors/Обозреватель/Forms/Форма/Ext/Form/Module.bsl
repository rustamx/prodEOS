﻿//Команда браузера "Вперед"
&НаКлиенте
Процедура Вперед(Команда)
	
    Элементы.ПолеHTMLДокумента.Вперед();
	
КонецПроцедуры

//Команда браузера "Назад"
&НаКлиенте
Процедура Назад(Команда)
	
    Элементы.ПолеHTMLДокумента.Назад();        
	
КонецПроцедуры

//Команда браузера "Обновить"
&НаКлиенте
Процедура Обновить(Команда)	
	
	Элементы.ПолеHTMLДокумента.Документ.location.reload();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	 //Устанавливает в свойстве формы "Заголовок" значение, переданное в параметре "Заголовок"
	 Если Параметры.Свойство("Заголовок") Тогда
		 Заголовок = Параметры.Заголовок;	 
	 КонецЕсли;
	 
	 //Устанавливает в свойстве формы "Стартовая страница" значение, 
	 //переданное в параметре "Адрес страницы"
	 //Указывать полный адрес страницы (с http:\\)
	 Если Параметры.Свойство("АдресСтраницы") Тогда
		 СтартоваяСтраница = Параметры.АдресСтраницы;	 
	 КонецЕсли;
	 
	 //Устанавливает стартовую страницу
	 Если Параметры.Свойство("АдресСтраницы") Тогда
		 СтартоваяСтраница = Параметры.АдресСтраницы;
	 КонецЕсли;
	 
	 //Устанавливает в свойстве видимость группы "Командная панель" значение, 
	 //переданное в параметре "ОтображатьКоманднуюПанель"
	 Если Параметры.Свойство("ОтображатьКоманднуюПанель") Тогда
		 Элементы.КоманднаяПанель.Видимость = Параметры.ОтображатьКоманднуюПанель;
	 КонецЕсли;
	 
	 //Установить размеры формы
	 Если Параметры.Свойство("Высота") И Параметры.Свойство("Ширина") Тогда
	 	ЭтаФорма.Высота = Параметры.Высота;
	 	ЭтаФорма.Ширина = Параметры.Ширина;
	 КонецЕсли;
	 
 КонецПроцедуры


