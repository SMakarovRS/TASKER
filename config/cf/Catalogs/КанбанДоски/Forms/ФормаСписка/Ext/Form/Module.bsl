﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПредопределенные(Команда)
	
	ЗаполнитьПредопределенныеНаСервере();
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПредопределенныеНаСервере()
	
	Справочники.КанбанДоски.ЗаполнитьКанбанДоскиПриПервоначальномЗаполнении();
	
КонецПроцедуры

#КонецОбласти