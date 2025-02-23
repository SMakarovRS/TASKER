﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбъектСсылка") Тогда
		ОбъектСсылка = Параметры.ОбъектСсылка;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СЭтапамиНаСервере();
	Элементы.ФормаСЭтапами.Пометка = Иерархически;
	РазвернутьДерево();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДерево

&НаКлиенте
Процедура ДеревоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьИсполнителя(Команда)
	
	ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Значение) <> Тип("СправочникСсылка.ЭтапыПроцессов") Тогда
		Закрыть(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СЭтапами(Команда)
	
	Иерархически = НЕ Иерархически;
	СЭтапамиНаСервере();
	Элементы.ФормаСЭтапами.Пометка = Иерархически;
	РазвернутьДерево();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СЭтапамиНаСервере()
	
	ДЗ = СЛС.ДеревоИсполнителейИЭтапов(ОбъектСсылка, "Исполнители", Иерархически, 
		УникальныйИдентификатор);
	ЗначениеВРеквизитФормы(ДЗ, "Дерево");
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево()
	
	КоллекцияЭлементовДерева = Дерево.ПолучитьЭлементы();
	Для Каждого Строка Из КоллекцияЭлементовДерева Цикл    
		ИдентификаторСтроки = Строка.ПолучитьИдентификатор();
		Элементы.Дерево.Развернуть(ИдентификаторСтроки, Истина);
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти