﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура загружает стандартные значения из макета с именем "СтандартныеЗначения".
// Имеет смысл заполнять значения из макета:
//  - при обновлении конфигурации (когда подключение к интернету может занять много времени);
//  - при первоначальном заполнении пустой базы, когда не заполнены параметры, логины и пароли для доступа к веб-сервисам обновлений.
//
// Параметры:
//  КонтекстВыполнения - Структура, Неопределено - структура контекста выполнения.
//
Процедура ЗагрузитьСтандартныеЗначения(КонтекстВыполнения = Неопределено) Экспорт

	ОбъектМетаданных = Справочники.ЛентыНовостей; // Переопределение
	ИмяОбъектаМетаданных = "Справочники.ЛентыНовостей"; // Переопределение
	ИмяСвойства = "CatalogObject_ЛентыНовостей"; // Переопределение
	ИдентификаторШага = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Новости. Сервис и регламент. Загрузка стандартных значений. %1. Начало'", ОбщегоНазначения.КодОсновногоЯзыка()),
		ИмяСвойства);

	НаименованиеПроцедурыФункции = ИмяОбъектаМетаданных + ".ЗагрузитьСтандартныеЗначения"; // Идентификатор.
	ЗаписыватьВЖурналРегистрации = Ложь;
	Если КонтекстВыполнения = Неопределено Тогда
		КонтекстВыполнения = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Этот контекст.
		ЗаписыватьВЖурналРегистрации = Истина;
	КонецЕсли;
	КодРезультата = 0;
	ОписаниеРезультата = "";
	КонтекстВыполненияВложенный = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Контекст "по шагам".
	ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		НаименованиеПроцедурыФункции, // Идентификатор.
		НСтр("ru='Загрузка стандартных значений'"));

		ТипСоответствие = Тип("Соответствие");
		ТипСтрока = Тип("Строка");

		СодержимоеМакета = ОбъектМетаданных.ПолучитьМакет("СтандартныеЗначения").ПолучитьТекст();
		ПоставляемыеДанныеОбъекта = Новый Соответствие;
		ПоставляемыеДанныеОбъекта.Вставить(
			"" + ИмяОбъектаМетаданных + ":СтандартныеЗначения", // Идентификатор.
			СодержимоеМакета);
		ОбработкаНовостей.ПолучитьДополнительныеСтандартныеЗначенияКлассификаторов(ИмяОбъектаМетаданных, ПоставляемыеДанныеОбъекта);
		Если ТипЗнч(ПоставляемыеДанныеОбъекта) = ТипСоответствие Тогда
			Для Каждого СтрокаСтандартныхЗначений Из ПоставляемыеДанныеОбъекта Цикл
				Если (ТипЗнч(СтрокаСтандартныхЗначений.Значение) = ТипСтрока)
						И (НЕ ПустаяСтрока(СтрокаСтандартныхЗначений.Значение)) Тогда
					ЕстьОшибки = Ложь;
					Попытка
						ОписаниеРезультата = ОписаниеРезультата
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Попытка загрузки стандартных значений из строки (первые 2000 символов):
									|%1'")
									+ Символы.ПС,
								Лев(СтрокаСтандартныхЗначений.Значение, 2000));
						ЧтениеХМЛ = Новый ЧтениеXML;
						ЧтениеХМЛ.УстановитьСтроку(СтрокаСтандартныхЗначений.Значение);
						ЧтениеХМЛ.Прочитать();
					Исключение
						ИнформацияОбОшибке = ИнформацияОбОшибке();
						ОписаниеРезультата = ОписаниеРезультата
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Ошибка загрузки стандартных значений из строки по причине:
									|%1'"),
								ПодробноеПредставлениеОшибки(ИнформацияОбОшибке))
							+ Символы.ПС;
						ЕстьОшибки = Истина;
					КонецПопытки;
					Если ЕстьОшибки <> Истина Тогда
						ХМЛТип = ПолучитьXMLТип(ЧтениеХМЛ);
						Если (НРег(ХМЛТип.ИмяТипа) = НРег("DefaultData")) Тогда // И (ВРег(ХМЛТип.URIПространстваИмен)=ВРег("http://v8.1c.ru/8.1/data/enterprise/current-config"))
							ОбъектХДТО = ФабрикаXDTO.ПрочитатьXML(ЧтениеХМЛ);
							СвойствоОбъект = ОбъектХДТО.Свойства().Получить(ИмяСвойства);
							Если ТипЗнч(СвойствоОбъект) = Тип("СвойствоXDTO") Тогда
								Если (СвойствоОбъект.ВерхняяГраница = -1) ИЛИ (СвойствоОбъект.ВерхняяГраница > 1) Тогда
									СписокХДТО = ОбъектХДТО.ПолучитьСписок(СвойствоОбъект);
									Для каждого лкТекущийОбъект Из СписокХДТО Цикл
										ЗагрузитьСтандартноеЗначение(лкТекущийОбъект, ОбъектМетаданных, ИмяСвойства, ОписаниеРезультата);
									КонецЦикла;
								ИначеЕсли (СвойствоОбъект.НижняяГраница = 1) И (СвойствоОбъект.ВерхняяГраница = 1) Тогда
									ЗагрузитьСтандартноеЗначение(ОбъектХДТО.Получить(СвойствоОбъект), ОбъектМетаданных, ИмяСвойства, ОписаниеРезультата);
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

	ШагВыполнения = ИнтернетПоддержкаПользователейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата, // Много действий, всегда установлено в 0, надо читать данные по каждому шагу.
		ОписаниеРезультата,
		КонтекстВыполненияВложенный);

	Если ЗаписыватьВЖурналРегистрации = Истина Тогда

		ИнтернетПоддержкаПользователей.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Сервис и регламент'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИмяСобытия.
			ИдентификаторШага, // ИдентификаторШага.
			?(КодРезультата > 0,
				УровеньЖурналаРегистрации.Ошибка,
				УровеньЖурналаРегистрации.Информация), // УровеньЖурналаРегистрации.*
			, // ОбъектМетаданных
			(ШагВыполнения.ВремяОкончания - ШагВыполнения.ВремяНачала), // Данные
			ОбработкаНовостей.КомментарийДляЖурналаРегистрации(
				НаименованиеПроцедурыФункции,
				ШагВыполнения,
				КонтекстВыполнения,
				"Простой"), // Комментарий
			ОбработкаНовостейПовтИсп.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	КонецЕсли;

КонецПроцедуры

// Процедура загружает стандартное значение из макета с именем "СтандартныеЗначения".
//
// Параметры:
//  ОбъектХДТО       - Объект ХДТО - загружаемый объект;
//  ОбъектМетаданных - Объект метаданных;
//  ИмяСвойства      - Строка - имя свойства;
//  ЛогЗагрузки      - Строка - сюда будет писаться состояние загрузки данных.
//
Процедура ЗагрузитьСтандартноеЗначение(ОбъектХДТО, ОбъектМетаданных, ИмяСвойства, ЛогЗагрузки)

	Попытка
		// Если объект был загружен ранее (есть другой объект с таким же кодом), то подставить
		//  в создаваемый объект ссылку на созданный ранее элемент.
		НайденныйЭлемент = ОбъектМетаданных.НайтиПоКоду(ОбъектХДТО.Code);
		Если НайденныйЭлемент.Пустая() Тогда
			// Нет ранее созданных элементов с таким же кодом - оставить как есть.
			СтрокаЛогаЗагрузки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Создание: %1'"),
				СокрЛП(ОбъектХДТО.Code));
		Иначе
			// Подменить на ранее созданный элемент с таким же кодом.
			ОбъектХДТО.Ref = НайденныйЭлемент.Ссылка;
			СтрокаЛогаЗагрузки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Изменение: %1, %2'"),
				СокрЛП(НайденныйЭлемент.Код),
				СокрЛП(НайденныйЭлемент.Наименование));
		КонецЕсли;
		ТекущийОбъект = СериализаторXDTO.ПрочитатьXDTO(ОбъектХДТО);
		// Дополнение для Лент новостей, в которых могут храниться пользовательские настройки.
		// После загрузки объекта его надо сравнить с сохраненным в базе данных (если он там был)
		//  и восстановить значения следующих полей:
		//   Логин, Пароль, ВидимостьПоУмолчанию, ЧастотаОбновления, Комментарий, ПропускатьЗагрузкуБинарныхДанных,
		//     Табличная часть ИсключенияВидимости.
		Если НЕ ТекущийОбъект.Ссылка.Пустая() Тогда
			ЭталонныйОбъект = ТекущийОбъект.Ссылка.ПолучитьОбъект();
			ЗаполнитьЗначенияСвойств(
				ТекущийОбъект,
				ЭталонныйОбъект,
				"Логин, Пароль, ВидимостьПоУмолчанию, ЧастотаОбновления, Комментарий, ПропускатьЗагрузкуБинарныхДанных");
			ТекущийОбъект.ИсключенияВидимости.Загрузить(ЭталонныйОбъект.ИсключенияВидимости.Выгрузить());
			ЭталонныйОбъект = Неопределено;
		КонецЕсли;
		ТекущийОбъект.ОбменДанными.Загрузка = Истина;
		ТекущийОбъект.Записать();
		// После записи классификатора можно провести дополнительные обработки.
		ОбработкаНовостей.ДополнительноОбработатьКлассификаторПослеПолученияПослеЗаписи(ТекущийОбъект.Ссылка);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ИдентификаторШага = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Новости. Сервис и регламент. Загрузка стандартных значений. %1. Ошибка'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ИмяСвойства);
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось записать объект метаданных по причине:
				|%1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ИнтернетПоддержкаПользователей.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Сервис и регламент'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИмяСобытия.
			ИдентификаторШага, // ИдентификаторШага.
			УровеньЖурналаРегистрации.Ошибка, // УровеньЖурналаРегистрации.*
			ОбъектМетаданных, // ОбъектМетаданных
			, // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации
		СтрокаЛогаЗагрузки = СтрокаЛогаЗагрузки + ". "
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Произошла ошибка записи: %1'"),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;

	ЛогЗагрузки = ЛогЗагрузки + СтрокаЛогаЗагрузки + Символы.ПС;

КонецПроцедуры

// Процедура формирует текст условия для генерации url, для получения новостей из новостного центра.
//
// Параметры:
//  ЛентаНовостей - СправочникСсылка.ЛентыНовостей - лента новостей, для которой необходимо сформировать фильтр.
//
// Возвращаемое значение:
//   Строка - представление условий отбора для генерации url. Может быть пустой строкой.
//
Функция СформироватьТекстУсловияДляСервераНовостей(ЛентаНовостей) Экспорт

	Результат = "";

	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	Спр.КатегорияНовостей           КАК КатегорияНовостей,
		|	Спр.КатегорияНовостей.Код       КАК КатегорияНовостей_Код,
		|	Спр.ОтборНастраиваетсяНаСервере КАК ОтборБудетНастраиватьНаСервере,
		|	ПВХ.ОтборНастраиваетсяНаСервере КАК ОтборМожноНастраиватьНаСервере,
		|	ПВХ.ТипЗначенияВспомогательный  КАК ТипЗначенияВспомогательный,
		|	Рег.ЗначениеКатегорииНовостей   КАК ЗначениеКатегорииНовостей,
		|	ВЫБОР
		|		КОГДА ПВХ.ТипЗначенияВспомогательный = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенийКатегорийНовостей.Булево) ТОГДА
		|			Рег.ЗначениеКатегорииНовостей
		|		КОГДА ПВХ.ТипЗначенияВспомогательный = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенийКатегорийНовостей.Дата) ТОГДА
		|			Рег.ЗначениеКатегорииНовостей
		|		КОГДА ПВХ.ТипЗначенияВспомогательный = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенийКатегорийНовостей.Строка) ТОГДА
		|			Рег.ЗначениеКатегорииНовостей
		|		КОГДА ПВХ.ТипЗначенияВспомогательный = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенийКатегорийНовостей.Число) ТОГДА
		|			Рег.ЗначениеКатегорииНовостей
		|		КОГДА ПВХ.ТипЗначенияВспомогательный = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ЗначенияКатегорийНовостей) ТОГДА
		|			Рег.ЗначениеКатегорииНовостей.Код
		|		КОГДА ПВХ.ТипЗначенияВспомогательный = ЗНАЧЕНИЕ(Перечисление.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ИнтервалыВерсийПродукта) ТОГДА
		|			Рег.ЗначениеКатегорииНовостей // Для интервала версий нет возможности задавать пользовательские отборы
		|	КОНЕЦ                           КАК ЗначениеКатегорииНовостей_Код
		|ИЗ
		|	Справочник.ЛентыНовостей.ДоступныеКатегорииНовостей КАК Спр
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|	ПланВидовХарактеристик.КатегорииНовостей КАК ПВХ
		|	ПО
		|		Спр.КатегорияНовостей = ПВХ.Ссылка
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ОтборыПоЛентамНовостейОбщие КАК Рег // Только Общие отборы, без отборов по области данных.
		|	ПО
		|		Рег.ЛентаНовостей = Спр.Ссылка
		|		И Рег.КатегорияНовостей = Спр.КатегорияНовостей
		|ГДЕ
		|	Спр.Ссылка = &ЛентаНовостей
		|	И ПВХ.ОтборНастраиваетсяНаСервере = ИСТИНА // ОтборМожноНастраиватьНаСервере
		|	И Спр.ОтборНастраиваетсяНаСервере = ИСТИНА // ОтборБудетНастраиватьНаСервере
		|УПОРЯДОЧИТЬ ПО
		|	Спр.КатегорияНовостей.Код
		|";
	Запрос.УстановитьПараметр("ЛентаНовостей", ЛентаНовостей);

	РезультатЗапроса = Запрос.Выполнить(); // СформироватьТекстУсловияДляСервераНовостей()
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);
		// Внутри одной категории условия объединяются по ИЛИ.
		// Между категориями условия объединяются по И.
		Пока Выборка.СледующийПоЗначениюПоля("КатегорияНовостей") Цикл
			Если СтрДлина(Выборка.КатегорияНовостей_Код) > 0 Тогда
				КоличествоУсловийПоКатегории = 0;
				УсловияПоКатегории = "";
				Пока Выборка.Следующий() Цикл
					Если (СтрДлина(Выборка.ЗначениеКатегорииНовостей_Код) > 0)
							ИЛИ (Выборка.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Строка) Тогда // Строка может быть нулевой длины, остальные значения должны быть явно введены
						Если Выборка.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Булево Тогда
							УсловияПоКатегории = УсловияПоКатегории + "#(" + Выборка.КатегорияНовостей_Код + "=" + ?(Выборка.ЗначениеКатегорииНовостей_Код, "TRUE", "FALSE") + ")#";
							КоличествоУсловийПоКатегории = КоличествоУсловийПоКатегории + 1;
						ИначеЕсли Выборка.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Дата Тогда
							УсловияПоКатегории = УсловияПоКатегории + "#(" + Выборка.КатегорияНовостей_Код + "=" + XMLСтрока(Выборка.ЗначениеКатегорииНовостей_Код) + "Z" + ")#"; // Дата - в нулевом меридиане
							КоличествоУсловийПоКатегории = КоличествоУсловийПоКатегории + 1;
						ИначеЕсли Выборка.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Строка Тогда
							УсловияПоКатегории = УсловияПоКатегории + "#(" + Выборка.КатегорияНовостей_Код + "=" + Выборка.ЗначениеКатегорииНовостей_Код + ")#";
							КоличествоУсловийПоКатегории = КоличествоУсловийПоКатегории + 1;
						ИначеЕсли Выборка.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Число Тогда
							УсловияПоКатегории = УсловияПоКатегории + "#(" + Выборка.КатегорияНовостей_Код + "=" + Формат(Выборка.ЗначениеКатегорииНовостей_Код, "ЧЦ=15; ЧДЦ=4; ЧРД=.; ЧН=0.0000; ЧГ=0; ЧО=1") + ")#";
							КоличествоУсловийПоКатегории = КоличествоУсловийПоКатегории + 1;
						ИначеЕсли Выборка.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ЗначенияКатегорийНовостей Тогда
							УсловияПоКатегории = УсловияПоКатегории + "#(" + Выборка.КатегорияНовостей_Код + "=" + Выборка.ЗначениеКатегорииНовостей_Код + ")#";
							КоличествоУсловийПоКатегории = КоличествоУсловийПоКатегории + 1;
						ИначеЕсли Выборка.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ИнтервалыВерсийПродукта Тогда
							// Для интервала версий нет возможности задавать пользовательские отборы.
							// Пропустить это условие.
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				Если КоличествоУсловийПоКатегории > 1 Тогда
					Результат = Результат + "$(" + УсловияПоКатегории + ")$";
				ИначеЕсли КоличествоУсловийПоКатегории = 1 Тогда
					Результат = Результат + "$" + УсловияПоКатегории + "$";
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если СтрДлина(Результат) > 0 Тогда
		Результат = "filter=(" + Результат + ")";
	КонецЕсли;

	Результат = СтрЗаменить(Результат, "$$", " and ");
	Результат = СтрЗаменить(Результат, "$", "");
	Результат = СтрЗаменить(Результат, "##", " or ");
	Результат = СтрЗаменить(Результат, "#", "");

	Возврат Результат;

КонецФункции

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
// Используется для сопоставления элементов механизмом "Выгрузка/загрузка областей данных".
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Код");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли