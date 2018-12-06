﻿#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьНаличиеОценки();
	
КонецПроцедуры		

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьНаличиеОценки()	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для каждого Эл Из ЭтотОбъект Цикл
		
		Период = Эл.Период;
		КонтрольнаяТочка = Эл.КонтрольнаяТочка;
		
		ДатаНачала = НачалоНедели(Период);
		ДатаОкончания = КонецНедели(Период);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ОценкиКонтрольныхТочек.Оценка
			|ИЗ
			|	РегистрСведений.ОценкиКонтрольныхТочек КАК ОценкиКонтрольныхТочек
			|ГДЕ
			|	ОценкиКонтрольныхТочек.Период >= &ДатаНачала
			|	И ОценкиКонтрольныхТочек.Период <= &ДатаОкончания
			|	И ОценкиКонтрольныхТочек.КонтрольнаяТочка = &КонтрольнаяТочка";
		
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
		Запрос.УстановитьПараметр("КонтрольнаяТочка", КонтрольнаяТочка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ВызватьИсключение НСтр("ru = 'Оценка за эту неделю уже есть.'; en = 'Estimate for this week already exists'");
		КонецЕсли;
	
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти
