#SingleInstance, force
#NoEnv  
SetWorkingDir %A_ScriptDir%
FileEncoding UTF-8

; measure time
StartTime := A_TickCount
StringLength := StrLen(StartTime) * (A_IsUnicode ? 2 : 1)
TmpFile := A_ScriptDir "\" SubStr( A_ScriptName, 1, -3 ) . "tmp"
WaitClose := 1

if 1 = start
{
  ; create new file, overwrite old one
  file := FileOpen(TmpFile, "w")
  if !IsObject(file)
  {
    MsgBox Can't open "%TmpFile%" for writing.
    return
  }
  file.RawWrite(StartTime, StringLength)
  file.Close()
  ;Msgbox % "Start: " StartTime
  cursorMessage("START", 500)
}
else if 1 = stop
{ 
  EndTime := StartTime
  file := FileOpen(TmpFile, "r-d")
  if !IsObject(file)
  {
    MsgBox Can't open "%TmpFile%" for reading.
    return
  }  
  file.RawRead(StartTime, StringLength)
  file.Close()  
  if (StartTime > EndTime)
  {
    MsgBox Something went wrong.
    return
  } 
  else 
  {
    ElapsedTime := Round((EndTime - StartTime) / 1000, 2)
    ;Msgbox % "Start: " StartTime "`nEnd: " EndTime "`n`nPassed: " ElapsedTime "s"  
    Msgbox % "Passed: " ElapsedTime "s"
    cursorMessage("STOP", 500)
  } 
  try
  {
    FileDelete %TmpFile% 
  }
  catch e
  {
    Msgbox % "Last Error: " A_LASTERROR "`nException: " e "`nErrorLvl: " ERRORLEVEL
  }
}
else
{
  Msgbox,,Usage:,%A_ScriptName% <option>`noptions are "start" and "stop"
}
while (WaitClose)
  sleep 50

Exit


cursorMessage(string, time = 750)
{
  WaitClose := 1
  SetTimer, cursorTime, %time%
  Tooltip, %string%  
  return               
}

; tooltip timer
cursorTime:
{
  SetTimer, cursorTime, off
  Tooltip,
  WaitClose := 0
  return
}