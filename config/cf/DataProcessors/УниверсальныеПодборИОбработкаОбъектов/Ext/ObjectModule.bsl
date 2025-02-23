﻿Перем мМенеджеры Экспорт;

Функция ПолучитьВидСравнения(Знач ИмяПоля, Знач ВидСравненияОтбора, ИмяПараметра) Экспорт
	Если Лев(ИмяПоля, 6) = "Объект" Тогда
		ИмяПоля = "Ссылка" + Сред(ИмяПоля, 7);
	КонецЕсли;
	
    Если ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Равно  Тогда
		Возврат "_Таблица." + ИмяПоля + " = &" + ИмяПараметра;

	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Больше Тогда
		Возврат "_Таблица." + ИмяПоля + " > &" + ИмяПараметра;
	
	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.БольшеИлиРавно  Тогда
		Возврат "_Таблица." + ИмяПоля + " >= &" + ИмяПараметра;
	
	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВИерархии 
		ИЛИ  ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии Тогда
		Возврат "_Таблица." + ИмяПоля + " В ИЕРАРХИИ (&" + ИмяПараметра + ")";
	
	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке  Тогда
		Возврат "_Таблица." + ИмяПоля + " В (&" + ИмяПараметра + ")";
	
	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Меньше  Тогда
		Возврат "_Таблица." + ИмяПоля + " < &" + ИмяПараметра;
	
	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно  Тогда         
		Возврат "_Таблица." + ИмяПоля + " <= &" + ИмяПараметра;
	
	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.НеВСписке  Тогда
		Возврат "НЕ _Таблица." + ИмяПоля + " В (&" + ИмяПараметра + ")";
	
	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.НеВИерархии 
		ИЛИ ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		Возврат "НЕ _Таблица." + ИмяПоля + " В ИЕРАРХИИ (&" + ИмяПараметра + ")";
	
	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.НеРавно  Тогда
		Возврат "_Таблица." + ИмяПоля + " <> &" + ИмяПараметра;
		
 	ИначеЕсли ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Содержит Тогда
        Возврат "_Таблица." + ИмяПоля + " ПОДОБНО " + """%""+" + "&" + ИмяПараметра + "+""%""";
		
	КонецЕсли; 

КонецФункции // ()

Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",") Экспорт
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр, Поз - 1));
			Стр = СокрЛ(Сред(Стр, Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр, Разделитель);
			Если Поз = 0 Тогда
				Если (СокрЛП(Стр) <> "") Тогда
					МассивСтрок.Добавить(Стр);
				КонецЕсли;
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз - 1));
			Стр = Сред(Стр, Поз + ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции 

Функция ПолучитьСтрокуИзМассиваПодстрок(Массив, Разделитель = ",") Экспорт
	Результат = "";
	Для Каждого Элемент ИЗ Массив Цикл
		Подстрока = ?(ТипЗнч(Элемент) = Тип("Строка"), Элемент, Строка(Элемент));
		РазделительПодстрок = ?(ПустаяСтрока(Результат), "", Разделитель);
		Результат = Результат + РазделительПодстрок + Подстрока;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Процедура ЗагрузитьОбработки(ТекФорма, ДоступныеОбработки2, ВыбранныеОбработки2) Экспорт

	_ДоступныеОбработки = ТекФорма.РеквизитФормыВЗначение("ДоступныеОбработки");
	_ВыбранныеОбработки = ТекФорма.РеквизитФормыВЗначение("ВыбранныеОбработки");
	
	Формы = ЭтотОбъект.Метаданные().Формы;

	Для каждого Форма из Формы Цикл
		Если Форма.Имя = "ПодборИОбработка" 
			ИЛИ Форма.Имя = "ФормаНастроек" 
			ИЛИ Форма.Имя = "ШаблонОбработки" 
			ИЛИ Форма.Имя = "ФормаОтбора" Тогда
			
			Продолжить;
		КонецЕсли;
		НайденнаяСтрока = _ДоступныеОбработки.Строки.Найти(Форма.Имя, "ИмяФормы");
		Если НЕ НайденнаяСтрока = Неопределено Тогда
			Если НЕ НайденнаяСтрока.Обработка = Форма.Синоним Тогда
				НайденнаяСтрока.Обработка = Форма.Синоним;
			КонецЕсли;
				Если НЕ ЭтотОбъект.ПолучитьФорму(Форма.Имя).мИспользоватьНастройки Тогда
					НайденнаяСтрока.Строки.Очистить();
				КонецЕсли;
			Продолжить;
		КонецЕсли;
			
		НоваяОбработка = _ДоступныеОбработки.Строки.Добавить();
		НоваяОбработка.Обработка = Форма.Синоним;
		НоваяОбработка.ИмяФормы  = Форма.Имя;
		
		Настройка = Новый Структура;
		Настройка.Вставить("Обработка", Форма.Синоним);
		Настройка.Вставить("Прочее", Неопределено);
		НоваяОбработка.Настройка.Добавить(Настройка);
	КонецЦикла;

	МассивДляУдаления = Новый Массив;
	
	Для каждого ДоступнаяОбработка из _ДоступныеОбработки.Строки Цикл
		Если Формы.Найти(ДоступнаяОбработка.ИмяФормы) = Неопределено Тогда
			МассивДляУдаления.Добавить(ДоступнаяОбработка);
		КонецЕсли;
	КонецЦикла;

	Для Индекс = 0 по МассивДляУдаления.Количество() - 1 Цикл
		_ДоступныеОбработки.Строки.Удалить(МассивДляУдаления[Индекс]);
	КонецЦикла;

	МассивДляУдаления.Очистить();
	
	Для каждого ВыбраннаяОбработка из _ВыбранныеОбработки Цикл
		Если ВыбраннаяОбработка.СтрокаДоступнойОбработки = Неопределено Тогда
			МассивДляУдаления.Добавить(ВыбраннаяОбработка);
		Иначе
			Если ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель = Неопределено Тогда
				Если _ДоступныеОбработки.Строки.Найти(ВыбраннаяОбработка.СтрокаДоступнойОбработки.ИмяФормы, "ИмяФормы") = Неопределено Тогда
					МассивДляУдаления.Добавить(ВыбраннаяОбработка);
				КонецЕсли;
			Иначе
				Если _ДоступныеОбработки.Строки.Найти(ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель.ИмяФормы, "ИмяФормы") = Неопределено Тогда
					МассивДляУдаления.Добавить(ВыбраннаяОбработка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Для Индекс = 0 по МассивДляУдаления.Количество() - 1 Цикл
		_ВыбранныеОбработки.Удалить(МассивДляУдаления[Индекс]);
	КонецЦикла;
	
	ТекФорма.ЗначениеВРеквизитФормы(_ДоступныеОбработки, "ДоступныеОбработки");
	ТекФорма.ЗначениеВРеквизитФормы(_ВыбранныеОбработки, "ВыбранныеОбработки");

КонецПроцедуры

// Инициализирует переменную мМенеджеры, содержащую соответствия типов объектов их свойствам.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Соответствие, содержащее соответствия типов объектов их свойствам.
// 
Функция ИнициализацияМенеджеров() Экспорт

	Менеджеры = Новый Соответствие;

	ИмяТипа = "Справочник";
	Для каждого ОбъектМД Из Метаданные.Справочники Цикл
		Имя              = ОбъектМД.Имя;
		Менеджер         = Справочники[Имя];
		ТипСсылкиСтрокой = "СправочникСсылка." + Имя;
		ТипСсылки        = Тип(ТипСсылкиСтрокой);
		Структура = Новый Структура("Имя,ИмяТипа,ТипСсылкиСтрокой,Менеджер,ТипСсылки, ОбъектМД", Имя, ИмяТипа, ТипСсылкиСтрокой, Менеджер, ТипСсылки, ОбъектМД);
		Менеджеры.Вставить(ОбъектМД, Структура);
	КонецЦикла;

	ИмяТипа = "Документ";
	Для каждого ОбъектМД Из Метаданные.Документы Цикл
		Имя              = ОбъектМД.Имя;
		Менеджер         = Документы[Имя];
		ТипСсылкиСтрокой = "ДокументСсылка." + Имя;
		ТипСсылки        = Тип(ТипСсылкиСтрокой);
		Структура = Новый Структура("Имя,ИмяТипа,ТипСсылкиСтрокой,Менеджер,ТипСсылки, ОбъектМД", Имя, ИмяТипа, ТипСсылкиСтрокой, Менеджер, ТипСсылки, ОбъектМД);
		Менеджеры.Вставить(ОбъектМД, Структура);
	КонецЦикла;

	Возврат Менеджеры;

КонецФункции // вИнициализацияМенеджеров()

Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	
	//Вид
	//Строка, вид обработки, один из возможных: 
	//"ДополнительнаяОбработка", "ДополнительныйОтчет", "ЗаполнениеОбъекта", "Отчет", "ПечатнаяФорма", "СозданиеСвязанныхОбъектов" 
	ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
	
	//Массив строк имен объектов метаданных в формате: 
	//<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]. 
	//Например, "Документ.СчетЗаказ" или "Справочник.*". 
	//Прим. параметр имеет смысл только для назначаемых обработок, для глобальных может не задаваться. 
	ПараметрыРегистрации.Вставить("Назначение", Новый СписокЗначений);
	
	//Наименование обработки, которым будет заполнено наименование элемента справочника по умолчанию - краткая строка для идентификации обработки администратором 
	ПараметрыРегистрации.Вставить("Наименование", "Универсальный подбор и обработка объектов");
	
	//Версия обработки в формате “<старший номер>.<младший номер>” используется при загрузке обработок в информационную базу. Например “. 
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	
	//Принимает значение Истина или Ложь, в зависимости от того, требуется ли устанавливать или отключать безопасный режим исполнения обработок. Если истина, обработка будет запущена в безопасном режиме. Более подбробно о безопасном режиме в справке к платформе 1С:Предприятие. 
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина);
	
	//Краткая информация по обработке, описание обработки. 
	ПараметрыРегистрации.Вставить("Информация", "");
	
	//Команды, поставляемые обработкой. Таблица значений с колонками: 
	ПараметрыРегистрации.Вставить("Команды", Новый СписокЗначений);
		
	ТаблицаКоманд = ПолучитьТаблицу_Команд();

  	ДобавитьКоманду(ТаблицаКоманд,
          "Универсальный подбор и обработка объектов", 	//Представление
          "Универсальный подбор и обработка объектов",	//Идентификатор
          "ОткрытиеФормы", 				//Использование
          Ложь,					 		//ПоказыватьОповещение
          "");			 				//Модификатор

  	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицу_Команд()

  Команды = Новый ТаблицаЗначений;
  
  //Представление – представление команды в пользовательском интерфейсе;
  Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
  
  //Идентификатор – идентификатор команды; 
  //любая строка, уникальная в пределах данной обработки (отчета). 
  //В случае с обработками печатных форм на основе макета табличного документа передается список макетов, 
  //на основе которых нужно получить печатную форму 
  //(см. описание параметра ИменаМакетов процедуры УправлениеПечатьюКлиент.ВыполнитьКомандуПечати в разделе Печать). 
  Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
  
  //"ОткрытиеФормы" – открыть форму обработки; 
  //"ВызовКлиентскогоМетода" – вызвать клиентскую экспортную процедуру из модуля формы обработки; 
  //"ВызовСерверногоМетода" – вызвать серверную экспортную процедуру из модуля объекта обработки.
  Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
 	
  //ПоказыватьОповещение – если Истина, требуется показать оповещение при начале и при завершении работы обработки. 
  //Имеет смысл только при запуске обработки без открытия формы. 
  Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
  
  //Модификатор – дополнительный модификатор команды. 
  //Используется для дополнительных обработок печатных форм на основе табличных макетов, 
  //для таких команд должен содержать строку ПечатьMXL (см. пример в демонстрационной конфигурации).
  Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
  
  Возврат Команды;
           
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")

  НоваяКоманда = ТаблицаКоманд.Добавить();
  НоваяКоманда.Представление = Представление;
  НоваяКоманда.Идентификатор = Идентификатор;
  НоваяКоманда.Использование = Использование;
  НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
  НоваяКоманда.Модификатор = Модификатор;

КонецПроцедуры

мМенеджеры = ИнициализацияМенеджеров();