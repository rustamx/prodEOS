﻿
&НаКлиенте
Процедура Направить(Команда)
	
	ВладелецФормы.Объект.Organizaciya = Организация;
	ВладелецФормы.Объект.OtvetstvenniyZaKachestvo = ОтветственныйЗаКачество;
	
	ВладелецФормы.Записать();
	
	Закрыть();
	
КонецПроцедуры
