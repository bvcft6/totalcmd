
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
		Get internal command index of current view mode for left panel (101 - brief, 102 - full, 71 - first custom mode etc.). Works only for modes listed in menu on cm_LeftCustomViewMenu;
	RightGetViewMode=65554
		Like LeftGetViewMode but for right panel;
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
		Get desktop work area dimensions and position (w/o taskbar). Parameter lParam specifies which value you need to return (0 - width, 1 - height, 2 - horizontal position, 3 - vertical position);
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

You must choose numbers not used by TC if you redefine command indexes (read TOTALCMD.inc file for used numbers).

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

2013-03-28	1.4.2.164
	+ GetWorkArea is now able to return also work area position
	* wrong work area size returned in case of left or top taskbar position

2012-11-17	1.4.2.158
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
