'Simple clipboard Script for Total Commander ScriptContent Plugin
'
'It's meant to be used with the MRT (Multi-Rename Tool).
'It strips all characters which aren't allowed in a filename from the clipboard.
'
'If this doesn't work you have to review the IE security settings.
'v1.0 by Milan "R.A.W." Franzkowski - 09. May 2008

dim objhtm
set objhtm=createobject("htmlfile") 
content=objhtm.parentwindow.clipboarddata.getdata("text") 

content=Replace(content,"\","")
content=Replace(content,"/","")
content=Replace(content,":","")
content=Replace(content,"*","")
content=Replace(content,"?","")
content=Replace(content,"""","")
content=Replace(content,"<","")
content=Replace(content,">","")
content=Replace(content,"|","")

'wscript.echo content