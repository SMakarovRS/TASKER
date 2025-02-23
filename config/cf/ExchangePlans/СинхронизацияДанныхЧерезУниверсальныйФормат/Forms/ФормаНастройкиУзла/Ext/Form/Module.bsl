﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = Метаданные.ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Имя;
	
	ОбменДаннымиСервер.ФормаНастройкиУзлаПриСозданииНаСервере(ЭтотОбъект, ИмяПланаОбмена);
	
	Если Не ЗначениеЗаполнено(ПравилаОтправкиСправочников) Тогда
		ПравилаОтправкиСправочников = "АвтоматическаяСинхронизация";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПравилаОтправкиДокументов) Тогда
		ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РежимВыгрузкиПриНеобходимости) Тогда
		РежимВыгрузкиПриНеобходимости = 
			Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	КонецЕсли;
	
	ПравилоОтбораСправочников =
		?(ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УстановитьДатуЗапретаИзменений",
		"Доступность",
		ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДатыЗапретаИзменения));
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереключательОтправлятьНСИАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиПриИзменении(Элемент)
	
	Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" 
		И ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		
		ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
		
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаПриИзменении(Элемент)
	ПравилаОтправкиДокументов = "НеСинхронизировать";
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковСОтборомПриИзменении(Элемент)
	УсловияОграниченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковБезОтбораПриИзменении(Элемент)
	УсловияОграниченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	РежимВыгрузкиПриНеобходимости = 
		ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости");
		
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		
		РежимВыгрузкиСправочников = 
			ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.НеВыгружать");
			
		РежимВыгрузкиДокументов = 
			ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.НеВыгружать");
			
	Иначе
		
		Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
			РежимВыгрузкиСправочников = 
				ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости");
		Иначе
			РежимВыгрузкиСправочников = 
				ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию");
		КонецЕсли;
		
		Если ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация" Тогда
			РежимВыгрузкиДокументов = 
				ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию");
		ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
			РежимВыгрузкиДокументов = 
				ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную");
		Иначе
			РежимВыгрузкиДокументов = 
				ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.НеВыгружать");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументов = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизаций(Команда)
	
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Организации");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаНачалаВыгрузкиДокументов",
		"Доступность",
		ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПереключательДокументыНеОтправлять",
		"Доступность",
		ПравилаОтправкиСправочников <> "СинхронизироватьПоНеобходимости");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОписаниеДокументыНеОтправлять",
		"Доступность",
		ПравилаОтправкиСправочников <> "СинхронизироватьПоНеобходимости");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы.ГруппаДокументы.ПодчиненныеЭлементы,
		"ГруппаРежимОтправкиДокументов",
		"Доступность",
		ПравилаОтправкиСправочников <> "НеСинхронизировать");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаНастройкаДополнительныхОтборов",
		"Видимость",
		ПравилаОтправкиСправочников <> "НеСинхронизировать" И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОткрытьСписокВыбранныхОрганизаций",
		"Доступность",
		ИспользоватьОтборПоОрганизациям);
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	ЭтотОбъект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		ЭтотОбъект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	// Обновим заголовок выбранных организаций.
	Если Организации.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовокОрганизаций = СтрСоединить(ВыбранныеОрганизации, ",");
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовокОрганизаций;
	
КонецПроцедуры

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	ТабличнаяЧасть           = ЭтотОбъект[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения];
	ТаблицаВыбранныхЗначений = ТабличнаяЧасть.Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	МассивВыбранныхЗначений  = ТаблицаВыбранныхЗначений.ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
	Возврат МассивВыбранныхЗначений;
	
КонецФункции

&НаКлиенте
Процедура УсловияОграниченияСинхронизации()
	ИспользоватьОтборПоОрганизациям = ПравилоОтбораСправочников = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям";
КонецПроцедуры

#КонецОбласти