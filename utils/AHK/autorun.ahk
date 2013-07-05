#SingleInstance
#NoEnv  
SetWorkingDir %A_ScriptDir%
FileEncoding UTF-8

EnvGet, COMMANDER_PATH, COMMANDER_PATH
EnvGet, TOOL_PATH, TOOL_PATH
AUTORUN_PATH := COMMANDER_PATH "\Plugins\wdx\Autorun"
sleep 600
Msgbox % AUTORUN_PATH
WinWait, ahk_class TTOTAL_CMD
WinActivate,  %A_ScriptName%,10
;change title, set options
