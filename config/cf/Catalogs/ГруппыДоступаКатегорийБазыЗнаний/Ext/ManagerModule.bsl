﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Функция определяет, используются или нет группы доступа категорий базы знаний.
//
//	Возвращаемое значение:
//		Булево - если ИСТИНА, значит группы доступа используются.
//
Функция ИспользуютсяГруппыДоступа() Экспорт
	
	Возврат
		ПолучитьФункциональнуюОпцию("ОграничиватьДоступНаУровнеЗаписей")
		И ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаКатегорийБазыЗнаний");
	
КонецФункции

Функция ГруппаДоступаПоУмолчанию(Пользователь = Неопределено) Экспорт

	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ГруппаДоступа = УправлениеITОтделом8УФПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновнаяГруппаДоступаКатегорийБазыЗнаний");
	Если Не ЗначениеЗаполнено(ГруппаДоступа) Тогда
		Возврат ГруппаДоступа;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ГруппыДоступаКатегорийБазыЗнаний.Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступаКатегорийБазыЗнаний КАК ГруппыДоступаКатегорийБазыЗнаний
	|ГДЕ
	|	ГруппыДоступаКатегорийБазыЗнаний.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ГруппаДоступа);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат ГруппаДоступа;
	Иначе
		Возврат Справочники.ГруппыДоступаКатегорийБазыЗнаний.ПустаяСсылка();
	КонецЕсли;

КонецФункции 

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
		
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
