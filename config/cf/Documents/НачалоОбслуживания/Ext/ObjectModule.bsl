﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПоложениеСтатьиДоходовРасходов = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Для каждого Строки Из Номенклатура Цикл
			Строки.СтатьяДоходовРасходов = СтатьяДоходовРасходов;
		КонецЦикла;
		Для каждого Строки Из Услуги Цикл
			Строки.СтатьяДоходовРасходов = СтатьяДоходовРасходов;
		КонецЦикла;
	КонецЕсли;
	
	Если (ПоложениеПодразделения = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке) ИЛИ (НЕ ЗначениеЗаполнено(ПоложениеПодразделения)) Тогда
		Для каждого Строки Из Номенклатура Цикл
			Строки.Подразделение = Подразделение;
		КонецЦикла;
		Для каждого Строки Из Услуги Цикл
			Строки.Подразделение = Подразделение;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда	
		Возврат;		
	КонецЕсли;
	
	// Проверка на ошибки
	СписокОшибок = ПроверитьДокументПередПроведением();
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(СписокОшибок, Отказ);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеITОтделом8УФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	СЛС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);	
	
	// Подготовка наборов записей.
	УправлениеITОтделом8УФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	СЛС.ОтразитьДвиженияВРазделахУчета(Ссылка, ДополнительныеСвойства, Движения, Отказ);
		
	// Запись наборов записей.
	УправлениеITОтделом8УФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль.
	СЛС.ВыполнитьКонтрольОтрицательныхОстатков(Ссылка, ДополнительныеСвойства, Отказ);	
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	УправлениеITОтделом8УФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеITОтделом8УФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеITОтделом8УФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	СЛС.ВыполнитьКонтрольОтрицательныхОстатков(Ссылка, ДополнительныеСвойства, Отказ, Истина);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		Основание = ДанныеЗаполнения;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Задание") Тогда
		
		Организация			= ДанныеЗаполнения.Организация;
		МестоХранения		= ДанныеЗаполнения.МестоХранения;
		Комментарий			= ДанныеЗаполнения.Тема;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Поступление") ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СборкаКомплектация") Тогда
		
		Организация			= ДанныеЗаполнения.Организация;
		МестоХранения		= ДанныеЗаполнения.МестоХранения;
		
		Для Каждого Строки Из ДанныеЗаполнения.Номенклатура Цикл
			НоваяСтрока = Номенклатура.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строки);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Перемещение") Тогда
		
		Организация			= ДанныеЗаполнения.ОрганизацияПрихода;
		МестоХранения		= ДанныеЗаполнения.МестоХраненияПрихода;
		Для Каждого Строки Из ДанныеЗаполнения.Номенклатура Цикл
			НоваяСтрока = Номенклатура.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строки);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РазбиениеКомплектации") Тогда
		
		Организация			= ДанныеЗаполнения.Организация;
		МестоХранения		= ДанныеЗаполнения.МестоХранения;
		Для Каждого Строки Из ДанныеЗаполнения.Номенклатура Цикл
			Если Строки.Разбиение Тогда
				НоваяСтрока = Номенклатура.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строки, , "Партия");
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	// Получаем комплект (верхнюю строку)
	Для Каждого Строки Из Номенклатура Цикл
		
		Если ЗначениеЗаполнено(Строки.Партия) Тогда
			
			Родитель			= Строки.Партия;
			ПредыдущийРодитель 	= Родитель;
			Пока ЗначениеЗаполнено(Родитель) Цикл
				ПредыдущийРодитель = Родитель;
				СтрокаПоиска = Номенклатура.Найти(Родитель, "КарточкаНоменклатуры");
				Если СтрокаПоиска <> Неопределено Тогда
					Родитель = СтрокаПоиска.Партия;
				Иначе
					Родитель = Справочники.КарточкиНоменклатуры.ПустаяСсылка();
				КонецЕсли;
			КонецЦикла;
			
			Если НЕ ЗначениеЗаполнено(Родитель) И ЗначениеЗаполнено(ПредыдущийРодитель) Тогда
				Строки.Комплект = ПредыдущийРодитель;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет документ перед проведением, возвращает СписокЗначений с ошибками,
// если пустой, то ошибок нет.
Функция ПроверитьДокументПередПроведением()
	
	СписокОшибок = Неопределено;
	
	// Если не заполнен контрагент.
	Если ВидНачалаОбслуживания = Перечисления.ВидыНачалаОбслуживания.ОбслуживаниеКонтрагентом И НЕ ЗначениеЗаполнено(Контрагент) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, "Объект.Контрагент", НСтр("ru='Не выбран контрагент для обслуживания оборудования'"), "");
	КонецЕсли;
	
	// Если не заполнено Место обслуживания.
	Если ВидНачалаОбслуживания = Перечисления.ВидыНачалаОбслуживания.ВнутреннееОбслуживание И НЕ ЗначениеЗаполнено(МестоОбслуживания) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, "Объект.МестоОбслуживания", НСтр("ru='Не выбрано место, куда будет перемещено оборудование для обслуживания'"), "");
	КонецЕсли;
	
	Если РаспределятьУслуги = Истина Тогда
		Если Номенклатура.Итог("СуммаРасходов") = 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, 
				"Объект.РаспределятьУслуги", 
				НСтр("ru = 'В документе включено ""Распределение услуг"", при этом распределенная сумма доп.расходов по номенклатуре равна 0.'"), "");
		КонецЕсли;
			
		Если Номенклатура.Итог("СуммаРасходов") > Услуги.Итог("Всего") Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(СписокОшибок, 
				"Объект.Услуги", 
				НСтр("ru = 'Распределенная сумма доп.расходов по номенклатуре больше суммы услуг.'"), "");
		КонецЕсли;			
	КонецЕсли;
	
	Возврат СписокОшибок;
	
КонецФункции

#КонецОбласти

#КонецЕсли