﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// СтандартныеПодсистемы.ВерсионированиеОбъектов
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Процедура ОтозватьПодписиПриУвольнении(ДополнительныеСвойства, Отказ) Экспорт
	
	ТаблицаОтзываемыхПодписей = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОтзываемыхПодписей;
	Для каждого СтрокаТаблицы Из ТаблицаОтзываемыхПодписей Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаТаблицы.ПодписьУвольняемого) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ПодписьОбъект = СтрокаТаблицы.ПодписьУвольняемого.ПолучитьОбъект();
		Попытка
			
			ПодписьОбъект.Заблокировать();
			ПодписьОбъект.ПравоОтозвано = Истина;
			ПодписьОбъект.Записать();
			
		Исключение
			
			Отказ = Истина;
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры	
	
Функция ПодписьИспользуетсяВДокументах(ПодписьСсылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПодписьСсылка) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(ПодписьСсылка);
	
	МассивОбластьПоиска = Новый Массив;
	Для каждого ОбъектМетаданных Из Метаданные.Документы Цикл
		
		МассивОбластьПоиска.Добавить(ОбъектМетаданных);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаСсылок = НайтиПоСсылкам(МассивСсылок, Новый Массив, МассивОбластьПоиска, Новый Массив);
	УжеИспользуется = (ТаблицаСсылок.Количество() > 0);
	ТаблицаСсылок = Неопределено;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат УжеИспользуется;
	
КонецФункции	
	
#КонецЕсли