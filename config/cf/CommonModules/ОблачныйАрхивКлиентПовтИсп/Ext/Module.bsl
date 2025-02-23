﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ОблачныйАрхив".
// ОбщийМодуль.ОблачныйАрхивКлиентПовтИсп.
//
// Все клиентские процедуры и функции для работы с "Облачным архивом" с повторным использованием значений.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ЛогИОтладка

// Функция возвращает значение, надо ли вести подробный журнал регистрации.
//
// Возвращаемое значение:
//  Булево - Истина, если надо вести подробный журнал регистрации, Ложь в противном случае.
//
Функция ВестиПодробныйЖурналРегистрации() Экспорт

	Результат = ОблачныйАрхивВызовСервера.ВестиПодробныйЖурналРегистрации();

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФункциональныеОпции

// Можно ли технически работать с облачным архивом и включена ли опция, разрешающая работать с этой подсистемой.
// В отличие от ВозможнаРаботаСОблачнымАрхивом() проверяется наличие технической возможности
//  и результат выбора пользователя в форме настроек.
// Это результат функциональной опции "РазрешенаРаботаСОблачнымАрхивом",
//   И доступны нужные роли,
//   И это файловая база,
//   И конфигурация запущена в Windows,
//   И это не веб-клиент и не внешнее соединение.
//
// Возвращаемое значение:
//  Булево - Истина, если возможна и разрешена работа с облачным архивом.
//
Функция РазрешенаРаботаСОблачнымАрхивом() Экспорт

	Результат = ОблачныйАрхивВызовСервера.РазрешенаРаботаСОблачнымАрхивом();

	Возврат Результат;

КонецФункции

// Можно ли технически работать с облачным архивом.
// В отличие от РазрешенаРаботаСОблачнымАрхивом() проверяется только наличие технической возможности работы с облачным архивом.
// Это результат, что
//   доступны нужные роли,
//   И это файловая база,
//   И конфигурация запущена в Windows,
//   И это не веб-клиент и не внешнее соединение.
// 
// Возвращаемое значение:
//  Булево - Истина, если возможна работа с облачным архивом.
//
Функция ВозможнаРаботаСОблачнымАрхивом() Экспорт

	Результат = ОблачныйАрхивВызовСервера.ВозможнаРаботаСОблачнымАрхивом();

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПрочиеСервисныеВозможности

// Возвращает ИСТИНА, если есть возможность работы с объектами Windows Scriprting Host.
// Так как работа с облачным архивом разрешена только в файловой ИБ, то можно проверять как на клиенте, так и на сервере.
//
// Возвращаемое значение:
//  Булево - Истина, если можно работать с объектами Windows Scriprting Host.
//
Функция ПоддерживаетсяРаботаСWSH() Экспорт

	// Работа возможна только в Windows, только файловой базе,
	//  и должны создаваться объекты Windows Scriprting Host:
	//  - Wscript:
	//   - WshShell.

	#Если НЕ ВебКлиент И НЕ МобильныйКлиент Тогда

	Результат = Истина;

	лкСистемнаяИнформация = Новый СистемнаяИнформация;

	Если (лкСистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86)
			ИЛИ (лкСистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64) Тогда

		Попытка
			ОбъектCOM = Новый COMОбъект("WScript.Shell");
		Исключение
			Результат = Ложь;
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка при использовании Windows Script Host:
					|%1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
				НСтр("ru='БИП:ОблачныйАрхив.Отладка'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()), // ИмяСобытия.
				НСтр("ru='Облачный архив. Отладка. Работа с Windows Script Host'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()), // ИдентификаторШага.
				"Ошибка", // УровеньЖурналаРегистрации.*
				, // ОбъектМетаданных
				, // Данные
				ТекстСообщения, // Комментарий
				ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации
		КонецПопытки;

	Иначе
		Результат = Ложь;
	КонецЕсли;

	#Иначе

		Результат = Ложь;

	#КонецЕсли

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти
