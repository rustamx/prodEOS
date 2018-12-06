﻿
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если Количество() = 1 Тогда
		
		Письмо = Получить(0).Письмо;
		ЭтоОшибка = Получить(0).ЭтоОшибка;
		
		Если ЭтоОшибка И ЗначениеЗаполнено(Письмо) Тогда
			
			РегистрыСведений.КешИнформацииОбОбъектах.УстановитьПризнак(
				Письмо, "ЕстьОшибкиПриемкиОтправкиПочты", Истина);	
						
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры


