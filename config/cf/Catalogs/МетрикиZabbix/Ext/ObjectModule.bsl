﻿
// Выполнение запроса метрики
// 
// Параметры:
//  ДополнительныеПараметры - Структура - дополнительные параметры метрики, полученные из JSON-а.
//
// Возвращаемое значение
//  СтруктураОтвета - Структура - структура с итоговым результатом по метрике.
//
Функция ВыполнитьЗапрос(ДополнительныеПараметры = Неопределено) Экспорт
	
	Попытка
		СтруктураОтветаПоМетрике = Новый Структура;
		ТипВходящейОперации = ТипВходящейОперации;
		ТипыОпераций = Перечисления.ТипВходящейОперации;
		
		Если ТипВходящейОперации = ТипыОпераций.Запрос Тогда
		 	ВыполнитьЗапросБезПостОбработки(СтруктураОтветаПоМетрике, ДополнительныеПараметры);
		ИначеЕсли ТипВходящейОперации = ТипыОпераций.ИсполняемыйКодИЗапрос Тогда
			ВыполнитьЗапросСПостОбработкой(СтруктураОтветаПоМетрике, ДополнительныеПараметры);
		ИначеЕсли ТипВходящейОперации = ТипыОпераций.ИсполняемыйКод Тогда
			ВыполнитьКод(СтруктураОтветаПоМетрике);
		Иначе
			СтруктураОтветаПоМетрике.Вставить("Error" + КлючМетрики, "Тип операции не обнаружен");
		КонецЕсли;
		
	Исключение
		СтруктураОтветаПоМетрике.Вставить("Error" + КлючМетрики, ОписаниеОшибки());	
	КонецПопытки;
	
	Возврат СтруктураОтветаПоМетрике;
	
КонецФункции

// Выполненяет код метрики.
// 
// Параметры:
//  СтруктураОтветаПоМетрике - Структура - структура, куда будет записано полученное значение.
//  РезультатОтветаПоМетрике - ТаблицаЗначений - таблица значений, откуда будут получены данные.
//  						   Используется при проведении постобработки запроса. 
//
Процедура ВыполнитьКод(СтруктураОтветаПоМетрике, РезультатОтветаПоМетрике = Неопределено)
	
	Попытка
		Выполнить(ИсполняемыйКод)
	Исключение
		СтруктураОтветаПоМетрике.Вставить("Error" + КлючМетрики, ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры

// Выполненяет запрос без постобработки.
// 
// Параметры:
//  ДополнительныеПараметры - Структура - дополнительные параметры метрики, полученные из JSON-а.
//  СтруктураОтвета - Структура - структура, в которую будет записано полученное значение.
//
Процедура ВыполнитьЗапросБезПостОбработки(СтруктураОтветаПоМетрике, ДополнительныеПараметры) 
	
	РезультатЗапроса = ВыполнитьЗапросКБазе(ДополнительныеПараметры);
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	СтруктураОтветаПоМетрике = СтруктураИзВыборки(Выборка);
	
КонецПроцедуры

// Выполненяет запрос с последующей обработкой.
// 
// Параметры:
//  ДополнительныеПараметры - Структура - дополнительные параметры метрики, полученные из JSON-а.
//  СтруктураОтвета - Структура - структура, в которую будет записано полученное значение.
//
Процедура ВыполнитьЗапросСПостОбработкой(СтруктураОтветаПоМетрике, ДополнительныеПараметры)
	
	РезультатЗапроса = ВыполнитьЗапросКБазе(ДополнительныеПараметры);
	РезультатОтветаПоМетрике = РезультатЗапроса.Выгрузить();
	ВыполнитьКод(СтруктураОтветаПоМетрике, РезультатОтветаПоМетрике);
		
КонецПроцедуры

// Формирование и выполнение запроса.
//  
// Параметры:
//  ДополнительныеПараметры - Структура - дополнительные параметры метрики, полученные из переданного JSON-а.
//
// Возвращаемое значение
//  РезультатОтветаПоМетрике - РезультатЗапроса - результат выполнения запроса.
//
Функция ВыполнитьЗапросКБазе(ДополнительныеПараметры) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	ПодготовитьПараметры(Запрос, ДополнительныеПараметры);
	РезультатОтветаПоМетрике = Запрос.Выполнить();
	Возврат РезультатОтветаПоМетрике;
	
КонецФункции

// Подготавливает и устанавливает параметры запроса.
// 
// Параметры: 
// 	Запрос - Запрос - выполняемый запрос
//  ДополнительныеПараметры - Структура - дополнительные параметры метрики, полученные из переданного JSON-а.
//  
Процедура ПодготовитьПараметры(Запрос, ДополнительныеПараметры)

	Для Каждого ПараматерЗапроса ИЗ ПараметрыЗапроса Цикл
		ИмяЗапроса = ПараматерЗапроса.Имя;
		ЗначениеПараметра = "";
		Если ПараматерЗапроса.ЭтоСписок Тогда
			ЗначениеПараметра = СформироватьСписокЗначений(ИмяЗапроса);
		ИначеЕсли НЕ ПустаяСтрока(ПараматерЗапроса.Выражение) Тогда
			Выполнить(ПараматерЗапроса.Выражение);
		Иначе
			ЗначениеПараметра = ПараматерЗапроса.Значение;
		КонецЕсли;
		Запрос.УстановитьПараметр(ИмяЗапроса, ЗначениеПараметра);
	КонецЦикла;
	
	Если ДополнительныеПараметры <> Неопределено Тогда	
		Для Каждого ДопПараметр Из ДополнительныеПараметры Цикл
			Запрос.УстановитьПараметр(ДопПараметр.Ключ, ДопПараметр.Значение);	
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

// Формирует список значений переданного параметра.
//  
// Параметры:
//  ИмяПараметра - Строка - имя параметра, списочное значение которого необходимо получить.
//
// Возвращаемое значение
//  СписокЗначений - СписокЗначений - список значений параметра.
//
Функция СформироватьСписокЗначений(ИмяПараметра) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МетрикиZabbixЗначенияСписочныхПараметров.Значение КАК Значение
		|ИЗ
		|	Справочник.МетрикиZabbix.ЗначенияСписочныхПараметров КАК МетрикиZabbixЗначенияСписочныхПараметров
		|ГДЕ
		|	МетрикиZabbixЗначенияСписочныхПараметров.ИмяПараметра = &ИмяПараметра
		|	И МетрикиZabbixЗначенияСписочныхПараметров.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ИмяПараметра", ИмяПараметра);
	
	РезультатЗапроса = Запрос.Выполнить();
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Значение"));
	Возврат СписокЗначений;	
	
КонецФункции

# Область Служебные_функции

// Формирование структуры из выборки. Служебная функция.
// 
// Параметры:
//  Выборка - Выборка - выборка значений.
//
// Возвращаемое значение
//  СтруктураОтвета - Структура - структура.
//
Функция СтруктураИзВыборки(Выборка)
	
	Результат = Новый Структура;
	Для каждого Колонка Из Выборка.Владелец().Колонки Цикл
		Результат.Вставить(Колонка.Имя);
	КонецЦикла;
	ЗаполнитьЗначенияСвойств(Результат, Выборка);
	Возврат Результат;
	
КонецФункции

#КонецОбласти
