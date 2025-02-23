﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидимостьПаролей = УправлениеITОтделом8УФПовтИсп.Право("ЧтениеПаролей") 
		ИЛИ УправлениеITОтделом8УФПовтИсп.Право("ПолныеПрава") 
		ИЛИ УправлениеITОтделом8УФПовтИсп.Право("ДобавлениеИзменениеПаролей");
		
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", ТекущийПользователь);
	Список.Параметры.УстановитьЗначениеПараметра("СписокГруппТекущегоПользователя", 
		УправлениеITОтделом8УФ.СписокПодчиненныхИГруппПользователя(ТекущийПользователь));
	
	// Отбор по сотруднику/месту хранения/подразделению/физлицу/контрагенту/контактному лицу/пользователю.
	Если Параметры.Свойство("Объект") Тогда 
		
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Объект", Параметры.Объект, Истина, 
			ВидСравненияКомпоновкиДанных.Равно);		

		// Для создания нового элемента, если форма открыта с отбором по объекту.
		ОбъектЗаписи = Параметры.Объект;
		
	КонецЕсли;
	
	// Насильно снимаем видимость с уволенных, когда открывается из карточки сотрудника.
	ПоказыватьУволенных = Ложь;
	Если Параметры.Свойство("ПоказыватьУволенных") Тогда		
		ПоказыватьУволенных = Параметры.ПоказыватьУволенных;		
	КонецЕсли;	
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьУволенных", ПоказыватьУволенных);
	
	Список.Параметры.УстановитьЗначениеПараметра("Период", ТекущаяДатаСеанса());	
	
	ЗагрузитьНастройкиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	УстановитьПометкиНаКнопках();
	ОбновитьГруппировку();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Сотрудники" 
		ИЛИ ИмяСобытия = "Запись_МестаХранения" Тогда		
		ОбновитьОтображениеДанных();
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда		
		СохранитьНастройкиФормы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура БезГруппировки(Команда)
	
	ГруппировкаСписка = 0;
	УстановитьПометкиНаКнопках();
	ОбновитьГруппировку();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПрограмма(Команда)
	
	ГруппировкаСписка = 1;
	УстановитьПометкиНаКнопках();
	ОбновитьГруппировку();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаВладелец(Команда)
	
	ГруппировкаСписка = 2;
	УстановитьПометкиНаКнопках();
	ОбновитьГруппировку();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПоПрограммеИВладельцу(Команда)
	
	ГруппировкаСписка = 3;
	УстановитьПометкиНаКнопках();
	ОбновитьГруппировку();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПоВладельцуИПрограмме(Команда)
	
	ГруппировкаСписка = 4;
	УстановитьПометкиНаКнопках();
	ОбновитьГруппировку();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПоОрганизации(Команда)
	
	ГруппировкаСписка = 5;
	УстановитьПометкиНаКнопках();
	ОбновитьГруппировку();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПоКатегорииИПрограмме(Команда)
	
	ГруппировкаСписка = 6;
	УстановитьПометкиНаКнопках();
	ОбновитьГруппировку();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПоКатегорииПрограммеВладельцу(Команда)
	
	ГруппировкаСписка = 7;
	УстановитьПометкиНаКнопках();
	ОбновитьГруппировку();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоЛогинам(Команда)
	
	ОткрытьФорму("Отчет.ЛогиныИПароли.ФормаОбъекта",,,);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ЗначениеЗаполнено(ОбъектЗаписи) Тогда
		Если Не Копирование Тогда
			Отказ = Истина;
			ПараметрыФормы = Новый Структура("Объект", ОбъектЗаписи);
			ОткрытьФорму("Справочник.ЛогиныИПароли.ФормаОбъекта", ПараметрыФормы);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьПометкиНаКнопках()
	
	Элементы.ФормаБезГруппировки.Пометка								= Ложь;
	Элементы.ФормаГруппировкаПрограмма.Пометка							= Ложь;	
	Элементы.ФормаГруппировкаВладелец.Пометка							= Ложь;	
	Элементы.ФормаГруппировкаПоПрограммеИВладельцу.Пометка				= Ложь;	
	Элементы.ФормаГруппировкаПоВладельцуИПрограмме.Пометка				= Ложь;	
	Элементы.ФормаГруппировкаПоОрганизации.Пометка						= Ложь;	
	Элементы.ФормаГруппировкаПоКатегорииИПрограмме.Пометка				= Ложь;
	Элементы.ФормаГруппировкаПоКатегорииПрограммеВладельцу.Пометка		= Ложь;
	
	Если ГруппировкаСписка = 0 Тогда
		Элементы.ФормаБезГруппировки.Пометка							= Истина;
	ИначеЕсли ГруппировкаСписка = 1 Тогда
		Элементы.ФормаГруппировкаПрограмма.Пометка						= Истина;		
	ИначеЕсли ГруппировкаСписка = 2 Тогда
		Элементы.ФормаГруппировкаВладелец.Пометка						= Истина;		
	ИначеЕсли ГруппировкаСписка = 3 Тогда
		Элементы.ФормаГруппировкаПоПрограммеИВладельцу.Пометка			= Истина;		
	ИначеЕсли ГруппировкаСписка = 4 Тогда
		Элементы.ФормаГруппировкаПоВладельцуИПрограмме.Пометка			= Истина;
	ИначеЕсли ГруппировкаСписка = 5 Тогда
		Элементы.ФормаГруппировкаПоОрганизации.Пометка					= Истина;
	ИначеЕсли ГруппировкаСписка = 6 Тогда
		Элементы.ФормаГруппировкаПоКатегорииИПрограмме.Пометка			= Истина;
	ИначеЕсли ГруппировкаСписка = 7 Тогда
		Элементы.ФормаГруппировкаПоКатегорииПрограммеВладельцу.Пометка	= Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппировку()
	
	Список.Группировка.Элементы.Очистить();
	Если ГруппировкаСписка = 1 Тогда
		УстановитьГруппировку("Программа");
	ИначеЕсли ГруппировкаСписка = 2 Тогда
		УстановитьГруппировку("Объект");
	ИначеЕсли ГруппировкаСписка = 3 Тогда
		УстановитьГруппировку("Программа");
		УстановитьГруппировку("Объект");
	ИначеЕсли ГруппировкаСписка = 4 Тогда
		УстановитьГруппировку("Объект");
		УстановитьГруппировку("Программа");
	ИначеЕсли ГруппировкаСписка = 5 Тогда
		УстановитьГруппировку("Объект.Организация");
	ИначеЕсли ГруппировкаСписка = 6 Тогда
		УстановитьГруппировку("Категория");
        УстановитьГруппировку("Программа");
	ИначеЕсли ГруппировкаСписка = 7 Тогда
		УстановитьГруппировку("Категория");
        УстановитьГруппировку("Программа");
        УстановитьГруппировку("Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьГруппировку(Знач ИмяПоля)
	
	ЭлементГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ЭлементГруппировки.Поле				= Новый ПолеКомпоновкиДанных(ИмяПоля);
	ЭлементГруппировки.Использование	= Истина;
	    
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	НастройкиФормы	= Новый Структура;
	НастройкиФормы.Вставить("ГруппировкаСписка", ГруппировкаСписка);
	ИмяКлючаОбъекта	= СтрЗаменить(ЭтотОбъект.ИмяФормы, ".", "");
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяКлючаОбъекта, "", НастройкиФормы);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиФормы()
	
	ИмяКлючаОбъекта	= СтрЗаменить(ЭтотОбъект.ИмяФормы, ".", "");
	НастройкиФормы	= ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяКлючаОбъекта,  "");
	Если НастройкиФормы <> Неопределено Тогда
		Если НастройкиФормы.Свойство("ГруппировкаСписка") Тогда
			ГруппировкаСписка = НастройкиФормы.ГруппировкаСписка;
		КонецЕсли;		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти