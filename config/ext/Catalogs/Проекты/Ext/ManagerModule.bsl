﻿
//++ Горохов И. 23.04.21
&Вместо("УсловияПравилаСобытий")
Функция РСК_УсловияПравилаСобытий()
	
	СоответствиеИзменениеОбъекта     = Новый Соответствие;
	СоответствиеИзменениеОбъекта.Вставить("СправочникПроектыИзменениеОбъектаСменаРуководителя", 
		НСтр("ru = 'Изменение руководителя проекта'"));
	СоответствиеПериодическоеСобытие = Новый Соответствие;
	
	СоответствиеРасчетМетрик = Новый Соответствие;
	СоответствиеРасчетМетрик.Вставить("ПроектыРасчетМетрикЗаписьЭлемента", НСтр("ru = 'Запись элемента'"));

	Соответствие = Новый Соответствие;
	Соответствие.Вставить("СоответствиеИзменениеОбъекта", 	  СоответствиеИзменениеОбъекта);
	Соответствие.Вставить("СоответствиеПериодическоеСобытие", СоответствиеПериодическоеСобытие);
	Соответствие.Вставить("СоответствиеРасчетМетрик", 		  СоответствиеРасчетМетрик);
	
	Возврат Соответствие;
КонецФункции


Функция ПроверкаУсловияПравилаСобытия(Знач ПравилоСобытия, Знач Структура = Неопределено, 
		Знач Источник = Неопределено) Экспорт
		
		ИмяСобытия = ПравилоСобытия.ПроверкаРеквизитовОбъектаИмяУсловия;
		
		Если ПравилоСобытия.ТипПравила = Перечисления.ТипыПравилСобытий.ИзменениеОбъекта Тогда 
			
			Результат = Ложь;		
			
			Если Структура.ЭтоНовый Тогда
				
				Результат = Истина;
				
			Иначе
				ИсточникПередЗаписью 	= Структура.ИсточникПередЗаписью;			
				Если ИмяСобытия = "СправочникПроектыИзменениеОбъектаСменаРуководителя" Тогда
					Если НЕ ИсточникПередЗаписью.РуководительПроекта = Источник.РуководительПроекта тогда
						Результат = Истина;	
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;	
			
			Возврат Результат;
			
		КонецЕсли;
	
	КонецФункции

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
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", 
//         		mxl" и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
	НовыйРеквизит = Реквизиты.Добавить();
	НовыйРеквизит.Имя = "Проект_Наименование";
	НовыйРеквизит.Представление = НСтр("ru = 'Наименование Проекта'");
	НовыйРеквизит.Тип = Новый ОписаниеТипов("Строка");	
	
	НовыйРеквизит = Реквизиты.Добавить();
	НовыйРеквизит.Имя = "Проект_РуководительПроекта";
	НовыйРеквизит.Представление = НСтр("ru = 'Руководитель проекта'");
	НовыйРеквизит.Тип = Новый ОписаниеТипов("Строка");
	
	НовыйРеквизит = Реквизиты.Добавить();
	НовыйРеквизит.Имя = "Проект_Клиент";
	НовыйРеквизит.Представление = НСтр("ru = 'Клиент'");
	НовыйРеквизит.Тип = Новый ОписаниеТипов("Строка");
	

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
	
	Попытка	
		Сообщение.ЗначенияРеквизитов["Проект_Наименование"]			= ПредметСообщения.Владелец.Наименование;
		Сообщение.ЗначенияРеквизитов["Проект_РуководительПроекта"]	= Строка(ПредметСообщения.Владелец.РуководительПроекта);
		Сообщение.ЗначенияРеквизитов["Проект_Клиент"]				= Строка(ПредметСообщения.Владелец.Клиент);
	Исключение
		Сообщение.ЗначенияРеквизитов["Проект_Наименование"]			= "";
		Сообщение.ЗначенияРеквизитов["Проект_РуководительПроекта"]	= "";
		Сообщение.ЗначенияРеквизитов["Проект_Клиент"]				= "";
	КонецПопытки;	
	
	Сообщение.Вставить("Предмет", ПредметСообщения);	
	
	// Внешняя ссылка. 
	Если Сообщение.ЗначенияРеквизитов.Получить("ВнешняяСсылкаНаОбъект") <> Неопределено Тогда
		ЗначениеВнешнейСсылки = Сообщение.ЗначенияРеквизитов.Получить("ВнешняяСсылкаНаОбъект");
		ТекстЗаголовка = "Проект " + Строка(ПредметСообщения.Наименование) + " от "
						+ Строка(Формат(ПредметСообщения.ДатаНачала, "ДФ=dd.MM.yy"));			
		Сообщение.ЗначенияРеквизитов["ВнешняяСсылкаНаОбъект"] = 
			"<a href=" + Строка(ЗначениеВнешнейСсылки) + ">" + ТекстЗаголовка + "</a></p>";
	КонецЕсли;
	
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
//@skip-warning
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
//@skip-warning
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт	
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ШаблоныСообщений


//--
