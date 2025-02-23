﻿
#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
			
	ЭтотОбъект.АдресХранилища		  = Параметры.АдресХранилища;
	ЭтотОбъект.Выравнивание 		  = Параметры.Выравнивание;
	ЭтотОбъект.ВысотаКартинки 		  = Параметры.Высота;
	ЭтотОбъект.Граница				  = Параметры.Граница;
	ЭтотОбъект.Имя				      = Параметры.Имя;
	ЭтотОбъект.Подпись			      = Параметры.Подпись;
	ЭтотОбъект.Подсказка		      = Параметры.Подсказка;
	ЭтотОбъект.СтатьяБазыЗнаний       = Параметры.СтатьяБазыЗнаний;
	ЭтотОбъект.ПрисоединенныйФайл     = Параметры.Файл;
	ЭтотОбъект.ИдентификаторВладельца = Параметры.Идентификатор;
	ЭтотОбъект.ИдентификаторКартинки  = Параметры.ИдентификаторКартинки;
	Если ЗначениеЗаполнено(ЭтотОбъект.ПрисоединенныйФайл) Тогда
		ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ЭтотОбъект.ПрисоединенныйФайл);
		АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.ИдентификаторВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПометкуКнопокВыравнивание();
	ОбновитьВстраиваемыйТекст();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("Имя");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	ОбновитьВстраиваемыйТекст();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьФайл(Команда)
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлВоВложенияПриПомещенииФайлов", ЭтотОбъект);	
	ПараметрыЗагрузки  = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
  	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОписаниеОповещения, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлВоВложенияПриПомещенииФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрываемыйФайл    = Новый Файл(ПомещенныеФайлы.Имя);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПроверкиСуществованияФайла", ЭтотОбъект, 
		Новый Структура("ОткрываемыйФайл, ОписаниеФайла", ОткрываемыйФайл, ПомещенныеФайлы));
	ОткрываемыйФайл.НачатьПроверкуСуществования(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиСуществованияФайла(Существует, ДополнительныеПараметры) Экспорт
	
	Если Не Существует Тогда
		Возврат;
	КонецЕсли;
	
	ОткрываемыйФайл = ДополнительныеПараметры.ОткрываемыйФайл;
	ОписаниеФайла   = ДополнительныеПараметры.ОписаниеФайла;
	Имя             = ОткрываемыйФайл.ИмяБезРасширения;
	Расширение      = ОткрываемыйФайл.Расширение;		
	Имя			    = УправлениеITОтделом8УФКлиентСервер.Транслит(Имя);		
	СтруктураФайла  = Новый Структура;
	СтруктураФайла.Вставить("Автор",              ПользователиКлиент.ТекущийПользователь());
	СтруктураФайла.Вставить("ВладелецФайлов",     ЭтотОбъект.СтатьяБазыЗнаний);
	СтруктураФайла.Вставить("ИмяБезРасширения",   Имя);
	СтруктураФайла.Вставить("РасширениеБезТочки", СтрЗаменить(Расширение, ".", ""));	
	Адрес 		    = ОписаниеФайла.Хранение;
	ЭтотОбъект.ПрисоединенныйФайл = ДобавитьПрисоединенныйФайлНаСервере(СтруктураФайла, Адрес);				
	АдресХранилища  = Адрес;
	ЭтотОбъект.Модифицированность = Истина;
	ЭтотОбъект.ОбновитьОтображениеДанных();	
	ОткрываемыйФайл = Неопределено;
	ОбновитьВстраиваемыйТекст();
	
КонецПроцедуры	

&НаСервере
Функция ДобавитьПрисоединенныйФайлНаСервере(СтруктураФайла, Адрес)
	
	СтруктураФайла.Вставить("ВремяИзмененияУниверсальное", ТекущаяДатаСеанса());
	ДобавленныйФайл       = РаботаСФайлами.ДобавитьФайл(СтруктураФайла, Адрес);
	ДобавленныйФайлОбъект = ДобавленныйФайл.ПолучитьОбъект();
	ДобавленныйФайлОбъект.ИДФайлаЭлектронногоПисьма = ?(ПустаяСтрока(ИдентификаторКартинки), 
		Строка(Новый УникальныйИдентификатор), ИдентификаторКартинки);
	ДобавленныйФайлОбъект.Записать();
		
	Возврат ДобавленныйФайлОбъект.Ссылка;
	
КонецФункции	

&НаКлиенте
Процедура Просмотр(Команда)
	
	ИмяФайла 	  = АдресХранилища;	
	ТекстКартинки = "<html>
	|" + БазаЗнанийCSSКлиентСервер.ПолучитьТаблицуСтилей() + "
	|<body>
	|	<div class='maintext'>
	|		<div class='pictureblock' %1>
	|			<a href='%2'><img src='%2' %3></a>
	|			" + ?(ПустаяСтрока(Подпись), "", "<br>" + Подпись) + "
	|		</div>
	|" + НСтр("ru = 'Здесь будет размещен текст статьи. Его положение относительно картинки зависит от параметров выравнивания.'") + "
	|</div>
	|</body>
	|</html>";
	
	Строка_1 = БазаЗнанийКлиентСерверПовтИсп.ТекстHTML_Выравнивание(Выравнивание);
	Если Граница > 0 Тогда
		Строка_1 = Строка_1 + "; border:" + Формат(Граница, "ЧН=0; ЧГ=") + "px solid #666;";
	КонецЕсли;
	Строка_1 = "style='" + Строка_1 + "'"; 
	Строка_2 = ИмяФайла ;
	Строка_3 = "";
	Если ВысотаКартинки > 0 Тогда
		Строка_3 = Строка_3 + " height='" + Формат(ВысотаКартинки, "ЧГ=") + "px'";
	КонецЕсли;
	Если НЕ ПустаяСтрока(Подсказка) Тогда
		Строка_3 = Строка_3 + " title='" + Подсказка + "'";
	КонецЕсли;
	
	ТекстКартинки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстКартинки,
		Строка_1,
		Строка_2,
		Строка_3);
	
	ПараметрыФормы = Новый Структура("СтрокаHTML", ТекстКартинки);	
	ОткрытьФорму("Справочник.СтатьиБазыЗнаний.Форма.ПросмотрHTML", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗакрытия = ЗаписатьВФорме(Истина);
	Если ПараметрыЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма.Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзменениеВыравнивание(Команда)
	
	Если Команда.Имя = "КартинкаСлеваТекстВокруг" Тогда
		ЭтотОбъект.Выравнивание		= 0;
	ИначеЕсли Команда.Имя = "КартинкаПоЦентруТекстСверхуСнизу" Тогда
		ЭтотОбъект.Выравнивание		= 2;
	ИначеЕсли Команда.Имя = "КартинкаСправаТекстВокруг" Тогда
		ЭтотОбъект.Выравнивание		= 1;
	КонецЕсли;
	
	УстановитьПометкуКнопокВыравнивание();
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьИЗакрыть(Команда)
	
	ПараметрыЗакрытия = ЗаписатьВФорме(Ложь);
	Если ПараметрыЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УправлениеITОтделом8УФКлиент.УстановитьТекстВБуферОбмена(ВстраиваемыйТекст);
	ЭтаФорма.Закрыть(ПараметрыЗакрытия);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// УПРАВЛЕНИЕ ФОРМОЙ

&НаКлиенте
Функция ЗаписатьВФорме(Знач ВставкаВТекст = Истина)
	
	Результат = ЭтотОбъект.ПроверитьЗаполнение();
	Если НЕ Результат Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = БазаЗнанийКлиентСервер.ПроверитьПравильностьЗаполненияИмени(ЭтотОбъект.Имя);
	Если НЕ Результат Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Имя может содержать только буквы и цифры, без пробелов и начинаться с буквы.'"));
		Возврат Неопределено;
	КонецЕсли;
		
	Если НЕ Параметры.Имена.Найти(Имя) = Неопределено Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Картинка с именем ""%1"" уже существует. Задайте другое имя.'"),
			Имя);
			
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("АдресХранилища"		, ЭтотОбъект.АдресХранилища);
	ПараметрыЗакрытия.Вставить("Выравнивание"		, ЭтотОбъект.Выравнивание);
	ПараметрыЗакрытия.Вставить("Высота"				, ЭтотОбъект.ВысотаКартинки);
	ПараметрыЗакрытия.Вставить("Граница"			, ЭтотОбъект.Граница);
	ПараметрыЗакрытия.Вставить("Имя"				, ЭтотОбъект.Имя);
	ПараметрыЗакрытия.Вставить("Подпись"			, ЭтотОбъект.Подпись);
	ПараметрыЗакрытия.Вставить("Подсказка"			, ЭтотОбъект.Подсказка);
	ПараметрыЗакрытия.Вставить("Модифицированность"	, ЭтотОбъект.Модифицированность);
	ПараметрыЗакрытия.Вставить("Файл"				, ЭтотОбъект.ПрисоединенныйФайл);
	ПараметрыЗакрытия.Вставить("ВставкаВТекст"		, ВставкаВТекст);
	
	Возврат ПараметрыЗакрытия;
	
КонецФункции

&НаКлиенте
Процедура УстановитьПометкуКнопокВыравнивание()
	
	Элементы.КартинкаСлеваТекстВокруг.Пометка			= (ЭтотОбъект.Выравнивание = 0);
	Элементы.КартинкаПоЦентруТекстСверхуСнизу.Пометка	= (ЭтотОбъект.Выравнивание = 2);
	Элементы.КартинкаСправаТекстВокруг.Пометка			= (ЭтотОбъект.Выравнивание = 1);
	
КонецПроцедуры

&НаСервере
Функция ТекущаДатаСеансаНаСервере()
	
	Возврат ТекущаяДатаСеанса();
	
КонецФункции

&НаКлиенте
Процедура ОбновитьВстраиваемыйТекст()
	
	ВстраиваемыйТекст = ?(ПустаяСтрока(Имя), "", "[picture='" + Имя + "']");
	
КонецПроцедуры

#КонецОбласти
