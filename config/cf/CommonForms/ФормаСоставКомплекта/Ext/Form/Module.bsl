﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Номенклатура") Тогда
		СтруктураНоменклатура 	= Параметры.Номенклатура.Номенклатура;
		НоменклатураИзКомплекта = ?(ЗначениеЗаполнено(СтруктураНоменклатура.КарточкаНоменклатуры),СтруктураНоменклатура.КарточкаНоменклатуры,
		СтруктураНоменклатура.Номенклатура);
	КонецЕсли;
	
	Если Параметры.Свойство("Комплект") Тогда
		Комплект = Параметры.Комплект;		
	КонецЕсли;
	
	Если Параметры.Свойство("СвернутыйКомплект") Тогда		
		СвернутыйКомплект = Параметры.СвернутыйКомплект;
	КонецЕсли;
	
	Если Параметры.Свойство("Период") Тогда
		Период = Параметры.Период;
	КонецЕсли;
	
	Если СтруктураНоменклатура.Свойство("ЕдиницаИзмерения") Тогда
		ЕдиницаИзмерения = СтруктураНоменклатура.ЕдиницаИзмерения;
	КонецЕсли;
	
	ВывестиДеревоНоменклатуры();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеITОтделом8УФКлиент.РазвернутьДеревоНоменклатуры(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Добавить(Команда)
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ДобавитьКомплект",			  Истина);
	СтруктураВозврата.Вставить("СвернутыйКомплект",СвернутыйКомплект);
	СтруктураВозврата.Вставить("Номенклатура",				Комплект);
	СтруктураВозврата.Вставить("ЕдиницаИзмерения",	ЕдиницаИзмерения);
	Закрыть(СтруктураВозврата);
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ДобавитьКомплект", Ложь);
	Закрыть(СтруктураВозврата);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	ТекущаяСтрока = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекущаяСтрока.КарточкаНоменклатуры) Тогда
		ПоказатьЗначение(,ТекущаяСтрока.КарточкаНоменклатуры);	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНоменклатуру(Команда)
	Если ДеревоНоменклатуры.ПолучитьЭлементы().Количество()>0 Тогда
		ТекущаяСтрока = Элементы.ДеревоНоменклатуры.ТекущиеДанные;
		Если ТекущаяСтрока = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
			ПоказатьЗначение(,ТекущаяСтрока.Номенклатура);	
		КонецЕсли;
	Иначе
		ПоказатьЗначение(,НоменклатураИзКомплекта);					
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура получает и выводит комплект в форму.
//
&НаСервере
Процедура ВывестиДеревоНоменклатуры()
	
	ПолучитьКомплект();
	КартинкаНоменклатуры = УправлениеITОтделом8УФПовтИсп.ПолучитьНавСсылкуНоменклатуры(НоменклатураИзКомплекта); 
	// Номенклатура не является частью комплекта.
	Если ДеревоНоменклатурыТЗ.Количество() = 1
		И (НоменклатураИзКомплекта = ДеревоНоменклатурыТЗ[0].КарточкаНоменклатуры 
        ИЛИ	НоменклатураИзКомплекта = ДеревоНоменклатурыТЗ[0].Номенклатура)	Тогда		
		Заголовок 									= НСтр("ru = 'Найдена номенклатура'");
		Элементы.Добавить.Заголовок 				= НСтр("ru = 'Добавить'");
		Элементы.ДекорацияЧастьКомплекта.Заголовок 	= НСтр("ru = 'не входит ни в один комплект.'");
		Элементы.ОткрытьКарточку.Видимость 			= Ложь;
		Элементы.ДекорацияПустаяКнопка.Видимость 	= Истина;
	Иначе
		ТЗ = Новый ТаблицаЗначений;
		ТЗ = ДеревоНоменклатурыТЗ.Выгрузить();
		Для Каждого Строки Из ТЗ Цикл
			Строки.НавСсылка = УправлениеITОтделом8УФПовтИсп.ПолучитьНавСсылкуНоменклатуры(Строки.Номенклатура);
		КонецЦикла;		
		ДЗ = ДанныеФормыВЗначение(ДеревоНоменклатуры, Тип("ДеревоЗначений"));
		ДЗ.Строки.Очистить();		
		УправлениеITОтделом8УФ.ВывестиДеревоНоменклатуры(ДЗ, ТЗ);
		ЗначениеВДанныеФормы(ДЗ, ДеревоНоменклатуры);			
	КонецЕсли;	
КонецПроцедуры

// Функция получает данные о комплекте.
//
&НаСервере
Функция ПолучитьКомплект()
	Номенклатура = Комплект;	
	НайденнаяНоменклатура = Новый Структура;		
	Если Не Номенклатура.ВидНоменклатуры.ВестиУчетПоКарточкамНоменклатуры Тогда
		НайденнаяНоменклатура.Вставить("Номенклатура",			Номенклатура);
		НайденнаяНоменклатура.Вставить("КарточкаНоменклатуры",	ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"));
		НайденнаяНоменклатура.Вставить("ЕдиницаИзмерения", 		Номенклатура.ЕдиницаИзмерения);
	Иначе	
		НайденнаяНоменклатура.Вставить("Номенклатура",			Номенклатура.Владелец);
		НайденнаяНоменклатура.Вставить("КарточкаНоменклатуры",	Номенклатура);
		НайденнаяНоменклатура.Вставить("ЕдиницаИзмерения", 		Номенклатура.Владелец.ЕдиницаИзмерения);
	КонецЕсли;
	
	НоваяСтрока = ДеревоНоменклатурыТЗ.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока,НайденнаяНоменклатура);
	ЗаполнитьПодчиненнуюНоменклатуру(Период,НоваяСтрока.КарточкаНоменклатуры);		
КонецФункции 

// Функция возвращает подчиненную номенклатуру.
//
&НаСервере
Функция ЗаполнитьПодчиненнуюНоменклатуру(Период, НоменклатураВладелец)
	
	Запрос = Новый Запрос;	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КомплектацияОстатки.Комплект,
	|	КомплектацияОстатки.Партия КАК Партия,
	|	КомплектацияОстатки.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрНакопления.Комплектация.Остатки(&Период, Комплект = &Партия) КАК КомплектацияОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	NULL,
	|	ОстаткиОстатки.Партия,
	|	ОстаткиОстатки.Номенклатура
	|ИЗ
	|	РегистрНакопления.Остатки.Остатки(&Период, Партия = &Партия) КАК ОстаткиОстатки";	
    
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Партия", НоменклатураВладелец);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ТипЗнч(Выборка.Номенклатура) = Тип("СправочникСсылка.КарточкиНоменклатуры") Тогда			
			Номенклатура			= Выборка.Номенклатура.Владелец;
			КарточкаНоменклатуры	= Выборка.Номенклатура; 			
		Иначе
			
			Номенклатура			= Выборка.Номенклатура;
			КарточкаНоменклатуры	= УправлениеITОтделом8УФПовтИсп.ПолучитьКарточкуНеВедетсяУчетПоКарточкамНоменклатуры(Выборка.Номенклатура); 			
		КонецЕсли;
		
		ПодчиненнаяНоменклатура = Новый Структура;
		ПодчиненнаяНоменклатура.Вставить("Номенклатура",		Номенклатура);				
		ПодчиненнаяНоменклатура.Вставить("Партия", 				Выборка.Партия);
		ПодчиненнаяНоменклатура.Вставить("КарточкаНоменклатуры",КарточкаНоменклатуры);
		ПодчиненнаяНоменклатура.Вставить("Комплект",			?(НоменклатураВладелец = Номенклатура, Справочники.КарточкиНоменклатуры.ПустаяСсылка(), НоменклатураВладелец));
		
		ПодчиненнаяНоменклатура.Вставить("ЕдиницаИзмерения", 	Номенклатура.ЕдиницаИзмерения);		
		НоваяСтрока					= ДеревоНоменклатурыТЗ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,ПодчиненнаяНоменклатура);		
		
		Если СвернутыйКомплект Тогда Продолжить
		Иначе	
			ЗаполнитьПодчиненнуюНоменклатуру(Период, ПодчиненнаяНоменклатура.КарточкаНоменклатуры);
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции 

#КонецОбласти


