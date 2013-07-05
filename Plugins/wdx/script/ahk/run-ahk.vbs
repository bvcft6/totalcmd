Sp=" "
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set f = fso.GetFile(filename)
if f.size>0 then  
  'ahkpath = scriptdir & "AutoHotkey.exe"
  'set res=WshShell.exec("""" & ahkpath & ".\totalcmd-wdx.ahk """ & filename & """")
  set res=WshShell.exec("x:\tmp\AutoHotkey.exe x:\tmp\totalcmd-wdx.ahk """ & filename & """")
  
 c=res.StdOut.ReadAll
 select case c
 case "-1"
   c =  "some error"
 case "0"
   c ="no result"
 End select
 content = c
else
 content = "zero size"
end if
