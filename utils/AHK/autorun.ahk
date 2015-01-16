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

SetTimer closeTimer, 5000



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

; Paste TC's active path anywhere
#IfWinExist, ahk_class TTOTAL_CMD
; Default shortcut is Win-A
$#a::
  ; Backup the clipboard
  ClipboardBackup = %ClipboardAll%
  ; Empty the clipboard
  Clipboard =
  ; Ask TC for the path
  PostMessage, 1075, 2029, , , ahk_class TTOTAL_CMD
  ; Wait at most 2 seconds for the path
  ; You can change the value below
  ClipWait, 2
  ; Paste and append a backslash
  ; You can remove the backslash from the following line if you prefer
  Send, ^v\
  ; Restore clipboard from backup
  Clipboard = %ClipboardBackup%
  ; Release memory
  ClipboardBackup =
Return

; launch diff program from the internal compare window
~F2::
  if WinActive( "ahk_class TFileCompForm" )
  {
    ControlGetText sFile1, Edit1
    ControlGetText sFile2, Edit2
    Run "C:\Program Files (x86)\WinMerge\WinMergeU.exe" "%sFile2%" "%sFile1%"
    Return
  }
  Return

; Scroll, keeping the cursor in place
^+Down:: TCScrollKeep( 1 )
^+Up:: TCScrollKeep( 0 )
TCScrollKeep( xnDirecton )
{
  if WinActive( "ahk_class TTOTAL_CMD" )
  {
    if xnDirecton = 1
      Send {Down}
    else
      Send {Up}
  ControlGetFocus sActivePanel, A
  PostMessage 0x115, xnDirecton, 0, %sActivePanel%, A
  }
  Return
}

; If the MRT-WIndow is opened it is sufficient to press [Alt]+[Backspace] to
; load the default settings.
~!BS::
if WinActive( "ahk_class TMultiRename" )
{
	Send {F2}{Home}{Down}{Enter}
}
Return

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
SplashTextOn, , , TC is gone
    sleep 1500
    SplashtextOff
    ExitApp
  }
  DetectHiddenWindows, off
  Return

ExitSub:
  if A_ExitReason not in Logoff,Shutdown,Close,Exit  ; Avoid spaces around the comma in this line.
  {
      MsgBox, 4, , Are you sure you want to exit?
      IfMsgBox, No
          return
  }
  ExitApp