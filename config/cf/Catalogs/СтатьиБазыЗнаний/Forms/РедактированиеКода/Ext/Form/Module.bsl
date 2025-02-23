﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтотОбъект.Текст = Параметры.Текст;
	ЭтотОбъект.Имя = Параметры.Имя;
	ЭтотОбъект.Язык = Параметры.Язык;
	
	ОбновитьПредпросмотр();
	
	// https://prismjs.com/download.html#themes=prism&languages=markup+css+clike+javascript+bash+batch+c+csharp+cpp+cmake+ini+java+json+makefile+nginx+pascal+powershell+python+regex+sql&plugins=line-numbers */
	// В таблице стилей зашит URL, который содержит все настройки prismjs.
	// Чтобы в будущем можно было легко обновлять, разберем строку и найдем все languages.
	Для Каждого КЗ Из СоответствиеЯзыков() Цикл
		Элементы.Язык.СписокВыбора.Добавить(КЗ.Ключ, КЗ.Значение);
	КонецЦикла;
	Элементы.Язык.СписокВыбора.СортироватьПоПредставлению();	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("Язык");
	ПроверяемыеРеквизиты.Добавить("Имя");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВставитьИЗакрыть(Команда)
		
	ПараметрыЗакрытия = ЗаписатьВФорме(Истина);
	Если ПараметрыЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма.Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитПриИзменении(Элемент)
	
	ОбновитьПредпросмотр();
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
			НСтр("ru='Вставка с именем ""%1"" уже существует. Задайте другое имя.'"),
			Имя);
			
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("Текст"				, ЭтотОбъект.Текст);
	ПараметрыЗакрытия.Вставить("Язык"				, ЭтотОбъект.Язык);
	ПараметрыЗакрытия.Вставить("Имя"				, ЭтотОбъект.Имя);	
	ПараметрыЗакрытия.Вставить("Модифицированность"	, ЭтотОбъект.Модифицированность);
	ПараметрыЗакрытия.Вставить("ВставкаВТекст"		, ВставкаВТекст);
	
	Возврат ПараметрыЗакрытия;
	
КонецФункции

&НаСервере
Процедура ОбновитьПредпросмотр()
	
	ТаблицаСтилей 	= БазаЗнанийCSSКлиентСервер.ПолучитьТаблицуСтилей();
	ТаблицаСкриптов = БазаЗнанийВызовСервера.ПолучитьТекстыСкриптов();
	
	ТекстHTML = ?(ПустаяСтрока(Язык), "",
		"<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN""
		|	""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">
		|<html xmlns=""http://www.w3.org/1999/xhtml"">
		|<head>
		|	" + ТаблицаСтилей + "
		|	" + ТаблицаСкриптов + "
		|</head>
		|<script>function scrollBottom(){document.body.scrollTop=document.body.scrollHeight;}</script>		
		|<body><div id=""content"" class=""content_main"">
		|" + БазаЗнанийHTML.ВложенныйКодВHTML(Язык, Текст) + "
		|</div></body>
		|</html>");
	
КонецПроцедуры

&НаСервере
Функция СоответствиеЯзыков()
	
	Соответствие = Новый Соответствие();
	Соответствие.Вставить("css", 			"CSS");
	Соответствие.Вставить("javascript", 	"JavaScript");
	Соответствие.Вставить("bash", 			"Bash");
	Соответствие.Вставить("batch", 			"Batch + Shell");
	Соответствие.Вставить("bsl", 			"1C");
	Соответствие.Вставить("c", 				"C");
	Соответствие.Вставить("csharp", 		"C#");
	Соответствие.Вставить("cpp", 			"C++");
	Соответствие.Вставить("ini", 			"INI-" + НСтр("ru = 'файл'"));
	Соответствие.Вставить("java", 			"Java");
	Соответствие.Вставить("json", 			"JSON");
	Соответствие.Вставить("cmake", 			"CMake");
	Соответствие.Вставить("makefile", 		"Make-" + НСтр("ru = 'файл'"));
	Соответствие.Вставить("nginx", 			"Nginx");
	Соответствие.Вставить("pascal", 		"Pascal");
	Соответствие.Вставить("powershell", 	"PowerShell");
	Соответствие.Вставить("python", 		"Python");
	Соответствие.Вставить("regex", 			НСтр("ru = 'Регулярное выражение'"));
	Соответствие.Вставить("sql", 			"SQL");
	Соответствие.Вставить("html", 			"HTML");
	Соответствие.Вставить("xml", 			"XML");
	Соответствие.Вставить("svg", 			"SVG");
	Соответствие.Вставить("mathml", 		"MathML");
	Соответствие.Вставить("atom", 			"Atom");
	Соответствие.Вставить("ssml", 			"SSML");
	Соответствие.Вставить("rss", 			"RSS");
	
	Возврат Соответствие;
	
КонецФункции


#КонецОбласти