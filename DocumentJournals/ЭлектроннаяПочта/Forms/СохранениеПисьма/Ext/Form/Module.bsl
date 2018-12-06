﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("Письмо") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Письмо) = Тип("ДокументСсылка.ВходящееПисьмо")
		ИЛИ ТипЗнч(Параметры.Письмо) = Тип("ДокументСсылка.ИсходящееПисьмо") Тогда
		
		Письмо = Параметры.Письмо;
		
		ФайлыПисьма = ВстроеннаяПочтаСервер.ПолучитьФайлыПисьма(
			Письмо,
			Ложь, // ФормироватьРазмерПредставление
			Ложь, // ВключатьПомеченныеНаУдаление
			Ложь,    // ТолькоСИдентификаторами
			Истина); // ТолькоБезИдентификаторов  - чтобы картинки в HTML не показывать
		
		ДанныеФайлов = Новый Массив;
		СписокФайлов = Новый СписокЗначений();
		Для каждого ФайлыПисьмаСтрока Из ФайлыПисьма Цикл
			ДанныеФайлов.Добавить(ФайлыПисьмаСтрока.Ссылка);
			СписокФайлов.Добавить(ФайлыПисьмаСтрока.Ссылка);
		КонецЦикла;
		
		НаименованиеФайлаТекстаПисьма = Письмо.Тема;
		
		ДанныеПисьма = ВстроеннаяПочтаСервер.ПолучитьДанныеПисьмаДляСохраненияТекста(Письмо, УникальныйИдентификатор);
		ДанныеСохраняемыхФайлов = ВстроеннаяПочтаСервер.ПолучитьДанныеФайловДляСохраненияФайлов(СписокФайлов, УникальныйИдентификатор);
		
	ИначеЕсли ТипЗнч(Параметры.Письмо) = Тип("Структура") Тогда
		
		СтруктураПисьма = Параметры.Письмо;
		
		ДанныеФайлов = ДанныеФормыВЗначение(СтруктураПисьма.ФайлыПисьма, Тип("ТаблицаЗначений"));
		
		НаименованиеФайлаТекстаПисьма = СтруктураПисьма.ТемаПисьма;
		
		ДанныеПисьма = ВстроеннаяПочтаСервер.ПолучитьДанныеПисьмаДляСохраненияТекста(СтруктураПисьма, УникальныйИдентификатор);
		ДанныеСохраняемыхФайлов = ВстроеннаяПочтаСервер.ПолучитьДанныеФайловДляСохраненияФайлов(ДанныеФайлов, УникальныйИдентификатор);
		
	КонецЕсли;
	
	РасширениеДляЗашифрованныхФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭП", "РасширениеДляЗашифрованныхФайлов");
	Если ПустаяСтрока(РасширениеДляЗашифрованныхФайлов) Тогда
		РасширениеДляЗашифрованныхФайлов = "p7m";
	КонецЕсли;
	
	СформироватьСписокФайлов(ДанныеФайлов);
	ВыбраноФайлов = ПосчитатьКоличествоВыбранных(СписокФайловДляВыбора);
	
	ПапкаДляЭкспорта = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы", "ПапкаДляСохраненияПисем", "");
	ПапкаДляЭкспортаПрежняя = ПапкаДляЭкспорта;
	
	ПапкаДляТекстаПисьма = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы", "ПапкаДляСохраненияТекстаПисем", "");
	ПапкаДляТекстаПисьмаПрежняя = ПапкаДляТекстаПисьма;
	
	СписокВыбораПапкаТекста = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы, "СписокВыбораПапкаТекста");
	СписокВыбораПапкаФайла = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы, "СписокВыбораПапкаФайла");
	
	Расширение = "txt";
	ФорматСохраненияПисьма = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПерсональнуюНастройку("ФорматСохраненияПисьма");
	Если ФорматСохраненияПисьма = Перечисления.ФорматыСохраненияПисьма.HTML Тогда
		Расширение = "html";
	КонецЕсли;
	НаименованиеФайлаТекстаПисьма = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(НаименованиеФайлаТекстаПисьма, "_");
	Если ЗначениеЗаполнено(ПапкаДляТекстаПисьма) Тогда
		ПолноеИмяФайлаДляТекста = ПапкаДляТекстаПисьма + НаименованиеФайлаТекстаПисьма + "." + Расширение;
		
		// Проверка длинного имени файла
		ДопустимаяДлинаИмениФайла = 245;
		Если СтрДлина(ПолноеИмяФайлаДляТекста) > ДопустимаяДлинаИмениФайла Тогда
			МаксимальнаяДлинаИмениФайлаТекста = 230 - СтрДлина(ПапкаДляТекстаПисьма);
			Если МаксимальнаяДлинаИмениФайлаТекста > 0 Тогда
				НаименованиеФайлаТекстаПисьма = Лев(НаименованиеФайлаТекстаПисьма, МаксимальнаяДлинаИмениФайлаТекста);
				ПолноеИмяФайлаДляТекста = ПапкаДляТекстаПисьма + НаименованиеФайлаТекстаПисьма + "." + Расширение;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ПапкаДляЭкспорта) Тогда
		ПапкаДляЭкспорта = ФайловыеФункцииКлиент.НормализоватьКаталог(ПапкаДляЭкспорта);
	КонецЕсли;
	
	ВебКлиент = Ложь;
	РасширениеРаботыСФайламиПодключено = Ложь;
	#Если ВебКлиент Тогда
		ВебКлиент = Истина;
	#КонецЕсли
	
	Если ВебКлиент Тогда 
		РасширениеРаботыСФайламиПодключено = ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено();
		Если Не РасширениеРаботыСФайламиПодключено Тогда
			НачатьУстановкуРасширенияРаботыСФайлами();
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСпискиВыбора();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура НаименованиеФайлаТекстаПисьмаПриИзменении(Элемент)
	
	ЗаполнитьРеквизитыФайлаТекстаПисьмаПоПолномуНаименованию(ПолноеИмяФайлаДляТекста);
	
	НаименованиеФайлаТекстаПисьма = СокрЛП(НаименованиеФайлаТекстаПисьма);
	Попытка
		ФайловыеФункцииКлиент.КорректноеИмяФайла(НаименованиеФайлаТекстаПисьма, Истина);
	Исключение
		Информация = ИнформацияОбОшибке();
		ПоказатьПредупреждение(, Информация.Описание);
	КонецПопытки;
	
	НаименованиеФайлаТекстаПисьма = СокрЛП(НаименованиеФайлаТекстаПисьма);
	
	// Проверка длинного имени файла
	ДопустимаяДлинаИмениФайла = 255;
	Если СтрДлина(ПолноеИмяФайлаДляТекста) > ДопустимаяДлинаИмениФайла Тогда
		СтрокаПредупрежденияДлинноеНаименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Полный путь файла ""%1"" слишком длинный. Выберите другое имя или папку для сохранения.'; en = 'The full path of the file ""%1"" is too long. Please choose another file name or directory for saving.'"),
			НаименованиеФайлаТекстаПисьма);
		ПоказатьПредупреждение( , СтрокаПредупрежденияДлинноеНаименование);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеФайлаТекстаПисьмаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
					
	Расширение = "txt";
	// Только сохраненное письмо можно сохранить в HTML-формате.
	Если ФорматСохраненияПисьма = ПредопределенноеЗначение("Перечисление.ФорматыСохраненияПисьма.HTML")
		И ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Письмо) Тогда
		
		Расширение = "html";
	КонецЕсли;
	ИмяСРасширением = ФайловыеФункцииКлиент.ПолучитьИмяСРасширением(НаименованиеФайлаТекстаПисьма, Расширение);

	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ВыборФайла.МножественныйВыбор = Ложь;
	ВыборФайла.ПолноеИмяФайла = ИмяСРасширением;
	
	МассивРасширений = Новый Массив;
	МассивРасширений.Добавить("txt");
	МассивРасширений.Добавить("html");
	МассивПредставленийРасширений = Новый Массив;
	МассивПредставленийРасширений.Добавить(НСтр("ru = 'Простой текст'; en = 'Plain text'") + " (*.txt)|*.txt");
	// Только сохраненное письмо можно сохранить в HTML-формате.
	Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Письмо) Тогда
		МассивПредставленийРасширений.Добавить(НСтр("ru = 'Веб-страница'; en = 'Web page'") + " (*.html)|*.html");
	КонецЕсли;
	
	МассивФорматов = Новый Массив;
	МассивФорматов.Добавить(ПредопределенноеЗначение("Перечисление.ФорматыСохраненияПисьма.ПростойТекст"));
	// Только сохраненное письмо можно сохранить в HTML-формате.
	Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Письмо) Тогда
		МассивФорматов.Добавить(ПредопределенноеЗначение("Перечисление.ФорматыСохраненияПисьма.HTML"));
	КонецЕсли;
	
	Фильтр = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(МассивПредставленийРасширений, "|");
	ВыборФайла.ИндексФильтра = МассивРасширений.Найти(Расширение);
	ВыборФайла.Фильтр = Фильтр;
	ВыборФайла.Каталог = ПапкаДляТекстаПисьма;
			
	Если ВыборФайла.Выбрать() Тогда
		НаименованиеФайлаТекстаПисьма = ВыборФайла.ПолноеИмяФайла;
		ПолноеИмяФайлаДляТекста = ВыборФайла.ПолноеИмяФайла;
		ПапкаДляТекстаПисьма = ВыборФайла.Каталог;
		ПапкаДляЭкспорта = ПапкаДляТекстаПисьма; 
		ВыбранноеИмяСРасширением = СтрЗаменить(ПолноеИмяФайлаДляТекста, ПапкаДляТекстаПисьма, "");
		
		ФорматСохраненияПисьма = МассивФорматов[ВыборФайла.ИндексФильтра];
		Если ДанныеПисьма.Расширение <> МассивРасширений[ВыборФайла.ИндексФильтра] Тогда
			ДанныеПисьма = УстановитьФорматСохраненияПисьмаИВернутьНовыеДанныеПисьма(ФорматСохраненияПисьма, Письмо, УникальныйИдентификатор);
		КонецЕсли;
		НаименованиеФайлаТекстаПисьма = Лев(ВыбранноеИмяСРасширением, СтрДлина(ВыбранноеИмяСРасширением) - СтрДлина(ДанныеПисьма.Расширение) - 1);
		
	КонецЕсли;
				
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ПапкаДляЭкспорта) Тогда
		ПапкаДляЭкспорта = ФайловыеФункцииКлиент.НормализоватьКаталог(ПапкаДляЭкспорта);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Каталог = ПапкаДляЭкспорта;
	Диалог.Выбрать();
		
	Если ЗначениеЗаполнено(Диалог.Каталог) Тогда
		ПапкаДляЭкспорта = ФайловыеФункцииКлиент.НормализоватьКаталог(Диалог.Каталог);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловДляВыбораВыгружатьПриИзменении(Элемент)
	
	ВыбраноФайлов = ПосчитатьКоличествоВыбранных(СписокФайловДляВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеФайлаТекстаПисьмаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Расширение = "txt";
	ФорматСохраненияПисьма = ВстроеннаяПочтаСерверПовтИсп.ПолучитьПерсональнуюНастройку("ФорматСохраненияПисьма");
	Если ФорматСохраненияПисьма = ПредопределенноеЗначение("Перечисление.ФорматыСохраненияПисьма.HTML") Тогда
		Расширение = "html";
	КонецЕсли;
	
	Если Элемент.ТекстРедактирования <> ПолноеИмяФайлаДляТекста Тогда
		ЗаполнитьРеквизитыФайлаТекстаПисьмаПоПолномуНаименованию(Элемент.ТекстРедактирования);
	КонецЕсли;
	
	ПапкаДляТекстаПисьма = ВыбранноеЗначение;
	ПапкаДляЭкспорта = ВыбранноеЗначение; 
	ВыбранноеЗначение = ПапкаДляТекстаПисьма + НаименованиеФайлаТекстаПисьма + "." + Расширение;
	
	// Проверка длинного имени файла
	ДопустимаяДлинаИмениФайла = 255;
	Если СтрДлина(ВыбранноеЗначение) > ДопустимаяДлинаИмениФайла Тогда
		МаксимальнаяДлинаИмениФайлаТекста = 240 - СтрДлина(ПапкаДляТекстаПисьма);
		Если МаксимальнаяДлинаИмениФайлаТекста > 0 Тогда
			НаименованиеФайлаТекстаПисьма = Лев(НаименованиеФайлаТекстаПисьма, МаксимальнаяДлинаИмениФайлаТекста);
			ВыбранноеЗначение = ПапкаДляТекстаПисьма + НаименованиеФайлаТекстаПисьма + "." + Расширение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловДляВыбораПолноеНаименованиеПриИзменении(Элемент)
	
	Для Каждого ДанныеСтроки Из СписокФайловДляВыбора Цикл
		ДанныеСтроки.ИмяФайлаДляСохранения = 
			ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ДанныеСтроки.ИмяФайлаДляСохранения, "_");
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выгрузить(Команда)
	
	ОчиститьСообщения();
	ДопустимаяДлинаИмениФайла = 255;
	ЕстьПредупрежденияПересечениеИмен = Ложь;
	ЕстьПредупрежденияДлинноеНаименование = Ложь;
	СтрокаПредупреждения = "";
	СтрокаПредупрежденияДлинноеНаименование = "";
	МассивПредупреждений = Новый Массив;
	
	СписокИменФайлов = Новый СписокЗначений;
	СписокСчетчиковИменФайлов = Новый Массив;
	
	СохранитьТекст = Ложь;
	Если ЗначениеЗаполнено(ПолноеИмяФайлаДляТекста) Тогда
		СохранитьТекст = Истина;
		
		// Проверка заполнения название файла с текстом письма
		Если Не ЗначениеЗаполнено(НаименованиеФайлаТекстаПисьма) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не указано имя файла для текста письма'; en = 'No file name specified for the text of the email'"),
				, 
				"ПолноеИмяФайлаДляТекста");
			Возврат;
		КонецЕсли;
		
		// Проверка заполнения папки для текста письма
		Если Не ЗначениеЗаполнено(ПапкаДляТекстаПисьма) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не указана папка для сохранения текста письма'; en = 'Specify a directory to save message text'")
				,
				, 
				"ПолноеИмяФайлаДляТекста");
			Возврат;
		КонецЕсли;
		
		// Проверка формата файла текста письма
		РасширениеФайла = ФайловыеФункцииКлиентСервер.ПолучитьРасширениеИмениФайла(ПолноеИмяФайлаДляТекста);
		Если НРег(РасширениеФайла) <> "txt" И НРег(РасширениеФайла) <> "html" Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Сохранять текст письма возможно только в форматах TXT и HTML'; en = 'Save the text of the email is possible only in TXT and HTML formats'"),,
				"ПолноеИмяФайлаДляТекста");
			Возврат;
		КонецЕсли;
		
		// Проверка существования папки для текста письма
		КаталогВыгрузки = Новый Файл(ПапкаДляТекстаПисьма);
		Если Не КаталогВыгрузки.Существует() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Указанная папка не найдена'; en = 'The specified folder is not found'"),, "ПолноеИмяФайлаДляТекста");
			Возврат;			
		КонецЕсли;
		
		ИмяФайлаСРасширением = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(
			НаименованиеФайлаТекстаПисьма, 
			РасширениеФайла);
		ВыбранноеПолноеИмяФайла = ПапкаДляТекстаПисьма + ИмяФайлаСРасширением;
		Файл = Новый Файл(ВыбранноеПолноеИмяФайла);
		Если Файл.Существует() Тогда
			ЕстьПредупрежденияПересечениеИмен = Истина;
			
			Счетчик = 1;
			Пока Файл.Существует() Цикл
				ПредлагаемоеИмяФайла = 
					ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(
						НаименованиеФайлаТекстаПисьма + " (" + Строка(Счетчик) + ")", 
						РасширениеФайла); 
				ПредлагаемоеПолноеИмяФайла = ПапкаДляТекстаПисьма + ПредлагаемоеИмяФайла;
				Файл = Новый Файл(ПредлагаемоеПолноеИмяФайла);						
				Счетчик = Счетчик + 1;
			КонецЦикла;
            ДобавитьВМассивСчетчиков(ИмяФайлаСРасширением, Счетчик, СписокСчетчиковИменФайлов);
			
			СтрокаПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файл с именем ""%1"" уже существует в указанной папке. Можно сохранить с именем ""%2"".'; en = 'A file named ""%1"" already exists in the specified directory. You can save it with the name ""%2"".'") + Символы.ПС,
				ИмяФайлаСРасширением,
				ПредлагаемоеИмяФайла);
			ТекстОшибки = НСтр("ru = 'Файл с таким именем уже существует в указанной папке.'; en = 'A file with the same name already exists in the specified directory.'");		
			
			ОписаниеОшибки = Новый Структура;
			ОписаниеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
			ОписаниеОшибки.Вставить("ЭлементФормы", "ПолноеИмяФайлаДляТекста");
			
			МассивПредупреждений.Добавить(ОписаниеОшибки);
		КонецЕсли;
		
		// Проверка длинного имени файла
		Если ЗначениеЗаполнено(ПредлагаемоеПолноеИмяФайла) Тогда
			ВыбранноеПолноеИмяФайла = ПредлагаемоеПолноеИмяФайла;
		КонецЕсли;
		Если СтрДлина(ВыбранноеПолноеИмяФайла) > ДопустимаяДлинаИмениФайла Тогда
			ЕстьПредупрежденияДлинноеНаименование = Истина;
			
			СтрокаПредупрежденияДлинноеНаименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Полный путь файла ""%1"" слишком длинный.'; en = 'The full path of the file ""%1"" is too long.'") + Символы.ПС,
				ИмяФайлаСРасширением);
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Полный путь файла ""%1"" слишком длинный. Выберите другое имя или папку для сохранения.'; en = 'The full path of the file ""%1"" is too long. Please choose another file name or directory for saving.'"),
				ИмяФайлаСРасширением);
			
			ОписаниеОшибки = Новый Структура;
			ОписаниеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
			ОписаниеОшибки.Вставить("ЭлементФормы", "ПолноеИмяФайлаДляТекста");
			
			МассивПредупреждений.Добавить(ОписаниеОшибки);
		КонецЕсли;
		
		Если ПапкаДляТекстаПисьма = ПапкаДляЭкспорта Тогда
			СписокИменФайлов.Добавить(ИмяФайлаСРасширением);
		КонецЕсли;
		
	КонецЕсли;
	
	СохранитьФайлы = Ложь;
	КоличествоВыбранных = 0;
	Для Каждого ДанныеСтроки Из СписокФайловДляВыбора Цикл
		Если ДанныеСтроки.Выгружать Тогда
			КоличествоВыбранных = КоличествоВыбранных + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоВыбранных <> 0 Тогда
		СохранитьФайлы = Истина;
		
		// Проверка заполнения папки для текста письма
		Если Не ЗначениеЗаполнено(ПапкаДляЭкспорта) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана папка для сохранения файлов письма'; en = 'Specify a directory for saving email files'"),, "ПапкаДляЭкспорта");
			Возврат;
		КонецЕсли;
		
		// Проверка существования папки для экспорта
		КаталогВыгрузки = Новый Файл(ПапкаДляЭкспорта);
		Если Не КаталогВыгрузки.Существует() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Указанная папка не найдена'; en = 'The specified folder is not found'"),, "ПапкаДляЭкспорта");
			Возврат;			
		КонецЕсли;
		
		НомерСтроки = 1;
		Для Каждого ДанныеСтроки Из СписокФайловДляВыбора Цикл
			
			Если ДанныеСтроки.Выгружать Тогда
				ИмяФайлаСРасширением = ДанныеСтроки.ИмяФайлаДляСохранения;
				
				Наименование = ДанныеСтроки.ИмяФайлаДляСохранения;
				Расширение = ФайловыеФункцииКлиентСервер.ПолучитьРасширениеИмениФайла(ДанныеСтроки.ИмяФайлаДляСохранения);
				Если ЗначениеЗаполнено(Расширение) Тогда
					Наименование = Лев(Наименование, СтрДлина(Наименование) - СтрДлина(Расширение) - 1);
				КонецЕсли;
				
				ПредлагаемоеПолноеИмяФайла = "";
				ВыбранноеПолноеИмяФайла = ПапкаДляЭкспорта + ИмяФайлаСРасширением;
				Файл = Новый Файл(ВыбранноеПолноеИмяФайла);
				Если Файл.Существует() Тогда
					
					ЕстьПредупрежденияПересечениеИмен = Истина;
					
					Счетчик = НайтиВМассивеСчетчиков(ДанныеСтроки.ИмяФайлаДляСохранения, СписокСчетчиковИменФайлов);
					Пока Файл.Существует() Цикл
						ПредлагаемоеИмяФайла = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(Наименование + " (" + Строка(Счетчик) + ")", Расширение); 
						ПредлагаемоеПолноеИмяФайла = ПапкаДляЭкспорта + ПредлагаемоеИмяФайла;
						Файл = Новый Файл(ПредлагаемоеПолноеИмяФайла);						
						Счетчик = Счетчик + 1;
					КонецЦикла;
			        ДобавитьВМассивСчетчиков(ДанныеСтроки.ИмяФайлаДляСохранения, Счетчик, СписокСчетчиковИменФайлов);
					
					СтрокаПредупреждения = СтрокаПредупреждения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Файл с именем ""%1"" уже существует в указанной папке. Можно сохранить с именем ""%2"".'; en = 'A file named ""%1"" already exists in the specified directory. You can save it with the name ""%2"".'") + Символы.ПС,
						ИмяФайлаСРасширением,
						ПредлагаемоеИмяФайла);
					ТекстОшибки = НСтр("ru = 'Файл с таким именем уже существует в указанной папке.'; en = 'A file with the same name already exists in the specified directory.'");		
					ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"СписокФайловДляВыбора", 
						НомерСтроки,
						"ИмяФайлаДляСохранения");
								
					ОписаниеОшибки = Новый Структура;
					ОписаниеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
					ОписаниеОшибки.Вставить("ЭлементФормы", ПутьКТабличнойЧасти);
					
					МассивПредупреждений.Добавить(ОписаниеОшибки);
					
				КонецЕсли;
				
				Если СписокИменФайлов.НайтиПоЗначению(ИмяФайлаСРасширением) = Неопределено
					Или (ЗначениеЗаполнено(ПредлагаемоеПолноеИмяФайла)
					И СписокИменФайлов.НайтиПоЗначению(ПредлагаемоеПолноеИмяФайла) = Неопределено) Тогда
					
					СписокИменФайлов.Добавить(ИмяФайлаСРасширением);
					
				Иначе
					
					ЕстьПредупрежденияПересечениеИмен = Истина;
															
					Счетчик = НайтиВМассивеСчетчиков(ДанныеСтроки.ИмяФайлаДляСохранения, СписокСчетчиковИменФайлов);
					ПредлагаемоеИмяФайла = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(Наименование + " (" + Строка(Счетчик) + ")", Расширение);
					ПредлагаемоеПолноеИмяФайла = ПапкаДляЭкспорта + ПредлагаемоеИмяФайла;
					Счетчик = Счетчик + 1;
					Файл = Новый Файл(ПредлагаемоеПолноеИмяФайла);
					Пока Файл.Существует() Цикл						
						ПредлагаемоеИмяФайла = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(Наименование + " (" + Строка(Счетчик) + ")", Расширение); 
						ПредлагаемоеПолноеИмяФайла = ПапкаДляЭкспорта + ПредлагаемоеИмяФайла;
						Файл = Новый Файл(ПредлагаемоеПолноеИмяФайла);						
						Счетчик = Счетчик + 1;
					КонецЦикла;
					ДобавитьВМассивСчетчиков(ДанныеСтроки.ИмяФайлаДляСохранения, Счетчик, СписокСчетчиковИменФайлов);
					
					СтрокаПредупреждения = СтрокаПредупреждения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Файл с именем ""%1"" уже указан у письма. Можно сохранить с именем ""%2""'; en = 'Email already has file named ""%1"". You can save it with the name ""%2""'") + Символы.ПС,
						ИмяФайлаСРасширением,
						ПредлагаемоеИмяФайла);
					ТекстОшибки = НСтр("ru = 'Файл с таким именем уже указан у письма.'; en = 'Email already has the file with the same name.'");		
					ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"СписокФайловДляВыбора", 
						НомерСтроки,
						"ИмяФайлаДляСохранения");
								
					ОписаниеОшибки = Новый Структура;
					ОписаниеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
					ОписаниеОшибки.Вставить("ЭлементФормы", ПутьКТабличнойЧасти);
					
					МассивПредупреждений.Добавить(ОписаниеОшибки);
					
				КонецЕсли;
				
				// Проверка длинного имени файла
				Если ЗначениеЗаполнено(ПредлагаемоеПолноеИмяФайла) Тогда
					ВыбранноеПолноеИмяФайла = ПредлагаемоеПолноеИмяФайла;
				КонецЕсли;
				Если СтрДлина(ВыбранноеПолноеИмяФайла) > ДопустимаяДлинаИмениФайла Тогда
					ЕстьПредупрежденияДлинноеНаименование = Истина;
					
					СтрокаПредупрежденияДлинноеНаименование = СтрокаПредупрежденияДлинноеНаименование + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Полный путь файла ""%1"" слишком длинный.'; en = 'The full path of the file ""%1"" is too long.'") + Символы.ПС,
						ИмяФайлаСРасширением);
					ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Полный путь файла ""%1"" слишком длинный. Выберите другое имя или папку для сохранения.'; en = 'The full path of the file ""%1"" is too long. Please choose another file name or directory for saving.'"),
						ИмяФайлаСРасширением);
					
					ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"СписокФайловДляВыбора", 
						НомерСтроки,
						"ИмяФайлаДляСохранения");
					
					ОписаниеОшибки = Новый Структура;
					ОписаниеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
					ОписаниеОшибки.Вставить("ЭлементФормы", ПутьКТабличнойЧасти);
					
					МассивПредупреждений.Добавить(ОписаниеОшибки);
				КонецЕсли;
				
			КонецЕсли;
			
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
	КонецЕсли;
	
	// Проверка длинного имени файла
	Если ЕстьПредупрежденияДлинноеНаименование Тогда
		
		Для Каждого ОписаниеПредупреждения Из МассивПредупреждений Цикл
			ТекстОшибки = ОписаниеПредупреждения.ТекстОшибки;
			ЭлементФормы = ОписаниеПредупреждения.ЭлементФормы;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , ЭлементФормы);
		КонецЦикла;
		
		СтрокаПредупрежденияДлинноеНаименование = СтрокаПредупрежденияДлинноеНаименование
			+ Символы.ПС + НСтр("ru = 'Выберите другое имя файла или папку.'; en = 'Choose a different file name or folder.'");
		ПоказатьПредупреждение( , СтрокаПредупрежденияДлинноеНаименование);
		Возврат;
		
	КонецЕсли;
	
	Если Не СохранитьТекст И Не СохранитьФайлы Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для сохранения письма необходимо выбрать файл для сохранения текста письма или выбрать файлы для сохранения'; en = 'To save the emails, you must select a file to save the text of the email, or you can select files to be saved'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано полное имя файла для сохранения текста письма'; en = 'Specify the full name of the file to save the text of the email'"),, "ПолноеИмяФайлаДляТекста");
		Возврат;
	КонецЕсли;
	
	ТекстВариантаСохранитьСНовымИменем = НСтр("ru = 'Сохранить с предложенными именами'; en = 'Save with suggested names'");		
	ТекстВариантаУточнить = НСтр("ru = 'Уточнить вариант для каждого файла'; en = 'Refine option for each file'");
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ТекстВариантаСохранитьСНовымИменем", ТекстВариантаСохранитьСНовымИменем);
	ПараметрыОбработчика.Вставить("МассивПредупреждений", МассивПредупреждений);
	ПараметрыОбработчика.Вставить("СохранитьТекст", СохранитьТекст);
	ПараметрыОбработчика.Вставить("СохранитьФайлы", СохранитьФайлы);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузитьЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	Если ЕстьПредупрежденияПересечениеИмен Тогда
		
		ТекстВопроса = СтрокаПредупреждения + НСтр("ru = 'Выберите вариант сохранения для указанных файлов:'; en = 'Select saving option to the specified files:'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(ТекстВариантаСохранитьСНовымИменем);
		Кнопки.Добавить(ТекстВариантаУточнить);
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		
		Для Каждого ОписаниеПредупреждения Из ДополнительныеПараметры.МассивПредупреждений Цикл
			ТекстОшибки = ОписаниеПредупреждения.ТекстОшибки;
			ЭлементФормы = ОписаниеПредупреждения.ЭлементФормы;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , ЭлементФормы);	
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
	СохранитьСНовымИменем = (Результат = ДополнительныеПараметры.ТекстВариантаСохранитьСНовымИменем);
	
	Если ДополнительныеПараметры.СохранитьТекст Тогда
		ВстроеннаяПочтаКлиент.ЗаписатьТекстПисьма(ДанныеПисьма, УникальныйИдентификатор, Ложь, ПапкаДляТекстаПисьма, НаименованиеФайлаТекстаПисьма, СохранитьСНовымИменем);
	КонецЕсли;
	
	ОтложенноеЗакрытиеФормы = Ложь;
	Если ДополнительныеПараметры.СохранитьФайлы Тогда
		
		ЕстьФайлыДляВыгрузки = Ложь;
		ЕстьФайлыСОтказомОтВыгрузки = Ложь;
		Для Каждого ДанныеСтроки Из СписокФайловДляВыбора Цикл
			Если ДанныеСтроки.Выгружать Тогда
				ЕстьФайлыДляВыгрузки = Истина;
			Иначе
				ЕстьФайлыСОтказомОтВыгрузки = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьФайлыДляВыгрузки Тогда
			Если ЕстьФайлыСОтказомОтВыгрузки Тогда
				СформироватьСписокФайловКВыгрузке();
				ВстроеннаяПочтаКлиент.ОтобратьДанныеФайловДляСохранения(ДанныеСохраняемыхФайлов, СписокФайловКВыгрузке, ПапкаДляЭкспорта);
			Иначе
				ВстроеннаяПочтаКлиент.ОтобратьДанныеФайловДляСохранения(ДанныеСохраняемыхФайлов, СписокФайловДляВыбора, ПапкаДляЭкспорта);
			КонецЕсли;
			ВстроеннаяПочтаКлиент.ОтобратьДанныеФайловДляСохранения(ДанныеСохраняемыхФайлов, СписокФайловДляВыбора, ПапкаДляЭкспорта);
			
			ОтложенноеЗакрытиеФормы = Истина;
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"СохранитьЗавершение",
				ЭтотОбъект);
			
			РаботаСФайламиКлиент.СохранитьФайлы(ОписаниеОповещения, ДанныеСохраняемыхФайлов, УникальныйИдентификатор, "ПапкаДляСохраненияПисем", Истина, СохранитьСНовымИменем);
		КонецЕсли;
		
	КонецЕсли;
	
	Если (ПапкаДляТекстаПисьмаПрежняя <> ПапкаДляТекстаПисьма И ЗначениеЗаполнено(ПапкаДляТекстаПисьма))
		ИЛИ (ПапкаДляЭкспортаПрежняя <> ПапкаДляЭкспорта И ЗначениеЗаполнено(ПапкаДляЭкспорта)) Тогда
		
		ОбновитьСпискиВыбора();
		СохранитьНастройки();
		
	КонецЕсли;	
	
	Если ОтложенноеЗакрытиеФормы = Ложь Тогда
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗавершение(КодВозврата, Параметры) Экспорт 
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	Для Каждого Строка Из СписокФайловДляВыбора Цикл
		
		Строка.Выгружать = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	
	Для Каждого Строка Из СписокФайловДляВыбора Цикл
		
		Строка.Выгружать = Ложь;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура СформироватьСписокФайлов(ДанныеФайлов)
	
	Если ТипЗнч(ДанныеФайлов) = Тип("Массив") Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		               |	Файлы.ПолноеНаименование КАК ПолноеНаименование,
		               |	Файлы.ТекущаяВерсия.Расширение КАК Расширение,
		               |	Файлы.ТекущаяВерсия.Размер КАК Размер,
		               |	Файлы.Ссылка,
		               |	Файлы.ПометкаУдаления,
		               |	ИСТИНА КАК Выгружать,
		               |	ВЫБОР
		               |		КОГДА Файлы.ПометкаУдаления = ИСТИНА
		               |			ТОГДА Файлы.ИндексКартинки + 1
		               |		ИНАЧЕ Файлы.ИндексКартинки
		               |	КОНЕЦ КАК ИндексКартинки,
		               |	Файлы.ТекущаяВерсия
		               |ИЗ
		               |	Справочник.Файлы КАК Файлы
		               |ГДЕ
		               |	Файлы.Ссылка В(&МассивСсылок)
		               |	И Файлы.ТекущаяВерсия <> ЗНАЧЕНИЕ(Справочник.ВерсииФайлов.ПустаяСсылка)
		               |	И Файлы.ПометкаУдаления = ЛОЖЬ";
		Запрос.Параметры.Вставить("МассивСсылок", ДанныеФайлов);
		
		Результат = Запрос.Выполнить();
		ТаблицаФайлов = Результат.Выгрузить(ОбходРезультатаЗапроса.Прямой);
		ТаблицаФайлов.Колонки.Добавить("ПредставлениеФайла", Новый ОписаниеТипов("Строка"));
		ТаблицаФайлов.Колонки.Добавить("ИмяФайлаДляСохранения", Новый ОписаниеТипов("Строка"));
		ТаблицаФайлов.Колонки.Добавить("Адрес", Новый ОписаниеТипов("Строка"));
		
		Для Каждого СтрокаФайл Из ТаблицаФайлов Цикл
			
			ИмяСРасширением = СтрокаФайл.ПолноеНаименование;
			Расширение = СтрокаФайл.Расширение;
			Если Расширение <> "" Тогда
				ИмяСРасширением = ИмяСРасширением + "." + Расширение;
			КонецЕсли;
			
			РазмерФайла = ФайловыеФункцииКлиентСервер.ПолучитьСтрокуСРазмеромФайлаДляКарточкиПапки(СтрокаФайл.Размер);
			
			СтрокаФайл.ПредставлениеФайла = ИмяСРасширением + ", " + РазмерФайла;
			СтрокаФайл.ИмяФайлаДляСохранения = ИмяСРасширением;
			
			СтруктураКлюча = Новый Структура("ВерсияФайла", СтрокаФайл.ТекущаяВерсия);
			КлючЗаписи = РегистрыСведений.ХранимыеФайлыВерсий.СоздатьКлючЗаписи(СтруктураКлюча);
			НавигационнаяСсылкаТекущейВерсии = ПолучитьНавигационнуюСсылку(КлючЗаписи, "ХранимыйФайл");
			СтрокаФайл.Адрес = НавигационнаяСсылкаТекущейВерсии;
			
		КонецЦикла;
		
		ЗначениеВДанныеФормы(ТаблицаФайлов, СписокФайловДляВыбора);
		
	ИначеЕсли ТипЗнч(ДанныеФайлов) = Тип("ТаблицаЗначений") Тогда
		
		ТаблицаФайлов = РеквизитФормыВЗначение("СписокФайловДляВыбора");
		
		Для Каждого СтрокаФайл Из ДанныеФайлов Цикл
			
			НоваяСтрока = ТаблицаФайлов.Добавить();
			
			НоваяСтрока.Выгружать = Истина;
			НоваяСтрока.ИмяФайлаДляСохранения = СтрокаФайл.ИмяФайла;
			НоваяСтрока.ИндексКартинки = СтрокаФайл.ИндексКартинки;
			НоваяСтрока.ПолноеНаименование = СтрокаФайл.ИмяФайла;
			НоваяСтрока.ПредставлениеФайла = СтрокаФайл.ИмяФайла + ", " + СтрокаФайл.РазмерПредставление;
			НоваяСтрока.Размер = СтрокаФайл.Размер;
			НоваяСтрока.Расширение = ФайловыеФункцииКлиентСервер.ПолучитьРасширениеИмениФайла(СтрокаФайл.ИмяФайла);
			НоваяСтрока.Ссылка =СтрокаФайл.Ссылка;
			НоваяСтрока.Адрес = СтрокаФайл.Адрес;
			НоваяСтрока.ТекущаяВерсия = Справочники.ВерсииФайлов.ПустаяСсылка();
			
		КонецЦикла;
		
		ЗначениеВДанныеФормы(ТаблицаФайлов, СписокФайловДляВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПосчитатьКоличествоВыбранных(Список)
	
	КоличествоВыбранныхФайлов = 0;
	РазмерВыбранныхФайлов = 0;
	Для Каждого ЭлементСписка Из Список Цикл
		Если ЭлементСписка.Выгружать Тогда
			КоличествоВыбранныхФайлов = КоличествоВыбранныхФайлов + 1;
			РазмерВыбранныхФайлов = РазмерВыбранныхФайлов + ЭлементСписка.Размер;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоВыбранныхФайлов <> 0 Тогда
		ВыбраноФайлов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '%1 (%2)'; en = '%1 (%2)'"),
					КоличествоВыбранныхФайлов,
					ФайловыеФункцииКлиентСервер.ПолучитьСтрокуСРазмеромФайлаДляКарточкиПапки(РазмерВыбранныхФайлов));
	Иначе
		ВыбраноФайлов = НСтр("ru = 'нет'; en = 'none'");				
	КонецЕсли;
	Возврат ВыбраноФайлов;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройки()
	
	Если (ПапкаДляТекстаПисьмаПрежняя <> ПапкаДляТекстаПисьма И ЗначениеЗаполнено(ПапкаДляТекстаПисьма)) Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПрограммы", "ПапкаДляСохраненияТекстаПисем", ПапкаДляТекстаПисьма);	
	КонецЕсли;
	
	Если (ПапкаДляЭкспортаПрежняя <> ПапкаДляЭкспорта И ЗначениеЗаполнено(ПапкаДляЭкспорта)) Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПрограммы", "ПапкаДляСохраненияПисем", ПапкаДляЭкспорта);
	КонецЕсли;
	
	ХранилищеСистемныхНастроек.Сохранить(ИмяФормы, "СписокВыбораПапкаТекста", СписокВыбораПапкаТекста);
	ХранилищеСистемныхНастроек.Сохранить(ИмяФормы, "СписокВыбораПапкаФайла", СписокВыбораПапкаФайла);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокВыбора(Элемент, СписокВыбора, Значение = "")
		
	ХранитьЭлементов = 20;	
	
	Если ЗначениеЗаполнено(Значение) Тогда
		Для Индекс = 0 По СписокВыбора.Количество() - 1 Цикл
			
			ЭлементСпискаЗначений = СписокВыбора[Индекс];
			Если ЭлементСпискаЗначений.Значение = Значение Тогда
				СписокВыбора.Удалить(Индекс);
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		СписокВыбора.Вставить(0, Значение);	
		
		КоличествоСтрок = СписокВыбора.Количество();
		Пока КоличествоСтрок > ХранитьЭлементов Цикл
			СписокВыбора.Удалить(КоличествоСтрок - 1);
			КоличествоСтрок = КоличествоСтрок - 1;
		КонецЦикла;
	КонецЕсли;
	
	Элемент.СписокВыбора.Очистить();
	Для каждого Строка Из СписокВыбора Цикл
		Элемент.СписокВыбора.Добавить(Строка.Значение);
	КонецЦикла;
	
	Элемент.КнопкаВыпадающегоСписка = (Элемент.СписокВыбора.Количество() > 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСпискиВыбора(ЗаписатьПапки = Истина)
	
	Если ЗаписатьПапки Тогда
		ОбновитьСписокВыбора(Элементы.НаименованиеФайлаТекстаПисьма, СписокВыбораПапкаТекста, ПапкаДляТекстаПисьма);
		ОбновитьСписокВыбора(Элементы.КаталогВыгрузки, СписокВыбораПапкаФайла, ПапкаДляЭкспорта);
	Иначе
		ОбновитьСписокВыбора(Элементы.НаименованиеФайлаТекстаПисьма, СписокВыбораПапкаТекста);
		ОбновитьСписокВыбора(Элементы.КаталогВыгрузки, СписокВыбораПапкаФайла);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВМассивСчетчиков(Значение, Счетчик, МассивСчетчиков)

	Для Каждого ЭлементМассива Из МассивСчетчиков Цикл
		Если ЭлементМассива.Значение = Значение Тогда
			ЭлементМассива.Счетчик = Счетчик;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	Структура = Новый Структура;
	Структура.Вставить("Значение", Значение);
	Структура.Вставить("Счетчик", Счетчик);
	
	МассивСчетчиков.Добавить(Структура);
	
КонецПроцедуры

&НаКлиенте
Функция НайтиВМассивеСчетчиков(ИскомоеЗначение, МассивСчетчиков)
	
	Для Каждого ЭлементМассива Из МассивСчетчиков Цикл
		Если ЭлементМассива.Значение = ИскомоеЗначение Тогда
			Возврат ЭлементМассива.Счетчик; 
		КонецЕсли;
	КонецЦикла;
	
	Возврат 1;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьРеквизитыФайлаТекстаПисьмаПоПолномуНаименованию(ПолноеНаименование)
	
	НаименованиеФайлаТекстаПисьма = ПолучитьНаименованиеФайла(ПолноеНаименование);
	НаименованиеФайлаТекстаПисьма = 
		ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(НаименованиеФайлаТекстаПисьма, "_");
	
	ПапкаДляТекстаПисьма = ОбрезатьПоДлинеСтроки(ПолноеНаименование, НаименованиеФайлаТекстаПисьма);
	ПапкаДляТекстаПисьма =
		ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
			ПапкаДляТекстаПисьма, ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
	
	Расширение = ФайловыеФункцииКлиентСервер.ПолучитьРасширениеИмениФайла(НаименованиеФайлаТекстаПисьма);
	НаименованиеФайлаТекстаПисьма = ОбрезатьПоДлинеСтроки(НаименованиеФайлаТекстаПисьма, Расширение);
	
	Если ЗначениеЗаполнено(ПапкаДляТекстаПисьма) Тогда
		ПолноеИмяФайлаДляТекста = ПапкаДляТекстаПисьма + НаименованиеФайлаТекстаПисьма + "." + Расширение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьНаименованиеФайла(ПолноеНаименование)
	
	РазделительПути = "\";
	Если Найти(ПолноеНаименование, "/") > 0 Тогда
		РазделительПути = "/";
	КонецЕсли;
	
	Наименование = ПолучитьСтрокуОтделеннойСимволом(ПолноеНаименование, РазделительПути);
	Возврат Наименование;
	
КонецФункции

&НаКлиенте
Функция ПолучитьСтрокуОтделеннойСимволом(Знач ИсходнаяСтрока, Знач СимволПоиска)
	
	ПозицияСимвола = СтрДлина(ИсходнаяСтрока);
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИсходнаяСтрока, ПозицияСимвола, 1) = СимволПоиска Тогда
			
			Возврат Сред(ИсходнаяСтрока, ПозицияСимвола + 1); 
			
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;
		
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

&НаКлиенте
Функция ОбрезатьПоДлинеСтроки(Знач ИсходнаяСтрока, Знач ОбрабатываемаяСтрока)
	
	Если ЗначениеЗаполнено(ОбрабатываемаяСтрока) Тогда
		Возврат Лев(ИсходнаяСтрока, СтрДлина(ИсходнаяСтрока) - СтрДлина(ОбрабатываемаяСтрока) - 1);
	КонецЕсли;
		
	Возврат ИсходнаяСтрока;
	
КонецФункции

&НаСервере
Процедура СформироватьСписокФайловКВыгрузке()
	
	ТаблицаФайловКВыгрузке = РеквизитФормыВЗначение("СписокФайловДляВыбора");
	
	СтрокаНеВыгружать = ТаблицаФайловКВыгрузке.Найти(Ложь, "Выгружать");
	Пока ТаблицаФайловКВыгрузке.Найти(Ложь, "Выгружать") <> Неопределено Цикл
		ТаблицаФайловКВыгрузке.Удалить(СтрокаНеВыгружать);
		СтрокаНеВыгружать = ТаблицаФайловКВыгрузке.Найти(Ложь, "Выгружать");
	КонецЦикла;
	
	ЗначениеВДанныеФормы(ТаблицаФайловКВыгрузке, СписокФайловКВыгрузке);
	
КонецПроцедуры

&НаСервере
Функция УстановитьФорматСохраненияПисьмаИВернутьНовыеДанныеПисьма(ФорматСохраненияПисьма, Письмо, УникальныйИдентификатор)
	
	ВстроеннаяПочтаСервер.УстановитьПерсональнуюНастройку(
		"ФорматСохраненияПисьма",
		ФорматСохраненияПисьма);
	ОбновитьПовторноИспользуемыеЗначения();
	
	ДанныеПисьма = ВстроеннаяПочтаСервер.ПолучитьДанныеПисьмаДляСохраненияТекста(Письмо, УникальныйИдентификатор);
	
	Возврат ДанныеПисьма;
	
КонецФункции


