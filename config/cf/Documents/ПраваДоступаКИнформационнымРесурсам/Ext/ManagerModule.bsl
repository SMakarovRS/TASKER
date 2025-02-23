﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс
// Функция возвращает список имен «ключевых» реквизитов.
// Возвращаемое значение:
//  Массив - массив блокируемых реквизитов.
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

// Возвращает список реквизитов, которые разрешается редактировать,
// с помощью обработки группового изменения объектов.
//
// Возвращаемое значение:
//  Массив - массив редактируемых реквизитов.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	РедактируемыеРеквизиты = Новый Массив;
		
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;

	Результат  	  = Новый Массив;
	ТаблицаДоступ = Ссылка.Доступ;
	Если ТаблицаДоступ.Количество() > 0 Тогда 
		Для Каждого СтрокаТаблицы Из ТаблицаДоступ Цикл
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
	
	РеквизитПоложениеСотрудника  	  = Реквизиты.Найти("ПраваДоступаКИнформационнымРесурсам.ПоложениеСотрудника");
	Реквизиты.Удалить(РеквизитПоложениеСотрудника);
	
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
	СоответствиеИзменениеОбъекта.Вставить("ПраваДоступаКИнформационнымРесурсамИзменениеОбъектаПроведение", НСтр("ru = 'Проведение'"));
	
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
	
	Если ИмяСобытия = "ПраваДоступаКИнформационнымРесурсамИзменениеОбъектаПроведение" Тогда
		
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
	
	СтруктураЗаполнения = Новый Структура;
	ТабличныйДокумент   = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ДоступСотрудниковКИнформационнымРесурсам";
	
	ПервыйДокумент = Истина;
	
	Для каждого ТекущийДокумент Из МассивОбъектов Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СтруктураЗаполнения = УправлениеITОтделом8УФ.СтруктураЗаполненияПечатнойФормы(ТекущийДокумент);
		
		// СЮДА ФОРМИРОВВНИЕ ПЕЧАТНОЙ ФОРМЫ
		Запрос = Новый Запрос();
		
		Запрос.УстановитьПараметр("ТекущийДокумент", 	ТекущийДокумент);
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПраваДоступаКИнформационнымРесурсам.Ссылка,
			|	ПраваДоступаКИнформационнымРесурсам.ВерсияДанных,
			|	ПраваДоступаКИнформационнымРесурсам.ПометкаУдаления,
			|	ПраваДоступаКИнформационнымРесурсам.Номер,
			|	ПраваДоступаКИнформационнымРесурсам.Дата,
			|	ПраваДоступаКИнформационнымРесурсам.Проведен,
			|	ПраваДоступаКИнформационнымРесурсам.Организация,
			|	ПраваДоступаКИнформационнымРесурсам.Автор,
			|	ПраваДоступаКИнформационнымРесурсам.ДатаСоздания,
			|	ПраваДоступаКИнформационнымРесурсам.АвторКорректировки,
			|	ПраваДоступаКИнформационнымРесурсам.ДатаКорректировки,
			|	ПраваДоступаКИнформационнымРесурсам.Комментарий,
			|	ПраваДоступаКИнформационнымРесурсам.Основание,
			|	ПраваДоступаКИнформационнымРесурсам.Сотрудник,
			|	ПраваДоступаКИнформационнымРесурсам.ПоложениеСотрудника,
			|	ПраваДоступаКИнформационнымРесурсам.ИнициаторПредоставленияДоступа,
			|	ПраваДоступаКИнформационнымРесурсам.СписокСотрудников,
			|	ПраваДоступаКИнформационнымРесурсам.Подразделение
			|ИЗ
			|	Документ.ПраваДоступаКИнформационнымРесурсам КАК ПраваДоступаКИнформационнымРесурсам
			|ГДЕ
			|	ПраваДоступаКИнформационнымРесурсам.Ссылка = &ТекущийДокумент";
		
		РезультатЗапроса	= Запрос.Выполнить();
		
		Шапка 				= РезультатЗапроса.Выбрать();
		Шапка.Следующий();
		
		ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПраваДоступаКИнформационнымРесурсам_ПФ_MXL_ПраваДоступа";
		
		Макет 				= УправлениеПечатью.МакетПечатнойФормы("Документ.ПраваДоступаКИнформационнымРесурсам.ПФ_MXL_ПраваДоступа");
		ОбластьШапка		= Макет.ПолучитьОбласть("Шапка");
		ОбластьШапкаТаблицы	= Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОбластьСтрокаТаблицы= Макет.ПолучитьОбласть("СтрокаТаблицы");
		ОбластьПодвал		= Макет.ПолучитьОбласть("Подвал");
		
		ОбластьШапка.Параметры.Заполнить(Шапка);
		
		СведенияОбОрганизации = УправлениеITОтделом8УФ.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата, ,);
		
		ОбластьШапка.Параметры.Заполнить(Новый Структура("НомерДата", "№" + ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер, Истина, Истина) + " от " + Формат(Шапка.Дата, "ДЛФ=DD")));
		ОбластьШапка.Параметры.Заполнить(Новый Структура("ПолноеНаименованиеОрганизации", УправлениеITОтделом8УФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование")));
		ОбластьШапка.Параметры.Заполнить(Новый Структура("ДатаИВремяПечати", ТекущаяДатаСеанса()));
		ОбластьШапка.Параметры.Заполнить(Новый Структура("СамДокумент", ТекущийДокумент));
		
		СведенияОбОрганизации = УправлениеITОтделом8УФ.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата, ,);
		ОбластьШапка.Параметры.Заполнить(Новый Структура("ПредставлениеОрганизации", УправлениеITОтделом8УФ.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет")));
		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, СтруктураЗаполнения);
		ТабличныйДокумент.Вывести(ОбластьШапка);
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
		
		ПоследнийСотрудник	= Справочники.Сотрудники.ПустаяСсылка();
		
		ТЧДоступ	= Шапка.Ссылка.Доступ.Выгрузить();
		ТЧПрава		= Шапка.Ссылка.Права.Выгрузить();
		ТЧДоступ.Сортировать("Сотрудник,ВидДоступа");
		ТЧПрава.Сортировать("ПраваДоступа");
		нн			= 1;
		
		Для Каждого Строки Из ТЧДоступ Цикл
			
			ПраваСтрокой = "";		
			НайденныеПрава = ТЧПрава.НайтиСтроки(Новый Структура("Ключ, Разрешено", Строки.Ключ, Истина));
			Для Каждого Права Из НайденныеПрава Цикл
				
				Если НЕ ПустаяСтрока(ПраваСтрокой) Тогда
					ПраваСтрокой = ПраваСтрокой + ", ";
				КонецЕсли;
				ПраваСтрокой = ПраваСтрокой + Строка(Права.ПраваДоступа);
				
			КонецЦикла;
			
			ОбластьСтрокаТаблицы.Параметры.Заполнить(Строки);
			ОбластьСтрокаТаблицы.Параметры.Заполнить(Новый Структура("ПраваСтрокой,нн", ПраваСтрокой, нн));
			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
			нн = нн + 1;
			
		КонецЦикла;
				
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
		ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, СтруктураЗаполнения);
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
	КонецЦикла;
	
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ДоступСотрудников") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ДоступСотрудников", НСтр("ru='Доступ сотрудников'"), ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "ДоступСотрудников"));
	КонецЕсли;
		
КонецПроцедуры

// Функция получает данные печати по документу.
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
	
	// Акт ввода в эксплуатацию
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ДоступСотрудников";
	КомандаПечати.Представление = НСтр("ru = 'Доступ сотрудников'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;	
	КомандаПечати.Порядок = 0;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли