﻿
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// ТСК Близнюк С.И.; 08.10.2018; task#1380{
	ОграничивающиеРеквизиты  = Новый Массив;
	ОграничивающиеРеквизиты.Добавить("Владелец");
	ра_ОбщегоНазначения.ПроверитьУникальностьРеквизита(ЭтотОбъект, "Наименование", ОграничивающиеРеквизиты);
	// ТСК Близнюк С.И.; 08.10.2018; task#1380}
	
КонецПроцедуры

#КонецОбласти