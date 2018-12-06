﻿
Функция BusinessPartnerUpdateRequest_Async(BusinessPartner, Error)  Экспорт
	
	ВидИнтеграции = Перечисления.ра_ВидыИнтеграций.EOSNSI_BusinessPartners;
	Попытка
		Если Константы.ра_ИспользоватьВнешнююОбработкуИнтеграции.Получить() Тогда
			во = ВнешниеОбработки.Создать(Константы.ра_ПутьКОбработкеВебСервисовИнтеграции.Получить(), Ложь);
			P = во.ВыполнитьСценарийЗагрузкиКонтрагентаВ1С(BusinessPartner, Error);       			
		Иначе
			P = Обработки.ра_Интеграция.ВыполнитьСценарийЗагрузкиКонтрагентаВ1С(BusinessPartner, Error);       		
		КонецЕсли;
				
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Обработки.ра_Интеграция.ДобавитьЗаписьВЖурналОбмена(BusinessPartner, ФабрикаXDTO, ВидИнтеграции, ТекстОшибки,, Истина, Ложь, Ложь);
		Error = "IN_ERROR:" + ТекстОшибки;
	КонецПопытки;
		
	Возврат Error;
	
КонецФункции

