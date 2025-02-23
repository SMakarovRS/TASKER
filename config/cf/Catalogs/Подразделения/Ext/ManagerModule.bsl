﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Объект, Представление, СтандартнаяОбработка)
	
	Представление 			= СтрШаблон(НСтр("ru = '%1%2'"), Объект.Наименование, ?(ЗначениеЗаполнено(Объект.Организация), " (" + Объект.Организация + ")", ""));
	СтандартнаяОбработка 	= Ложь;	
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Наименование");
	Поля.Добавить("Организация");
	СтандартнаяОбработка = Ложь;	
	
КонецПроцедуры

#Область ПравилаСобытий

// Функция - Все условия правил событий для объекта.
// 
// Возвращаемое значение:
//  Соответствие - соответствие с условиями.
//
Функция УсловияПравилаСобытий() Экспорт
	
	СоответствиеИзменениеОбъекта     = Новый Соответствие;	
	СоответствиеПериодическоеСобытие = Новый Соответствие;
	
	СоответствиеРасчетМетрик = Новый Соответствие;
	СоответствиеРасчетМетрик.Вставить("ПодразделенияРасчетМетрикЗаписьЭлемента", НСтр("ru = 'Запись элемента'"));

	Соответствие = Новый Соответствие;
	Соответствие.Вставить("СоответствиеИзменениеОбъекта", 	  СоответствиеИзменениеОбъекта);
	Соответствие.Вставить("СоответствиеПериодическоеСобытие", СоответствиеПериодическоеСобытие);
	Соответствие.Вставить("СоответствиеРасчетМетрик", 		  СоответствиеРасчетМетрик);
	
	Возврат Соответствие;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецЕсли