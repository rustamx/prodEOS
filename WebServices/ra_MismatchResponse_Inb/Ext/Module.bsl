﻿
Функция UpdateNonconformityStatus(NonconfomityUpdateRequest)
	
	ВидИнтеграции = Перечисления.ра_ВидыИнтеграций.SRM_Nonconformities;
	Результат = "ok";
	Попытка
		Если Константы.ра_ИспользоватьВнешнююОбработкуИнтеграции.Получить() Тогда
			во = ВнешниеОбработки.Создать(Константы.ра_ПутьКОбработкеВебСервисовИнтеграции.Получить(), Ложь);
			во.ВыполнитьСценарийЗагрузкиОбновлениеСтатусаВыгруженныхВSRMНесоответствий(NonconfomityUpdateRequest);       			
		Иначе
			Обработки.ра_Интеграция.ВыполнитьСценарийЗагрузкиОбновлениеСтатусаВыгруженныхВSRMНесоответствий(NonconfomityUpdateRequest);       		
		КонецЕсли;
				
	Исключение
		Результат = "IN_ERROR:" + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Обработки.ра_Интеграция.ДобавитьЗаписьВЖурналОбмена(NonconfomityUpdateRequest, ФабрикаXDTO, ВидИнтеграции, Результат,, Истина, Ложь, Ложь);
	КонецПопытки;
		
	Возврат Результат;
	
КонецФункции
