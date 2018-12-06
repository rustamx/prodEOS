﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не Параметры.Свойство("Документ", Отчет.Документ) Тогда
		Параметры.Свойство("ПараметрКоманды", Отчет.Документ);
	КонецЕсли;

	Элементы.Документ.ТолькоПросмотр = ЗначениеЗаполнено(Отчет.Документ);
	
	Если НЕ ЗначениеЗаполнено(СпособВыводаОтчета) Тогда
		СпособВыводаОтчета = Перечисления.СпособыВыводаОтчета.ПоВертикали;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	Значение = Настройки.Получить("СпособВыводаОтчета");
	Если Значение <> Неопределено Тогда
		СпособВыводаОтчета = Значение;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отчет.Документ) Тогда
		СформироватьОтчет();
		ОтчетСформирован = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)

	Настройки.Вставить("СпособВыводаОтчета", СпособВыводаОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если Не ОтчетСформирован И ЗначениеЗаполнено(Отчет.Документ) Тогда
		СформироватьОтчет();
		ОтчетСформирован = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособВыводаПриИзменении(Элемент)
	
	Сформировать(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)

	ОчиститьСообщения();
	СформироватьОтчет();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент.Очистить();

	Макет 				= РеквизитФормыВЗначение("Отчет").ПолучитьМакет("Макет");
	МетаданныеДокумента = Отчет.Документ.Метаданные();
	МассивРегистров     = ПолучитьМассивИспользуемыхРегистров(Отчет.Документ, МетаданныеДокумента.Движения);
	СписокРегистров 	= Новый СписокЗначений; // для упорядочивания по полному имени регистров
	
	Для Каждого МетаданныеРегистра Из МетаданныеДокумента.Движения Цикл
		Если МассивРегистров.Найти(МетаданныеРегистра.Имя) <> Неопределено Тогда
			СписокРегистров.Добавить(МетаданныеРегистра, МетаданныеРегистра.ПолноеИмя());
		КонецЕсли;
	КонецЦикла;
	
	СписокРегистров.СортироватьПоПредставлению();
	
	Для Каждого ЭлементСписка Из СписокРегистров Цикл
		ВывестиДанныеПоРегистру(ЭлементСписка.Значение, Макет);
	КонецЦикла;
	
	Если МассивРегистров.Количество() > 1 Тогда 
		ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(0);
	КонецЕсли;
	
КонецПроцедуры


// Функция формирует массив имен регистров, по которым документ имеет движения.
//  Вызывается при подготовке записей к регистрации движений.
//
// Параметры:
//  Регистратор					 - ДокументСсылка	 - ссылка на документ, для которого формируется список регистров
//  Движения					 - КоллекцияДвижений - движения документа
//  МассивИсключаемыхРегистров	 - Массив			 - исключаемые регистры
// 
// Возвращаемое значение:
//  Массив - массивимен регистров, по которым документ имеет движения.
//
Функция ПолучитьМассивИспользуемыхРегистров(Регистратор, Движения, МассивИсключаемыхРегистров = Неопределено) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Регистратор);

	Результат = Новый Массив;
	МаксимумТаблицВЗапросе = 256;

	СчетчикТаблиц   = 0;
	СчетчикДвижений = 0;

	ВсегоДвижений = Движения.Количество();
	ТекстЗапроса  = "";
	Для Каждого Движение Из Движения Цикл

		СчетчикДвижений = СчетчикДвижений + 1;

		ПропуститьРегистр = МассивИсключаемыхРегистров <> Неопределено
							И МассивИсключаемыхРегистров.Найти(Движение.Имя) <> Неопределено;

		Если Не ПропуститьРегистр Тогда

			Если СчетчикТаблиц > 0 Тогда

				ТекстЗапроса = ТекстЗапроса + "
				|ОБЪЕДИНИТЬ ВСЕ
				|";

			КонецЕсли;

			СчетчикТаблиц = СчетчикТаблиц + 1;

			ТекстЗапроса = ТекстЗапроса + 
			"
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|""" + Движение.Имя + """ КАК ИмяРегистра
			|
			|ИЗ " + Движение.ПолноеИмя() + "
			|
			|ГДЕ Регистратор = &Регистратор
			|";

		КонецЕсли;

		Если СчетчикТаблиц = МаксимумТаблицВЗапросе Или СчетчикДвижений = ВсегоДвижений Тогда

			Запрос.Текст  = ТекстЗапроса;
			ТекстЗапроса  = "";
			СчетчикТаблиц = 0;

			Если Результат.Количество() = 0 Тогда

				Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРегистра");

			Иначе

				Выборка = Запрос.Выполнить().Выбрать();
				Пока Выборка.Следующий() Цикл
					Результат.Добавить(Выборка.ИмяРегистра);
				КонецЦикла;

			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

#Область ПодготовкаДанных

&НаСервере
Функция ПолучитьДанныеПоДвижениям(МетаданныеРегистра, ВидРегистра)

	ТаблицаРесурсов         = Новый ТаблицаЗначений;
	ТаблицаИзмерений        = Новый ТаблицаЗначений;
	ТаблицаРеквизитов       = Новый ТаблицаЗначений;
	ТаблицаДанныеДляРасчета = Неопределено;
	ТаблицаВидДвижений      = Неопределено;

	СтруктураПолей = Новый Структура("Измерения, Реквизиты, ДанныеДляРасчета, Ресурсы");
	СтруктураПолей.Измерения 		= Новый Структура("СтрокаПолей, МассивРеквизитовАналитики", "", Новый Массив);
	СтруктураПолей.Реквизиты 		= Новый Структура("СтрокаПолей, МассивРеквизитовАналитики", "", Новый Массив);
	СтруктураПолей.ДанныеДляРасчета = Новый Структура("СтрокаПолей, МассивРеквизитовАналитики", "", Новый Массив);
	СтруктураПолей.Ресурсы 			= Новый Структура("СтрокаПолей, МассивРеквизитовАналитики", "", Новый Массив);
	
	ТекстСоединения   = "";
	ТекстПолейВыборки = "";

	Для Счетчик = 1 По 2 Цикл

		Если Счетчик = 1 Тогда
			ИмяКоллекции = "Измерения";
			ИмяТаблицы = ТаблицаИзмерений;
		Иначе
			ИмяКоллекции = "Реквизиты";
			ИмяТаблицы = ТаблицаРеквизитов;
		КонецЕсли;
	
		Для Каждого Измерение Из МетаданныеРегистра[ИмяКоллекции] Цикл

			Если ПолеОтключеноФункциональнойОпцией(Измерение) Тогда
				Продолжить;
			КонецЕсли;

			НуженДтКт = ВидРегистра = "Бухгалтерии" И ИмяКоллекции = "Измерения" И НЕ Измерение.Балансовый;

			Если НуженДтКт Тогда

				ДобавитьКолонкуВТаблицу(Измерение, ИмяТаблицы, "Дт");
				ДобавитьКолонкуВТаблицу(Измерение, ИмяТаблицы, "Кт");

			Иначе

				ДобавитьКолонкуВТаблицу(Измерение, ИмяТаблицы);

			КонецЕсли;

			//Если Измерение.Тип.СодержитТип(Тип("СправочникСсылка.КлючиАналитикиУчетаНоменклатуры")) И Измерение.Тип.Типы().Количество() = 1 Тогда

			//	ПсевдонимТаблицы = "Аналитика" + Измерение.Имя;

			//	ТекстПоля = "" + ПсевдонимТаблицы +".Номенклатура      КАК " + Измерение.Имя + "Номенклатура,
			//				|" + ПсевдонимТаблицы +".Характеристика    КАК " + Измерение.Имя + "Характеристика,
			//				|" + ПсевдонимТаблицы +".Серия             КАК " + Измерение.Имя + "Серия,
			//				|" + ПсевдонимТаблицы +".Склад             КАК " + Измерение.Имя + "Склад,
			//				//++ НЕ УТ
			//				|" + ПсевдонимТаблицы +".СтатьяКалькуляции КАК " + Измерение.Имя + "СтатьяКалькуляции,
			//				//-- НЕ УТ
			//				|" + ПсевдонимТаблицы +".Назначение        КАК " + Измерение.Имя + "Назначение,";
			//				
			//	ТекстСоединения = ТекстСоединения + ?(ПустаяСтрока(ТекстСоединения), "", Символы.ПС)
			//					+ " ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК " + ПсевдонимТаблицы + "
			//						|ПО Таблица." + Измерение.Имя + " = " + ПсевдонимТаблицы +".КлючАналитики
			//						|	И Таблица." + Измерение.Имя + " <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)";

			//	МассивПолей = Новый Массив;
			//	МассивПолей.Добавить(Измерение.Имя + "Номенклатура");
			//	МассивПолей.Добавить(Измерение.Имя + "Характеристика");
			//	МассивПолей.Добавить(Измерение.Имя + "Серия");
			//	МассивПолей.Добавить(Измерение.Имя + "Склад");
			//	МассивПолей.Добавить(Измерение.Имя + "Назначение");
			//	//++ НЕ УТ
			//	МассивПолей.Добавить(Измерение.Имя + "СтатьяКалькуляции");
			//	//-- НЕ УТ

			//	СтруктураПолей[ИмяКоллекции].МассивРеквизитовАналитики.Добавить(
			//			Новый Структура("Поле, МассивПолей",
			//							Измерение.Имя,
			//							МассивПолей));

			//ИначеЕсли Измерение.Тип.СодержитТип(Тип("СправочникСсылка.КлючиАналитикиУчетаПоПартнерам")) И Измерение.Тип.Типы().Количество() = 1 Тогда

			//	ПсевдонимТаблицы = "Аналитика" + Измерение.Имя;

			//	ТекстПоля = "" + ПсевдонимТаблицы +".Партнер     КАК " + Измерение.Имя + "Партнер,
			//				|" + ПсевдонимТаблицы +".Организация КАК " + Измерение.Имя + "Организация,
			//				|" + ПсевдонимТаблицы +".Контрагент  КАК " + Измерение.Имя + "Контрагент,
			//				|" + ПсевдонимТаблицы +".Договор     КАК " + Измерение.Имя + "Договор,
			//				|" + ПсевдонимТаблицы +".НаправлениеДеятельности     КАК " + Измерение.Имя + "НаправлениеДеятельности,";

			//	ТекстСоединения = ТекстСоединения + ?(ПустаяСтрока(ТекстСоединения), "", Символы.ПС)
			//				+ " ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК " + ПсевдонимТаблицы +"
			//					|ПО Таблица." + Измерение.Имя + " = " + ПсевдонимТаблицы + ".КлючАналитики
			//					|	И Таблица." + Измерение.Имя + " <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПоПартнерам.ПустаяСсылка)";

			//	МассивПолей = Новый Массив;
			//	МассивПолей.Добавить(Измерение.Имя + "Партнер");
			//	МассивПолей.Добавить(Измерение.Имя + "Организация");
			//	МассивПолей.Добавить(Измерение.Имя + "Контрагент");
			//	МассивПолей.Добавить(Измерение.Имя + "Договор");
			//	МассивПолей.Добавить(Измерение.Имя + "НаправлениеДеятельности");
			//	
			//	СтруктураПолей[ИмяКоллекции].МассивРеквизитовАналитики.Добавить(
			//			Новый Структура("Поле, МассивПолей",
			//							Измерение.Имя,
			//							МассивПолей));
			//							
			//ИначеЕсли Измерение.Тип.СодержитТип(Тип("СправочникСсылка.КлючиАналитикиУчетаПартий")) И Измерение.Тип.Типы().Количество() = 1 Тогда

			//	ПсевдонимТаблицы = "Аналитика" + Измерение.Имя;

			//	ТекстПоля = "" + ПсевдонимТаблицы +".ГруппаФинансовогоУчета     КАК " + Измерение.Имя + "ГруппаФинансовогоУчета,
			//				|" + ПсевдонимТаблицы +".Поставщик                  КАК " + Измерение.Имя + "Поставщик,
			//				|" + ПсевдонимТаблицы +".Контрагент                 КАК " + Измерение.Имя + "Контрагент,
			//				|" + ПсевдонимТаблицы +".НалогообложениеНДС         КАК " + Измерение.Имя + "НалогообложениеНДС,
			//				|" + ПсевдонимТаблицы +".СтавкаНДС                  КАК " + Измерение.Имя + "СтавкаНДС,
			//				|" + ПсевдонимТаблицы +".ВидЦенности                КАК " + Измерение.Имя + "ВидЦенности,";

			//	ТекстСоединения = ТекстСоединения + ?(ПустаяСтрока(ТекстСоединения), "", Символы.ПС)
			//				+ " ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПартий КАК " + ПсевдонимТаблицы +"
			//					|ПО Таблица." + Измерение.Имя + " = " + ПсевдонимТаблицы + ".КлючАналитики";

			//	МассивПолей = Новый Массив;
			//	МассивПолей.Добавить(Измерение.Имя + "ГруппаФинансовогоУчета");
			//	МассивПолей.Добавить(Измерение.Имя + "Поставщик");
			//	МассивПолей.Добавить(Измерение.Имя + "Контрагент");
			//	МассивПолей.Добавить(Измерение.Имя + "НалогообложениеНДС");
			//	МассивПолей.Добавить(Измерение.Имя + "СтавкаНДС");
			//	МассивПолей.Добавить(Измерение.Имя + "ВидЦенности");

			//	СтруктураПолей[ИмяКоллекции].МассивРеквизитовАналитики.Добавить(
			//			Новый Структура("Поле, МассивПолей",
			//							Измерение.Имя,
			//							МассивПолей));
				
			Если НуженДтКт Тогда
				
				ТекстПоля = " Таблица." + Измерение.Имя + "Дт КАК " + Измерение.Имя + "Дт,
							| Таблица." + Измерение.Имя + "Кт КАК " + Измерение.Имя + "Кт, ";
				
				СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей
								+ ?(ПустаяСтрока(СтруктураПолей[ИмяКоллекции].СтрокаПолей),"", ",") 
								+ Измерение.Имя + "Дт," + Измерение.Имя + "Кт";
				
			Иначе
				
				ТекстПоля = " Таблица." + Измерение.Имя + " КАК " + Измерение.Имя + ", ";
				
				СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей
								+ ?(ПустаяСтрока(СтруктураПолей[ИмяКоллекции].СтрокаПолей),"", ",") + Измерение.Имя;
				
			КонецЕсли;
			
			ТекстПолейВыборки = ТекстПолейВыборки + Символы.ПС + ТекстПоля;
			
		КонецЦикла;

	КонецЦикла;

	ИмяКоллекции = "Ресурсы";
	Для Каждого Ресурс Из МетаданныеРегистра[ИмяКоллекции] Цикл

		НуженДтКт = ВидРегистра = "Бухгалтерии" И НЕ Ресурс.Балансовый;

		Если НуженДтКт Тогда
			
			ТекстПолейВыборки = ТекстПолейВыборки + "
								|Таблица." + Ресурс.Имя + "Дт КАК " + Ресурс.Имя +"Дт,
								|Таблица." + Ресурс.Имя + "Кт КАК " + Ресурс.Имя +"Кт, ";
			
			СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей
								+ ?(ПустаяСтрока(СтруктураПолей[ИмяКоллекции].СтрокаПолей),"", ",")
								+ Ресурс.Имя + "Дт," + Ресурс.Имя + "Кт";

			ДобавитьКолонкуВТаблицу(Ресурс, ТаблицаРесурсов, "Дт");
			ДобавитьКолонкуВТаблицу(Ресурс, ТаблицаРесурсов, "Кт");

		Иначе
			
			ТекстПолейВыборки = ТекстПолейВыборки + "
								|Таблица." + Ресурс.Имя + " КАК " + Ресурс.Имя +", ";
			
			СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей
							+ ?(ПустаяСтрока(СтруктураПолей[ИмяКоллекции].СтрокаПолей),"", ",") + Ресурс.Имя;
			
			ДобавитьКолонкуВТаблицу(Ресурс, ТаблицаРесурсов);
			
		КонецЕсли;
		
	КонецЦикла;

	// Специфические случаи разных регистров.
	Если ВидРегистра = "Накопления"
	   И МетаданныеРегистра.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда

		ТаблицаВидДвижений = Новый ТаблицаЗначений;
		ТаблицаВидДвижений.Колонки.Добавить("ВидДвижения", , НСтр("ru = 'Вид движения'"));

		ТекстПолейВыборки = ТекстПолейВыборки + "Таблица.ВидДвижения КАК ВидДвижения, ";

	ИначеЕсли ВидРегистра = "Бухгалтерии" Тогда

		ИмяКоллекции = "Измерения";
		ИмяТаблицы   = ТаблицаИзмерений;
		
		СтрокаПолейСчетИСубконто = "";
		
		ДобавитьКолонкиСчетИСубконтоВТаблицу(МетаданныеРегистра.ПланСчетов.МаксКоличествоСубконто,
												ТаблицаИзмерений,
												СтрокаПолейСчетИСубконто);

		СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей
								+ ?(ПустаяСтрока(СтруктураПолей[ИмяКоллекции].СтрокаПолей),"", ",") + СтрокаПолейСчетИСубконто;

		ТекстПолейВыборки = ТекстПолейВыборки + "
			|Таблица.СчетДт КАК СчетДт,
			|Таблица.СчетКт КАК СчетКт, ";
		
		Для НомерСубконто = 1 По МетаданныеРегистра.ПланСчетов.МаксКоличествоСубконто Цикл

			ТекстПолейВыборки = ТекстПолейВыборки + "
				|Таблица.СубконтоДт" + НомерСубконто + " КАК СубконтоДт" + НомерСубконто + ",
				|Таблица.СубконтоКт" + НомерСубконто + " КАК СубконтоКт" + НомерСубконто + ",";

		КонецЦикла;

	ИначеЕсли ВидРегистра = "Расчета" Тогда

		ТаблицаДанныеДляРасчета = Новый ТаблицаЗначений;

		ИмяКоллекции = "ДанныеДляРасчета";
		ИмяТаблицы   = ТаблицаДанныеДляРасчета;

		ДобавитьКолонкуПериодВТаблицу(ИмяТаблицы, "ВидРасчета", НСтр("ru = 'Вид расчета'"));
		СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей + " ВидРасчета";

		ДобавитьКолонкуПериодВТаблицу(ИмяТаблицы, "ПериодРегистрации", НСтр("ru = 'Период регистрации'"));
		СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей + ", ПериодРегистрации";

		ДобавитьКолонкуПериодВТаблицу(ИмяТаблицы, "Сторно", НСтр("ru = 'Сторно'"));
		СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей + ", Сторно";

		ТекстПолейВыборки = ТекстПолейВыборки + "
			|Таблица.ВидРасчета КАК ВидРасчета,
			|Таблица.Сторно КАК Сторно,
			|Таблица.ПериодРегистрации КАК ПериодРегистрации, ";

		Если МетаданныеРегистра.БазовыйПериод Тогда

			ТекстПолейВыборки = ТекстПолейВыборки + "
				|Таблица.БазовыйПериодНачало КАК БазовыйПериодНачало,
				|Таблица.БазовыйПериодКонец КАК БазовыйПериодКонец,";

			ДобавитьКолонкуПериодВТаблицу(ИмяТаблицы, "БазовыйПериодНачало", НСтр("ru = 'Базовый период начало'"));
			СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей + ", БазовыйПериодНачало";
			ДобавитьКолонкуПериодВТаблицу(ИмяТаблицы, "БазовыйПериодКонец", НСтр("ru = 'Базовый период конец'"));
			СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей + ", БазовыйПериодКонец";

		КонецЕсли;
		
		Если МетаданныеРегистра.ПериодДействия Тогда

			ТекстПолейВыборки = ТекстПолейВыборки + "
				|Таблица.ПериодДействияНачало КАК ПериодДействияНачало,
				|Таблица.ПериодДействияКонец КАК ПериодДействияКонец,";

			ДобавитьКолонкуПериодВТаблицу(ИмяТаблицы, "ПериодДействияНачало", НСтр("ru = 'Период действия начало'"));
			СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей + ", ПериодДействияНачало";
			ДобавитьКолонкуПериодВТаблицу(ИмяТаблицы, "ПериодДействияКонец", НСтр("ru = 'Период действия конец'"));
			СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей + ", ПериодДействияКонец";

		КонецЕсли;

	КонецЕсли;

	ЕстьПериод = Истина;
	Если (ВидРегистра = "Сведений" И МетаданныеРегистра.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический)
	  ИЛИ ВидРегистра = "Расчета" Тогда

		ЕстьПериод = Ложь;

	КонецЕсли;

	Если ЕстьПериод Тогда

		ТекстПолейВыборки = ТекстПолейВыборки + "
			|Таблица.Период КАК Период, ";

		ИмяКоллекции = "Измерения";
		ИмяТаблицы   = ТаблицаИзмерений;

		ДобавитьКолонкуПериодВТаблицу(ТаблицаИзмерений);
		СтруктураПолей[ИмяКоллекции].СтрокаПолей = СтруктураПолей[ИмяКоллекции].СтрокаПолей + ", Период";

	КонецЕсли;

	ТекстПолейВыборки = ТекстПолейВыборки + "
		|Таблица.НомерСтроки КАК НомерСтроки";

	ТекстЗапроса = 
	"
	|ВЫБРАТЬ
	|" + ТекстПолейВыборки + "
	|ИЗ
	|	" + МетаданныеРегистра.ПолноеИмя() + ?(ВидРегистра = "Бухгалтерии", ".ДвиженияССубконто(, , Регистратор = &Документ, , )", "") + " КАК Таблица 
	|" + ТекстСоединения + "
	|" + ?(ВидРегистра = "Бухгалтерии", "", "ГДЕ
	|	Таблица.Регистратор = &Документ") + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Результат = Новый Структура;
	Результат.Вставить("ТекстЗапроса", 			  ТекстЗапроса);
	Результат.Вставить("СтруктураПолей", 		  СтруктураПолей);
	Результат.Вставить("ТаблицаРесурсов", 		  ТаблицаРесурсов);
	Результат.Вставить("ТаблицаИзмерений", 		  ТаблицаИзмерений);
	Результат.Вставить("ТаблицаРеквизитов", 	  ТаблицаРеквизитов);
	Результат.Вставить("ТаблицаВидДвижений", 	  ТаблицаВидДвижений);
	Результат.Вставить("ТаблицаДанныеДляРасчета", ТаблицаДанныеДляРасчета);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ДобавитьКолонкиСчетИСубконтоВТаблицу(МаксКоличествоСубконто, ТаблицаПолей, СтрокаПолейСчетИСубконто)

	ТаблицаПолей.Колонки.Добавить("СчетДт", , НСтр("ru = 'Счет Дт'"));
	СтрокаПолейСчетИСубконто = "СчетДт";
	
	Для НомерСубконто = 1 По МаксКоличествоСубконто Цикл
		ТаблицаПолей.Колонки.Добавить("СубконтоДт" + НомерСубконто, , "Субконто" + НомерСубконто + " Дт");
		СтрокаПолейСчетИСубконто = СтрокаПолейСчетИСубконто + "," + "СубконтоДт" + НомерСубконто;
	КонецЦикла;
	
	ТаблицаПолей.Колонки.Добавить("СчетКт", , НСтр("ru = 'Счет Кт'"));
	СтрокаПолейСчетИСубконто = СтрокаПолейСчетИСубконто + ",СчетКт";
	
	Для НомерСубконто = 1 По МаксКоличествоСубконто Цикл
		ТаблицаПолей.Колонки.Добавить("СубконтоКт" + НомерСубконто, , "Субконто" + НомерСубконто + " Кт");
		СтрокаПолейСчетИСубконто = СтрокаПолейСчетИСубконто + "," + "СубконтоКт" + НомерСубконто;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКолонкуВТаблицу(МетаданныеПоля, ТаблицаПолей, Постфикс = "")

	ТаблицаПолей.Колонки.Добавить(МетаданныеПоля.Имя + Постфикс, , МетаданныеПоля.Синоним + ?(Постфикс = "", "", " ") + Постфикс);

КонецПроцедуры

&НаСервере
Процедура ДобавитьКолонкуПериодВТаблицу(ТаблицаПолей, Колонка = "Период", ПредставлениеКолонки = "Период")

	ТаблицаПолей.Колонки.Добавить(Колонка, , ПредставлениеКолонки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолеОтключеноФункциональнойОпцией(МетаданныеПоля)

	Результат = Ложь;
	//Если Метаданные.ФункциональныеОпции.ИспользоватьХарактеристикиНоменклатуры.Состав.Содержит(МетаданныеПоля) Тогда

	//	Результат = Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");

	//ИначеЕсли Метаданные.ФункциональныеОпции.ИспользоватьСерииНоменклатуры.Состав.Содержит(МетаданныеПоля) Тогда

	//	Результат = Не ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры");

	//ИначеЕсли Метаданные.ФункциональныеОпции.УчитыватьСебестоимостьТоваровПоВидамЗапасов.Состав.Содержит(МетаданныеПоля) Тогда

	//	Результат = Не ПолучитьФункциональнуюОпцию("УчитыватьСебестоимостьТоваровПоВидамЗапасов");

	//КонецЕсли;
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ВыводДанных

&НаСервере
Процедура ВывестиДанныеПоРегистру(МетаданныеРегистра, Макет)

	ВидРегистра = "";
	Если Не ОпределитьВидРегистра(МетаданныеРегистра, ВидРегистра) Тогда
		Возврат;
	КонецЕсли;

	Результат = ПолучитьДанныеПоДвижениям(МетаданныеРегистра, ВидРегистра);

	ТаблицаРесурсов         = Результат.ТаблицаРесурсов;
	ТаблицаИзмерений        = Результат.ТаблицаИзмерений;
	ТаблицаРеквизитов       = Результат.ТаблицаРеквизитов;
	ТаблицаВидДвижений      = Результат.ТаблицаВидДвижений;
	ТаблицаДанныеДляРасчета = Результат.ТаблицаДанныеДляРасчета;

	ЕстьТаблицаДвижений         = ТаблицаВидДвижений <> Неопределено;
	ЕстьТаблицаДанныеДляРасчета = ТаблицаДанныеДляРасчета <> Неопределено;

	Запрос = Новый Запрос(Результат.ТекстЗапроса);
	Запрос.УстановитьПараметр("Документ", Отчет.Документ);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		СтрокаИзмерений  = ТаблицаИзмерений.Добавить();
		СтрокаРеквизитов = ТаблицаРеквизитов.Добавить();

		Для Каждого ЭлементАналитики Из Результат.СтруктураПолей.Измерения.МассивРеквизитовАналитики Цикл

			СтрокаИзмерений[ЭлементАналитики.Поле] = ПолучитьЗначенияВСтроку(Выборка, ЭлементАналитики.МассивПолей);

		КонецЦикла;

		Для Каждого ЭлементАналитики Из Результат.СтруктураПолей.Реквизиты.МассивРеквизитовАналитики Цикл

			СтрокаРеквизитов[ЭлементАналитики.Поле] = ПолучитьЗначенияВСтроку(Выборка, ЭлементАналитики.МассивПолей);

		КонецЦикла;

		ЗаполнитьЗначенияСвойств(ТаблицаРесурсов.Добавить(), Выборка, Результат.СтруктураПолей.Ресурсы.СтрокаПолей);
		ЗаполнитьЗначенияСвойств(СтрокаИзмерений,  Выборка, Результат.СтруктураПолей.Измерения.СтрокаПолей);
		ЗаполнитьЗначенияСвойств(СтрокаРеквизитов, Выборка, Результат.СтруктураПолей.Реквизиты.СтрокаПолей);

		Если ЕстьТаблицаДвижений Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаВидДвижений.Добавить(), Выборка, "ВидДвижения");
		КонецЕсли;

		Если ЕстьТаблицаДанныеДляРасчета Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаДанныеДляРасчета.Добавить(), Выборка, Результат.СтруктураПолей.ДанныеДляРасчета.СтрокаПолей);
		КонецЕсли;
	
	КонецЦикла;

	ЦветЗеленый = WebЦвета.Зеленый;
	ЦветКрасный = WebЦвета.Кирпичный;

	ОбластьРазделитель = Макет.ПолучитьОбласть("Разделитель");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокОтчета");
	УстановитьПараметрОбласти(
		ОбластьЗаголовок,
		"СинонимРегистра",
		НСтр("ru = 'Регистр'") + " " + НРег(ВидРегистра) + " """ + МетаданныеРегистра.Синоним + """");
	
	ТабличныйДокумент.Вывести(ОбластьРазделитель);
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	ТабличныйДокумент.НачатьГруппуСтрок();
	ТабличныйДокумент.Вывести(ОбластьРазделитель);

	КоличествоСтрокРезультата = Выборка.Количество();

	Если СпособВыводаОтчета = Перечисления.СпособыВыводаОтчета.ПоГоризонтали Тогда

		ОбластьЗаголовок = Макет.ПолучитьОбласть("ЗаголовокЯчейки");
		ОбластьЯчейка    = Макет.ПолучитьОбласть("Ячейка");
		ОбластьОтступ    = Макет.ПолучитьОбласть("Отступ1");

		ТабличныйДокумент.Вывести(ОбластьОтступ);

		Если ЕстьТаблицаДвижений Тогда

			УстановитьПараметрОбласти(ОбластьЗаголовок, "ЗаголовокКолонки", НСтр("ru = 'Вид движения'"));
			ТабличныйДокумент.Присоединить(ОбластьЗаголовок);

		КонецЕсли;

		Если ЕстьТаблицаДанныеДляРасчета Тогда

			ПрисоединитьОбласть(ТабличныйДокумент, ОбластьЗаголовок, ТаблицаДанныеДляРасчета);

		КонецЕсли;

		ПрисоединитьОбласть(ТабличныйДокумент, ОбластьЗаголовок, ТаблицаИзмерений);
		ПрисоединитьОбласть(ТабличныйДокумент, ОбластьЗаголовок, ТаблицаРесурсов);
		ПрисоединитьОбласть(ТабличныйДокумент, ОбластьЗаголовок, ТаблицаРеквизитов);

		Для НомерСтроки = 1 По КоличествоСтрокРезультата Цикл

			ТабличныйДокумент.Вывести(ОбластьОтступ);
			Если ЕстьТаблицаДвижений Тогда

				УстановитьПараметрОбласти(ОбластьЯчейка, "Значение", ТаблицаВидДвижений[НомерСтроки-1].ВидДвижения);
				ТабличныйДокумент.Присоединить(ОбластьЯчейка);

				Область = ТабличныйДокумент.Область("Ячейка");
				Область.ШиринаКолонки = 13;

				Если ТаблицаВидДвижений[НомерСтроки-1].ВидДвижения = ВидДвиженияНакопления.Расход Тогда
					Область.ЦветТекста = ЦветКрасный;
				Иначе
					Область.ЦветТекста = ЦветЗеленый;
				КонецЕсли;

			КонецЕсли;

			Если ЕстьТаблицаДанныеДляРасчета Тогда
				ПрисоединитьОбластьПоСтроке(ТабличныйДокумент, ОбластьЯчейка, ТаблицаДанныеДляРасчета[НомерСтроки-1]);
			КонецЕсли;

			ПрисоединитьОбластьПоСтроке(ТабличныйДокумент, ОбластьЯчейка, ТаблицаИзмерений[НомерСтроки-1]);
			ПрисоединитьОбластьПоСтроке(ТабличныйДокумент, ОбластьЯчейка, ТаблицаРесурсов[НомерСтроки-1]);
			ПрисоединитьОбластьПоСтроке(ТабличныйДокумент, ОбластьЯчейка, ТаблицаРеквизитов[НомерСтроки-1]);

		КонецЦикла;
	Иначе
		// Вывод таблицы
		
		Если ЕстьТаблицаДвижений Тогда

			ОбластьШапки                  = Макет.ПолучитьОбласть("ШапкаТаблицы");
			ОбластьДеталиШапки            = Макет.ПолучитьОбласть("ДеталиШапки");
			ОбластьДетали                 = Макет.ПолучитьОбласть("Детали");
			ОбластьШапкиВидДвижения       = Макет.ПолучитьОбласть("ШапкаТаблицыВидДвижения");
			ОбластьДеталиШапкиВидДвижения = Макет.ПолучитьОбласть("ДеталиШапкиВидДвижения");
			ОбластьДеталиВидДвижения      = Макет.ПолучитьОбласть("ДеталиВидДвижения");
			ОбластьОтступ                 = Макет.ПолучитьОбласть("Отступ");

		ИначеЕсли ЕстьТаблицаДанныеДляРасчета Тогда

			ОбластьШапки       = Макет.ПолучитьОбласть("ШапкаТаблицы2");
			ОбластьДеталиШапки = Макет.ПолучитьОбласть("ДеталиШапки2");
			ОбластьДетали      = Макет.ПолучитьОбласть("Детали2");
			ОбластьОтступ      = Макет.ПолучитьОбласть("Отступ2");

		Иначе

			ОбластьШапки       = Макет.ПолучитьОбласть("ШапкаТаблицы1");
			ОбластьДеталиШапки = Макет.ПолучитьОбласть("ДеталиШапки1");
			ОбластьДетали      = Макет.ПолучитьОбласть("Детали1");
			ОбластьОтступ      = Макет.ПолучитьОбласть("Отступ2");

		КонецЕсли;

		ТабличныйДокумент.Вывести(ОбластьОтступ);

		Если ЕстьТаблицаДвижений Тогда
			ТабличныйДокумент.Присоединить(ОбластьШапкиВидДвижения);
		КонецЕсли;

		ТабличныйДокумент.Присоединить(ОбластьШапки);

		КоличествоКолонокШапки = Макс(ТаблицаРесурсов.Колонки.Количество(),
									ТаблицаИзмерений.Колонки.Количество(),
									ТаблицаРеквизитов.Колонки.Количество(),
									?(ЕстьТаблицаДанныеДляРасчета, ТаблицаДанныеДляРасчета.Количество(), 0));

		ТонкаяЛиния = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,1);
		Для НомерСтроки = 1 По КоличествоКолонокШапки Цикл

			СдвигКолонки = 0;

			// Данные расчета
			Если ЕстьТаблицаДанныеДляРасчета Тогда

				СдвигКолонки = 1;
				УстановитьПараметрОбласти(ОбластьДеталиШапки, "ДанныеРасчета");
				Если ТаблицаДанныеДляРасчета.Колонки.Количество() >= НомерСтроки Тогда

					УстановитьПараметрОбласти(ОбластьДеталиШапки, "ДанныеРасчета", ТаблицаДанныеДляРасчета.Колонки[НомерСтроки-1].Заголовок);
					ОбластьДеталиШапки.Область(1, СдвигКолонки, 1, СдвигКолонки + 1).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);

				Иначе

					ОбластьДеталиШапки.Область(1, СдвигКолонки, 1, СдвигКолонки + 1).Обвести(ТонкаяЛиния,,ТонкаяЛиния,);
				КонецЕсли;
			КонецЕсли;

			//Измерения
			УстановитьПараметрОбласти(ОбластьДеталиШапки, "Измерения");
			Если ТаблицаИзмерений.Колонки.Количество() >= НомерСтроки Тогда

				УстановитьПараметрОбласти(ОбластьДеталиШапки, "Измерения", ТаблицаИзмерений.Колонки[НомерСтроки-1].Заголовок);
				ОбластьДеталиШапки.Область(1, СдвигКолонки + 1, 1, СдвигКолонки + 1).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);

			Иначе

				ОбластьДеталиШапки.Область(1, СдвигКолонки + 1, 1, СдвигКолонки + 1).Обвести(ТонкаяЛиния,,ТонкаяЛиния,);
			КонецЕсли;

			//Ресурсы
			УстановитьПараметрОбласти(ОбластьДеталиШапки, "Ресурсы");
			Если ТаблицаРесурсов.Колонки.Количество() >= НомерСтроки Тогда

				УстановитьПараметрОбласти(ОбластьДеталиШапки, "Ресурсы", ТаблицаРесурсов.Колонки[НомерСтроки-1].Заголовок);
				ОбластьДеталиШапки.Область(1, СдвигКолонки + 2, 1, СдвигКолонки + 2).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);

			Иначе

				ОбластьДеталиШапки.Область(1, СдвигКолонки + 2, 1, СдвигКолонки + 2).Обвести(ТонкаяЛиния,,ТонкаяЛиния,);
			КонецЕсли;

			//Реквизиты
			УстановитьПараметрОбласти(ОбластьДеталиШапки, "Реквизиты");
			Если ТаблицаРеквизитов.Колонки.Количество() >= НомерСтроки Тогда

				УстановитьПараметрОбласти(ОбластьДеталиШапки, "Реквизиты", ТаблицаРеквизитов.Колонки[НомерСтроки-1].Заголовок);
				ОбластьДеталиШапки.Область(1, СдвигКолонки + 3, 1, СдвигКолонки + 3).Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);

			Иначе
				ОбластьДеталиШапки.Область(1, СдвигКолонки + 3, 1, СдвигКолонки + 3).Обвести(ТонкаяЛиния,,ТонкаяЛиния,);
			КонецЕсли;

			ТабличныйДокумент.Вывести(ОбластьОтступ);
			Если ЕстьТаблицаДвижений Тогда
				ТабличныйДокумент.Присоединить(ОбластьДеталиШапкиВидДвижения);
			КонецЕсли;

			ПрисоединеннаяОбласть = ТабличныйДокумент.Присоединить(ОбластьДеталиШапки);

			Если НомерСтроки = КоличествоКолонокШапки Тогда

				ПрисоединеннаяОбласть.Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния);
				Если ЕстьТаблицаДвижений Тогда

					ТабличныйДокумент.Область("ДеталиШапкиВидДвижения").Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния);

				КонецЕсли;
			КонецЕсли;

		КонецЦикла;

		Для НомерСтроки = 1 По КоличествоСтрокРезультата Цикл

			ВыведенВидДвижения = Ложь;

			Для НомерКолонки = 1 По КоличествоКолонокШапки Цикл

				СдвигКолонки = 0;
				// Данные расчета
				Если ЕстьТаблицаДанныеДляРасчета Тогда

					СдвигКолонки = 1;
					УстановитьПараметрОбласти(ОбластьДетали, "ДанныеРасчета");
					ОбластьОбвести = ОбластьДетали.Область(1, СдвигКолонки, 1, СдвигКолонки);
					Если ТаблицаДанныеДляРасчета.Колонки.Количество() >= НомерКолонки Тогда

						ИмяКолонки = ТаблицаДанныеДляРасчета.Колонки[НомерКолонки-1].Имя;
						УстановитьПараметрОбласти(ОбластьДетали, "ДанныеРасчета", ТаблицаДанныеДляРасчета[НомерСтроки-1][ИмяКолонки]);
						ОбластьОбвести.Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);

					Иначе

						ОбластьОбвести.Обвести(ТонкаяЛиния,, ТонкаяЛиния,); 

					КонецЕсли;
				КонецЕсли;

				// Измерения
				УстановитьПараметрОбласти(ОбластьДетали, "Измерения");
				ОбластьОбвести = ОбластьДетали.Область(1, СдвигКолонки + 1, 1, СдвигКолонки + 1);
				Если ТаблицаИзмерений.Колонки.Количество() >= НомерКолонки Тогда

					ИмяКолонки = ТаблицаИзмерений.Колонки[НомерКолонки-1].Имя;
					УстановитьПараметрОбласти(ОбластьДетали, "Измерения", ТаблицаИзмерений[НомерСтроки-1][ИмяКолонки]);
					ОбластьОбвести.Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);

				Иначе

					ОбластьОбвести.Обвести(ТонкаяЛиния, , ТонкаяЛиния,);

				КонецЕсли;

				// Ресурсы.
				УстановитьПараметрОбласти(ОбластьДетали, "Ресурсы");
				ОбластьОбвести = ОбластьДетали.Область(1, СдвигКолонки + 2, 1, СдвигКолонки + 2);
				Если ТаблицаРесурсов.Колонки.Количество() >= НомерКолонки Тогда

					ИмяКолонки = ТаблицаРесурсов.Колонки[НомерКолонки-1].Имя;
					УстановитьПараметрОбласти(ОбластьДетали, "Ресурсы", ТаблицаРесурсов[НомерСтроки-1][ИмяКолонки]);
					ОбластьОбвести.Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);

				Иначе

					ОбластьОбвести.Обвести(ТонкаяЛиния,, ТонкаяЛиния,);

				КонецЕсли;

				// Реквизиты.
				УстановитьПараметрОбласти(ОбластьДетали, "Реквизиты");
				ОбластьОбвести = ОбластьДетали.Область(1, СдвигКолонки + 3, 1, СдвигКолонки + 3);
				Если ТаблицаРеквизитов.Колонки.Количество() >= НомерКолонки Тогда

					ИмяКолонки = ТаблицаРеквизитов.Колонки[НомерКолонки-1].Имя;
					УстановитьПараметрОбласти(ОбластьДетали, "Реквизиты", ТаблицаРеквизитов[НомерСтроки-1][ИмяКолонки]);
					ОбластьОбвести.Обвести(ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния, ТонкаяЛиния);

				Иначе

					ОбластьОбвести.Обвести(ТонкаяЛиния, , ТонкаяЛиния,);

				КонецЕсли;

				ТабличныйДокумент.Вывести(ОбластьОтступ);
				
				Если ЕстьТаблицаДвижений Тогда

					ВидДвижения = ?(ВыведенВидДвижения, "", ТаблицаВидДвижений[НомерСтроки-1]["ВидДвижения"]);

					УстановитьПараметрОбласти(ОбластьДеталиВидДвижения, "ВидДвижения", ВидДвижения);
					ТабличныйДокумент.Присоединить(ОбластьДеталиВидДвижения);

					Если Не ВыведенВидДвижения Тогда
						Если ВидДвижения = ВидДвиженияНакопления.Расход Тогда
							ТабличныйДокумент.Область("ДеталиВидДвижения").ЦветТекста = ЦветКрасный;
						Иначе
							ТабличныйДокумент.Область("ДеталиВидДвижения").ЦветТекста = ЦветЗеленый;
						КонецЕсли;
					КонецЕсли;

					ВыведенВидДвижения = Истина;

				КонецЕсли;

				ПрисоединеннаяОбласть = ТабличныйДокумент.Присоединить(ОбластьДетали);

				Если НомерКолонки = КоличествоКолонокШапки Тогда

					ПрисоединеннаяОбласть.Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния);
					Если ЕстьТаблицаДвижений Тогда

						ТабличныйДокумент.Область("ДеталиВидДвижения").Обвести(ТонкаяЛиния,, ТонкаяЛиния, ТонкаяЛиния);

					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;

	ТабличныйДокумент.ЗакончитьГруппуСтрок();

КонецПроцедуры

&НаСервере
Функция ОпределитьВидРегистра(МетаданныеРегистра, ВидРегистра)

	РегистрОбрабатывается = Истина;
	Если Метаданные.РегистрыНакопления.Индекс(МетаданныеРегистра) >= 0 Тогда
		ВидРегистра = "Накопления";
	ИначеЕсли Метаданные.РегистрыСведений.Индекс(МетаданныеРегистра) >= 0 Тогда
		ВидРегистра = "Сведений";
	ИначеЕсли Метаданные.РегистрыБухгалтерии.Индекс(МетаданныеРегистра) >= 0 Тогда
		ВидРегистра = "Бухгалтерии";
	ИначеЕсли Метаданные.РегистрыРасчета.Индекс(МетаданныеРегистра) >= 0 Тогда
		ВидРегистра = "Расчета";
	Иначе
		РегистрОбрабатывается = Ложь;
	КонецЕсли;

	Возврат РегистрОбрабатывается;

КонецФункции

&НаСервере
Процедура ПрисоединитьОбласть(ТабличныйДокумент, ОбластьМакета, Таблица)

	Для Каждого Колонка Из Таблица.Колонки Цикл

		УстановитьПараметрОбласти(ОбластьМакета, "ЗаголовокКолонки", Колонка.Заголовок);
		ТабличныйДокумент.Присоединить(ОбластьМакета);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПрисоединитьОбластьПоСтроке(ТабличныйДокумент, Область, СтрокаТаблицы)

	Для Каждого Колонка Из СтрокаТаблицы.Владелец().Колонки Цикл

		УстановитьПараметрОбласти(Область, "Значение", СтрокаТаблицы[Колонка.Имя]);
		ТабличныйДокумент.Присоединить(Область);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ПолучитьЗначенияВСтроку(ВыборкаДанных, МассивПолей)

	Результат = "";
	Для Каждого ИмяПоля Из МассивПолей Цикл
		Если ЗначениеЗаполнено(ВыборкаДанных[ИмяПоля]) Тогда

			Результат = Результат + ?(ПустаяСтрока(Результат), "", "; ") + СокрЛП(ВыборкаДанных[ИмяПоля]);

		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

&НаСервере
Процедура УстановитьПараметрОбласти(Область, ИмяПараметра, ЗначениеПараметра = Неопределено)
	
	ЗначенияЗаполнения = Новый Структура(ИмяПараметра + ", " + ИмяПараметра + "Расшифровка");
	
	Если ТипЗнч(ЗначениеПараметра) = Тип("ХранилищеЗначения") Тогда
		ЗначенияЗаполнения[ИмяПараметра] = НСтр("ru = '<Хранилище значения>'");
		
	ИначеЕсли ЗначениеНеТребуетРасшифровки(ЗначениеПараметра) Тогда
		ЗначенияЗаполнения[ИмяПараметра] = ЗначениеПараметра;
		
	Иначе
		ЗначенияЗаполнения[ИмяПараметра] = СокрЛП(ЗначениеПараметра);
		ЗначенияЗаполнения[ИмяПараметра + "Расшифровка"] = ЗначениеПараметра;
		
	КонецЕсли;
	
	Область.Параметры.Заполнить(ЗначенияЗаполнения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначениеНеТребуетРасшифровки(Значение)
	
	ТипЗначения = ТипЗнч(Значение);
	
	Возврат НЕ ЗначениеЗаполнено(Значение)
	 		ИЛИ ТипЗначения = Тип("Строка")
	 		ИЛИ ТипЗначения = Тип("Число")
	 		ИЛИ ТипЗначения = Тип("Дата")
	 		ИЛИ ТипЗначения = Тип("Булево")
	 		ИЛИ ТипЗначения = Тип("УникальныйИдентификатор")
	 		ИЛИ ТипЗначения = Тип("ВидДвиженияНакопления")
	 		ИЛИ ТипЗначения = Тип("ВидДвиженияБухгалтерии")
			ИЛИ Перечисления.ТипВсеСсылки().СодержитТип(ТипЗначения);
	
КонецФункции

#КонецОбласти

#КонецОбласти
