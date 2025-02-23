﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест"
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Запись.РабочееМесто = Справочники.РабочиеМеста.ПустаяСсылка() Тогда
		Запись.РабочееМесто = ПараметрыСеанса.РабочееМестоКлиента;
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура УстройствоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если РабочееМестоУстройства(ВыбранноеЗначение) = Запись.РабочееМесто Тогда
		СтандартнаяОбработка = Ложь;
		ТекстСообщения = НСтр("ru = 'Выбранное устройство уже привязано к данному рабочему месту!
		                            |Укажите удаленное устройство для использования по сети'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , );
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция РабочееМестоУстройства(Устройство)

	Возврат Устройство.РабочееМесто;

КонецФункции
