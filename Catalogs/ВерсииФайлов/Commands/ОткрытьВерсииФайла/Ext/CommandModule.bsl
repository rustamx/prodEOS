﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Файл, УникальныйИдентификаторКарточкиФайла", 
		ПараметрКоманды, ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор);
	ОткрытьФорму("Справочник.ВерсииФайлов.Форма.ФормаСпискаВерсийФайла", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры


