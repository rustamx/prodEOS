Перем РодительСсылки;

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если Primenenie.НайтиСтроки(Новый Структура(
		"VidPredmetaNesootvetstviya, EhtapVyyavleniyaNesootvetstvija"
		, Перечисления.ra_VidyPredmetovNesootvetstviya.ПустаяСсылка()
		, Справочники.ra_EhtapyVyyavleniyaNesootvetstvij.ПустаяСсылка())).Количество() = 0 Тогда
		Primenenie.Добавить();				
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РодительСсылки = Ссылка.Родитель;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗначениеЗаполнено(Родитель) Тогда
		ОбновитьДанныеГруппы(Родитель);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РодительСсылки)
		и РодительСсылки <> Родитель Тогда
		ОбновитьДанныеГруппы(РодительСсылки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьДанныеГруппы(Группа)
		
	ОбъектГруппа = Группа.ПолучитьОбъект();
	ОбъектГруппа.ЗаполнитьПрименение();
	
	Если ОбъектГруппа.Модифицированность() Тогда
		ОбъектГруппа.Записать();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьПрименение() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.VidPredmetaNesootvetstviya КАК VidPredmetaNesootvetstviya,
	|	ВложенныйЗапрос.EhtapVyyavleniyaNesootvetstvija КАК EhtapVyyavleniyaNesootvetstvija,
	|	СУММА(ВложенныйЗапрос.ПолеСравнения) КАК ПолеСравнения
	|ПОМЕСТИТЬ Т
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ra_VidyNesootvetstvijPrimenenie.VidPredmetaNesootvetstviya КАК VidPredmetaNesootvetstviya,
	|		ra_VidyNesootvetstvijPrimenenie.EhtapVyyavleniyaNesootvetstvija КАК EhtapVyyavleniyaNesootvetstvija,
	|		1 КАК ПолеСравнения
	|	ИЗ
	|		Справочник.ra_VidyNesootvetstvij.Primenenie КАК ra_VidyNesootvetstvijPrimenenie
	|	ГДЕ
	|		ra_VidyNesootvetstvijPrimenenie.Ссылка В ИЕРАРХИИ(&Ссылка)
	|		И ra_VidyNesootvetstvijPrimenenie.Ссылка <> &Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ra_VidyNesootvetstvijPrimenenie.VidPredmetaNesootvetstviya,
	|		ra_VidyNesootvetstvijPrimenenie.EhtapVyyavleniyaNesootvetstvija,
	|		-1
	|	ИЗ
	|		Справочник.ra_VidyNesootvetstvij.Primenenie КАК ra_VidyNesootvetstvijPrimenenie
	|	ГДЕ
	|		ra_VidyNesootvetstvijPrimenenie.Ссылка = &Ссылка) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.VidPredmetaNesootvetstviya,
	|	ВложенныйЗапрос.EhtapVyyavleniyaNesootvetstvija
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	Т КАК Т
	|ГДЕ
	|	Т.ПолеСравнения <> 0";
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Т.VidPredmetaNesootvetstviya КАК VidPredmetaNesootvetstviya,
		|	Т.EhtapVyyavleniyaNesootvetstvija КАК EhtapVyyavleniyaNesootvetstvija
		|ИЗ
		|	Т КАК Т
		|ГДЕ
		|	Т.ПолеСравнения <> -1";
		
		Primenenie.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли;	
	
	Запрос.МенеджерВременныхТаблиц.Закрыть();
		
КонецПроцедуры

#КонецОбласти