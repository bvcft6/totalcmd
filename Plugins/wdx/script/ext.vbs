'Script for Script Content Plugin
'(c)Lev Freidin, 2005
'http://www.totalcmd.net/plugring/script_wdx.html
'http://wincmd.ru/plugring/script_wdx.html

'Show size for eps, ai, ps, prn files
'Show title for htm, html files
'Show file type for bar files - just for test

'content = "" 
'filename="c:\test\test.htm"

Dim fso, ts, s, re
Set fso = CreateObject("Scripting.FileSystemObject")
sExt = lcase(fso.GetExtensionName(filename))
Const ForReading = 1

Set re = New RegExp
re.Global = True
re.IgnoreCase = True
re.MultiLine = True

Select Case sExt

case "bar"
content="bar file"' Just For testing
'---------------------------------
case "eps", "ai", "ps", "prn"
Set f = fso.GetFile(filename)

Set ts = fso.OpenTextFile(filename, ForReading)
if f.size>1000000 then
s = ts.read(1000)
else
s = ts.ReadAll
end if
ts.Close

sp = "\s+" 'at least one any space symbol
num = "(-?\d+\.?\d*)" 'any number like -3.51 or 4
spnum = sp + num
re.Pattern = "(%%BoundingBox:|%%PageBoundingBox:|%ADO_ImageableArea:|%%HiResBoundingBox:)" + spnum + spnum + spnum + spnum
if re.Test(s) then
Set tt = re.Execute(s)
re.Pattern = num
Set bb = re.Execute(tt(0))
sx= Round((bb(2)-bb(0))*0.352778)'25.4/72
sy= Round((bb(3)-bb(1))*0.352778)'25.4/72

'content= sx & " mm x " & sy& " mm"
content= sx & " x " & sy& " mm"
else
content= "---"'"Cannot find size"
End if
'end case "eps", "ai", "ps", "prn"

'---------------------------------
case "htm", "html"
Set f = fso.GetFile(filename)
Set ts = fso.OpenTextFile(filename, ForReading)
s = ts.read(1000)
ts.Close

re.Pattern = "<TITLE>(.*)</TITLE>"
if re.Test(s) then
Set tt = re.Execute(s)
content= re.replace (tt(0),"$1")
End if

case "url"
Set f = fso.GetFile(filename)
Set ts = fso.OpenTextFile(filename, ForReading)
s = ts.read(1000)
ts.Close

re.Pattern = "URL=(.*)"
if re.Test(s) then
Set tt = re.Execute(s)
content= re.replace (tt(0),"$1")
End if

Case Else
'content = sExt + " file type"
End Select

set f=nothing
set fso=nothing
set re=nothing

'MsgBox content