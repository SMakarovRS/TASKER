﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ФормаТолькоПросмотр") Тогда
		ЭтаФорма.ТолькоПросмотр 				     = Истина;
		ЗаполнитьЗначенияСвойств(Запись, Параметры.СтруктураЗаписи);		
	ИначеЕсли Параметры.Свойство("КарточкаНоменклатуры") Тогда
		Запись.КарточкаНоменклатуры 			     = Параметры.КарточкаНоменклатуры;
		Элементы.КарточкаНоменклатуры.ТолькоПросмотр = Истина;
		Элементы.Пользователь.Видимость 			 = Ложь;
		Элементы.Период.Видимость					 = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(Запись.Пользователь) Тогда
		Запись.Пользователь = ПользователиКлиент.ТекущийПользователь();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Запись.Статус) Тогда		
		ТекстОшибки = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", "Статус");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "Запись.Статус", , Отказ);		
		Возврат;
	КонецЕсли;	
	
	Запись.Период = ТекущаяДатаНаСервере();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатусНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Запись.КарточкаНоменклатуры) Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.СтатусыКарточекНоменклатуры.ФормаВыбора", Новый Структура("КарточкаНоменклатуры", Запись.КарточкаНоменклатуры), ЭтотОбъект, , , ,
			Новый ОписаниеОповещения("ПослеВыбораСтатуса", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыбораСтатуса(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Запись.Статус = Результат;
	
КонецПроцедуры	

&НаСервере
Функция ТекущаяДатаНаСервере()
	Возврат ТекущаяДатаСеанса();
КонецФункции	

#КонецОбласти