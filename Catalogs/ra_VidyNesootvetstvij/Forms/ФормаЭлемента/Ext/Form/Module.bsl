

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьДеревоИспользования();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьДеревоИспользования();	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Primenenie.Очистить();
	Для каждого СтрокаПредмет из ДеревоПрименения.ПолучитьЭлементы() Цикл
		Для каждого СтрокаЭтап из СтрокаПредмет.ПолучитьЭлементы() Цикл
			Если СтрокаЭтап.Использование Тогда
				СтрокаПрименение = ТекущийОбъект.Primenenie.Добавить();
				СтрокаПрименение.VidPredmetaNesootvetstviya      = СтрокаПредмет.ПредметЭтап;
				СтрокаПрименение.EhtapVyyavleniyaNesootvetstvija = СтрокаЭтап.ПредметЭтап;
			КонецЕсли;			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоИспользования()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.VidPredmetaNesootvetstviya КАК VidPredmetaNesootvetstviya,
	|	ВложенныйЗапрос.EhtapVyyavleniyaNesootvetstvija КАК EhtapVyyavleniyaNesootvetstvija,
	|	МАКСИМУМ(ВложенныйЗапрос.Использование) КАК Использование
	|ИЗ
	|	(ВЫБРАТЬ
	|		ra_ZavisimostPredmetovOtEtapov.EhtapVyyavleniyaNesootvetstvija КАК EhtapVyyavleniyaNesootvetstvija,
	|		ra_ZavisimostPredmetovOtEtapov.VidPredmetaNesootvetstviya КАК VidPredmetaNesootvetstviya,
	|		ЛОЖЬ КАК Использование
	|	ИЗ
	|		РегистрСведений.ra_ZavisimostPredmetovOtEtapov КАК ra_ZavisimostPredmetovOtEtapov
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ra_VidyNesootvetstvijPrimenenie.EhtapVyyavleniyaNesootvetstvija,
	|		ra_VidyNesootvetstvijPrimenenie.VidPredmetaNesootvetstviya,
	|		ИСТИНА
	|	ИЗ
	|		Справочник.ra_VidyNesootvetstvij.Primenenie КАК ra_VidyNesootvetstvijPrimenenie
	|	ГДЕ
	|		ra_VidyNesootvetstvijPrimenenie.Ссылка = &Ссылка
	|		И ra_VidyNesootvetstvijPrimenenie.VidPredmetaNesootvetstviya <> ЗНАЧЕНИЕ(Перечисление.ra_VidyPredmetovNesootvetstviya.ПустаяСсылка)) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.EhtapVyyavleniyaNesootvetstvija,
	|	ВложенныйЗапрос.VidPredmetaNesootvetstviya
	|
	|УПОРЯДОЧИТЬ ПО
	|	VidPredmetaNesootvetstviya,
	|	EhtapVyyavleniyaNesootvetstvija
	|ИТОГИ ПО
	|	VidPredmetaNesootvetstviya
	|АВТОУПОРЯДОЧИВАНИЕ");
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ДеревоЗапроса = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ЭлементыДереваПрименения = ДеревоПрименения.ПолучитьЭлементы();
	ЭлементыДереваПрименения.Очистить();
	
	Для каждого СтрокаПредмет из ДеревоЗапроса.Строки Цикл
		
		СтрокаПредметПрименения = ЭлементыДереваПрименения.Добавить();
		СтрокаПредметПрименения.ПредметЭтап = СтрокаПредмет.VidPredmetaNesootvetstviya;
		
		ЭлементыСтрокаПредметПрименения = СтрокаПредметПрименения.ПолучитьЭлементы();
		
		Для каждого СтрокаЭтап из СтрокаПредмет.Строки Цикл
			
			СтрокаЭтапПрименения = ЭлементыСтрокаПредметПрименения.Добавить();
			СтрокаЭтапПрименения.ПредметЭтап   = СтрокаЭтап.EhtapVyyavleniyaNesootvetstvija;
			СтрокаЭтапПрименения.Использование = СтрокаЭтап.Использование;
			СтрокаЭтапПрименения.Уровень       = 1;
			
		КонецЦикла;
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти