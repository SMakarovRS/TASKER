﻿////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Форма параметризуется:
//     ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//     УзелИнформационнойБазы   - ПланОбменаСсылка                      - узел обмена, для которого происходит
//                                                                        настройка.
//     ПериодОтбора             - СтандартныйПериод                     - общий период отбора.
//     Отбор                    - ДанныеФормыКоллекция, ТаблицаЗначений - описание отбора для редактирования.
//                                При описании отбора используются колонки:
//                                    ПолноеИмяМетаданных - Строка                - имя метаданных, для отбора.
//                                    Отбор               - ОтборКомпоновкиДанных - описание отбора.
//                                    ВыборПериода        - Булево                - Истина, если применим общий период 
//                                                                                  отбора строки.
//                                    Период              - СтандартныйПериод     - общий период отбора для строки.
//
// Форма должна вернуть результатом выбора структуру с полями:
//     ПредставлениеОтбора      - Строка                                - описание отбора.
//     ИспользоватьПериодОтбора - Булево                                - флаг использования общего отбора по периоду.
//     ПериодОтбора             - СтандартныйПериод                     - общий период выбора, если используется.
//     Отбор                    - ДанныеФормыКоллекция, ТаблицаЗначений - заполненные данные.
//                                Используются колонки аналогичные входному параметру: 
//                                ПолноеИмяМетаданных, Отбор, ВыборПериода, Период.
//

#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УзелИнформационнойБазы = Параметры.УзелИнформационнойБазы;
	ПериодОтбора           = Параметры.ПериодОтбора;
	
	// Все возможные организации
	Для Каждого ЭлементСписка Из ДоступныеОрганизацииУзла(УзелИнформационнойБазы) Цикл
		ЗаполнитьЗначенияСвойств(СписокОрганизаций.Добавить(), ЭлементСписка);
	КонецЦикла;
	
	// Расставляем пометки, согласно входящему параметру.
	ОрганизацииОтбора = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ОрганизацииОтбораИнтерактивнойВыгрузки(Параметры.Отбор);
	
	Для Каждого Элемент Из ОрганизацииОтбора Цикл
		ЭлементСписка = СписокОрганизаций.НайтиПоЗначению(Элемент.Значение);
		Если ЭлементСписка<>Неопределено Тогда
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//

&НаКлиенте
Процедура ВыбратьОтмеченные(Команда)
	
	ОповеститьОВыборе(РезультатВыбора());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//

&НаСервереБезКонтекста
Функция ДоступныеОрганизацииУзла(Знач УзелИнформационнойБазы)
	
	Если УзелИнформационнойБазы.ИспользоватьОтборПоОрганизациям Тогда
		// Организации из табличной части.
		ЗапросИсточника = Новый Запрос("
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ОрганизацииПланаОбмена.Организация              КАК Организация,
			|	ОрганизацииПланаОбмена.Организация.Наименование КАК Наименование
			|ИЗ
			|	ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Организации КАК ОрганизацииПланаОбмена
			|ГДЕ
			|	ОрганизацииПланаОбмена.Ссылка = &Получатель
			|");
		ЗапросИсточника.УстановитьПараметр("Получатель", УзелИнформационнойБазы);
	Иначе
		// Все доступные организации
		ЗапросИсточника = Новый Запрос("
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Организации.Ссылка       КАК Организация,
			|	Организации.Наименование КАК Наименование
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	НЕ Организации.ПометкаУдаления
			|");
	КонецЕсли;
	
	Результат = Новый СписокЗначений;
	
	Выборка = ЗапросИсточника.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.Организация, Выборка.Наименование);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция РезультатВыбора()
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПериодОтбора", Истина);
	Результат.Вставить("ПериодОтбора",             ПериодОтбора);
	
	ТаблицаОтбора.Очистить();
	Результат.Вставить("Отбор", ТаблицаОтбора);
	СтрокаОтбора = Результат.Отбор.Добавить();
	СтрокаОтбора.ПолноеИмяМетаданных = "Документ.Поступление";
	СтрокаОтбора.ВыборПериода = ЗначениеЗаполнено(ПериодОтбора);
	СтрокаОтбора.Период       = ПериодОтбора;
	
	КомпоновщикОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	СтрокаОтбора.Отбор = КомпоновщикОтбора.Настройки.Отбор;
	
	ИмяПоляОрганизации = "Ссылка.Организация";
	ТипЭлементОтбора   = Тип("ЭлементОтбораКомпоновкиДанных");
	
	ОтборПоОрганизации = СтрокаОтбора.Отбор.Элементы.Добавить(ТипЭлементОтбора);
	ОтборПоОрганизации.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоляОрганизации);
	ОтборПоОрганизации.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборПоОрганизации.ПравоеЗначение = Новый Массив;
	ОтборПоОрганизации.Использование  = Истина;
	
	Для Каждого ЭлементСписка Из СписокОрганизаций Цикл
		Если ЭлементСписка.Пометка Тогда
			ОтборПоОрганизации.ПравоеЗначение.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Результат.Вставить("ПредставлениеОтбора", 
		ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ПредставлениеОтбораИнтерактивнойВыгрузки(УзелИнформационнойБазы, Результат));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
