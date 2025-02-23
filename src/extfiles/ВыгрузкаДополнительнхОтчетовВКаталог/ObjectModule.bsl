﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Возвращает сведения о внешней обработке.
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Версия = "2.0";
	
	НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление = НСтр("ru = 'Выгрузка файлов в каталог (GIT)'");
	НоваяКоманда.Идентификатор = "ВыгрузкаФайловВКаталог";
	НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	НоваяКоманда.ПоказыватьОповещение = Ложь;
		
	Возврат ПараметрыРегистрации;
	
КонецФункции






Процедура ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения = Неопределено) Экспорт
	
	Если ИдентификаторКоманды = "ВыгрузкаФайловВКаталог" Тогда		
		РегламентноеЗадание_ВыгрузитьФайлы();
	КонецЕсли;
			
КонецПроцедуры


#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли




&НаСервере
Процедура РегламентноеЗадание_ВыгрузитьФайлы() Экспорт

	Массив = Новый Массив;
	Каталог = "D:\REP\tasker\extfiles\";
	Выборка = Справочники.ДополнительныеОтчетыИОбработки.Выбрать(); // выберем все в справочнике.
	Пока Выборка.Следующий() Цикл
		Если ТипЗнч(Выборка.ХранилищеОбработки) = Тип("ХранилищеЗначения") Тогда
			
			ХЗ = Выборка.ХранилищеОбработки.Получить();
			
			ИмяФайла = Каталог+Выборка.ИмяОбъекта+?(Выборка.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет,".erf",".epf");
	        НайденныеФайлы = НайтиФайлы(ИмяФайла);    //проверит в каталоге, включая вложенные подкаталоги
			Если НайденныеФайлы.Количество() = 0 Тогда
				УдалитьФайлы(ИмяФайла);
			КонецЕсли;
			
			ХЗ.Записать(ИмяФайла);
			
		
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры 
