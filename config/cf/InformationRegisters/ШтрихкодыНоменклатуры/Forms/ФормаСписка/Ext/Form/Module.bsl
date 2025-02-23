﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Номенклатура") Тогда
		
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Номенклатура", Параметры.Номенклатура);		
		ВидНоменклатуры = Неопределено;
		
		Если ТипЗнч(Параметры.Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
			ВидНоменклатуры = Параметры.Номенклатура.ВидНоменклатуры;
		ИначеЕсли ТипЗнч(Параметры.Номенклатура) = Тип("СправочникСсылка.КарточкиНоменклатуры") Тогда
			ВидНоменклатуры = Параметры.Номенклатура.Владелец.ВидНоменклатуры;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ВидНоменклатуры) ИЛИ НЕ ВидНоменклатуры.МожетИметьШтрихкод Тогда
			ТекстЗаголовка = НСтр("ru = 'Для элемента: ""%ОтборНоменклатура%"" штрих коды не могут быть заданы.'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%ОтборНоменклатура%", Строка(Параметры.Номенклатура));
			АвтоЗаголовок = Ложь;
			Заголовок = ТекстЗаголовка;
			Элементы.Список.ТолькоПросмотр = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры