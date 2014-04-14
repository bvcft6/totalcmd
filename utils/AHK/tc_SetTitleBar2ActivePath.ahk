;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   File:   TC_ST2A.ahk    (TC_SetTitleToActive)
;;
;;   Version: 3.50   Date: Mar.2011
;; AHK_L compatible, removed DOT concatenation of strings.
;;   
;;   Requires: Autohotkey: 1.0.48 - February 25, 2009
;;
;;   Author: Balderstrom, aka Crash&Burn
;;
;;
;;   From AHK Boards: http://www.autohotkey.com/forum/viewtopic.php?t=61979
;;   ::
;;   :: Modified RegisterCallBack Example by Lexikos, and SKAN's ShellMessages.
;;   ::
;;   :: Included: SKAN's ProcessCreationTime() to fix sorting of TC Windows.
;;   ::
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   :*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:
;;   To Customize title output: See the TC_ST2A__FormatTitle function below.
;;   :*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:*:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Version 3 Notes::
;;      Script utilizes NO HotKeys AND NO Timers.
;;      Due to the addition of RegisterCallBack(), the minimum AHK version has been increased.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   #SingleInstance, Force
   #Persistent
   #NoEnv
SetBatchLInes, -1
SetTitleMatchMode 2
DetectHiddenWindows, ON
OnExit, DeRegisterHooks

WinGet, TC_ST2A__hWnd, ID, %A_ScriptFullPath%
DllCall( "RegisterShellHookWindow", "UInt",TC_ST2A__hWnd )
TC_ST2A__MsgNum := DllCall( "RegisterWindowMessage", "Str","SHELLHOOK" )
OnMessage( TC_ST2A__MsgNum, "TC_ST2A__ShellMessages" )

TC_COUNT := 0
;;
;;   Total Commander Global newLine delimited Strings (PseudoArrays)
;;
T_TC_hwnd      := ""   ; TC hwnd's
T_TC_InSysTray   := ""   ; TC hwnd's in the SystemTray
T_TC_csID      := ""   ; TC hwnd's of TMyPanel3 (Command Prompt|Status)
T_TC_RCB      := ""   ; TC RegisterCallBack pointers   (So we can FREE Them)
T_TC_hHook      := ""   ; TC EventHook IDs            (So we can FREE Them)
T_TC_ownName   := ""
T_TC_version   := ""
T_TC_wincmd      := ""
T_TC_BBMinWidthChange := 1139
T_TC_BBChanged  := FALSE

TC_ST2A__HShellMsgName()
TC_ST2A__INIT( TRUE )   ;;   TC_FindALLInstances()
;__ADDEventHook__ObjectCreate()
return


TC_ST2A__FormatTitle( tInstance, tPath, tOwnName, tVersion )
{
   global TC_COUNT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Change this to the string to be appended to TitleBar's SourcePath
;;;   i.e. "     ::     Total Commander "
;;;
   titleTCName := "   ::   Total Commander "
;;;
;; For the first Running Instance of TC
;; 0 : Do Not Show TC Instance Number
;; 1 : Always Show TC Instance Number
;; 2 :  Only  Show TC Instance Number if more than 1 Copy of TC is Running.
;;;
   showTCNum1 := 2
;;;
   upperCaseDriveLetter := TRUE
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   tcNum := "[" tInstance "]  "
   if( tInstance == 1 && (!showTCNum1 || (showTCNum1 && TC_COUNT < showTCNum1)) )
      tcNum := ""
   
   tPath := ( upperCaseDriveLetter ? UpperChar(tPath, 1) SubStr(tPath, 2, -1) : tPath )
   
return ( tcNum tPath titleTCName tVersion )
}


TC_ST2A__TitleReset( wID="", cID="", idx="", path="", ownName="", version="" )
{
   global T_TC_hwnd, T_TC_ownName, T_TC_version
   
   wID := WinExist( !wID ? "A" : "ahk_id " wID )
   
   idx := (idx ? idx : ParseStringN( T_TC_hwnd, wID ))
   idx := (idx ? idx : ParseStringN( T_TC_hwnd, cID ))
   if( !idx )
      MsgBox, % A_ThisFunc " :: No IDX!!"
      
   ownName := ( ownName ? ownName : ParseStringN( T_TC_ownName, "", idx ))
   version := ( version ? version : ParseStringN( T_TC_version, "", idx ))
   if( !path )
      path:=TC_QueryPathA(wID) ; ControlGetText, path, TMyPanel3, ahk_id %wID%
      
   title := TC_ST2A__FormatTitle( idx, path, ownName, version )
   WinSetTitle, ahk_id %wID%,, %title%
return
}


ControlGet( byRef cmdOut, aControl, param1="", param2="", param3="", param4="" )
{
   StringSplit, cmd, cmdOut, #
   if( aControl + 0 )
      ControlGet, cmdOut, % cmd1, % cmd2,, %aControl%, % (param2 + 0 ? "ahk_id " param2 : param2), %param3%, %param4%
   else
      ControlGet, cmdOut, % cmd1, % cmd2,  %aControl%, % (param1 + 0 ? "ahk_id " param1 : param1), %param2%, %param3%, %param4%
return (cmdOut)
}


ControlGetText( byRef aText, aControl, aWin="A", winText="", notTitle="", notText="" )
{
   if( aControl + 0 )
      ControlGetText, aText,, ahk_id %aControl%
   else
      ControlGetText, aText, %aControl%, % (aWin+0 ? "ahk_id " aWin : aWin), %winText%, %notTitle%, %notText%
return aText
}



TC_QueryPathA(wID, byRef pathID="") {
   return ControlGetText(cText, pathID ? pathID : pathID:=TC_QueryPathID(wID))
}


TC_QueryPathID(wID) {
   Loop, 3
      if(">" == SubStr(ControlGetText(cText, "TMyPanel" (A_Index + 2), wID), 0))
         return ControlGet(pathID:="HWND",  "TMyPanel" (A_Index + 2), wID)
return (pathID)
}



UpperChar( cStr, cPos )
{
   cStr := SubStr(cStr, cPos, 1)
   StringUpper, cStr, cStr
return cStr
}


;;
;;   ParseStringN()
;;   ::   Parse a newline delimited String ( AHK/Pseudo Array )
;;   ::   
;;   ::   Returns the index position of the string, 0 if not Found.
;;   OR   Returns the string @ index position "idx"
;;   ::
;;   ::   NOTE:: idx var overides sFind for what matching is performed.
;;   ::
ParseStringN( T_stringN, sFind="", idx=0, removeFound=FALSE )
{
   retVal := ( idx ? 0 : "" )
   sLen:=0
   if( idx )
   {
      Loop, Parse, T_stringN, `n
      {
         sLen += 1 + strlen(A_LoopField)
         if( idx == A_Index && (retVal:=A_LoopField) && rvLen:=strlen(A_LoopField) )
            break
      }
   }
   else
   {
      Loop, Parse, T_stringN, `n
      {
         sLen += 1 + strlen(A_LoopField)
         if( sFind == A_LoopField && (retVal:=A_Index) && rvLen:=strlen(A_LoopField) )
            break
      }
   }

   if( removeFound )
      T_stringN:=substr(T_stringN, 1, sLen - rvLen - 1) substr(T_stringN, sLen + 1)
return retVal
}


TC_ST2A__GETTitlePart( wID, byRef ownName, byRef version )
{
   pass := 0
   if( !WinActive( "ahk_id " wID ) )
      WinActivate, ahk_id %wID%
   ST2A__GetTitlePart:
   WinGetTitle, aTitle, ahk_id %wID%
   RegExMatch( aTitle, "(\[(\d+)\] )?(.* - )?Total Commander (.*) - (.*)$", titleTC )
   ownName   := titleTC5
   version := titleTC4

   if( !ownName || !version )
   {
      if( pass <> 0 )
      {
         MsgBox, Error cannot get Total Commander's Title
         Exit
      }
      ++pass   
      WinMinimize, ahk_id %wID%
      WinActivate, ahk_id %wID%
      Sleep, 100
      goto, ST2A__GetTitlePart
   }
return
}


TC_ST2A__CreateStruct( wID, index=0 )
{
static
   global TC_COUNT, T_TC_ownName, T_TC_version, TC_TCINI
   global T_TC_hwnd, T_TC_csID, T_TC_hHook, T_TC_RCB, T_TC_xWyH
   local cID, ownName, version, wincmd
   static init:=0

   if( !init && init:=1 )
   {
      local globalVars, gVar
      
      globalVars:="T_TC_ownName,T_TC_version,T_TC_hwnd,T_TC_csID,T_TC_hHook,T_TC_RCB"
      Loop, Parse, globalVars, `,
         gVar := A_LoopField, %gVar% := ""
      TC_COUNT:=0
   }
   
   TC_QueryPathA(wID, cID:="")
;   ControlGet, cID, Hwnd,, TMyPanel3, ahk_id %wID%
   wID += 0   ; Make sure Decimal format
   cID += 0   ; Make sure Decimal format

   if( !ParseStringN(T_TC_hwnd, wID) && ++TC_COUNT )
   {   ; New Instance of TC Started
   
      T_TC_hwnd .= wID "`n"      ; Update TotalCMDR hwnd's
      T_TC_csID .= cID "`n"      ; Update TMyPanel3 hwnd's

      TC_ST2A__GETTitlePart( wID, ownName, version )
      T_TC_ownName .= ownName "`n"
      T_TC_version .= version "`n"
      
/*
      if( !wincmd%version% )   ; STATIC Variable
      {
         TC_EMC( "em_CMDSTART cmd.exe /c START ""em_RUN_TC_ST2A"" /MIN setenv.exe -v TC_" wID "_wincmd "`"%%COMMANDER_INI%%`", "", "ahk_id " wID )
         WinWaitClose, em_RUN_TC_ST2A ahk_class ConsoleWindowClass
         RegRead, wincmd, HKEY_CURRENT_USER, Volatile Environment, TC_%wID%_wincmd
         wincmd%version% := wincmd
      }
*/
      TC_ST2A__ADDEventHook( wID, R_hHook, R_tcRCB )
      T_TC_hHook   .= R_hHook "`n"   ; Update hHook
      T_TC_RCB    .= R_tcRCB "`n"   ; Update RegisterCallBack pointer LIST
      TC_ST2A__TitleReset( wID, "", TC_COUNT, "", ownName, version )
      
   }
   else
   {
      MsgBox, %A_ThisFunc% :: Error, Attempting to Add the same TC Instance again.
      Exit
   }
return
}


TC_ST2A__DeleteStruct( wID="", DX=0 )
{
   global TC_COUNT, T_TC_ownName, T_TC_version
   global T_TC_hwnd, T_TC_csID, T_TC_hHook, T_TC_RCB

   index := (DX ? DX : ParseStringN( T_TC_hwnd, wID, 0, TRUE ))
   ParseStringN( T_TC_csID,    "", index, TRUE )   ; Version 3.2 Fix
   ParseStringN( T_TC_ownName, "", index, TRUE )   ; Remove index-Position from Array
   ParseStringN( T_TC_version, "", index, TRUE )   ; Remove index-Position from Array
   i := index - 1
   Loop, % TC_COUNT - index
      TC_ST2A__TitleReset(ParseStringN( T_TC_hwnd, "", A_Index + i ))

   hHook := ParseStringN( T_TC_hHook, "", index, TRUE )   ; RemoveFound=TRUE, ReturnField=TRUE
   tcRCB := ParseStringN( T_TC_RCB,   "", index, TRUE )   ; RemoveFound=TRUE, ReturnField=TRUE
   TC_ST2A__UnHookEvent( hHook, tcRCB )
   
   --TC_COUNT
return
}


TC_ST2A__INIT( preINIT=TRUE )   ;TC_FindALLInstances( EnumerateSysTray=FALSE )
{
   global T_TC_InSysTray, TC_TCINI
   T_TC_InSysTray := ""
   WinGet, wIDTray, list, , , ahk_class Shell_TrayWnd
   Loop, %wIDTray%
   {
      thisID := wIDTray%A_Index%
      WinGetClass, thisClass, ahk_id %thisID%
      if( thisClass <> "TTOTAL_CMD" )
         continue
      WinGetTitle, aTitle, ahk_id %thisID%
      WinGet, tcPID, PID, ahk_id %thisID%
      tc_CTList .= ProcessCreationTime( tcPID ) "," thisID "`n"
   }

   Sort, tc_CTList, N

   Loop, Parse, tc_CTList, `n
   {
      if( !A_LoopField )
         break
      Loop, Parse, A_LoopField, `,
         thisID := ( A_Index == 2 ? A_LoopField : "" )
      if( preINIT )
         TC_ST2A__CreateStruct( thisID + 0, A_Index )
      DetectHiddenWindows, OFF
      T_TC_InSysTray .= ( WinExist("ahk_id " thisID) ? "" : thisID + 0 "`n" )
      DetectHiddenWindows, ON
   }
return
}


ProcessCreationTime( PID ) {                        ; Requires AutoHotkey v1.0.46.03+

 VarSetCapacity(PrCT,16)  ,  VarSetCapacity(Dummy,16)  ,  VarSetCapacity(SysT,16)

 AccessRights := 1040       ; PROCESS_QUERY_INFORMATION = 1024,  PROCESS_VM_READ = 16
 hPr:=DllCall( "OpenProcess", Int,AccessRights, Int,0, Int,PID )
 DllCall( "GetProcessTimes" , Int,hPr, Int,&PrCT, Int,&Dummy, Int,&Dummy, Int,&Dummy)
 DllCall("CloseHandle"      , Int,hPr)

 DllCall( "FileTimeToLocalFileTime" , Int,&PrCT, Int,&PrCT )  ; PrCT is Creation time
 DllCall( "FileTimeToSystemTime"    , Int,&PrCt, Int,&SysT )  ; SysT is System Time

 Loop 16   {       ; Extracting and concatenating 8 words from a SYSTEMTIME structure
  Word := Mod(A_Index-1,2) ? "" :  *( &SysT +A_Index-1 ) + ( *(&SysT +A_Index) << 8 )
  Time .= StrLen(Word) = 1 ? ( "0" Word ) : Word  ; Prefixing "0" for single digits
           }
Return SubStr(Time,1,6) SubStr(Time,9) ; YYYYMMDD24MISS
}


TC_ST2A__ADDEventHook( wID, byRef hHook, byRef tcRCB )
{
   WinGet, tcPID, PID, ahk_id %wID%

   hHook := DllCall("SetWinEventHook", "uint", 0x800C, "uint", 0x800C
            , "uint", 0
            , "uint", tcRCB := RegisterCallback("TC_ST2A__ObjectChange")
            , "uint", tcPID      ; idProcess (0=all)
            , "uint", 0
            , "uint", 0 )
return
}

TC_ST2A__BBIconSize()
{
   TC_BBICONSIZE := 5 + (( (tcWidth - 8) == A_ScreenWidth && (tcHeight - 8) == A_ScreenHeight ) ? 24 : 32 )
return
}

TC_ST2A__ObjectChange( hWinEventHook, event, hwnd, idObject, idChild, thread, time )
{
static
   global T_TC_csID, T_TC_hwnd, T_TC_BBMinWidthChange, T_TC_BBChanged
   local idx
;   local EVENT_OBJECT_LOCATIONCHANGE := 0x0000800B
   local EVENT_OBJECT_NAMECHANGE     := 0x0000800C
   local tcWidth
/*
   if( event == EVENT_OBJECT_LOCATIONCHANGE && T_TC_BBMinWidthChange )
   {
      if( !ParseStringN( T_TC_hwnd, hwnd ) )
         return
      WinGetPos,,, tcWidth,,, ahk_id %hwnd%
      if( tcWidth < T_TC_BBMinWidthChange )
         TC_ST2A__BBIconSize()
   return
   }
*/
   if( idx := ParseStringN( T_TC_csID, hwnd ))
   {
      ControlGetText, cText%hwnd%,, ahk_id %hwnd%
      if( cText%hwnd% == cTextLast%hwnd% )
         return
      cTextLast%hwnd% := cText%hwnd%
      TC_ST2A__TitleReset( "", hwnd, idx, cText%hwnd% )
   }
   else
   if( idx := ParseStringN( T_TC_hwnd, hwnd ))
      TC_ST2A__TitleReset( hwnd, "", idx, cTextLast%hwnd% )
return
}


TC_ST2A__ShellMessages( wP,lP )
{
   global T_TC_InSysTray

   routine := TC_ST2A__HShellMsgName( wP )
   
   WinGetClass, aClass, ahk_id %lP%
   
   if( aClass <> "TTOTAL_CMD" )
      return
   
   if( routine == "HSHELL_WINDOWCREATED" )
   {
      if( ParseStringN( T_TC_InSysTray, lP, 0, TRUE ) )
         return
      else
         TC_ST2A__CreateStruct( lP + 0 )
   }
   else
   if( routine == "HSHELL_WINDOWDESTROYED" )
   {
      Sleep, 100
      TC_ST2A__INIT( FALSE )   ; Update T_TC_InSysTray
      if(!inStr( T_TC_InSysTray, lP "`n" ))
         TC_ST2A__DeleteStruct( lP + 0 )
   }
return
}


TC_ST2A__HShellMsgName( msgNum="" )
{
   static
   static init := 0
   local msgName
   
   if( !init && init := 1 )
   {
      local hMsgNames := "
         (LTrim Join, 
            HSHELL_WINDOWCREATED
            HSHELL_WINDOWDESTROYED
            HSHELL_ACTIVATESHELLWINDOW
            HSHELL_WINDOWACTIVATED
            HSHELL_GETMINRECT
            HSHELL_REDRAW
            HSHELL_TASKMAN
            HSHELL_LANGUAGE
            HSHELL_SYSMENU
            HSHELL_ENDTASK
            HSHELL_ACCESSIBILITYSTATE
            HSHELL_APPCOMMAND
            HSHELL_WINDOWREPLACED
            HSHELL_WINDOWREPLACING
            HSHELL_HIGHBIT
            HSHELL_FLASH
            HSHELL_RUDEAPPACTIVATED
         )"
         
      Loop, Parse, hMsgNames, `,
      {
         HSHELL__MSG%A_Index% := A_LoopField
      }
      if( msgNum == "" )
         return
   }
return ( msgName := (HSHELL__MSG%msgNum% ? HSHELL__MSG%msgNum% : "UNKNOWN") )
}


TC_ST2A__UnHookEvent( hHook, tcRCB )
{
Critical
   if( hHook )   
      DllCall("UnhookWinEvent", "Uint", hHook)
   if( tcRCB )
      DllCall("GlobalFree", UInt, &tcRCB )
return
}

DeRegisterHooks:
{
Critical
   MsgBox,,DeRegisterHooks, Deregistering Hooks...,1

   DllCall( "UnhookWinEvent", Uint,hWinEventHook )
   DllCall( "GlobalFree", UInt,&HookProcAdr ) ; free up allocated memory for RegisterCallback

   DllCall( "DeregisterShellHookWindow", "UInt", TC_ST2A__hWnd )
   Loop, %TC_COUNT%
      TC_ST2A__DeleteStruct( "", A_Index )   ; This includes, Unhooking Events.
   ExitApp
}   


TC_ST2A__ExitScript()
{
   MsgBox,4,%A_ScriptName%::%A_ThisFunc%(),Do you wish to Exit %A_ScriptName%?,4
   ifMsgBox, YES
      ExitApp
   else
   ifMsgBox, TimeOut
      return
return
}

/*   NOTE::
 *   If you disable the SystemTray icon above, then
 *   you should enable a Hotkey to exit the script.
 */
;#ifWinActive, ahk_class TTOTAL_CMD
;{
;   ;; ^#!4::TC_ST2A__ExitScript()
;return
;} 
