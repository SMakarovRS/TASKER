﻿
&ИзменениеИКонтроль("ОбработкаПроведения")
Процедура РСК_ОбработкаПроведения(Отказ, РежимПроведения)

	// Инициализация дополнительных свойств для проведения документа.
	УправлениеITОтделом8УФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	// Инициализация данных документа.
	СЛС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);	

	// Подготовка наборов записей.
	УправлениеITОтделом8УФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	// Отражение в разделах учета.
	СЛС.ОтразитьДвиженияВРазделахУчета(Ссылка, ДополнительныеСвойства, Движения, Отказ);		
	
	#Вставка
	Движения.РСК_ЦеныУслугКонтрагентов.Загрузить(Движения.ЦеныУслуг.Выгрузить());
	М = Новый Массив();
	М.Добавить(Контрагент);
	Движения.РСК_ЦеныУслугКонтрагентов.ЗагрузитьКолонку(М,"Контрагент");
	Движения.РСК_ЦеныУслугКонтрагентов.Записывать=Истина;
	#КонецВставки
	// Запись наборов записей.
	УправлениеITОтделом8УФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();

КонецПроцедуры
