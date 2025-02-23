﻿
#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстРегистрации Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтранаПередИзменением = Страна;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	Если СтранаПередИзменением = Страна Тогда
		Возврат;
	КонецЕсли;
	
	РегионыСтраны = КонтекстРегистрации.РегионыСтран[Страна];
	Если РегионыСтраны = Неопределено Тогда
		РегионыСтраны = Новый СписокЗначений;
		РегионыСтраны.Добавить("-1", НСтр("ru = '<не выбран>'"));
	КонецЕсли;
	
	ИнтернетПоддержкаПользователейКлиент.СкопироватьСписокЗначенийИтерационно(
		РегионыСтраны,
		Элементы.КодРегиона.СписокВыбора);
	
	КодРегиона = "-1";
	
	СтранаПередИзменением = Страна;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ТолькоПросмотр Тогда
		Закрыть();
	Иначе
		Закрыть(СтруктураДанныхАдреса());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СтруктураДанныхАдреса()
	
	Результат = Новый Структура;
	Результат.Вставить("Страна"    , Страна);
	Результат.Вставить("Индекс"    , Индекс);
	Результат.Вставить("КодРегиона", КодРегиона);
	Результат.Вставить("Район"     , Район);
	Результат.Вставить("Город"     , Город);
	Результат.Вставить("Улица"     , Улица);
	Результат.Вставить("Дом"       , Дом);
	Результат.Вставить("Строение"  , Строение);
	Результат.Вставить("Квартира"  , Квартира);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
