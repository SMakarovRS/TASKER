﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс
// Функция возвращает список имен «ключевых» реквизитов.
//
// Возвращаемое значение:
//  Массив - массив блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

// Возвращает список реквизитов, которые разрешается редактировать,
// с помощью обработки группового изменения объектов.
//
// Возвращаемое значение:
//  Массив - массив реквизитов, редактируемых при групповой обработке.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Возврат Новый Массив;
	
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
	
	РеквизитПоложениеСтатьиДоходовРасходов  	  = Реквизиты.Найти("Списание.ПоложениеСтатьиДоходовРасходов");
	Реквизиты.Удалить(РеквизитПоложениеСтатьиДоходовРасходов);
	РеквизитПоложениеПодразделения	  = Реквизиты.Найти("Списание.ПоложениеПодразделения");
	Реквизиты.Удалить(РеквизитПоложениеПодразделения);
	
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
	СоответствиеИзменениеОбъекта.Вставить("СписаниеИзменениеОбъектаПроведение", НСтр("ru = 'Проведение'"));
	
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
	
	Если ИмяСобытия = "СписаниеИзменениеОбъектаПроведение" Тогда
		
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

// Функция печати документа
//
Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ИмяМакета)
	
	СтруктураЗаполнения 					= Новый Структура;
	ТабличныйДокумент 						= Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати  = "ПараметрыПечати_Списание";
	
	ПервыйДокумент = Истина;
	
	
	
	Для каждого ТекущийДокумент Из МассивОбъектов Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СтруктураЗаполнения = УправлениеITОтделом8УФ.СтруктураЗаполненияПечатнойФормы(ТекущийДокумент);
				
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
		Запрос.УстановитьПараметр("Период", ТекущийДокумент.Дата);
		Запрос.УстановитьПараметр("Организация", ТекущийДокумент.Организация);
		Запрос.УстановитьПараметр("МестоХранения", ТекущийДокумент.МестоХранения); 		
		Запрос.Текст=
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОстаткиОстатки.Номенклатура,
		|	ОстаткиОстатки.Партия,
		|	ЕСТЬNULL(ОстаткиОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
		|	ЕСТЬNULL(ОстаткиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ОстаткиОстатки.КоличествоОстаток, 0) = 0
		|			ТОГДА 0
		|		ИНАЧЕ ОстаткиОстатки.СуммаОстаток / ОстаткиОстатки.КоличествоОстаток
		|	КОНЕЦ КАК Себестоимость
		|ПОМЕСТИТЬ ВТ_Остатки
		|ИЗ
		|	РегистрНакопления.Остатки.Остатки(
		|			&Период,
		|			Организация = &Организация
		|				И МестоХранения = &МестоХранения) КАК ОстаткиОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Списание.Ссылка,
		|	Списание.ВерсияДанных,
		|	Списание.ПометкаУдаления,
		|	Списание.Номер,
		|	Списание.Дата КАК ДатаДокумента,
		|	Списание.Проведен,
		|	Списание.Организация,
		|	Списание.МестоХранения,
		|	ВЫРАЗИТЬ(Списание.Комментарий КАК СТРОКА(1000)) КАК Комментарий,
		|	Списание.Основание,
		|	Списание.Автор,
		|	Списание.ДатаСоздания,
		|	Списание.АвторКорректировки,
		|	Списание.ДатаКорректировки,
		|	Списание.Представление,
		|	Списание.МоментВремени,
		|	Списание.ДополнительныеРеквизиты.(
		|		Ссылка,
		|		НомерСтроки,
		|		Свойство,
		|		Значение,
		|		ТекстоваяСтрока
		|	)
		|ИЗ
		|	Документ.Списание КАК Списание
		|ГДЕ
		|	Списание.Ссылка = &ТекущийДокумент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	&Период,
		|	&Организация КАК Организация,
		|	&МестоХранения КАК МестоХранения,
		|	ВЫБОР
		|		КОГДА СписаниеНоменклатура.Номенклатура.ВидНоменклатуры.ВестиУчетПоКарточкамНоменклатуры
		|			ТОГДА СписаниеНоменклатура.КарточкаНоменклатуры
		|		ИНАЧЕ СписаниеНоменклатура.Номенклатура
		|	КОНЕЦ КАК Номенклатура,
		|	СписаниеНоменклатура.Партия,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(СписаниеНоменклатура.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
		|			ТОГДА СписаниеНоменклатура.Количество
		|		ИНАЧЕ СписаниеНоменклатура.Количество * СписаниеНоменклатура.ЕдиницаИзмерения.Коэффициент
		|	КОНЕЦ КАК Количество,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ВТ_Остатки.Себестоимость, 0) = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ТИПЗНАЧЕНИЯ(СписаниеНоменклатура.ЕдиницаИзмерения) = ТИП(Справочник.КлассификаторЕдиницИзмерения)
		|					ТОГДА ВТ_Остатки.Себестоимость * СписаниеНоменклатура.Количество
		|				ИНАЧЕ ВТ_Остатки.Себестоимость * СписаниеНоменклатура.Количество * СписаниеНоменклатура.ЕдиницаИзмерения.Коэффициент
		|			КОНЕЦ
		|	КОНЕЦ КАК Сумма,
		|	СписаниеНоменклатура.НомерСтроки,
		|	СписаниеНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмеренияНаименование,
		|	СписаниеНоменклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
		|	СписаниеНоменклатура.ПричинаСписания.Наименование КАК ПричинаСписанияНаименование,
		|	СписаниеНоменклатура.ПричинаСписания.Код КАК ПричинаСписанияКод,
		|	СписаниеНоменклатура.Номенклатура.Код КАК НоменклатураКод,
		|	СписаниеНоменклатура.КарточкаНоменклатуры.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	СписаниеНоменклатура.КарточкаНоменклатуры.СерийныйНомер КАК СерийныйНомер,
		|	СписаниеНоменклатура.КарточкаНоменклатуры.ДокументПоступления.Дата КАК ДатаПоступления,
		|	ВТ_Остатки.Себестоимость КАК Цена,
		|	СписаниеНоменклатура.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
		|	ВЫРАЗИТЬ(СписаниеНоменклатура.Описание КАК СТРОКА(1000)) КАК Описание
		|ИЗ
		|	Документ.Списание.Номенклатура КАК СписаниеНоменклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
		|		ПО СписаниеНоменклатура.Партия = ВТ_Остатки.Партия
		|			И (ВЫБОР
		|				КОГДА СписаниеНоменклатура.Номенклатура.ВидНоменклатуры.ВестиУчетПоКарточкамНоменклатуры
		|					ТОГДА СписаниеНоменклатура.КарточкаНоменклатуры = ВТ_Остатки.Номенклатура
		|				ИНАЧЕ СписаниеНоменклатура.Номенклатура = ВТ_Остатки.Номенклатура
		|			КОНЕЦ)
		|ГДЕ
		|	СписаниеНоменклатура.Ссылка = &ТекущийДокумент";
			
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		Шапка = МассивРезультатов[1].Выбрать();
		Шапка.Следующий();
		
		ВыборкаСтрокНоменклатуры = МассивРезультатов[2].Выгрузить();
		
		НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер, Истина, Истина);
		
		СведенияОбОрганизации 	= УправлениеITОтделом8УФ.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента, ,);
		МОЛ						= УправлениеITОтделом8УФ.ПолучитьОтветственногоСотрудникаМестаХранения(Шапка.ДатаДокумента, Шапка.МестоХранения);
		СтруктураРуководители 	= УправлениеITОтделом8УФ.ОтветственныеЛицаОрганизационнойЕдиницы(Шапка.Организация, Шапка.ДатаДокумента);
		
		Если ИмяМакета = "АктСписания" Тогда			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Списание.ПФ_MXL_МакетАктСписания");
			
			ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Списание_АктСписания";
			
			СтруктураЗаполнения.Вставить("Номер", 							НомерДокумента);			
			СтруктураЗаполнения.Вставить("ДатаДокумента", 					Формат(Шапка.ДатаДокумента, "ДЛФ=DD"));
			СтруктураЗаполнения.Вставить("МестоХранения",					Шапка.МестоХранения);
			СтруктураЗаполнения.Вставить("МОЛ",								МОЛ);
			СтруктураЗаполнения.Вставить("ПолноеНаименованиеОрганизации", 	УправлениеITОтделом8УФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование"));
			СтруктураЗаполнения.Вставить("ДатаИВремяПечати",				ТекущаяДатаСеанса());
			СтруктураЗаполнения.Вставить("СамДокумент", 					ТекущийДокумент);
			СтруктураЗаполнения.Вставить("Комментарий",						Шапка.Комментарий);
			СтруктураЗаполнения.Вставить("Основание",						Шапка.Основание);			
			
			ОбластьМакета                            = Макет.ПолучитьОбласть("Шапка");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ОбластьМакета                            = Макет.ПолучитьОбласть("ШапкаТаблицы");			
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Вывод строк
			ОбластьМакета							 = Макет.ПолучитьОбласть("СтрокаТаблицы");
			Сумма									 = 0;
			Количество								 = 0;
			Для Каждого Строка Из  ВыборкаСтрокНоменклатуры Цикл
				ОбластьМакета.Параметры.Заполнить(Строка);
				ТабличныйДокумент.Вывести(ОбластьМакета);
				Количество = Количество + Строка.Количество;
				Сумма 	   = Сумма 		+ Строка.Сумма;
			КонецЦикла;
			
			ОбластьМакета							= Макет.ПолучитьОбласть("Подвал");			
			СтруктураЗаполнения.Вставить("ИтогКолво",		Количество);
			СтруктураЗаполнения.Вставить("ИтогСумма",      	Формат(Сумма,"ЧДЦ=2; ЧН=0,00"));						   
			СтруктураЗаполнения.Вставить("СуммаПрописью", 	ЧислоПрописью(Сумма,, "Рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2"));			
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		ИначеЕсли ИмяМакета = "АктСписанияОС4" Тогда
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Списание.ПФ_MXL_ОС4");			
			ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Списание_АктСписанияОС4";		
			СтруктураЗаполнения.Вставить("Номер", 							НомерДокумента);
			СтруктураЗаполнения.Вставить("ДатаДокумента",  					Формат(Шапка.ДатаДокумента, "ДЛФ=DD"));
			СтруктураЗаполнения.Вставить("МестоХранения",  					Шапка.МестоХранения);
			СтруктураЗаполнения.Вставить("МОЛ",								МОЛ);
			СтруктураЗаполнения.Вставить("ПолноеНаименованиеОрганизации", 	УправлениеITОтделом8УФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование"));
			СтруктураЗаполнения.Вставить("Комментарий",						Шапка.Комментарий);
			СтруктураЗаполнения.Вставить("Основание",						Шапка.Основание);
			СтруктураЗаполнения.Вставить("ФИОГлавногоБухгалтера",			СтруктураРуководители.ФИОГлавногоБухгалтера);
			
			ОбластьМакета                             	= Макет.ПолучитьОбласть("Заголовок1");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);
				
			// Вывод строк			
			ОбластьМакета								= Макет.ПолучитьОбласть("Строка");
			Количество									= ВыборкаСтрокНоменклатуры.Количество();
			Для Каждого Строка Из ВыборкаСтрокНоменклатуры Цикл
				ОбластьМакета.Параметры.Заполнить(Строка);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЦикла;
			
			ОбластьМакета								= Макет.ПолучитьОбласть("Заголовок2");			
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);                                                                                                                               
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		ИначеЕсли ИмяМакета = "РасходнаяНакладная" Тогда
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Списание.ПФ_MXL_РасходнаяНакладная");			
			ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Списание_РасходнаяНакладная";			
			СтруктураЗаполнения.Вставить("Номер", НомерДокумента);
			СтруктураЗаполнения.Вставить("ДатаДокумента", 	Формат(Шапка.ДатаДокумента, "ДЛФ=DD"));
			СтруктураЗаполнения.Вставить("МестоХранения", 	Шапка.МестоХранения);
			СтруктураЗаполнения.Вставить("МОЛ",		   		МОЛ);
			СтруктураЗаполнения.Вставить("ПолноеНаименованиеОрганизации", УправлениеITОтделом8УФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование"));
			СтруктураЗаполнения.Вставить("ДатаИВремяПечати",ТекущаяДатаСеанса());
			СтруктураЗаполнения.Вставить("СамДокумент", 	ТекущийДокумент);
			СтруктураЗаполнения.Вставить("Комментарий",		Шапка.Комментарий);
			СтруктураЗаполнения.Вставить("Основание",		Шапка.Основание);			
			
			ОбластьМакета                           = Макет.ПолучитьОбласть("Шапка");			
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ОбластьМакета                           = Макет.ПолучитьОбласть("ШапкаТаблицы");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Вывод строк			
			ОбластьМакета							= Макет.ПолучитьОбласть("СтрокаТаблицы");
			Сумма									= 0;
			Количество								= 0;
			Для Каждого Строка Из ВыборкаСтрокНоменклатуры Цикл
				ОбластьМакета.Параметры.Заполнить(Строка);
				Количество = Количество + Строка.Количество;
				Сумма = Сумма + Строка.Сумма;
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
			КонецЦикла;
			
			ОбластьМакета							= Макет.ПолучитьОбласть("Подвал");			
			СтруктураЗаполнения.Вставить("ИтогКоличество",		Количество);
			СтруктураЗаполнения.Вставить("ИтогСумма",			Формат(Сумма, "ЧДЦ=2; ЧН=0,00"));
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);			
			
		ИначеЕсли ИмяМакета = "МБ4" Тогда
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Списание.ПФ_MXL_МБ4");			
			ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_Списание_МБ4";						
			СтруктураЗаполнения.Вставить("Номер",						НомерДокумента);
			СтруктураЗаполнения.Вставить("Дата",						Шапка.ДатаДокумента);
			СтруктураЗаполнения.Вставить("МестоХранения",				Шапка.МестоХранения);
			СтруктураЗаполнения.Вставить("ПолноеНаименованиеОрганизации", УправлениеITОтделом8УФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование"));
			СтруктураЗаполнения.Вставить("Комментарий",					Шапка.Комментарий);
			СтруктураЗаполнения.Вставить("Основание",					Шапка.Основание);
			СтруктураЗаполнения.Вставить("ДолжностьРуководителя",		СтруктураРуководители.РуководительДолжность);
			СтруктураЗаполнения.Вставить("ФИОРуководителя",				СтруктураРуководители.ФИОРуководителя);
			СтруктураЗаполнения.Вставить("ДолжностьКладовщика",			СтруктураРуководители.КладовщикДолжность);
			СтруктураЗаполнения.Вставить("ФИОКладовщика",				СтруктураРуководители.ФИОКладовщика);
			СтруктураЗаполнения.Вставить("ДолжностьГлавногоБухгалтера",	СтруктураРуководители.ГлавныйБухгалтерДолжность);
			СтруктураЗаполнения.Вставить("ФИОГлавногоБухгалтера",		СтруктураРуководители.ФИОГлавногоБухгалтера);
			СтруктураЗаполнения.Вставить("МОЛ",							МОЛ);
			
			ОбластьМакета                           = Макет.ПолучитьОбласть("Шапка");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ОбластьМакета                           = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Вывод строк			
			ОбластьМакета							= Макет.ПолучитьОбласть("Строка");
			Сумма									= 0;
			Количество								= ВыборкаСтрокНоменклатуры.Количество();
			Для Каждого Строка Из ВыборкаСтрокНоменклатуры Цикл
				ОбластьМакета.Параметры.Заполнить(Строка);
				ТабличныйДокумент.Вывести(ОбластьМакета);
				Сумма = Сумма + Строка.Сумма;
			КонецЦикла;
			
			ОбластьМакета							= Макет.ПолучитьОбласть("Подвал");						
			СтруктураЗаполнения.Вставить("ИтогСумма",	Сумма);
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);			
			ТабличныйДокумент.Вывести(ОбластьМакета);			
			
			ОбластьМакета							= Макет.ПолучитьОбласть("Итог");		
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);			
			ТабличныйДокумент.Вывести(ОбластьМакета);			
			
		ИначеЕсли ИмяМакета = "МБ8" Тогда
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Списание.ПФ_MXL_МБ8");			
			ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_Списание_МБ8";			
			СтруктураЗаполнения.Вставить("НомерДокумента",				НомерДокумента);
			СтруктураЗаполнения.Вставить("ДатаДокумента",				Шапка.ДатаДокумента);
			СтруктураЗаполнения.Вставить("МестоХранения",				Шапка.МестоХранения);
			СтруктураЗаполнения.Вставить("ПолноеНаименованиеОрганизации", УправлениеITОтделом8УФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование"));
			СтруктураЗаполнения.Вставить("ОрганизацияПоОКПО", 			СведенияОбОрганизации.КодПоОКПО);
			СтруктураЗаполнения.Вставить("Комментарий",					Шапка.Комментарий);
			СтруктураЗаполнения.Вставить("Основание",					Шапка.Основание);
			
			ОбластьМакета                           = Макет.ПолучитьОбласть("Шапка");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ОбластьМакета                           = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Вывод строк
			ОбластьМакета							= Макет.ПолучитьОбласть("Строка");
			КоличествоИтог							= 0; 				
			СуммаИтог								= 0;
						
			Для Каждого Строка Из ВыборкаСтрокНоменклатуры Цикл							
				ОбластьМакета.Параметры.Заполнить(Строка);
				КоличествоИтог = КоличествоИтог + Строка.Количество;
				СуммаИтог = СуммаИтог + Строка.Сумма;
				ТабличныйДокумент.Вывести(ОбластьМакета);				
			КонецЦикла;
			
			ОбластьМакета	= Макет.ПолучитьОбласть("Итого");			
			СтруктураЗаполнения.Вставить("КоличествоИтог", КоличествоИтог);
			ФорматнаяСтрока = "Л=ru_RU"; 
			ПараметрыПредметаИсчисления = " , , , , , , , , 0"; 			   
			СтруктураЗаполнения.Вставить("КоличествоПрописью", ЧислоПрописью(КоличествоИтог, ФорматнаяСтрока, ПараметрыПредметаИсчисления));
			СтруктураЗаполнения.Вставить("СуммаИтог", СуммаИтог);
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);			
			
			ОбластьМакета	= Макет.ПолучитьОбласть("Подвал");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);	
			
		ИначеЕсли ИмяМакета = "М30" Тогда
			
			Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Списание.ПФ_MXL_М30");			
			ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_Списание_М30";
			
			СтруктураЗаполнения.Вставить("НомерДокумента", 				НомерДокумента);
			СтруктураЗаполнения.Вставить("МестоХранения",  				Шапка.МестоХранения);
			СтруктураЗаполнения.Вставить("ДатаДокумента",				Шапка.ДатаДокумента);
			СтруктураЗаполнения.Вставить("ПолноеНаименованиеОрганизации", УправлениеITОтделом8УФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование"));
			СтруктураЗаполнения.Вставить("Комментарий",					Шапка.Комментарий);
			СтруктураЗаполнения.Вставить("Основание",					Шапка.Основание);
			
			СтруктураЗаполнения.Вставить("СоставКоличество",            СтруктураЗаполнения.КоличествоЧленовКомиссии);
						
			ОбластьМакета                           = Макет.ПолучитьОбласть("Шапка");
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ОбластьМакета                           = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Вывод строк
			ОбластьМакета							= Макет.ПолучитьОбласть("СтрокаТаблицы");
			КоличествоИтог							= 0; 				
			СуммаИтог								= 0;
						
			Для Каждого Строка Из ВыборкаСтрокНоменклатуры Цикл							
				ОбластьМакета.Параметры.Заполнить(Строка);
				КоличествоИтог = КоличествоИтог + Строка.Количество;
				СуммаИтог = СуммаИтог + Строка.Сумма;
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
			КонецЦикла;
			
			ОбластьМакета	= Макет.ПолучитьОбласть("Подвал");			
			СтруктураЗаполнения.Вставить("КоличествоИтог",				КоличествоИтог);
			СтруктураЗаполнения.Вставить("СуммаИтог",					СуммаИтог);
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтруктураЗаполнения);
			ТабличныйДокумент.Вывести(ОбластьМакета);							
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	КонецЦикла;
	
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	ТабличныйДокумент.АвтоМасштаб    = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Сформировать печатные формы объектов
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктСписания") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "АктСписания", НСтр("ru='Акт списания'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "АктСписания"));
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктСписанияОС4") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "АктСписанияОС4", НСтр("ru='Акт списания ОС (ОС-4)'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "АктСписанияОС4"));
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасходнаяНакладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "РасходнаяНакладная", НСтр("ru='Расходная накладная'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "РасходнаяНакладная"));		
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МБ4") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "МБ4", НСтр("ru='Акт выбытия (МБ-4)'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "МБ4"));		
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МБ8") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "МБ8", НСтр("ru='Акт списания (МБ-8)'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "МБ8"));		
	КонецЕсли;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М30") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М30", НСтр("ru='Акт списания (М-30)'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "М30"));		
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

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт	
	
	// Акт списания
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктСписания";
	КомандаПечати.Представление = НСтр("ru = 'Акт списания'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;	
	КомандаПечати.Порядок = 5;
	
	// Акт списания ОС (ОС-4)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктСписанияОС4";
	КомандаПечати.Представление = НСтр("ru = 'Акт списания ОС (ОС-4)'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;	
	КомандаПечати.Порядок = 6;
	
	// Акт выбытия (МБ-4)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "МБ4";
	КомандаПечати.Представление = НСтр("ru = 'Акт выбытия (МБ-4)'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;	
	КомандаПечати.Порядок = 2;
	
	// Акт списания (МБ-8)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "МБ8";
	КомандаПечати.Представление = НСтр("ru = 'Акт списания (МБ-8)'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;	
	КомандаПечати.Порядок = 4;
	
	// Акт списания (М-30)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "М30";
	КомандаПечати.Представление = НСтр("ru = 'Акт списания (М-30)'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;	
	КомандаПечати.Порядок = 3;
	
	// Расходная накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РасходнаяНакладная";
	КомандаПечати.Представление = НСтр("ru = 'Расходная накладная'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;	
	КомандаПечати.Порядок = 7;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли