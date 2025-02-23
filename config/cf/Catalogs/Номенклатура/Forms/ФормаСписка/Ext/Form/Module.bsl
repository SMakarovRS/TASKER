﻿
#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КодФормы = "Справочник_Номенклатура_ФормаСписка";	
	
	УстановитьЗначенияПоНастройкамФормы();
	
	УстановитьВидимостьИДоступность();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокНоменклатура.КоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтображениеСпискаНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьФильтрыПриИзменении(Элемент)
	ИспользоватьФильтрыПриИзмененииНаСервере();
	УстановитьОтображениеСпискаНоменклатуры();
КонецПроцедуры

&НаКлиенте
Процедура ИерархияНоменклатураПриАктивизацииСтроки(Элемент)
	Если ВариантНавигации <> ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ИерархияНоменклатура.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущаяИерархияНоменклатуры = ТекущиеДанные.Ссылка Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяИерархияНоменклатуры = ТекущиеДанные.Ссылка;
	
	Если ИспользоватьФильтры Тогда
		ПодключитьОбработчикОжидания("ИерархияНоменклатураПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатураПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("СписокНоменклатураПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНавигацииПриИзменении(Элемент)
	
	ВариантНавигацииПриИзмененииНаСервере();
	УстановитьОтображениеСпискаНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыОтборПриИзменении(Элемент)
	
	ВидНоменклатурыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыНоменклатурыПриАктивизацииСтроки(Элемент)
	
	Если Не (ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоХарактеристикам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИХарактеристикам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидам")) Тогда
		Возврат;
	КонецЕсли;		
	ТекущиеДанные = Элементы.ВидыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
		Или ВидНоменклатуры = ТекущиеДанные.Ссылка Тогда
		Возврат;
	КонецЕсли;
	
	ВидНоменклатуры = ТекущиеДанные.Ссылка;

	Если Не ИспользоватьФильтры Тогда
		Возврат;
	КонецЕсли;	
	
	ПодключитьОбработчикОжидания("ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТД = Элементы.Характеристики.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТД.ВидХарактеристики) Тогда
		Элементы.ХарактеристикиЗначение.ОграничениеТипа =
			Новый ОписаниеТипов(ПолучитьТипЗначенияХарактеристики(ТД.ВидХарактеристики));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиЗначениеПриИзменении(Элемент)
	
	ТД = Элементы.Характеристики.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТД.Флаг = ЗначениеЗаполнено(ТД.Значение);
	НайтиПоХарактеристикамНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиФлагПриИзменении(Элемент)
	
	НайтиПоХарактеристикамНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.СписокНоменклатура);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПоискПоХарактеристикам(Команда)
	
	ОтменитьПоискПоХарактеристикамНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьФильтры(Команда)
	
	ПоказыватьСкрыватьФильтры 					= Не ПоказыватьСкрыватьФильтры;
	Если ПоказыватьСкрыватьФильтры Тогда
		Элементы.ПоказатьСкрытьФильтры.Заголовок	= НСтр("ru = 'Скрыть фильтры>>'");
		Элементы.ГруппаВариантыНавигации.Видимость 	= Истина;
	Иначе
		Элементы.ПоказатьСкрытьФильтры.Заголовок	= НСтр("ru = '<<Показать фильтры'");
		Элементы.ГруппаВариантыНавигации.Видимость 	= Ложь;
		ИспользоватьФильтры 						= Ложь;
		УдалитьОтборПоИерархииНоменклатуры();
		ТекущаяИерархияНоменклатуры = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
		УдалитьОтборПоВидуНоменклатурыИХарактеристикамВидаНоменклатуры();
		ВидНоменклатуры = ПредопределенноеЗначение("Справочник.ВидыНоменклатуры.ПустаяСсылка");
		ХарактеристикиОтбор.Очистить();
	КонецЕсли;	
	УстановитьВидимостьИДоступность();
	УстановитьОтображениеСпискаНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокНоменклатура);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокНоменклатура, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокНоменклатура);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаСервере
Процедура УстановитьЗначенияПоНастройкамФормы()
	
	// Установить значения по умолчанию.
	ИспользоватьФильтры 						= Истина;
	ПоказыватьСкрыватьФильтры 					= Истина;
	Элементы.ПоказатьСкрытьФильтры.Заголовок 	= НСтр("ru = 'Скрыть фильтры>>'");
	ВариантНавигации 							= Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии;	
	ВидНоменклатуры 							= Справочники.ВидыНоменклатуры.ПустаяСсылка();
	ТекущаяИерархияНоменклатуры 				= Справочники.Номенклатура.ПустаяСсылка();
	// Если есть сохраненные настройки, то установить значения по настройкам.
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КодФормы,  "");
	Если Настройки <> Неопределено Тогда		
		
		Если Настройки.Свойство("ПоказыватьСкрыватьФильтры") Тогда
			ПоказыватьСкрыватьФильтры  = Настройки.ПоказыватьСкрыватьФильтры;
		КонецЕсли;
		
		Если Не ПоказыватьСкрыватьФильтры Тогда
			ИспользоватьФильтры  = Ложь;			
		ИначеЕсли Настройки.Свойство("ИспользоватьФильтры") Тогда
			ИспользоватьФильтры  = Настройки.ИспользоватьФильтры;
		КонецЕсли;
		
		Если Настройки.Свойство("ВариантНавигации") И ЗначениеЗаполнено(Настройки.ВариантНавигации) Тогда			       			
			ВариантНавигации 	 = Настройки.ВариантНавигации;
		КонецЕсли;
		
		Если Настройки.Свойство("ТекущаяИерархияНоменклатуры") И ЗначениеЗаполнено(Настройки.ТекущаяИерархияНоменклатуры) Тогда
			Если Настройки.ТекущаяИерархияНоменклатуры.ПолучитьОбъект() <> Неопределено Тогда
				ТекущаяИерархияНоменклатуры	= Настройки.ТекущаяИерархияНоменклатуры;
			КонецЕсли;	
		КонецЕсли;
		
		Если Настройки.Свойство("ВидНоменклатуры") И ЗначениеЗаполнено(Настройки.ВидНоменклатуры) Тогда				
			// Проверить, что ссылка указывает на существующий объект.
			Если Настройки.ВидНоменклатуры.ПолучитьОбъект() <> Неопределено Тогда					
				ВидНоменклатуры = Настройки.ВидНоменклатуры;				
			КонецЕсли;	
		КонецЕсли;		
		
		Если ПоказыватьСкрыватьФильтры Тогда
			Если ИспользоватьФильтры Тогда			
				Если ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоВидам
					ИЛИ ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИХарактеристикам
					ИЛИ ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоХарактеристикам Тогда
					Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
						Элементы.ВидыНоменклатуры.ТекущаяСтрока = ВидНоменклатуры;
						ВидНоменклатурыПриИзмененииНаСервере();
					КонецЕсли;	
				Иначе
					Если ЗначениеЗаполнено(ТекущаяИерархияНоменклатуры) Тогда 
						Элементы.ИерархияНоменклатура.ТекущаяСтрока = ТекущаяИерархияНоменклатуры; 
						ОтборПоИерархииПриИзмененииНаСервере();										
					КонецЕсли;					
				КонецЕсли;			
			КонецЕсли;
		Иначе Элементы.ПоказатьСкрытьФильтры.Заголовок 	= НСтр("ru = '<<Показать фильтры'");
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьИДоступность()	
	
	Элементы.ГруппаВариантыНавигации.Видимость	= ПоказыватьСкрыватьФильтры;
	Элементы.ВариантНавигации.Доступность 		= ИспользоватьФильтры;
	Элементы.ИерархияНоменклатура.Доступность 	= ИспользоватьФильтры;
	Элементы.ВидыНоменклатуры.Доступность		= ИспользоватьФильтры;
	Элементы.ВидНоменклатурыОтбор.Доступность	= ИспользоватьФильтры;
	Элементы.Характеристики.Доступность			= ИспользоватьФильтры;
	
	Если Не ЗначениеЗаполнено(ВариантНавигации) Тогда
		ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии;
	КонецЕсли;
	
	Если ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии Тогда
		СтраницаВариантаНавигации = Элементы.ПоИерархии;		
		
	ИначеЕсли Не ЗначениеЗаполнено(ВариантНавигации) Тогда
		СтраницаВариантаНавигации = Элементы.ПоИерархии;
		ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии;
		
	ИначеЕсли ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоВидам Тогда
		СтраницаВариантаНавигации 				= Элементы.ПоХарактеристикам;
		Элементы.ВидыНоменклатуры.Видимость 	= Истина;
		Элементы.ВидНоменклатурыОтбор.Видимость	= Ложь;
		Элементы.Характеристики.Видимость 		= Ложь;		
	
	ИначеЕсли ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИХарактеристикам Тогда
		СтраницаВариантаНавигации 				= Элементы.ПоХарактеристикам;
		Элементы.ВидыНоменклатуры.Видимость 	= Истина;
		Элементы.ВидНоменклатурыОтбор.Видимость = Ложь;
		Элементы.Характеристики.Видимость 		= Истина;
		
	ИначеЕсли ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоХарактеристикам Тогда
		СтраницаВариантаНавигации = Элементы.ПоХарактеристикам;
		Элементы.ВидыНоменклатуры.Видимость 	= Ложь;
		Элементы.ВидНоменклатурыОтбор.Видимость	= Истина;
		Элементы.Характеристики.Видимость 		= Истина;
	КонецЕсли;	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = СтраницаВариантаНавигации;
	УстановитьОтображениеСпискаНоменклатурыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ИспользоватьФильтрыПриИзмененииНаСервере()	
	Если ИспользоватьФильтры Тогда
		Если (ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоХарактеристикам
			Или ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИХарактеристикам
			Или ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоВидам) Тогда		
			ВидНоменклатурыДоИзменения = Неопределено;
			ВидНоменклатурыПриИзмененииНаСервере();
		Иначе			
		    ИерархияНоменклатурыДоИзменения = Неопределено;
			ОтборПоИерархииПриИзмененииНаСервере();
		КонецЕсли;	
	Иначе		
		УдалитьОтборПоИерархииНоменклатуры();
		ТекущаяИерархияНоменклатуры = Справочники.Номенклатура.ПустаяСсылка();
		УдалитьОтборПоВидуНоменклатурыИХарактеристикамВидаНоменклатуры();
		ВидНоменклатуры = Справочники.ВидыНоменклатуры.ПустаяСсылка();
		ХарактеристикиОтбор.Очистить();
	КонецЕсли;	
	УстановитьВидимостьИДоступность();
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтрокуИерархииНоменклатуры()	
	ТекущаяСтрока = Элементы.СписокНоменклатура.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущаяСтрока, "Родитель");
	
	Элементы.ИерархияНоменклатура.ТекущаяСтрока = Родитель;
	ТекущаяИерархияНоменклатуры = Родитель;
КонецПроцедуры // ()

&НаСервере
Процедура УдалитьОтборПоИерархииНоменклатуры()
	Если ТекущаяИерархияНоменклатуры = Неопределено Тогда
		ТекущаяИерархияНоменклатуры = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
	КонецЕсли;
	ЭлементыОтбора = ПолучитьОтборДинамическогоСписка(СписокНоменклатура);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементыОтбора,
		"Родитель",
		ТекущаяИерархияНоменклатуры,
		ВидСравненияКомпоновкиДанных.Равно, 
		"ТекущаяИерархияНоменклатуры",
		Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИерархияНоменклатураПриАктивизацииСтрокиОбработчикОжидания()
	ОтборПоИерархииПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоИерархииНоменклатуры()	
	Если Не ИспользоватьФильтры Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущаяИерархияНоменклатуры = Неопределено Тогда
		ТекущаяИерархияНоменклатуры = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");	
	КонецЕсли;
	
	ЭлементыОтбора = ПолучитьОтборДинамическогоСписка(СписокНоменклатура);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементыОтбора,
		"Родитель",
		ТекущаяИерархияНоменклатуры,
		ВидСравненияКомпоновкиДанных.Равно, 
		"ТекущаяИерархияНоменклатуры",
		Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементыОтбора,
		"ЭтоГруппа",
		Ложь,
		ВидСравненияКомпоновкиДанных.Равно, 
		"ЭтоГруппаЛожь",
		Истина);
КонецПроцедуры

&НаКлиенте
Процедура СписокНоменклатураПриАктивизацииСтрокиОбработчикОжидания()
	Если ИспользоватьФильтры
		И Не (ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоХарактеристикам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИХарактеристикам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидам") 
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии")) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.СписокНоменклатура.ТекущаяСтрока;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.СписокНоменклатура.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ТекущиеДанные.ЭтоГруппа Тогда				
		Если ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии") Тогда 			
			ВидНоменклатуры 									= ТекущиеДанные.ВидНоменклатуры;
			
			Если Элементы.ИерархияНоменклатура.ТекущаяСтрока 	= ТекущиеДанные.Родитель Тогда
				Возврат;
			КонецЕсли;
			
			ТекущаяИерархияНоменклатуры                 		= ТекущиеДанные.Родитель;			
			ТекущийЭлементФормы 								= ЭтаФорма.ТекущийЭлемент;
			Если ТекущийЭлементФормы<>Неопределено И ТекущийЭлементФормы<>Элементы.ИерархияНоменклатура Тогда
				Элементы.ИерархияНоменклатура.ТекущаяСтрока 	= ТекущиеДанные.Родитель;
			КонецЕсли;
		Иначе
			ТекущаяИерархияНоменклатуры                 		= ТекущиеДанные.Родитель;
			Если Элементы.ВидыНоменклатуры.ТекущаяСтрока 		= ТекущиеДанные.ВидНоменклатуры Тогда
				Возврат;
			КонецЕсли;
			ВидНоменклатуры 									= ТекущиеДанные.ВидНоменклатуры; 			
			ТекущийЭлементФормы 								= ЭтаФорма.ТекущийЭлемент;
			Если ТекущийЭлементФормы<>Неопределено И ТекущийЭлементФормы<>Элементы.ВидыНоменклатуры Тогда
				Элементы.ВидыНоменклатуры.ТекущаяСтрока 		= ТекущиеДанные.ВидНоменклатуры;
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВариантНавигацииПриИзмененииНаСервере()
	УдалитьОтборПоИерархииНоменклатуры();
	УдалитьОтборПоВидуНоменклатурыИХарактеристикамВидаНоменклатуры();
	Если ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии Тогда		
		УстановитьОтборПоИерархииНоменклатуры();
		Если ЗначениеЗаполнено(ТекущаяИерархияНоменклатуры) Тогда
			Элементы.ИерархияНоменклатура.ТекущаяСтрока = ТекущаяИерархияНоменклатуры;
		КонецЕсли;
	Иначе		
		ВидНоменклатуры = Справочники.Номенклатура.ПустаяСсылка();
		ВидНоменклатурыПриИзмененииНаСервере();
		Если ЗначениеЗаполнено(ВидНоменклатуры) И (ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоВидам
			ИЛИ ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИХарактеристикам) Тогда
			Элементы.ВидыНоменклатуры.ТекущаяСтрока = ВидНоменклатуры;
		КонецЕсли;
	КонецЕсли;
	УстановитьВидимостьИДоступность();
КонецПроцедуры

&НаСервере
Процедура УдалитьОтборПоВидуНоменклатурыИХарактеристикамВидаНоменклатуры()	
	УдалитьОтборПоВидуНоменклатуры();
	УдалитьОтборПоХарактеристикамВидаНоменклатуры();	
КонецПроцедуры

&НаСервере
Процедура УдалитьОтборПоВидуНоменклатуры()
	Если ВидНоменклатуры = Неопределено Тогда
		ВидНоменклатуры = ПредопределенноеЗначение("Справочник.ВидыНоменклатуры.ПустаяСсылка");			
	КонецЕсли;	
	
	ЭлементыОтбора = ПолучитьОтборДинамическогоСписка(СписокНоменклатура);
	
	// Установить отбор по виду номенклатуры.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементыОтбора,
		"ВидНоменклатуры",
		ВидНоменклатуры,
		ВидСравненияКомпоновкиДанных.Равно, 
		"ОтборПоВидуНоменклатуры",
		Ложь);	
КонецПроцедуры

&НаСервере
Процедура УдалитьОтборПоХарактеристикамВидаНоменклатуры()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокНоменклатура, "Ссылка",,,,Ложь);
	ХарактеристикиОтбор.Очистить();
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоВидуНоменклатуры()	
	
	Если ВидНоменклатуры = Неопределено Тогда
		ВидНоменклатуры = ПредопределенноеЗначение("Справочник.ВидыНоменклатуры.ПустаяСсылка");	
	КонецЕсли;	
	
	ЭлементыОтбора = ПолучитьОтборДинамическогоСписка(СписокНоменклатура);
	
	// Установить отбор по виду номенклатуры.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементыОтбора,
		"ВидНоменклатуры",
		ВидНоменклатуры,
		ВидСравненияКомпоновкиДанных.Равно, 
		"ОтборПоВидуНоменклатуры",
		Истина);
		
КонецПроцедуры

&НаСервере
Функция ПолучитьОтборДинамическогоСписка(Список)
	
	Возврат Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
	
КонецФункции

&НаСервере
Процедура ВидНоменклатурыПриИзмененииНаСервере()	
	Если ВидНоменклатуры = ВидНоменклатурыДоИзменения Тогда
		Возврат;
	КонецЕсли;
	
	ВидНоменклатурыДоИзменения = ВидНоменклатуры;	
	УдалитьОтборПоВидуНоменклатурыИХарактеристикамВидаНоменклатуры();				
	УстановитьОтборПоВидуНоменклатуры();
	Если ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИХарактеристикам 
		ИЛИ ВариантНавигации = Перечисления.ВариантыНавигацииВФормахНоменклатуры.ПоХарактеристикам Тогда
			ЗаполнитьХарактеристикиОтбор();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтборПоИерархииПриИзмененииНаСервере()	
	Если ТекущаяИерархияНоменклатуры = ИерархияНоменклатурыДоИзменения Тогда
		Возврат;
	КонецЕсли;
	ИерархияНоменклатурыДоИзменения = ТекущаяИерархияНоменклатуры;	
	УдалитьОтборПоИерархииНоменклатуры();
	УстановитьОтборПоИерархииНоменклатуры();			
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьХарактеристикиОтбор()	
	Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	Если ХарактеристикиОтбор.Количество()>0 Тогда
		ХарактеристикиОтбор.Очистить();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Характеристики.ВидХарактеристики
		|ИЗ
		|	РегистрСведений.Характеристики КАК Характеристики
		|ГДЕ
		|	Характеристики.Объект = &Объект
		|
		|УПОРЯДОЧИТЬ ПО
		|	Характеристики.ВидХарактеристики.Наименование";
	
	Запрос.УстановитьПараметр("Объект", ВидНоменклатуры);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТЗ = ХарактеристикиОтбор.Добавить();
		СтрокаТЗ.ВидХарактеристики = ВыборкаДетальныеЗаписи.ВидХарактеристики; 
	КонецЦикла;	

КонецПроцедуры 

&НаКлиенте
Процедура ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания()	
	ТекущиеДанные = Элементы.ВидыНоменклатуры.ТекущиеДанные;	
	Если ТекущиеДанные <> Неопределено Тогда	
		ВидНоменклатурыПриИзмененииНаСервере();		
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура НайтиПоХарактеристикамНаСервере()	
	
	НеобходимОтбор = Ложь;
	МассивНоменклатуры = Новый Массив();
	ЭлементыОтбора = ПолучитьОтборДинамическогоСписка(СписокНоменклатура);
	Запрос = Новый Запрос;
	ДопУсловие = "";
	КоличествоУсловий = 0;
	Для Каждого Строки Из ХарактеристикиОтбор Цикл
		Если Строки.Флаг Тогда
			ДопУсловие = ДопУсловие + ?(НЕ ПустаяСтрока(ДопУсловие), "+", "") + "
				| ВЫБОР КОГДА Характеристики.ВидХарактеристики = &В" + Формат(КоличествоУсловий, "ЧРД=; ЧРГ=; ЧН=0; ЧГ=") 
				+ " И Характеристики.Значение = &З" + Формат(КоличествоУсловий, "ЧРД=; ЧРГ=; ЧН=0; ЧГ=") 
				+ " ТОГДА 1 ИНАЧЕ 0 КОНЕЦ";
			Запрос.УстановитьПараметр("В" + Формат(КоличествоУсловий, "ЧРД=; ЧРГ=; ЧН=0; ЧГ="), Строки.ВидХарактеристики);
			Запрос.УстановитьПараметр("З" + Формат(КоличествоУсловий, "ЧРД=; ЧРГ=; ЧН=0; ЧГ="), Строки.Значение);
			КоличествоУсловий = КоличествоУсловий + 1;
		КонецЕсли;	
	КонецЦикла;	
	
	Если КоличествоУсловий > 0 Тогда
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Характеристики.Объект
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Характеристики КАК Характеристики
			|		ПО Номенклатура.Ссылка = Характеристики.Объект
			|ГДЕ
			|	Характеристики.Объект.ВидНоменклатуры = &ВидНоменклатуры
			|
			|СГРУППИРОВАТЬ ПО
			|	Характеристики.Объект
			|
			|ИМЕЮЩИЕ
			|	СУММА(&ДополнительноеУсловие) = &КоличествоУсловий";
		
		Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
		Запрос.УстановитьПараметр("КоличествоУсловий", КоличествоУсловий);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ДополнительноеУсловие", ДопУсловие);
		РезультатЗапроса = Запрос.Выполнить();	
		
		МассивНоменклатуры = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Объект");
		НеобходимОтбор = Истина;
				
	КонецЕсли;		
	
	// Установить отбор.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭлементыОтбора,
		"Ссылка",
		МассивНоменклатуры,
		ВидСравненияКомпоновкиДанных.ВСписке, 
		"ОтборПоНоменклатуре",
		НеобходимОтбор);	
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПоискПоХарактеристикамНаСервере()
	
	ЭлементыОтбора = ПолучитьОтборДинамическогоСписка(СписокНоменклатура);
	МассивНоменклатуры = Новый Массив;
	// Установить отбор по виду номенклатуры.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементыОтбора,
		"Ссылка",
		МассивНоменклатуры,
		ВидСравненияКомпоновкиДанных.ВСписке, 
		"ОтборПоНоменклатуре",
		Ложь);
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТипЗначенияХарактеристики(Знач ВидХарактеристики)
	
	Возврат ВидХарактеристики.ТипЗначения;
	
КонецФункции

&НаКлиенте
Процедура УстановитьОтображениеСпискаНоменклатуры()
	
	Если ИспользоватьФильтры Тогда
		Элементы.СписокНоменклатура.Отображение = ОтображениеТаблицы.Список;
	Иначе
		Элементы.СписокНоменклатура.Отображение = ОтображениеТаблицы.ИерархическийСписок;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеСпискаНоменклатурыНаСервере()
	
	Если ИспользоватьФильтры Тогда
		Элементы.СписокНоменклатура.Отображение = ОтображениеТаблицы.Список;
	Иначе
		Элементы.СписокНоменклатура.Отображение = ОтображениеТаблицы.ИерархическийСписок;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	НастройкиФормы = Новый Структура;
	НастройкиФормы.Вставить("ПоказыватьСкрыватьФильтры",ПоказыватьСкрыватьФильтры);
	НастройкиФормы.Вставить("ИспользоватьФильтры",ИспользоватьФильтры);
	НастройкиФормы.Вставить("ВариантНавигации",ВариантНавигации);
	НастройкиФормы.Вставить("ВидНоменклатуры",ВидНоменклатуры);
	НастройкиФормы.Вставить("ТекущаяИерархияНоменклатуры",ТекущаяИерархияНоменклатуры);	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КодФормы, "", НастройкиФормы);
	
КонецПроцедуры

#КонецОбласти