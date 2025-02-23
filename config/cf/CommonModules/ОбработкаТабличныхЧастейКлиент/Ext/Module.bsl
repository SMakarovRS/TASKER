﻿
//Функция добавляет строку в дерево
//
Функция ДобавитьСтрокуДерева(РеквизитДерево, Родитель)Экспорт
	
	Если Родитель = Неопределено Тогда
		// Добавляем в корень
		НоваяСтрока = РеквизитДерево.ПолучитьЭлементы().Добавить();
	Иначе
		НоваяСтрока 			= Родитель.ПолучитьЭлементы().Добавить();
		НоваяСтрока.Комплект	= ?(ЗначениеЗаполнено(Родитель.Комплект), Родитель.Комплект, Родитель.КарточкаНоменклатуры);
		НоваяСтрока.Партия		= Родитель.КарточкаНоменклатуры;		
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

//Процедура заполняет реквизиты комплект и партия для ветки дерева
//
Процедура ЗаполнитьКомплектПартию(Родитель)Экспорт
	
	Для Каждого СтрокаДерева Из Родитель.ПолучитьЭлементы() Цикл
		СтрокаДерева.Комплект	= ?(ЗначениеЗаполнено(Родитель.Комплект), Родитель.Комплект, Родитель.КарточкаНоменклатуры);
		СтрокаДерева.Партия 	= Родитель.КарточкаНоменклатуры;
	КонецЦикла;	
	
КонецПроцедуры	