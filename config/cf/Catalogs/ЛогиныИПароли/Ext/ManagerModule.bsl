﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий	

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Объект");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	Представление 			= Строка(Данные.Объект);
	СтандартнаяОбработка	= Ложь;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли