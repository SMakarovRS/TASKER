﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьВидимостьДоступность();
    
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
    УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАдресаты

&НаКлиенте
Процедура АдресатыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
    
    ТекущиеДанные = Элементы.Адресаты.ТекущиеДанные;
    Если ТекущиеДанные = Неопределено Тогда
    	Возврат;
    КонецЕсли; 
    
    Если Копирование ИЛИ НоваяСтрока Тогда 
    	ТекущиеДанные.Состояние = ПредопределенноеЗначение("Перечисление.TelegramСостояниеИсходящегоСообщения.Черновик");
        ТекущиеДанные.ТекстОшибки = "";        
    КонецЕсли; 
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отправить(Команда)
	
	ОтправитьНаСервере();
	Записать();
	ОбновитьВидимостьДоступность();
    Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтправитьНаСервере()
	
	Для Каждого Строки Из Объект.Адресаты Цикл
		Если Строки.Состояние = Перечисления.TelegramСостояниеИсходящегоСообщения.Черновик Тогда
			Строки.Состояние = Перечисления.TelegramСостояниеИсходящегоСообщения.Исходящее;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьДоступность()
	
    Если Объект.ДатаОтправки <> Дата(1, 1, 1) Тогда
    	ЭтотОбъект.ТолькоПросмотр = Истина;
		Элементы.ФормаОтправить.Видимость = Ложь;
	Иначе		
		Для Каждого Строки Из Объект.Адресаты Цикл
			Если Строки.Состояние <> Перечисления.TelegramСостояниеИсходящегоСообщения.Черновик Тогда
				ЭтотОбъект.ТолькоПросмотр = Истина;
				Элементы.ФормаОтправить.Видимость = Ложь;
			КонецЕсли;
		КонецЦикла;		
    КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти