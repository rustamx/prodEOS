﻿#Область ПрограммныйИнтерфейс

// Открывает форму выбора пользователя (адресную книгу).
//
// Параметры:
//   ЭлементФормы - ЭлементФормы - элемент, оповещаемый о выборе.
//   ВыбранноеЗначение - СправочникСсылка.Пользователи - ранее выбранное значение.
//   ЗаголовокФормы - Строка - необязательный, заголовок формы (по умолчанию - "Выбор пользователя").
//
Процедура ВыбратьПользователя(ЭлементФормы, ВыбранноеЗначение, ЗаголовокФормы = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранноеЗначение);
	КонецЕсли;
	
	Если ЗаголовокФормы = Неопределено Тогда
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор пользователя'; en = 'Select user'"));
	Иначе
		ПараметрыФормы.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	КонецЕсли;
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, ЭлементФормы, Неопределено);
	
КонецПроцедуры

// Открывает форму выбора контейнера пользователей (адресную книгу).
//
// Параметры:
//   ЭлементФормы - ЭлементФормы - элемент, оповещаемый о выборе.
//   ВыбранноеЗначение - ОпределяемыйТип.КонтейнерыПользователей - ранее выбранное значение.
//   ЗаголовокФормы - Строка - необязательный, заголовок формы (по умолчанию - "Выбор пользователя, группы, подразделения").
//
Процедура ВыбратьКонтейнерПользователей(ЭлементФормы, ВыбранноеЗначение, ЗаголовокФормы = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранноеЗначение);
	КонецЕсли;
	
	Если ЗаголовокФормы = Неопределено Тогда
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор пользователя'; en = 'Select user'"));
	Иначе
		ПараметрыФормы.Вставить("ЗаголовокФормы", ЗаголовокФормы);
	КонецЕсли;
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, ЭлементФормы, Неопределено);
	
КонецПроцедуры

#КонецОбласти
