﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЗначениеЗаполнено(ПараметрКоманды) Тогда
		ОткрытьФорму("ОбщаяФорма.ra_PrichinyNesootvetstviya",Новый Структура("Несоответствие", ПараметрКоманды),
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Источник.КлючУникальности,
				ПараметрыВыполненияКоманды.Окно);
	КонецЕсли;
	
КонецПроцедуры