; This script sends F2 instead of Enter when in Copy or Move dialog.

; Careful: if you redefine the Enter key, it will not work as a terminator for
; hotstrings, see here: http://www.autohotkey.com/forum/viewtopic.php?t=4232 

$Enter::
If WinActive("ahk_class TInpComboDlg")
	Send, {F2}
else
	Send, {Enter}
return

; Alt-Shift-W (Run or activate Total Commander)
!+w::
	if not WinExist( "ahk_class TTOTAL_CMD" )
		Run "%COMMANDER_PATH%\Totalcmd.exe"
	WinActivate
	Return
	
	
; Start Total Commander with a tray icon.
; It allows the user to Show/Hide TC by clicking on it.
; The script allows more instances of TC running, each having its own tray icon.

DetectHiddenWindows On

Menu Tray, Icon, %COMMANDER_PATH%\TOTALCMD.EXE
Menu Tray, NoStandard
Menu Tray, Add, Hide, subShowHide
Menu Tray, Default, Hide
Menu Tray, Add
Menu Tray, Add, Exit, subExit
Menu Tray, Click, ClickCount 1
Menu Tray, Tip, Total Commander

OnExit subExit

bHidden := False

RunWait %COMMANDER_PATH%\TOTALCMD.EXE,,,pidTC
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
	


; This script will show a tooltip with short info about the drives when howering with the mouse over the drives toolbar. 

#Persistent

SetTimer subTimer, 500

subTimer:
	if WinActive( "ahk_class TTOTAL_CMD" )
	{
		MouseGetPos,,,,sControl
		if (InStr( sControl, "TDrivePanel"))
		{
			sToolTip := ""
			DriveGet sDriveList, LIST
			loop PARSE, sDriveList
				{
				DriveGet, sLabel, LABEL, %A_LoopField%:
				DriveGet, sType, TYPE, %A_LoopField%:
				sToolTip = %sToolTip%%A_LoopField%: %sType%`; %sLabel%`n
				}
			ToolTip %sToolTip%
		}
		else
			ToolTip
	}
	Return
