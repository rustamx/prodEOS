﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаПечать);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессСогласование(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		"Согласование", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Напечатать(Команда)
	
	#Если ВебКлиент Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте печать файлов не поддерживается.'; en = 'Printing files is not supported in web client.'"));
		Возврат;
	#КонецЕсли
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Если СистемнаяИнфо.ТипПлатформы <> ТипПлатформы.Windows_x86 
	   И СистемнаяИнфо.ТипПлатформы <> ТипПлатформы.Windows_x86_64 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Печать файлов возможна только в Windows.'; en = 'Printing files is only possible in Windows.'"));
		Возврат;
	КонецЕсли;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Обзор Тогда
		ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
		ВыделенныеСтроки = Элементы.Файлы.ВыделенныеСтроки;
	Иначе	
		ТекущиеДанные = Элементы.ФайлыСоздание.ТекущиеДанные;
		ВыделенныеСтроки = Элементы.ФайлыСоздание.ВыделенныеСтроки;
	КонецЕсли;
	
	Если ВыделенныеСтроки.Количество() > 1 Тогда
		МассивФайлов = Новый Массив;
		Для Каждого ВыбраннаяСтрока Из ВыделенныеСтроки Цикл
			Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Обзор Тогда
				ДанныеСтроки = Элементы.Файлы.ДанныеСтроки(ВыбраннаяСтрока);	
			Иначе	
				ДанныеСтроки = Элементы.ФайлыСоздание.ДанныеСтроки(ВыбраннаяСтрока);	
			КонецЕсли;
			МассивФайлов.Добавить(ДанныеСтроки.Ссылка);
		КонецЦикла;
		
		Если МассивФайлов.Количество() > 0 Тогда
			
			ДанныеФайлов = РаботаСФайламиВызовСервера.ДанныеФайловДляОткрытия(
				МассивФайлов, 
				ЭтаФорма.УникальныйИдентификатор);
				
			КомандыРаботыСФайламиКлиент.НапечататьФайлы(ДанныеФайлов);
			
		КонецЕсли;
	Иначе
		Если ТекущиеДанные = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
	
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
			ТекущиеДанные.Ссылка, 
			Неопределено, 
			ЭтаФорма.УникальныйИдентификатор, 
			Неопределено, 
			ПредыдущийАдресФайла);
		
		КомандыРаботыСФайламиКлиент.НапечататьФайл(ДанныеФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

