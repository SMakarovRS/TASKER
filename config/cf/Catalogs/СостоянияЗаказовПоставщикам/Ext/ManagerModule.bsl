﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет состояния заказов поставщикам по умолчанию.
//
// Параметры:
//	Нет.
//
Процедура ЗаполнитьСостоянияЗаказовПоставщикамПриПервоначальномЗаполнении() Экспорт
	
	// Описываем стуктуру.
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Объект");
	ТЗ.Колонки.Добавить("Наименование");
	ТЗ.Колонки.Добавить("СтатусЗаказа");
	ТЗ.Колонки.Добавить("Цвет");
	
	СЗП = Справочники.СостоянияЗаказовПоставщикам;
	
	ДобавитьВТаблицуЗначений(ТЗ, СЗП.Выполнен, 		НСтр("ru = 'Выполнен'"),Перечисления.СтатусыЗаказов.Выполнен, 	WebЦвета.Зеленый);
	ДобавитьВТаблицуЗначений(ТЗ, СЗП.Заявка,		НСтр("ru = 'Заявка'"), 	Перечисления.СтатусыЗаказов.Открыт, 	WebЦвета.ТемноГрифельноСиний);
	ДобавитьВТаблицуЗначений(ТЗ, СЗП.Открыт,		НСтр("ru = 'В работе'"),Перечисления.СтатусыЗаказов.ВРаботе, 	WebЦвета.Синий);
	ДобавитьВТаблицуЗначений(ТЗ, СЗП.Отменен,		НСтр("ru = 'Отменен'"),	Перечисления.СтатусыЗаказов.Отменен, 	WebЦвета.Серый);
	
	ДобавитьВТаблицуЗначений(ТЗ, СЗП.Согласован,	НСтр("ru = 'Согласован'"),		Перечисления.СтатусыЗаказов.ВРаботе, 	WebЦвета.СинеСерый);
	ДобавитьВТаблицуЗначений(ТЗ, СЗП.НеСогласован,	НСтр("ru = 'Не согласован'"),	Перечисления.СтатусыЗаказов.Отменен, 	WebЦвета.ТемноСерый);
	
	// Записываем.
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
//	 Наименование - Строка - наименование элемента.
//	 Объект - Справочники.СостоянияЗаказовПоставщикам - предопределенный элемент.
//	 СтатусЗаказа - ПеречислениеСсылка.СтатусыЗаказов - статусы расширенные.
//	 Цвет	- ХранилищеЗначения - цвет сохраненный в хранилище значений.
//
Процедура ДобавитьВТаблицуЗначений(ТЗ, Объект, Наименование, СтатусЗаказа, Цвет)
	
	НоваяСтрока 				= ТЗ.Добавить();
	НоваяСтрока.Объект		 	= Объект;
	НоваяСтрока.Наименование 	= Наименование;
	НоваяСтрока.СтатусЗаказа 	= СтатусЗаказа;
	НоваяСтрока.Цвет		 	= Новый ХранилищеЗначения(Цвет);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли