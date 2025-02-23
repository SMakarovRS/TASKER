﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БазовыеЦвета = ЗначениеИзСтрокиВнутр(ПолучитьОбщийМакет("БазовыеЦвета").ПолучитьТекст());
	Если Объект.Ссылка.Пустая() Тогда
		РедактируемыйЦветФона 				= WebЦвета.Белый;
		РедактируемыйЦветТекста 			= WebЦвета.Черный;
		РедактируемыйЦветРамкиКанбанДоски 	= WebЦвета.ТемноЗеленый;
	Иначе
		Попытка
			РедактируемыйЦветФона 			= РаботаСЦветомКлиентСервер.HexВЦвет(Объект.ЦветФона);
			РедактируемыйЦветТекста 		= РаботаСЦветомКлиентСервер.HexВЦвет(Объект.ЦветТекста);
			РедактируемыйЦветРамкиКанбанДоски = РаботаСЦветомКлиентСервер.HexВЦвет(Объект.ЦветРамкиКанбанДоски);
		Исключение
			РедактируемыйЦветФона 			= WebЦвета.Белый;
			РедактируемыйЦветТекста 		= WebЦвета.Черный;
			РедактируемыйЦветРамкиКанбанДоски = WebЦвета.ТемноЗеленый;
		КонецПопытки;
	КонецЕсли;
	
	НоваяСтрока 		= ПримерТекста.Добавить();
	НоваяСтрока.Пример 	= НСтр("ru = 'Пример текста,'");
	НоваяСтрока 		= ПримерТекста.Добавить();
	НоваяСтрока.Пример 	= НСтр("ru = 'который будет выводиться'");
	НоваяСтрока 		= ПримерТекста.Добавить();
	НоваяСтрока.Пример 	= НСтр("ru = 'в списке заданий для данного типа статусов'");
	
	ОбновитьИзображение();
	ОбновитьЦветТекстаИФона();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ЗаданияСервер.УстановитьШагКорректировкиВеса(ШагКорректировкиВеса);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ЦветФона   			= РаботаСЦветомКлиентСервер.ЦветВHex(РедактируемыйЦветФона);
	ТекущийОбъект.ЦветТекста 			= РаботаСЦветомКлиентСервер.ЦветВHex(РедактируемыйЦветТекста);
	ТекущийОбъект.ЦветРамкиКанбанДоски 	= РаботаСЦветомКлиентСервер.ЦветВHex(РедактируемыйЦветРамкиКанбанДоски);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОбновитьЦветаЭтаповПроцесса");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РедактируемыйЦветНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Результат = Неопределено;

	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("РедактируемыйЦветНачалоВыбораЗавершение2", ЭтотОбъект), БазовыеЦвета,
		Элемент, БазовыеЦвета.НайтиПоЗначению(РедактируемыйЦветФона));
	
КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветНачалоВыбораЗавершение2(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    Результат = ВыбранныйЭлемент;
    Если Результат <> Неопределено Тогда
        
        Если ТипЗнч(Результат.Значение) = Тип("Строка") Тогда
            ПараметрыФормы = Новый Структура("РедактируемыйЦвет", РедактируемыйЦветФона);
            ОткрытьФорму("ОбщаяФорма.ФормаВыбораЦвета", ПараметрыФормы, Элементы.РедактируемыйЦветФона,,,,
				Новый ОписаниеОповещения("РедактируемыйЦветНачалоВыбораЗавершение", ЭтотОбъект,
					Новый Структура("Результат", Результат)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
            Возврат;
        Иначе
            РедактируемыйЦветФона = Результат.Значение;
        КонецЕсли;
        РедактируемыйЦветНачалоВыбораФрагмент();
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветНачалоВыбораЗавершение(Результат1, ДополнительныеПараметры) Экспорт

    Результат = ДополнительныеПараметры.Результат;
    РедактируемыйЦветНачалоВыбораФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветНачалоВыбораФрагмент()

    ОбновитьЦветТекстаИФона();

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Цвет") Тогда
		РедактируемыйЦветФона = ВыбранноеЗначение;
		ОбновитьЦветТекстаИФона();
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветТекстаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Результат = Неопределено;
	
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("РедактируемыйЦветТекстаНачалоВыбораЗавершение1", ЭтотОбъект),
		БазовыеЦвета, Элемент, БазовыеЦвета.НайтиПоЗначению(РедактируемыйЦветТекста));
		
КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветТекстаНачалоВыбораЗавершение1(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    Результат = ВыбранныйЭлемент;
    Если Результат <> Неопределено Тогда
        
        Если ТипЗнч(Результат.Значение) = Тип("Строка") Тогда
            ПараметрыФормы = Новый Структура("РедактируемыйЦвет", РедактируемыйЦветТекста);
            ОткрытьФорму("ОбщаяФорма.ФормаВыбораЦвета", ПараметрыФормы, Элементы.РедактируемыйЦветТекста,,,,
				Новый ОписаниеОповещения("РедактируемыйЦветТекстаНачалоВыбораЗавершение", ЭтотОбъект,
					Новый Структура("Результат", Результат)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
            Возврат;
        Иначе
            РедактируемыйЦветТекста = Результат.Значение;
        КонецЕсли;
        РедактируемыйЦветТекстаНачалоВыбораФрагмент();
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветТекстаНачалоВыбораЗавершение(Результат1, ДополнительныеПараметры) Экспорт
    
    Результат = ДополнительныеПараметры.Результат;
    
    
    РедактируемыйЦветТекстаНачалоВыбораФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветТекстаНачалоВыбораФрагмент()
    
    ОбновитьЦветТекстаИФона();

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветТекстаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Цвет") Тогда
		РедактируемыйЦветТекста = ВыбранноеЗначение;
		ОбновитьЦветТекстаИФона();
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветРамкиКанбанДоскиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Результат = Неопределено;
	
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("РедактируемыйЦветРамкиКанбанДоскиНачалоВыбораЗавершение3", ЭтотОбъект),
		БазовыеЦвета, Элемент, БазовыеЦвета.НайтиПоЗначению(РедактируемыйЦветРамкиКанбанДоски));
		
КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветРамкиКанбанДоскиНачалоВыбораЗавершение3(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    Результат = ВыбранныйЭлемент;
    Если Результат <> Неопределено Тогда
        
        Если ТипЗнч(Результат.Значение) = Тип("Строка") Тогда
            ПараметрыФормы = Новый Структура("РедактируемыйЦвет", РедактируемыйЦветРамкиКанбанДоски);
            ОткрытьФорму("ОбщаяФорма.ФормаВыбораЦвета", ПараметрыФормы, Элементы.РедактируемыйЦветРамкиКанбанДоски,,,,
				Новый ОписаниеОповещения("РедактируемыйЦветРамкиКанбанДоскиНачалоВыбораЗавершение", ЭтотОбъект,
					Новый Структура("Результат", Результат)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
            Возврат;
        Иначе
            РедактируемыйЦветРамкиКанбанДоски = Результат.Значение;
        КонецЕсли;
        РедактируемыйЦветТекстаНачалоВыбораФрагмент();
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветРамкиКанбанДоскиНачалоВыбораЗавершение(Результат1, ДополнительныеПараметры) Экспорт
    
    Результат = ДополнительныеПараметры.Результат;
    РедактируемыйЦветТекстаНачалоВыбораФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура РедактируемыйЦветРамкиКанбанДоскиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Цвет") Тогда
		РедактируемыйЦветРамкиКанбанДоски = ВыбранноеЗначение;
		ОбновитьЦветТекстаИФона();
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВесРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Если ШагКорректировкиВеса > 1 Тогда		
		
		СтандартнаяОбработка = Ложь;
		Если Направление = 1 Тогда
			Объект.Вес = Объект.Вес + ШагКорректировкиВеса;
		Иначе
			Объект.Вес = Объект.Вес - ШагКорректировкиВеса;
		КонецЕсли;	
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресКартинкиНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьКартинкуИзФайла();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОчиститьИзображение(Команда)
	
	ОчиститьИзображениеНаСервере();	
	ОбновитьИзображение();
	Элементы.АдресКартинки.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзображениеИзФайла(Команда)
	
	ВыбратьКартинкуИзФайла();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзображениеИзНабора(Команда)
	
	Результат = Неопределено;	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораИзображенияИзНабора",,,,,,
		Новый ОписаниеОповещения("ВыбратьИзображениеИзНабораЗавершение", ЭтотОбъект),
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзображениеИзНабораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если Результат <> Неопределено Тогда
        Адрес = ПоместитьВоВременноеХранилище(Результат);
        ПоместитьФайлОбъекта(Адрес);
        Элементы.АдресКартинки.Обновить();
		ОбновитьИзображение();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройкиЦвета(Команда)
	
	РедактируемыйЦветФона 	= WebЦвета.Белый;
	РедактируемыйЦветТекста = WebЦвета.Черный;
	РедактируемыйЦветРамкиКанбанДоски = WebЦвета.ТемноЗеленый;
	ОбновитьЦветТекстаИФона();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СлучайныйЦвет(Команда)
    
    СлучайныйЦветНаСервере();
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьЦветТекстаИФона()
	
	Элементы.ПримерТекстаСтолбец.ЦветФона   		= РедактируемыйЦветФона;
	Элементы.ПримерТекстаСтолбец.ЦветТекста 		= РедактируемыйЦветТекста;
	Элементы.ДекорацияЦветРамкиКанбанДоски.Видимость = УправлениеITОтделом8УФПовтИсп.ПолучитьКонстанту("ИспользоватьКанбан");
	Элементы.ДекорацияЦветРамкиКанбанДоски.ЦветФона	= РедактируемыйЦветРамкиКанбанДоски;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьИзображениеНаСервере()
	
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	ЭлементСправочника.Картинка = Неопределено;
	ЭлементСправочника.Записать();
	Модифицированность = Ложь;
	ЗначениеВРеквизитФормы(ЭлементСправочника, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИзображение()
	
	АдресКартинки = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "Картинка")
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзФайла()
	
	Перем ВыбранноеИмя;
	Перем АдресВременногоХранилища;

	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ВыбратьКартинкуИзФайлаЗавершение2", ЭтотОбъект, 
		Новый Структура("АдресВременногоХранилища", АдресВременногоХранилища)));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзФайлаЗавершение2(Подключено, ДополнительныеПараметры) Экспорт
	
	АдресВременногоХранилища = ДополнительныеПараметры.АдресВременногоХранилища;
	
	
	Если Подключено Тогда
		Режим = РежимДиалогаВыбораФайла.Открытие;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		Фильтр = УправлениеITОтделом8УФКлиентСервер.ПолучитьФильтрИзображений();
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите изображение'");
		ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ВыбратьКартинкуИзФайлаЗавершение1", ЭтотОбъект,
			Новый Структура("АдресВременногоХранилища, ДиалогОткрытияФайла", АдресВременногоХранилища, ДиалогОткрытияФайла)));
	Иначе		
		ПоказатьПредупреждение(,НСтр("ru = 'Данная возможность недоступна, так как не подключено расширение работы с файлами.'", "ru"));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзФайлаЗавершение1(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	АдресВременногоХранилища = ДополнительныеПараметры.АдресВременногоХранилища;
	ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ВыбранноеИмя = ДиалогОткрытияФайла.ПолноеИмяФайла;
		НачатьПомещениеФайла(Новый ОписаниеОповещения("ВыбратьКартинкуИзФайлаЗавершение", ЭтотОбъект, 
			Новый Структура("АдресВременногоХранилища", АдресВременногоХранилища)), 
			АдресВременногоХранилища, ВыбранноеИмя, Ложь,);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзФайлаЗавершение(Результат, Адрес, ВыбранноеИмя, ДополнительныеПараметры) Экспорт
    
    Если Результат Тогда
        ПоместитьФайлОбъекта(Адрес);
        Элементы.АдресКартинки.Обновить();			
		ОбновитьИзображение();
    КонецЕсли;

КонецПроцедуры

// Процедура извлекает данные объекта из временного хранилища, 
// производит модификацию элемента справочника и записывает его.
// 
// Параметры: 
//  АдресВременногоХранилища - Строка - адрес временного хранилища. 
// 
// Возвращаемое значение: 
//  Нет.
&НаСервере
Процедура ПоместитьФайлОбъекта(АдресВременногоХранилища)
	ЭлементСправочника = РеквизитФормыВЗначение("Объект");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ЭлементСправочника.Картинка = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных());
	ЭлементСправочника.Записать();
	Модифицированность = Ложь;
	УдалитьИзВременногоХранилища(АдресВременногоХранилища);
	ЗначениеВРеквизитФормы(ЭлементСправочника, "Объект");     
КонецПроцедуры

&НаСервере
Процедура СлучайныйЦветНаСервере()
        
	РедактируемыйЦветФона = РаботаСЦветомКлиентСервер.СлучайныйЦветRALStandart();
	РедактируемыйЦветТекста = РаботаСЦветомКлиентСервер.КонтрастныйЦвет(РедактируемыйЦветФона);
    РедактируемыйЦветРамкиКанбанДоски = РаботаСЦветомКлиентСервер.СлучайныйЦветRALStandart();
	ОбновитьЦветТекстаИФона();
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

