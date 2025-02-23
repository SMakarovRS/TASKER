﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Возврат Результат;
	
КонецФункции

// СтандартныеПодсистемы.Печать

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

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
	СоответствиеРасчетМетрик.Вставить("БюджетыРасчетМетрикЗаписьЭлемента", НСтр("ru = 'Запись элемента'"));

	Соответствие = Новый Соответствие;
	Соответствие.Вставить("СоответствиеИзменениеОбъекта", 	  СоответствиеИзменениеОбъекта);
	Соответствие.Вставить("СоответствиеПериодическоеСобытие", СоответствиеПериодическоеСобытие);
	Соответствие.Вставить("СоответствиеРасчетМетрик", 		  СоответствиеРасчетМетрик);
	
	Возврат Соответствие;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.УправлениеДоступом
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
		
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецЕсли