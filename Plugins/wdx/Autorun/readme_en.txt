Autorun "content plugin" 1.6 beta 13
====================================

This is simple "content" plugin for manage some actions while starting Total Commander. At first this is was the personal project, that was made for merge different autorun tasks into single interface. Now it's developing mainly for making portable version simple. It's cover the most of startup requirements. For more advanced or specific actions is more reasonable run the script or create plugin in traditional language. 

This plugin is a simple command processor that executes commands from text configuration file. All commands executes in the separate thread and should not freeze TC in case of problem in one of commands. It's possible to use variables and simple If..Else condition.

Autorun should work on any OS from Win2000 to Win8, but currently tested only on WinXP SP3 and Win7 x64.

Installation
------------
Before installing plugin recommend to rename autorun.example.cfg file into autorun.cfg, and edit it if needed. Installation of plugin is usual for content plugins. Next, in order to load plugin at Total Commander start, you should create the fictitious color scheme:

Х On the "Color" page press "Define colors by file type..." button. 
Х In the "Define colors by file type" dialog set cursor in any place in the list, and press "Add..." button. 
Х Press "Define..." button. 
Х In the "Define selection" dialog move to "Plugins" tab.
Х Select in "Plugin" dropdown list "autorun".
Х Select in "Property" dropdown list "Autorun" (there will not be more properties).
Х Select in "OP" dropdown list "=" and set in following field any integer, for example 1. 
Х Press "Save" button, give the template some name , for example "Autorun".
Х Next, repeatedly press OK  button in all dialogs until options dialog will be closed.
Х Restart TC.

If you have many color schemes, it's recommended to move Autorun scheme to the top of list, else it can not run sometimes.

Plugin can be renamed, in this case change the name of configuration file correspondingly.

Configuration file
------------------
Configuration file is plain text file, either ANSI or UTF-16 (LE). 

Plugin operate two sections in configuration file. First section executing when TC starting, second - when it finishing. Sections separating by #FinalizeSection directive.

Directives
----------
Directives are performed at the script preprocess. Directive is starting with "Pragma" keyword.

AutorunFinalizeSection - the part of script after this directive running when Total Commander closing.
AutorunBlockUnload     - blocking the plugin unloading (with cm_UnloadPlugins) till the TC closing. Useful when using ShellExec with /T. When directive is absent, blocking disabled.

Variables
---------
Plugin operate with two kinds of variables - internal and environment. The only difference - internal variables are visible only in plugin, where environment variables are available for Total Commander and programs called from TC.
In common, variable is alphanumeric string, enclosed with "%" signs. Internal variables are defined with Set command, environment variables -  with SetEnv.

Autorun have one special variable %ERROR%. It usually should be zero, but some commands can set it to another value in case of non-fatal errors in command. If you need this info, you should check this variable right after command execution, because next command will reset it.

Also, autorun have few predefined variables (constants):

%AUTORUN_TCHANDLE% - Total Commander's window handle (for using in scripts).
%AUTORUN_TCPID%  - process ID of Total Commander (for using in scripts).
%AUTORUN_ISADMIN% - return 1 is TC executed under admin, 0 otherwise
%AUTORUN_TCARCH% - 32 or 64 - TotalCommander architecture where plugin is loaded.

Redefine the predefined constants are not allowed.

More system constansts available in Sysinfo plugin.

Conditional
-----------
Here is one and only conditional statement:

If <expression 1> Then
  ...
ElseIf <expression 2> Then
  ...
Else
  ...
EndIf

Simple conditional statement. For numeric comparison operator can be one of: =, <>, >, <, >=, <=. For string comparison only = and <> allowed, comparison is case insensitive. If both expressions are numeric, then numeric comparison used. 

Variables are always expanding in the expressions. If you assume that variable value can conatin spaces, wrap expression in quotes. Example:

If ("%var_with_spaces%" = "value") Then

Also, some special functions can be used in comparison. In this case comparison limited to only one function.

If Function1 <parameters> Then
  ...
ElseIf Function2 <parameters> Then
  ...
Else
  ...
EndIf

Commands
--------
AutorunBlockUnload <True/False> - command temporarily leaved for compatibility. Use "Pragma AutorunBlockUnload" instead.

FileExist <variable name> <filename>
FileExist <filename>
Function available for direct calling and using in conditional. When direct calling, first mandatory parameter should be variable name, which will receive 0 or 1, depending on function result.

Set [/C] | [/EV] [/EE] <var name> <var text>
Sets internal variable. All internal variables are text, but can be treated as numeric in comparison.
[/C] - treat var text as numeric and calculate the expression. Four aritmetic operations and parenthesis are supported, variables (environment too) are always expanding.
[/EV] - enbables using environment variable in text.  
[/EE] - enbables using escape characters in text.

Note: when using /C parameter, any non-numeric string lead to zero, /EV /EE parameters are not taking in account.

SendCommand <command>
Sends to TC it's internal command. Can be literal (values retrieving from TOTALCMD.INC) or numeric.

ShellExec [/EV] [/SW_HIDE|/SW_SHOWNORMAL|/SW_MINIMIZE|/SW_MAXIMIZE] [/T|/TT] [/W[:####]] <filename> [<parameters> [<working dir>]]
Executes the file. If no params are set, but you need to set working directory, use empty string (two consecutive quotes). Any environment variable can be used in any path.
Optional parameters:
[/EV] - enbables using environment variables also in parameters.
[/SW_HIDE] - hidden
[/SW_SHOWNORMAL] - normal (by default), also using when no explicit SW_* parameter set
[/SW_MINIMIZE] - minimized
[/SW_MAXIMIZE] - maximized to all screen
[/T] - terminate program when plugin unloading (also look AutorunBlockUnload command)
[/TT] - terminate program tree when plugin unloading
[/W] - trying to close process window before program terminating. Default closing timeout 1000 ms. After parameter can be optional value that sets timeout, ex: /W:5000. This parameter can be used only with /T or /TT paramaters.
[/WAIT] - waiting for process finish. By default waiting is infinite. After parameter can be optional value that sets timeout, ex: /WAIT:5000. When using this parameter /T or /TT paramaters are ignored.

CommandExec [/CD[:T|S|TS]] <command/path1> [<path2>]
Execute user command em_*** or set paths in the panels.
[/CD] - first and optional secons paramaters - paths for setting in panels.  After parameter can be optional flags how to set paths: T - open in new tab, S - make first path as source, second as target, else left and right panels  accordingly, ST - combination of parameters.

SetEnv [/A] [/EV] [/EE] <var name> <var text>
Sets environment variable for current process. 
Optional parameters:
[/A] - appends a text to exising variable text (replacing instead).
[/AD] - the same as /A, but allow duplicating (look note)
[/EV] - enbables using environment variable in text.
[/EE] - enbables using escape characters in text.

Note: by default, when using parameter /A, plugin is checking if text at the end of variable's text the same as text being added, and not adding it repeatedly. This allow to avoid the case when text is repeatedly adding when you restart TC or unload plugin by cm_UnloadPlugins. If you still need to add text without this check use /AD.

Usage example: place "noclose.pif" in TC folder and add this path to the PATH variable for current process, after that Shift+Enter command will work correctly without placing this file to windows directory (portable mode).

Sleep <delay>
Delay before executing next command in milliseconds.

IniDelete <ini name> <section> [<key>]
Deleting key or section from given configuration file.
If <key> is omitted, the whole section will be deleted. Use carefully!

IniRead <var name> <ini name> <section> <key> [<default value>]
Read the value from given configuration file. 
First parameter should be name of variable. If variable not exists, it will be created. Default value is the value that will be returned in case of function failure (error with file, missed key etc.)

IniWrite [/EV] <ini name> <section> <key> [<value>]
Writing value into given configuration file. In writing failed, command set ERROR variable to 1.
Optional parameters:
[/EV] - enbables using environment variable in value.
This command is partucularly useful in portable compilations for fixing paths for some programs that are not smart enough to run in any place.

Language <ID>
Load custom language for messages from autorun.lng file. If this command absent the default language (English) will be used.

LoadFont [/N] <font name>
Command that loading selecting font. By default this font will be available in Total Commander process only and will be unloaded when TC is closed.
[/N] - allow other applications using this font. Note, that font still become unavailable when TC is closed.

LoadLibrary [/U] <dll name> [<function>]
Command that loading a dynamic library (paths can be relative to plugin path). Also can execute parameterless function.
Optional parameters:
[/U] - dll will be unloaded immediately after loading and executing function (if this set).

This command also loading plugins, read more about in corresponding section.

Note: code that executing while library initialization, running in the main thread, so when using blocking functions (like MessageBox), the Total Commander loading will be suspended. In order to avoid this, don't use those functions in the initializing code, or use explicit function call.

RegRead [/HEX] <key> <parameter> [<default text>]
Read the registry value. Supported types: REG_DWORD, REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ, REG_BINARY (return hex-string). If you need to retieve default paramter, don't set parameter, or set it empty in case you need to use default text.
Optional parameters:
[/HEX] - return REG_DWORD parameter as hex-string, else decimal.
[/I:xxx] - string index (starts with 1) for the REG_MULTI_SZ parameter. If not set, whole line return, separated with line breaks.

StrUpper <var name> <text>
Change text to uppercase and write result to variable. 

StrLower <var name> <text>
Change text to lowercase and write result to variable. 

StrMid  <var name> <text> <position> [<count>]
Extracts a number of characters from a text from given position. If count is omitted, then extracted characters till string end.

StrLeft  <var name> <text> <count>
Write to variable the leftmost count characters of the string.

StrRight <var name> <text> <count>
Write to variable the rightmost count characters of the string.

StrTrim  <var name> <text>
Write to variable the text with trimmed out leading and trailing whitespaces.

StrLen  <var name> <text>
Write to variable the text length.

StrPos [/S] <var name> <text> <substr>
Write to variable the substring position in the string. If not found, zero returned.
Optional parameters:
[/S] - case-sensitive search.

StrReplace [/S]  <var name> <text> <old substr> [<new substr>]
Write to variable text with old substrings replaced by new ones.
Optional parameters:
[/S] - case-sensitive search.

Notes
-----
If space used in command parameter, take it into quotes - double or single. In this case quotes of another type can be used in text. 
Example:

"param with spaces"
'param with spaces'
"param with spaces and 'quotes'"
'param with spaces and "quotes"'

If you need to use in text quotes of both types, the quote of type that opens parameter should be doubled in the text. 
Example: 

"this ""text"" and this 'text' with quotes" 
'this "text" and this ''text'' with quotes'

Line that begin with # treating as comment. Empty lines are ignoring.

Optional named parameters should start with "/" and should be placed before mandatory parameters.

Plugins
-------
If needed to use own commands with parameters, it's possible to use plugins. They are loading with LoadLibrary command.

One example plugin already included in the distributive, it intended to moving the "Options" button in the copy/move dialogs of Total Commander (since it's new position starting from TC 7.50 don't liked by many people). After loading plugin with LoadLibrary the new command become enabled:

MoveOptionsButton <MOVE_LEGACY|MOVE_RIGHT>
It's parameter can be one of:
[MOVE_LEGACY] - moving button to position as in versions prior 7.5
[MOVE_RIGHT] - moving button to right side of dialog
The command can be executed only once, following calls are ignoring. Plugin works correctly only for TC version 7.55 and up.
 

Sysinfo
-------
Plugin exports next constants:

%SYSINFO_OSARCH% - architecture of OS where TC is running. This can be either 32 or 64.
%SYSINFO_OSVERSION% - version of OS where TC is running. This can be one of:

WIN_2000, WIN_XP, WIN_2003, WIN_2003R2, WIN_VISTA, WIN_2008, WIN_7, WIN_2008R2, WIN_8, WIN_2012

If version can not detected, returned the string:

"WIN_" + Major Version + "." + Minor Version

For workstation at the end of string "W" attached.

For example, for Windows 7 it's would be: WIN_6.2W, for Windows Server 2008 - WIN_6.1.

%SYSINFO_DESKTOPWIDTH% - desktop width.
%SYSINFO_DESKTOPHEIGHT% - desktop height.
%SYSINFO_DESKTOPDEPTH% - desktop depth.

And next function:

GetSystemMetrics <variable name> <metric index>
Return metric value by given index. First parameter should be name of variable. If variable not exists, it will be created.

Process
-------
This plugin will contain additional functions for working with processes.

ProcessExist [/F] [/EV] <variable name> <process name>
ProcessExist [/F] [/EV] <process name>
Function available for direct calling and using in conditional. When direct calling, first mandatory parameter should be variable name, which will receive 0 or 1, depending on function result.
[/F] - compare process by full path.
[/EV] - enbables using environment variable in text.

ProcessCount [/F] [/EV]  <variable name> <process name>
Count number of running processes with given name.
First parameter should be name of variable. If variable not exists, it will be created.
[/F] - compare process by full path.
[/EV] - enbables using environment variable in text.

ProcessTerminate [/F] [/EV] [/TT] [/A] [/W[:####]] <process name 1> [<process name 2> [... <process name N>]]
Close one or more processes. Note that optional paramters apply to every process in list.
[/F] - compare process by full path.
[/EV] - enbables using environment variable in text.
[/TT] - terminate program tree.
[/W] - trying to close process window before program terminating. Default closing timeout 1000 ms. After parameter can be optional value that sets timeout, ex: /W:5000.
[/A] - close all processes with the same name (else first only).

ProcessExecGetOutput [/EV] [/OEM] <variable name> <filename> [<parameters> [<working dir>]]
Executing process (hidden) and gets it's result via stdout into variable.
[/EV] - enbables using environment variable in parameters.
[/OEM] - program output in OEM-encoding (ANSI by default)

x64 specific information
------------------------
Working with x64 version is the same as with x86, with exception loading libraries and plugins. Under 64-bit version you can load 64-bit libraries and plugins only, under 32-bit varsion - correspondingly 32-bit libraries.

For simplicity plugin using and using single config file in different TC versions, for 64-bit verions implicit loading used (similarly to TC plugins). For that 64-bit version of plugin should have "dll64" extension. In configuration "dll" extension using.

Example (on MoveButton): record in configuration "LoadLibrary Plugins\Autorun_MoveButton.dll". Under 32-bit version will be loaded Autorun_MoveButton.dll, under 64-bit version - Autorun_MoveButton.dll64.

History
-------
1.6 beta 13
+ added %ERROR% variable functionality
+ added commands SystemParametersInfo, GetSysColor into SysInfo plugin
+ basic functions for working with strings
- removed Win9x/ME/NT4 support from Sysinfo plugin (Autorun will not work on these OS)
* IniWrite will not show error dialog in case writing impossibility (sets %ERROR% instead)
* changed API a bit, added sending a buffer size
* reduced size of standard plugins
* by default variables expanded, use /EV- switch to disable

1.6 beta 12
+ added API for —++
* system information moved to Sysinfo plugin
+ added Sysinfo plugin
- fixed empty string handling in expressions
- fixed incorrect script loading in certain situations

1.6 beta 11
+ command ProcessExecGetOutput in Process plugin
+ command RegRead
- fixed bug with expression that have and/or keywords

1.6 beta 10
+ Additional examples of using quotes in documentation
+ /WAIT parameter for ShellExec
* AutorunBlockUnload now used in Pragma (function leaved for compatibility)
* FinalizeSection renamed to AutorunFinalizeSection and used in Pragma
+ New keyword Pragma for directives
* FileExist works with dirs with trailing "\"

1.6 beta 9
+ FileExist function
* optimized code, slightly reduced plugin size
* internal variables can have empty value

1.6 beta 8
- fixed incorrect line numbers in error messages
- fixed crash when using == in comparison

1.6 beta 7
+ ability to make actions when TC closing
+ added function ProcessTerminate in the Process plugin
+ configuration file can be either ANSI or UTF-16(LE).
- fixed problem with ShellExec in certain conditions

1.6 beta 6
+ added full-fledged comparison expressions
+ special functions for comparisons
+ Process plugin (working with processes)
* language file changes

1.6 beta 5
* fully changed plugin API
+ %AUTORUN_TCPID% constant added
+ added Windows 8 detection
* updated language

1.6 beta 4
- fixed string comparing
- fixed OS detection

1.6 beta 3
+ example of using conditional block is added to autorun.example.cfg
- language file mistakes
- fixed broken CommandExec command
- fixed crash on exit when using T/TT keys in ShellExec

1.6 beta 2
* rewritten MoveButton plugin to reduce CPU load
+ added AUTORUN_TCARCH constant (32 or 64)
- fixed wrong "Autorun" field

1.6 beta 1 
+ added x64 version
- fixed dll path searching


1.5.0 - Added %AUTORUN_ISADMIN% constant
1.4.9.6 beta - CommandExec rewritten
1.4.9.5 beta - fixed closing routines
1.4.9.4 beta - added /W for ShellExec
1.4.9.3 beta - added /TT for ShellExec
1.4.9.2 beta - added /T for ShellExec, added AutorunBlockUnload command, fixed versioninfo
1.4.9.1 beta - added variables (Set), conditional expression, LoadFont, messages translation
1.4.7 - added IniDelete command
1.4.6 - fixed lockup on empty lines in configuration file
1.4.5 - small fix in expand variables function, removed limitation of using mixed quotes
1.4.4 - fixed installation via TC Plugin Manager, added version info
1.4.3 - fixed bug when environment variable become empty in append mode, if it's initial length was big enough
1.4.2 - added /AD parameter for SetEnv command (read the note)
1.4.1 - fixed TC crash when calling cm_UnloadPlugins
1.4 - changed handling of optional parameters/switches, added ability for loading libraries, added plugins, added IniWrite
1.3 - added showing parameters for ShellExecute command, value of Autorun field can be compared to anything
1.2 - first public version, script-like configuration file instead .ini
1.1 - added environment variables support and some other improvements
1.0 - first version, three commans, keep config in .ini file

Plans
-----
At first this is was the personal project, that was made for myself. I think it cover the most of startup requirements. For more advanced or specific actions is more reasonable run the script or create plugin in traditional language. 
Bug reports are welcome. Suggestions too, but they can be added in "core" only if they are universal enough. 
NO visual configurators are planned at all.

For developers
--------------
When loading library with LoadLibrary, Autorun is trying to find Autorun_PluginInit function, if this is found, calling it allow developer to define custom commands and variables. Function get the AutorunInterface type structure with some useful information and pointer to adapter function. For working with functions it's need to assign this pointer to global variable Adapter.

Now next functions are exists:

procedure AddFunc(AName: PWideChar; AAddr: Pointer; AFlags: integer);

Adds user function for using in the Autorun script.

function ParseNext(AParamStr: PWideChar; ABuffer: PWideChar): integer;

Write first parameter from string to buffer ABuffer. Also this parameter is deleting from source string. Function return parameter type (AU_PARSER_NAMEDPARARAM, AU_PARSER_REGULARPARAM). If no more parameters, returns AU_PARSER_NOMOREPARAMS.

function GetVar(AVarName: PWideChar; Buffer: PWideChar): integer;

Write into buffer ABuffer value of variable with AVarName name. If variable not exist function return error code AU_RESULT_VARNOEXIST.

function SetVar(const AName, AValue: PWideChar; AFlags: integer): integer;

Set variable with name AName and value AValue. If AFlags is have AU_VAR_CONSTANT set, variable will be protected from changes. If this function trying to change constant, it's value will be preserved, and function return error code AU_RESULT_NOREDEFINECONST.

function ExpandVars(const AText: PWideChar; ABuffer: PWideChar): integer;

Expanding variables еременные в тексте AText с учетом внутренних переменных и переменных окружени€ и возвращает результат в буфер ABuffer.

ѕодробнее смотрите в прилагаемом файле testplugin_src.zip

Copyright (c) 2010-2012 Dmitry Yudin

Look more in the file testplugin_src.zip

Copyright (c) 2010-2012 Dmitry Yudin