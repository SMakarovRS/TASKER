﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строки Из Номенклатура Цикл
		
		Если НЕ ЗначениеЗаполнено(Строки.МестоХранения) Тогда
			Строки.МестоХранения = МестоХранения;
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	УдалитьМестоХраненияОприходованияИзлишков = Справочники.МестаХранения.ПустаяСсылка();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда	
		Возврат;		
	КонецЕсли;
		
	// Проверка на ошибки.
	СписокОшибок = ПроверитьДокументПередПроведением();
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибок, Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		Основание = ДанныеЗаполнения;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Задание") Тогда
		Организация				= ДанныеЗаполнения.Организация;
		МестоХранения			= ДанныеЗаполнения.МестоХранения;
		Комментарий				= ДанныеЗаполнения.Тема;		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Проверяет документ перед проведением, возвращает СписокЗначений с ошибками,
// если пустой, то ошибок нет.
Функция ПроверитьДокументПередПроведением()
	
	СписокОшибок = Неопределено;
			
	// Проверка не заполненных столбцов.
	Для каждого Строки Из Номенклатура Цикл
		Если НЕ ЗначениеЗаполнено(Строки.КарточкаНоменклатуры) Тогда                                     
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, 
				"Объект.Номенклатура", 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
					"ru = 'Для номенклатуры %1 не заполнены карточки номенклатуры.'"),
					Строки.Номенклатура),
					"");
		КонецЕсли;		
	КонецЦикла;
	
	// Проверка, что в Номенклатуре нет услуг.
	Для каждого Строки Из Номенклатура Цикл
		
		Если ЗначениеЗаполнено(Строки.Номенклатура) Тогда
			Если ЗначениеЗаполнено(Строки.Номенклатура.ВидНоменклатуры) Тогда
				Если Строки.Номенклатура.ВидНоменклатуры.ТипВидаНоменклатуры = 
						Перечисления.ТипыВидовНоменклатуры.Услуга Тогда
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, 
						"Объект.Номенклатура", 
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
						"ru = 'Номенклатура %1 не может быть выбрана в дереве, т.к. это услуга.'"), 
						Строки.Номенклатура), 
						"");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;		
	КонецЦикла;
	
	Если СписокОшибок <> Неопределено Тогда
		Возврат СписокОшибок;
	КонецЕсли;
	
	// Есть ли дубли.
	ТЗДубли = Номенклатура.Выгрузить( ,"Номенклатура, КарточкаНоменклатуры, МестоХранения");
	ТЗДубли.Колонки.Добавить("Количество");
	ТЗДубли.ЗаполнитьЗначения(1, "Количество");
	ТЗДубли.Свернуть("Номенклатура, КарточкаНоменклатуры, МестоХранения", "Количество");
	Для Каждого Строки Из ТЗДубли Цикл
		Если Строки.Номенклатура.ВидНоменклатуры.ВестиУчетПоКарточкамНоменклатуры И Строки.Количество > 1 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, 
				"Объект.Номенклатура", 
				СтрШаблон(НСтр(
				"ru = 'Для номенклатуры %1 есть дублирующие строки по месту хранения %2.'"),
				Строки.Номенклатура, Строки.МестоХранения), 
				"");			
		КонецЕсли;
	КонецЦикла;
		
	// Проверки номенклатуры.
	Для Каждого Строки Из Номенклатура Цикл
		
		// Учет по карточкам и количество <> 1.
		Если Строки.Номенклатура.ВидНоменклатуры.ВестиУчетПоКарточкамНоменклатуры И Строки.Количество > 1 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, 
				"Объект.Номенклатура", 
				СтрШаблон(НСтр("ru = 'Для номенклатуры %1 в ее виде указано, что ведется учет по карточкам. 
				|Для такой номенклатуры количество в строке не может быть больше единицы.'"), 
				Строки.Номенклатура), 
				"");
		КонецЕсли;
		
		// Проверка, что карточка соответствует номенклатуре.
		Если Строки.Номенклатура <> Строки.КарточкаНоменклатуры.Владелец Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, 
				"Объект.Номенклатура", 
				СтрШаблон(НСтр(
				"ru = 'Для номенклатуры %1 выбрана карточка, которая не является дочерней карточкой этой номенклатуры.'"),
				Строки.Номенклатура),
				"");
		КонецЕсли;
		        
		// Карточка не заполнена.
		Если НЕ ЗначениеЗаполнено(Строки.КарточкаНоменклатуры) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, 
				"Объект.Номенклатура", 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
				"ru = 'В строке %1  не выбрана карточка номенклатуры.'"), 
				Строки.НомерСтроки), 
				"", 
				Строки.НомерСтроки);
		КонецЕсли;	
		
		// Не заполнено место хранения.
		Если НЕ ЗначениеЗаполнено(Строки.МестоХранения) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, 
				"Объект.Номенклатура", 
				СтрШаблон(НСтр("ru = 'В строке %1 не заполнено место хранения.'"),
				Строки.НомерСтроки), 
				"", 
				Строки.НомерСтроки);	
		КонецЕсли;	
		    
	КонецЦикла;			
	
	Возврат СписокОшибок;
	
КонецФункции

#КонецОбласти

#КонецЕсли