﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Параметры = Новый Структура;
	Параметры.Вставить("Заголовок", НСтр("ru = 'Отзыв о программе'; en = 'Leave review'"));
	Параметры.Вставить("АдресСтраницы", "http://www.1c.ru/usability/inquirer/do8corp.jsp");
	Параметры.Вставить("ОтображатьКоманднуюПанель", Ложь);
	ОткрытьФорму("Обработка.Обозреватель.Форма.Форма", Параметры);
	
КонецПроцедуры


