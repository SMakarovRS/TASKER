﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		
		Приоритет = ЗаданияСервер.РассчитатьПриоритет(Влияние, Срочность);
		
		Если ТипШаблона = Перечисления.ТипыШаблоновЗаданий.РегламентноеЗадание 
				И (РасписаниеШаблона.Получить() = Неопределено 
				ИЛИ ТипЗнч(РасписаниеШаблона.Получить()) <> Тип("РасписаниеРегламентногоЗадания")) Тогда
			Р = Новый РасписаниеРегламентногоЗадания();			
			Р.ДеньВМесяце = 1;
			Р.ВремяНачала = Дата(1, 1, 1, 8, 0, 0);
			Р.ПериодПовтораДней = 1;
			РасписаниеШаблона = Новый ХранилищеЗначения(Р);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Ошибки = Неопределено;
	
	Если ВидимостьШаблона = Перечисления.ВидимостьШаблонов.ГруппыПользователей Тогда
		Если НЕ ЗначениеЗаполнено(ВладелецШаблона) 
			ИЛИ ТипЗнч(ВладелецШаблона) <> Тип("СправочникСсылка.ГруппыПользователей") Тогда
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.ВладелецШаблона",
				НСтр("ru = 'Не заполнен вледелец шаблона.'"),
				"");
				
		КонецЕсли;
	КонецЕсли;
	
	Если ВидимостьШаблона = Перечисления.ВидимостьШаблонов.Личный Тогда
		Если НЕ ЗначениеЗаполнено(ВладелецШаблона) 
			ИЛИ ТипЗнч(ВладелецШаблона) <> Тип("СправочникСсылка.Пользователи") Тогда
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.ВладелецШаблона",
				НСтр("ru = 'Не заполнен вледелец шаблона.'"),
				"");
				
		КонецЕсли;
	КонецЕсли;
	
	Если ТипШаблона = Перечисления.ТипыШаблоновЗаданий.РегламентноеЗадание 
		И НЕ ЗначениеЗаполнено(Инициатор) Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Объект.Инициатор",
			НСтр("ru = 'Не заполнен инициатор шаблона.'"),
			"");		
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаПоследнегоЗапуска = Дата(1, 1, 1);
	РасписаниеШаблона = "";
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли