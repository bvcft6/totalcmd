; Lautstärke rutnerregeln
#SingleInstance
#NoEnv  
SetWorkingDir %A_ScriptDir%

SoundGet, current
SoundSet, 10

Msgbox,1,,Zimmerlautstärke aktiviert!
Ifmsgbox Cancel
  SoundSet, %current%


ExitApp
