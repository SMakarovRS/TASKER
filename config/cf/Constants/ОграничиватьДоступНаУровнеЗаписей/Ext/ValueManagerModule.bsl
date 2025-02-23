﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ОграничениеДоступаНаУровнеЗаписейВключено; // Флажок изменения значения константы с Ложь на Истина.
                                                 // Используется в обработчике события ПриЗаписи.

Перем ОграничениеДоступаНаУровнеЗаписейИзменено; // Флажок изменения значения константы.
                                                 // Используется в обработчике события ПриЗаписи.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОграничениеДоступаНаУровнеЗаписейВключено
		= Значение И НЕ Константы.ОграничиватьДоступНаУровнеЗаписей.Получить();
	
	ОграничениеДоступаНаУровнеЗаписейИзменено
		= Значение <>   Константы.ОграничиватьДоступНаУровнеЗаписей.Получить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОграничениеДоступаНаУровнеЗаписейИзменено Тогда
		УправлениеДоступомСлужебный.ПриИзмененииОграниченияДоступаНаУровнеЗаписей(
			ОграничениеДоступаНаУровнеЗаписейВключено);
		
		Если УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально(Истина) Тогда
			
			ПараметрыПланирования = УправлениеДоступомСлужебный.ПараметрыПланированияОбновленияДоступа();
			ПараметрыПланирования.ЭтоПродолжениеОбновления = Истина;
			ПараметрыПланирования.Описание = "ОграничиватьДоступНаУровнеЗаписейПриЗаписи";
			УправлениеДоступомСлужебный.ЗапланироватьОбновлениеДоступа(, ПараметрыПланирования);
			
			УправлениеДоступомСлужебный.УстановитьОбновлениеДоступа(Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли