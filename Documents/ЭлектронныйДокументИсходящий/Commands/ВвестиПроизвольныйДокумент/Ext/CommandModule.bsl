﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ДокументОснование", ПараметрКоманды);
	ОткрытьФорму("Документ.ЭлектронныйДокументИсходящий.Форма.ФормаПроизвольногоДокумента", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);
КонецПроцедуры

#КонецОбласти
