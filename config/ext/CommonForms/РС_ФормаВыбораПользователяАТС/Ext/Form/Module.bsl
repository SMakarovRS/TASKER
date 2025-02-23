﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НабираемыйНомер") Тогда
		НабираемыйНомер = Параметры.НабираемыйНомер;
	КонецЕсли;
	
	Соединение = Новый HTTPСоединение("vpbx381206422.domru.biz",443,,,,,Новый ЗащищенноеСоединениеOpenSSL());
	Запрос = Новый HTTPЗапрос("/sys/crm_api.wcgp?cmd=accounts&token=" + Константы.РС_ТокенОблачнойАТС.Получить());
	Попытка
		Результат = Соединение.Получить(Запрос);
	Исключение
		Сообщить("Ошибка подключения к серверу ДОМ.ру для получения списка пользователей АТС");
		Возврат;
	КонецПопытки;
	
	Если Не ЗначениеЗаполнено(Результат.ПолучитьТелоКакСтроку()) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаJSON = Результат.ПолучитьТелоКакСтроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	ЧтениеJSON.Прочитать();
	ДОМруПользователь = "@vpbx381206422.domru.biz";
	
	ВнутреннийНомер = УправлениеITОтделом8УФПовтИсп.ПолучитьЗначениеНастройки("РС_ВнутреннийНомер");
	
	Пока ЧтениеJSON.Прочитать() Цикл
		
		Если ЧтениеJSON.ТипТекущегоЗначения = ТипЗначенияJSON.КонецМассива Тогда
			Прервать;
		КонецЕсли;
		ЧтениеJSON.Прочитать();
		Номер = "";
		Ник = "";
		Пока Номер = "" ИЛИ Ник = "" Цикл
			Если ЧтениеJSON.ТекущееЗначение = "name" Тогда
				ЧтениеJSON.Прочитать();	
				Ник = ЧтениеJSON.ТекущееЗначение;
			ИначеЕсли ЧтениеJSON.ТекущееЗначение = "ext" Тогда
				ЧтениеJSON.Прочитать();	
				Номер = ЧтениеJSON.ТекущееЗначение;
			Иначе
				ЧтениеJSON.Прочитать();
			КонецЕсли;	
			ЧтениеJSON.Прочитать();
		КонецЦикла;
		
		СтрокаТаблицы = СписокПользователейАТС.Добавить();
		СтрокаТаблицы.ПользовательАТС = Ник + ДОМруПользователь;
		СтрокаТаблицы.ВнутреннийНомер = Номер;
		СтрокаТаблицы.ВнутреннийНомерЧислом = Число(Номер);
		Если ВнутреннийНомер = Номер Тогда
			СтрокаТаблицы.УказанВНастройках = Истина;	
		КонецЕсли;
		
		Пока ЧтениеJSON.ТипТекущегоЗначения <> ТипЗначенияJSON.КонецОбъекта Цикл
			ЧтениеJSON.Прочитать();
		КонецЦикла;
		
	КонецЦикла;
	
	СписокПользователейАТС.Сортировать("ВнутреннийНомерЧислом");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СтрокаТаблицы = СписокПользователейАТС.НайтиСтроки(Новый Структура("УказанВНастройках", Истина));
	Если СтрокаТаблицы.Количество() > 0 Тогда
		
		СтрокаТаблицы = СтрокаТаблицы[0];
		Элементы.СписокПользователейАТС.ТекущаяСтрока = СтрокаТаблицы.ПолучитьИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.СписокПользователейАТС.ТекущиеДанные <> Неопределено Тогда
		Закрыть(Элементы.СписокПользователейАТС.ТекущиеДанные.ПользовательАТС);
	Иначе
		Закрыть(); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейАТСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элементы.СписокПользователейАТС.ТекущиеДанные <> Неопределено Тогда
		Закрыть(Элементы.СписокПользователейАТС.ТекущиеДанные.ПользовательАТС);
	Иначе
		Закрыть(); 
	КонецЕсли;
	
КонецПроцедуры
