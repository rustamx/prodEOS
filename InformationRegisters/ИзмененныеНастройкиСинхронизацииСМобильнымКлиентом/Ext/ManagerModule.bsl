﻿// Делает запись об изменившейся насторойке для текущего пользователя
Процедура ДобавитьЗапись(Пользователь, ВидНастройки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписиИзмененныхНастроек = 
		РегистрыСведений.ИзмененныеНастройкиСинхронизацииСМобильнымКлиентом.СоздатьМенеджерЗаписи();
	МенеджерЗаписиИзмененныхНастроек.Пользователь = Пользователь;
	МенеджерЗаписиИзмененныхНастроек.ВидНастройки = ВидНастройки;
	МенеджерЗаписиИзмененныхНастроек.Записать();
	
КонецПроцедуры


