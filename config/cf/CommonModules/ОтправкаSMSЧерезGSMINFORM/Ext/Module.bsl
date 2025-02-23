﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Отправляет SMS через GSM-INFORM.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +7ХХХХХХХХХХ;
//  Текст 			  - Строка - текст сообщения, длиной не более 480 символов;
//  ИмяОтправителя 	  - Строка - имя отправителя, которое будет отображаться вместо номера входящего SMS;
//  Логин			  - Строка - логин пользователя услуги отправки sms;
//  Пароль			  - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//  Структура: ОтправленныеСообщения - Массив структур: НомерОтправителя.
//                                                  ИдентификаторСообщения.
//             ОписаниеОшибки        - Строка - пользовательское представление ошибки, если пустая строка,
//                                          то ошибки нет.
Функция ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Пароль) Экспорт
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	// Подготовка строки получателей.
	СтрокаПолучателей = МассивПолучателейСтрокой(НомераПолучателей);
	
	// Проверка на заполнение обязательных параметров.
	Если ПустаяСтрока(СтрокаПолучателей) Или ПустаяСтрока(Текст) Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Неверные параметры сообщения'");
		Возврат Результат;
	КонецЕсли;
	
	// Подготовка параметров запроса.
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("id", Логин);
	ПараметрыЗапроса.Вставить("api_key", Пароль);
	
	ПараметрыЗапроса.Вставить("cmd", "send");
	ПараметрыЗапроса.Вставить("message", Текст);
	ПараметрыЗапроса.Вставить("to", СтрокаПолучателей);
	ПараметрыЗапроса.Вставить("sender", ИмяОтправителя);
	
	// отправка запроса
	Ответ = ВыполнитьЗапрос(ПараметрыЗапроса);
	Если Ответ = Неопределено Тогда
		Результат.ОписаниеОшибки = Результат.ОписаниеОшибки + НСтр("ru = 'Соединение не установлено'");
		Возврат Результат;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Ответ);
	ОтветСервера = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	Если ОтветСервера["error_no"] = 0 Тогда
		Для Каждого Элемент Из ОтветСервера["items"] Цикл
			Если Элемент["error_no"] = 0 Тогда
				ОтправленноеСообщение = Новый Структура("НомерПолучателя,ИдентификаторСообщения", Элемент["phone"], Формат(Элемент["sms_id"], "ЧГ=0"));
				Результат.ОтправленныеСообщения.Добавить(ОтправленноеСообщение);
			Иначе
				КодОшибки = Элемент["error_no"];
				Результат.ОписаниеОшибки = Результат.ОписаниеОшибки + Элемент["phone"] + ": " + ОписаниеОшибкиПолученияСтатуса(КодОшибки) + Символы.ПС;
			КонецЕсли;
		КонецЦикла;
		Если Не ПустаяСтрока(Результат.ОписаниеОшибки) Тогда
			Результат.ОписаниеОшибки = НСтр("ru = 'Не удалось отправить SMS'") + ":" + СокрП(Результат.ОписаниеОшибки);
		КонецЕсли;
	Иначе
		Результат.ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
			"ru = 'Не удалось отправить SMS:
			|%1 (код ошибки: %2)'"), ОписаниеОшибкиОтправки(ОтветСервера["error_no"]), ОтветСервера["error_no"]);
			
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Результат.ОписаниеОшибки);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текстовое представление статуса доставки сообщения.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный sms при отправке;
//  НастройкиОтправкиSMS   - см. ОтправкаSMSПовтИсп.НастройкиОтправкиSMS;
//
// Возвращаемое значение:
//  Строка - статус доставки. См. описание функции ОтправкаSMS.СтатусДоставки.
Функция СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS) Экспорт
	Логин = НастройкиОтправкиSMS.Логин;
	Пароль = НастройкиОтправкиSMS.Пароль;
	
	// Подготовка параметров запроса.
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("id", Логин);
	ПараметрыЗапроса.Вставить("api_key", Пароль);
	ПараметрыЗапроса.Вставить("sms_id", ИдентификаторСообщения);
	ПараметрыЗапроса.Вставить("cmd", "status");
	
	// отправка запроса
	Ответ = ВыполнитьЗапрос(ПараметрыЗапроса);
	Если Ответ = Неопределено Тогда
		Возврат "Ошибка";
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Ответ);
	ОтветСервера = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	ОписаниеОшибки = "";
	КодОшибки = Неопределено;
	Результат = "Ошибка";
	
	Если ОтветСервера["error_no"] = 0 Тогда
		Для Каждого Элемент Из ОтветСервера["items"] Цикл
			Если Элемент.Свойство("error_no") Тогда
				КодОшибки = Элемент["error_no"];
				Прервать;
			Иначе
				Результат = СтатусДоставкиSMS(Элемент["status_no"]);
			КонецЕсли;
		КонецЦикла;
	Иначе
		КодОшибки = ОтветСервера["error_no"];
	КонецЕсли;
	
	Если КодОшибки <> Неопределено Тогда
		ОписаниеОшибки = ОписаниеОшибкиПолученияСтатуса(КодОшибки);
		Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
			"ru = 'Не удалось получить статус доставки SMS (id: ""%3""):
			|%1 (код ошибки: %2)'"), ОписаниеОшибки, КодОшибки, ИдентификаторСообщения);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Комментарий);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СтатусДоставкиSMS(КодСостояния)
	СоответствиеСтатусов = Новый Соответствие;
	СоответствиеСтатусов.Вставить("1", "Отправлено");
	СоответствиеСтатусов.Вставить("2", "Доставлено");
	СоответствиеСтатусов.Вставить("3", "НеДоставлено");
	СоответствиеСтатусов.Вставить("4", "Отправляется");
	СоответствиеСтатусов.Вставить("6", "НеДоставлено");
	СоответствиеСтатусов.Вставить("7", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("8", "Отправляется");
	СоответствиеСтатусов.Вставить("9", "НеОтправлено");
	СоответствиеСтатусов.Вставить("10", "Отправляется");
	СоответствиеСтатусов.Вставить("11", "Отправлено");
	
	Результат = СоответствиеСтатусов[КодСостояния];
	Возврат ?(Результат = Неопределено, "НеОтправлялось", Результат);
КонецФункции

Функция ОписанияОшибок()
	Результат = Новый Соответствие;
	Результат.Вставить(1, НСтр("ru = 'Неверный API-ключ.'"));
	Результат.Вставить(2, НСтр("ru = 'Неизвестная команда.'"));
	Результат.Вставить(3, НСтр("ru = 'Пользователь с указанным ID кабинета не найден.'"));
	Результат.Вставить(4, НСтр("ru = 'Пустой список телефонов для отправки сообщений.'"));
	Результат.Вставить(5, НСтр("ru = 'Не указан текст сообщения.'"));
	Результат.Вставить(6, НСтр("ru = 'Не удалось отправить сообщение на указанный номер.'"));
	Результат.Вставить(7, НСтр("ru = 'Не указан отправитель по приоритетному трафику.'"));
	Результат.Вставить(8, НСтр("ru = 'Некорректный отправитель, допускается только латиница и цифры.'"));
	Результат.Вставить(9, НСтр("ru = 'Пустой список идентификаторов сообщений для получения статусов.'"));
	Результат.Вставить(10, НСтр("ru = 'Не найдено сообщение с таким идентификатором.'"));
	Результат.Вставить(11, НСтр("ru = 'Не удалось оплатить рассылку, проверьте баланс.'"));
	
	Возврат Результат;
КонецФункции

Функция ОписаниеОшибкиОтправки(КодОшибки)
	ОписанияОшибок = ОписанияОшибок();
	ТекстСообщения = ОписанияОшибок[КодОшибки];
	Если ТекстСообщения = Неопределено Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сообщение не отправлено (код ошибки: %1).'"), КодОшибки);
	КонецЕсли;
	Возврат ТекстСообщения;
КонецФункции

Функция ОписаниеОшибкиПолученияСтатуса(КодОшибки)
	ОписанияОшибок = ОписанияОшибок();
	ТекстСообщения = ОписанияОшибок[КодОшибки];
	Если ТекстСообщения = Неопределено Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Статус сообщения не получен (код ошибки: %1).'"), КодОшибки);
	КонецЕсли;
	Возврат ТекстСообщения;
КонецФункции

Функция ВыполнитьЗапрос(ПараметрыЗапроса)
	
	HTTPЗапрос = ОтправкаSMS.ПодготовитьHTTPЗапрос("/api/", ПараметрыЗапроса);
	HTTPОтвет = Неопределено;
	
	Попытка
		Соединение = Новый HTTPСоединение("gsm-inform.ru",,,, 
			ПолучениеФайловИзИнтернета.ПолучитьПрокси("http"), 
			60);
		HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если HTTPОтвет <> Неопределено Тогда
		Если HTTPОтвет.КодСостояния <> 200 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Запрос ""%1"" не выполнен. Код состояния: %2.'"), ПараметрыЗапроса["cmd"], HTTPОтвет.КодСостояния) + Символы.ПС
				+ HTTPОтвет.ПолучитьТелоКакСтроку();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
		КонецЕсли;
		
		Возврат HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция МассивПолучателейСтрокой(Массив)
	Получатели = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Получатели, Массив, Истина);
	
	Результат = "";
	Для Каждого Получатель Из Получатели Цикл
		Номер = ФорматироватьНомер(Получатель);
		Если НЕ ПустаяСтрока(Номер) Тогда 
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + ",";
			КонецЕсли;
			Результат = Результат + Номер;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "+1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;	
КонецФункции

// Возвращает список разрешений для отправки SMS с использованием всех доступных провайдеров.
//
// Возвращаемое значение:
//  Массив - .
//
Функция Разрешения() Экспорт
	
	Протокол = "HTTP";
	Адрес = "gsm-inform.ru";
	Порт = Неопределено;
	Описание = НСтр("ru = 'Отправка SMS через ""GSM-INFORM"".'");
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Разрешения = Новый Массив;
	Разрешения.Добавить(
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	
	Возврат Разрешения;
КонецФункции

Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.АдресОписанияУслугиВИнтернете = "http://gsm-inform.ru";
	Настройки.ПриОпределенииСпособовАвторизации = Истина;
	
КонецПроцедуры

Процедура ПриОпределенииСпособовАвторизации(СпособыАвторизации) Экспорт
	
	СпособыАвторизации.Очистить();
	
	ПоляАвторизации = Новый СписокЗначений;
	ПоляАвторизации.Добавить("Логин", НСтр("ru = 'ID кабинета'"));
	ПоляАвторизации.Добавить("Пароль", НСтр("ru = 'API-ключ'"));
	
	СпособыАвторизации.Вставить("ПоЛогинуИПаролю", ПоляАвторизации);
	
КонецПроцедуры

#КонецОбласти

