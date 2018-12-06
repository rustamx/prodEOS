﻿// Возвращает массив исполнителей указанной задачи
Функция ПолучитьИсполнителей(ЗадачаСсылка) Экспорт
	
	Набор = РегистрыСведений.СведенияОбИсполнителяхЗадач.СоздатьНаборЗаписей();
	Набор.Отбор.Задача.Установить(ЗадачаСсылка);
	Набор.Прочитать();
	
	Результат = Новый Массив;
	
	Для каждого Запись Из Набор Цикл
		
		Результат.Добавить( 
			Новый Структура("Участник",
				Запись.Участник));
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции


