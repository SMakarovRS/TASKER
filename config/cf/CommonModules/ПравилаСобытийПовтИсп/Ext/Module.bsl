﻿
#Область ПрограммныйИнтерфейс

// Возвращает макет для установки условия правил событий.
//
// Параметры:
//	ОписаниеОбъектаМетаданных - Строка, Метаданные - объект метаданных.
//	ИмяМакетаШаблона - Строка - имя макета
//
// Возвращаемое значение:
//	Макет.
//
Функция ПолучитьМакетПравилОтбораСобытий(Знач ОписаниеОбъектаМетаданных, Знач ИмяМакетаШаблона) Экспорт
	
	ТипОписанияОбъектаМетаданных = ТипЗнч(ОписаниеОбъектаМетаданных);
	
	Если ТипОписанияОбъектаМетаданных = Тип("Тип") Тогда
		//@skip-warning
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ОписаниеОбъектаМетаданных);
	ИначеЕсли ТипОписанияОбъектаМетаданных = Тип("Строка") Тогда
		МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ОписаниеОбъектаМетаданных);
	Иначе
		МетаданныеОбъекта = ОписаниеОбъектаМетаданных;
	КонецЕсли;
	
	Если МетаданныеОбъекта = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Неизвестный объект метаданных для правила'");
	КонецЕсли;
	
	Если МетаданныеОбъекта.Макеты.Найти(ИмяМакетаШаблона) = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Не найдена схема компоновки данных для правила'");
	КонецЕсли;
	
	Возврат ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеОбъекта.ПолноеИмя()).ПолучитьМакет(
		ИмяМакетаШаблона);	
	
КонецФункции

// Функция - Объект исключение подсистемы правил событий.
//
// Параметры:
//  ИмяОбъекта	 - Строка	 - полное имя объекта.
// 
// Возвращаемое значение:
//  Булево - Исключить или нет из регистрации правил событий.
//
Функция ОбъектИсключениеПодсистемыПравилСобытий(Знач ИмяОбъекта) Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить("Справочник.ПравилаСобытий");
	Массив.Добавить("Справочник.ДействияПравилСобытий");
	Массив.Добавить("Справочник.ШаблоныСообщений");
	Массив.Добавить("Документ.ОтражениеМетрик");
	
	// Исключим присоединенные файлы.
	Для Каждого Спр Из Метаданные.Справочники Цикл
		Если СтрНайти(Спр.ПолноеИмя(), "ПрисоединенныеФайлы") > 0 Тогда
			Массив.Добавить(Спр.ПолноеИмя());
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив.Найти(ИмяОбъекта) <> Неопределено;
	
КонецФункции

// Проверяет по имени объекта, учавствует ли он в правилах или нет.
//
// Возвращаемое значение:
//  Булево.
//
Функция ОбъектИспользуетсяПодсистемойПравилСобытий(Знач ИмяОбъекта) Экспорт
	
	Если ИмяОбъекта = "Справочник.Комментарии" Тогда
		Возврат Истина;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПравилаСобытий.ТипПравила КАК ТипПравила
		|ИЗ
		|	Справочник.ПравилаСобытий КАК ПравилаСобытий
		|ГДЕ
		|	НЕ ПравилаСобытий.ПометкаУдаления
		|	И НЕ ПравилаСобытий.ЭтоГруппа
		|	И ПравилаСобытий.Использовать
		|	И ПравилаСобытий.ТипПравила = ЗНАЧЕНИЕ(Перечисление.ТипыПравилСобытий.ИзменениеОбъекта)
		|	И ПОДСТРОКА(ПравилаСобытий.ПроверкаРеквизитовОбъектаИмяОбъекта, 1, 1024) = &ИмяОбъекта";
	
	Запрос.УстановитьПараметр("ИмяОбъекта", ИмяОбъекта);
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти