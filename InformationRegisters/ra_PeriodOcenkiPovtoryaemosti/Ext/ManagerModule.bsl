#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьГлубинуОценкиПовторяемости(Организация, КлассБезопасности, ВидНесоответствия) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ra_PeriodOcenkiPovtoryaemosti.GlubinaOcenki КАК GlubinaOcenki
	|ИЗ
	|	РегистрСведений.ra_PeriodOcenkiPovtoryaemosti КАК ra_PeriodOcenkiPovtoryaemosti
	|ГДЕ
	|	ra_PeriodOcenkiPovtoryaemosti.Organizaciya В(&Organizaciya, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка))
	|	И ra_PeriodOcenkiPovtoryaemosti.Klass В(&Klass, ЗНАЧЕНИЕ(Перечисление.ra_KlassyBezopasnosti.ПустаяСсылка))
	|	И ra_PeriodOcenkiPovtoryaemosti.VidNS В(&VidNS, ЗНАЧЕНИЕ(Справочник.ra_VidyNesootvetstvij.ПустаяСсылка))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ra_PeriodOcenkiPovtoryaemosti.Klass УБЫВ,
	|	ra_PeriodOcenkiPovtoryaemosti.Organizaciya УБЫВ,
	|	ra_PeriodOcenkiPovtoryaemosti.VidNS УБЫВ");
	
	Запрос.УстановитьПараметр("Organizaciya", Организация);
	Запрос.УстановитьПараметр("Klass",        КлассБезопасности);
	Запрос.УстановитьПараметр("VidNS",        ВидНесоответствия);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.GlubinaOcenki	
	КонецЕсли;
	
	Возврат 0;

КонецФункции

#КонецОбласти

#КонецЕсли
