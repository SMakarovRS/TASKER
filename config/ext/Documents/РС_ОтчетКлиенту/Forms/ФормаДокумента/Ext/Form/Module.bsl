﻿
// СтандартныеПодсистемы.Печать 
&НаКлиенте 
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда) 
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект); 
КонецПроцедуры 

//++Горохов 01.04.21

&НаКлиенте
Процедура ПроверитьЗаказы(Команда) Экспорт
	Если Элементы.ПроверитьЗаказ.Заголовок = "" тогда
		ПроверитьЗаказыНаСервере();
	ИначеЕсли Элементы.ПроверитьЗаказ.Заголовок = "Повторное подключение к УНФ" Тогда
		Попытка
			WS = УстановитьСоединениеСWebСервисомUNF();
			ПроверитьЗаказыНаСервере();
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	Иначе
		ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьЗаказ", ЭтотОбъект);
		СписокВыбора = Новый СписокЗначений;
		СписокВыбора.Добавить("Одной строкой");
		СписокВыбора.Добавить("Детально");
		СписокВыбора.Добавить("Отмена");
		ПоказатьВопрос(ОписаниеОповещения, "Выберите способ заполнения заказа:", СписокВыбора, , "Одной строкой"); 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаказ(Результат, Параметры) Экспорт
	Если Результат = "Отмена" Тогда
		Возврат;
	КонецЕсли;
	
	
	// создание массива
	Массив = Новый Массив;
	Массив.Добавить(Объект.Ссылка);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СсылкаНаОбъект", Массив);
	ПараметрыФормы.Вставить("СоздатьЗаказПар",Истина);
	ПараметрыФормы.Вставить("ТипОбработки", Результат);
	
	// окончание создания массива
	
	Попытка
		ОткрытьФорму("Отчет.РС_ОтчетКлиенту.Форма", ПараметрыФормы);
		//Элементы.ПроверитьЗаказ.Видимость = Ложь;
		ПроверитьЗаказыНаСервере();
	Исключение
		Элементы.ПроверитьЗаказ.Заголовок = "Создать заказ";
		Элементы.ПроверитьЗаказ.Видимость = Истина;
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаказыНаСервере(Кнопка = Неопределено) Экспорт
	
	//СтатусСчета = Объект.СтатусОтчета = Справочники.РС_СтатусыОтчетовКлиенту.Оплачен Или Объект.СтатусОтчета = Справочники.РС_СтатусыОтчетовКлиенту.ВыставленСчет ИЛИ Объект.СтатусОтчета = Справочники.РС_СтатусыОтчетовКлиенту.НеТребуется;

	//Если СтатусСчета тогда     //п
	//	Элементы.ПроверитьЗаказ.Заголовок = "Создать заказ";
	//	Элементы.ЗаполнитьРеквизиты.Доступность = Ложь;
	//	Возврат;	
	//КонецЕсли;

	СсылкаНаЗаказ.Очистить();
	УдалитьДинамическиеЭлементы();
	Попытка
		WS = УстановитьСоединениеСWebСервисомUNF();
		СписокЗаказов = WS.ПроверитьЗаказы(Строка(Объект.Номер +";"+ Строка(Объект.Дата)));
		Если НЕ ЗначениеЗаполнено(СписокЗаказов) Тогда
			Элементы.ПроверитьЗаказ.Заголовок = "Создать заказ";
			Элементы.ЗаполнитьРеквизиты.Доступность = Ложь;
		Иначе
			Элементы.ПроверитьЗаказ.Заголовок = "Проверить заказы";
			Элементы.ЗаполнитьРеквизиты.Доступность = Истина;
			СписокЗаказов = Десериализовать(СписокЗаказов);
			Сч = 1;
			Если СписокЗаказов.Количество() = 1 тогда
				Если ЗначениеЗаполнено(Кнопка) тогда
					ЗаполнитьРеквизитыСчетов(СписокЗаказов);
					ЦенаПоДоговору = СписокЗаказов[0].Цена;
					Если ЗначениеЗаполнено(ЦенаПоДоговору) тогда
						Элементы.ЦенаПоДоговору.Видимость = ИСТИНА;		
					КонецЕсли;
				Иначе
					Если СверитьРеквизитыИзУНФ(СписокЗаказов) тогда
						Если Объект.СтатусОтчета = Справочники.РС_СтатусыОтчетовКлиенту.ВыставленСчет ИЛИ Объект.СтатусОтчета = Справочники.РС_СтатусыОтчетовКлиенту.Оплачен ИЛИ Объект.СтатусОтчета = Справочники.РС_СтатусыОтчетовКлиенту.НайтиПоКоду("000000010") тогда
							//ЗаполнитьРеквизитыСчетов(СписокЗаказов);
							Сообщить("Счет/акт отличается от найденного в УНФ.");
						КонецЕсли;
					КонецЕсли;
					ЦенаПоДоговору = СписокЗаказов[0].Цена;
					Если ЗначениеЗаполнено(ЦенаПоДоговору) тогда
						Элементы.ЦенаПоДоговору.Видимость = ИСТИНА;		
					КонецЕсли;
					Элементы.ЗаполнитьРеквизиты.Доступность = Истина;
					//Иначе
					//	//Сообщить("Заполненные реквизиты счета/акта отличаются от имеющихся в УНФ. Реквизиты не обновлены");
					//КонецЕсли;	
				КонецЕсли;	
			КонецЕсли;
			
			Для Каждого Строка Из СписокЗаказов Цикл 
				СтрокаСсылки = СсылкаНаЗаказ.Добавить();
				СтрокаСсылки.НавСсылка = Строка.СсылкаЗаказ;
				НовыйЭлемент = Элементы.Вставить("Заказ"+Сч, Тип("ДекорацияФормы"), Элементы.ГруппаШапка);
				НовыйЭлемент.Вид = ВидДекорацииФормы.Надпись;
				НовыйЭлемент.Заголовок = "Заказ №"+Строка.НомерЗаказа+" от "+Строка.ДатаЗаказа;
				НовыйЭлемент.Гиперссылка = Истина;
				НовыйЭлемент.УстановитьДействие("Нажатие","НажатиеЗаказ");
				Сч = Сч+1;	
			КонецЦикла;
			Элементы.ПроверитьЗаказ.Видимость = Ложь;
		КонецЕсли;
	Исключение
		Элементы.ПроверитьЗаказ.Заголовок = "Повторное подключение к УНФ";
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

Функция СчетАктЗаполнены()
	Если ЗначениеЗаполнено(Объект.НомерСчета) И ЗначениеЗаполнено(Объект.НомерСчета) тогда
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Процедура ЗаполнитьРеквизитыСчетов(СписокЗаказов)
	Объект.НомерСчета = СписокЗаказов[0].НомерЗаказа;
	Объект.ДатаСчета = КонвертироватьДату(СписокЗаказов[0].ДатаЗаказа);
	Объект.НомерАкта = СписокЗаказов[0].НомерАкта;
	Объект.ДатаАкта = КонвертироватьДату(СписокЗаказов[0].ДатаАкта);
	ЭтотОбъект.Модифицированность = Истина;
КонецПроцедуры

Функция СверитьРеквизитыИзУНФ(СписокЗаказов)
	Если НЕ ЗначениеЗаполнено(Объект.НомерАкта) ИЛИ НЕ ЗначениеЗаполнено(Объект.НомерСчета) Тогда
		Возврат ИСТИНА;
	Иначе
		Если Объект.НомерАкта = СписокЗаказов[0].НомерАкта И Объект.НомерСчета = СписокЗаказов[0].НомерЗаказа И Объект.ДатаСчета = КонвертироватьДату(СписокЗаказов[0].ДатаЗаказа) И Объект.ДатаАкта = КонвертироватьДату(СписокЗаказов[0].ДатаАкта) тогда
			Возврат ЛОЖЬ;
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
КонецФункции

Функция КонвертироватьДату(СтрДата)
	Если ЗначениеЗаполнено(СтрДата) тогда
		МассивЗнач = СтрРазделить(СтрДата, ".");
		Возврат Дата(МассивЗнач[2] + МассивЗнач[1] + МассивЗнач[0]);
	КонецЕсли;	
КонецФункции

Процедура УдалитьДинамическиеЭлементы()
	Повтор = Ложь;
	пЭлементыФормы = Этаформа.Элементы;
	Для каждого пЭлементФормы из пЭлементыФормы цикл
		Если СтрНачинаетсяС(пЭлементФормы.Имя,"Заказ") Тогда
			пЭлементыФормы.Удалить(пЭлементФормы);
			Повтор = Истина;
		Конецесли;
	Конеццикла;
	Если Повтор Тогда
		УдалитьДинамическиеЭлементы();		
	КонецЕсли;
КонецПроцедуры

Функция УстановитьСоединениеСWebСервисомUNF() Экспорт
	Попытка
		ВСОпределение = Новый WSОпределения("http://192.168.88.38/UNFRS/ws/CreateDock.1cws?wsdl","WS","капитал");
		//ВСОпределение = Новый WSОпределения("http://192.168.12.231:8080/UNFRS/ws/CreateDock.1cws?wsdl","WS","капитал");
	Исключение
		ВСОпределение = Новый WSОпределения("http://192.168.88.38/UNFRS/ws/CreateDock.1cws?wsdl","WS","капитал");
	Конецпопытки;
	ВСПрокси = Новый WSПрокси(ВСОпределение, "http://rscons.unf.ru", "СозДок_WebDock", "СозДок_WebDockSoap");
	ВСПрокси.Пользователь = "WS";
	ВСПрокси.Пароль = "капитал";
	Возврат ВСПрокси;                                    
КонецФункции // УстановитьСоединениеСWebСервисом()

Функция Десериализовать(Данные, ТипПреобразования = Неопределено) Экспорт
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Данные);
	ПрочитанныеДанные = СериализаторXDTO.ПрочитатьXML(ЧтениеXML, ТипПреобразования);
	ЧтениеXML.Закрыть();
	Возврат ПрочитанныеДанные;	
КонецФункции // Десериализовать()

&НаСервере
Функция ПолучитьСсылкуНаОбработку(АдресХранилища)
	Возврат ВнешниеОтчеты.Подключить(АдресХранилища,,ложь);
КонецФункции

&НаКлиенте
Процедура ОпроситьУНФ()
	ПроверитьЗаказыНаСервере();			
КонецПроцедуры

&НаКлиенте
Процедура РСК_ПриОткрытииПосле(Отказ)
	Если СчетАктЗаполнены() тогда	
		//ПодключитьОбработчикОжидания("ОпроситьУНФ", 0.5, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РСК_ЗаполнитьРеквизитыУНФВместо(Команда)
	ПроверитьЗаказыНаСервере(Истина);
КонецПроцедуры

&НаКлиенте
Процедура РСК_СтатусОтчетаПриИзмененииПосле(Элемент)
	ЗаполнитьСумму();
КонецПроцедуры

Процедура ЗаполнитьСумму()
	Если Объект.СтатусОтчета = Справочники.РС_СтатусыОтчетовКлиенту.Оплачен тогда
		Объект.СуммаОплаты = Объект.ВсегоКОплатеЗакрытые * ЦенаПоДоговору;
	Иначе
		Объект.СуммаОплаты = 0;
	КонецЕсли;
КонецПроцедуры

//--


//&НаСервере
//&Вместо("ОбновитьДеревоЗначений")
//Процедура РСК_ОбновитьДеревоЗначений()
//	// Вставить содержимое метода.

//	СписокЗанятостейДерево = РеквизитФормыВЗначение("СписокЗанятостейЗакрытые");
//	СписокЗанятостейДерево.Строки.Очистить();
//	
//	СписокНезакрытыхЗанятостейДерево = РеквизитФормыВЗначение("СписокЗанятостейНезакрытые");
//	СписокНезакрытыхЗанятостейДерево.Строки.Очистить();
//	
//	СтрОбхода = Новый Структура("СписокЗанятостейЗакрытые,СписокЗанятостейНезакрытые", СписокЗанятостейДерево, СписокНезакрытыхЗанятостейДерево);
//	
//	Запрос = Новый Запрос( 
//	"ВЫБРАТЬ
//	|	СписокЗанятостейЗакрытые.Занятость КАК Занятость,
//	|	СписокЗанятостейЗакрытые.ФактическоеВремя КАК ФактическоеВремя,
//	|	СписокЗанятостейЗакрытые.ВремяКлиента КАК ВремяКлиента,
//	|	СписокЗанятостейЗакрытые.КОплате КАК КОплате,
//	|	ИСТИНА КАК Закрытые
//	|ПОМЕСТИТЬ ВтТаблицаДвиженийЗакрытые
//	|ИЗ
//	|	&СписокЗанятостейЗакрытые КАК СписокЗанятостейЗакрытые
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	СписокЗанятостейНезакрытые.Занятость КАК Занятость,
//	|	СписокЗанятостейНезакрытые.ФактическоеВремя КАК ФактическоеВремя,
//	|	СписокЗанятостейНезакрытые.ВремяКлиента КАК ВремяКлиента,
//	|	СписокЗанятостейНезакрытые.КОплате КАК КОплате,
//	|	ЛОЖЬ КАК Закрытые
//	|ПОМЕСТИТЬ ВтТаблицаДвиженийНезакрытые
//	|ИЗ
//	|	&СписокЗанятостейНезакрытые КАК СписокЗанятостейНезакрытые
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	ВтТаблицаДвиженийЗакрытые.Занятость КАК Занятость,
//	|	ВтТаблицаДвиженийЗакрытые.ФактическоеВремя КАК ФактическоеВремя,
//	|	ВтТаблицаДвиженийЗакрытые.ВремяКлиента КАК ВремяКлиента,
//	|	ВтТаблицаДвиженийЗакрытые.КОплате КАК КОплате,
//	|	ВтТаблицаДвиженийЗакрытые.Закрытые КАК Закрытые
//	|ПОМЕСТИТЬ ВтТаблицаДвижений
//	|ИЗ
//	|	ВтТаблицаДвиженийЗакрытые КАК ВтТаблицаДвиженийЗакрытые
//	|
//	|ОБЪЕДИНИТЬ ВСЕ
//	|
//	|ВЫБРАТЬ
//	|	ВтТаблицаДвиженийНезакрытые.Занятость,
//	|	ВтТаблицаДвиженийНезакрытые.ФактическоеВремя,
//	|	ВтТаблицаДвиженийНезакрытые.ВремяКлиента,
//	|	ВтТаблицаДвиженийНезакрытые.КОплате,
//	|	ВтТаблицаДвиженийНезакрытые.Закрытые
//	|ИЗ
//	|	ВтТаблицаДвиженийНезакрытые КАК ВтТаблицаДвиженийНезакрытые
//	|
//	|ИНДЕКСИРОВАТЬ ПО
//	|	Занятость
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	дЗадание.Ссылка КАК Задание,
//	|	дЗадание.Проект КАК Проект,
//	|	дЗадание.СогласованоЧасов КАК ВремяСогласовано,
//	|	дЗадание.ДатаКорректировки КАК ДатаКорректировки,
//	|	дЗадание.ДатаВыполнения КАК ДатаВыполнения,
//	|	дЗадание.ДатаЗавершения КАК ДатаЗавершения,
//	|	дЗадание.Тема КАК Тема,
//	|	РС_Занятость.Ссылка КАК Занятость,
//	|	РС_Занятость.Исполнитель КАК Исполнитель,
//	|	РС_Занятость.Описание КАК Описание,
//	|	ВтТаблицаДвижений.ФактическоеВремя КАК ВремяФакт,
//	|	ВтТаблицаДвижений.ВремяКлиента КАК ВремяКлиента,
//	|	ВтТаблицаДвижений.КОплате КАК ВремяКОплате
//	|ИЗ
//	|	ВтТаблицаДвижений КАК ВтТаблицаДвижений
//	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РС_Занятость КАК РС_Занятость
//	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Задание КАК дЗадание
//	|			ПО РС_Занятость.Задание = дЗадание.Ссылка
//	|		ПО ВтТаблицаДвижений.Занятость = РС_Занятость.Ссылка
//	|			И (ВтТаблицаДвижений.Закрытые)
//	|
//	|УПОРЯДОЧИТЬ ПО
//	|	Проект,
//	|	Задание,
//	|	Занятость
//	|ИТОГИ
//	|	МАКСИМУМ(ВремяСогласовано),
//	|	МАКСИМУМ(Тема),
//	|	СУММА(ВремяФакт),
//	|	СУММА(ВремяКлиента),
//	|	СУММА(ВремяКОплате)
//	|ПО
//	|	Проект,
//	|	Задание
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	дЗадание.Ссылка КАК Задание,
//	|	дЗадание.Проект КАК Проект,
//	|	дЗадание.СогласованоЧасов КАК ВремяСогласовано,
//	|	дЗадание.Тема КАК Тема,
//	|	РС_Занятость.Ссылка КАК Занятость,
//	|	РС_Занятость.Исполнитель КАК Исполнитель,
//	|	РС_Занятость.Описание КАК Описание,
//	|	ВтТаблицаДвижений.ФактическоеВремя КАК ВремяФакт,
//	|	ВтТаблицаДвижений.ВремяКлиента КАК ВремяКлиента,
//	|	ВтТаблицаДвижений.КОплате КАК ВремяКОплате
//	|ИЗ
//	|	ВтТаблицаДвижений КАК ВтТаблицаДвижений
//	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РС_Занятость КАК РС_Занятость
//	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Задание КАК дЗадание
//	|			ПО РС_Занятость.Задание = дЗадание.Ссылка
//	|		ПО ВтТаблицаДвижений.Занятость = РС_Занятость.Ссылка
//	|			И (НЕ ВтТаблицаДвижений.Закрытые)
//	|
//	|УПОРЯДОЧИТЬ ПО
//	|	Проект,
//	|	Задание,
//	|	Занятость
//	|ИТОГИ
//	|	МАКСИМУМ(ВремяСогласовано),
//	|	МАКСИМУМ(Тема),
//	|	СУММА(ВремяФакт),
//	|	СУММА(ВремяКлиента),
//	|	СУММА(ВремяКОплате)
//	|ПО
//	|	Проект,
//	|	Задание");
//	
//	Запрос.УстановитьПараметр("СписокЗанятостейЗакрытые", Объект.СписокЗанятостейЗакрытые.Выгрузить());
//	Запрос.УстановитьПараметр("СписокЗанятостейНезакрытые", Объект.СписокЗанятостейНезакрытые.Выгрузить());
//	
//	РезультатЗапроса = Запрос.ВыполнитьПакет();
//	
//	РезультатЗапросаЗакрытые = РезультатЗапроса.Получить(3);
//	РезультатЗапросаНезакрытые = РезультатЗапроса.Получить(4);
//	
//	СтрРезультат = Новый Структура("СписокЗанятостейЗакрытые,СписокЗанятостейНезакрытые", РезультатЗапросаЗакрытые, РезультатЗапросаНезакрытые);
//	
//	Для Каждого СтрокаОбхода Из СтрОбхода Цикл
//		Результат = СтрРезультат[СтрокаОбхода.Ключ];
//		ЗаполнятьДатуЗакрытия = СтрокаОбхода.Ключ = "СписокЗанятостейЗакрытые";
//		Если Не Результат.Пустой() Тогда
//			НомерПроекта = 1;
//			ВыборкаПроекты = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
//			Пока ВыборкаПроекты.Следующий() Цикл
//				НоваяСтрокаПроект = СтрокаОбхода.Значение.Строки.Добавить();
//				НоваяСтрокаПроект.НомерСтроки = НомерПроекта;
//				НоваяСтрокаПроект.ЗаданиеЗанятость = ВыборкаПроекты.Проект;
//				НоваяСтрокаПроект.ВремяФакт = ВыборкаПроекты.ВремяФакт;
//				НоваяСтрокаПроект.ВремяКлиента = ВыборкаПроекты.ВремяКлиента;
//				НоваяСтрокаПроект.ВремяКОплате = ВыборкаПроекты.ВремяКОплате;
//				
//				НомерЗадачи = 1;
//				СогласованоПоПроекту = 0;
//				СписокПользователейПроекта = Новый Массив;
//				ВыборкаЗадачи = ВыборкаПроекты.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
//				Пока ВыборкаЗадачи.Следующий() Цикл			
//					СогласованоПоПроекту = СогласованоПоПроекту + ?(ВыборкаЗадачи.Задание.ПоСогласованию,ВыборкаЗадачи.ВремяСогласовано,ВыборкаЗадачи.ВремяКлиента);
//					
//					НоваяСтрока = НоваяСтрокаПроект.Строки.Добавить();
//					НоваяСтрока.НомерСтроки = НомерЗадачи;
//					НоваяСтрока.ЗаданиеЗанятость = ВыборкаЗадачи.Задание;
//					НоваяСтрока.ТемаОписание = ВыборкаЗадачи.Тема;
//					НоваяСтрока.ВремяПлан = ВыборкаЗадачи.ВремяСогласовано;
//					НоваяСтрока.ВремяФакт = ВыборкаЗадачи.ВремяФакт;
//					НоваяСтрока.ВремяКлиента = ВыборкаЗадачи.ВремяКлиента;
//					НоваяСтрока.ВремяКОплате = ?(ВыборкаЗадачи.Задание.ПоСогласованию,ВыборкаЗадачи.ВремяСогласовано,ВыборкаЗадачи.ВремяКлиента);
//					Если ЗаполнятьДатуЗакрытия Тогда
//						НоваяСтрока.ДатаЗакрытия = Макс(ВыборкаЗадачи.ДатаКорректировки, ВыборкаЗадачи.ДатаВыполнения, ВыборкаЗадачи.ДатаЗавершения);
//					КонецЕсли;

//					КфПересчетаПлана = НоваяСтрока.ВремяПлан / ?(НоваяСтрока.ВремяФакт = 0, 1, НоваяСтрока.ВремяФакт); 
//					
//					НомерЗанятости = 1;
//					СписокПользователейЗадачи = Новый Массив;
//					ВыборкаЗанятости = ВыборкаЗадачи.Выбрать();
//					Пока ВыборкаЗанятости.Следующий() Цикл
//						НоваяПодСтрока = НоваяСтрока.Строки.Добавить();
//						НоваяПодСтрока.НомерСтроки = НомерЗанятости;
//						НоваяПодСтрока.ЗаданиеЗанятость = ВыборкаЗанятости.Занятость;
//						НоваяПодСтрока.Исполнитель = ВыборкаЗанятости.Исполнитель;
//						НоваяПодСтрока.ТемаОписание = ВыборкаЗанятости.Описание;
//						НоваяПодСтрока.ВремяПлан = ВыборкаЗанятости.ВремяФакт * КфПересчетаПлана;
//						НоваяПодСтрока.ВремяФакт = ВыборкаЗанятости.ВремяФакт;
//						НоваяПодСтрока.ВремяКлиента = ВыборкаЗанятости.ВремяКлиента;
//						НоваяПодСтрока.ВремяКОплате = ?(ВыборкаЗадачи.Задание.ПоСогласованию,ВыборкаЗанятости.ВремяФакт * КфПересчетаПлана,ВыборкаЗанятости.ВремяКлиента);
//						
//						Если СписокПользователейЗадачи.Найти(НоваяПодСтрока.Исполнитель) = Неопределено Тогда
//							СписокПользователейЗадачи.Добавить(НоваяПодСтрока.Исполнитель);
//						КонецЕсли;
//						Если СписокПользователейПроекта.Найти(НоваяПодСтрока.Исполнитель) = Неопределено Тогда
//							СписокПользователейПроекта.Добавить(НоваяПодСтрока.Исполнитель);
//						КонецЕсли;
//						
//						НомерЗанятости = НомерЗанятости + 1;
//					КонецЦикла;
//					Если СписокПользователейЗадачи.Количество() = 1 Тогда
//						НоваяСтрока.Исполнитель = СписокПользователейЗадачи[0];
//					Иначе
//						СписокЗначенийИсполнителей = Новый СписокЗначений;
//						Для Каждого СтрокаМассива Из СписокПользователейЗадачи Цикл
//							СписокЗначенийИсполнителей.Добавить(СтрокаМассива);
//						КонецЦикла;
//						НоваяСтрока.Исполнитель = СписокЗначенийИсполнителей;
//					КонецЕсли;
//					НомерЗадачи = НомерЗадачи + 1;
//				КонецЦикла;
//				НоваяСтрокаПроект.ВремяПлан = СогласованоПоПроекту;
//				НоваяСтрокаПроект.ВремяКОплате = СогласованоПоПроекту;
//				Если СписокПользователейПроекта.Количество() = 1 Тогда
//					НоваяСтрокаПроект.Исполнитель = СписокПользователейПроекта[0];
//				Иначе
//					СписокЗначенийИсполнителей = Новый СписокЗначений;
//					Для Каждого СтрокаМассива Из СписокПользователейПроекта Цикл
//						СписокЗначенийИсполнителей.Добавить(СтрокаМассива);
//					КонецЦикла;
//					НоваяСтрокаПроект.Исполнитель = СписокЗначенийИсполнителей;
//				КонецЕсли;
//				НомерПроекта = НомерПроекта + 1;
//			КонецЦикла;
//		КонецЕсли;
//	КонецЦикла;
//	
//	ЗначениеВРеквизитФормы(СписокЗанятостейДерево, "СписокЗанятостейЗакрытые");
//	ЗначениеВРеквизитФормы(СписокНезакрытыхЗанятостейДерево, "СписокЗанятостейНезакрытые");
//	
//	

//КонецПроцедуры
