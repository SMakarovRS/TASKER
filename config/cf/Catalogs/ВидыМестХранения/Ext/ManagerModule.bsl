﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет виды мест хранения по умолчанию.
//
// Параметры:
//	Нет
//
Процедура ЗаполнитьВидыМестХраненияПриПервоначальномЗаполнении() Экспорт
	
	// Описываем стуктуру.
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Объект");
	ТЗ.Колонки.Добавить("Наименование");
	ТЗ.Колонки.Добавить("ИмеетСетевыеНастройки");
	ТЗ.Колонки.Добавить("Картинка");
	
	ВД = Справочники.ВидыМестХранения;
	
	// Заполняем реквизитами.
	ДобавитьВТаблицуЗначений(ТЗ,	ВД.РабочееМесто,				НСтр("ru = 'Рабочее место'"), Истина		, БиблиотекаКартинок.вмхРабочееМесто);
	ДобавитьВТаблицуЗначений(ТЗ,	ВД.Склад,						НСтр("ru = 'Склад'"), 						, БиблиотекаКартинок.вмхСклад);
	ДобавитьВТаблицуЗначений(ТЗ,	ВД.Шкаф,						НСтр("ru = 'Шкаф'"), 						, БиблиотекаКартинок.вмхШкаф);
	ДобавитьВТаблицуЗначений(ТЗ,	ВД.СкладРасходныхМатериалов,	НСтр("ru = 'Склад расходных материалов'"), 	, БиблиотекаКартинок.вмхСкладРасходныхМатериалов);
	ДобавитьВТаблицуЗначений(ТЗ,	ВД.Полка,						НСтр("ru = 'Полка'"), 						, БиблиотекаКартинок.вмхПолка);
	ДобавитьВТаблицуЗначений(ТЗ,	ВД.СкладСписанногоОборудования,	НСтр("ru = 'Склад списанного оборудования'"),, БиблиотекаКартинок.вмхСкладСписанногоОборудования);
	ДобавитьВТаблицуЗначений(ТЗ,	ВД.СкладРемонта,				НСтр("ru = 'Склад ремонта'"), 				, БиблиотекаКартинок.вмхСкладРемонта);
	ДобавитьВТаблицуЗначений(ТЗ,	ВД.СерверныйШкаф,				НСтр("ru = 'Серверный шкаф'"), 				, БиблиотекаКартинок.вмхСерверныйШкаф);
	
	// Записываем.
	Для Каждого Строки Из ТЗ Цикл
		Объект = Строки.Объект.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(Объект, Строки);
		Объект.Картинка = Новый ХранилищеЗначения(Строки.Картинка.Получить());
		Объект.Записать();
	КонецЦикла;

	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьВТаблицуЗначений(ТЗ, Объект, Наименование, ИмеетСетевыеНастройки = Ложь, Картинка = Неопределено)
	
	НоваяСтрока = ТЗ.Добавить();
	НоваяСтрока.Объект		 				= Объект;
	НоваяСтрока.Наименование 				= Наименование;
	НоваяСтрока.ИмеетСетевыеНастройки		= ИмеетСетевыеНастройки;
	Если Картинка <> Неопределено Тогда
		НоваяСтрока.Картинка 				= Новый ХранилищеЗначения(Картинка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли