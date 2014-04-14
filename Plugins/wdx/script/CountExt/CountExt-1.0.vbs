'*** CountExts.vbs, V1.0, 12.07.2008, van Dusen
'*** Script for Script Content Plugin 0.2
'*** Lev Freidin (c) 2005-2008
'*** http://www.totalcmd.net/plugring/script_wdx.html
'*** http://wincmd.ru/plugring/script_wdx.html

Dim vExts(9)
Dim vRecurse, vDistinct, vProperty

'*** User configurable area           - Begin *************************************
'*** Benutzerkonfigurierbarer Bereich - Beginn ************************************

'vRecurse: 1 = Scan subfolders recursively;             0 = Do not scan subfolders
'vRecurse: 1 = Unterverzeichnisse rekursiv durchsuchen; 0 = Unterverzeichnisse nicht durchsuchen
   vRecurse = 1

'vDistinct: 1 = Count file only for first matching file group     ; 0 = Count file for each matching file group
'vDistinct: 1 = Datei nur für erste zutreffende Dateigruppe zählen; 0 = Datei für alle zutreffenden Dateigruppen zählen
   vDistinct = 1

'vCharIfResultIsZero: Character/String which is displayed, if no file matchs the particular file group (e.g. "0", "", "-")
'vCharIfResultIsZero: Zeichen/String, das/der angezeigt wird, wenn sich für die Dateigruppe keine Datei qualifiziert hat (z.B. "0", "", "-")
   vCharIfResultIsZero = "-"

'vProperty: "NumAbs" | "NumRel" | "SizeAbs" | "SizeRel"
   vProperty = "NumAbs"

'vSizeUnit: Unit, only relevant for vProperty = "SizeAbs":   "bkMG" = Dynamically; "b" = Bytes; "k" = KiB; "M" = MiB; "G" = GiB; ...; "E" = EiB
'vSizeUnit: Einheit, nur relevant für vProperty = "SizeAbs": "bkMG" = Dynamisch; "b" = Bytes; "k" = KiB; "M" = MiB; "G" = GiB; ...; "E" = EiB
   vSizeUnit = "bkMG"
   
'(1) Archives / Archive
   vExts(1) = ":7Z:ACE:CAB:CATALOG:DISKDIR:GZ:GZIP:JAR:PJG:RAR:SBC:SQX:TAR:TGZ:UC2:UHA:UUE:XXE:Z:ZIP:"
'(2) Grafics / Grafiken
   vExts(2) = ":ANI:BMP:CUR:DIB:EMF:GIF:ICO:J2K:JP2:JPG:JPEG:PFI:PNG:PSD:PSP:TGA:TIF:TIFF:WMF:"
'(3) Audio
   vExts(3) = ":AU:MID:MP3:OGG:WAV:WMA:"
'(4) Videos
   vExts(4) = ":AVI:FLC:FLI:MOV:MPEG:MPG:QTIF:SFW:SWF:WMV:"
'(5) Office
   vExts(5) = ":DOC:DOT:MDB:MDE:MSG:POT:PPT:PST:RTF:VSD:XLS:XLT:"
'(6) Docu / Doku
   vExts(6) = ":CHM:HLP:HTM:HTML:MHT:PDF:TXT:"
'(7) Executables
   vExts(7) = ":COM:DLL:EXE:WCX:WDX:WFX:WLX:"
'(8) Scripts / Scripte
   vExts(8) = ":AHK:AU3:BAT:JS:PIF:SH:SQL:TCS:VBS:"
'(9) Backups
   vExts(9) = ":ALT:BAK:OLD:ORI:SIK:TIB:XLK:"

'*** Benutzerkonfigurierbarer Bereich - Ende ************************************
'*** User configurable area           - End *************************************

'(0) Other / Sonstige
   vExts(0) = ""

Dim vResult(9)
For vI = 0 To 9
   vResult(vI) = 0
Next

Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
Dim vFolder
Dim vFileCollection, vFile, vFileExt, vFileSize
Dim vSubFolderCollection, vSubFolder
Dim vPath
vPath = fso.GetAbsolutePathName(filename)


If fso.FolderExists(filename) Then
   RecurseDir(vPath)
Else
   Set vFile = fso.GetFile(filename)
   CheckExt(fso.GetExtensionName(filename))
End If

'~~~
If vProperty = "NumRel" Or vProperty = "SizeRel" Then
   vTotal = 0
   For vI = 0 To 9
      vTotal = vTotal + vResult(vI)
   Next
   For vI = 0 To 9
      If vResult(vI) = 0 Then
         vResult(vI) = vCharIfResultIsZero
      Else
         vResult(vI) = FormatPercent(vResult(vI) / vTotal, 1, -2, -2, -2)
      End If
   Next
End If
'~~~
If vProperty = "SizeAbs" Then
   For vI = 0 To 9
      If vResult(vI) = 0 Then
         vResult(vI) = vCharIfResultIsZero
      Else
         'If vResult(vI) > 0 Then
            If vSizeUnit = "bkMG" Then
               vExp = Int(Log(vResult(vI)) / Log(1024))
            Else
               vExp = InStr(1, "bkMGTPE", vSizeUnit)-1
            End If
         'Else
         '   vExp = 0
         'End If

         vFract = 1
         If vExp = 0 Then vFract = 0
         vResult(vI) = FormatNumber(vResult(vI) / (1024^vExp), vFract, -2, -2, -2)

         'If vExp > 6 Then
         '   vResult(vI) = vResult(vI) & "×1024^" & vExp & " b"
         'Else
            vResult(vI) = vResult(vI) & " " & Mid("bkMGTPE", vExp+1, 1)
         'End If
      End If
   Next
End If
'~~~
If vProperty = "NumAbs" Then
   For vI = 0 To 9
      If vResult(vI) = 0 Then
         vResult(vI) = vCharIfResultIsZero
      Else
         vResult(vI) = FormatNumber(vResult(vI), 0, -2, -2, -2)
      End If
   Next
End If
'~~~

Set vSubFolderCollection = Nothing
Set vFileCollection = Nothing
Set vFolder = Nothing
Set vFile = Nothing
Set fso = Nothing

content  = vResult(0)
content1 = vResult(1)
content2 = vResult(2)
content3 = vResult(3)
content4 = vResult(4)
content5 = vResult(5)
content6 = vResult(6)
content7 = vResult(7)
content8 = vResult(8)
content9 = vResult(9)

'~~~
Function RecurseDir(vFolderName)
   
   Set vFolder = fso.GetFolder(vFolderName)
   Set vFileCollection = vFolder.Files
   Set vSubFolderCollection = vFolder.SubFolders
   
   For Each vFile In vFileCollection
      CheckExt(fso.GetExtensionName(vFile))
   Next
   
   If vRecurse = 0 Then Exit Function
   
   For Each vSubFolder In vSubFolderCollection
      vPath = vPath & "\" & vSubFolder.Name
      RecurseDir(vPath)
      vP = InStr(1, StrReverse(vPath), "\")
      If vP > 0 Then vPath = Left(vPath, Len(vPath) - vP)
   Next
   
End Function
'~~~

Function CheckExt(vFileExt)
   vExtNotMatch = 1
   
   For vI = 1 To 9
      If InStr(1, LCase(vExts(vI)), ":" & LCase(vFileExt) & ":") > 0 Then
         vExtNotMatch = 0
         If vProperty = "SizeAbs" Or vProperty = "SizeRel" Then
            vResult(vI) = vResult(vI) + vFile.Size
         Else
            vResult(vI) = vResult(vI) + 1
         End If
         If vDistinct = 1 Then Exit For
      End If
   Next
   
   If vProperty = "SizeAbs" Or vProperty = "SizeRel" Then
      vResult(0) = vResult(0) + vFile.Size * vExtNotMatch
   Else
      vResult(0) = vResult(0) + vExtNotMatch
   End If
End Function
'~~~