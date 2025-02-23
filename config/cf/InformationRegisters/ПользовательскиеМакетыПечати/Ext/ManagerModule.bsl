﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
// Параметры:
//  Параметры - Структура - служебный параметр для передачи в процедуру ОбновлениеИнформационнойБазы.ОтметитьКОбработке.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПользовательскиеМакетыПечати.ИмяМакета КАК ИмяМакета,
	|	ПользовательскиеМакетыПечати.Объект КАК Объект
	|ИЗ
	|	РегистрСведений.ПользовательскиеМакетыПечати КАК ПользовательскиеМакетыПечати";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	ПользовательскиеМакеты = Запрос.Выполнить().Выгрузить();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.ПользовательскиеМакетыПечати";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ПользовательскиеМакеты, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьПользовательскиеМакеты(Параметры) Экспорт
	
	МакетыВФорматеDOCX = Новый Массив;
	ИнтеграцияПодсистемБСП.ПриПодготовкеСпискаМакетовВФорматеОфисныхДокументовФормируемыхНаСервере(МакетыВФорматеDOCX);
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, "РегистрСведений.ПользовательскиеМакетыПечати");
		
	Пока Выборка.Следующий() Цикл
		Запись = СоздатьМенеджерЗаписи();
		Запись.ИмяМакета = Выборка.ИмяМакета;
		Запись.Объект = Выборка.Объект;
		Запись.Прочитать();
		ИзмененныйМакет = Запись.Макет.Получить();
		
		ЭтоОбщийМакет = СтрРазделить(Выборка.Объект, ".", Истина).Количество() < 2;
		
		Если ЭтоОбщийМакет Тогда
			ИмяОбъектаМетаданныхМакета = "ОбщийМакет." + Выборка.ИмяМакета;
		Иначе
			ИмяОбъектаМетаданныхМакета = Выборка.Объект + ".Макет." + Выборка.ИмяМакета;
		КонецЕсли;
		
		ПолноеИмяМакета = Выборка.Объект + "." + Выборка.ИмяМакета;
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Объект.Установить(Выборка.Объект);
		НаборЗаписей.Отбор.ИмяМакета.Установить(Выборка.ИмяМакета);
		
		Если Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданныхМакета) = Неопределено Тогда
			ИмяСобытия = НСтр("ru = 'Печать'", ОбщегоНазначения.КодОсновногоЯзыка());
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обнаружен пользовательский макет, отсутствующий в метаданных конфигурации:
					|""%1"".'"), ИмяОбъектаМетаданныхМакета);
			ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Предупреждение, , ИмяОбъектаМетаданныхМакета, ТекстОшибки);
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			Продолжить;
		КонецЕсли;
		
		Если ЭтоОбщийМакет Тогда
			МакетИзМетаданных = ПолучитьОбщийМакет(Выборка.ИмяМакета);
		Иначе
			УстановитьОтключениеБезопасногоРежима(Истина);
			УстановитьПривилегированныйРежим(Истина);
		
			МакетИзМетаданных = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Выборка.Объект).ПолучитьМакет(Выборка.ИмяМакета);
			
			УстановитьПривилегированныйРежим(Ложь);
			УстановитьОтключениеБезопасногоРежима(Ложь);
		КонецЕсли;
		
		Если Не УправлениеПечатью.МакетыРазличаются(МакетИзМетаданных, ИзмененныйМакет) Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		ИначеЕсли МакетыВФорматеDOCX.Найти(ПолноеИмяМакета) <> Неопределено
			И ТипЗнч(МакетИзМетаданных) = Тип("ДвоичныеДанные") И ТипЗнч(ИзмененныйМакет) = Тип("ДвоичныеДанные")
			И ТипыМакетовОфисныхДокументовРазличаются(МакетИзМетаданных, ИзмененныйМакет) Тогда
			УправлениеПечатью.ОтключитьПользовательскийМакет(ПолноеИмяМакета);
		Иначе
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
		КонецЕсли;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "РегистрСведений.ПользовательскиеМакетыПечати");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТипыМакетовОфисныхДокументовРазличаются(ИсходныйМакет, ИзмененныйМакет)
	
	Возврат УправлениеПечатьюСлужебный.ОпределитьРасширениеФайлаДанныхПоСигнатуре(ИсходныйМакет) <> УправлениеПечатьюСлужебный.ОпределитьРасширениеФайлаДанныхПоСигнатуре(ИзмененныйМакет);
	
КонецФункции

#КонецОбласти

#КонецЕсли
