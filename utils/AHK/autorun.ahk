#NoEnv  
#SingleInstance, force

SetWorkingDir %A_ScriptDir%
FileEncoding UTF-8

EnvGet, COMMANDER_PATH, COMMANDER_PATH
EnvGet, TOOL_PATH, TOOL_PATH
AUTORUN_PATH := COMMANDER_PATH "\Plugins\wdx\Autorun"

Menu,Tray,Icon, %COMMANDER_PATH%\TOTALCMD.EXE,1

sTitle = Total Commander (x64) 8.50 - Portable Version

OnExit, ExitSub

SetTimer subTimer, 250

WinWait, ahk_class TTOTAL_CMD, , 5
if ErrorLevel
{
    MsgBox, Totalcmd not running?
    ExitApp
}
else
{
    SetTimer closeTimer, 2500
}

subTimer:
  if WinActive( "ahk_class TTOTAL_CMD" )
  {
    WinGetTitle sWindowTitle
    if ( sWindowTitle != sTitle )
      WinSetTitle %sTitle%
  }
  Return

closeTimer:
  DetectHiddenWindows, on
  if !WinExist( "ahk_class TTOTAL_CMD" )
  {
    Msgbox, wech?
    ExitApp
  }
  DetectHiddenWindows, off
  Return

; TOTALCMD: minimize on esc  
;#ifWinActive ahk_class TTOTAL_CMD
;  $Escape::WinMinimize A

; Mark Important Files Permanently (via Comment & Highlight)

#IfWinActive, ahk_class TTOTAL_CMD
^+z::
PostMessage, 1075, 2700
WinWaitActive, ahk_class TCmtEditForm, , 1
If Errorlevel
  Return
Marker := "*** "
ControlGetText, Comment, Edit1
StringLeft, Check, Comment, 4
If Check <> %Marker%
  Comment := Marker Comment
Else
  StringTrimLeft, Comment, Comment, 4
ControlSetText, Edit1, %Comment%
SendInput, {F2}
Return

; Pressing F4 in TC Lister starts Notepad with the active document. 
#IfWinActive, ahk_class TLister
F4::
editor = notepad.exe
WinGetTitle, title
left := InStr(title, "[") + 1
right := InStr(title, "]") - left
StringMid, listerpath, title, left, right
WinClose
Run, %editor% "%listerpath%"
Return

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


ExitSub:
  if A_ExitReason not in Logoff,Shutdown  ; Avoid spaces around the comma in this line.
  {
      MsgBox, 4, , Are you sure you want to exit?
      IfMsgBox, No
          return
  }
  ExitApp