﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрано ни одного документа или файла!'; en = 'Not a single document or file is selected!'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Объекты", ПараметрКоманды);
	ОткрытьФорму(
		"Обработка.ПочтовоеСообщение.Форма.Форма",
		ПараметрыОткрытия,,
		Новый УникальныйИдентификатор);
	
КонецПроцедуры


