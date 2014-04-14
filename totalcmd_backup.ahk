#NoEnv  							  
#SingleInstance, Force  
SetWorkingDir %A_ScriptDir%
#Include ..\AHK\lib\Array.ahk

; http://www.ghisler.ch/wiki/index.php/Files
; http://www.ghisler.ch/wiki/index.php/Backup

; files to backup
files := Array()                
files.append("wincmd.ini")
files.append("user.ini") 
files.append("plugins.ini")
files.append("usercmd.ini")
files.append("wcx_ftp.ini")
files.append("sftpplug.ini")
files.append("tcignore.txt")
files.append("*.BAR")
files.append("Language\wcmd_deu.*")

;files.append("default.br2")
; do not backup!
; files.append("history.ini")

timestamp = %A_YYYY%-%A_MM%-%A_DD%_-_%A_Hour%-%A_Min%-%A_SEC%
tmpDir = tmp_%timestamp%
archiveFilename = totalcmd-ini %timestamp%
archiveExe = C:\Programme\7-Zip\7z.exe
closedTC = false

; check if script is run from total commander directory
if not FileExist(files[1])
{
  Msgbox,,Error!, Files not found! `n`nScript must be run from `ntotal commander directory. `nPlease move accordingly! `n`nScript is terminating...
  ExitApp
}   
; check if total commander is running  
if WinExist( "ahk_class TTOTAL_CMD" )  
{
  ; offer to close total commander
  Msgbox, 52,Close Total Commander?, Running Instance of Total Commander found! `nIf Total Commander is running `nyour backup will not be up to date. `n`nClose it? 
  Ifmsgbox Yes
  {
    WinClose
    closedTC = true
  }    
}

; make tmp dir
FileCreateDir, %tmpDir% 

; copy files to tmp dir
Loop, % files.len()
   FileCopy, % files[A_Index], %tmpDir% 
   
; archive the files     
SetWorkingDir %tmpDir%
RunWait, %archiveExe% a -t7z "%A_SCRIPTDIR%\%archiveFilename%.7z" *

; remove tmp dir
SetWorkingDir %A_ScriptDir%
FileRemoveDir, %TmpDir%, 1



if (closedTC = "true")
{
  ; restart TC
  Msgbox,4,Finished,Your Settings were stored in %A_SCRIPTDIR%\%archiveFilename%.7z `n`nRestart Total Commander? 
  Ifmsgbox Yes
  Run %A_SCRIPTDIR%\TOTALCMD.EXE
}
else
  ; no restart
  Msgbox,,Finished,Your Settings were stored in %A_SCRIPTDIR%\%archiveFilename%.7z 
  
ExitApp

