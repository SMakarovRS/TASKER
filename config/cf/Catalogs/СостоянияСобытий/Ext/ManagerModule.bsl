﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСостоянияСобытийПриПервоначальномЗаполнении() Экспорт
	
	// Описываем стуктуру
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Объект");
	ТЗ.Колонки.Добавить("Наименование");
	ТЗ.Колонки.Добавить("Цвет");
	
	СЗП = Справочники.СостоянияСобытий;
	
	ДобавитьВТаблицуЗначений(ТЗ, СЗП.Отменено,		НСтр("ru = 'Отменено'"),		WebЦвета.Серый);
	ДобавитьВТаблицуЗначений(ТЗ, СЗП.Завершено,		НСтр("ru = 'Завершено'"),		WebЦвета.Зеленый);
	ДобавитьВТаблицуЗначений(ТЗ, СЗП.Запланировано, НСтр("ru = 'Запланировано'"), 	WebЦвета.Синий);
		
	// Записываем
	Для Каждого Строки Из ТЗ Цикл
		Объект = Строки.Объект.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(Объект, Строки);
		Объект.Записать();
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет в таблицу значений данные по заполняемым объектам.
//
// Параметры:
//   ТЗ 	- ТаблицаЗначений - таблица, куда надо добавить.
//	 Объект - Справочники.СостоянияСобытий - предопределенный элемент.
//	 Цвет	- ХранилищеЗначения - цвет сохраненный в хранилище значений.
//
Процедура ДобавитьВТаблицуЗначений(ТЗ, Объект, Наименование, Цвет)
	
	НоваяСтрока 				= ТЗ.Добавить();
	НоваяСтрока.Объект		 	= Объект;
	НоваяСтрока.Наименование 	= Наименование;
	НоваяСтрока.Цвет		 	= Новый ХранилищеЗначения(Цвет);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли