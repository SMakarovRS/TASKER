﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСписокНастроекОбменаДанными();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтображениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Отображение) Тогда
		Элементы.НастройкиОбменаДанными.ОтборСтрок = Новый ФиксированнаяСтруктура("ТекущаяИБ", Истина);
	Иначе
		Элементы.НастройкиОбменаДанными.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Удалить(Команда)
	
	Если Элементы.НастройкиОбменаДанными.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"УдалитьПриОтветеНаВопрос",
		ЭтотОбъект);
	
	ТекстВопроса = НСтр("ru = 'Настройка и все не загруженные файлы обмена будут удалены в сервисе обмена с внешними системами.
		|Удалить настройку обмена?'");
	
	ПоказатьВопрос(
		ОписаниеОповещения,
		ТекстВопроса,
		РежимДиалогаВопрос.ДаНет,
		,
		КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокНастроекОбменаДанными();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция УдалитьНаСервере()
	
	ДанныеСтроки = НастройкиОбменаДанными.НайтиПоИдентификатору(
		Элементы.НастройкиОбменаДанными.ТекущаяСтрока);
	Если ДанныеСтроки <> Неопределено Тогда
		РезультатУдаления = СервисОбменаСообщениями.УдалитьИдентификаторОбменаДанными(
			ДанныеСтроки.ИдентификаторНастройки);
		Если ЗначениеЗаполнено(РезультатУдаления.КодОшибки) Тогда
			Возврат Ложь;
		Иначе
			ОбновитьСписокНастроекОбменаДанными();
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбновитьСписокНастроекОбменаДанными()
	
	Результат = СервисОбменаСообщениями.ИнформацияОНастроенныхОбменахДанными();
	
	Если ЗначениеЗаполнено(Результат.КодОшибки) Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОшибки;
		Элементы.ДекорацияОшибкаНадпись.Заголовок = Результат.СообщениеОбОшибке;
		Возврат;
	Иначе
		НастройкиОбменаДанными.Загрузить(Результат.НастройкиОбменаДанными);
	КонецЕсли;
	
	НастройкиТранспортаОбмена = ОбменДаннымиСервер.ВсеНастройкиТранспортаОбменаСВнешнимиСистемами();
	Для Каждого ОписаниеНастройки Из НастройкиТранспортаОбмена Цикл
		
		Отбор = Новый Структура;
		Отбор.Вставить("ИдентификаторНастройки", ОписаниеНастройки.НастройкиТранспорта.ИдентификаторОбмена);
		
		НайденныеСтроки = НастройкиОбменаДанными.НайтиСтроки(Отбор);
		Для Каждого ОписаниеОбмена Из НайденныеСтроки Цикл
			ОписаниеОбмена.ТекущаяИБ = Истина;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПриОтветеНаВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	РезультатУдаления = УдалитьНаСервере();
	Если РезультатУдаления = Неопределено Тогда
		Возврат;
	ИначеЕсли РезультатУдаления = Истина Тогда
		ПоказатьОповещениеПользователя(
		НСтр("ru = 'Настройка обмена данными удалена'"),
		,
		НСтр("ru = 'Удаление настройки обмена данными успешно завершено.'"));
	ИначеЕсли РезультатУдаления = Ложь Тогда
		ПоказатьОповещениеПользователя(
		НСтр("ru = 'Настройка обмена данными не удалена'"),
		,
		НСтр("ru = 'При попытке выполнить удаление настройки обмена данными сервис вернул ошибку.
			|Подробнее см. журнал регистрации.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

