﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("КонтекстноеОткрытие", КонтекстноеОткрытие);
	
	Если НЕ КонтекстноеОткрытие Тогда
		РаботаСОтборамиВызовСервера.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	КонецЕсли;	
	
	#Область БСП_ПриСозданииНаСервере
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	#КонецОбласти
	
	// Учет остатков контрагентов.
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ОтборОрганизацияРасхода");
	МассивЭлементов.Добавить("ОтборОрганизацияПрихода");
	УправлениеITОтделом8УФ.УстановитьОграничениеТипаДляЭлементовФормы(ЭтаФорма, МассивЭлементов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ИсточникВыбора) = Тип("УправляемаяФорма") 
		И ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ФормаВыбораОрганизацииКонтрагента"
		И ИсточникВыбора.ВладелецФормы = ЭтаФорма Тогда
		Если ВыбранноеЗначение.ИмяРеквизитаВозврата = "ОтборОрганизацияРасхода" Тогда
			УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОбработкаВыбораФормы(ЭтаФорма, 
		 					"ОтборОрганизацияРасхода",
							ОтборОрганизацияРасхода,
							ВыбранноеЗначение.Ссылка,
							Новый ОписаниеОповещения("ПослеОбработкиВыбора", ЭтотОбъект, Новый Структура("ИмяРеквизитаВозврата", "ОтборОрганизацияРасхода")));
		ИначеЕсли ВыбранноеЗначение.ИмяРеквизитаВозврата = "ОтборОрганизацияПрихода"	Тогда
			УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОбработкаВыбораФормы(ЭтаФорма, 
		 					"ОтборОрганизацияПрихода",
							ОтборОрганизацияПрихода,
							ВыбранноеЗначение.Ссылка,
							Новый ОписаниеОповещения("ПослеОбработкиВыбора", ЭтотОбъект, Новый Структура("ИмяРеквизитаВозврата", "ОтборОрганизацияПрихода")));				
		КонецЕсли;					
							
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ КонтекстноеОткрытие И НЕ ЗавершениеРаботы Тогда
		
		СохранитьНастройкиОтборов();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Перемещение_ФормаСписка_УстановленОтборПериод" Тогда	
		
		Если НЕ КонтекстноеОткрытие Тогда			
			СохранитьНастройкиОтборов();	
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияРасходаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка	= Ложь;
	УстановитьОтборСписка("ОрганизацияРасхода", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение		= Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМестоХраненияРасходаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка	= Ложь;
	УстановитьОтборСписка("МестоХраненияРасхода", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение		= Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриходаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка	= Ложь;
	УстановитьОтборСписка("ОрганизацияПрихода", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение		= Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМестоХраненияПриходаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка	= Ложь;
	УстановитьОтборСписка("МестоХраненияПрихода", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение		= Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка	= Ложь;
	УстановитьОтборСписка("Автор", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение		= Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	КлючеваяОперация = "ДокументПеремещение (открытие)";
	ОценкаПроизводительностиКлиент.ЗамерВремени(КлючеваяОперация);
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПанельОтборов

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДопПараметры 		= Новый Структура;	
	ДопПараметры.Вставить("ОписаниеОповещенияОВыбореПериода", 
		"Перемещение_ФормаСписка_УстановленОтборПериод"); 
	
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьПанельОтборов(Команда)	
	
	НовоеЗначениеВидимости = НЕ Элементы.ПанельОтборов.Видимость;
	РаботаСОтборамиКлиент.ПоказатьСкрытьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимости);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборамиВызовСервера.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписка(ИмяПоляОтбора, ИмяГруппыРодителя, ЗначениеОтбора)
		
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ИмяПоляОтбора",				ИмяПоляОтбора);
	ДопПараметры.Вставить("ИмяГруппыРодителя",			ИмяГруппыРодителя);
	ДопПараметры.Вставить("ЗначениеОтбора",				ЗначениеОтбора);
	ДопПараметры.Вставить("ПредставлениеЗначенияОтбора",Строка(ЗначениеОтбора));
	
	РаботаСОтборамиВызовСервера.СоздатьЭлементФормыПоЗначениюОтбора(ЭтотОбъект, ДопПараметры);		
	РаботаСОтборамиВызовСервера.УстановитьОтборСписка(ЭтотОбъект, Список, 
		Новый Структура("ИмяПоляОтбора", ИмяПоляОтбора));
		
	Если НЕ КонтекстноеОткрытие Тогда			
		СохранитьНастройкиОтборов();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтборОбработкаНавигационнойСсылки(Элемент, 
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОтборИД = Сред(Элемент.Имя, СтрДлина("Отбор_")+1);
	УдалитьЭлементОтбор(ОтборИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементОтбор(ОтборИД)
	
	РаботаСОтборамиВызовСервера.УдалитьОтборСписка(ЭтотОбъект, Список, Новый Структура("ОтборИД", ОтборИД));
	
	Если НЕ КонтекстноеОткрытие Тогда			
		СохранитьНастройкиОтборов();	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СброситьВсеОтборы(Команда)
			
	УдалитьОтборы();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьОтборы()
	
	РаботаСОтборамиВызовСервера.УдалитьВсеОтборыСписка(ЭтотОбъект, Список);	
	ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(ОтборПериод);
	
	Если НЕ КонтекстноеОткрытие Тогда			
		СохранитьНастройкиОтборов();	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область БСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область УчетОстатковКонтрагентов

&НаКлиенте
Процедура Подключаемый_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
			
	Если Элемент.Имя = "ОтборОрганизацияРасхода" Тогда
		УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикНачалоВыбора(ЭтаФорма, ОтборОрганизацияРасхода, СтандартнаяОбработка, "ОтборОрганизацияРасхода");
	ИначеЕсли Элемент.Имя = "ОтборОрганизацияПрихода" Тогда
		УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикНачалоВыбора(ЭтаФорма, ОтборОрганизацияПрихода, СтандартнаяОбработка, "ОтборОрганизацияПрихода");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Очистка(Элемент, СтандартнаяОбработка)
	
	Если Элемент.Имя = "ОтборОрганизацияРасхода" Тогда	
		УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОчистка(ЭтаФорма, "ОтборОрганизацияРасхода");
	ИначеЕсли Элемент.Имя = "ОтборОрганизацияПрихода" Тогда
		УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОчистка(ЭтаФорма, "ОтборОрганизацияПрихода");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикАвтоПодбор(ЭтаФорма, 
				Элемент.Имя,
				Текст, 
				ДанныеВыбора,
				Ожидание,
				СтандартнаяОбработка);	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)	
		
	Если Элемент.Имя = "ОтборОрганизацияРасхода" Тогда
		УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОбработкаВыбора(ЭтаФорма, 
					"ОтборОрганизацияРасхода", 
					ОтборОрганизацияРасхода,
					Новый ОписаниеОповещения("ПослеОбработкиВыбора", ЭтотОбъект, Новый Структура("ИмяРеквизитаВозврата", "ОтборОрганизацияРасхода")),
					ВыбранноеЗначение,
					СтандартнаяОбработка);
	ИначеЕсли Элемент.Имя = "ОтборОрганизацияПрихода" Тогда
		 УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОбработкаВыбора(ЭтаФорма, 
					"ОтборОрганизацияПрихода", 
					ОтборОрганизацияПрихода,
					Новый ОписаниеОповещения("ПослеОбработкиВыбора", ЭтотОбъект, Новый Структура("ИмяРеквизитаВозврата", "ОтборОрганизацияПрихода")),
					ВыбранноеЗначение,
					СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбработкиВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ИмяРеквизитаВозврата = "ОтборОрганизацияРасхода" Тогда	
		
		Если ЗначениеЗаполнено(ОтборОрганизацияРасхода) Тогда
			УстановитьОтборСписка("ОрганизацияРасхода", "ГруппаОтборОрганизацияРасхода", ОтборОрганизацияРасхода);
			ОтборОрганизацияРасхода = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"); 
		КонецЕсли;
		
	ИначеЕсли ДополнительныеПараметры.ИмяРеквизитаВозврата = "ОтборОрганизацияПрихода" Тогда
		
		Если ЗначениеЗаполнено(ОтборОрганизацияПрихода) Тогда
			УстановитьОтборСписка("ОрганизацияПрихода", "ГруппаОтборОрганизацияПрихода", ОтборОрганизацияПрихода);
			ОтборОрганизацияПрихода = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"); 
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

