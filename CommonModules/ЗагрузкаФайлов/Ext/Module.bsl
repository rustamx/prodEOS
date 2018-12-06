﻿
// Извлечь текст из файла и поместить в ХранилищеЗначения
Функция ИзвлечьТекстВХранилищеЗначения(ПолноеИмяФайла) Экспорт
	
	Текст = "";
	
	ИзвлекатьТекстыФайловНаСервере = Константы.ИзвлекатьТекстыФайловНаСервере.Получить();
	Если Не ИзвлекатьТекстыФайловНаСервере Тогда
		
		ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();
		Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
			
			Текст = ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекст(ПолноеИмяФайла);
			
		КонецЕсли;			
		
	КонецЕсли;

	Если ПустаяСтрока(Текст) Тогда
		Возврат Новый ХранилищеЗначения("");
	КонецЕсли;

	ХранилищеЗначения = Новый ХранилищеЗначения(Текст);
	
	Возврат ХранилищеЗначения;
	
КонецФункции

// Разыменовать lnk файл
Функция РазыменоватьLnkФайл(ВыбранныйФайл) Экспорт
	
	ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();
	
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
	
		ShellApp = Новый COMОбъект("shell.application");
		FolderObj = ShellApp.NameSpace(ВыбранныйФайл.Путь);		// полный (только) путь на lnk-файл
		FolderObjItem = FolderObj.items().item(ВыбранныйФайл.Имя); 	// только имя lnk-файла
		Link = FolderObjItem.GetLink();
		Возврат Новый Файл(Link.path);
		
	КонецЕсли;
	
	Возврат ВыбранныйФайл;
КонецФункции

// Рекурсивная функция импорта файлов с диска - принимает массив файлов (или каталогов)
// - если файл, просто добавляет его,   если каталог - создает группу и рекурсивно вызывает саму себя
Процедура ИмпортФайлов(
	Владелец, 
	Путь, 
	ФайлыАргумент, 
	Индикатор, 
	МассивИменФайловСОшибками, 
	МассивСтруктурВсехФайлов, 
	Комментарий, 
	ХранитьВерсии, 
	Рекурсивно, 
	КоличествоСуммарное, 
	Счетчик,
	ИдентификаторФормы,
	Знач ПсевдоФайловаяСистема,
	ДобавленныеФайлы,
	МассивВсехПапок,
	РежимЗагрузки,
	Пользователь,
	ПараметрыРаспознавания,
	Категории = Неопределено) Экспорт
	
	Перем ПерваяПапкаСТакимЖеИменем;
	Перем ДокГруппаСсылка;
	
	МаксРазмерФайла = ФайловыеФункции.ПолучитьМаксимальныйРазмерФайла();
	ЗапретЗагрузкиФайловПоРасширению = ФайловыеФункции.ПолучитьЗапретЗагрузкиФайловПоРасширению();
	СписокЗапрещенныхРасширений = ФайловыеФункции.ПолучитьСписокЗапрещенныхРасширений();
	
	Для Каждого ВыбранныйФайл Из ФайлыАргумент Цикл
		Попытка

			Если ВыбранныйФайл.Существует() Тогда

				Если ВыбранныйФайл.Расширение = ".lnk" Тогда
					ВыбранныйФайл = РазыменоватьLnkФайл(ВыбранныйФайл);
				КонецЕсли;
				
				Если ВыбранныйФайл.ЭтоКаталог() Тогда
					
					Если Рекурсивно = Истина Тогда
						НовыйПуть = Строка(ВыбранныйФайл.Путь);
						НовыйПуть = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
							НовыйПуть, ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера());
						НовыйПуть = НовыйПуть + Строка(ВыбранныйФайл.Имя);
						МассивФайлов = ФайловыеФункцииКлиентСервер.НайтиФайлыПсевдо(ПсевдоФайловаяСистема, НовыйПуть);
						
						// Создаем группу в справочнике - эквивалент папки на диске
						Если МассивФайлов.Количество() <> 0 Тогда
							ИмяФайла = ВыбранныйФайл.Имя;
							
							Если РаботаСФайламиВызовСервера.ЕстьПапкаСТакимИменем(ИмяФайла, Владелец, ПерваяПапкаСТакимЖеИменем) Тогда
								ДокГруппаСсылка = ПерваяПапкаСТакимЖеИменем;
							Иначе	
								ДокГруппаСсылка = РаботаСФайламиВызовСервера.СправочникиПапкиСоздатьЭлемент(ИмяФайла, Владелец, Пользователь);
							КонецЕсли;
							
							ИмпортФайлов(
								ДокГруппаСсылка, 
								НовыйПуть, 
								МассивФайлов, 
								Индикатор, 
								МассивИменФайловСОшибками, 
								МассивСтруктурВсехФайлов, 
								Комментарий, 
								ХранитьВерсии, 
								Рекурсивно, 
								КоличествоСуммарное, 
								Счетчик,
								ИдентификаторФормы,
								ПсевдоФайловаяСистема,
								ДобавленныеФайлы,
								МассивВсехПапок,
								РежимЗагрузки,
								Пользователь,
								ПараметрыРаспознавания,
								Категории);
								
							МассивВсехПапок.Добавить(НовыйПуть);	
						КонецЕсли;
					КонецЕсли;
				
					Продолжить;
				КонецЕсли;
				
				Если Не ФайловыеФункцииКлиентСервер.ФайлМожноЗагружать(ВыбранныйФайл, МаксРазмерФайла, ЗапретЗагрузкиФайловПоРасширению, СписокЗапрещенныхРасширений, МассивИменФайловСОшибками) Тогда
					Продолжить;
				КонецЕсли;	
					
				// Создаем Элемент справочника Файлы
				ИмяБезРасширения = ВыбранныйФайл.ИмяБезРасширения;
				Расширение = ВыбранныйФайл.Расширение;
				
				Если РежимЗагрузки Тогда
					Если РаботаСФайламиВызовСервера.ЕстьФайлСТакимИменем(ИмяБезРасширения, Владелец) Тогда
						Запись = Новый Структура;
						Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
						ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Файл с таким именем уже есть в информационной базе в папке ""%1""'; en = 'A file with the same name already exists in the infobase in folder ""%1""'"),
							Строка(Владелец));			
						Запись.Вставить("Ошибка", ТекстОшибки);
						МассивИменФайловСОшибками.Добавить(Запись);
						Продолжить;
					КонецЕсли;	
				КонецЕсли;	
				
				АдресВременногоХранилищаФайла = ВыбранныйФайл.ПолноеИмя;
				
				АдресВременногоХранилищаТекста = ИзвлечьТекстВХранилищеЗначения(
					ВыбранныйФайл.ПолноеИмя);

				// Создаем элемент справочника Файлы
				РаботаСФайламиКлиентСервер.СоздатьЭлементСправочникаФайлы(ВыбранныйФайл, МассивСтруктурВсехФайлов, 
					Владелец, ИдентификаторФормы, Комментарий, ХранитьВерсии, ДобавленныеФайлы,
					АдресВременногоХранилищаФайла, АдресВременногоХранилищаТекста, Пользователь,
					ПараметрыРаспознавания, Категории);
				
			Иначе
				Запись = Новый Структура;
				Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
				Запись.Вставить("Ошибка", НСтр("ru = 'Файл отсутствует на диске'; en = 'The file does not exist on disk'"));
				МассивИменФайловСОшибками.Добавить(Запись);
			КонецЕсли;

		Исключение
			ОшибкаИнфо = ИнформацияОбОшибке();
			СообщениеОбОшибке = "";
			Если ОшибкаИнфо.Причина = Неопределено Тогда
				СообщениеОбОшибке =ОшибкаИнфо.Описание;
			Иначе
				СообщениеОбОшибке = ОшибкаИнфо.Причина.Описание;
			КонецЕсли;
			
			Запись = Новый Структура;
			Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
			Запись.Вставить("Ошибка", СообщениеОбОшибке);
			МассивИменФайловСОшибками.Добавить(Запись);
		
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

// Импорт - с вспомогательными операциями типа проверки предельного размера и впоследствии удаления файлов и показа ошибок
//   при импорте только одной папки - вернет на нее ссылку.
Функция ИмпортФайловВыполнить(
	ПапкаДляДобавления, 
	ВыбранныеФайлы, 
	Комментарий, 
	ХранитьВерсии, 
	УдалятьФайлыПослеДобавления, 
	Рекурсивно, 
	ИдентификаторФормы,
	Знач ПсевдоФайловаяСистема,
	ДобавленныеФайлы,
	РежимЗагрузки,
	Пользователь,
	МассивИменФайловСОшибками,
	СтратегияРаспознавания,      
	ЯзыкРаспознавания,
	Категории) Экспорт
	
	Перем ПерваяПапкаСТакимЖеИменем;
	Перем ПапкаДляДобавленияТекущая;

	ВыбранКаталог = Ложь;
	Путь = "";
	КоличествоСуммарное = 0;
	
	МассивФайлов = Новый Массив;
	Счетчик = 0;
	Индикатор = 0;
	МассивСтруктурВсехФайлов = Новый Массив;
	МассивВсехПапок = Новый Массив;
	
	ПапкаДляДобавленияТекущая = Неопределено;
	
	// параметры распознавания по умолчанию	
	РаспознатьПослеДобавления = Истина;
	
	Если СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.НеРаспознавать Тогда
		РаспознатьПослеДобавления = Ложь;
	КонецЕсли;
	
	ИспользоватьРаспознавание = РаботаСФайламиВызовСервера.ПолучитьИспользоватьРаспознавание();
	Если ИспользоватьРаспознавание = Ложь Тогда
		РаспознатьПослеДобавления = Ложь;
	КонецЕсли;
	
	ПараметрыРаспознавания = Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания, РаспознатьПослеДобавления", 
		СтратегияРаспознавания, ЯзыкРаспознавания, РаспознатьПослеДобавления);
	
	Для Каждого ИмяФайла Из ВыбранныеФайлы Цикл
		Попытка
			ВыбранныйФайл = Новый Файл(ИмяФайла.Значение);
			
			ВыбранКаталог = Ложь;
			Если ВыбранныйФайл.Существует() Тогда
				ВыбранКаталог = ВыбранныйФайл.ЭтоКаталог();
			КонецЕсли;
			
			Если ВыбранКаталог Тогда
				Путь = ИмяФайла.Значение;
				МассивФайловЭтогоКаталога = ФайловыеФункцииКлиентСервер.НайтиФайлыПсевдо(ПсевдоФайловаяСистема, Путь);
				
				ИмяПапки = ВыбранныйФайл.Имя;
				
				Если РаботаСФайламиВызовСервера.ЕстьПапкаСТакимИменем(ИмяПапки, ПапкаДляДобавления, ПерваяПапкаСТакимЖеИменем) Тогда
					ПапкаДляДобавленияТекущая = ПерваяПапкаСТакимЖеИменем;
				Иначе	
					ПапкаДляДобавленияТекущая = РаботаСФайламиВызовСервера.СправочникиПапкиСоздатьЭлемент(ИмяПапки, ПапкаДляДобавления, Пользователь);
				КонецЕсли;
				
				// Собственно импорт 
				ИмпортФайлов(
					ПапкаДляДобавленияТекущая, 
					Путь, 
					МассивФайловЭтогоКаталога, 
					Индикатор, 
					МассивИменФайловСОшибками, 
					МассивСтруктурВсехФайлов, 
					Комментарий, 
					ХранитьВерсии, 
					Рекурсивно, 
					КоличествоСуммарное, 
					Счетчик,
					ИдентификаторФормы,
					ПсевдоФайловаяСистема,
					ДобавленныеФайлы,
					МассивВсехПапок,
					РежимЗагрузки,
					Пользователь,
					ПараметрыРаспознавания,
					Категории);
				МассивВсехПапок.Добавить(Путь);	
					
			Иначе
				МассивФайлов.Добавить(ВыбранныйФайл);
			КонецЕсли;
		Исключение
			// запись в журнал регистрации
			ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка автоматической загрузки файлов: ""%1""'; en = 'Error of automatic import of files: ""%1""'"),
					ОписаниеОшибки);			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Автоматическая загрузка файлов'; en = 'Automatic file import'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				УровеньЖурналаРегистрации.Ошибка, , ,
				ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Если МассивФайлов.Количество() <> 0 Тогда
		// Собственно импорт 
		ИмпортФайлов(
			ПапкаДляДобавления, 
			Путь, 
			МассивФайлов, 
			Индикатор, 
			МассивИменФайловСОшибками, 
			МассивСтруктурВсехФайлов, 
			Комментарий, 
			ХранитьВерсии, 
			Рекурсивно, 
			КоличествоСуммарное, 
			Счетчик,
			ИдентификаторФормы,
			ПсевдоФайловаяСистема,
			ДобавленныеФайлы,
			МассивВсехПапок,
			РежимЗагрузки,
			Пользователь,
			ПараметрыРаспознавания,
			Категории);
	КонецЕсли;
	
	Если УдалятьФайлыПослеДобавления = Истина Тогда
		ФайловыеФункцииКлиентСервер.УдалитьФайлыПослеДобавления(МассивСтруктурВсехФайлов, МассивВсехПапок, РежимЗагрузки);
	КонецЕсли;
	
	// Вывод сообщений об ошибках
	Для Каждого Выборка Из МассивИменФайловСОшибками Цикл
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка автоматической загрузки файла ""%1"": ""%2""'; en = 'Error of automatic import of file ""%1"" : ""%2""'"),
				Выборка.ИмяФайла, Выборка.Ошибка);
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Автоматическая загрузка файлов'; en = 'Automatic file import'", Метаданные.ОсновнойЯзык.КодЯзыка), 
			УровеньЖурналаРегистрации.Ошибка, , ,
			ТекстСообщения);
	КонецЦикла; 	
	
	Если ВыбранныеФайлы.Количество() <> 1 Тогда
		ПапкаДляДобавленияТекущая = Неопределено;
	КонецЕсли;	
	
	Возврат ПапкаДляДобавленияТекущая;
КонецФункции

Функция ЕстьПравоДоступа(Пользователь, Папка)
	
	// Если не включена функциональная опция "использовать права доступа" - то не делаем проверки.
	Если Не УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Папка, Пользователь).Добавление;
	
КонецФункции	

// Выполняет загрузку файлов с диска
Процедура ЗагрузкаФайлов(МассивНастроек) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Если ТипЗнч(МассивНастроек) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;	
	
	Для Каждого Настройка Из МассивНастроек Цикл
		
		КаталогНаДиске = "";
		ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();
		Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
			КаталогНаДиске = Настройка.КаталогWindows;
		Иначе	
			КаталогНаДиске = Настройка.КаталогLinux;
		КонецЕсли;	
		
		Категории = Неопределено;
		Если ТипЗнч(Настройка) = Тип("Структура") Тогда
			Настройка.Свойство("Категории", Категории);
		КонецЕсли;
		
		Папка = Настройка.Папка;
		Пользователь = Настройка.Пользователь;
		
		СтратегияРаспознавания = Неопределено;
		ЯзыкРаспознавания = Неопределено;
		
		Если Настройка.Свойство("СтратегияРаспознавания") Тогда
			СтратегияРаспознавания = Настройка.СтратегияРаспознавания;
		Иначе
			СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.ПоместитьТолькоВТекстовыйОбраз;
		КонецЕсли;	
		
		Если Настройка.Свойство("ЯзыкРаспознавания") Тогда
			ЯзыкРаспознавания = Настройка.ЯзыкРаспознавания;
		Иначе
			ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ПолучитьЯзыкРаспознавания();
		КонецЕсли;	
		
		Если ПустаяСтрока(КаталогНаДиске) Тогда
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Автоматическая загрузка файлов'; en = 'Automatic file import'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				УровеньЖурналаРегистрации.Ошибка, , ,
				НСтр("ru = 'Не указан каталог на диске'; en = 'Directory on disk is not specified'"));
			Продолжить;
		КонецЕсли;
		
		ФайлКаталога = Новый Файл(КаталогНаДиске);
		Если Не ФайлКаталога.Существует() Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неверный путь к каталогу на диске: ""%1""'; en = 'Invalid directory path: ""%1""'"),
					КаталогНаДиске);			
					
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Автоматическая загрузка файлов'; en = 'Automatic file import'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				УровеньЖурналаРегистрации.Ошибка, , ,
				ТекстОшибки);
				
			Продолжить;
		КонецЕсли;	
		
		Если Папка.Пустая() Тогда
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Автоматическая загрузка файлов'; en = 'Automatic file import'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				УровеньЖурналаРегистрации.Ошибка, , ,
				НСтр("ru = 'Не указана папка'; en = 'Folder is not specified'"));
			Продолжить;
		КонецЕсли;	
		
		Если Пользователь.Пустая() Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Автоматическая загрузка файлов'; en = 'Automatic file import'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				УровеньЖурналаРегистрации.Ошибка, , ,
				НСтр("ru = 'Не указан пользователь'; en = 'User is not specified'"));
			Продолжить;
		КонецЕсли;	
		
		Если Не ЕстьПравоДоступа(Пользователь, Папка) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У пользователя ""%1"" нет прав на добавление файлов в папку ""%2""'; en = 'User ""%1"" does not have permission to add files to folder ""%2""'"),
				Пользователь, Папка);
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Автоматическая загрузка файлов'; en = 'Automatic file import'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				УровеньЖурналаРегистрации.Ошибка, , ,
				ТекстОшибки);
			Продолжить;
			
		КонецЕсли;		
		
		Попытка
			
			ВыбранныеФайлы = Новый СписокЗначений;
			
			НайденныеФайлы = НайтиФайлы(КаталогНаДиске, "*.*");
			Для Каждого ФайлВложенный Из НайденныеФайлы Цикл
				ВыбранныеФайлы.Добавить(ФайлВложенный.ПолноеИмя);
			КонецЦикла;
			
			ПсевдоФайловаяСистема = Новый Соответствие; // соответствие путь к директории - файлы и папки в ней 
			ДобавленныеФайлы = Новый Массив;
			МассивИменФайловСОшибками = Новый Массив;
			
			Описание = "";
			ХранитьВерсии = Истина;
			УдалятьФайлыПослеДобавления = Истина;
			
			ПапкаДляДобавленияТекущая = ИмпортФайловВыполнить(
				Папка, 
				ВыбранныеФайлы, 
				Описание, 
				ХранитьВерсии, 
				УдалятьФайлыПослеДобавления, 
				Истина,
				Неопределено, //УникальныйИдентификатор,
				ПсевдоФайловаяСистема,
				ДобавленныеФайлы,
				Истина,  // режим загрузки
				Пользователь,
				МассивИменФайловСОшибками,
				СтратегияРаспознавания,
				ЯзыкРаспознавания,
				Категории);
				
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Закончена автоматическая загрузка файлов из каталога ""%1"" в папку ""%2"". Загружено файлов: %3. Не удалось загрузить файлов: %4.'; en = 'Completed automatic file import from directory ""%1"" to folder ""%2"". Imported files: %3. Files that could not be imported: %4.'"),
					КаталогНаДиске, Папка, ДобавленныеФайлы.Количество(), МассивИменФайловСОшибками.Количество());
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Автоматическая загрузка файлов'; en = 'Automatic file import'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				УровеньЖурналаРегистрации.Информация, , ,
				ТекстСообщения);
				
		Исключение
			// запись в журнал регистрации
			
			ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка автоматической загрузки файлов: ""%1""  из каталога ""%2"" в папку ""%3""'; en = 'Error of automatic import of files: ""%1"" from directory ""%2"" to folder ""%3""'"),
					ОписаниеОшибки, КаталогНаДиске, Папка);
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Автоматическая загрузка файлов'; en = 'Automatic file import'", Метаданные.ОсновнойЯзык.КодЯзыка), 
				УровеньЖурналаРегистрации.Ошибка, , ,
				ТекстСообщения);
		КонецПопытки;	
	
	КонецЦикла;	
	
КонецПроцедуры


