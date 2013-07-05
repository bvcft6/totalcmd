IniRead(_IniFile="", _Options="") ; http://www.autohotkey.com/forum/topic72442.html
{
   Local _Reading, _Prepend, _Entries, _nSec, _nKey, _@ := 0, _@1, _@2, _Literal := """", _Commands := "sa|ka|sl|sr|p|d|r|e|t|c"
   ;---------------------------------OPTIONS:-----------------------------------------------------------
   ; INITIAL                 DEFAULT                 NAME                    ABOUT
   , _sa := "",              _sa_def := "Sections*"  ;sa = Section Array     Creates the specified pseudoarray containing each section header that was read. An asterisk (*) will be replaced by the item number, otherwise it will be appended to the end. Item 0 will contain the size of the ray. Only applicable if all sections are being read (s = "")
   , _ka := "",              _ka_def := "Keys*"      ;ka = Key Array         Same as above but for individual keys. Similar to the d option
   , _sl := "",              _sl_def := "*"          ;sl = Section (Literal) Section to use out of whole file. If multiple sections have the same name the first will be used. Specify an asterisk (*) to only read the first section. Leave blank to read the entire file
   , _sr := "",              _sr_def := ""           ;sr = Section (RegEx)   Same as above but will extract from all sections whose names match the given regular expression
   , _p := "",               _p_def := "*_"          ;p = Prepend            Prepend this string to the variables. An asterisk (*) will be replaced by the current section name
   , _d := "",               _d_def := "`n"          ;d = Delimited List     Instead of returning the number of keys read, the function will return a string of all variables created (i.e. all keys read with any additional modifications made by _r or _p) delimited by the indicated character(s)
   , _r := "",               _r_def := "_"           ;r = Replace Bad Chars  One or more characters in key or section names that are unsuitable for AutoHotkey variable names will be replaced by this character
   , _e := "fso",            _e_def := ""            ;e = Error Behavior     Indicate/omit any combination of f/s/o/r to display an error dialog/exit silently if the ini file cannot be found/the desired section cannot be found/a preexisting variable will be overwritten/r will replace any inappropriate characters
   , _t := True,             _t_def := False         ;t = Trim Whitespace    Trims whitespaces from the beginning and end of all keys and values
   , _c := False,            _c_def := True          ;c = Allow Comments     Specifying true for Allow Comments will exclude all comments from ini values. Comments are delimited with a space and then a semicolon (;) as in AutoHotkey
   ;----------------------------------------------------------------------------------------------------
   While (_@ := RegExMatch(_Options, "i)\s*\K(?P<1>" _Commands ")(?P<2>" _Literal "(?:[^" _Literal "]|" _Literal _Literal ")*" _Literal "(?= |$)|[^ ]*)", _@, _@ + StrLen(_@1 _@2) + 1))
      If (_@2 <> "") {
         If (InStr(_@2, _Literal) = 1) and (StrLen(_@2) > 1) and (SubStr(_@2, 0, 1) = _Literal) and (_@2 := SubStr(_@2, 2, -1))
            StringReplace, _@2, _@2, %_Literal%%_Literal%, %_Literal%, All
         _%_@1% := _@2
      } Else
         _%_@1% := _%_@1%_def
   If RegExMatch(_r, "[^\w#@$?]") or RegExMatch(_p, "[^\w*#@$?]") {
      MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, Neither the p nor r options may contain characters that are not alloewd in AutoHotkey variable names.
      Return
   }
   _Entries := _d = "" ? 0 : _d
   If !InStr(_p, "*")
      _Prepend := _p
   If (_IniFile = "") {
      Loop, *.ini
      {
         _IniFile := A_LoopFileFullPath
         Break
      }
      If (_IniFile = "") {
         If InStr(_e, "f")
            MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, No .ini file found in working directory.`n`not avoid this error, specify an explicit .ini file path in the first parameter of the function.
         Return
      }
   } Else If !FileExist(_IniFile) {
      If InStr(_e, "f")
         MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, File "%_IniFile%" not found or does not exist.
      Return
   }
   If (_sl <> "") {
      If (_sr <> "") {
         MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, Please enter either a sl (Section - Literal) or sr (Section - RegEx) value, not both.
         Return
      }
   } Else If (_sr = "")
      _Reading := True
   If (_sa <> "") {
      If RegExMatch(_sa, "[^\w#@$?*]")
         _sa := RegExReplace(_sa, "[^\w#@$?*]")
      If !InStr(_sa, "*")
         _sa .= "*"
   }
   If (_ka <> "") {
      If RegExMatch(_ka, "[^\w#@$?*]")
         _ka := RegExReplace(_ka, "[^\w#@$?*]")
      If !InStr(_ka, "*")
         _ka .= "*"
      If (_ka = _sa) {
         MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, The sa (Section Output Array) and ka (Key Output Array) options cannot be the same.
         Return
      }
   }
   Loop, Read, %_IniFile%
      If RegExMatch(A_LoopReadLine, "^[^=]*\[\K[^\]]+(?=\])", _@) {
         If _t
            _@ = %_@%
         If (_sr <> "")
            _Reading := RegExMatch(_@, _sr) ? True : False
         Else If (_sl <> "")
            If _Reading
               Break
            Else If (_@ = _sl) or (_sl = "*")
               _Reading := True
         If !_Reading
            Continue
         If InStr(_p, "*") {
            StringReplace, _Prepend, _p, *, % RegExReplace(_@, "[^\w#_t$?]+", _r, _@2), All
            If _@2 and InStr(_e, "r") {
               MsgBox, 262420, %A_ScriptName% - %A_ThisFunc%(): Error, The section "%_@%" contains characters not allowed in AutoHotkey variable names. Replace these characters with "%_r%"?`n`nTo change the replacement character, use the r option.
               IfMsgBox NO
                  Return
            }
         }
         If _sa {
            _nSec += 1
            StringReplace, _@1, _sa, *, %_nSec%, All
            %_@1% := _@
         }
      } Else If _Reading and InStr(A_LoopReadLine, "=") {
         _@ := SubStr(A_LoopReadLine, 1, InStr(A_LoopReadLine, "=") - 1), _@2 := SubStr(A_LoopReadLine, InStr(A_LoopReadLine, "=") + 1)
         If _t {
            _@ = %_@%
            _@2 = %_@2%
         }
         If _c
            _@2 := RegExReplace(_@2, "(?:\s+|^);.*")
         _@1 := RegExReplace(_@, "[^\w#_t$?]+", _r)
         If (_@1 <> _@) and InStr(_e, "r") {
            MsgBox, 262420, %A_ScriptName% - %A_ThisFunc%(): Error, The key name "%_@%" contains characters not allowed in AutoHotkey variable names. Replace these characters with "%_r%"?`n`nTo change the replacement character, use the r option.
            IfMsgBox NO
               Return
         }
         If (%_Prepend%%_@1% <> "") and InStr(_e, "o") {
            MsgBox, 262420, %A_ScriptName% - %A_ThisFunc%(): Error, The variable "%_Prepend%%_@1%" has already been assigned, either by %A_ThisFunc%() or elsewhere in the script. Overwrite it with "%_@2%" (the value from the .ini file)?`n`nTo avoid this error, try using the p or s options to make output variable names more unique.
            IfMsgBox NO
               Return
         }
         %_Prepend%%_@1% := _@2
         If (_d <> "") {
            StringReplace, _Entries, _Entries, %_d%%_Prepend%%_@1%%_d%, %_d%, All
            _Entries .= _Prepend _@1 _d
         } Else
            _Entries += 1
         If _ka {
            _nKey += 1
            StringReplace, _@, _ka, *, %_nKey%, All
            %_@% := _Prepend _@1
         }
      }
   If (_sl <> "") and !_Reading and InStr(_e, "s")
      MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, Section "%_sl%" was not found in ini file "%_IniFile%", therefore no variables were assigned.`n`nTo avoid this error, use the sr (Section Name - RegEx) option instead of sl (Section Name - Literal), or omit both options.
   If _sa {
      StringReplace, _@, _sa, *, 0, All
      %_@% := _nSec
   }
   If _ka {
      StringReplace, _@, _ka, *, 0, All
      %_@% := _nKey
   }
   Return _d = "" ? _Entries : SubStr(_Entries, 2, -1)
}


;IniRead("AutoHotKey.ini", "slString pstr_")
;IniRead("AutoHotKey.ini", "p*_")
;Listvars
;pause