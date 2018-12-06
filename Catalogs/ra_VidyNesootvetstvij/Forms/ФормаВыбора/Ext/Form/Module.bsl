
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	VidPredmetaNesootvetstviya      = Список.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("VidPredmetaNesootvetstviyaFilter"));
	EhtapVyyavleniyaNesootvetstvija = Список.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("EhtapVyyavleniyaNesootvetstvijaFilter"));
	
	VidPredmetaNesootvetstviya.Использование = Истина;	
	EhtapVyyavleniyaNesootvetstvija.Использование = Истина;
	
	Если Параметры.Отбор.Свойство("VidPredmetaNesootvetstviya", VidPredmetaNesootvetstviya.Значение) Тогда
		Параметры.Отбор.Удалить("VidPredmetaNesootvetstviya");	
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("EhtapVyyavleniyaNesootvetstvija", EhtapVyyavleniyaNesootvetstvija.Значение) Тогда
		Параметры.Отбор.Удалить("EhtapVyyavleniyaNesootvetstvija");	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
