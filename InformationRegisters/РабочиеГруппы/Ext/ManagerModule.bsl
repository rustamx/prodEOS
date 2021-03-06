﻿#Область ПрограммныйИнтерфейс

// Записывает набор записей в регистр сведений с отбором по объекту
//
Процедура ЗаписатьНаборПоОбъекту(Объект, ТаблицаИсточник, ОбновитьПраваДоступа) Экспорт
	
	Если Не ЗначениеЗаполнено(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	Набор = РегистрыСведений.РабочиеГруппы.СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Объект);
	
	Для каждого ИсточникСтрока Из ТаблицаИсточник Цикл
		
		Если Не ЗначениеЗаполнено(ИсточникСтрока.Участник) Тогда
			Продолжить;
		КонецЕсли;
		
		Запись = Набор.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, ИсточникСтрока);
		ЗаполнитьУстаревшиеИзмерения(Запись);
		Запись.Объект = Объект;
		
	КонецЦикла;
	
	Набор.Записать(Истина);
	
	// Обновление прав доступа
	Если ОбновитьПраваДоступа Тогда
		ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(Объект);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает таблицу участников рабочей группы по объекту.
//
Функция ПолучитьУчастниковПоОбъекту(Объект) Экспорт
	
	Набор = РегистрыСведений.РабочиеГруппы.СоздатьНаборЗаписей();
	
	ТаблицаУчастников = Набор.ВыгрузитьКолонки();
	
	ТаблицаУчастников.Колонки.Удалить("УдалитьУчастник");
	ТаблицаУчастников.Колонки.Удалить("УдалитьОсновнойОбъектАдресации");
	ТаблицаУчастников.Колонки.Удалить("УдалитьДополнительныйОбъектАдресации");
	
	ТаблицаУчастников.Колонки.Добавить("Недействителен", Новый ОписаниеТипов("Булево"));
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РабочиеГруппы.Объект КАК Объект,
		|	РабочиеГруппы.Участник КАК Участник,
		|	РабочиеГруппы.Участник.ПометкаУдаления КАК ПометкаУдаления,
		|	ВЫБОР
		|		КОГДА РабочиеГруппы.Участник ССЫЛКА Справочник.Пользователи
		|			ТОГДА РабочиеГруппы.Участник.Недействителен
		|		КОГДА РабочиеГруппы.Участник ССЫЛКА Справочник.РабочиеГруппы
		|			ТОГДА РабочиеГруппы.Участник.Недействительна
		|		ИНАЧЕ
		|			ЛОЖЬ
		|	КОНЕЦ КАК Недействителен,
		|	РабочиеГруппы.Изменение КАК Изменение
		|ИЗ
		|	РегистрСведений.РабочиеГруппы КАК РабочиеГруппы
		|ГДЕ
		|	Объект = &Объект");
		
	Запрос.УстановитьПараметр("Объект", Объект);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаУчастников.Добавить(), Выборка);
	КонецЦикла;
	
	Возврат ТаблицаУчастников;
	
КонецФункции

// Возвращает пустую таблицу участников рабочей группы.
//
Функция ПолучитьПустуюТаблицуУчастников() Экспорт
	
	Возврат РегистрыСведений.РабочиеГруппы.СоздатьНаборЗаписей().ВыгрузитьКолонки(
		"Участник, Изменение");
	
КонецФункции

// Заполняет устаревшие измерения записи регистра.
//
Процедура ЗаполнитьУстаревшиеИзмерения(Запись) Экспорт
	
	Если ТипЗнч(Запись.Участник) = Тип("СправочникСсылка.ПолныеРоли") Тогда
		
		РеквизитыРоли = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Участник,
			"Владелец, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации");
		Запись.УдалитьУчастник = РеквизитыРоли.Владелец;
		Запись.УдалитьОсновнойОбъектАдресации = РеквизитыРоли.ОсновнойОбъектАдресации;
		Запись.УдалитьДополнительныйОбъектАдресации = РеквизитыРоли.ДополнительныйОбъектАдресации;
		
	Иначе
		
		Запись.УдалитьУчастник = Запись.Участник;
		Запись.УдалитьОсновнойОбъектАдресации = Неопределено;
		Запись.УдалитьДополнительныйОбъектАдресации = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

// ТСК Близнюк С.И.; 21.12.2018; task#2231{
Процедура ОбновитьЗаписиПоДелегированию(Делегирование) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РеквизитыНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Делегирование,
			"Ссылка, ОтКого, Кому, Действует, ВариантДелегирования, ОбластиДелегирования");
			
	РеквизитыНастройки.ОбластиДелегирования = РеквизитыНастройки.ОбластиДелегирования.Выгрузить();
	
	Если РеквизитыНастройки.Действует Тогда
		
		Набор = СоздатьНаборЗаписей();
		//Набор.Отбор.Участник.Установить(РеквизитыНастройки.Кому);
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РабочиеГруппы.Объект КАК Объект,
		|	&Кому КАК Участник,
		|	&Кому КАК УдалитьУчастник,
		|	РабочиеГруппы.УдалитьОсновнойОбъектАдресации КАК УдалитьОсновнойОбъектАдресации,
		|	РабочиеГруппы.УдалитьДополнительныйОбъектАдресации КАК УдалитьДополнительныйОбъектАдресации,
		|	РабочиеГруппы.Изменение КАК Изменение,
		|	РабочиеГруппы.ра_Несоответствие КАК ра_Несоответствие,
		|	РабочиеГруппы.ра_ЗаявкаНаОценкуСоответствия КАК ра_ЗаявкаНаОценкуСоответствия,
		|	РабочиеГруппы.ра_ЗаявкаНаКонтрольнуюОперацию КАК ра_ЗаявкаНаКонтрольнуюОперацию
		|ИЗ
		|	РегистрСведений.РабочиеГруппы КАК РабочиеГруппы
		|ГДЕ
		|	РабочиеГруппы.Участник = &ОтКого";
				
		Запрос.УстановитьПараметр("ОтКого", РеквизитыНастройки.ОтКого);
		Запрос.УстановитьПараметр("Кому", РеквизитыНастройки.Кому);
		
		Если РеквизитыНастройки.ВариантДелегирования <> Перечисления.ВариантыДелегированияПрав.ВсеПрава Тогда
			
			ТекстУсловияОбщий = "
			|	И (%1 
			|	ИЛИ 
			|	%2)";
			
			ТекстУсловия1 = "Ложь";
			ТекстУсловия2 = "Ложь";
			
			Для каждого Строка Из РеквизитыНастройки.ОбластиДелегирования Цикл
				
				Если Строка.ОбластьДелегирования = Справочники.ОбластиДелегированияПрав.ПроцессыИЗадачи Тогда
					
					ТекстУсловия1 = "ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.Исполнение)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.КомплексныйПроцесс)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.ОбработкаВнутреннегоДокумента)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.ОбработкаВходящегоДокумента)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.ОбработкаИсходящегоДокумента)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.Ознакомление)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.Поручение)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.Приглашение)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.Рассмотрение)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.Регистрация)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.РешениеВопросовВыполненияЗадач)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.Согласование)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(БизнесПроцесс.Утверждение)";
					
				ИначеЕсли Строка.ОбластьДелегирования = Справочники.ОбластиДелегированияПрав.ДокументыИФайлы Тогда
										
					ТекстУсловия2 = "ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_AktObUstraneniiNesootvetstviya)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_ItogovyjOtchetONesootvetstvii)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_KorrektiruyushcheeDejstvie)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_Nesootvetstvie)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_OcenkaZnachimosti)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_OperaciyaOcenkiSootvetstviya)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_OtchetONesootvetstviiCHast1)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_OtchetONesootvetstviiCHast2)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_OtchetONesootvetstviiCHast3)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_PlanProvedeniyaOcenkiSootvetstviya)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_PreduprezhdayushcheeDejstvie)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_RezultatKontrolnoyOperacii)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_Signal)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_Uvedomlenie)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_VremennyeSderzhivayushchieDejstviyaIKorrekciya)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_ZayavkaNaKontrolnuyuOperaciyu)
					|			ИЛИ ТИПЗНАЧЕНИЯ(РабочиеГруппы.Объект) = ТИП(Документ.ra_ZayavkaNaOcenkuSootvetstviya)";
					
				КонецЕсли;
				
			КонецЦикла;
			
			ТекстУсловияОбщий = СтрШаблон(ТекстУсловияОбщий, ТекстУсловия1, ТекстУсловия2);
			
			Запрос.Текст = Запрос.Текст + ТекстУсловияОбщий;
			
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();	
		Пока Выборка.Следующий() Цикл	
			// Добавляем делегата.
			Запись = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
		КонецЦикла;
		
		Набор.Записать(Ложь);
	
	Иначе
		// Если настройка делегирования не действует, то не понятно что удалять.
	КонецЕсли;
	
КонецПроцедуры
// ТСК Близнюк С.И.; 21.12.2018; task#2231}

#КонецОбласти

#Область ИнтеграцияBitrix

Процедура СформироватьМассивДанныхGetList(Результат, ПолноеИмя, ПараметрыЗапросаHTTP) Экспорт
	
	ОбъектМетаданных = Метаданные.РегистрыСведений.РабочиеГруппы;
	
	ТаблицаРеквизитов = ра_ОбменДанными.ПолучитьТаблицуРеквизитовОбъекта(ОбъектМетаданных);
	
	АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов);
	
	ТекстЗапросаВложенныеТаблицы = ПолучитьТекстЗапросаВложенныеТаблицы();
	ТекстЗапросаСоединений = ПолучитьТекстЗапросаСоединений();
	
	Запрос = ра_ОбменДанными.ПолучитьЗапрос(ТаблицаРеквизитов, ПараметрыЗапросаHTTP, ПолноеИмя, ТекстЗапросаВложенныеТаблицы, ТекстЗапросаСоединений);
	
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзЗапроса(Запрос);
	Результат.Вставить("value", МассивДанных);
	
	НастройкаФормы = ПараметрыЗапросаHTTP.Получить("$form_settings");
	Если ЗначениеЗаполнено(НастройкаФормы) И НастройкаФормы Тогда
		МассивКолонок = ПолучитьПолучитьМассивКолонокСписка();
		МассивКнопок = ПолучитьМассивКнопок(Запрос.Параметры);
		МассивФильтров = ПолучитьМассивФильтровСписка();
		Результат.Вставить("form_settings", МассивКолонок);
		Результат.Вставить("button_settings", МассивКнопок);
		Результат.Вставить("filter_settings", МассивФильтров);
	КонецЕсли;
	
КонецПроцедуры

Процедура АктуализироватьТаблицуРеквизитов(ТаблицаРеквизитов)
	
	
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаВложенныеТаблицы() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьТекстЗапросаСоединений() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПолучитьМассивКнопок(МенеджерЗаписи) Экспорт
	
	//ВидФормы = "ФормаОбъекта";
	//Несоответствие = Документы.ra_Nesootvetstvie.ПустаяСсылка();
	//Если ТипЗнч(МенеджерЗаписи) = Тип("Структура") Тогда
	//	ВидФормы = "ФормаСписка";
	//	Если МенеджерЗаписи.Свойство("Nesootvetstvie") Тогда
	//		Несоответствие = МенеджерЗаписи.Nesootvetstvie;
	//	КонецЕсли;
	//Иначе
	//	Несоответствие = МенеджерЗаписи.Nesootvetstvie;
	//КонецЕсли;
	
	МассивКнопок = Новый Массив;
		
	Возврат МассивКнопок;
	
КонецФункции

Функция ПолучитьПолучитьМассивКолонокСписка() Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.РабочиеГруппы;
	
	ТаблицаНастроек = ра_ОбменДанными.СформироватьПустуюТаблицуНастроек();
	
	ИзмеренияРегистра = МетаданныеРегистра.Измерения;
	РесурсыРегистра = МетаданныеРегистра.Ресурсы;
	
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, ИзмеренияРегистра.Объект);
	ра_ОбменДанными.ДобавитьСтрокуВТаблицуНастроек(ТаблицаНастроек, ИзмеренияРегистра.Участник);
		
	МассивДанных = ра_ОбменДанными.СформироватьМассивДанныхИзТаблицыНастроек(ТаблицаНастроек);
	
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьМассивФильтровСписка() Экспорт
	
	МассивДанных = Новый Массив;
	
	Возврат МассивДанных;
	
КонецФункции

// ТСК Ткаченко И.Л.; 17.08.2018; task#971{
Функция ПолучитьМассивЗаголовков(МассивДанных = Неопределено) Экспорт

	МассивЗаголовков = Новый Массив;
	
	Возврат МассивЗаголовков;	
	
КонецФункции	
// ТСК Ткаченко И.Л.; 14.07.2018; task#971}

#КонецОбласти
