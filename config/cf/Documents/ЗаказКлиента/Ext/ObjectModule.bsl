﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = Номенклатура.Итог("Всего");
	
	Если ПоложениеДатыПоступления = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Для каждого СтрокаТабличнойЧасти Из Номенклатура Цикл
			СтрокаТабличнойЧасти.ДатаПоступления = ДатаПоступления;
		КонецЦикла;
	КонецЕсли;
	Если ПоложениеСтатьиДоходовРасходов = Перечисления.ПоложениеРеквизитаНаФорме.ВШапке Тогда
		Для каждого СтрокаТабличнойЧасти Из Номенклатура Цикл
			СтрокаТабличнойЧасти.СтатьяДоходовРасходов = СтатьяДоходовРасходов;
		КонецЦикла;
	КонецЕсли;
	Если ПоложениеДатыПоступления = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		Если Номенклатура.Количество() > 0 Тогда
			ДатаПоступления = Номенклатура[0].ДатаПоступления;
		КонецЕсли;
	КонецЕсли;
	
	КоличествоВДокументе = Номенклатура.Итог("Количество");
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда	
		Возврат;		
	КонецЕсли;
	
	Если ПоложениеДатыПоступления = Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ДатаПоступления"));
	Иначе
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Номенклатура.ДатаПоступления"));
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеITОтделом8УФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	СЛС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);	
	
	// Подготовка наборов записей.
	УправлениеITОтделом8УФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	СЛС.ОтразитьДвиженияВРазделахУчета(Ссылка, ДополнительныеСвойства, Движения, Отказ);		
		
	// Запись наборов записей.
	УправлениеITОтделом8УФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа.
	УправлениеITОтделом8УФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеITОтделом8УФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей.
	УправлениеITОтделом8УФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		Контрагент 				= ДанныеЗаполнения.Ссылка;
		Ответственный			= Пользователи.ТекущийПользователь();
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Инициатор) И ЗначениеЗаполнено(МестоХранения) Тогда
		Сотрудник		= УправлениеITОтделом8УФ.ПолучитьОтветственногоСотрудникаМестаХранения(ТекущаяДатаСеанса(), МестоХранения);
		Если ЗначениеЗаполнено(Сотрудник) Тогда
			Инициатор	= Сотрудник.Физлицо;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения

Процедура ПриКопировании(ОбъектКопирования)
	
	УправлениеITОтделом8УФ.ОчиститьДатуНомерВходящегоДокумента(ЭтотОбъект);
	
	ЗаполнитьПриКопировании();
		 
КонецПроцедуры // ПриКопировании

#КонецОбласти

#Область СлужебныеПроцедурыИФункции	

// Процедура заполняет документ при копировании.
//
Процедура ЗаполнитьПриКопировании()
	
	СостояниеЗаказа = Справочники.СостоянияЗаказовКлиентов.Открыт;
	Закрыт = Ложь;
	
КонецПроцедуры // ЗаполнитьПриКопировании()

#КонецОбласти

#КонецЕсли