﻿&НаКлиенте
Процедура ЗаполнитьСписокФайлов(ПутьФайла, Знач ЭлементыДерева, ЭлементВерхнегоУровня, ТолькоКаталоги = Неопределено)
	ФайлПеренесенный = Новый Файл(ПутьФайла);
	
	НовыйЭлемент = ЭлементыДерева.Добавить();
	НовыйЭлемент.ПолныйПуть = ФайлПеренесенный.ПолноеИмя;
	НовыйЭлемент.ИмяФайла = ФайлПеренесенный.Имя;
	НовыйЭлемент.Пометка = Истина;
	
	Если ФайлПеренесенный.Расширение = "" Тогда
		НовыйЭлемент.ИндексКартинки = 2; // папка
	Иначе
		НовыйЭлемент.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлПеренесенный.Расширение);
		ЧислоФайлов = ЧислоФайлов + 1;
	КонецЕсли;
			
	Если ФайлПеренесенный.ЭтоКаталог() Тогда
		
		Путь = ФайлПеренесенный.ПолноеИмя + ПолучитьРазделительПути();
		
		Если ЭлементВерхнегоУровня = Истина Тогда
			Состояние(СтрШаблон(
				   НСтр("ru = 'Идет сбор информации о каталоге ""%1"". 
				   |Пожалуйста, подождите.';
				   |en = 'Collecting information about directory ""%1"". 
				   |Please wait...'"), Путь ));
		КонецЕсли;	   
		
		НайденныеФайлы = НайтиФайлы(Путь, "*.*");
		
		ФайлСортированные = Новый Массив;
		
		// папки сперва
		Для Каждого ФайлВложенный Из НайденныеФайлы Цикл
			Если ФайлВложенный.ЭтоКаталог() Тогда
				ФайлСортированные.Добавить(ФайлВложенный.ПолноеИмя);
			КонецЕсли;
		КонецЦикла;
		
		// потом файлы
		Для Каждого ФайлВложенный Из НайденныеФайлы Цикл
			Если НЕ ФайлВложенный.ЭтоКаталог() Тогда
				ФайлСортированные.Добавить(ФайлВложенный.ПолноеИмя);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ФайлВложенный Из ФайлСортированные Цикл
			ЗаполнитьСписокФайлов(ФайлВложенный, НовыйЭлемент.ПолучитьЭлементы(), Ложь);
		КонецЦикла;
		
	Иначе
		
		Если ЭлементВерхнегоУровня Тогда
			ТолькоКаталоги = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте импорт файлов не поддерживается. Используйте команду ""Создать"" в списке файлов.'; en = 'File import is not supported in Web client. Click the ""Create"" button in the file list form.'"));
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
	ХранитьВерсии = Истина;
	ТолькоКаталоги = Истина;
	ЧислоФайлов = 0;
	
	Для Каждого ПутьФайла Из СписокИменФайлов Цикл
		ЗаполнитьСписокФайлов(ПутьФайла, ДеревоФайлов.ПолучитьЭлементы(), Истина, ТолькоКаталоги);
	КонецЦикла;
	
	Если ТолькоКаталоги Тогда
		Заголовок = НСтр("ru='Загрузка папок'; en = 'Import folders'");
	Иначе	
		Если ЧислоФайлов = 0 Тогда
			Заголовок = НСтр("ru='Загрузка файлов'; en = 'Import files'");
		Иначе
			Заголовок = СтрШаблон(
				НСтр("ru='Загрузка файлов (%1)'; en = 'Import files (%1)'"), Строка(ЧислоФайлов));
		КонецЕсли;	
	КонецЕсли;
	
	Состояние();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Файлы.Форма.ВыборКодировки") Тогда
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		КодировкаТекстаФайла = ВыбранноеЗначение.Значение;
		КодировкаПредставление = ВыбранноеЗначение.Представление;
		УстановитьПредставлениеКомандыКодировки(КодировкаПредставление);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФайловуюСистему(ПсевдоФайловаяСистема, ЭлементДерева)
	Если ЭлементДерева.Пометка = Истина Тогда
		ДочерниеЭлементы = ЭлементДерева.ПолучитьЭлементы();
		Если ДочерниеЭлементы.Количество() <> 0 Тогда
			
			ФайлыИПодпапки = Новый Массив;
			Для Каждого ФайлВложенный Из ДочерниеЭлементы Цикл
				ЗаполнитьФайловуюСистему(ПсевдоФайловаяСистема, ФайлВложенный);
				
				Если ФайлВложенный.Пометка = Истина Тогда
					ФайлыИПодпапки.Добавить(ФайлВложенный.ПолныйПуть);
				КонецЕсли;
			КонецЦикла;
			
			ПсевдоФайловаяСистема.Вставить(ЭлементДерева.ПолныйПуть, ФайлыИПодпапки);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВыполнить()
	
	ОчиститьСообщения();
	
	ПоляНеЗаполнены = Ложь;
	
	ПсевдоФайловаяСистема = Новый Соответствие; // соответствие путь к директории - файлы и папки в ней 
	
	ВыбранныеФайлы = Новый СписокЗначений;
	Для Каждого файлВложенный Из ДеревоФайлов.ПолучитьЭлементы() Цикл
		Если файлВложенный.Пометка = Истина Тогда
			ВыбранныеФайлы.Добавить(файлВложенный.ПолныйПуть);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого файлВложенный Из ДеревоФайлов.ПолучитьЭлементы() Цикл
		ЗаполнитьФайловуюСистему(ПсевдоФайловаяСистема, файлВложенный);
	КонецЦикла;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нет файлов для добавления!'; en = 'No files to add!'"), , "ВыбранныеФайлы");
		ПоляНеЗаполнены = Истина;
	КонецЕсли;
	
	Если ПапкаДляДобавления.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Укажите папку!'; en = 'Specify the folder'"), , "ПапкаДляДобавления");
		ПоляНеЗаполнены = Истина;
	КонецЕсли;
	
	Если ПоляНеЗаполнены = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ДобавленныеФайлы = Новый Массив;
	ПараметрыРаспознавания = Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", 
		СтратегияРаспознавания, ЯзыкРаспознавания);
		
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДобавленныеФайлы", ДобавленныеФайлы);
	ПараметрыОбработчика.Вставить("ВладелецФайловДляДобавления", ПапкаДляДобавления);
	
	ПараметрыВыполнения = РаботаСФайламиКлиент.ПараметрыИмпортаФайлов();
	ПараметрыВыполнения.ОбработчикРезультата = 
		Новый ОписаниеОповещения("ДобавитьВыполнитьПослеИмпортаФайлов", ЭтотОбъект, ПараметрыОбработчика);
	ПараметрыВыполнения.Владелец = ПапкаДляДобавления;
	ПараметрыВыполнения.ВыбранныеФайлы = ВыбранныеФайлы; 
	ПараметрыВыполнения.Комментарий = Комментарий;
	ПараметрыВыполнения.ХранитьВерсии = ХранитьВерсии;
	ПараметрыВыполнения.УдалятьФайлыПослеДобавления = УдалятьФайлыПослеДобавления;
	ПараметрыВыполнения.Рекурсивно = Истина;
	ПараметрыВыполнения.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыВыполнения.ПсевдоФайловаяСистема = ПсевдоФайловаяСистема;
	ПараметрыВыполнения.Кодировка = КодировкаТекстаФайла;
	ПараметрыВыполнения.ПараметрыРаспознавания = ПараметрыРаспознавания;
	ПараметрыВыполнения.СписокКатегорий = СписокКатегорий;
	ПараметрыВыполнения.Проект = Проект;
	
	РаботаСФайламиКлиент.ВыполнитьИмпортФайлов(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВыполнитьПослеИмпортаФайлов(Результат, ПараметрыВыполнения) Экспорт
	
	Закрыть();
	Оповестить("ИмпортКаталоговЗавершен", Результат.Владелец);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Проект") Тогда 	
		Проект = Параметры.Проект;
	КонецЕсли;
	
	ПапкаДляДобавления = Параметры.ПапкаДляДобавления;
	
	Для Каждого путьФайла Из Параметры.МассивИменФайлов Цикл
		СписокИменФайлов.Добавить(путьФайла);
	КонецЦикла;
	
	ИспользоватьРаспознавание = РаботаСФайламиВызовСервера.ПолучитьИспользоватьРаспознавание();
	Элементы.ГруппаРаспознавание.Видимость = ИспользоватьРаспознавание;
	Если ИспользоватьРаспознавание = Ложь Тогда
		СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.НеРаспознавать;
	Иначе
		ЯзыкРаспознавания = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Распознавание", "ЯзыкРаспознавания");
		Если НЕ ЗначениеЗаполнено(ЯзыкРаспознавания) Тогда
			ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ПолучитьЯзыкРаспознавания();
		КонецЕсли;
		
		СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.ПоместитьТолькоВТекстовыйОбраз;
		
		ПредставлениеНастроекРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания);
		Команды.Настройка.Подсказка = ПредставлениеНастроекРаспознавания;
	КонецЕсли;	
	
	Команды.ВыбратьКодировку.Заголовок = НСтр("ru= 'По умолчанию'; en = 'Default'");

	Если Параметры.Свойство("СписокКатегорий") Тогда
		Для Каждого КатегорияВСписке Из Параметры.СписокКатегорий Цикл
			НоваяСтрока = СписокКатегорий.Добавить();
			НоваяСтрока.Значение = КатегорияВСписке.Значение;
			НоваяСтрока.ПолноеНаименование = РаботаСКатегориямиДанных.ПолучитьПолныйПутьКатегорииДанных( КатегорияВСписке.Значение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// рекурсивно ставит пометку всем дочерним элементам
&НаКлиенте
Процедура УстановитьПометку(ЭлементДерева, Пометка)
	ДочерниеЭлементы = ЭлементДерева.ПолучитьЭлементы();
	
	Для Каждого ФайлВложенный Из ДочерниеЭлементы Цикл
		ФайлВложенный.Пометка = Пометка;
		УстановитьПометку(ФайлВложенный, Пометка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоФайловПометкаПриИзменении(Элемент)
	ЭлементДанных = ДеревоФайлов.НайтиПоИдентификатору(Элементы.ДеревоФайлов.ТекущаяСтрока);
	УстановитьПометку(ЭлементДанных, ЭлементДанных.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиРаспознавания(Команда)
	
	ПараметрыОткрытия = Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", СтратегияРаспознавания, ЯзыкРаспознавания);	
	РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	Обработчик = Новый ОписаниеОповещения("ПослеВыбораНастроекРаспознавания", ЭтотОбъект);
	ОткрытьФорму("Справочник.Файлы.Форма.НастройкаРаспознавания", ПараметрыОткрытия, ЭтаФорма,,,,Обработчик, РежимОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНастроекРаспознавания(РезультатОткрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатОткрытия) = Тип("Структура") Тогда
		СтратегияРаспознавания = РезультатОткрытия.СтратегияРаспознавания;
		ЯзыкРаспознавания = РезультатОткрытия.ЯзыкРаспознавания;
		УстановитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания)
	
	ПредставлениеНастроекРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания);
	Команды.Настройка.Подсказка = ПредставлениеНастроекРаспознавания;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКатегории(Команда)
	
	РаботаСКатегориямиДанныхКлиент.ОткрытьФормуПодбораКатегорийДляСпискаКатегорий(СписокКатегорий);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеКомандыКодировки(Представление)
	
	Команды.ВыбратьКодировку.Заголовок = Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяКодировка", КодировкаТекстаФайла);
	ОткрытьФорму("Справочник.Файлы.Форма.ВыборКодировки", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоФайловПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоФайловПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры


