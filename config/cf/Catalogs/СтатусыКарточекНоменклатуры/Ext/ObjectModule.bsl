﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Картинка.Получить() = Неопределено Тогда 
		Картинка = Новый ХранилищеЗначения(БиблиотекаКартинок.вмхКартинкаНеВыбранногоВидаСклада);
	КонецЕсли;	
	
	Если ЭтоНовый() Тогда
		НоваяСсылка = Справочники.СтатусыКарточекНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор);
		УстановитьСсылкуНового(НоваяСсылка);
	Иначе
		НоваяСсылка = Ссылка;
	КонецЕсли;
	
	НавСсылка = ПолучитьНавигационнуюСсылку(НоваяСсылка, "Картинка");

КонецПроцедуры

#КонецОбласти

#КонецЕсли