#NoEnv
#SingleInstance, force
SetWorkingDir %A_ScriptDir%
FileEncoding UTF-8

 args = %0%
a_old = %1%
a_new = %2%

if (args > 0) 
  Msgbox, 1: %1% 2: %2%
else 
  msgbox, error