﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		Если Картинка.Получить() = Неопределено Тогда 
			Картинка = Новый ХранилищеЗначения(БиблиотекаКартинок.КартинкаНеВыбранногоВидаНоменклатуры);
		КонецЕсли;	
		
		Если Ссылка.Пустая() Тогда
			НовыйУИД = Новый УникальныйИдентификатор;
			НоваяСсылка = Справочники.ЭтапыПроцессов.ПолучитьСсылку(НовыйУИД);
			УстановитьСсылкуНового(НоваяСсылка);		
			НавСсылка = ПолучитьНавигационнуюСсылку(НоваяСсылка, "Картинка");
		Иначе
			НавСсылка = ПолучитьНавигационнуюСсылку(ЭтотОбъект, "Картинка");
		КонецЕсли;
		
		ВидЭтапа = 0;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли