﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФлагЗакладки = Истина;
	ФлагВидимостьОтбора = Ложь;
	Элементы.ОбщаяГруппа.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;	
	УстановитьВидимостьИДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбщаяГруппаПриСменеСтраницы(Элемент, ТекущаяСтраница)
	УстановитьВидимостьИДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПоДокументамПриСменеСтраницы(Элемент, ТекущаяСтраница)
	УстановитьВидимостьИДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Закладки(Команда)
	ФлагЗакладки = НЕ ФлагЗакладки;	
	УстановитьВидимостьИДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьОтбора(Команда)
	ФлагВидимостьОтбора = НЕ ФлагВидимостьОтбора;
	УстановитьВидимостьИДоступность();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьИДоступность()
	
	Если ФлагЗакладки Тогда
		Если Элементы.ОбщаяГруппа.ТекущаяСтраница <> Элементы.ГруппаПоДокументам Тогда
			Элементы.ОбщаяГруппа.ТекущаяСтраница = Элементы.ГруппаПоДокументам;
		КонецЕсли;
	Иначе
		Если Элементы.ОбщаяГруппа.ТекущаяСтраница <> Элементы.ГруппаЖурнал Тогда
			Элементы.ОбщаяГруппа.ТекущаяСтраница = Элементы.ГруппаЖурнал;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.ОбщаяГруппа.ТекущаяСтраница = Элементы.ГруппаЖурнал Тогда
		Элементы.СписокЗакладки.Пометка = ФлагЗакладки;
	Иначе
		Если Элементы.ПоДокументам.ТекущаяСтраница = Элементы.ГруппаЗакреплениеСотрудников Тогда
			Элементы.ЗакреплениеСотрудниковЗакладки.Пометка = ФлагЗакладки;
		ИначеЕсли Элементы.ПоДокументам.ТекущаяСтраница = Элементы.ГруппаПеремещениеСотрудников Тогда
			Элементы.ПеремещениеСотрудниковЗакладки.Пометка = ФлагЗакладки;
		ИначеЕсли Элементы.ПоДокументам.ТекущаяСтраница = Элементы.ГруппаСнятиеЗакрепленияСотрудников Тогда
			Элементы.СнятиеЗакрепленияСотрудниковЗакладки.Пометка = ФлагЗакладки;
		КонецЕсли;
	КонецЕсли;	
	
	Если Элементы.ОбщаяГруппа.ТекущаяСтраница = Элементы.ГруппаЖурнал Тогда
		Элементы.СписокВидимостьОтбора.Пометка = ФлагВидимостьОтбора;
		Если Элементы.ГруппаСписокОтбор.Видимость <> ФлагВидимостьОтбора Тогда
        	Элементы.ГруппаСписокОтбор.Видимость = ФлагВидимостьОтбора;
		КонецЕсли;
	Иначе
		Если Элементы.ПоДокументам.ТекущаяСтраница = Элементы.ГруппаЗакреплениеСотрудников Тогда
			Элементы.ЗакреплениеСотрудниковВидимостьОтбора.Пометка = ФлагВидимостьОтбора;
			Если Элементы.ГруппаЗакреплениеСотрудниковОтбор.Видимость <> ФлагВидимостьОтбора Тогда
				Элементы.ГруппаЗакреплениеСотрудниковОтбор.Видимость = ФлагВидимостьОтбора;
			КонецЕсли;
		ИначеЕсли Элементы.ПоДокументам.ТекущаяСтраница = Элементы.ГруппаПеремещениеСотрудников Тогда
			Элементы.ПеремещениеСотрудниковВидимостьОтбора.Пометка = ФлагВидимостьОтбора;
			Если Элементы.ГруппаПеремещениеСотрудниковОтбор.Видимость <> ФлагВидимостьОтбора Тогда
				Элементы.ГруппаПеремещениеСотрудниковОтбор.Видимость = ФлагВидимостьОтбора;
			КонецЕсли;
		ИначеЕсли Элементы.ПоДокументам.ТекущаяСтраница = Элементы.ГруппаСнятиеЗакрепленияСотрудников Тогда
			Элементы.СнятиеЗакрепленияСотрудниковВидимостьОтбора.Пометка = ФлагВидимостьОтбора;
			Если Элементы.ГруппаСнятиеЗакрепленияСотрудниковОтбор.Видимость <> ФлагВидимостьОтбора Тогда
				Элементы.ГруппаСнятиеЗакрепленияСотрудниковОтбор.Видимость = ФлагВидимостьОтбора;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

