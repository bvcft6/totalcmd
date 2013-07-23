
VirtualPanel plugin for Total Commander
---------------------------------------
(English section)

(If you find any errors in this readme file, please help me to fix them)

Temporary panel plugin for Total Commander:
+ keeps links to files and folders, and virtual folders
+ import/export of whole contents or separate directories
+ saving VP state on exit TC or Windows, by timer or after each modification
+ import/export of usual filelists (like m3u)
+ log file
+ asks for physical removing if Shift is down
+ correct copy/move operations processing
+ internal commands for extra functions (execute ? command for help)
+ batch commands execution and script files support
+ autoexecuted scripts on load state or enter directory
+ supports internal associations in TC 7.51 and later
+ standard cd command support in TC
+ external scripts support
+ multi-threading support (background operations in TC 7.55 and later)
+ virtual explorer with drag-and-drop support
+ full Unicode support


0. Some notation conventions

In most places of this file C language syntax is used to indicate characters and strings: characters are enclosed with apostrophes '' and strings are enclosed with double quotes "".

In command descriptions parameters or flags in square brackets are optional, construction like {a|b} means that either a or b should be used. Curly braces that don't have '|' symbol inside usually should be specified explicitly because they enclose some parameters.


1. Configuration file

Total Commander passes INI file name on plugin loading. If not (e.g. TC version earlier than 5.51) or if INI with plugin's name exists near the plugin, this file will be used as configuration file. File encoding may be ANSI or Unicode - you may change it manually using any text editor.

You may open plugin properties to get path to INI file.
Parameters in [Virtual Panel] section:

	AutoSaveInterval
		Default state file autosave interval in seconds;
	AutoSaveListOnEachOp=0
		Save default state file after each operation with virtual panel (if there are unsaved modifications);
	AutoUpdateScriptName
		Name of script file that will be executed on enter directory;
	DefFileList
		Path to default state file;
	DefFileListNewFormat=1
		Save default filelist using new compact format (uses less disk space);
	EnableAutoScripts
		Automatic scripts execution flags;
	Language
		Current language file name (just name w/o path and extension);
	LogEnabled
		Log event mask;
	LogPath
		Path to log file;
	MaxLogSize
		Max log file size (when file size exceeds this limit, it will be renamed and new log file will be started).
	RemovedFileIcon, RemovedFolderIcon
		Icons for inaccessible physical objects (e.g. removed);
	SaveIniOnUnload=1
		Save parameters into configuration file on unload plugin;
	VirtualFolderIcon
		Virtual folder icon path and index after comma;
	Explorer.RenameByF2=0
		If this option is enabled, F2 key renames focused item, else refreshes Virtual Explorer window;
	Explorer.RightPixels=0
		Specifies width of unused (last) column in full view mode after auto realigning - this column is useful for mouse selection. If option is set to -1, auto realigning not used.

Language files must be placed into Language folder near plugin, have any name and extension .lng. Language files are simple INI files, file must have [Virtual Panel] section with translated strings which have names 1, 2, 3 etc. You may use "\t", "\r", "\n" and '"' special characters in strings. In format strings you need to double '%' character, also do not remove combinations like "%s" or "%X" in such strings. Language file may be in ANSI or Unicode. Russian and English languages are hardcoded and don't require language file.

Please be careful with autosave feature. If you enable it and then do some unwanted modification (delete some useful scripts etc) you may lose previous state (by default state is saved only when plugin is unloaded). Also autosave may slow down your work since it plugin will save state file periodically (base is blocked during saving). You may use external scripts for saving state periodically using attached tool VPBatch - you will have chance to specify any path to state file or make backups of state file.

Parameter EnableAutoScripts supports following bits: 1 - use autoupdate scripts on enter directory (if AutoUpdateScriptName contains its name), 2 - execute enter directory script on each folder list (also during file search/sync) instead of execution only on manual browse, 4 - execute >Autoexec script on load state file, 8 - don't ask confirmation on >Autoexec script file execution, 16 - execute >Shutdown script on plugin unload.
	
If DefFileList parameter is specified, this file will be loaded automatically on VP start and saved on exit TC (also on exit Windows). Also, if AutoSaveInterval parameter is specified, VP will save state into this file automatically with given interval (in background thread, only when changes are made since last save). During saving virtual system access is blocked. If you set read-only attribute, this file won't be replaced. Also file won't be saved if there is no write access to save folder.

You may enable log for some event types by combining bits (by summation) in the mask (bits are: 1 - operation start/end, 2 - file actions, 4 - attributes setting, 8 - enum files actions, 16 - scripts execution, 32 - actions in Virtual Explorer windows). To enable all events you may use -1 value as bit mask. Note that you may limit log file size using MaxLogSize parameter in INI.

Virtual folders and links to inaccessible physical objects have special icons. You may edit INI in order to specify any other icons for theese objects.

All configuration parameters may be changed directly from configuration dialog. When you click OK button configuration is saved into INI file.


2. General features

Following object types are supported:
	Physical file/folder link - may be situated in virtual folder only, created when you add file into VP by copying (only for files) or with help of internal command (also for folders), you may access physical object via this link;
	Virtual folder - usual folder, TC creates it when you copy folder into VP or when you make new folder;
	Virtual file - object that have no link to physical file but TC shows it as a file (it may contain empty real path field or internal script in it).

All supported by Total Commander's FS interface functions are realized (execution, adding, moving, copying, removing, properties displaying). When you hold Shift while confirm deletion, plugin will ask you for physical files remove confirmation (confirmation is asked always when you remove files within physical folder link). When you copy folder into VP, TC copies its structure with virtual folders and file links, you can't create physical folder link directly. You need to use internal commands for adding physical folder links, or you may simply drop that folder into virtual explorer window. When removing physical files, they are placed to Recycle Bin by default (if TC configured to delete directly or Shift key was held on confirm physical files deletion, files are deleted directly).

When you execute application via file links, program launches from its directory (if you're in virtual folder) or from current physical folder (if you're inside of physical folder link). Also you may run programs with parameters and use standard cd command to change current path.

You may use standard TC shortcuts Ctrl+Left/Right if you want to jump to target physical file in inactive panel. Also, if you put focus onto file or archive and press Shift+Enter, VP will jump to this file (or shows archive contents) in new tab.

When you click Cancel in file system progress dialogs, TC doesn't allow to undo aborting. However VP supports such feature, but due to TC limitations it is possible to abort operation by clicking Cancel button only once, next time you will need to press Escape key to display abort dialog. The reason is that module ignores continuous TC notifications about cancelling after first Cancel clicking.


3. Internal commands and scripts

Commands allow to extend plugin functionality. They allow to perform actions unavailable directly from TC interface. Each command must be started with '<' character, you may specify more than one command sequentially in command line. Command flags should be specified in a single parameter w/o spaces. Script is a sequence of commands.

Supported internal commands:

	? (or any unsupported command)
		Show message with list of supported commands;
	add [/[r][f]] <virtual_path> [{<physical_path_or_script>}]
		Add physical file/folder link or a virtual folder or a script file depending on second parameter's value (you must enclose script into braces). Flags: r - create intermediate virtual folders, f - replace existing object;
	cd <virtual_path>
		Change current folder within current script;
	config
		Display settings dialog;
	convert <source_filelist_path> <filelist_path> [<virtual_path>]
		Converts list of virtual names or paths (that may be got via TC parameters like %F, %L, %WF etc.) into list of physical paths to files. Parameter virtual_path sets base virtual path for relative paths in a list (e.g. it should be path to folder with files whose names are listed by %F or %WF);
	deflist <filelist_path>
		Set default state file;
	del [/[r][f][d[!]]] <virtual_path_and_mask>
		Remove VP object (or multiple using mask). You can't remove physical objects with this command. Flags: r - remove non-empty folders, f - remove read-only files, d[!] - remove folders too (with ! - folders only);
	eas {<autoupdate_script_name> | <bit_mask>}
		Set autoupdate script name or autoexecution flags (refer to secion 1 of this Readme for details; in order to set -1 as bit mask use "-1" instead);
	edit <virtual_path> [<new_script_or_real_path>]
		Ñhange script text or target path for object. If second parameter is not specified, edit dialog will be shown;
	exec [/w] <command> [<parameters>]
		Execute command as if you enter it in command line (e.g. allows to start another scripts from scripts); Flags: w - wait for program termination (TC will be blocked);
	exit
		Exit from current script (started using exec command or from TC directly);
	explore [<virtual_path>]
		Open new Virtual Explorer window (refer to secion 6 of this Readme for details);
	export [/[a][e][f][r]] <filelist_path> [<virtual_path> [{<masks>}]]
		Export whole VP contents or contents of specified virtual folder into list file (just real paths - e.g. for Playlist creation). Masks allow to filter files to be exported. Flags: a - use ANSI encoding, e - append to existing list, f - overwrite existing file, r - recursively;
	flush
		Save parameters into configuration file;
	for [/[d[!]] [%<symbol>] <virtual_path> {<masks>} {<script_to_execute>}
		Execute some script for each matched object that can be found in specified folder. Percent sign with specified symbol found in script text will be replaced with object path (or just filename if '~' is specified after '%'). You need to double '%' symbol in script files. Flags: d[!] - search folders too (with '!' - folders only);
	ifcond {<expression> @ <virtual_path>} {<script_if_true>} [{<else_script>}
		Check condition for specified file. Expression may contain numbers, round brackets, operators +, -, *, /, conditional operators !, ||, &&, <, >, !=, <=, ==, >=. Also expression may contain keywords that will be expanded to values: a[a|c|d|h|r|s|A|C|D|H|R|S] - check attribute (attribute char case is important), date[now|YYYYMMDD], time[now|HHMM] - file date and time [or current or specified] (values converted to minutes since year 2000), size - file size, script - is it script file or not, valid - target accessibility, like "<mask>" - alows to check if file name matches mask. If target file is inaccessible, attributes are taken from cache. If value of expression is larget than 0, its true, if it is equal to 0, its false, else it is treated as faulty (no script will be executed in this case);
	ifdef <parameter> {<script_if_defined>} [{<else_script>}]
		If parameter is not blank, execute first script, else second (if specified);
	ifexist <virtual_path_and_mask> {<script_if_exists>} [{<else_script>}
		Execute first script if object exists (at least one that matches), else second (if specified);
	ifok <question_text> {<script_if_ok>} [{<else_script>}]
		Display question dialog and executes first or second (if specified) script depending on user's answer;
	lang <language>
		Switch language to specified language file;
	load [<filelist_path> [<virtual_path>]]
		Add objects from specified VP state file to contents of specified virtual folder; if virtual path is omitted, command clears VP and loads specified state file as root;
	log {<full_path_to_file> | <bit_mask>}
		Set log file path or log events mask (refer to secion 1 of this Readme for details; in order to set -1 as bit mask use "-1" instead);
	move <virtual_path> <new_virtual_path>
		Move or renames VP object. If destination is an existing folder, object is moved into it. Existing object (file or folder) will be replaced with all contents;
	properties
		Display properties dialog;
	put [/[a][l][d[!]]] <virtual_path> <physical_path_and_mask>
		Add links to specified physical objects. Flags: a - autorename files if such file already exist, d[!] - folders too (with '!' - folders only), l - add objects from specified file lists;
	save [/[a][e][f][m][o][r]] [<filelist_path> [<virtual_path> [{<masks>}]]]
		Export whole VP contents or contents of specified virtual folder into state file (if path is omitted default state file is saved). Masks allow to filter files to be exported. Flags: a - use ANSI encoding, e - append to existing list, f - overwrite existing file, m - save only if state was changed (the only flag used when default state file is saved), o - save full (old-style) list, r - recursively;
	silent
		Disable information and error messages until end of current script;
	tgmove <virtual_path> <physical_path>
		Allows to rename/move target object. New path may be full name or just filename.

Commands <for, <export, <save support multiple masks for filtering objects. If you specify multiple masks, you must enclose mask set with curly braces, e.g. {*.exe *.dat | s* t*} - mask set that includes files *.exe and *.dat except ones whose names start with 's' or 't'.

You may replace any parameter with '?' symbol if you want this parameter to be asked during script execution. If you specify a colon with following text (usually in quotes if text contains spaces - except for <exec command), this text will be used as ask param dialog text. Also you may interrupt script execution by pressing Esc key.

When you specify nested scripts (e.g. while adding script file) you must enclose each nested script into braces. If not, commands inside of script will be treated as commands of current script. Also it is necessary to enclose into braces all parameters containing '<' character (e.g. ifcond command expression). You may use environment variables in commands and scripts - they are expanded automatically (variables inside script files will be expanded during script execution).

Script file name must be started with '>' character. You may set read-only attribute for script file in order to protect it from removing. Script file has special icon, but you may also specify any external icon. You should specify external icon path (and index after comma, if need) after pair of less-than signs ("<<") at the end of script. In script files you may use environment variables inside pair of '%' chars, symbols "%1"-"%9" to paste parameters, "%0" to paste script file path. You must double '%' char to paste it ("%%").

In order to start external programs from VP scripts you need to add to VP link to attached tool Exec and use it to start external programs.

Supported file lists encodings (for put command) are ANSI, UTF-8 and Unicode. File must have byte order marker set at the beginning to allow encoding detection.


Example of command to add to \Music virtual folder all files from m3u lists in D:\Music physical folder:
<put /al \Music D:\Music\*.m3u

Example of command that creates >Refresh script file that will load video files from some physical folders into current virtual folder:
<add >Refresh { <silent <del *.avi <put /a . "D:\Video\*.avi" <put /al . "E:\Video\*.lst" }

Example of script file creation that allows to remove files by mask in current directory and its subdirectories recursively (script file will have custom icon):
<add \>rdelete { <for %%f . "%1" { <del "%%f" } <for /d! %%d . * { <cd "%%d" <exec \>rdelete "%1" } <<shell32.dll,31 }

Example of command that deletes all files with size less than 1 KB modified more than 14 days ago in current directory:
<for %f . * { <ifcond { !script && (size < 1024 && date < datenow - 14*24*60) @ %f } { <del "%f" } }

Example of command that deletes all files except scripts and *.mp3 and *.m3u in current directory:
<for %f . * { <ifcond { !script && !like "*.mp3" && !like "*.m3u" @ %f } { <del "%f" } }

Example of same command like above but using multiple masks (should work faster):
<for %f . {|*.mp3 *.m3u} { <ifcond { !script @ %f } { <del "%f" } }

Example of script file to move folders and merge them if destination exists:
<ifdef "%2" { <for /d %%f "" "%1" { <ifcond "aD @ %2\%%~f" { <for /d! %%g "" "%%f\*" { <exec "%0" "%%g\*" "%2\%%~f\%%~g" } <for %%g "" "%%f\*" { <move "%%g" "%2\%%~f" } <exit } <move "%%f" "%2\%%~f" } } {<ifok {Syntax: >movx <what> <where>} {} }

Example of command to export list of physical paths for files *.mp3 *.m3u | m* from virtual folder \Music into file D:\1.m3u:
<export D:\1.m3u \Music {*.mp3 *.m3u | m*}

Example of command to add link to TC folder (useful in >Autoexec script on USB stick, allows to start TC tools from VP):
<add /f \COMMANDER_PATH "%COMMANDER_PATH%"


4. Getting information about VP objects

Plugin have no own content fields but temporary panel plugin supports all content plugins fields and standard fields for physical files and folders (e.g. comment field or path field). E.g. to retrieve full path to physical target you should use [=tc.path][=tc.fullname] pattern for column. Do not forget to change file system to <General> in drop-down combo box above column sets list.

There are a lot of ways to get script file contents. One of them is to use Obj_RealPath field of NTLinks plugin (it shows script text for script files). Also there is an interesting way to get script text - you should place cursor onto script file and press F3 key. TC will show you error message with script text.


5. External script execution

VP allows to execute scripts by sending to TC special WM_COPYDATA message with COPYDATASTRUCT struct; dwData field of that struct must be set to 0x5056 (for script in ANSI) or to 0x00500056 (for script in Unicode); lpData field should point to script text to execute. Optionally before script text you may specify root name of VP that should execute script and work path; they must be separated with '\r' character, also null character with following script text must be specified after path. If work path is not specified, VP will use path that was listed in TC last time (most probably it is current virtual path). If you need to execute file from VP, use <exec command.

When current virtual folder changes, new path sets to environment variable "${Virtual Panel}Path", where "Virtual Panel" - VP root name in TC. Also, path sets to variable "${}Path" - but this variable is used by all VPs loaded in TC.

You may use attached tool VPBatch to execute script in VP, loaded in TC. 

Launch VPBatch w/o parameters to read about command line syntax.

Don't forget that if you call VPBatch from batch file you need to add additional ^ character before characters ^ and >.

Example of TC buttonbar button for adding physical folder as link:
VPBatch.exe ^exec { ^ifok "Add as %%${}Path%%"\%N? { ^add /r %N %P%N } {} }


6. Virtual Explorer

Virtual Explorer allows to have any number of browser windows. Every window may display virtual folder contents or real one if you have link to it (real path is displayed in window title in this case), last 20 visited folders are kept in browser history. Only left button selection mode is supported (like in Windows Explorer).

Supported keyboard shortcuts are:
	Alt+Enter
		Show properties;
	Alt+Left/Alt+Right
		Navigate through folder history;
	Alt+Down
		Open drop-down folder history menu;
	Backspace
		Go to parent directory;
	Ctrl+\
		Go to root directory;
	Ctrl+C
		Interrupt reading folder contents;
	Ctrl+A/Ctrl+Num +
		Select all files/folders;
	Ctrl+Num -
		Remove selection;
	Num *
		Invert selection;
	Del
		Delete selected items (Shift modified may be used to remove physical objects too);
	Shift+F6
		Rename focused object;
	F2/Ctrl+R
		Reread folder contents;
	Ctrl+F1/Ctrl+F2
		Change folder view mode;
	F12
		Switch "always on top" mode;
	Esc
		Close browser window.

You may drag files between theese windows and external applications (currently dragged to external applications files get original names and not virtual ones), also delete and rename operations are supported.


Discussion page on official board: http://www.ghisler.ch/board/viewtopic.php?t=24293



History:

2012-11-13	2.0.6.1264
	+ copying encrypted files to target that doesn't support encryption (moving is still not allowed)

2012-10-26	2.0.6.1262
	+ <convert command
	+ multiple include/exclude masks support in <for, <export, <save commands
	+ flag 'e' for <save, <export commands
	* <save command is not recursive by default now (use 'r' flag)
	* null characters in ANSI exported lists
	* correct icons for inaccessible files (like pagefile.sys)
	* explorer: paths for subfolders of links to physical folders haven't displayed in title

2012-09-22	2.0.5.1228
	+ <tgmove command now allows to move files between volumes
	* improved confirm dialog centering
	* fixed direct date/time calculation in <ifcond command (dateYYYYMMDD and timeHHMM)
	* load incomplete language file issue
	* some language corrections

2012-03-03	2.0.5.1208
	+ 64-bit version of Exec.exe added (allows to start processes like regedit.exe in 64-bit environment)
	* FsGetDefRootName returned "Virtual Pane" instead of "Virtual Panel" as default plugin root name (introduced in 1.0.0.922)
	* explorer: enormous font (introduced in 2.0.5.1206)

2011-09-19	2.0.5.1200
	+ 64-bit version of plugin added (requires 64-bit TC version)

2011-09-04	2.0.4.1154
	* loading external icons for scripts bug (introduced in 2.0.4.1150)
	* executing via command line bug (introduced in 2.0.4.1150)

2011-09-03	2.0.4.1150
	+ log report on save deflist (flag 2)
	* explorer: Del deleted all items if ".." was focused and no items selected
	* dynamic TLS is now used instead of static which is buggy for dynamic libraries
	* log string formats for FsDeleteFile, FsRemoveDir, FsMkDir, FsSetAttr slightly changed
	* log string format bug for FsSetTime
	* rename via <move command bug when only name characters case is changed
	* tab order in configuration dialog

2011-07-17	2.0.3.1120
	+ explorer: always on top toolbar button and F12 key
	+ explorer: now is able to delete physical folders recursively
	+ explorer: remove selection mark from focused item if no selection
	* <ifcond function now uses API to calculate exact number of minutes
	* explorer: bad colors when color values are set to -1 in wincmd.ini
	* explorer: focused item didn't become selected on Ctrl+A if inversed cursor used
	* explorer: Del deleted all items if no items were selected

2011-04-13	2.0.1.1090
	+ explorer: history item moves to end when clicked
	+ explorer: Alt+Down shows history
	+ explorer: Explorer.RenameByF2 and Explorer.RightPixels INI options
	* explorer: doesn't erase all history items after current on dir change
	* explorer: drag from root bug
	* explorer: couldn't enter folders after going to root using Ctrl+\
	* wrong processing of "like" operator argument for <ifcond command

2011-04-11	2.0.0.1080
	+ virtual explorer allowing to have any number of browser windows
	+ virtual explorer interface tries to copy TC style
	+ drag-n-drop support between virtual browser windows and external applications
	+ new log event for Virtual Explorer actions
	+ max state file line length is now 8k characters
	+ <put command may add folders from lists created via e.g. cm_SaveSelectionToFile (trailing folder slashes are now stripped)
	+ <edit command now allows to edit empty targets for files
	* recursive intermediate folders creation bug (after some changes in 1.0.0.920)
	* <for command produced wrong names
	* bits 0x01 and 0x02 of LogEnabled parameter exchanged
	* log string format for FsPutFile slightly changed

2011-03-12	1.0.0.920
	+ VPBatch now accepts root name in both direct form and TC-style path form (\\\Virtual Panel\...)
	+ own environment variables expander (leaves %xx% as is if variable xx is undefined)
	+ long scripts are now saved w/o truncation
	* save bug when long scripts are used
	* exception while processing long scripts that were sent via WM_COPYDATA in Unicode

2010-12-01	1.0.0.904
	+ log now shows thread id (for background threads detection)
	* some optimizations
	* correct retrieving plugin version info on Windows 2000
	* wrong filelists processing e.g. in <put command (after some changes in 1.0.0.850)
	* some small fixes

2010-07-12	1.0.0.820
	+ flag 'm' for <save command
	+ autosave after every operation feature (only if state was modified) - you may enable it in settings

2010-05-13	1.0.0.800
	+ always starts executables (.exe, .lnk, .cmd, .bat, .com) itself to set right working path
	+ overwrites list files w/o deleting (preserves attributes and permissions)
	* wrong working path for executables started from command line within virtual folder

2010-04-21	1.0.0.780
	+ always returns FS_EXEC_OK on show properties (TC doesn't show ugly dialog on error)
	+ allows to abort operations by first pressing Cancel button (if user cancels aborting then only by Escape)
	+ thread local storage is used for storing thread-specific data
	* wrong properties dialog for pure virtual objects

2010-04-15	1.0.0.760
	+ flag f for <save and <export commands to overwrite existing file
	+ may execute special >Shutdown script on plugin unload
	+ configuration is saved to INI when user clicks OK button in configuration fialog
	+ new INI parameter SaveIniOnUnload allows to disable saving INI on exit
	+ <flush command to manual save configuration to INI file
	+ <tgmove command to rename/move target object (link is fixed automatically)
	+ log event flag for scripts execution
	+ status log message for VPBatch commands

2010-04-12	1.0.0.700
	+ put, renmove, mkdir operations create absent intermediate folders
	* Ctrl+Tab didn't work after pressing Apply button
	* focus bug in confirmation dialog
	* <exec command bug if parameter was in braces

2010-04-09	1.0.0.690
	+ group answers for link creation question when user tries to move physical file to virtual folder
	+ new settings tab in configuration dialog
	+ configuration dialog uses Windows theme colors (calls EnableThemeDialogTexture function if available)
	+ buttons OK, Cancel, Apply in configuration dialog
	+ internal command <config to show settings tab of configuration dialog
	* open properties command in TC 7.55 was overridden by internal execute feature
	* exception on move from physical folder to virtual
	* overwrite read-only physical file error
	* bug in <save command when started w/o params and user answers No on save deflist question
	* changed line order in information box of configuration dialog (localization line 8)

2010-04-01	1.0.0.620
	+ compact state file format
	+ flag 'o' for <save command to save old-style state file
	+ safe multi-thread enum files (list builds in single critical section during FsFindFirst call)
	+ faster saving (files in subfolders now searched from folder handle and not from root)
	+ faster loading/unloading large states (now boost::fast_pool_allocator is used as map allocator)
	* wrong <for parameters order
	* set time/date for script files bug
	* <put command accepted relative path incorrectly
	* wrong mask processing by <export command

2010-03-29	1.0.0.580
	+ environment variables ${Virtual Panel}Path and ${}Path keep last listed VP path
	+ new flags for <add command (to replace existing object and to create intermediate virtual folders)
	+ multi-thread access to virtual system
	+ <move command
	+ <for command now replaces %~<symbol> with just filename
	+ allows to cancel aborting of any operation (checks if Escape is held instead of accepting TC abort flag)
	* Shift+Enter jumped to file's folder instead of jumping to file (after some changes in 1.0.0.550)
	* Shift+Enter in TC 7.55 was overridden by internal execute feature
	* <for command parameters processing bug
	* buggy parsing paths with ".."
	* removed questions in <save and <export commands after <silent

2010-03-24	1.0.0.550
	+ changed default image base address
	+ now VP may execute scripts sent to TC using WM_COPYDATA message
	+ attached tool VPBatch to send scripts to VP
	* blocks multiple timer event thread creation (event skipped if previous yet working)
	* kills timers and waits for exiting timer event processors when plugin is unloading
	* log path changing from configuration dialog now works
	* fixed launching applications from physical folder

2010-03-15	1.0.0.520
	+ autosave default state file by timer feature
	+ new operator "like" for <ifcond command allows to check if filename matches mask
	+ <exec command now asks for command line if parameter begins with '?'
	+ expanding environment variables in parameters for launched executables
	+ shows help on "?" command too
	+ if parameter looks like ?:"<text>", text is used as ask param dialog text
	* wrong environment variables processing in cd command
	* reread source call after operations removed
	* read-only files delete mode bug
	* "%%" parsing error in script files

2010-03-08	1.0.0.500
	+ supports internal associations in TC 7.51 and later
	+ saves state on exit Windows
	+ multi-thread safe virtual system access
	+ non-modal configuration dialog
	+ standard cd command support in TC

2010-02-25	1.0.0.494
	+ information box in cfg dialog and language, icons etc are updated after changing parameters if need
	+ links to inaccessible folders are treated now as empty folders so TC may delete them
	+ shows time for each log line
	+ percent char in script files is now processed like in usual batch files
	* changed font in cfg dialog and tab view (in some Windows themes vertical tabs are buggy)
	* empty text now may be accepted as parameter value in cfg dialog
	* wrong detection of flag 'a' in <put command

2010-02-17	1.0.0.470
	+ configuration dialog
	+ moving from VP (physical file is copied and link is removed)
	+ <put command may now add files or folders or both
	+ flag 'a' for <put command to autorename file if such file already exists
	+ flag 'w' for <exec command to wait for process termination
	* fixed physical moving from VP (file was moved but link was left)

2010-02-11	1.0.0.420
	+ Shift+Enter jumps to file or enters archive in new tab
	+ new keyword to detect scripts (for <ifcond command)
	+ ifcond now understands relative paths
	+ log file size limit feature
	* fixed dates comparing in <ifcond command (wrong conversion to number of minutes)
	* check for existance before starting autoupdate script (avoid some execution errors)
	* %0 in script now treated as script filename
	* trailing spaces in condition of <ifcond command are removed
	* fixed exporting filenames in ANSI (Unicode w/o BOM was written)

2010-02-06	1.0.0.400
	+ removes physical files to recycle bin by default (checks if Shift is held and corresponding TC setting before)
	+ default filelist now is saved on exit only if VP state was modified during session
	+ <load command may be executed w/o parameters now for loading default filelist state
	+ <eas command now allows to change autoupdate script name
	+ new flag 'a' for <save/<export to save with ANSI encoding
	+ new command <ifcond that allows to check file attributes etc
	* removed locked dialog on exit if INI can't be written
	* all commands now fit into help dialog
	* some other fixes

2010-02-03	1.0.0.370
	+ script files now can be executed with params (supported %0 for whole script text and %1-%9 for parameters)
	+ improved <del command: may remove files or folders or both
	+ new condition commands <ifexist, <ifdef and <ifok
	+ new <for command allowing to execute script for all matched objects (files or folders or both)
	+ new <cd command for changing current path within script
	+ infinite script execution loop protection
	* wrong icon was displayed for inaccessible EXE and LNK
	* crash after entering text in TC request dialog
	* some other fixes that I can't remember :)

2010-02-02	1.0.0.340
	+ plugin now keeps content in %TEMP%\VirtualPanel.lst file by default
	+ inaccessible physical objects have special icons (you may specify another icons in configuration file)
	+ <edit command allows to change script or path
	* fixed crash on first start (with empty configuration file)
	* some small fixes

2010-01-31	1.0.0.322
	+ Unicode support! all functions use Unicode by default; ANSI functions replaced with stubs that call Unicode functions
	+ supports adding files from filelists in ANSI, UTF-8 and Unicode
	+ recursive and/or by mask filelist export
	* removed retrieving plugin file version on Windows 2000 because of strange crash during initialization

2010-01-24	1.0.0.200
	+ now files with read-only attribute may be removed (except scripts), also forced flag 'f' added to <del command
	* now files can be moved from virtual folder even w/o holding Shift key (confirmation is displayed)
	* fixed move file to normal panel (removed error checking if move function succeeds)
	* system search handle leak in FsFindNext function (one handle per file in virtual folder)

2009-12-24	1.0.0.194
	+ added language file support for translation (see sample in Language folder)
	* parameters parsing bug (e.g. for <add command)

2009-12-09	1.0.0.180
	+ added change case only renaming
	+ if INI with plugin's name exists near the plugin, this file is used as configuration file
	+ shows error message if configuration isn't saved (e.g. no write permission to INI)
	* null settings are not saved now when plugin loaded during installation
	* some minor fixes

2009-11-05	1.0.0.166
	* error opening script file mesage if file doesn't exist
	* error copying file within VP - file was moved instead

2009-10-26	1.0.0.162
	+ special delete physical files confirmation dialog
	+ <del command supports wildcards and keeps read-only files
	+ autoexecuted scripts - on load list and on list directory contents
	+ this Readme file :)
	* division by zero when copy empty files from VP
	* new FsExtractCustomIcon function extracts non-standard icons in background and causes TC to use less GDI objects

2009-10-18	1.0.0.121
	+ expanding of environment variables in commands and scripts except braced blocks
	+ import/export partial folder
	+ <put command allows to add physical files and entire filelists (e.g. playlists, full/relative paths) by mask
	+ <export command to export just physical names from virtual folder (e.g. to make playlist)
	+ <load command clears VP contents only if executed w/o second parameter
	+ you can't delete read-only script files (protection)
	+ added panels refreshing after VP operations
	* exception in <load command
	* set attributes for internal objects not always worked

2009-10-12	1.0.0.97
	+ log event groups
	+ correct initialization for older TC versions (w/o FsSetDefaultParams func support)
	+ support full internal paths starting from plugin name (for Ctrl+Shift+Enter)
	+ <add command supports nested blocks of commands in braces
	* log was always disabled at startup

2009-10-12	1.0.0.83
	+ batch script support
	+ if command parameter equals to "?", it is asked (useful for scripts)

2009-10-10	1.0.0.36
	* bug in filelist importing when line end was at the end of buffer

2009-10-10	1.0.0.xx
	! first public release
	+ virtual files/folders, links to physical files/folders
	+ internal commands allow to add/delete objects, import/export filelist and set default filelist
	+ correct links handling by TC
	+ correct copy/move operations between physical paths
	+ physical delete confirmation dialog if Shift is held
