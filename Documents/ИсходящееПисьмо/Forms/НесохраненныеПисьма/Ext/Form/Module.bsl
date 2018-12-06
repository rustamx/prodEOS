﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если Не ВебКлиент Тогда			
	Каталог = КаталогВременныхФайлов();
	Каталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Каталог, 
		ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
		
	МаскаПоиска = "v8cln_Автосохранение_Новое_*.*";
	
	МассивФайлов = НайтиФайлы(Каталог, МаскаПоиска);
	
	ФайлыТекстов = Новый Соответствие;
	
	Для Каждого Файл Из МассивФайлов Цикл
		
		Если Файл.Существует() Тогда
			
			ИмяБезРасширения = Файл.ИмяБезРасширения;
			Тема = ПолучитьТему(ИмяБезРасширения);
			
			Описание = Новый Структура("ДатаСохранения, РазмерТекста, ПолныйПутьФайла",
				Файл.ПолучитьВремяИзменения(),
				Файл.Размер(),
				Файл.ПолноеИмя);
				
			НайденнаяСтруктура = ФайлыТекстов.Получить(Тема);	
			Если НайденнаяСтруктура = Неопределено Тогда
				
				ФайлыТекстов[Тема] = Описание;
				
			Иначе
				
				Если НайденнаяСтруктура.ДатаСохранения < Описание.ДатаСохранения Тогда
					ФайлыТекстов[Тема] = Описание;
				КонецЕсли;
				
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЦикла;	
	
	Для Каждого КлючИЗначение Из ФайлыТекстов Цикл
		
		Тема = КлючИЗначение.Ключ;
		Описание = КлючИЗначение.Значение;
		
		Строка = ТаблицаВерсий.Добавить();
		Строка.ДатаСохранения = Описание.ДатаСохранения;
		Строка.РазмерТекста = Описание.РазмерТекста;
		Строка.Тема = Тема;
		Строка.ПолныйПутьФайла = Описание.ПолныйПутьФайла;
		
	КонецЦикла;	
	
	
	ТаблицаВерсий.Сортировать("ДатаСохранения Убыв");
	
#КонецЕсли		

КонецПроцедуры

&НаКлиенте
Функция ПолучитьТему(ИмяБезРасширения)
	
	НачалоИмени = Лев(ИмяБезРасширения, СтрДлина(ИмяБезРасширения) - 15); // 15 - дата + _
	ДлинаНачала = СтрДлина("v8cln_Автосохранение_Новое_");
	Тема = Сред(НачалоИмени, ДлинаНачала + 1);
	Возврат Тема;
	
КонецФункции	


&НаКлиенте
Процедура Просмотреть(Команда)
	
	Если Элементы.ТаблицаВерсий.ТекущиеДанные <> Неопределено Тогда
		ПолныйПутьФайла = Элементы.ТаблицаВерсий.ТекущиеДанные.ПолныйПутьФайла;
		ЗапуститьПриложение(ПолныйПутьФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	
	Если Элементы.ТаблицаВерсий.ТекущиеДанные <> Неопределено Тогда
		
		ПолныйПутьФайла = Элементы.ТаблицаВерсий.ТекущиеДанные.ПолныйПутьФайла;
		Файл = Новый Файл(ПолныйПутьФайла);
		
		Если Файл.Существует() Тогда
			
			ИмяБезРасширения = Файл.ИмяБезРасширения;
			Тема = ПолучитьТему(ИмяБезРасширения);
			
			ЧтениеТекста = Новый ЧтениеТекста(ПолныйПутьФайла, КодировкаТекста.UTF8);
			ТекстПисьмаФайла = ЧтениеТекста.Прочитать();
			ЧтениеТекста.Закрыть();
			
			Расширение = Файл.Расширение;
			Если Найти(НРег(Расширение), "htm") <> 0 Тогда
				ВстроеннаяПочтаСервер.ДобавитьНеобходимыеТэгиHTML(ТекстПисьмаФайла);			
			КонецЕсли;	
			
			ПараметрыОткрытия = Новый Структура("ВосстановлениеПисьма", 
				Новый Структура("Тема, Текст, Расширение", Тема, ТекстПисьмаФайла, Расширение));
			ОткрытьФорму("Документ.ИсходящееПисьмо.ФормаОбъекта", ПараметрыОткрытия);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


