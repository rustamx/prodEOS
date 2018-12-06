﻿
// Вернет Истина, у этого объекта метаданных есть функция ПолучитьАдресФото
Функция ЕстьФункцияПолученияФото() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Прочитать фото и вернуть адрес (навигационную ссылку)
// Параметры:
//  Ссылка - ссылка на справочник, для которого надо показать фото
//  УникальныйИдентификатор - уникальный идентификатор формы, откуда идет вызов
//  ЕстьКартинка - возвращаемое значение - Булево - Истина, если в объекте есть картинка
//
// Возвращаемое значение:
//   Строка - навигационная ссылка - или "", если нет картинки
Функция ПолучитьАдресФото(Ссылка, УникальныйИдентификатор, ЕстьКартинка) Экспорт
	
	Возврат РаботаСФотографиями.ПолучитьНавигационнуюСсылкуРеквизита(Ссылка, УникальныйИдентификатор, ЕстьКартинка);
	
КонецФункции

// Возвращает двоичные данные фото личного адресата
//
Функция ПолучитьДвоичныеДанныеФото(ЛичныйАдресат) Экспорт
	
	ДвоичныеДанные = РаботаСФотографиями.ПолучитьДвоичныеДанныеРеквизита(ЛичныйАдресат, "ФайлФотографии");
	Если Не ЗначениеЗаполнено(ДвоичныеДанные) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДвоичныеДанные;
	
КонецФункции


