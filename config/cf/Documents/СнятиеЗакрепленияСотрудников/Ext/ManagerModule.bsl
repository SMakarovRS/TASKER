﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Функция возвращает список имен ключевых реквизитов.
//
// Параметры:
//   нет
//
// Возвращаемое значение:
//   Массив - массив реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

// Возвращает список реквизитов, которые разрешается редактировать.
//
// Параметры:
//   нет
//
// Возвращаемое значение:
//   Массив - массив реквизитов
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;

	Результат  = Новый Массив;
	Сотрудники = Ссылка.Сотрудники;
	Если Сотрудники.Количество() > 0 Тогда 
		Для Каждого СтрокаТаблицы Из Сотрудники Цикл
			Если ЗначениеЗаполнено(СтрокаТаблицы.Сотрудник) И ЗначениеЗаполнено(СтрокаТаблицы.Сотрудник.Физлицо) Тогда
				Результат.Добавить(СтрокаТаблицы.Сотрудник.Физлицо);
			КонецЕсли;	
		КонецЦикла;	
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

#Область ШаблоныСообщений

// СтандартныеПодсистемы.ШаблоныСообщений

////////////////////////////////////////////////////////////////////////////////
// Шаблоны сообщений

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Подсказка      - Строка - Расширенная информация о реквизите.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** Подсказка      - Строка - Расширенная информация о вложении.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl" и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
		
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получается SMS.
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS.
//     * Представление - Строка - представление получателя сообщения SMS.
//     * Контакт       - Произвольный - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт	
	
КонецПроцедуры

// Заполняет список получателей письма при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электронной почты.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт	
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ШаблоныСообщений

#КонецОбласти

#Область ПравилаСобытий

// Функция - Все условия правил событий для объекта.
// 
// Возвращаемое значение:
//  Соответствие - соответствие с условиями.
//
Функция УсловияПравилаСобытий() Экспорт
	
	СоответствиеИзменениеОбъекта = Новый Соответствие;
	СоответствиеИзменениеОбъекта.Вставить("СнятиеЗакрепленияСотрудниковИзменениеОбъектаПроведение", НСтр("ru = 'Проведение'"));
	
	СоответствиеПериодическоеСобытие = Новый Соответствие;
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("СоответствиеИзменениеОбъекта", 	  СоответствиеИзменениеОбъекта);
	Соответствие.Вставить("СоответствиеПериодическоеСобытие", СоответствиеПериодическоеСобытие);
	
	Возврат Соответствие;
	
КонецФункции

// Функция - Проверка условия правила события.
//
// Параметры:
//  ПравилоСобытия	 - СправчоникСсылка.ПравилаСобытий	 - правило проверки.
//  ИмяСобытия		 - Строка	 - имя проверки.
//  Структура		 - Структура	 - источник события и другая информация.
// 
// Возвращаемое значение:
//   - 
//
Функция ПроверкаУсловияПравилаСобытия(Знач ПравилоСобытия, Знач Структура, Знач Источник) Экспорт
	
	Результат = Ложь;
	ИмяСобытия = ПравилоСобытия.ПроверкаРеквизитовОбъектаИмяУсловия;
	
	Если ИмяСобытия = "СнятиеЗакрепленияСотрудниковИзменениеОбъектаПроведение" Тогда
		
		Если Структура.ЭтоНовый И Источник.Проведен Тогда
			Результат = Истина;
		Иначе
			ИсточникПередЗаписью = Структура.ИсточникПередЗаписью;
			Если Источник.Проведен <> ИсточникПередЗаписью.Проведен И ИсточникПередЗаписью.Проведен = Истина Тогда
				Результат = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ЗаполнениеОбъектов
// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗаполнениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ИнтерфейсПечати
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ ФОРМЫ

// Функция печати документа.
//
Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_СнятиеЗакрепленияСотрудников";
	
	ПервыйДокумент = Истина;
	
	Для каждого ТекущийДокумент Из МассивОбъектов Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СтруктураЗаполнения = УправлениеITОтделом8УФ.СтруктураЗаполненияПечатнойФормы(ТекущийДокумент);
			
		Если ИмяМакета = "СнятиеЗакрепленияСотрудников"Тогда
						
			ВыборкаСтрок= СтруктураЗаполнения.Сотрудники; 			
			Макет 		= УправлениеПечатью.МакетПечатнойФормы("Документ.СнятиеЗакрепленияСотрудников.ПФ_MXL_СнятиеЗакрепленияСотрудников");
			ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СнятиеЗакрепленияСотрудников_СнятиеЗакрепленияСотрудников";
			
			ОбластьШапка         = Макет.ПолучитьОбласть("Шапка");
			ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("ШапкаТаблицы");
			ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
			ОбластьПодвал        = Макет.ПолучитьОбласть("Подвал");
			
			ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, СтруктураЗаполнения);						
			ТабличныйДокумент.Вывести(ОбластьШапка);
			
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			
			Для Каждого СтрокаВыборки Из ВыборкаСтрок Цикл
				ЗаполнитьЗначенияСвойств(ОбластьСтрокаТаблицы.Параметры, СтрокаВыборки);
				ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
			КонецЦикла;
			
			ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьПодвал);
			
		ИначеЕсли ИмяМакета = "АктПередачи" Тогда
					
			ВыборкаСтрок= СтруктураЗаполнения.Сотрудники;
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СнятиеЗакрепленияСотрудников.ПФ_MXL_МакетАктПередачи");
			ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СнятиеЗакрепленияСотрудников_АктПередачи";
			
			КоличествоСтраниц = 0;
			Для Каждого СтрокаВыборки Из ВыборкаСтрок Цикл
				
				Если КоличествоСтраниц > 0 Тогда
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;				
				
				ОбластьШапка         = Макет.ПолучитьОбласть("Шапка");
				ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("ШапкаТаблицы");
				ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
				ОбластьПодвал        = Макет.ПолучитьОбласть("Подвал");		
								
				СтруктураЗаполнения.Вставить("ДатаИВремяПечати", ТекущаяДатаСеанса());
				СтруктураЗаполнения.Вставить("ТекстЗаголовка", НСтр("ru = 'Акт передачи'"));
				СтруктураЗаполнения.Вставить("МОЛ", СтрокаВыборки.Сотрудник);
				СтруктураЗаполнения.Вставить("МестоХранения", СтрокаВыборки.МестоХранения);
				ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, СтруктураЗаполнения);
				ТабличныйДокумент.Вывести(ОбластьШапка);
				
				ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
				
				Запрос = Новый Запрос();
				Запрос.Текст =
					"ВЫБРАТЬ
					|	ОстаткиОстатки.Номенклатура КАК Номенклатура,
					|	ОстаткиОстатки.Партия,
					|	ОстаткиОстатки.КоличествоОстаток КАК Количество,
					|	ВЫБОР
					|		КОГДА ТИПЗНАЧЕНИЯ(ОстаткиОстатки.Номенклатура) = ТИП(Справочник.КарточкиНоменклатуры)
					|			ТОГДА ОстаткиОстатки.Номенклатура.ИнвентарныйНомер
					|		ИНАЧЕ """"
					|	КОНЕЦ КАК ИнвентарныйНомер,
					|	ВЫБОР
					|		КОГДА ТИПЗНАЧЕНИЯ(ОстаткиОстатки.Номенклатура) = ТИП(Справочник.КарточкиНоменклатуры)
					|			ТОГДА ОстаткиОстатки.Номенклатура.СерийныйНомер
					|		ИНАЧЕ """"
					|	КОНЕЦ КАК СерийныйНомер,
					|	ВЫБОР
					|		КОГДА ТИПЗНАЧЕНИЯ(ОстаткиОстатки.Номенклатура) = ТИП(Справочник.КарточкиНоменклатуры)
					|			ТОГДА ОстаткиОстатки.Номенклатура.Владелец.ЕдиницаИзмерения
					|		ИНАЧЕ ОстаткиОстатки.Номенклатура.ЕдиницаИзмерения
					|	КОНЕЦ КАК ЕдиницаИзмерения
					|ИЗ
					|	РегистрНакопления.Остатки.Остатки(
					|			&ДатаКон,
					|			Организация = &Организация
					|				И МестоХранения = &МестоХранения) КАК ОстаткиОстатки
					|
					|УПОРЯДОЧИТЬ ПО
					|	Номенклатура";
					
				Запрос.УстановитьПараметр("ДатаКон"			, СтруктураЗаполнения.Дата);
				Запрос.УстановитьПараметр("Организация"		, СтруктураЗаполнения.Организация);
				Запрос.УстановитьПараметр("МестоХранения"	, СтрокаВыборки.МестоХранения);

				Выборка 	= Запрос.Выполнить();
				МассивСтрок = УправлениеITОтделом8УФ.МассивСтруктурИзРезультатаЗапроса(Выборка);
				
				нпп = 1;
				ИтогКолво = 0;
				Для Каждого СтрокаМассива Из МассивСтрок Цикл
					ЗаполнитьЗначенияСвойств(ОбластьСтрокаТаблицы.Параметры, СтрокаМассива);
					ОбластьСтрокаТаблицы.Параметры.Заполнить(Новый Структура("НомерСтроки", нпп));
					ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
					нпп = нпп + 1;
					ИтогКолво = ИтогКолво + СтрокаМассива.Количество;
				КонецЦикла;
				
				СтруктураЗаполнения.Вставить("ИтогКолво", ИтогКолво);
				ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, СтруктураЗаполнения);
				ТабличныйДокумент.Вывести(ОбластьПодвал);
				
				КоличествоСтраниц = КоличествоСтраниц + 1;
			КонецЦикла;			
			
		КонецЕсли;
	КонецЦикла;
	
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов,
				 ПараметрыПечати,
				 КоллекцияПечатныхФорм,
				 ОбъектыПечати,
				 ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СнятиеЗакрепленияСотрудников") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СнятиеЗакрепленияСотрудников", НСтр("ru = 'Снятие закрепления сотрудников'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "СнятиеЗакрепленияСотрудников"));
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктПередачи") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "АктПередачи", НСтр("ru = 'Акт передачи'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "АктПередачи"));
	КонецЕсли;
		
КонецПроцедуры

// Функция возвращает данные для печати документа.
//
Функция ПолучитьДанныеПечати(знач МассивДокументов, знач МассивИменМакетов) Экспорт
	
	ДанныеПоВсемОбъектам = Новый Соответствие;
	ОписаниеОбластей = Новый Соответствие;
	ДвоичныеДанныеМакетов = Новый Соответствие;
	ТипыМакетов = Новый Соответствие;
	
	Возврат Новый Структура("Данные, Макеты",
							ДанныеПоВсемОбъектам,
							Новый Структура("ОписаниеОбластей, ТипыМакетов, ДвоичныеДанныеМакетов",
											ОписаниеОбластей,
											ТипыМакетов,
											ДвоичныеДанныеМакетов));
	
КонецФункции

// Заполняет список команд печати
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт	
	
	// Акт передачи
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктПередачи";
	КомандаПечати.Представление = НСтр("ru = 'Акт передачи'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;	
	КомандаПечати.Порядок = 4;
	
	// Снятие закрепления сотрудников
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СнятиеЗакрепленияСотрудников";
	КомандаПечати.Представление = НСтр("ru = 'Снятие закрепления сотрудников'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;	
	КомандаПечати.Порядок = 5;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли