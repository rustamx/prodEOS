
&НаКлиенте
Процедура PolnoeNaimenovanieПриИзменении(Элемент)
	
	Объект.PolnoeNaimenovanie = СтрЗаменить(Объект.PolnoeNaimenovanie, Символы.ПС, " ");
	Объект.PolnoeNaimenovanie = СтрЗаменить(Объект.PolnoeNaimenovanie, "  ",       " ");
	
	Если СтрДлина(Объект.PolnoeNaimenovanie) > 150 Тогда
		Объект.Наименование = Лев(Объект.PolnoeNaimenovanie, 147) + "...";
	Иначе
		Объект.Наименование = Объект.PolnoeNaimenovanie;
	КонецЕсли;
	
КонецПроцедуры
