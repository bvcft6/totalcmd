'Script for Script Content Plugin
'(c)Lev Freidin, 2005
'http://www.totalcmd.net/plugring/script_wdx.html
'http://wincmd.ru/plugring/script_wdx.html

'Sort executable files to the first place
'archives to the second
'keep grouping files by type

content = "" 
'filename="c:\test\test.exe"

Dim fso, ts
Set fso = CreateObject("Scripting.FileSystemObject")
sExt = lcase(fso.GetExtensionName(filename))
Const ForReading = 1


Select Case sExt

case "exe", "com", "bat", "pif", "cmd"
content="1-"+sExt
case "arj", "ha", "lzh", "rar", "uc2", "zip", "cab", "ace", "7z", "tar", "uha", "fb"
content="2-"+sExt

Case Else
content="3-"+sExt
'content = sExt + " file type"
End Select

set f=nothing
set fso=nothing

'MsgBox content