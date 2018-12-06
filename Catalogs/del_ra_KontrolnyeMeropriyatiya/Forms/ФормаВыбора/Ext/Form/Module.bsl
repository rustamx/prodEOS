
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("EhtapVyyavleniyaNesootvetstvija") Тогда
		
		EhtapVyyavleniyaNesootvetstvija = Список.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("EhtapVyyavleniyaNesootvetstvija"));

		EhtapVyyavleniyaNesootvetstvija.Использование = Истина;
		EhtapVyyavleniyaNesootvetstvija.Значение = Параметры.Отбор.EhtapVyyavleniyaNesootvetstvija;
		Параметры.Отбор.Удалить("EhtapVyyavleniyaNesootvetstvija");
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
