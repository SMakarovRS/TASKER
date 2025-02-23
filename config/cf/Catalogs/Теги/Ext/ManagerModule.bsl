﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьТегПоНаименованию(Наименование, знач Описание = "") Экспорт
	
	Наименование	= СокрЛП(Наименование);
	ЭлементСсылка	= Справочники.Теги.НайтиПоНаименованию(Наименование, Истина);
	Если НЕ ЗначениеЗаполнено(ЭлементСсылка) Тогда
		ЭлементОбъект = Справочники.Теги.СоздатьЭлемент();
		ЭлементОбъект.ОбменДанными.Загрузка = Истина;
		ЭлементОбъект.Наименование	= Наименование;		
		ЭлементОбъект.Записать();		
		ЭлементСсылка = ЭлементОбъект.Ссылка;
	КонецЕсли;
	
	Возврат ЭлементСсылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли