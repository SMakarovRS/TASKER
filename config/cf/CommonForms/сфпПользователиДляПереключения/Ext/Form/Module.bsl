﻿
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
// Функция возвращает выбранного пользователя
//
// Параметры:
//	ВыбраннаяСтрока	- РегистрСведенийКлючЗаписи	- Выбранная запись 
//
// Возвращаемое значение:
//	СправочникСсылка	- Выбранный пользователь
//
Функция ПолучитьВыбранногоПользователя(ВыбраннаяСтрока)
	Возврат ВыбраннаяСтрока.Пользователь;
КонецФункции // ПолучитьВыбранногоПользователя()	

&НаСервере
// Функция возвращает ключ записи настройки внутреннего номера для пользователя
//
// Параметры:
//	Пользователь	- СправочникСсылка	- Пользователь
//
// Возвращаемое значение:
//	РегистрСведенийКлючЗаписи	- Ключ записи
//
Функция сфпПолучитьКлючЗаписи(Пользователь)
	
	ИмяПВХ_СофтфонНастройкиПользователей = сфпСофтФонПроСервер.сфпИмяПВХ_СофтфонНастройкиПользователей();
	ИмяРегистраСофтфонНастройкиПользователей = сфпСофтФонПроСервер.сфпИмяРегистраСофтфонНастройкиПользователей();
	
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("Пользователь", Пользователь);
	СтруктураОтбора.Вставить("Настройка", ПланыВидовХарактеристик[ИмяПВХ_СофтфонНастройкиПользователей].сфпТекущийВнутреннийНомер);
	Возврат РегистрыСведений[ИмяРегистраСофтфонНастройкиПользователей].СоздатьКлючЗаписи(СтруктураОтбора);

КонецФункции // сфпПолучитьКлючЗаписи()	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ОБРАБОТЧИКИ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
// Процедура - обработчик события "Выбор" таблицы формы "Список"
//
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	НовыйПользователь	= ПолучитьВыбранногоПользователя(ВыбраннаяСтрока);
	Если НовыйПользователь = Пользователь Тогда Возврат; КонецЕсли;
	ВнутреннийНомер	= сфпСофтФонПроСервер.сфпТекущийВнутреннийНомер(НовыйПользователь);
	Если ПустаяСтрока(ВнутреннийНомер) Тогда Возврат; КонецЕсли;
	СтарыйНабор	= сфпСофтФонПроСервер.сфпПолучитьТаблицуМаршрутизации(Контакт, Пользователь);
	ПользовательОбновлен	= сфпСофтФонПроСервер.сфпЗаписатьНовогоПользователя(Контакт, НовыйПользователь);
	Если ПользовательОбновлен Тогда
		НовыйНабор	= сфпСофтФонПроСервер.сфпПолучитьТаблицуМаршрутизации(Контакт, НовыйПользователь);
		СписокМаршрутизации = сфпСофтФонПроСервер.сфпСформироватьСписокМаршрутизации(СтарыйНабор, НовыйНабор);
		сфпСофтФонПроСервер.сфпИзменитьМаршрутизациюВАТС(СписокМаршрутизации);
	КонецЕсли;	
	ОповеститьОВыборе(НовыйПользователь);	
КонецПроцедуры // СписокВыбор()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
// Процедура - обработчик события формы "ПриСозданииНаСервере"
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ сфпСофтФонПроСервер.сфпИспользоватьМаршрутизацию() Тогда
		Отказ					= Истина;
		СтандартнаяОбработка	= Ложь;
	ИначеЕсли НЕ Параметры.Свойство("Контакт") Тогда
		Отказ					= Истина;
		СтандартнаяОбработка	= Ложь;
	Иначе	
		Контакт			= Параметры.Контакт;
		Пользователь	= сфпСофтФонПроСервер.сфпПолучитьПользователяДляПереключенияЗвонков(Контакт);
	КонецЕсли;	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
// Процедура - обработчик события формы "ПриОткрытии"
//
Процедура ПриОткрытии(Отказ)
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда Возврат; КонецЕсли;
	Элементы.Список.ТекущаяСтрока = сфпПолучитьКлючЗаписи(Пользователь);
КонецПроцедуры // ПриОткрытии()
