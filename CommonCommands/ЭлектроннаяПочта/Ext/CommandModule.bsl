﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму(
		"ЖурналДокументов.ЭлектроннаяПочта.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		Ложь,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры


