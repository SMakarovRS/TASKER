﻿#Область КлиентскиеПроцедурыИФункцииСофтФон

// Функция выполняет подключение к серверу СофтФона
//
// Параметры:
//	ПоказыватьСообщения - Булево - Показывать ли сообщения об ошибках подключения пользователю
//
// Возвращаемое значение:
//	Булево	- Результат подключения
//
Функция сфпПодключитьсяComОбъект(ПоказыватьСообщения = Ложь) Экспорт
	// Получаем номер версии внешней панели
	Попытка
		Shell = Новый COMОбъект("WScript.Shell");
		Ключ = "HKEY_LOCAL_MACHINE\SOFTWARE\1C-Rarus\SoftPhone\Versions\";
		ВерсияПанели = Shell.RegRead(Ключ + "Client 2.0");
	Исключение
		ВерсияПанели = "0.0.0.0";
	КонецПопытки;	
	Если ВерсияПанели = "0.0.0.0" Тогда
		Если ПоказыватьСообщения Тогда
			ПоказатьПредупреждение(, НСтр("ru='Не установлена панель управления СофтФон!'"), 5);
		КонецЕсли;
		Возврат Ложь;
	КонецЕсли;
	// Запускаем внешнюю панель
	Попытка
		сфпПанельУправления	= Новый COMОбъект("SPPanel.SPPanelAO");
	Исключение
		сфпПанельУправления = Неопределено;
		Возврат Ложь;
	КонецПопытки;
	ДобавитьОбработчик сфпПанельУправления.OnCallInfo,		сфпOnCallInfo;
	ДобавитьОбработчик сфпПанельУправления.OnEvent,			сфпOnEvent;
	ДобавитьОбработчик сфпПанельУправления.OnRecordInfo,	сфпOnRecordInfo;
	ДобавитьОбработчик сфпПанельУправления.OnAllLinesInfo,	сфпOnAllLinesInfo;
	ДобавитьОбработчик сфпПанельУправления.OnResultInfo,	сфпOnResultInfo;
	ДобавитьОбработчик сфпПанельУправления.OnEventData,		сфпOnEventData;
	//
	сфпНужнаАвторизация = сфпСофтФонПроСервер.сфпПолучитьЗначениеНастройкиПользователя("сфпПривязатьВнутреннийНомер");
	Если сфпНужнаАвторизация Тогда
		ЛогинСофтфон 	= сфпСофтФонПроСервер.сфпПолучитьЗначениеНастройкиПользователя("сфпЛогинНаСерверСофтФон");
		ПарольСофтфон 	= сфпСофтФонПроСервер.сфпПолучитьЗначениеНастройкиПользователя("сфпПарольНаСерверСофтФон");
		сфпПанельУправления.Autorization(ЛогинСофтфон, ПарольСофтфон, 1);
	КонецЕсли;
	СтрокаДоступныхДействий	= "";
	МассивДоступныхДействий = сфпСофтФонПроСерверПереопределяемый.сфпПолучитьМассивДоступныхДействий();
	КоличествоДействий		= МассивДоступныхДействий.Количество() - 1;
	Для НомерДействия = 2 По КоличествоДействий Цикл
		ЭлементМассива = МассивДоступныхДействий[НомерДействия];
		СтрокаДоступныхДействий	= СтрокаДоступныхДействий + Формат(НомерДействия, "ЧГ=0") + "=" 
			+ СтрЗаменить(ЭлементМассива.Наименование, " ", Символы.НПП) + ";";
	КонецЦикла;	
	сфпПанельУправления.RegistrationEvents(СтрокаДоступныхДействий);
	Возврат Истина;
КонецФункции // сфпПодключитьсяComОбъект()

// Процедура заполняет префиксы и настройки
//
// Параметры:
//	Нет.
//
Процедура сфпЗаполнитьПрефиксыИНастройкиComОбъект() Экспорт
	сфпСтрокаНастроек = "";
	Попытка
		сфпПанельУправления.GetSettingsJSON(сфпСтрокаНастроек);
	Исключение	
	КонецПопытки;
	Если ПустаяСтрока(сфпСтрокаНастроек) Тогда Возврат; КонецЕсли;
	// Получим текущие настройки
	сфпПараметрыСервера		= сфпСофтФонПроСервер.сфпПараметрыСервера();
	// Запишем настройки сервера СофтФона
	сфпСтруктураНастроек	= сфпСофтФонПроСервер.сфпUnJSON(сфпСофтФонПроКлиент.сфпЗаменитьНедопустимыеСимволыXML(сфпСтрокаНастроек));
	сфпСофтФонПроСервер.сфпЗаписатьПараметрыСервераComОбъект(сфпСтруктураНастроек);
	// Если изменилось количество последних цифр, то перезаполним регистр поиска по номерам
	//@skip-warning
	Если НЕ (сфпСтруктураНастроек["LastNumberCount"] = сфпПараметрыСервера.ПоследниеЦифрыТелефонногоНомера) Тогда
		сфпСофтФонПроКлиент.сфпПерезаполнитьРегистрПоискаПоНомерам();
	КонецЕсли;
	// Если пользователь авторизовался
	//@skip-warning
	Если НЕ ПустаяСтрока(сфпСтруктураНастроек["LocalPhoneNum"]) Тогда
		// Если изменился текущий внутренний номер пользователя
		//@skip-warning
		Если НЕ (сфпСтруктураНастроек["LocalPhoneNum"] = сфпСофтФонПроСервер.сфпТекущийВнутреннийНомер()) Тогда
			// Запишем внутренний номер для текущего пользователя
			ТекущийПользователь	= сфпСофтФонПроСервер.сфпТекущийПользователь();
			//@skip-warning
			МассивПользователей = сфпСофтФонПроСервер.сфпЗаписатьНомерПользователю(сфпСтруктураНастроек["LocalPhoneNum"], ТекущийПользователь);
			Если сфпСофтФонПроСервер.сфпИспользоватьМаршрутизацию() Тогда
				// Изменим маршрутизацию в АТС
				СтарыйНабор	= сфпСофтФонПроСервер.сфпПолучитьТаблицуМаршрутизации(, ТекущийПользователь);
				Для Каждого ПользовательМассива Из МассивПользователей Цикл
					НаборПользователя	= сфпСофтФонПроСервер.сфпПолучитьТаблицуМаршрутизации(, ПользовательМассива);
					Для Каждого СтрокаНабора Из НаборПользователя Цикл
						СтарыйНабор.Добавить(СтрокаНабора);
					КонецЦикла;	
				КонецЦикла;	
				НовыйНабор	= сфпСофтФонПроСервер.сфпПолучитьТаблицуМаршрутизации(, ТекущийПользователь);
				// Изменяем внутренний номер на новый
				Для Каждого СтрокаНабора Из НовыйНабор Цикл
					//@skip-warning
					СтрокаНабора.ВнутреннийНомер = сфпСтруктураНастроек["LocalPhoneNum"];
				КонецЦикла;	
				СписокМаршрутизации = сфпСофтФонПроСервер.сфпСформироватьСписокМаршрутизации(СтарыйНабор, НовыйНабор);
				сфпСофтФонПроСервер.сфпИзменитьМаршрутизациюВАТС(СписокМаршрутизации);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// Проверяем необходимость обновления интерфейса
	Если НЕ (сфпСтруктураНастроек.Получить("UseRouter") = Неопределено) Тогда
		//@skip-warning
		Если НЕ (сфпСтруктураНастроек["UseRouter"] = сфпПараметрыСервера.ИспользоватьМаршрутизацию) Тогда
			ОбновитьИнтерфейс();	
		КонецЕсли;	
	ИначеЕсли НЕ (сфпСтруктураНастроек.Получить("HistoryOn") = Неопределено) Тогда
		// Если изменилась видимость отчетов
		//@skip-warning
		Если НЕ (сфпСтруктураНастроек["HistoryOn"] = сфпПараметрыСервера.ИспользоватьИсториюЗвонков) Тогда
			ОбновитьИнтерфейс();	
		КонецЕсли;	
	ИначеЕсли НЕ (сфпСтруктураНастроек.Получить("UseHistory") = Неопределено) Тогда
		//@skip-warning
		Если НЕ (сфпСтруктураНастроек["UseHistory"] = сфпПараметрыСервера.ИспользоватьИсториюЗвонков) Тогда
			ОбновитьИнтерфейс();	
		КонецЕсли;	
	КонецЕсли;		
КонецПроцедуры // сфпЗаполнитьПрефиксыИНастройкиComОбъект()	

// Динамически подключаемый обработчик события "OnAllLinesInfo" внешней панели
// Отсутствие ссылок на процедуру не является ошибкой!
//
// Параметры:
//	SA	- COMSafeArray	- Массив описания состояния линий
//
Процедура сфпOnAllLinesInfoComОбъект(SA) Экспорт
	ZA = SA.GetDimensions();
	Если НЕ (ZA = 2) Тогда Возврат; КонецЕсли;
	ZA = SA.GetUpperBound(0);
	Если НЕ (ZA = 5) Тогда Возврат; КонецЕсли;
	XA = SA.GetLowerBound(1);
	YA = SA.GetUpperBound(1);
	МассивЛиний = Новый Массив;
	Для ZA = XA По YA Цикл
		СтруктураЛинии = Новый Структура;
		СтруктураЛинии.Вставить("hLine",		SA.GetValue(0, ZA));
		СтруктураЛинии.Вставить("LineName",		SA.GetValue(1, ZA));
		СтруктураЛинии.Вставить("Number",		SA.GetValue(2, ZA));
		СтруктураЛинии.Вставить("LineType",		SA.GetValue(3, ZA));
		СтруктураЛинии.Вставить("Provider",		SA.GetValue(4, ZA));
		СтруктураЛинии.Вставить("LineState",	SA.GetValue(5, ZA));
		МассивЛиний.Добавить(СтруктураЛинии);
	КонецЦикла;
	Оповестить("СофтФон_OnAllLinesInfo", МассивЛиний);
КонецПроцедуры // сфпOnAllLinesInfoComОбъект()

// Функция получает версию используемой панели Софтфона
//
Функция сфпПолучитьВерсиюПанели() Экспорт
	ВерсияПанели = "0.0.0.0";
	Если НЕ (сфпПанельУправления = Неопределено) Тогда
		Попытка
			Shell = Новый COMОбъект("WScript.Shell");
			Ключ = "HKEY_LOCAL_MACHINE\SOFTWARE\1C-Rarus\SoftPhone\Versions\";
			ВерсияПанели = Shell.RegRead(Ключ + "Client 2.0");
		Исключение
			ВерсияПанели = "0.0.0.0";
		КонецПопытки;
	КонецЕсли;
	Возврат ВерсияПанели;
КонецФункции	

#КонецОбласти

#Область ОБРАБОТЧИКИ_СОБЫТИЙ_ВНЕШНЕЙ_ПАНЕЛИ

// Динамически подключаемый обработчик события "OnCallInfo" внешней панели
// Отсутствие ссылок на процедуру не является ошибкой!
//
// Параметры:
//	hCall				- Число			- Идентификатор линии.
//	LineName			- Строка		- Имя линии.
//	LineType			- Строка		- Тип линии.
//	CallerID			- Строка		- Номер звонящего.
//	CallerInfoName		- Строка		- Представление звонящего. Возвращаемый параметр.
//											Значение может быть изменено приложением.
//	CalledId			- Строка		- Номер принимающего звонок.
//	CalledInfoName		- Строка		- Представление принимающего звонок. Возвращаемый параметр.
//											Значение может быть изменено приложением.
//	State				- Число			- Состояние звонка.
//	Origin				- Число			- Направление звонка звонка. (0 – Неопределенно; 1 – Внутренний исходящий;
//											2 – Внутренний входящий; 3 – Внешний входящий; 4 – Недоступно;
//											5 – Конференция; 6 – Входящий)
//	DopInfo				- Строка		- Дополнительная информация о звонке. Возвращаемый параметр.
//											Значение может быть изменено приложением.
//	AvailableActions	- Число			- Доступные действия со звонком. Битовая маска (aa_Drop	= $00000001; aa_Answer = $00000002;
//											aa_Hold = $00000004; aa_UnHold = $00000008; aa_Redirect = $00000010; aa_Transfer = $00000020;
//											aa_CompleteTransfer = $00000040; aa_CancelTransfer = $00000080)
//	AppValue			- Произвольный	- Произвольная, служебная информация, хранимая приложением. Возвращаемый параметр.
//											Значение может быть изменено приложением.
//	ImageData			- Строка		- Картинка контакта в формате Base64. Возвращаемый параметр.
//											Значение может быть изменено приложением.
//	ContactID			- Строка		- Идентификатор контакта во внешней учетной системе. Возвращаемый параметр.
//											Значение может быть изменено приложением.
Процедура сфпOnCallInfo(hCall, LineName, LineType, CallerID, CallerInfoName, CalledId, CalledInfoName, State, Origin, DopInfo, AvailableActions, AppValue, ImageData, ContactID) Экспорт
	
	Если State = 0 Тогда
		СтруктураЗвонка	= сфпСофтФонПроКлиент.сфпНайтиДанныеЗвонка(hCall);
		Если СтруктураЗвонка <> Неопределено Тогда
			Если ЗначениеЗаполнено(СтруктураЗвонка.НовыйЗвонок) Тогда
				// Оповещаем об окончании разговора
				СтруктураОповещения = Новый Структура();
				НомерЛинии = сфпСофтФонПроСервер.сфпУбратьИзНомераТелефонаВсеПрефиксы(LineName);
				НовыйОтветственный = сфпСофтФонПроСервер.сфпНайтиОтветственного(НомерЛинии);
				Если ЗначениеЗаполнено(НовыйОтветственный) И НовыйОтветственный <> сфпСофтФонПроСервер.сфпПолучитьЗначениеРеквизита(СтруктураЗвонка.НовыйЗвонок, "Ответственный") Тогда
					СтруктураОповещения.Вставить("НовыйОтветственный", НовыйОтветственный);
				КонецЕсли;
				СтруктураОповещения.Вставить("Звонок", СтруктураЗвонка.НовыйЗвонок);
				Оповестить("СофтФон_КонецРазговора", СтруктураОповещения);
								
				ИмяФормыДокументаТелефонныйЗвонок = сфпСофтФонПроСервер.сфпИмяФормыДокументаТелефонныйЗвонок();
				Если ЗначениеЗаполнено(ИмяФормыДокументаТелефонныйЗвонок) Тогда
					ПараметрыФормы = Новый Структура("Ключ", СтруктураЗвонка.НовыйЗвонок);
					ФормаЗвонка = ПолучитьФорму(ИмяФормыДокументаТелефонныйЗвонок, ПараметрыФормы);
					Если НЕ ФормаЗвонка.Открыта() Тогда
						// Записываем в документ время окончания разговора
						Если СтруктураОповещения.Свойство("НовыйОтветственный") Тогда
							  сфпСофтФонПроСервер.сфпЗаписатьОкончаниеЗвонка(СтруктураЗвонка.НовыйЗвонок, НовыйОтветственный);
						Иначе сфпСофтФонПроСервер.сфпЗаписатьОкончаниеЗвонка(СтруктураЗвонка.НовыйЗвонок);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;

				// Записываем окончание разговора в регистр
				сфпСофтФонПроСервер.сфпЗаписатьОкончаниеЗвонкаВРегистр(СтруктураЗвонка.НовыйЗвонок, hCall);
			КонецЕсли;	
			
			// Удаляем звонок
			сфпСофтФонПроКлиент.сфпУдалитьДанныеЗвонка(hCall);
		КонецЕсли;

		сфпДанныеЗаполнения	= Неопределено;
		
	ИначеЕсли State = 8 Тогда
		ТекНомерЛинии = сфпСофтФонПроСервер.сфпТекущийВнутреннийНомер(сфпСофтФонПроСервер.сфпТекущийПользователь());
		НомерЛинии = сфпСофтФонПроСервер.сфпУбратьИзНомераТелефонаВсеПрефиксы(LineName);
		Если ТекНомерЛинии <> НомерЛинии И Origin = 3 Тогда
			// звонок не нам
			Возврат;
		КонецЕсли;
		
		СтруктураЗвонка	= сфпСофтФонПроКлиент.сфпНайтиДанныеЗвонка(hCall);
		// Для случая, когда Origin меняется в ходе коммуникации (в случае перевода между своими номерами)
		Если НЕ (СтруктураЗвонка = Неопределено) И СтруктураЗвонка.Origin <> Origin Тогда
			СтруктураЗвонка.ВнешнийЗвонок = сфпСофтФонПроКлиент.сфпОпределитьВнешнийЗвонок(Origin, СтруктураЗвонка.НомерТелефона);
			СтруктураЗвонка.ВходящийЗвонок	= сфпСофтФонПроКлиент.сфпОпределитьВходящийЗвонок(Origin);
			сфпПараметрыСервера = сфпСофтФонПроСервер.сфпПараметрыСервера();
			сфпМаксимальнаяДлинаВнутреннегоНомера = сфпПараметрыСервера.МаксимальнаяДлинаВнутреннихНомеров;
			Если НЕ сфпСофтФонПроКлиент.сфпОпределитьВнутреннийЗвонокПоНомеру(CallerID, сфпМаксимальнаяДлинаВнутреннегоНомера) Тогда
				СтруктураЗвонка.НомерТелефона	= сфпСофтФонПроСервер.сфпУбратьИзНомераТелефонаВсеПрефиксы(CallerID);				
				СтруктураЗвонка.МассивЗвонящих = сфпСофтФонПроСервер.сфпНайтиОбъектВРегистреПоТелефону(СтруктураЗвонка.НомерТелефона);
				Если СтруктураЗвонка.МассивЗвонящих.Количество() = 1 Тогда
					СтруктураЗвонка.Контакт		= СтруктураЗвонка.МассивЗвонящих[0];
					Контакт						= СтруктураЗвонка.Контакт;
					ИмяКонтакта					= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(Контакт);
					ContactID					= сфпСофтФонПроСервер.сфпПолучитьИдентификаторКонтакта(Контакт);
					ВладелецКонтакта			= сфпСофтФонПроСервер.сфпПолучитьВладельцаКонтакта(Контакт);
					Если ЗначениеЗаполнено(ВладелецКонтакта) Тогда
						DopInfo	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ВладелецКонтакта);
					Иначе	
						DopInfo	= "";
					КонецЕсли;	
					Если СтруктураЗвонка.ВходящийЗвонок Тогда
						CallerInfoName = ИмяКонтакта;
					Иначе
						CalledInfoName = ИмяКонтакта;	
					КонецЕсли;
					ImageData	= сфпСофтФонПроСервер.сфпПолучитьАватарКонтакта(Контакт, Истина);
					AppValue	= ИмяКонтакта + Символы.ПС + DopInfo + Символы.ПС + СтруктураЗвонка.НомерТелефона;
				ИначеЕсли СтруктураЗвонка.МассивЗвонящих.Количество() > 1 Тогда
					Если СтруктураЗвонка.ВходящийЗвонок Тогда
						ПервыйНайденный	= СтруктураЗвонка.МассивЗвонящих[0];
						ИмяКонтакта		= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ПервыйНайденный);
						CallerInfoName 	= НСтр("ru='Первый найденный контакт: '") + Символы.ПС + ИмяКонтакта;
						DopInfo			= Нстр("ru = 'Есть и другие совпадения'");
						AppValue 		= CallerInfoName + Символы.ПС + DopInfo + Символы.ПС + СтруктураЗвонка.НомерТелефона;
					ИначеЕсли НЕ ПустаяСтрока(ContactID) Тогда
						Контакт = сфпСофтФонПроСервер.сфпНайтиКонтактПоGUID(ContactID);
						Если НЕ (Контакт = Неопределено) Тогда
							СтруктураЗвонка.Контакт		= Контакт;
							ИмяКонтакта					= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(Контакт);
							ContactID					= сфпСофтФонПроСервер.сфпПолучитьИдентификаторКонтакта(Контакт);
							ВладелецКонтакта			= сфпСофтФонПроСервер.сфпПолучитьВладельцаКонтакта(Контакт);
							Если ЗначениеЗаполнено(ВладелецКонтакта) Тогда
								DopInfo	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ВладелецКонтакта);
							Иначе	
								DopInfo	= "";
							КонецЕсли;	
							CalledInfoName = ИмяКонтакта;
							ImageData = сфпСофтФонПроСервер.сфпПолучитьАватарКонтакта(Контакт, Истина);
							AppValue = ИмяКонтакта + Символы.ПС + DopInfo + Символы.ПС + СтруктураЗвонка.НомерТелефона;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			// -
			сфпСофтФонПроКлиент.сфпОбновитьДанныеЗвонка(СтруктураЗвонка);
		КонецЕсли;
		Если НЕ (СтруктураЗвонка = Неопределено) Тогда
			Если ПустаяСтрока(СтруктураЗвонка.НомерТелефона) Тогда
				Контакт			= Неопределено;
				НовыйЗвонок		= Неопределено;
				МассивЗвонящих	= Неопределено;
				ВходящийЗвонок	= сфпСофтФонПроКлиент.сфпОпределитьВходящийЗвонок(Origin);
				Если ВходящийЗвонок Тогда
					PhoneNumber	= CallerID;
				Иначе
					PhoneNumber	= CalledId;
				КонецЕсли;	
				НомерТелефона	= сфпСофтФонПроСервер.сфпУбратьИзНомераТелефонаВсеПрефиксы(PhoneNumber);
				ВнешнийЗвонок	= сфпСофтФонПроКлиент.сфпОпределитьВнешнийЗвонок(Origin, НомерТелефона);
				Если ЗначениеЗаполнено(НомерТелефона) Тогда
					Если ЗначениеЗаполнено(СокрЛП(AppValue)) Тогда
						Текст = Новый ТекстовыйДокумент;
						Текст.УстановитьТекст(AppValue);
						СтарыйНомер = Текст.ПолучитьСтроку(3);
						Если НЕ ПустаяСтрока(СтарыйНомер) И НЕ (СтарыйНомер = НомерТелефона) Тогда
							Если (СтрДлина(СтарыйНомер) > 7) И (Найти(НомерТелефона, СтарыйНомер) > 0) Тогда
								НомерТелефона = СтарыйНомер;
							Иначе	
								AppValue = "";
							КонецЕсли;	
						КонецЕсли;
					КонецЕсли;
					Если ЗначениеЗаполнено(СокрЛП(AppValue)) Тогда
						Текст = Новый ТекстовыйДокумент;
						Текст.УстановитьТекст(AppValue);
						Если ВходящийЗвонок Тогда
							CallerInfoName = Текст.ПолучитьСтроку(1);
						Иначе
							CalledInfoName = Текст.ПолучитьСтроку(1);	
						КонецЕсли;
					ИначеЕсли НЕ ПустаяСтрока(ContactID) Тогда
						Контакт = сфпСофтФонПроСервер.сфпНайтиКонтактПоGUID(ContactID);
						Если НЕ (Контакт = Неопределено) Тогда
							ИмяКонтакта	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(Контакт);
							ContactID	= сфпСофтФонПроСервер.сфпПолучитьИдентификаторКонтакта(Контакт);
							ВладелецКонтакта	= сфпСофтФонПроСервер.сфпПолучитьВладельцаКонтакта(Контакт);
							Если ЗначениеЗаполнено(ВладелецКонтакта) Тогда
								DopInfo	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ВладелецКонтакта);
							Иначе	
								DopInfo	= "";
							КонецЕсли;	
							CalledInfoName = ИмяКонтакта;
							ImageData = сфпСофтФонПроСервер.сфпПолучитьАватарКонтакта(Контакт, Истина);
							AppValue = ИмяКонтакта + Символы.ПС + DopInfo + Символы.ПС + НомерТелефона;
						КонецЕсли;	
					Иначе
						МассивЗвонящих = сфпСофтФонПроСервер.сфпНайтиОбъектВРегистреПоТелефону(НомерТелефона);
						Если МассивЗвонящих.Количество() = 1 Тогда
							Контакт		= МассивЗвонящих[0];
							ИмяКонтакта	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(Контакт);
							ContactID	= сфпСофтФонПроСервер.сфпПолучитьИдентификаторКонтакта(Контакт);
							ВладелецКонтакта	= сфпСофтФонПроСервер.сфпПолучитьВладельцаКонтакта(Контакт);
							Если ЗначениеЗаполнено(ВладелецКонтакта) Тогда
								DopInfo	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ВладелецКонтакта);
							Иначе	
								DopInfo	= "";
							КонецЕсли;	
							Если ВходящийЗвонок Тогда
								CallerInfoName = ИмяКонтакта;
							Иначе
								CalledInfoName = ИмяКонтакта;	
							КонецЕсли;
							ImageData	= сфпСофтФонПроСервер.сфпПолучитьАватарКонтакта(Контакт, Истина);
							AppValue	= ИмяКонтакта + Символы.ПС + DopInfo + Символы.ПС + НомерТелефона;
						ИначеЕсли МассивЗвонящих.Количество() > 1 Тогда
							Если ВходящийЗвонок Тогда
								ПервыйНайденный	= МассивЗвонящих[0];
								ИмяКонтакта		= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ПервыйНайденный);
								CallerInfoName 	= НСтр("ru='Первый найденный контакт: '") + Символы.ПС + ИмяКонтакта;
								DopInfo			= Нстр("ru = 'Есть и другие совпадения'");
								AppValue 		= CallerInfoName + Символы.ПС + DopInfo + Символы.ПС + НомерТелефона;
							ИначеЕсли НЕ ПустаяСтрока(ContactID) Тогда
								Контакт = сфпСофтФонПроСервер.сфпНайтиКонтактПоGUID(ContactID);
								Если НЕ (Контакт = Неопределено) Тогда
									ИмяКонтакта	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(Контакт);
									ContactID	= сфпСофтФонПроСервер.сфпПолучитьИдентификаторКонтакта(Контакт);
									ВладелецКонтакта	= сфпСофтФонПроСервер.сфпПолучитьВладельцаКонтакта(Контакт);
									Если ЗначениеЗаполнено(ВладелецКонтакта) Тогда
										DopInfo	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ВладелецКонтакта);
									Иначе	
										DopInfo	= "";
									КонецЕсли;	
									CalledInfoName = ИмяКонтакта;
									ImageData = сфпСофтФонПроСервер.сфпПолучитьАватарКонтакта(Контакт, Истина);
									AppValue = ИмяКонтакта + Символы.ПС + DopInfo + Символы.ПС + НомерТелефона;
								КонецЕсли;	
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
					//!!! Тут вопрос в том, что PhoneNumber был не заполнен
					СтруктураЗвонка = сфпСофтФонПроКлиент.сфпСформироватьСтруктуруЗвонка(hCall, LineName, CallerID, CallerInfoName, CalledId,
						CalledInfoName, State, Origin, AvailableActions, ContactID, PhoneNumber, Контакт, ВходящийЗвонок, ВнешнийЗвонок,
						НомерТелефона, НовыйЗвонок, МассивЗвонящих);
					сфпСофтФонПроКлиент.сфпОбновитьДанныеЗвонка(СтруктураЗвонка);
				КонецЕсли;
			КонецЕсли;
			Если СтруктураЗвонка.ВнешнийЗвонок Тогда
				Если НЕ ЗначениеЗаполнено(СтруктураЗвонка["НовыйЗвонок"]) Тогда
					СтарыйАлгоритм = Ложь;
					Если СтруктураЗвонка.ВходящийЗвонок Тогда
						сфпТекущееДействиеПриВходящемЗвонке = сфпСофтФонПроСервер.сфпПолучитьЗначениеНастройкиПользователя("сфпДействиеПриВходящемЗвонке");	
						Если сфпТекущееДействиеПриВходящемЗвонке = Нстр("ru='Открыть телефонный звонок'") 
							ИЛИ сфпТекущееДействиеПриВходящемЗвонке = Нстр("ru='Нет действий'") Тогда
							СтарыйАлгоритм = Истина;
						КонецЕсли;
					Иначе
						сфпТекущееДействиеПриИсходящемЗвонке = сфпСофтФонПроСервер.сфпПолучитьЗначениеНастройкиПользователя("сфпДействиеПриИсходящемЗвонке");
						Если сфпТекущееДействиеПриИсходящемЗвонке = Нстр("ru='Открыть телефонный звонок'") 
							ИЛИ сфпТекущееДействиеПриИсходящемЗвонке = Нстр("ru='Нет действий'") Тогда
							СтарыйАлгоритм = Истина;
						КонецЕсли;
					КонецЕсли;
					Если сфпСофтФонПроСервер.сфпИспользоватьЗаписьПереговоров() Тогда
						Если сфпСофтФонПроСервер.сфпИспользоватьСпрут7() Тогда
							// Передаем команду на запись разговора
							Если НЕ СтруктураЗвонка.ЗаписьЗапущена Тогда
								сфпПанельУправления.StartRecord(СтруктураЗвонка.LineName, СтруктураЗвонка.hCall);	
								СтруктураЗвонка.Вставить("ЗаписьЗапущена", Истина);
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
					Если СтарыйАлгоритм Тогда
						НовыйЗвонок	= сфпСофтФонПроСервер.сфпСоздатьТелефонныйЗвонок(СтруктураЗвонка, сфпДанныеЗаполнения);
						Если ЗначениеЗаполнено(НовыйЗвонок) Тогда
							сфпСофтФонПроКлиент.сфпВыполнитьДействияПослеЗаписиТелефонногоЗвонка(НовыйЗвонок, СтруктураЗвонка);
							сфпСофтФонПроКлиентПереопределяемый.сфпВыполнитьАвтоматическоеДействие(СтруктураЗвонка);
						КонецЕсли;
						
					Иначе
						сфпСофтФонПроКлиентПереопределяемый.сфпВыполнитьАвтоматическоеДействие(СтруктураЗвонка);
						
						ИмяДокументаТелефонныйЗвонок = сфпСофтФонПроСервер.сфпИмяДокументаТелефонныйЗвонок();
						Если ЗначениеЗаполнено(ИмяДокументаТелефонныйЗвонок) Тогда
							  НовыйЗвонок = ПредопределенноеЗначение(ИмяДокументаТелефонныйЗвонок + ".ПустаяСсылка");
						Иначе НовыйЗвонок = Неопределено;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если сфпСофтФонПроСервер.сфпПолучитьЗначениеНастройкиПользователя("сфпИспользоватьВнутреннююПанель") Тогда
				// Оповещаем внутреннюю панель
				СтруктураЗвонка.State				= State;
				СтруктураЗвонка.AvailableActions	= AvailableActions;
				Оповестить("СофтФон_ОбновитьЗвонок", СтруктураЗвонка);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Контакт			= Неопределено;
		НовыйЗвонок		= Неопределено;
		МассивЗвонящих	= Неопределено;
		ВходящийЗвонок	= сфпСофтФонПроКлиент.сфпОпределитьВходящийЗвонок(Origin);
		Если ВходящийЗвонок Тогда
			PhoneNumber	= CallerID;
		Иначе
			PhoneNumber	= CalledId;
		КонецЕсли;	
		НомерТелефона	= сфпСофтФонПроСервер.сфпУбратьИзНомераТелефонаВсеПрефиксы(PhoneNumber);
		ВнешнийЗвонок	= сфпСофтФонПроКлиент.сфпОпределитьВнешнийЗвонок(Origin, НомерТелефона);
		Если ЗначениеЗаполнено(НомерТелефона) Тогда
			Если ЗначениеЗаполнено(СокрЛП(AppValue)) Тогда
				Текст = Новый ТекстовыйДокумент;
				Текст.УстановитьТекст(AppValue);
				СтарыйНомер = Текст.ПолучитьСтроку(3);
				Если НЕ ПустаяСтрока(СтарыйНомер) И НЕ (СтарыйНомер = НомерТелефона) Тогда
					Если (СтрДлина(СтарыйНомер) > 7) И (Найти(НомерТелефона, СтарыйНомер) > 0) Тогда
						НомерТелефона = СтарыйНомер;
					Иначе	
						AppValue = "";
					КонецЕсли;	
				КонецЕсли;
			КонецЕсли;
			Если ЗначениеЗаполнено(СокрЛП(AppValue)) Тогда
				Текст = Новый ТекстовыйДокумент;
				Текст.УстановитьТекст(AppValue);
				Если ВходящийЗвонок Тогда
					CallerInfoName = Текст.ПолучитьСтроку(1);
				Иначе
					CalledInfoName = Текст.ПолучитьСтроку(1);	
				КонецЕсли;
			ИначеЕсли НЕ ПустаяСтрока(ContactID) Тогда
				Контакт = сфпСофтФонПроСервер.сфпНайтиКонтактПоGUID(ContactID);
				Если НЕ (Контакт = Неопределено) Тогда
					ИмяКонтакта	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(Контакт);
					ContactID	= сфпСофтФонПроСервер.сфпПолучитьИдентификаторКонтакта(Контакт);
					ВладелецКонтакта	= сфпСофтФонПроСервер.сфпПолучитьВладельцаКонтакта(Контакт);
					Если ЗначениеЗаполнено(ВладелецКонтакта) Тогда
						DopInfo	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ВладелецКонтакта);
					Иначе	
						DopInfo	= "";
					КонецЕсли;	
					CalledInfoName = ИмяКонтакта;
					ImageData = сфпСофтФонПроСервер.сфпПолучитьАватарКонтакта(Контакт, Истина);
					AppValue = ИмяКонтакта + Символы.ПС + DopInfo + Символы.ПС + НомерТелефона;
				КонецЕсли;	
			Иначе
				МассивЗвонящих = сфпСофтФонПроСервер.сфпНайтиОбъектВРегистреПоТелефону(НомерТелефона);
				Если МассивЗвонящих.Количество() = 1 Тогда
					Контакт		= МассивЗвонящих[0];
					ИмяКонтакта	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(Контакт);
					ContactID	= сфпСофтФонПроСервер.сфпПолучитьИдентификаторКонтакта(Контакт);
					ВладелецКонтакта	= сфпСофтФонПроСервер.сфпПолучитьВладельцаКонтакта(Контакт);
					Если ЗначениеЗаполнено(ВладелецКонтакта) Тогда
						DopInfo	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ВладелецКонтакта);
					Иначе	
						DopInfo	= "";
					КонецЕсли;	
					Если ВходящийЗвонок Тогда
						CallerInfoName = ИмяКонтакта;
					Иначе
						CalledInfoName = ИмяКонтакта;	
					КонецЕсли;
					ImageData	= сфпСофтФонПроСервер.сфпПолучитьАватарКонтакта(Контакт, Истина);
					AppValue	= ИмяКонтакта + Символы.ПС + DopInfo + Символы.ПС + НомерТелефона;
				ИначеЕсли МассивЗвонящих.Количество() > 1 Тогда
					Если ВходящийЗвонок Тогда
						ПервыйНайденный	= МассивЗвонящих[0];
						ИмяКонтакта		= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ПервыйНайденный);
						CallerInfoName 	= НСтр("ru='Первый найденный контакт: '") + Символы.ПС + ИмяКонтакта;
						DopInfo			= Нстр("ru = 'Есть и другие совпадения'");
						AppValue 		= CallerInfoName + Символы.ПС + DopInfo + Символы.ПС + НомерТелефона;
					ИначеЕсли НЕ ПустаяСтрока(ContactID) Тогда
						Контакт = сфпСофтФонПроСервер.сфпНайтиКонтактПоGUID(ContactID);
						Если НЕ (Контакт = Неопределено) Тогда
							ИмяКонтакта	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(Контакт);
							ContactID	= сфпСофтФонПроСервер.сфпПолучитьИдентификаторКонтакта(Контакт);
							ВладелецКонтакта	= сфпСофтФонПроСервер.сфпПолучитьВладельцаКонтакта(Контакт);
							Если ЗначениеЗаполнено(ВладелецКонтакта) Тогда
								DopInfo	= сфпСофтФонПроСервер.сфпПолучитьНаименованиеКонтакта(ВладелецКонтакта);
							Иначе	
								DopInfo	= "";
							КонецЕсли;	
							CalledInfoName = ИмяКонтакта;
							ImageData = сфпСофтФонПроСервер.сфпПолучитьАватарКонтакта(Контакт, Истина);
							AppValue = ИмяКонтакта + Символы.ПС + DopInfo + Символы.ПС + НомерТелефона;
						КонецЕсли;	
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		//!!! ContactID, >CallerID<, Контакт (CallerID возможно ошибочно)
		СтруктураЗвонка = сфпСофтФонПроКлиент.сфпСформироватьСтруктуруЗвонка(hCall, LineName, CallerID, CallerInfoName, CalledId, CalledInfoName,
			State, Origin, AvailableActions, ContactID, CallerID, Контакт, ВходящийЗвонок, ВнешнийЗвонок, НомерТелефона, НовыйЗвонок,
			МассивЗвонящих);
		сфпСофтФонПроКлиент.сфпОбновитьДанныеЗвонка(СтруктураЗвонка);
	КонецЕсли;	
КонецПроцедуры // сфпOnCallInfo()

// Динамически подключаемый обработчик события "OnEvent" внешней панели
// Отсутствие ссылок на процедуру не является ошибкой!
//
// Параметры:
//	EventType	- Число		- Тип события (-1 – Таймер; -2 – Изменились настройки; 0 – Автоматический при ответе на звонок;
//										1 – Ручной вызов для создания события;	Прочие при регистрации событий из 1С)
//	Origin		- Число		- Направление звонка звонка (0 – Неопределенно; 1 – Внутренний исходящий; 2 – Внутренний входящий;
//										3 – Внешний входящий; 4 – Недоступно; 5 – Конференция; 6 – Входящий)
//	ContactID	- Строка	- Идентификатор контакта во внешней учетной системе
//	PhoneNumber	- Строка	- Номер телефона контакта
//
Процедура сфпOnEvent(EventType, Origin, ContactID, PhoneNumber) Экспорт
	Если EventType = -2 Тогда
		// Событие изменения номера основной линии
		сфпСофтФонПроКлиент.сфпЗаполнитьПрефиксыИНастройки();
	ИначеЕсли EventType = -1 Тогда
		// Событие таймера, для обновления истории звонков
	ИначеЕсли EventType = 0 Тогда
		// Событие ответа на звонок панели управления
		СтруктураЗвонка	= сфпСофтФонПроКлиент.сфпНайтиЗвонокПоВспомогательнымДанным(Origin, ContactID, PhoneNumber);		
	ИначеЕсли EventType = 1 Тогда
		// Событие нажатия кнопки "Передать в 1С" панели управления
		СтруктураЗвонка	= сфпСофтФонПроКлиент.сфпНайтиЗвонокПоВспомогательнымДанным(Origin, ContactID, PhoneNumber);
		сфпСофтФонПроКлиентПереопределяемый.сфпВыполнитьАвтоматическоеДействие(СтруктураЗвонка);
	Иначе
		// Прочие кнопки, определенные пользователем
		СтруктураЗвонка	= сфпСофтФонПроКлиент.сфпНайтиЗвонокПоВспомогательнымДанным(Origin, ContactID, PhoneNumber);
		сфпСофтФонПроКлиентПереопределяемый.сфпВыполнитьДоступноеДействие(EventType, СтруктураЗвонка);
	КонецЕсли;
КонецПроцедуры // сфпOnEvent()

// Динамически подключаемый обработчик события "OnRecordInfo" внешней панели
// Отсутствие ссылок на процедуру не является ошибкой!
//
// Параметры:
//	RecordEventType		- Число		- Тип события
// 	hCall				- Число		- Идентификатор звонка. Может быть = 0.
//	LineID				- Строка	- Имя линии, на которой происходит звонок. Может быть = "".
//	RecordID			- Строка	- Идентификатор записи
//	TimeStart			- ДатаВремя	- Время начала записи
//	DurationTalk		- Число		- Продолжительность записи в секундах.
//	FileName			- Строка	- Имя файла звонка. Может быть = "".
//	ResultDescription	- Строка	- Описание ошибки. Может быть = "".
//	
Процедура сфпOnRecordInfo(RecordEventType, hCall, LineID, RecordID, TimeStart, DurationTalk, FileName, ResultDescription) Экспорт
	Если НЕ сфпСофтФонПроСервер.сфпИспользоватьЗаписьПереговоров() Тогда Возврат; КонецЕсли;
	Если RecordEventType = 0 Тогда
		// Запись остановлена
		ПоказатьПредупреждение(, ResultDescription, 5);
	ИначеЕсли RecordEventType = 1 Тогда
		// Запись запущена
		СтруктураЗвонка	= сфпСофтФонПроКлиент.сфпНайтиДанныеЗвонка(hCall);
		Если НЕ (СтруктураЗвонка = Неопределено) Тогда
			// Записываем в регистр истории звонков идентификатор записи
			сфпСофтФонПроСервер.сфпЗаписатьИдентификаторЗаписиВРегистр(СтруктураЗвонка.НовыйЗвонок, hCall, RecordID);			
			// Для системы записей CLON передаём в структуру идентификатор
			СтруктураЗвонка.Вставить("ИдентификаторЗаписи", RecordID);
		КонецЕсли;
	ИначеЕсли RecordEventType = 2 Тогда
		// Файл записи сохранен
		Если ПустаяСтрока(FileName) Тогда
			FileName = сфпСофтФонПроКлиент.сфпПолучитьИмяФайлаЗаписиРазговора();
		КонецЕсли;	
		Попытка
			НачатьЗапускПриложения(Новый ОписаниеОповещения("сфпОбработчикОповещенияБезДействия", сфпОбщегоНазначенияКлиентСервер), FileName);
		Исключение
		КонецПопытки;
	КонецЕсли;	
КонецПроцедуры // сфпOnRecordInfo()

// Динамически подключаемый обработчик события "OnEvent" внешней панели
// Отсутствие ссылок на процедуру не является ошибкой!
//
// Параметры:
//	SA	- COMSafeArray	- Массив описания состояния линий
//
Процедура сфпOnAllLinesInfo(ПараметрыЛиний) Экспорт
	сфпВариантСофтфона = сфпСофтФонПроСервер.сфпПрочитатьПараметрыСеанса();
	Если сфпВариантСофтфона = Неопределено Тогда Возврат; КонецЕсли;
	Если сфпВариантСофтфона = ПредопределенноеЗначение("Перечисление.сфпВариантИспользованияСофтфона.сфпComОбъект") Тогда
		сфпСофтФонПроКлиентComОбъект.сфпOnAllLinesInfoComОбъект(ПараметрыЛиний);
	Иначе
		сфпСофтФонПроКлиентНативнаяКомпонента.сфпOnAllLinesInfoНативнаяКомпонента(ПараметрыЛиний);
	КонецЕсли;	
КонецПроцедуры // сфпOnAllLinesInfo()

// Динамически подключаемый обработчик события "OnResultInfo" внешней панели
// Отсутствие ссылок на процедуру не является ошибкой!
//
// Параметры:
//	OperationName				- Строка	- Наименование операции
//	OperationResult				- Число		- Результат. Успешное выполнение, если = 0
//  OperationResultDescription	- Строка	- Описание результата
//	DopInfo						- Строка	- Дополнительная информация
//
Процедура сфпOnResultInfo(OperationName, OperationResult, OperationResultDescription, DopInfo) Экспорт
	Если OperationName = "Autorization" Тогда
		Если OperationResult = 0 Тогда	// Нет ошибки
			сфпСофтФонПроКлиент.сфпЗаполнитьПрефиксыИНастройки(); // Получаем настройки сервера СофтФон
		ИначеЕсли OperationResult = 1 Тогда	// Неверный пароль
			сфпОбщегоНазначенияКлиентСервер.сфпСообщитьПользователю(OperationResultDescription);
		ИначеЕсли OperationResult = 2 Тогда	// Пользователь не найден
			сфпОбщегоНазначенияКлиентСервер.сфпСообщитьПользователю(OperationResultDescription);
		ИначеЕсли OperationResult = 3 Тогда	// Отказано в самостоятельной регистрации пользователя
			сфпОбщегоНазначенияКлиентСервер.сфпСообщитьПользователю(OperationResultDescription);
		ИначеЕсли OperationResult = 4 Тогда	// Пользователь уже зарегистрирован		
			сфпОбщегоНазначенияКлиентСервер.сфпСообщитьПользователю(OperationResultDescription);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры // Подключаемый_OnResultInfo()

// Динамически подключаемый обработчик события "OnEventData" внешней панели
// Отсутствие ссылок на процедуру не является ошибкой!
//
// Параметры:
//	LineName	- Строка	- Имя линии
//  DataType	- Число		- Тип данных
//	StrData		- Строка	- Строковые данные
//
Процедура сфпOnEventData(LineName, DataType, StrData) Экспорт
	Если (DataType = 51) ИЛИ (DataType = 52) Тогда
		Если сфпСофтФонПроСервер.сфпИспользоватьCoMagic() Тогда
			Если ПустаяСтрока(StrData) Тогда Возврат; КонецЕсли;						
			СтруктураВнешнихДанных	= сфпСофтФонПроКлиент.сфпПолучитьСтруктуруВнешнихДанных(StrData);
			Origin		= 0;
			ContactID	= "";
			PhoneNumber	= Прав(СтруктураВнешнихДанных.ani, 10);
			СтруктураЗвонка	= сфпСофтФонПроКлиент.сфпНайтиЗвонокПоВспомогательнымДанным(Origin, ContactID, PhoneNumber);
			Если СтруктураЗвонка = Неопределено Тогда
				// Сохраняем данные CoMagic в структуре заполнения
				Если сфпДанныеЗаполнения = Неопределено Тогда
					сфпДанныеЗаполнения = Новый Структура;
					сфпДанныеЗаполнения.Вставить("СтруктураCoMagic", СтруктураВнешнихДанных);
				Иначе
					Если сфпДанныеЗаполнения.Свойство("СтруктураCoMagic") Тогда
						сфпДанныеЗаполнения.Удалить("СтруктураCoMagic");
					КонецЕсли;	
					сфпДанныеЗаполнения.Вставить("СтруктураCoMagic", СтруктураВнешнихДанных);
				КонецЕсли;	
			Иначе	
				// Оповещаем о структуре CoMagic
				СтруктураОповещения = Новый Структура;
				СтруктураОповещения.Вставить("Звонок",				СтруктураЗвонка.НовыйЗвонок);
				СтруктураОповещения.Вставить("СтруктураCoMagic",	СтруктураВнешнихДанных);
				Оповестить("Софтфон_CoMagic", СтруктураОповещения);
				ПараметрыФормы	= Новый Структура("Ключ", СтруктураЗвонка.НовыйЗвонок);
				
				ИмяФормыДокументаТелефонныйЗвонок = сфпСофтФонПроСервер.сфпИмяФормыДокументаТелефонныйЗвонок();
				Если ЗначениеЗаполнено(ИмяФормыДокументаТелефонныйЗвонок) Тогда
					ФормаЗвонка = ПолучитьФорму(ИмяФормыДокументаТелефонныйЗвонок, ПараметрыФормы);
					Если НЕ ФормаЗвонка.Открыта() Тогда
						// Записываем в документ структуру CoMagic
						сфпСофтФонПроСервер.сфпЗаписатьСтруктуруCoMagic(СтруктураЗвонка.НовыйЗвонок, СтруктураВнешнихДанных);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;		
	Конецесли;		
КонецПроцедуры // сфпOnEventData()

#КонецОбласти


