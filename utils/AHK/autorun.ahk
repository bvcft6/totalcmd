#SingleInstance, force
#NoEnv  
SetWorkingDir %A_ScriptDir%
FileEncoding UTF-8

EnvGet, COMMANDER_PATH, COMMANDER_PATH
EnvGet, TOOL_PATH, TOOL_PATH
AUTORUN_PATH := COMMANDER_PATH "\Plugins\wdx\Autorun"

Menu,Tray,Icon, %COMMANDER_PATH%\TOTALCMD.EXE,1

sTitle = Total Commander 8.01 - Portable Version

SetTimer subTimer, 250

subTimer:
	if WinActive( "ahk_class TTOTAL_CMD" )
	{
		WinGetTitle sWindowTitle
		if ( sWindowTitle != sTitle )
			WinSetTitle %sTitle%
	}
	Return

; TOTALCMD: always COPY/MOVE in BACKGROUND
;#IfWinActive ahk_class TInpComboDlg
;	$Enter::SendInput, {F2}

; TOTALCMD: minimize on esc  
;#ifWinActive ahk_class TTOTAL_CMD
;	$Escape::WinMinimize A

; TOTALCMD: always unpack into seperate directory
~!F6:: 
~!F9:: 
If WinActive("ahk_class TTOTAL_CMD") or WinActive("ahk_class TDLGUNZIPALL")
{
  WinWaitActive, ahk_class TDLGUNZIPALL
  ControlSend, TCheckBox1, {SPACE}
  ControlFocus, TAltEdit1
  ; If you always want to extract to the active panel, uncomment:
  ; Send {DEL}
}
Return
