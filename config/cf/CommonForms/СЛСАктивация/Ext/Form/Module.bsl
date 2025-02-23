﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Истина;
	Возврат;
	
	ЭтоКлиентСервернаяБаза = Не СтрНайти(ВРег(СтрокаСоединенияИнформационнойБазы()), "FILE=");
	Стр = СтрШаблон(НСтр("ru = 'Локально, на комьютере %1%2'"), ИмяКомпьютера(), 
		?(ЭтоКлиентСервернаяБаза, ", где работает сервер приложений", ", где запущено клиентское приложение"));
	
	Элементы.РасположениеСервера.СписокВыбора.Добавить(0, Стр);
	Элементы.РасположениеСервера.СписокВыбора.Добавить(1, НСтр("ru = 'На другом компьютере сети'"));
	
	ПараметрыСвязи 		= СЛС.ПолучитьПараметрыСвязи();
	АдресСервера 		= ПараметрыСвязи.АдресСервера;
	ПортСервера 		= ПараметрыСвязи.ПортСервера;
	
	РасположениеСервера = ?(ПараметрыСвязи.АдресСервера = "localhost", 0, 1);
	Элементы.АдресСервера.Доступность 	= РасположениеСервера > 0;
	Элементы.ПортСервера.Доступность 	= РасположениеСервера > 0;
	
	РезультатИнициализации = Ложь;
	Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	РезультатСтарта = 0;
	Если НЕ Параметры.Свойство("РезультатСтарта", РезультатСтарта) Тогда
		РезультатСтарта = СЛС.Старт();
	КонецЕсли;
	
	// Первоначальное заполнение.
	Если РезультатСтарта = 1 Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СвязьССервером;
		Элементы.ПерейтиКАктивации.КнопкаПоУмолчанию = Истина;
	ИначеЕсли РезультатСтарта = 2 Тогда
		ПолеАктивации = ПолучитьАдресАктивации();
		Элементы.Страницы.ТекущаяСтраница = Элементы.Активация;
	ИначеЕсли РезультатСтарта = 3 Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.НедостаточноЛицензий;
		ОбновитьЗаголовокНедостаточноЛицензий();
		Элементы.ПовторитьПроверкуСоединений.КнопкаПоУмолчанию = Истина;
	ИначеЕсли РезультатСтарта = 4 Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.НетОбновлений;
		ОбновитьЗаголовокНетОбновлений();
		Элементы.ЗавершитьРаботу.КнопкаПоУмолчанию = Истина;
	ИначеЕсли РезультатСтарта = 5 Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.НесоответствиеВерсииСервера;
		ОбновитьЗаголовокНесоответствиеВерсииСервера();
		Элементы.ЗавершитьРаботу1.КнопкаПоУмолчанию = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РасположениеСервераПриИзменении(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РезультатИнициализации Тогда
		Результат = Неопределено;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
			НСтр("ru = 'Хотите прервать работу мастера активации?'"), РежимДиалогаВопрос.ДаНет, 10, КодВозвратаДиалога.Нет);
	    Отказ = Истина;		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
		
    Результат = РезультатВопроса;
    Если Результат <> КодВозвратаДиалога.Да Тогда
        РезультатИнициализации = Истина;
		Закрыть();
    Иначе
        СтрДобавить		= НСтр("ru = 'РАБОТА МАСТЕРА БЫЛА ПРЕРВАНА ПОЛЬЗОВАТЕЛЕМ'");
        ТекстСообщения	= ?(ПустаяСтрока(ТекстСообщения), СтрДобавить, ТекстСообщения + Символы.ПС + СтрДобавить);
        РезультатИнициализации = Истина;
		Закрыть(Новый Структура("КомпонентаЗагруженаУспешно,ТекстСообщения", Ложь, ТекстСообщения));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьВыполнение(Команда)
	
	СохранитьАдресСервераИПорт();
	
	СЛС.ОбновитьПараметрыДоступа();
	РезультатСтарта = СЛС.Старт();
	
	// Проверим подключается ли к серверу.	
	Если РезультатСтарта = 1 Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СвязьССервером;
		ПоказатьПредупреждение(, 
			НСтр("ru = 'Соединение с сервером не установлено...
                  |1. Проверьте установлен ли сервер лицензирования?
                  |2. Адрес сервера лицензирования и порт указан верно?
                  |3. Блокируется ли файрволом сервер лицензирования на компьютере, где он установлен?'"));
		Возврат;
		
	КонецЕсли;

	// Если успешно, то есть два варианта:
	// 1. Конфигурация активирована?
	Если РезультатСтарта = 2 Тогда
		
		// 2. Конфигурация не активирована.	
		ПолеАктивации = ПолучитьАдресАктивации();
		Элементы.Страницы.ТекущаяСтраница = Элементы.Активация;
		Возврат;
		
	КонецЕсли;
	
	// Если успешно, то есть два варианта:
	// Не хватает лицензий.
	Если РезультатСтарта = 3 Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.НедостаточноЛицензий;
		ОбновитьЗаголовокНедостаточноЛицензий();
		ПоказатьПредупреждение(, НСтр("ru = 'К сожалению, ситуация не изменилась и соединений по прежнему не хватает...
                                       |Повторите попытку.'"));
		
		Возврат;
		
	КонецЕсли;
	
	// Закончился срок техподдержки и версия не соответствует.
	Если РезультатСтарта = 4 Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.НетОбновлений;
		ОбновитьЗаголовокНетОбновлений();
		ПоказатьПредупреждение(, НСтр("ru = 'К сожалению, ситуация не изменилась и соединений по прежнему не хватает...
                                       |Повторите попытку.'"));
		
		Возврат;
		
	КонецЕсли;
	
	// Не соответствие версии сервера
	Если РезультатСтарта = 5 Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.НесоответствиеВерсииСервера;
		ОбновитьЗаголовокНесоответствиеВерсииСервера();
		ПоказатьПредупреждение(, 
			НСтр("ru = 'К сожалению, ситуация не изменилась и версия сервера лицензирования по прежнему не актуальна...
                  |Повторите попытку.'"));
		
		Возврат;
		
	КонецЕсли;	
	
	СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения();
	РезультатИнициализации = Истина;
    Закрыть(Новый Структура("КомпонентаЗагруженаУспешно,ТекстСообщения", "Активация", ТекстСообщения));
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.СЛСПараметрыСервераЛицензирования");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьАктивационныеДанные(Команда)
	
	СтрокаЗапроса = 
		"mailto:crm@softonit.ru?subject=" + НСтр("ru = 'Запрос активационных данных'") + "&body=" + 
			НСтр("ru = 'Здравствуйте!
                  |Просим вас предоставить новые активационные данные для конфигурации Управление IT-отделом 8'");
		
	РегДанные = УправлениеITОтделом8УФПовтИсп.ПолучитьКонстанту("УдалитьРегистрационныеДанные");
	Если НЕ ПустаяСтрока(РегДанные) Тогда
		СтрокаЗапроса = СтрокаЗапроса + "%0D%0A" 
			+ "===== НАЧАЛО СТАРЫЕ РЕГИСТРАЦИОННЫЕ ДАННЫЕ =====" 
			+ "%0D%0A" + РегДанные + "%0D%0A" 
			+ "===== КОНЕЦ СТАРЫЕ РЕГИСТРАЦИОННЫЕ ДАННЫЕ =====";
	КонецЕсли;
	
	СтрокаЗапроса = СтрЗаменить(СтрокаЗапроса, Символы.ПС, "%0D%0A");
	НачатьЗапускПриложения(Новый ОписаниеОповещения("ЗапроситьАктивационныеДанныеЗавершение", ЭтотОбъект), СтрокаЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьАктивационныеДанныеЗавершение(КодВозврата, ДополнительныеПараметры) Экспорт
	
	ПоказатьПредупреждение(, 
		НСтр("ru = 'Ваш запрос сформирован, подготовлен в виде письма и показан Вам в почтовом клиенте. Отправьте его и ответным письмом вы получите регистрационные данные.
              |Если ничего другого не показано, то напишите письмо на support@softonit.ru с просьбой предоставить новый ключ активации и укажите организацию и количество необходимых лицензий (подключений) для информационной базы.'"));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПерейтиКАктивацииНажатие(Элемент)
	
	ПолеАктивации = ПолучитьАдресАктивации();
	Элементы.Страницы.ТекущаяСтраница = Элементы.Активация;
	Элементы.ДекорацияИнфо.Заголовок = НСтр("ru = 'Продление техподдержки и получения обновлений'");
	
КонецПроцедуры

&НаКлиенте 
Процедура РасположениеСервераПриИзменении(Элемент)
	
	АдресСервера = ?(РасположениеСервера = 0, "localhost", ?(АдресСервера = "localhost", "", АдресСервера));
	ПортСервера = ?(РасположениеСервера = 0, 9555, ?(ПортСервера = "", 9555, ПортСервера));
	
	Элементы.АдресСервера.Доступность = РасположениеСервера > 0;
	Элементы.ПортСервера.Доступность = РасположениеСервера > 0;
	
	Если Элемент <> Неопределено Тогда
		ТекущийЭлемент = Элементы.АдресСервера;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеАктивацииПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ДанныеСобытия) Тогда
		Если ДанныеСобытия.Свойство("Href") Тогда
			Если СтрНайти(ДанныеСобытия.Href, "/reload") > 0 Тогда
				РезультатИнициализации = Истина;
				Закрыть(Новый Структура("НеобходимПерезапуск", Истина));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КупитьОбновленияНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://softonit.ru/catalog/updateit/?utm_source=from1c&utm_medium=organic&utm_campaign=need_new_updates");
	
КонецПроцедуры

&НаКлиенте
Процедура КупитьЛицензииНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://softonit.ru/catalog/newconnections/?utm_source=from1c&utm_medium=organic&utm_campaign=need_new_connections");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	
	РезультатИнициализации = Истина;
	//Закрыть(Новый Структура("НеобходимоЗавершениеРаботы", Истина));
	Закрыть();
		
КонецПроцедуры

&НаКлиенте
Процедура СофтонитНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://softonit.ru/sls/");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация8Нажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://softonit.ru/sls/");
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация15Нажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("https://softonit.ru/sls/");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьЗаголовокНетОбновлений()

	Элементы.ДекорацияНетОбновлений.Заголовок = СЛС.ТекстНетДоступаКОбновлениям();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокНесоответствиеВерсииСервера()
	
	Попытка
		ВерсияСервера = СЛС.ВерсияСервера()
	Исключение
		ВерсияСервера = Неопределено;
	КонецПопытки;	
	СЛС.ПроверитьВерсиюСервера(ВерсияСервера, Элементы.ДекорацияНесоответствиеВерсий.Заголовок);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокНедостаточноЛицензий()

	Текст = НСтр("ru = 'В данный момент, превышено число пользователей, которые могут одновременно работать в конфигурации.'");
	Элементы.ДекорацияНедостаточноЛицензий.Заголовок = Текст;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьАдресСервераИПорт()
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СвязьССервером Тогда
		СЛС.СохранитьПараметрыСвязи(АдресСервера, ПортСервера);			
	КонецЕсли;
	ОбновитьПовторноИспользуемыеЗначения();	

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьАдресАктивации()

	Параметры 		= СЛС.ПолучитьПараметрыСвязи();
	
	Результат = Параметры.АдресСервера;
	Если СтрНачинаетсяС(НРег(Результат), "http://") = Ложь Тогда
		Результат = "http://" + Результат;
	КонецЕсли;
	Результат = Результат + ":" + Формат(Число(Параметры.ПортСервера), "ЧРД=; ЧРГ=; ЧГ=") + "/setup?program";
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти