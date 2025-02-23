﻿
#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Процедура обработчик события ПриСозданииНаСервере.
// Осуществляет первоначальное заполнение реквизитов формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Установка значения реквизита АдресКартинки.
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбновитьИзображение();
	КонецЕсли;	
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	// СтандартныеПодсистемы.КонтактнаяИнформация	
	ДополнительныеПараметры = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформации();
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, Объект.Наименование);	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	ЗаданияСервер.УстановитьШагКорректировкиВеса(ШагКорректировкиВеса);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
// Процедура обработчик события ПриЧтенииНаСервере
//
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	ОбновитьИзображение();
	
КонецПроцедуры // ПриЧтенииНаСервере()

&НаКлиенте
// Процедура обработчик события ОбработкаОповещения.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Свойство("ВладелецФайла") Тогда
		
		Если Параметр.ВладелецФайла = Объект.Ссылка Тогда
			Модифицированность = Истина;
			
			СсылкаНаФайл = "";
			Если ТипЗнч(Источник) = Тип("Массив") Тогда
				Если Источник.Количество()>0 Тогда
					СсылкаНаФайл = Источник[0];
				КонецЕсли;
			Иначе
				СсылкаНаФайл = Источник;
			КонецЕсли;
			
			Если ВыборИзображения Тогда
				Объект.ФайлКартинки = СсылкаНаФайл;
				АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, ЭтотОбъект.УникальныйИдентификатор);
				#Если ВебКлиент Тогда
				ВыборИзображения = Ложь;
				#КонецЕсли
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры // ОбработкаОповещения()

&НаСервере
// Процедура обработчик события ПриСозданииНаСервере.
// Осуществляет первоначальное заполнение реквизитов формы.
//
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры // ПередЗаписьюНаСервере()

&НаСервере
// Процедура обработчик события ОбработкаПроверкиЗаполненияНаСервере.
//
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры // ОбработкаПроверкиЗаполненияНаСервере()

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ВзаимодействияКлиент.КонтактПослеЗаписи(ЭтаФорма,Объект,ПараметрыЗаписи,"ФизическиеЛица");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
			
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ЗаполнитьПараметрыСклонения(ЭтотОбъект, ПараметрыСклонения);
	СклонениеПредставленийОбъектов.ПриЗаписиФормыОбъектаСклонения(ЭтотОбъект, 
		Объект.Наименование, ТекущийОбъект.Ссылка, ПараметрыСклонения);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ОбновитьИзображение()
	
	АдресКартинки = "";
	Если НЕ Объект.ФайлКартинки.Пустая() Тогда
		Попытка
			АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, ЭтотОбъект.УникальныйИдентификатор);
		Исключение
			СтрокаОшибки = ОписаниеОшибки();
			ОбщегоНазначения.СообщитьПользователю(СтрокаОшибки);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Если ШагКорректировкиВеса > 1 Тогда		
		
		СтандартнаяОбработка = Ложь;
		Если Направление = 1 Тогда
			Объект.Вес = Объект.Вес + ШагКорректировкиВеса;
		Иначе
			Объект.Вес = Объект.Вес - ШагКорректировкиВеса;
		КонецЕсли;	
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ЗаполнитьПараметрыСклонения(ЭтотОбъект, ПараметрыСклонения);
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление(ЭтотОбъект, Объект.Наименование, ПараметрыСклонения);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

КонецПроцедуры

&НаКлиенте
Процедура АдресКартинкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Склонения(Команда)
	
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ЗаполнитьПараметрыСклонения(ЭтотОбъект, ПараметрыСклонения);
	СклонениеПредставленийОбъектовКлиент.ПоказатьСклонение(ЭтотОбъект, Объект.Наименование, ПараметрыСклонения);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображение(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросДобавитьИзображение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	Иначе
		ДобавитьИзображениеДействиеПослеДобавления();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображение(Команда)
	
	Объект.ФайлКартинки = ПредопределенноеЗначение("Справочник.НоменклатураПрисоединенныеФайлы.ПустаяСсылка");
	АдресКартинки = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьИзображение(Команда)
	
	ПросмотретьПрисоединенныйФайл();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображение(Команда)
	
	ОчиститьСообщения();
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		РаботаСФайламиКлиент.ОткрытьФормуФайла(Объект.ФайлКартинки);
	Иначе
		ТекстСообщения = НСтр("ru='Отсутствует изображение для редактирования'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзображениеИзПрисоединенныхФайлов(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросДобавитьИзображение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	Иначе
		СтруктураПараметрыВыбора =
			Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе, РежимВыбора", Объект.Ссылка, Истина, Истина);
		ОткрытьФорму(
			"Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы",
			СтруктураПараметрыВыбора,,,,,
			Новый ОписаниеОповещения("ВыбратьКартинкуИзПрисоединенныхФайловЗавершение", ЭтотОбъект),
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайловЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат) Тогда
		Объект.ФайлКартинки = Результат;
		АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, ЭтотОбъект.УникальныйИдентификатор)
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства
//@skip-warning
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, 
	СтандартнаяОбработка = Неопределено)
	
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.КонтактнаяИнформация
//@skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)	
	УправлениеКонтактнойИнформациейКлиент.НачатьИзменение(ЭтотОбъект, Элемент);	
КонецПроцедуры
	
//@skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.НачатьВыбор(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.НачатьВыбор(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.НачатьОчистку(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
    УправлениеКонтактнойИнформациейКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных,
		Ожидание, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, 
		Ожидание, СтандартнаяОбработка);
КонецПроцедуры
	
//@skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, 
		СтандартнаяОбработка);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаНавигационнойСсылки(Элемент,
	НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.НачатьОбработкуНавигационнойСсылки(ЭтотОбъект, Элемент, 
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьОбновлениеКонтактнойИнформации(Результат, ДополнительныеПараметры) Экспорт
    ОбновитьКонтактнуюИнформацию(Результат);
КонецПроцедуры

&НаСервере
Процедура ОбновитьКонтактнуюИнформацию(Результат)
    УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПараметрыСклонения(Форма, ПараметрыСклонения)
	
	ПараметрыСклонения.ЭтоФИО = Истина;
	ПараметрыСклонения.Пол = Неопределено;
	
	Если ЗначениеЗаполнено(Форма.Объект.Пол) Тогда
		ПараметрыСклонения.Пол = 1;
		Если Форма.Объект.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Женский") Тогда
			ПараметрыСклонения.Пол = 2;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеДействиеПослеДобавления()

	ВыборИзображения = Истина;
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла, 
		УправлениеITОтделом8УФКлиентСервер.ПолучитьФильтрИзображений());
	#Если Не ВебКлиент Тогда
	ВыборИзображения = Ложь;
	#КонецЕсли

КонецПроцедуры // ВыполнитьДобавлениеИзображения()

&НаСервереБезКонтекста
Функция НавигационнаяСсылкаКартинки(ФайлКартинки, ИдентификаторФормы)
	
	УстановитьПривилегированныйРежим(Истина);
	СсылкаНаДвоичныеДанныеФайла = РаботаСФайлами.ДанныеФайла(ФайлКартинки, 
		ИдентификаторФормы).СсылкаНаДвоичныеДанныеФайла;
	УстановитьПривилегированныйРежим(Ложь);	
	Возврат СсылкаНаДвоичныеДанныеФайла;
	
КонецФункции

&НаКлиенте
Процедура ПросмотретьПрисоединенныйФайл()
	
	ОчиститьСообщения();
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		ДанныеФайла = РаботаСФайламиКлиент.ДанныеФайла(Объект.ФайлКартинки, УникальныйИдентификатор);
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	Иначе
		ТекстСообщения = НСтр("ru='Отсутствует изображение для просмотра'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиенте()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросДобавитьИзображение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		ПросмотретьПрисоединенныйФайл();
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ДобавитьИзображениеДействиеПослеДобавления();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросДобавитьИзображение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Записать() Тогда
			ДобавитьИзображениеДействиеПослеДобавления();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
