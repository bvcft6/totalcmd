'*** CheckEncoding, van Dusen, 31.07.2009
'*** Script for Script Content Plugin 0.2
'*** Lev Freidin (c) 2005-2008
'*** http://www.totalcmd.net/plugring/script_wdx.html
'*** http://wincmd.ru/plugring/script_wdx.html

'*** [=script.Result]  ===> Character Encoding  •  Line Endings
'*** [=script.Result1] ===> Character Encoding {ASCII|ANSI|Binary|Unicode: UTF-8|Unicode: UTF-8 BOM|Unicode: UTF-[16|32] [LE|BE] BOM}
'*** [=script.Result2] ===> Line Endings       {None|CRLF (Win)|LF (Unix)|CR (Mac)}

'*** [=script.Result3] ===> 16 byte hex signature
'*** [=script.Result4] ===> 16 byte txt signature

Dim oFSO, f
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set f = oFSO.OpenTextFile(filename, 1, False)

const nCharCnt = 16

If not f.AtEndOfStream Then  
  vFileContentIn = f.Read(1024)
  'vFileContentIn = f.ReadAll
  vSignature = Left(vFileContentIn,nCharCnt)
  'vSignature = f.Read(nCharCnt)
end if
f.Close
Set f = Nothing
Set oFSO = Nothing

   
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'Check Character Encoding
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vEncoding = "?"

'Bytefolgen der BOM in verschiedenen Zeichenkodierungen
'Kodierung              Bytefolge
'UTF-8                  EF BB BF    (239 187 191)
'UTF-16 Big Endian      FE FF       (254 255)
'UTF-16 Little Endian   FF FE       (255 254)
'UTF-32 Big Endian      00 00 FE FF (000 000 254 255)
'UTF-32 Little Endian   FF FE 00 00 (255 254 000 000)

vBOM = Left(vFileContentIn, 2)
If vBOM = Chr(&HFF) & Chr(&HFE) Then vEncoding = "UTF-16 LE BOM"
If vBOM = Chr(&HFE) & Chr(&HFF) Then vEncoding = "UTF-16 BE BOM"

vBOM = Left(vFileContentIn, 3)
If vBOM = Chr(&HEF) & Chr(&HBB) & Chr(&HBF) Then vEncoding = "UTF-8 BOM"

vBOM = Left(vFileContentIn, 4)
If vBOM = Chr(&H00) & Chr(&H00) & Chr(&HFE) & Chr(&HFF) Then vEncoding = "UTF-32 BE BOM"
If vBOM = Chr(&HFF) & Chr(&HFE) & Chr(&H00) & Chr(&H00) Then vEncoding = "UTF-32 LE BOM"


If vEncoding = "?" Then
   Dim vRegExp
   Set vRegExp = New RegExp
   vRegExp.IgnoreCase = False
   vRegExp.Global = True
   
   vRegExp.Pattern = "[\x09-\x0D\x20-\x7E]"
   vFileContentOt = vRegExp.Replace(vFileContentIn, "")
   If vFileContentOt = "" Then
      vEncoding = "ASCII"
      
   Else
      vEncoding = "UTF-8"
      For vI = 1 To Len(vFileContentIn)
         
         vAsc = Asc(Mid(vFileContentIn, vI, 1))
         vSubseqBytes = 0
         
         '[\x00-\x7F] = 0xxxxxxx
         If vAsc >= &H00 And vAsc <= &H7F Then
            vSubseqBytes = 0
         '[\xC0-\xDF][\x80-\xBF] = 110xxxxx 10xxxxxx
         ElseIf vAsc >= &HC0 And vAsc <= &HDF Then
            vSubseqBytes = 1
         '[\xE0-\xEF][\x80-\xBF][\x80-\xBF] = 1110xxxx 10xxxxxx 10xxxxxx
         ElseIf vAsc >= &HE0 And vAsc <= &HEF Then
            vSubseqBytes = 2
         '[\xF0-\xF7][\x80-\xBF][\x80-\xBF][\x80-\xBF] = 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
         ElseIf vAsc >= &HF0 And vAsc <= &HF7 Then
            vSubseqBytes = 3
         Else
            vSubseqBytes = 0
            vEncoding = "?"
         End If
         
         If vI + vSubseqBytes > Len(vFileContentIn) Then Exit For
         
         For vJ = 1 To vSubseqBytes
            vI = vI + 1
            vAsc = Asc(Mid(vFileContentIn, vI, 1))
            If vAsc < &H80 Or vAsc > &HBF Then
               vEncoding = "?"
               Exit For
            End If
         Next
         
         If vEncoding = "?" Then Exit For
         
      Next
      
      If vEncoding = "?" Then
         vRegExp.Pattern = "[\x00-\x08\x0E-\x1F\x7F]" 'Control Chars
         vFileContentOt = vRegExp.Replace(vFileContentIn, "")
         If vFileContentIn = vFileContentOt Then
            vEncoding = "ANSI"
         Else
            vEncoding = "Binary"
         End If
      End If
      
   End If
   
End If

content1 = vEncoding


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'Check Line Endings
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vLineEndings = ""
vCR = ""
vLF = ""

Select Case vEncoding
   Case "ASCII", "ANSI", "UTF-8", "UTF-8 BOM" '0D 0A
      vCR = Chr(13)
      vLF = Chr(10)
   Case "UTF-16 BE BOM" '00 0D 00 0A
      vCR = Chr(00) & Chr(13)
      vLF = Chr(00) & Chr(10)
   Case "UTF-16 LE BOM" '0D 00 0A 00
      vCR = Chr(13) & Chr(00)
      vLF = Chr(10) & Chr(00)
End Select
vCRLF = vCR & vLF

If vCRLF <> "" Then
   vLineEndings = "None"
   If InStr(1, vFileContentIn, vCRLF) > 0 Then
      vLineEndings = "Win (CR+LF)"
   Else
      If InStr(1, vFileContentIn, vCR) > 0 Then vLineEndings = "Max (CR)"
      If InStr(1, vFileContentIn, vLF) > 0 Then vLineEndings = "Unix (LF)"
   End If
End If

content2 = vLineEndings


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'Concatenation and Output Encoding & Line Endings
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

content = vEncoding
If vLineEndings <> "" Then
   content = content & "  " & ChrW(&H2022) & "  " & vLineEndings
End If


'signatur.vbs by ricobautsch

'Script for Script Content Plugin (c)Lev Freidin, 2005
'http://www.totalcmd.net/plugring/script_wdx.html
'http://wincmd.ru/plugring/script_wdx.html
'
'This script returns the first 10 bytes in the file as text or hex-representation.
'Could be usefull for example to search for files with a specified signatur
' changed to result3


'If not f.AtEndOfStream Then
If vSignature <> "" Then
  For i=1 To Len(vSignature)
    If content3 <> "" Then
      content3 = content3 & " "
    End If   
    hex_value = Hex(Asc(Mid(vSignature,i,1)))  
    content3 = content3 & string(2 - len(hex_value), "0")
    content3 = content3 & hex_value
  Next
 'content4 = vSignature
else
 content3 = "<empty>"
 content4 = "<empty>"
End If

' END SIGNATUR.VBS

