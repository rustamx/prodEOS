﻿
// Заполняет данные регистра.
// 
Процедура ОбновитьВсеДанные() Экспорт
	
	Набор = РегистрыСведений.РазрешенияДляРазрезовДоступа.СоздатьНаборЗаписей();
	
	ТаблицаРазрезовДоступа = ДокументооборотПраваДоступаПовтИсп.ТаблицаРазрезовДоступа(Ложь);
	Для Каждого СтрВидаДоступа Из ТаблицаРазрезовДоступа Цикл
		
		Запрос = Новый Запрос("ВЫБРАТЬ Ссылка Из " + СтрВидаДоступа.ИмяТаблицыЗначенийДоступа);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Ссылка.ЭтоГруппа Тогда
				Продолжить;
			КонецЕсли;
			
			ВозможныеРазрешения = Новый Массив;
			ВозможныеРазрешения.Добавить(Выборка.Ссылка);
			ВозможныеРазрешения.Добавить(ДокументооборотПраваДоступа.РазрезДоступаПоЗначению(Выборка.Ссылка));
	
			МетаданныеЗначенияДоступа = Метаданные.НайтиПоПолномуИмени(СтрВидаДоступа.ИмяТаблицыЗначенийДоступа);
			Если МетаданныеЗначенияДоступа.Иерархический Тогда
				
				Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Ссылка, "Родитель");
				Пока ЗначениеЗаполнено(Родитель) Цикл
					ВозможныеРазрешения.Добавить(Родитель);
					Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "Родитель");
				КонецЦикла;
				
			КонецЕсли;
			
			Для Каждого Разрешение Из ВозможныеРазрешения Цикл
				Стр = Набор.Добавить();
				Стр.РазрезДоступа = Выборка.Ссылка;
				Стр.Разрешение = Разрешение;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Набор.Записать();
	
КонецПроцедуры


