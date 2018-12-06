﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОграничиватьДоступЧерезВебСерверы = Константы.ОграничиватьДоступЧерезВебСерверы.Получить();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПараметрыСинхронизацииСМобильнымКлиентом(Команда)

	ТекДанные = Элементы.Список.ТекущиеДанные;

	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПользовательУзла = ТекДанные.Пользователь;
	ПараметрыФормы   = Новый Структура("ТекущийПользователь", ПользовательУзла);

	Открытьформу("Обработка.НастройкаСинхронизацииСМобильнымКлиентом.Форма.НастройкаПравилСинхронизации", 
		ПараметрыФормы, 
		ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)

	ОписаниеОповещения = Новый ОписаниеОповещения("ВопросЗаполнитьЗавершение", ЭтаФорма);

	ЗаголовокВопроса   = НСтр("ru = 'Заполнение списка пользователей'; en = 'User list filling'", 
							ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());

	Если ОграничиватьДоступЧерезВебСерверы Тогда
		ТекстВопроса = НСтр("ru = 'Список будет перезаполнен пользователями, которым разрешен доступ через веб-серверы.'; en = 'List will be refilled by users who are have access through Web servers.'", 
						ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	Иначе
		ТекстВопроса = НСтр("ru = 'Список будет перезаполнен пользователями, которым разрешен доступ.'; en = 'List will be refilled by users who are have access'", 
						ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	КонецЕсли;

	ВариантыВыбора = Новый СписокЗначений();
	ВариантыВыбора.Добавить(КодВозвратаДиалога.ОК, "Заполнить");
	ВариантыВыбора.Добавить(КодВозвратаДиалога.Отмена);

	ВариантПоУмолчанию = КодВозвратаДиалога.Отмена;

	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, ВариантыВыбора, 60, ВариантПоУмолчанию, 
		ЗаголовокВопроса, );

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросЗаполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Отмена 
	 Или Результат = КодВозвратаДиалога.Таймаут Тогда
		Возврат;
	КонецЕсли;

	ПерезаполнитьРегистрАктуальнымиПользователями(Строка(Результат));

	Элементы.Список.Обновить();

КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьРегистрАктуальнымиПользователями(РежимЗаполнения)

	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РазрешенныеМобильныеПользователи.Пользователь,
		|	РазрешенныеМобильныеПользователи.Пользователь.Недействителен КАК НеДействителен,
		|	РазрешенныеМобильныеПользователи.Пользователь.РазрешенныеВебСерверы КАК РазрешенныеВебСерверы
		|ИЗ
		|	РегистрСведений.РазрешенныеМобильныеПользователи КАК РазрешенныеМобильныеПользователи
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Пользователь,
		|	Пользователи.РазрешенныеВебСерверы
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	НЕ Пользователи.Недействителен";

	Пакет = Запрос.ВыполнитьПакет();

	КэшПользователей = Новый Соответствие;

	// удаляем из списка неактуальных поьзователей
	СуществующийСписок = Пакет[0].Выбрать();
	Пока СуществующийСписок.Следующий() Цикл

		Если СуществующийСписок.НеДействителен 
		 Или (ОграничиватьДоступЧерезВебСерверы И Не ЗначениеЗаполнено(СуществующийСписок.РазрешенныеВебСерверы))Тогда

			Запись = РегистрыСведений.РазрешенныеМобильныеПользователи.СоздатьМенеджерЗаписи();

			Запись.Пользователь = СуществующийСписок.Пользователь;

			Запись.Прочитать();
			Запись.Удалить();

		Иначе

			КэшПользователей.Вставить(СуществующийСписок.Пользователь, СуществующийСписок.Пользователь);

		КонецЕсли;

	КонецЦикла;

	// добавляем в список новых пользователей
	ВсеПользователи = Пакет[1].Выбрать();
	Пока ВсеПользователи.Следующий() Цикл

		Если НЕ КэшПользователей[ВсеПользователи.Пользователь] = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если ОграничиватьДоступЧерезВебСерверы И Не ЗначениеЗаполнено(ВсеПользователи.РазрешенныеВебСерверы) Тогда
			Продолжить;
		КонецЕсли;

		Запись = РегистрыСведений.РазрешенныеМобильныеПользователи.СоздатьМенеджерЗаписи();

		Запись.Пользователь = ВсеПользователи.Пользователь;

		Запись.Записать();

	КонецЦикла;

КонецПроцедуры

#КонецОбласти



