﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема ЕОК
// Клиентские и серверные процедуры и функции общего назначения
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область АвтозаполнениеШаблонов

//Осуществляет выборку всех полей в файле MSWord
//Параметры:Расширение - расширение файла ("doc" и т.п.)
//			ДвоичныеДанныеФайла - двоичные данные файла
//Возвращает:Массив наименований полей. Массив пустой, если в файле нет полей.
//Выполняет замену полей и строк в документе MSOffice 2007+ (OpenXML)
//Параметры:ЧтениеXML - объект ЧтениеXML, содержащий в себе файл, составляющий OpenOffice документ
//			ЗаписьXML - объект ЧтениеXML, содержащий в себе файл с измененными данными, составляющий OpenOffice документ
//			МассивДанныхДляАвтоЗамен - массив настроек для заполнения файла данными
Процедура ВыполнитьЗаменуПолейИСтрокВДокументеMSOfficeOpenXML(ЧтениеXML, ЗаписьXML, АдресXML, МассивДанныхДляАвтоЗамен) Экспорт
	
	КэшДанныхДляАвтоЗамен = Новый Соответствие;
	Для Каждого НастройкаЗамены Из МассивДанныхДляАвтоЗамен Цикл
		КэшДанныхДляАвтоЗамен.Вставить(НастройкаЗамены.ТермДляЗамены, НастройкаЗамены);
	КонецЦикла;
	
	ЧтениеXML.ОткрытьФайл(АдресXML);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	ЗакладкиDOM = Новый Соответствие;
	Для каждого ЗакладкаDOM Из ДокументDOM.ПолучитьЭлементыПоИмени("w:bookmarkStart") Цикл
		ЗакладкиDOM.Вставить(ПолучитьАтрибут(ЗакладкаDOM, "w:id"), ЗакладкаDOM);
	КонецЦикла;
	
	Для каждого ЗакладкаDOM Из ДокументDOM.ПолучитьЭлементыПоИмени("w:bookmarkEnd") Цикл
		НачалоЗакладки = ЗакладкиDOM[ПолучитьАтрибут(ЗакладкаDOM, "w:id")];
		Если НачалоЗакладки.РодительскийУзел <> ЗакладкаDOM.РодительскийУзел Тогда
			ЗакладкаDOM.РодительскийУзел.ВставитьПеред(НачалоЗакладки, ЗакладкаDOM.РодительскийУзел.ДочерниеУзлы.Элемент(0));
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ОписаниеЗакладки Из ПолучитьЗакладки(ДокументDOM, КэшДанныхДляАвтоЗамен) Цикл
		Если ТипЗнч(ОписаниеЗакладки.ЗначениеЗамены) <> Тип("Массив") Тогда
			ОписаниеЗакладки.text.ТекстовоеСодержимое = ?(ЗначениеЗаполнено(ОписаниеЗакладки.ЗначениеЗамены), ОписаниеЗакладки.ЗначениеЗамены, Нстр("ru = 'Не заполнено'; en = 'Not filled'"));
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТаблицаDOM Из ДокументDOM.ПолучитьЭлементыПоИмени("w:tbl") Цикл
		Для каждого СтрокаDOM Из ТаблицаDOM.ПолучитьЭлементыПоИмени("w:tr") Цикл
			Для каждого ОписаниеЗакладки Из ПолучитьЗакладки(СтрокаDOM, КэшДанныхДляАвтоЗамен) Цикл
				Если ТипЗнч(ОписаниеЗакладки.ЗначениеЗамены) = Тип("Массив") Тогда
					Для Н = 1 По ОписаниеЗакладки.ЗначениеЗамены.Количество() - ТаблицаDOM.ПолучитьЭлементыПоИмени("w:tr").Количество() + 1 Цикл
						ТаблицаDOM.ДобавитьДочерний(СтрокаDOM.КлонироватьУзел(Истина));
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Индексы = Новый Соответствие;
		Для каждого СтрокаDOM Из ТаблицаDOM.ПолучитьЭлементыПоИмени("w:tr") Цикл
			Для каждого ОписаниеЗакладки Из ПолучитьЗакладки(СтрокаDOM, КэшДанныхДляАвтоЗамен) Цикл
				Если ТипЗнч(ОписаниеЗакладки.ЗначениеЗамены) = Тип("Массив") Тогда
					Если Индексы[ОписаниеЗакладки.name] = Неопределено Тогда
						Индексы.Вставить(ОписаниеЗакладки.name, 0);
					КонецЕсли;
					
					Если ОписаниеЗакладки.ЗначениеЗамены.Количество() > Индексы[ОписаниеЗакладки.name] Тогда
						ЗначениеЗамены = ОписаниеЗакладки.ЗначениеЗамены[Индексы[ОписаниеЗакладки.name]].Значение;
						
						ОписаниеЗакладки.text.ТекстовоеСодержимое = ?(ЗначениеЗаполнено(ЗначениеЗамены), ЗначениеЗамены, "Не заполнено");
					Иначе
						ОписаниеЗакладки.text.ТекстовоеСодержимое = "Не заполнено";
					КонецЕсли;
					
					Индексы.Вставить(ОписаниеЗакладки.name, Индексы[ОписаниеЗакладки.name] + 1);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	ЗаписьXML.ОткрытьФайл(АдресXML);
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(ДокументDOM, ЗаписьXML);
	
КонецПроцедуры

//заполняет поля и строки в файле MSWord формата 2007+
Функция ЗаполнитьФайлMSWordВXML(ДвоичныеДанныеФайла, ТекущаяВерсияРасширение, МассивДанныхДляАвтоЗамен, ЗаменятьПространствоИмен = Истина, ФайлСсылка) Экспорт
	
	#Если Не ВебКлиент Тогда
		ВременнаяПапка = ПолучитьИмяВременногоФайла("");
		
		Поток = Новый ПотокВПамяти(ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ДвоичныеДанныеФайла));
		Архив = Новый ЧтениеZipФайла(Поток);
		Архив.ИзвлечьВсе(ВременнаяПапка, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		Архив.Закрыть();
		Поток.Закрыть();
		
		ИнтернетАдрес = ра_ОбщийМодульСервер.ИнтернетАдресЕОСК();
		
		ВыполнитьЗаменуПолейИСтрокВФайлеOpenXML(ВременнаяПапка + "/word/document.xml", МассивДанныхДляАвтоЗамен, ЗаменятьПространствоИмен, Ложь);
		
		Для Счетчик = 1 по 10 Цикл
			ВыполнитьЗаменуПолейИСтрокВФайлеOpenXML(ВременнаяПапка + "/word/header" + Счетчик + ".xml", МассивДанныхДляАвтоЗамен, ЗаменятьПространствоИмен);
			ВыполнитьЗаменуГиперссылкиВФайлеOpenXML(ВременнаяПапка, "header", Счетчик, ФайлСсылка, ИнтернетАдрес);
			
			ВыполнитьЗаменуПолейИСтрокВФайлеOpenXML(ВременнаяПапка + "/word/footer" + Счетчик + ".xml", МассивДанныхДляАвтоЗамен, ЗаменятьПространствоИмен);
			ВыполнитьЗаменуГиперссылкиВФайлеOpenXML(ВременнаяПапка, "footer", Счетчик, ФайлСсылка, ИнтернетАдрес);
		КонецЦикла;
		
		Архиватор = Новый ЗаписьZipФайла;
		Архиватор.Добавить(ВременнаяПапка + "\*.*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
		
		ДвоичныеДанныеЗаполненногоФайла = Архиватор.ПолучитьДвоичныеДанные();
		
		УдалитьФайлы(ВременнаяПапка);
		
		Возврат ДвоичныеДанныеЗаполненногоФайла;		
	#Иначе
		ВызватьИсключение "Функционал не доступен в веб-клиенте";
	#КонецЕсли

КонецФункции

#КонецОбласти

#Область Печать

// Формирует файл PDF по переданному файлу doc или docx
//
// Параметры:
//   ИмяФайлаСПутем  - полное имя файла doc или docx
//
// Возвращаемое значение:
//   Строка - Полный путь к временному файлу pdf
//
Функция ВыполнитьПечатьDOCToPDF(ИмяФайлаСПутем) Экспорт
	
	#Если Не ВебКлиент Тогда
		Попытка
			ИмяФайлаПечатиPDF = ПолучитьИмяВременногоФайла(".pdf");
			
			WordApp = Новый COMОбъект("Word.Application");
			Док = WordApp.Documents.Add(ИмяФайлаСПутем);
			
			Build = WordApp.Build;
			Если истина или Найти(Build, "12.") = 1 Или Найти(Build, "14.") = 1
				Или Найти(Build, "15.") = 1 Тогда
				Док.SaveAs(ИмяФайлаПечатиPDF, 17);
			Иначе
				Док.SaveAs(ИмяФайлаПечатиPDF);
			КонецЕсли;
			
			Док.Close(False);
			WordApp.Quit();
			
			WordApp = Неопределено;
			
			УдалитьФайлы(ИмяФайлаСПутем);
			
			Возврат Новый Структура("ИмяФайлаПечатиPDF, ОписаниеОшибки", ИмяФайлаПечатиPDF, "");
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			СообщениеОбОшибке = СтрШаблон(
			НСтр("ru = 'Не удалось вывести на печать файл шаблона.%1'; en = 'Unable to print template file.%1'"), Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
			#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
				ЗаписьЖурналаРегистрации("ОшибкаЗапускаWordПриПечатиPDF", УровеньЖурналаРегистрации.Ошибка,,, СообщениеОбОшибке);
				
			#Иначе
				ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации("ОшибкаЗапускаWordПриПечатиPDF", "Ошибка", СообщениеОбОшибке,, Истина);
				
				ПоказатьПредупреждение(, СообщениеОбОшибке);
			#КонецЕсли
			
			Возврат Новый Структура("ИмяФайлаПечатиPDF, ОписаниеОшибки", Неопределено, СообщениеОбОшибке);
		КонецПопытки;
	#Иначе
		ВызватьИсключение "Функционал не доступен в веб-клиенте";
	#КонецЕсли
КонецФункции

// Формирует файл PDF по переданному шаблону doc или docx
//
// Параметры:
//  ФайлШаблона  - <Справочник.Файлы> - Ссылка на конкретный файл шаблона
//  ДокументСсылка  - Ссылка на документ
//
// Возвращаемое значение:
//   Строка - Полный путь к временному файлу pdf
//
Функция СформироватьФайлPDFПоШаблону(ФайлШаблона, ДокументСсылка, МенеджерПечати = "", ФайлСсылка = Неопределено) Экспорт
	
	#Если Не ВебКлиент Тогда
		// ТСК Ткаченко И.Л.; 30.07.2018; Печать {
		Если ТипЗнч(ФайлШаблона) = Тип("СправочникСсылка.Файлы") И ра_ОбщийМодульСервер.ПолучитьРасширениеФайла(ФайлШаблона) = "mxl" Тогда 
			РезультатЗаполненияФайла = ПолучитьФайлДляПередачиЧерезМенеджер(ФайлШаблона, ДокументСсылка, МенеджерПечати = "");
		Иначе
			// ТСК Ткаченко И.Л.; 30.07.2018; Печать }
			РезультатЗаполненияФайла = АвтозаполнениеШаблоновФайловКлиентСервер.ЗаполнитьПоляФайлаДаннымиВладельца(
			Ложь,
			ФайлШаблона,
			Ложь,
			,
			ДокументСсылка,
			ФайлСсылка);
		КонецЕсли;
		
		Если РезультатЗаполненияФайла.Результат Тогда 
			Если РезультатЗаполненияФайла.Свойство("ДвоичныеДанныеЗаполненногоФайла")
				И РезультатЗаполненияФайла.ДвоичныеДанныеЗаполненногоФайла <> Неопределено Тогда
				
				ИмяФайлаСПутем = ПолучитьИмяВременногоФайла(".tmp");
				РезультатЗаполненияФайла.ДвоичныеДанныеЗаполненногоФайла.Записать(ИмяФайлаСПутем);
				
				Возврат ВыполнитьПечатьDOCToPDF(ИмяФайлаСПутем);
				// ТСК Ткаченко И.Л.; 30.07.2018; Печать {
			ИначеЕсли РезультатЗаполненияФайла.Свойство("ПутьКФайлу") Тогда 
				Возврат Новый Структура("ИмяФайлаПечатиPDF, ОписаниеОшибки", РезультатЗаполненияФайла.ПутьКФайлу, "");
				// ТСК Ткаченко И.Л.; 30.07.2018; Печать }
			КонецЕсли;
		Иначе
			Возврат Новый Структура("ИмяФайлаПечатиPDF, ОписаниеОшибки", Неопределено, РезультатЗаполненияФайла.Описание);
		КонецЕсли;
	#Иначе
		ВызватьИсключение "Функционал не доступен в веб-клиенте";
	#КонецЕсли

КонецФункции

#КонецОбласти

// Возвращает документ качества по виду внутреннего документа
//
Функция ДокументКачества(ВидВнутреннегоДокумента) Экспорт
	
	Кэш = Новый Соответствие;
	Для каждого Документ Из ДокументыКачества() Цикл
		Кэш.Вставить(ПредопределенноеЗначение("Справочник.ВидыВнутреннихДокументов." + Документ),
			ПредопределенноеЗначение("Документ." + Документ + ".ПустаяСсылка"));
	КонецЦикла;
	
	Возврат Кэш[ВидВнутреннегоДокумента];
	
КонецФункции

// Определяет перечень метаданных документов подсистемы качества
//
Функция ДокументыКачества(НаименованиеПодсистемы = "") Экспорт
	
	ДокументыКачества = Новый Массив;
	
	Если НаименованиеПодсистемы = "" Или НаименованиеПодсистемы = "УправлениеНесоответствиями" Тогда
		ДокументыКачества.Добавить("ra_AktObUstraneniiNesootvetstviya");
		ДокументыКачества.Добавить("ra_ItogovyjOtchetONesootvetstvii");
		ДокументыКачества.Добавить("ra_KorrektiruyushcheeDejstvie");
		ДокументыКачества.Добавить("ra_Nesootvetstvie");
		ДокументыКачества.Добавить("ra_OcenkaZnachimosti");
		ДокументыКачества.Добавить("ra_OtchetONesootvetstviiCHast1");
		ДокументыКачества.Добавить("ra_OtchetONesootvetstviiCHast2");
		ДокументыКачества.Добавить("ra_OtchetONesootvetstviiCHast3");
		ДокументыКачества.Добавить("ra_PreduprezhdayushcheeDejstvie");
		ДокументыКачества.Добавить("ra_Uvedomlenie");
		ДокументыКачества.Добавить("ra_VremennyeSderzhivayushchieDejstviyaIKorrekciya");
	КонецЕсли;
	
	Если НаименованиеПодсистемы = "" Или НаименованиеПодсистемы = "КонтрольныеОперации" Тогда
		ДокументыКачества.Добавить("ra_ZayavkaNaKontrolnuyuOperaciyu");
		ДокументыКачества.Добавить("ra_RezultatKontrolnoyOperacii");
	КонецЕсли;
	
	Если НаименованиеПодсистемы = "" Или НаименованиеПодсистемы = "ОценкаСоответствия" Тогда
		// ТСК Близнюк С.И.; 27.11.2018; task#1834{
		ДокументыКачества.Добавить("ra_ZayavkaNaOcenkuSootvetstviya3");
		// ТСК Близнюк С.И.; 27.11.2018; task#1834}
		
		ДокументыКачества.Добавить("ra_EHtapOcenkiSootvetstviyaPrinyatieResheniya");
		ДокументыКачества.Добавить("ra_EHtapOcenkiSootvetstviyaFormirovanieZadanij");
		ДокументыКачества.Добавить("ra_EHtapOcenkiSootvetstviyaVypolnenieZadanij");
		ДокументыКачества.Добавить("ra_EHtapOcenkiSootvetstviyaObsuzhdeniePredvRezultatov");
		ДокументыКачества.Добавить("ra_EHtapOcenkiSootvetstviyaOformlenieEhkspZaklyucheniya");	
		
	КонецЕсли;
	
	Если НаименованиеПодсистемы = "" Или НаименованиеПодсистемы = "УдалитьОценкаСоответствия1" Тогда
		ДокументыКачества.Добавить("ra_OperaciyaOcenkiSootvetstviya");
		ДокументыКачества.Добавить("ra_PlanProvedeniyaOcenkiSootvetstviya");
		ДокументыКачества.Добавить("ra_ZayavkaNaOcenkuSootvetstviya");
	КонецЕсли;
	
	Если НаименованиеПодсистемы = "" Или НаименованиеПодсистемы = "УдалитьОценкаСоответствия2" Тогда
		// ТСК Близнюк С.И.; 18.10.2018; task#1491{
		ДокументыКачества.Добавить("ra_ZayavkaNaOcenkuSootvetstviya2");
		ДокументыКачества.Добавить("ra_ResheniePoZayavke");
		ДокументыКачества.Добавить("ra_UvedomlenieObOtkazeVProvedeniiOS");
		ДокументыКачества.Добавить("ra_UvedomlenieOProvedeniiOS");
		ДокументыКачества.Добавить("ra_NaznachenieKomissii");
		ДокументыКачества.Добавить("ra_ProektEkspertnogoZaklyucheniya");
		ДокументыКачества.Добавить("ra_EkspertnoeZaklyuchenie");
		// ТСК Близнюк С.И.; 18.10.2018; task#1491}
	КонецЕсли;
	
	Если НаименованиеПодсистемы = "" Тогда
		ДокументыКачества.Добавить("ra_Signal");
	КонецЕсли;
	
	Возврат ДокументыКачества;
	
КонецФункции

// Определяет принадлежность документа подсистеме качества
//
// Параметры:
//  Объект					- Документ (ссылка, объект, метаданные)
//  НаименованиеПодсистемы  - Строка, наименование подсистемы качества
//
// Возвращаемое значение:
//   Булево - входит/не входит
//
Функция ЭтоДокументКачества(Объект, НаименованиеПодсистемы = "") Экспорт
	
	Если Объект = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДокументыКачества = ДокументыКачества(НаименованиеПодсистемы);
	
	ТипОбъекта = ТипЗнч(Объект);
	
	#Если Сервер Тогда
		Если ТипОбъекта = Тип("ОбъектМетаданных") Тогда
			Возврат ДокументыКачества.Найти(Объект.Имя) <> Неопределено;
		КонецЕсли;
	#КонецЕсли
	
	Если ТипОбъекта = Тип("Строка") Тогда
		Возврат ДокументыКачества.Найти(Объект) <> Неопределено;
	Иначе
		Для каждого ДокументКачества Из ДокументыКачества Цикл
			Если Тип("ДокументСсылка." + ДокументКачества) = ТипОбъекта Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
		
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Создаёт XLSX-файл с несколькими листами
//
// Параметры
//  ИмяФайла      - Имя выходного файла
//  СписокЛистов  -       (1) Список значений:
//          Представление - Строка - Имя листа
//          Значение      - Табличный документ - Содержимое листа
//                        (2) Таблица значений с колонками Ключ и Значение.
//                            Может понадобиться, если требуется строгий порядок листов.
Процедура СохранитьМногостраничныйФайл(ИмяФайла, СписокЛистов) Экспорт 
	
	#Если Не ВебКлиент Тогда
		ПриложениеExcel = ПолучитьCOMОбъект("", "Excel.Application");
		ПриложениеExcel.SheetsInNewWorkbook = 1;
		КнигаExcel = ПриложениеExcel.Workbooks.Add();
		
		ЭтоПервыйЛист = Истина;
		ПрошлыйЛистExcel = Неопределено;
		
		Для Каждого ЭлементСписка Из СписокЛистов Цикл 
			
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xlsx");
			ТабличныйДокумент = ЭлементСписка.Значение;
			ТабличныйДокумент.Записать(ИмяВременногоФайла, ТипФайлаТабличногоДокумента.XLSX); 
			
			ПриложениеExcel.CutCopyMode = False;
			
			КнигаExcelДоп = ПриложениеExcel.Workbooks.Open(ИмяВременногоФайла);
			КнигаExcelДоп.Worksheets(1).Cells.Select();
			ПриложениеExcel.Selection.Copy(); 
			
			Если ЭтоПервыйЛист Тогда
				НовыйЛистExcel = КнигаExcel.Worksheets(1);
				ЭтоПервыйЛист = Ложь;
			Иначе
				НовыйЛистExcel = КнигаExcel.Worksheets.Add(, ПрошлыйЛистExcel);
			КонецЕсли; 
			
			//Органичение на наименование листа Excel - 31 символ
			НовыйЛистExcel.Name = Лев(ЭлементСписка.Представление, 31);
			НовыйЛистExcel.Paste();
			
			НовыйЛистExcel.Activate();
			ПриложениеExcel.Range("A1").Select(); 
			
			ПрошлыйЛистExcel = НовыйЛистExcel;
			
		КонецЦикла;
		
		ПриложениеExcel.DisplayAlerts = False;
		КнигаExcel.Worksheets(1).Activate();
		КнигаExcel.SaveAs(ИмяФайла);
		
		ПриложениеExcel.Quit();
		
		ПриложениеExcel = Неопределено; 
	#Иначе
		ВызватьИсключение "Функционал не доступен в веб-клиенте";
	#КонецЕсли
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область АвтозаполнениеШаблонов

Процедура ВыполнитьЗаменуГиперссылкиВФайлеOpenXML(ВременнаяПапка, Колонтитул, Счетчик, Версия, ИнтернетАдрес)
	
	Если Версия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресXML1 = ВременнаяПапка + "/word/" + Колонтитул + Счетчик + ".xml";
	АдресXML2 = ВременнаяПапка + "/word/_rels/"+ Колонтитул + Счетчик + ".xml.rels";
	
	Если НайтиФайлы(АдресXML1).Количество() И НайтиФайлы(АдресXML2).Количество() Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(АдресXML1);
		
		ПостроительDOM = Новый ПостроительDOM;
		ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
		ЧтениеXML.Закрыть();
		
		Идентификаторы = "";
		
		Адрес = СтрШаблон("%1/ajax/downloadFile.php?GUID=%2&show=1", ИнтернетАдрес, Версия.УникальныйИдентификатор());
		
		Для каждого ГиперссылкаDOM Из ДокументDOM.ПолучитьЭлементыПоИмени("w:hyperlink") Цикл
			Для каждого ДочернийУзел Из ГиперссылкаDOM.ПолучитьЭлементыПоИмени("w:t") Цикл
				Если ДочернийУзел.ТекстовоеСодержимое = "HyperlinkToItself" Тогда
					Идентификаторы = Идентификаторы + "," + ПолучитьАтрибут(ГиперссылкаDOM, "r:id") + ",";
					ДочернийУзел.ТекстовоеСодержимое = Адрес;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.ОткрытьФайл(АдресXML1);
		
		ЗаписьDOM = Новый ЗаписьDOM;
		ЗаписьDOM.Записать(ДокументDOM, ЗаписьXML);
		
		Если Идентификаторы > "" Тогда
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.ОткрытьФайл(АдресXML2);
			
			ПостроительDOM = Новый ПостроительDOM;
			ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
			ЧтениеXML.Закрыть();
			
			Для каждого ГиперссылкаDOM Из ДокументDOM.ПолучитьЭлементыПоИмени("Relationship") Цикл
				Если СтрНайти(Идентификаторы, "," + ПолучитьАтрибут(ГиперссылкаDOM, "Id") + ",") Тогда
					Для каждого АтрибутDOM Из ГиперссылкаDOM.Атрибуты Цикл
						Если АтрибутDOM.ИмяУзла = "Target" Тогда
							АтрибутDOM.Значение = Адрес;
							АтрибутDOM.ЗначениеУзла = Адрес;
							АтрибутDOM.ТекстовоеСодержимое = Адрес;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
			
			ЗаписьXML = Новый ЗаписьXML;
			ЗаписьXML.ОткрытьФайл(АдресXML2);
			
			ЗаписьDOM = Новый ЗаписьDOM;
			ЗаписьDOM.Записать(ДокументDOM, ЗаписьXML);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьЗаменуПолейИСтрокВФайлеOpenXML(АдресXML, МассивДанныхДляАвтоЗамен, ЗаменятьПространствоИмен, ИскатьФайл = Истина)
	
	Если Не ИскатьФайл Или НайтиФайлы(АдресXML).Количество() Тогда
		Если ЗаменятьПространствоИмен Тогда
			АвтозаполнениеШаблоновФайловКлиентСервер.ЗаменитьПространствоИменR(АдресXML);
		КонецЕсли;
		ВыполнитьЗаменуПолейИСтрокВДокументеMSOfficeOpenXML(Новый ЧтениеXML, Новый ЗаписьXML, АдресXML, МассивДанныхДляАвтоЗамен);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьАтрибут(Элемент, Имя)
	
	Для каждого АтрибутDOM Из Элемент.Атрибуты Цикл
		Если АтрибутDOM.ИмяУзла = Имя Тогда
			Возврат АтрибутDOM.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

Функция ПолучитьЗакладки(Элемент, КэшДанныхДляАвтоЗамен)
	
	ЗакладкиDOM = Новый Соответствие;
	Для каждого ЗакладкаDOM Из Элемент.ПолучитьЭлементыПоИмени("w:fldChar") Цикл
		Если ПолучитьАтрибут(ЗакладкаDOM, "w:fldCharType") = "begin" Тогда
			Для каждого ЭлементЗакладки Из ЗакладкаDOM.ПолучитьЭлементыПоИмени("w:name") Цикл
				ЗакладкиDOM.Вставить(ПолучитьАтрибут(ЭлементЗакладки, "w:val"), ЗакладкаDOM);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ЗакладкаDOM Из Элемент.ПолучитьЭлементыПоИмени("w:bookmarkStart") Цикл
		Имя = ПолучитьАтрибут(ЗакладкаDOM, "w:name");
		Если Имя <> "_GoBack" Тогда
			ЗакладкиDOM.Вставить(ПолучитьАтрибут(ЗакладкаDOM, "w:name"), ЗакладкаDOM);
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Массив;
	
	Для каждого Закладка Из ЗакладкиDOM Цикл
		НастройкаЗамены = КэшДанныхДляАвтоЗамен[Закладка.Ключ];
		Если НастройкаЗамены <> Неопределено Тогда
			ОписаниеЗакладки = Новый Структура("name,id,instrText,text", Закладка.Ключ, "");
			
			Если Закладка.Значение.ИмяУзла = "w:bookmarkStart" Тогда
				ОписаниеЗакладки.Вставить("id", ПолучитьАтрибут(Закладка.Значение, "w:id"));
				
				Узел = Закладка.Значение.СледующийСоседний;
			Иначе
				Узел = Закладка.Значение.РодительскийУзел.СледующийСоседний;
			КонецЕсли;
			
			Пока Узел <> Неопределено Цикл
				Если Узел.ИмяУзла = "w:bookmarkEnd" И ОписаниеЗакладки.id = ПолучитьАтрибут(Узел, "w:id") Или ПолучитьАтрибут(Узел, "w:fldCharType") = "end" Тогда
					Прервать;
				КонецЕсли;
				
				Для каждого ДочернийУзел Из Узел.ДочерниеУзлы Цикл
					Если ДочернийУзел.ИмяУзла = "w:instrText" И ДочернийУзел.ТекстовоеСодержимое = " FORMTEXT " Тогда
						ОписаниеЗакладки.Вставить("instrText", ДочернийУзел);
					КонецЕсли;
					Если ДочернийУзел.ИмяУзла = "w:t" Тогда
						ОписаниеЗакладки.Вставить("text", ДочернийУзел);
					КонецЕсли;
				КонецЦикла;
				
				Узел = Узел.СледующийСоседний;
			КонецЦикла;
			
			Если ОписаниеЗакладки.instrText <> Неопределено И ОписаниеЗакладки.text <> Неопределено Тогда
				ОписаниеЗакладки.Вставить("ЗначениеЗамены", НастройкаЗамены.ЗначениеЗамены);
				
				Результат.Добавить(ОписаниеЗакладки);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Печать

Функция ПолучитьФайлДляПередачиЧерезМенеджер(ФайлШаблона, ДокументСсылка, МенеджерПечати = "")
	
	#Если Не ВебКлиент Тогда
		ДанныеВозврата = Новый Структура("Результат");
		
		Попытка
			Если СтрНайти(ФайлШаблона.Наименование,"Результаты согласования") <> 0 Тогда 
				
				МенеджерПечати = "Обработки.ра_ПечатьОбщихФорм";
				МассивОбъектов = Новый Массив;
				МассивОбъектов.Добавить(Документссылка);
				
				ФункцияПечати = "СформироватьПечатнуюФормуЛистаСогласования";
				
			Иначе
				
				МенеджерПечати = "Документы.ra_Nesootvetstvie";
				МассивОбъектов = Новый Массив;
				МассивОбъектов.Добавить(Документссылка);
				
				ФункцияПечати = "НерезультативныеМероприятия";
				
			КонецЕсли;
			ТабДокумент = Неопределено;
			
			
			Выполнить("ТабДокумент = " + МенеджерПечати + "." + ФункцияПечати + "(МассивОбъектов,Истина)");
			
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("pdf"); 
			ТабДокумент.Записать(ИмяВременногоФайла,ТипФайлаТабличногоДокумента.PDF);
			
			ДанныеВозврата.Результат = Истина;
			ДанныеВозврата.Вставить("ПутьКФайлу",ИмяВременногоФайла);
			
			Возврат ДанныеВозврата;  
			
		Исключение
			ДанныеВозврата.Результат = Ложь;
			ДанныеВозврата.Вставить("Описание",ОписаниеОшибки());
			
			Возврат ДанныеВозврата; 
			
		КонецПопытки;
	#Иначе
		ВызватьИсключение "Функционал не доступен в веб-клиенте";
	#КонецЕсли

КонецФункции

#КонецОбласти

#КонецОбласти
