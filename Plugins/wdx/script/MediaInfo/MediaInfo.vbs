
' quick and dirty Mediainfo Script for Totalcommander ScriptContent Plugin
' uses the Dll from mediainfo.sourceforge dot net
'
' You have to register the Active-X-Control-Addon-Dll included in the Zip
' (MediaInfo_0.7.6.4_DLL_Win32.7z\Developpers\Contrib\ActiveX\Release\MediaInfoActiveX_Install.bat).
'
' The Batch copies the mediainfo.dll and the MediaInfoActiveX.dll to the windows\system32 Folder.
'
' For me, the registration of the Active-X-Dll only worked after I downloaded and unzipped the
' msvbvm50.dll (from dll-files dot com/dllindex/dll-files.shtml?msvbvm50 for example)
' into %windir%\system32 Folder.
'
' You can check the registration by running "regsvr32 %windir%\system32\MediaInfoActiveX.dll". It should say "...succedded".
'
' v1.0 by BrotBuexe - 2. May 2008

Const MediaInfo_Stream_Video       = 1
Const MediaInfo_Stream_Audio       = 2
Const MediaInfo_Stream_Text        = 3
Const MediaInfo_Info_Name           = 0
Const MediaInfo_Info_Text          = 1

Set fso = CreateObject("Scripting.FileSystemObject")
sExt = lcase(fso.GetExtensionName(filename))

Select Case sExt

Case "mkv", "avi", "mov", "mp3", "wav", "ogg", "mp4", "divx", "wmv", "rm", "mpg", "vob", "m2ts", "ts"
  Set obj = createObject("MediaInfo.ActiveX")
  handle = obj.MediaInfo_New()
  obj.MediaInfo_Open handle, CStr(filename)
 
  ' Frames per Second
  content = obj.MediaInfo_Get(handle, MediaInfo_Stream_Video, 0, "FrameRate", MediaInfo_Info_Text, MediaInfo_Info_Name)
 
  ' Resolution
  content1 = obj.MediaInfo_Get(handle, MediaInfo_Stream_Video, 0, "Width", MediaInfo_Info_Text, MediaInfo_Info_Name)  & "x" & obj.MediaInfo_Get(handle, MediaInfo_Stream_Video, 0, "Height", MediaInfo_Info_Text, MediaInfo_Info_Name)
 
  ' VideoBitrate
  content2 = obj.MediaInfo_Get(handle, MediaInfo_Stream_Video, 0, "BitRate/String", MediaInfo_Info_Text, MediaInfo_Info_Name)
 
  ' VideoCodec
  content3 = obj.MediaInfo_Get(handle, MediaInfo_Stream_Video, 0, "Codec", MediaInfo_Info_Text, MediaInfo_Info_Name)
 
  ' PlayTime
  content4 = obj.MediaInfo_Get(handle, MediaInfo_Stream_Video, 0, "PlayTime/String2", MediaInfo_Info_Text, MediaInfo_Info_Name)
 
  ' Number of Audiostreams
  content5 = obj.MediaInfo_Get(handle, MediaInfo_Stream_Audio, 0, "StreamCount", MediaInfo_Info_Text, MediaInfo_Info_Name)
 
  ' AudioBitrate
  content6 = obj.MediaInfo_Get(handle, MediaInfo_Stream_Audio, 0, "BitRate/String", MediaInfo_Info_Text, MediaInfo_Info_Name)
 
  ' Channel
  content7 = obj.MediaInfo_Get(handle, MediaInfo_Stream_Audio, 0, "Channel(s)", MediaInfo_Info_Text, MediaInfo_Info_Name)
 
  ' Number of Subs
  content8 = obj.MediaInfo_Get(handle, MediaInfo_Stream_Text, 0, "StreamCount", MediaInfo_Info_Text, MediaInfo_Info_Name)
 
 
  obj.MediaInfo_Close handle
  obj.MediaInfo_Delete handle
End Select 