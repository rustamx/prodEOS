
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивПолей = ра_ОбщегоНазначения.ПолучитьПоляВводаПоСтроке(ПустаяСсылка().Метаданные());
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("EhtapVyyavleniyaNesootvetstvija") Тогда
		
		Запрос = ра_ОбщегоНазначения.ЗапросДанныхВыбораПоТексту(
			"ВЫБРАТЬ
			|	ra_KontrolnyeMeropriyatiya.Ссылка КАК Ссылка,
			|	ra_KontrolnyeMeropriyatiya.Код КАК Код,
			|	ra_KontrolnyeMeropriyatiya.Наименование КАК Наименование,
			|	ra_KontrolnyeMeropriyatiya.ПометкаУдаления КАК ПометкаУдаления
			|ИЗ
			|	Справочник.ra_KontrolnyeMeropriyatiya.Primenenie КАК ra_KontrolnyeMeropriyatiyaPrimenenie
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ra_KontrolnyeMeropriyatiya КАК ra_KontrolnyeMeropriyatiya
			|		ПО ra_KontrolnyeMeropriyatiyaPrimenenie.Ссылка = ra_KontrolnyeMeropriyatiya.Ссылка
			|			И ra_KontrolnyeMeropriyatiyaPrimenenie.EhtapVyyavleniyaNesootvetstvija = &EhtapVyyavleniyaNesootvetstvija",
			Параметры,
			МассивПолей);
												
		ра_ОбщегоНазначения.ЗаполнитьДанныеВыбораПоЗапросу(ДанныеВыбора, Параметры, Запрос, МассивПолей, СтрСоединить(МассивПолей, ","));
				
	Иначе
		
		ра_ОбщегоНазначения.ПолучитьСтандартныеДанныеВыбора(Справочники.ra_KontrolnyeMeropriyatiya, ДанныеВыбора, Параметры, СтандартнаяОбработка, МассивПолей, СтрСоединить(МассивПолей, ","));
		
	КонецЕсли;	
	
КонецПроцедуры

