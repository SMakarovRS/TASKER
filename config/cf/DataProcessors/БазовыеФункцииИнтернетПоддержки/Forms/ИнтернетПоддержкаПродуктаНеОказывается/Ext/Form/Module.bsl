﻿
#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда 
		Возврат;
	КонецЕсли;
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаКонтента.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
	Если Параметры.ПриНачалеРаботыСистемы Тогда
		ЗапускатьПриСтарте = Истина;
	Иначе
		Элементы.ГруппаЗапускатьПриСтарте.Видимость = Ложь;
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = Строка(ЗапускатьПриСтарте);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ПрограммноеЗакрытие Тогда
		ИнтернетПоддержкаПользователейКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьСодержанияКонтентаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка. Интернет-поддержка продукта не оказывается.'"),
			НСтр("ru = 'При подключении Интернет-поддержки отображается сообщение ""Интернет-поддержка продукта не оказывается"".'"),
			,
			,
			Новый Структура("Логин, Пароль",
				ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"login"),
				ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"password")));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьНастройкуЗапускатьПриСтарте(ЗначениеНастройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтернетПоддержкаПользователей",
		"ВсегдаПоказыватьПриСтартеПрограммы",
		ЗначениеНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускатьПриСтартеПриИзменении(Элемент)
	
	УстановитьНастройкуЗапускатьПриСтарте(ЗапускатьПриСтарте);
	
КонецПроцедуры

#КонецОбласти