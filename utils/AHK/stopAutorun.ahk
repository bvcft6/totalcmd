DetectHiddenWindows, On  ; Detect hidden windows
SetTitleMatchMode, RegEx ; Find window titles by regex

Script := "autorun.ahk"  ; Get this script's name
; Get the PID of the window with the title matching the format "*\Scriptname - AutoHotkey v*"
WinGet, PID, PID, % "i)^.+\\" CleanEx(Script) " - AutoHotkey v.+$"

PostMessage, 0x12,,,, ahk_pid %PID% ; WM_QUIT

CleanEx(Needle)
{ ; Sanitize the RegEx input
    return RegExReplace(Needle, "[\\\.\*\?\+\[\{\|\(\)\^\$]", "\$0")
}
