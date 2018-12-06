﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ) 
	
	Если РаботаСоСканеромКлиент.ПроинициализироватьКомпоненту() Тогда
		
		МассивУстройств = РаботаСоСканеромКлиент.ПолучитьУстройства();
		Для Каждого Строка Из МассивУстройств Цикл
			СписокУстройств.Добавить(Строка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрытьВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	Если Элементы.СписокУстройств.ТекущиеДанные = Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Вам нужно выбрать сканер.'; en = 'You need to select a scanner.'"));				
		Возврат;
		
	КонецЕсли;	
	
	МассивСтруктур = Новый Массив;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/ИмяУстройства");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Элементы.СписокУстройств.ТекущиеДанные.Значение);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	Закрыть(Элемент);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстройствПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокУстройствПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокУстройствПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокУстройствВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаписатьИЗакрытьВыполнить();
	
КонецПроцедуры


