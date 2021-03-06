﻿
Функция MTRRequest(MTRRequest)
	
	ВидИнтеграции = Перечисления.ра_ВидыИнтеграций.EOSNSI_MTR;
	Попытка
		Если Константы.ра_ИспользоватьВнешнююОбработкуИнтеграции.Получить() Тогда
			//внешняя обработка
			во = ВнешниеОбработки.Создать(Константы.ра_ПутьКОбработкеВебСервисовИнтеграции.Получить(), Ложь);
			Результат = во.ВыполнитьСценарийЗагрузкиМТР(MTRRequest);
		Иначе
			Результат = Обработки.ра_Интеграция.ВыполнитьСценарийЗагрузкиМТР(MTRRequest);
		КонецЕсли;
	Исключение
		Обработки.ра_Интеграция.ДобавитьЗаписьВЖурналОбмена(MTRRequest, ФабрикаXDTO, ВидИнтеграции, ОписаниеОшибки(),, Истина, Ложь, Ложь,,,MTRRequest);
	    Возврат "IN_WARN"+Символы.ПС+ОписаниеОшибки();
	КонецПопытки;
	Возврат Результат; 

КонецФункции