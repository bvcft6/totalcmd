'Script for Script Content Plugin
'(c)Lev Freidin, 2005-2008
'http://www.totalcmd.net/plugring/script_wdx.html
'http://wincmd.ru/plugring/script_wdx.html

'two column sample retreiving html file title and "saved from" info

Dim fso, ts, s, re
Set fso = CreateObject("Scripting.FileSystemObject")
sExt = lcase(fso.GetExtensionName(filename))
Const ForReading = 1

Set re = New RegExp
re.Global = True
re.IgnoreCase = True
re.MultiLine = True

Select Case sExt

'---------------------------------
case "htm", "html", "shtml", "xml"
Set f = fso.GetFile(filename)
Set ts = fso.OpenTextFile(filename, ForReading)
s = ts.read(1000)
ts.Close

re.Pattern = "<TITLE>(.*)</TITLE>"
if re.Test(s) then
Set tt = re.Execute(s)
content= re.replace (tt(0),"$1")
End if

re.Pattern = "<!-- saved from url=\(\d+\)(.*)-->"
if re.Test(s) then
Set sav = re.Execute(s)
content1= re.replace (sav(0),"$1")
End if
'----------------------------------
Case Else
'content = sExt + " file type"
End Select

set f=nothing
set fso=nothing
set re=nothing


