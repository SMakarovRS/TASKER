﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает признак наличия в конфигурации общих реквизитов-разделителей.
//
// Возвращаемое значение:
// Булево.
//
Функция сфпЭтоРазделеннаяКонфигурация() Экспорт
	
	ЕстьРазделители = Ложь;
	Для каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
			ЕстьРазделители = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЕстьРазделители;
	
КонецФункции

// Возвращает признак включения условного разделения.
// В случае вызова в неразделенной конфигурации возвращает Ложь.
//
Функция сфпРазделениеВключено() Экспорт
	
	Попытка
		ИмяОпции = "РаботаВМоделиСервиса";
		ЗначениеОпции = ПолучитьФункциональнуюОпцию(ИмяОпции);
	Исключение
		ЗначениеОпции = Ложь;
	КонецПопытки;
	
	Возврат сфпЭтоРазделеннаяКонфигурация() И ЗначениеОпции;
	
КонецФункции

// Возвращает Истина, если привилегированный режим был установлен
// при запуске с помощью параметра UsePrivilegedMode.
//
// Поддерживается только при запуске клиентских приложений
// (внешнее соединение не поддерживается).
//
Функция сфпПривилегированныйРежимУстановленПриЗапуске() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		Возврат ПараметрыСеанса["ПараметрыКлиентаНаСервере"].Получить(
			"ПривилегированныйРежимУстановленПриЗапуске") = Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции


