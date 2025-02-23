﻿
#Область ОписаниеПеременных

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Перем ИдентификаторЗамераПроведение;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СЛС.ПриСозданииНаСервере(Объект, Отказ, СтандартнаяОбработка, Параметры, ЭтаФорма);	
		
	Если Объект.Ссылка.Пустая() Тогда
		
		// Если открыта из другой
	    ОткрываетсяИзВне = Ложь;
	    Если Параметры.Свойство("ОткрываетсяИзВне") Тогда
	        ОткрываетсяИзВне = Параметры.ОткрываетсяИзВне;
			Если ОткрываетсяИзВне Тогда
				Попытка
					Структура = ПолучитьИзВременногоХранилища(Параметры["Объект"]);
		        	ЗначениеВРеквизитФормы(Структура.Документ, "Объект");
	            	Модифицированность = Истина;
					УдалитьИзВременногоХранилища(Параметры["Объект"]);
				Исключение
				КонецПопытки;	
		    КонецЕсли;
		КонецЕсли;
		
		// Документ создается из обработки "РабочийСтол".
		Если Параметры.Свойство("РабочийСтолЗначенияЗаполнения") Тогда
			ЗаполнитьЗначенияСвойств(Объект, Параметры.РабочийСтолЗначенияЗаполнения);
		КонецЕсли;
		
	КонецЕсли;
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	#Область БСП_ПриСозданииНаСервере
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	
	// ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ВерсионированиеОбъектов	
	
	#КонецОбласти
	
	ТекущийЭлемент = Элементы.Сотрудники;
	
	// Учет остатков контрагентов.
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("Организация");
	УправлениеITОтделом8УФ.УстановитьОграничениеТипаДляЭлементовФормы(ЭтаФорма, МассивЭлементов);
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	 // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Корректировки документа
	УправлениеITОтделом8УФКлиент.ОбновитьНадписьАвтор(Объект, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
       ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.ЗамерВремени();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МассивМестХранения = Новый Массив;
	Для Каждого Строки Из Объект.Сотрудники Цикл
		МассивМестХранения.Добавить(Строки.МестоХранения);
	КонецЦикла;
	Оповестить("Запись_ЗакреплениеСотрудников",
		Новый Структура("МассивМестХранения", МассивМестХранения), Объект.Ссылка);
		
	// Корректировки документа
	УправлениеITОтделом8УФКлиент.ОбновитьНадписьАвтор(Объект, ЭтаФорма);
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
        ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведение, 
			"ДокументЗакреплениеСотрудников (проведение)");	
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СЛС.ПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
    УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры // ПриЧтенииНаСервере()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ДатаСоздания = Дата(1, 1, 1) Тогда
		ТекущийОбъект.ДатаСоздания = ТекущаяДатаСеанса();
	Иначе
		ТекущийОбъект.ДатаКорректировки = ТекущаяДатаСеанса();
	КонецЕсли; 
	
	Если ТекущийОбъект.Автор = Справочники.Пользователи.ПустаяСсылка() Тогда
		ТекущийОбъект.Автор = Пользователи.ТекущийПользователь();
	Иначе
		ТекущийОбъект.АвторКорректировки = Пользователи.ТекущийПользователь();
	КонецЕсли; 
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	СЛС.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма);
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ИсточникВыбора) = Тип("УправляемаяФорма") 
		И ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ФормаВыбораОрганизацииКонтрагента"
		И ИсточникВыбора.ВладелецФормы = ЭтаФорма Тогда
		УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОбработкаВыбораФормы(ЭтаФорма, 
		 				"Организация",
						Объект.Организация,
						ВыбранноеЗначение,
						Новый ОписаниеОповещения("ПослеОбработкиВыбора", ЭтотОбъект));	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьАвторНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("НадписьАвторНажатиеЗавершение", ЭтотОбъект), 
		УправлениеITОтделом8УФКлиент.ПолучитьСписокНадписьАвтор(Объект), Элементы.НадписьАвтор,);
		
КонецПроцедуры

&НаКлиенте
Процедура НадписьАвторНажатиеЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт    

КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Номер = "";
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиМестоХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеВыбора 			= Элементы.Сотрудники.ТекущиеДанные.МестоХранения;
	СтандартнаяОбработка 	= Ложь;
	Структура 				= Новый Структура();
	Структура.Вставить("Ключ", 				ДанныеВыбора);
	Структура.Вставить("РежимВыбора", 		Истина);
	Структура.Вставить("ВыбранноеЗначение", ДанныеВыбора);
	ОткрытьФорму("Справочник.МестаХранения.ФормаВыбора", Структура, Элемент, Новый УникальныйИдентификатор());	
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СотрудникиСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Организации") Тогда 
		МассивСотрудник	= Новый Массив();
		МассивСотрудник.Добавить(Тип("СправочникСсылка.Сотрудники"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивСотрудник, , );
		Элементы.СотрудникиСотрудник.ОграничениеТипа = ДопустимыеТипы;
	ИначеЕсли ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Контрагенты") Тогда 
		СтандартнаяОбработка = Ложь;
		МассивСотрудник	= Новый Массив();
		МассивСотрудник.Добавить(Тип("СправочникСсылка.КонтактныеЛица"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивСотрудник, , );
		Элементы.СотрудникиСотрудник.ОграничениеТипа = ДопустимыеТипы;
		ОткрытьФормуВыбораКонтактныеЛица("Сотрудник");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область БСП

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
    УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

// Процедура устанавливает видимость элементов формы.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьВидимостьИДоступность()
	
	Если ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Организации") Тогда 
		Элементы.СотрудникиСотрудник.Заголовок = НСтр("ru = 'Сотрудник'");
	ИначеЕсли ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Контрагенты") Тогда 
		Элементы.СотрудникиСотрудник.Заголовок = НСтр("ru = 'Контактное лицо'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораКонтактныеЛица(Знач ПолеРаботы)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетОстатков", Истина);
	ПараметрыФормы.Вставить("ОтборКонтрагент", Объект.Организация);
		
	ПараметрыПоля = Новый Структура;
	ПараметрыПоля.Вставить("ИмяПоля", ПолеРаботы);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораСотрудники", ЭтотОбъект, ПараметрыПоля); 
	ОткрытьФорму("Справочник.КонтактныеЛица.ФормаВыбора",ПараметрыФормы,ЭтотОбъект, , , ,
													ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);   
	
КонецПроцедуры
												
&НаКлиенте
Процедура ПослеВыбораСотрудники(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		 ТекущиеДанные[ДополнительныеПараметры.ИмяПоля] = Результат;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("РазностьДат", УправлениеITОтделом8УФ.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

#Область УчетОстатковКонтрагентов

&НаКлиенте
Процедура Подключаемый_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
			
	УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикНачалоВыбора(ЭтаФорма, Объект.Организация, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
		
	УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикАвтоПодбор(ЭтаФорма, 
				"Организация",
				Текст, 
				ДанныеВыбора,
				Ожидание,
				СтандартнаяОбработка);
				
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Очистка(Элемент, СтандартнаяОбработка)	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)	
		
	УправлениеITОтделом8УФКлиент.ВыполнитьОбработчикОбработкаВыбора(ЭтаФорма, 
				"Организация", 
				Объект.Организация,
				Новый ОписаниеОповещения("ПослеОбработкиВыбора", ЭтотОбъект),
				ВыбранноеЗначение,
				СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбработкиВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	ОрганизацияПриИзменении(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

