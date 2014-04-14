; Start Total Commander with a tray icon.
; It allows the user to Show/Hide TC by clicking on it.
; The script allows more instances of TC running, each having its own tray icon.

DetectHiddenWindows On

Menu Tray, Icon, C:\Programme\Total Commander\TOTALCMD.EXE
Menu Tray, NoStandard
Menu Tray, Add, Hide, subShowHide
Menu Tray, Default, Hide
Menu Tray, Add
Menu Tray, Add, Exit, subExit
Menu Tray, Click, ClickCount 1
Menu Tray, Tip, Total Commander

OnExit subExit

bHidden := False

RunWait "C:\Programme\Total Commander\TOTALCMD.EXE",,,pidTC
Return

subShowHide:
	if (bHidden)
	{
		WinActivate ahk_pid %pidTC%
		WinShow ahk_pid %pidTC%
		Menu Tray, Rename, Show, Hide
		Menu Tray, Default, Hide
		bHidden := False
	}
	else
	{
		WinHide ahk_pid %pidTC%
		Menu Tray, Rename, Hide, Show
		Menu Tray, Default, Show
		bHidden := True
	}
	Return

subExit:
	WinClose ahk_pid %pidTC%
	ExitApp
