﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("НеОтбирать") Тогда
		
		Если Параметры.Отбор.Свойство("Ссылка") И
				ТипЗнч(Параметры.Отбор.Ссылка) = Тип("ДокументСсылка.ra_ZayavkaNaKontrolnuyuOperaciyu") Тогда
				
			СтандартнаяОбработка = Ложь;
			
			ДанныеВыбора = Новый СписокЗначений;
			
			ДанныеВыбора.Добавить(Перечисления.СостоянияДокументов.ra_Проект);
			ДанныеВыбора.Добавить(Перечисления.СостоянияДокументов.ra_НаПодтверждении);
			ДанныеВыбора.Добавить(Перечисления.СостоянияДокументов.ra_Подтвержден);
			ДанныеВыбора.Добавить(Перечисления.СостоянияДокументов.НаИсполнении);
			ДанныеВыбора.Добавить(Перечисления.СостоянияДокументов.Исполнен);
			ДанныеВыбора.Добавить(Перечисления.СостоянияДокументов.НаСогласовании);
			ДанныеВыбора.Добавить(Перечисления.СостоянияДокументов.Согласован);
			ДанныеВыбора.Добавить(Перечисления.СостоянияДокументов.ra_Завершен);
			ДанныеВыбора.Добавить(Перечисления.СостоянияДокументов.ra_Аннулирован);
			
		КонецЕсли;
		
	КонецЕсли;
				
КонецПроцедуры

#КонецОбласти
