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
	
	СЛС.ПриСозданииНаСервере(Объект, Отказ, СтандартнаяОбработка, Параметры, ЭтаФорма);	
		
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		// Документ создается из обработки "РабочийСтол".
		Если Параметры.Свойство("РабочийСтолЗначенияЗаполнения") Тогда
			ЗаполнитьЗначенияСвойств(Объект, Параметры.РабочийСтолЗначенияЗаполнения);
		КонецЕсли;

	КонецЕсли; 
	
	#Область БСП_ПриСозданииНаСервере
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ВерсионированиеОбъектов	
	#КонецОбласти
	
	// Учет остатков контрагентов.
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("Организация");
	УправлениеITОтделом8УФ.УстановитьОграничениеТипаДляЭлементовФормы(ЭтаФорма, МассивЭлементов);
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры // ПриСозданииНаСервере()

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

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СЛС.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма);	
	
КонецПроцедуры

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
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
        ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведение, 
			"ДокументПраваДоступаКИнформационнымРесурсам (проведение)");	
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Организация.
// В процедуре осуществляется очистка номера документа,
// а также производится установка параметров функциональных опций формы.
// Переопределяет соответствующий параметр формы.
Процедура ОрганизацияПриИзменении(Элемент)

	// Обработка события изменения организации.
	Объект.Номер = "";
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры // ОрганизацияПриИзменении()

&НаКлиенте
Процедура ИнициаторПредоставленияДоступаПриИзменении(Элемент)
	
	ИнициаторПредоставленияДоступаПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДоступ

&НаКлиенте
Процедура ДоступПриАктивизацииСтроки(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Доступ.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Отбор = Новый ФиксированнаяСтруктура("Ключ", СтрокаТабличнойЧасти.Ключ);
	Элементы.Права.ОтборСтрок = Отбор;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока ИЛИ Копирование Тогда
		
		СтрокаТабличнойЧасти = Элементы.Доступ.ТекущиеДанные;
		СтрокаТабличнойЧасти.Ключ = ПолучитьНовыйКлюч();
				
		Отбор = Новый ФиксированнаяСтруктура("Ключ", СтрокаТабличнойЧасти.Ключ);
		Элементы.Права.ОтборСтрок = Отбор;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступПередУдалением(Элемент, Отказ)
	
	СтрокаТабличнойЧасти = Элементы.Доступ.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьСтрокиПоКлючу(СтрокаТабличнойЧасти.Ключ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступВидДоступаПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Доступ.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьСтрокиПоКлючу(СтрокаТабличнойЧасти.Ключ);
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ВидДоступа) Тогда
		Результат = ЗаполнитьПраваДляВидаДоступа(СтрокаТабличнойЧасти.ВидДоступа, СтрокаТабличнойЧасти.Ключ);
		Если Не Результат Тогда			
			ОбщегоНазначенияКлиент.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Для вида доступа <%1>  не заданы права доступа. Измените этот вид доступа.'"), Строка(СтрокаТабличнойЧасти.ВидДоступа)));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	Если ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Организации") Тогда 
		МассивСотрудник	= Новый Массив();
		МассивСотрудник.Добавить(Тип("СправочникСсылка.Сотрудники"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивСотрудник, , );
		Элементы.Сотрудник.ОграничениеТипа = ДопустимыеТипы;
	ИначеЕсли ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Контрагенты") Тогда 
		СтандартнаяОбработка = Ложь;
		МассивСотрудник	= Новый Массив();
		МассивСотрудник.Добавить(Тип("СправочникСсылка.КонтактныеЛица"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивСотрудник, , );
		Элементы.Сотрудник.ОграничениеТипа = ДопустимыеТипы;
		ОткрытьФормуВыбораКонтактныеЛица("Сотрудник");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступСотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Доступ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Организации") Тогда 
		МассивСотрудник	= Новый Массив();
		МассивСотрудник.Добавить(Тип("СправочникСсылка.Сотрудники"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивСотрудник, , );
		Элементы.ДоступСотрудник.ОграничениеТипа = ДопустимыеТипы;
	ИначеЕсли ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Контрагенты") Тогда 
		СтандартнаяОбработка = Ложь;
		МассивСотрудник	= Новый Массив();
		МассивСотрудник.Добавить(Тип("СправочникСсылка.КонтактныеЛица"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивСотрудник, , );
		Элементы.ДоступСотрудник.ОграничениеТипа = ДопустимыеТипы;
		ОткрытьФормуВыбораКонтактныеЛица("ДоступСотрудник");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициаторПредоставленияДоступаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Организации") Тогда 
		МассивСотрудник	= Новый Массив();
		МассивСотрудник.Добавить(Тип("СправочникСсылка.Сотрудники"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивСотрудник, , );
		Элементы.ИнициаторПредоставленияДоступа.ОграничениеТипа = ДопустимыеТипы;
	ИначеЕсли ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Контрагенты") Тогда 
		СтандартнаяОбработка = Ложь;
		МассивСотрудник	= Новый Массив();
		МассивСотрудник.Добавить(Тип("СправочникСсылка.КонтактныеЛица"));
		ДопустимыеТипы = Новый ОписаниеТипов(МассивСотрудник, , );
		Элементы.ИнициаторПредоставленияДоступа.ОграничениеТипа = ДопустимыеТипы;
		ОткрытьФормуВыбораКонтактныеЛица("ИнициаторПредоставленияДоступа");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаДокумента(Команда)
	// 1. Формируем структуру параметров для заполнения формы "Настройка документа".
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПоложениеСотрудника", 	Объект.ПоложениеСотрудника);
	СтруктураПараметров.Вставить("БылиВнесеныИзменения", 	Ложь);
	
	СтруктураНастройкаДокумента = Неопределено;
	// 2. Открываем форму "Цены и Валюта".
	ОткрытьФорму("ОбщаяФорма.НастройкаДокумента", СтруктураПараметров,,,,, Новый ОписаниеОповещения("НастройкаДокументаЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
        
    СтруктураНастройкаДокумента = Результат;
    
    // 3. Применяем изменения, сделанные в форме "Настройка документа".
    Если ТипЗнч(СтруктураНастройкаДокумента) = Тип("Структура") И СтруктураНастройкаДокумента.БылиВнесеныИзменения Тогда		
        Объект.ПоложениеСотрудника = СтруктураНастройкаДокумента.ПоложениеСотрудника;
        
        УстановитьВидимостьДоступность();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НадписьАвторНажатие(Элемент, СтандартнаяОбработка)	
	СтандартнаяОбработка = Ложь;
	Спк = УправлениеITОтделом8УФКлиент.ПолучитьСписокНадписьАвтор(Объект);	
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("НадписьАвторНажатиеЗавершение", ЭтотОбъект), Спк, Элементы.НадписьАвтор, );
КонецПроцедуры

&НаКлиенте
Процедура НадписьАвторНажатиеЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область БСП

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

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

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
    УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если (Объект.ПоложениеСотрудника = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке) ИЛИ (НЕ ЗначениеЗаполнено(Объект.ПоложениеСотрудника)) Тогда
		Элементы.Сотрудник.Видимость = Истина;
		Элементы.ДоступСотрудник.Видимость = Ложь;	
	Иначе
		Элементы.Сотрудник.Видимость = Ложь;
		Элементы.ДоступСотрудник.Видимость = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Организации") Тогда 
		Элементы.Сотрудник.Заголовок		= НСтр("ru = 'Сотрудник'");
		Элементы.ДоступСотрудник.Заголовок	= НСтр("ru = 'Сотрудник'");
	ИначеЕсли ТипЗнч(Объект.Организация) = Тип("СправочникСсылка.Контрагенты") Тогда 
		Элементы.Сотрудник.Заголовок		= НСтр("ru = 'Контактное лицо'");
		Элементы.ДоступСотрудник.Заголовок	= НСтр("ru = 'Контактное лицо'");
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
	
	Если Не ПустаяСтрока(ДополнительныеПараметры.ИмяПоля) И ДополнительныеПараметры.ИмяПоля = "Сотрудник" Тогда 
		Объект.Сотрудник = Результат;
	ИначеЕсли Не ПустаяСтрока(ДополнительныеПараметры.ИмяПоля) 
				И ДополнительныеПараметры.ИмяПоля = "ДоступСотрудник" Тогда 
		ТекущиеДанные = Элементы.Доступ.ТекущиеДанные;
		ИмяПоля = "Сотрудник";
		ТекущиеДанные.Сотрудник = Результат;
	ИначеЕсли Не ПустаяСтрока(ДополнительныеПараметры.ИмяПоля) 
				И ДополнительныеПараметры.ИмяПоля = "ИнициаторПредоставленияДоступа" Тогда
		Объект.ИнициаторПредоставленияДоступа = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНовыйКлюч()

	СписокЗначений = Новый СписокЗначений;	
	Для каждого СтрокаТЧ Из Объект.Доступ Цикл
        СписокЗначений.Добавить(СтрокаТЧ.Ключ);
	КонецЦикла;

    Если СписокЗначений.Количество() = 0 Тогда
		Возврат 0;
	Иначе
		СписокЗначений.СортироватьПоЗначению();
		Возврат СписокЗначений.Получить(СписокЗначений.Количество() - 1).Значение + 1;
	КонецЕсли;

КонецФункции

&НаСервере
Функция ЗаполнитьПраваДляВидаДоступа(ВидДоступа, Ключ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыДоступаКИнформационнымРесурсамДоступныеПрава.ПраваДоступа,
		|	&Ключ,
		|	ИСТИНА КАК Разрешено
		|ИЗ
		|	Справочник.ВидыДоступаКИнформационнымРесурсам.ДоступныеПрава КАК ВидыДоступаКИнформационнымРесурсамДоступныеПрава
		|ГДЕ
		|	ВидыДоступаКИнформационнымРесурсамДоступныеПрава.Ссылка = &Ссылка
		|АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("Ссылка", ВидДоступа);
	Запрос.УстановитьПараметр("Ключ", Ключ);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	Иначе		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл			
			ЗаполнитьЗначенияСвойств(Объект.Права.Добавить(), Выборка);			
		КонецЦикла;		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура УдалитьСтрокиПоКлючу(Ключ)
	
    НайденныеСтроки = Объект.Права.НайтиСтроки(Новый Структура("Ключ", Ключ));
	Для каждого Строки Из НайденныеСтроки Цикл
		Объект.Права.Удалить(Строки);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициаторПредоставленияДоступаПриИзмененииНаСервере()
	
	Если Объект.ПоложениеСотрудника = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		
		Объект.Подразделение = ?(ЗначениеЗаполнено(Объект.ИнициаторПредоставленияДоступа), Объект.ИнициаторПредоставленияДоступа.Подразделение, Справочники.Подразделения.ПустаяСсылка());
		
	Иначе
		
		Объект.Подразделение = ?(ЗначениеЗаполнено(Объект.Сотрудник), Объект.Сотрудник.Подразделение, Справочники.Подразделения.ПустаяСсылка());
		
	КонецЕсли;
	
КонецПроцедуры

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
