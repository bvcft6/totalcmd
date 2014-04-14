TCFS2Tools Module for Total Commander
-------------------------------------
(English section is below)

Расширяет функциональность утилиты TCFS2, позволяя:
+ скрывать/отображать строку главного меню
+ временно отображать главное меню программы при вызове
+ отображать главное меню в виде всплывающего по команде пользователя
+ получать/устанавливать позицию разделителя файловых панелей
+ получать текущие режимы панелей
+ получать системные величины, возвращаемые функцией GetSystemMetrics
+ получать размеры рабочей области экрана



1. Файл конфигурации и описание команд

Конфигурационный файл должен находиться в папке модуля и иметь такое же имя файла, но расширение INI. Файл конфигурации необходим только если нужно переопределить стандартные идентификаторы команд и опции (указаны ниже после знаков равенства). Команды делятся на 2 вида - TCM (с числовым идентификатором) и STR (со строковым идентификатором). Как вызывать те и другие, указано в разделе 2 данного файла.

Параметры секции [HideMenu]:
	MenuMode=0
		Задает режим отображения главного меню при вызове, когда оно скрыто: 0 - при нажатии Alt главное меню временно включается; 1 - при нажатии Alt главное меню отображается в виде всплывающего.

Команды секции [HideMenu]:
	ShowMainMenu=65537
		Показывает строку меню (если она была скрыта);
	HideMainMenu=65538
		Скрывает строку меню;
	SwitchMainMenu=65539
		Переключает видимость строки меню;
	TrackMainMenu=65540
		Отображает главное меню в виде всплывающего меню.

Команды секции [Common]:
	GetWindowMetrics=65550
		Возвращает размеры и положение окна ТК. Параметр lParam определяет, какое именно значение возвращается: 0, 1, 2, 3 - координаты X, Y, ширина и высота окна; 4, 5, 6, 7 - координаты X, Y, ширина и высота клиентской части окна (без заголовка, меню и границ);
	LeftIsActive=65551
		Проверяет, активна ли левая (верхняя) панель, и возвращает 1 или 0;
	RightIsActive=65552
		Проверяет, активна ли правая (нижняя) панель, и возвращает 1 или 0;
	LeftGetViewMode=65553
		Возвращает индекс внутренней команды ТК для переключения левой панели в текущий режим (101 - краткий, 102 - подробный, 71 - первый пользовательский и т.д.);
	RightGetViewMode=65554
		Возвращает индекс внутренней команды ТК для переключения в текущий режим правой панели (201 - краткий, 202 - подробный, 171 - первый пользовательский и т.д.);
	IsVerticalPanels=65555
		Возвращает 1, если панели отображаются одна над другой;
	SeparatorGet=65561
		Возвращает позицию разделителя файловых панелей;
	SeparatorSet=65562
		Устанавливает позицию разделителя панелей, задаваемую в lParam. Если параметр меньше нуля, позицию сепаратора можно будет установить мышью.

Команды секции [System]:
	GetSystemMetrics=65570
		Возвращает значение некоторой системной величины с индексом, задаваемым в параметре lParam. Значения поддерживаемых индексов смотрите в описании функции GetSystemMetrics (например, 0 - ширина экрана, 1 - высота экрана, 4 - высота заголовка окна) - доступно более 50 значений;
	GetWorkArea=65571
		Возвращает размеры рабочей области экрана (без панели задач). Значение параметра lParam определяет, какую именно величину нужно вернуть (0 - ширина рабочей области, 1 - высота рабочей области);
	GetAsyncKeyState=65572
		Возвращает информацию о состоянии клавиши. Значение lParam задает виртуальный код клавиши. Коды клавиш и возвращаемое значение смотрите в описании функции GetAsyncKeyState (например, 16 - Shift, 17 - Ctrl, 18 - Alt; отрицательный результат означает, что клавиша зажата);
	GetSomeInfo=65573
		Возвращает различную информацию в зависимости от значения lParam: 0 - количество миллисекунд с момента загрузки Windows.

Команды секции [Registers]:
	RegWrite=RegWrite
		Записывает значение в один из регистров. Параметры: wParam - адрес регистра (начиная с 1), lParam - значение для записи;
	RegRead=RegRead
		Считывает значение из регистра. Параметры: wParam - адрес регистра, lParam - значение, возвращаемое при ошибке;
	RegCount=RegCount
		Возвращает количество доступных регистров (совпадает с максимальным номером регистра).

Переопределяемые номера TCM-команд должны быть больше или равны 16384 (сообщения в диапазоне 0-16383 в той или иной степени используются Windows).

При регистрации сообщения со строковым идентификатором оно получает приставку "TCFS2." (например, TCFS2.RegRead), даже если идентификатор переопределяется - при отправке сообщения также необходимо указывать эту приставку.



2. Вызов команд

2.1 Вызов TCM-команд

Для вызова какой-либо команды нужно отправить оконное сообщение с номером WM_USER+51 ($433) окну ТК при загруженном модуле TCFS2Tools. Модуль обработает сообщение и вернет результат. В качестве параметра wParam сообщения нужно указать номер команды TCFS2Tools (указаны в разделе 1 данного файла). Если команда принимает параметр, его нужно указывать в качестве параметра lParam сообщения.

Если модуль не загружен, ТК воспримет команду как внутреннюю и попытается её выполнить. При этом в большинстве случаев появится сообщение, что команда не реализована (внутренние команды ТК имеют другие индексы).


2.2 Вызов команд со строковыми идентификаторами

Для вызова команды необходимо получить номер оконного сообщения с помощью функции RegisterWindowMessage, указав идентификатор сообщения с приставкой "TCFS2." (например, TCFS2.RegRead). Если команда принимает параметры, их нужно указывать в качестве параметров wParam и lParam сообщения.

Если модуль не загружен, сообщение не будет обработано.



3. Интеграция с TCFS2

Аддон TCFS2 (страница загрузки здесь: http://wincmd.ru/plugring/tcfs2.html) позволяет управлять режимами окна ТК, в том числе и посылать внутренние команды ТК. Чтобы выполнить команду TCFS2Tools без параметров, можно использовать функцию tcm, для выполнения команды с параметром - функцию msg. К слову, tcm(x) работает как msg($433, x, 0, 0). Для использования возможностей TCFS2Tools добавьте следующие команды в секцию [Items] файла конфигурации TCFS2:

mm1=tcm(65537)
mm0=tcm(65538)
mm2=tcm(65539)
mm_track=tcm(65540)
set_separator=msg($433, 65562, #1)
regwrite=msg(regmsg(TCFS2.RegWrite), #1, #2)
...

Команды, возвращающие значения, можно использовать в качестве команд проверки. Также в TCFS2 с версии 2.0 можно прописать их в секции [Macros] и вызывать из параметров функций:

sepPos=msg($433, 65561)
L_isActive=tcm(65551)
L_viewMode=tcm(65553)
cxScreen=msg($433, 65570, 0)
cxWorkArea=msg($433, 65571, 0)
pressedShift=msg($433, 65572, $10) < 0
regread=msg(regmsg(TCFS2.RegRead), #1, #2-0)
...

Разумеется, номера команд или идентификаторы сообщений должны совпадать с указанными в файле конфигурации TCFS2Tools, если вы их переопределяете. В стандартном файле конфигурации TCFS2 уже прописаны некоторые команды, использующие TCFS2Tools. Для отправки сообщений по строковым идентификаторам необходима TCFS2 версии 2.0.4 и выше.



4. Загрузка при запуске ТК

Есть минимум 2 способа загрузки модуля при запуске ТК. Первый способ заключается в регистрации TCFS2Tools.dll в качестве WDX-модуля ТК с последующим определением специального шаблона цвета для типов файлов (Конфигурация, Цвета, для типов файлов, Добавить, Шаблон, вкладка Плагины, "TCFSTools.Autorun > 0", сохранить с любым именем, применить все изменения), заставляющего ТК загружать модуль автоматически.

Вы также можете использовать контентный модуль автозапуска Autorun.wdx, тогда достаточно прописать в его Autorun.cfg следующую строку:

LoadLibrary "X:\Path\To\TCFS2Tools.dll"


Обсуждение на официальном русскоязычном форуме: http://forum.wincmd.ru/viewtopic.php?t=13332



TCFS2Tools Module for Total Commander
-------------------------------------
(English section)

Expands TCFS2 functionality by allowing to:
+ show/hide main menu
+ temporary show main menu on menu call
+ show main menu as popup menu on user command
+ get/set file panel separator
+ get current view modes for panels
+ get system metrics via function GetSystemMetrics
+ get width and height of desktop work area



1. Configuration file and commands description

Configuration file should be placed near module and have same name and extension INI. You need it only if you wish to redefine default command identifiers and options (specified below after equals signs). There are two command types - TCM (with numeric id) and STR (with literal id). Read section 2 of this file to know how to call both.

Parameters for [HideMenu] section:
	MenuMode=0
		Main menu display mode when it is hidden: 0 - when Alt is pressed, main menu is temporary enabled; 1 - when Alt is pressed, main menu is displayed as popup menu.

Commands for [HideMenu] section:
	ShowMainMenu=65537
		Show main menu;
	HideMainMenu=65538
		Hide main menu;
	SwitchMainMenu=65539
		Switch main menu;
	TrackMainMenu=65540
		Display main menu as popup menu.

Commands for [Common] section:
	GetWindowMetrics=65550
		Get TC window dimensions and position. Parameter lParam specifies what to retrieve: 0, 1, 2, 3 - coordinates X, Y, width and height of entire window; 4, 5, 6, 7 - coordinates X, Y, width and height of client part of window (w/o title, menu and borders);
	LeftIsActive=65551
		Check if left (top) panel is active and returns 1 or 0;
	RightIsActive=65552
		Check if right (bottom) panel is active and returns 1 or 0.
	LeftGetViewMode=65553
		Get view mode for left panel (0 - brief, 1 - full or custom, 2 - tree);
	RightGetViewMode=65554
		Get view mode for right panel;
	IsVerticalPanels=65555
		Check if vertical panels arrangement is enabled and returns 1 or 0;
	SeparatorGet=65561
		Get file panels separator position;
	SeparatorSet=65562
		Set file panels separator position. You must pass new position in lParam parameter. If parameter is less than zero mouse will be used to move separator.

Commands for [System] section:
	GetSystemMetrics=65570
		Get system parameter value depending on index passed in lParam. Refer to GetSystemMetrics function documentation for supported indexes (e.g. 0 - screen width, 1 - screen height, 4 - window caption height) - there are more than 50 values;
	GetWorkArea=65571
		Get work area dimensions (w/o taskbar). Parameter lParam specifies which value you need to return (0 - work area width, 1 - work area height);
	GetAsyncKeyState=65572
		Get information about key state. Parameter lParam specifies virtual-key code. Refer to GetAsyncKeyState function documentation for virtual-key codes and return value description (e.g. 16 - Shift, 17 - Ctrl, 18 - Alt; negative return value tells that key is pressed);
	GetSomeInfo=65573
		Get some information depending on lParam value: 0 - number of msecs since Windows start.

Commands for [Registers] section:
	RegWrite=RegWrite
		Stores a number in a cell. Parameters: wParam - cell address (starting from 1), lParam - value to store;
	RegRead=RegRead
		Reads a value from a cell. Parameters: wParam - cell address, lParam - value that is returned on error;
	RegCount=RegCount
		Returns number of available cells (same as last cell address).

You must choose numbers greater or equal than 16384 if you redefine command indexes (messages within range 0-16383 are reserved by Windows).

Module adds "TCFS2." prefix to all literal ids that it registers (e.g. TCFS2.RegRead) even if you redefine it - when you send a message, you should add this prefix too.



2. Commands execution

2.1 TCM-commands

In order to call some command you need to send message with number WM_USER+51 ($433) to TC window after loading TCFS2Tools. Module will process message and return result. You need to specify command index as wParam message parameter. If you call command with parameter, you must pass it in lParam parameter.

If you don't have TCFS2Tools loaded or installed, TC will try to execute command itself. In most of cases it will show message that function is not realized (internal TC commands have another indexes).

2.2 STR-commands

You should get window message number associated with literal id using function RegisterWindowMessage. Don't forget to specify identifier with "TCFS2." prefix (e.g. TCFS2.RegRead). If command accepts parameters, you should pass them via wParam and lParam message parameters.

If TCFS2Tools is not loaded, message won't be processed.



3. Integration with TCFS2

TCFS2 Addon (download page is here: http://www.totalcmd.net/plugring/tcfs2.html) allows to control TC window modes, including sending TC internal commands. You should use tcm command in order to call TCFS2Tools command w/o parameters or msg command if you need to pass some parameters. By the way, tcm(x) acts like msg($433, x, 0, 0). You may add following lines to [Items] section of TCFS2 configuration file:

mm1=tcm(65537)
mm0=tcm(65538)
mm2=tcm(65539)
mm_track=tcm(65540)
set_separator=msg($433, 65562, #1)
regwrite=msg(regmsg(TCFS2.RegWrite), #1, #2)
...

Commands that return values may be used as check commands. Also since TCFS2 2.0 you may add some values to [Macros] section and call directly from parameters of functions:

sepPos=msg($433, 65561)
L_isActive=tcm(65551)
L_viewMode=tcm(65553)
cxScreen=msg($433, 65570, 0)
cxWorkArea=msg($433, 65571, 0)
pressedShift=msg($433, 65572, $10) < 0
regread=msg(regmsg(TCFS2.RegRead), #1, #2-0)
...

Of course, command indexes or literal identifiers must be the same with ones in HideMenu configuration file if you've redefined them. Default TCFS2 configuration file already has some commands that use TCFS2Tools. You need TCFS2 version 2.0.4 to be able to send messages with literal ids.



4. Loading module on TC start

There are at least two ways to load module on TC start. First way is to register TCFS2Tools.dll as WDX plugin and to define special 'color by file type' preset (Configuration, Color, by file type, Add, Define, Plugins tab, "TCFSTools.Autorun > 0", save with any name, apply all changes) to cause TC to load TCFS2Tools automatically.

You may also use Autorun.wdx content plugin in order to load HideMenu module on TC start. You need to add following line to Autorun.cfg file:

LoadLibrary "X:\Path\To\TCFS2Tools.dll"


Discussion page on official board: http://www.ghisler.ch/board/viewtopic.php?t=29700



History:

2012-03-14	1.4.2.154
	+ command to check vertical panels arrangement
	+ get/set separator commands now work with vertical panels

2011-11-14	1.4.2.130
	+ 64-bit version of module added
	+ commands to write numbers to internal array and read them back

2011-09-10	1.4.1.114
	+ commands to get exact current view mode for TC panels
	+ command to get TC window dimensions
	+ command to get some system information like number of msecs since Windows start

2011-05-07	1.4.0.88
	+ may be loaded w/o Autorun.wdx
	+ commands to get/set separator pos
	+ command to get work area width and height (w/o taskbar)
	+ command to get any GetSystemMetrics value
	+ command to get any key state

2010-11-20	1.2
	+ commands to check if left/right panel is active

2010-06-20	1.1.5
	+ changed default menu mode, now main menu temporary appears when Alt is pressed

2010-06-19	1.1
	+ shows popup menu on Alt key if main menu is hidden
	+ unload protection on cm_UnloadPlugins (loads itself to increase loads count)

2010-06-19	1.0
	! first public release
	+ show/hide menu feature
	+ shows main menu as popup menu
	+ shows empty line for HELP_BREAK
	+ controlled by windows messages sent to TC window
