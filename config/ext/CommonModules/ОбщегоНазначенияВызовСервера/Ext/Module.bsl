﻿//++ 07.01.2021, Тарасов Михаил: подключение телефонии Дом.РУ к DevBase
Функция ПолучитьДанныеНовогоЗвонка() Экспорт
	МассивДанных = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(РС_ОповещениеОНовомЗвонке.КонтактныйТелефон, """") КАК КонтактныйТелефон,
		|	ЕСТЬNULL(РС_ОповещениеОНовомЗвонке.Контрагент, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Контрагент,
		|	ЕСТЬNULL(РС_ОповещениеОНовомЗвонке.КонтактноеЛицо, ЗНАЧЕНИЕ(Справочник.КонтактныеЛица.ПустаяСсылка)) КАК КонтактноеЛицо,
		|	ЕСТЬNULL(РС_ОповещениеОНовомЗвонке.ИдентификаторПользователяАТС, """") КАК ИдентификаторПользователяАТС,
		|	РС_ОповещениеОНовомЗвонке.Дата КАК Дата
		|ИЗ
		|	РегистрСведений.РС_ОповещениеОНовомЗвонке КАК РС_ОповещениеОНовомЗвонке
		|ГДЕ
		|	РС_ОповещениеОНовомЗвонке.ИдентификаторПользователяАТС = &ИдентификаторПользователяАТС
		|	И РС_ОповещениеОНовомЗвонке.Тип = ""ACCEPTED""";
	Запрос.УстановитьПараметр("ИдентификаторПользователяАТС", ПараметрыСеанса.РС_ДОМруИмяПользователя);
	ВДЗ = Запрос.Выполнить().Выбрать();
	
	Набор = РегистрыСведений.РС_ОповещениеОНовомЗвонке.СоздатьНаборЗаписей();
	Набор.Отбор.ИдентификаторПользователяАТС.Установить(ПараметрыСеанса.РС_ДОМруИмяПользователя);
	Набор.Отбор.Тип.Установить("ACCEPTED");
	Набор.Прочитать();
	
	Для Каждого Запись Из Набор Цикл
		МенеджерЗаписи = РегистрыСведений.РС_ОповещениеОНовомЗвонке.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись);
		МенеджерЗаписи.Прочитать();
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Удалить();
		КонецЕсли;	
	КонецЦикла;
	
	Пока ВДЗ.Следующий() Цикл
		МассивДанных.Добавить(ВДЗ.КонтактныйТелефон);
		МассивДанных.Добавить(ВДЗ.Контрагент);
		МассивДанных.Добавить(ВДЗ.КонтактноеЛицо);
		МассивДанных.Добавить(ВДЗ.Дата);
	КонецЦикла;
	Возврат МассивДанных;
КонецФункции
//-- 07.01.2021, Тарасов Михаил: подключение телефонии Дом.РУ к DevBase

Функция ЗначениеРеквизитаОбъектаКлиент(Ссылка, ИмяРеквизита, ВыбратьРазрешенные = Ложь) Экспорт

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные);
	
КонецФункции