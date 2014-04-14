library tag_panel;

uses
SysUtils,
Windows,
Tag_types;

{$R *.res}
{$E wdx}
type 
  TCode = (win, koi, iso, dos); 
   
const 
  CodeStrings: array [TCode] of String = ('win','koi','iso','dos');

Function GetCode (So:String):String;
var 
  str: array [TCode] of string; 
  norm: array ['À'..'ÿ'] of single; 
  code1, code2: TCode; 
  min1, min2: TCode; 
  count: array [char] of integer; 
  d, min: single; 

  s: string;
  chars: array [char] of char; 
  c: char; 
  i: integer;
Begin
norm['À'] := 0.001; 
  norm['Á'] := 0; 
  norm['Â'] := 0.002; 
  norm['Ã'] := 0; 
  norm['Ä'] := 0.001; 
  norm['Å'] := 0.001; 
  norm['Æ'] := 0; 
  norm['Ç'] := 0; 
  norm['È'] := 0.001; 
  norm['É'] := 0; 
  norm['Ê'] := 0.001; 
  norm['Ë'] := 0; 

  norm['Ì'] := 0.001; 
  norm['Í'] := 0.001; 
  norm['Î'] := 0.001; 
  norm['Ï'] := 0.002; 
  norm['Ğ'] := 0.002; 
  norm['Ñ'] := 0.001; 
  norm['Ò'] := 0.001; 
  norm['Ó'] := 0; 
  norm['Ô'] := 0; 
  norm['Õ'] := 0; 
  norm['Ö'] := 0; 
  norm['×'] := 0.001; 
  norm['Ø'] := 0.001; 
  norm['Ù'] := 0; 
  norm['Ú'] := 0; 
  norm['Û'] := 0; 
  norm['Ü'] := 0; 

  norm['İ'] := 0.001; 
  norm['Ş'] := 0; 
  norm['ß'] := 0; 
  norm['à'] := 0.057; 
  norm['á'] := 0.01; 
  norm['â'] := 0.031; 
  norm['ã'] := 0.011; 
  norm['ä'] := 0.021; 
  norm['å'] := 0.067; 
  norm['æ'] := 0.007; 
  norm['ç'] := 0.013; 
  norm['è'] := 0.052; 
  norm['é'] := 0.011; 
  norm['ê'] := 0.023; 
  norm['ë'] := 0.03; 
  norm['ì'] := 0.024; 

  norm['í'] := 0.043; 
  norm['î'] := 0.075; 
  norm['ï'] := 0.026; 
  norm['ğ'] := 0.038; 
  norm['ñ'] := 0.034; 
  norm['ò'] := 0.046; 
  norm['ó'] := 0.016; 
  norm['ô'] := 0.001; 
  norm['õ'] := 0.006; 
  norm['ö'] := 0.002; 
  norm['÷'] := 0.011; 
  norm['ø'] := 0.004; 
  norm['ù'] := 0.004; 
  norm['ú'] := 0; 
  norm['û'] := 0.012; 
  norm['ü'] := 0.012; 

  norm['ı'] := 0.003; 
  norm['ş'] := 0.005; 
  norm['ÿ'] := 0.015; 

  Str[win] := 'ÀàÁáÂâÃãÄäÅåÆæÇçÈèÉéÊêËëÌìÍíÎîÏïĞğÑñÒòÓóÔôÕõÖö×÷ØøÙùÚúÛûÜüİıŞşßÿ'; 
  Str[koi] := 'şŞàÀáÁöÖäÄåÅôÔãÃõÕèÈéÉêÊëËìÌíÍîÎïÏÿßğĞñÑòÒóÓæÆâÂüÜûÛçÇøØıİùÙ÷×úÚ'; 
  Str[iso] := 'ĞğÑñÒòÓóÔôÕõÖö×÷ØøÙùÚúÛûÜüİıŞşßÿà¹á¸âãƒäºå¾æ³ç¿è¼éšêœëìí§î¢ïŸ';
  Str[dos] := '‰“Š…ƒ˜™‡•š”›‚€‹„†Ÿ—‘Œˆ’œ©æãª¥­£èé§åêäë¢ ¯à®«¤¦íïçá¬¨âì¡î';

  
  for c := #0 to #255 do
    Chars[c] := c;

  min1 := win;
  min2 := win;
  min := 0;
  s := so;
  fillchar(count, sizeof(count), 0);
  for i := 1 to Length(s) do
    inc(count[s[i]]);
  for c := 'À' to 'ÿ' do
    min := min + sqr(count[c] / Length(s) - norm[c]);
  for code1 := low(TCode) to high(TCode) do begin
    for code2 := low(TCode) to high(TCode) do begin

      if code1 = code2 then continue;

      s := so;
      for i := 1 to Length(Str[win]) do
        Chars[Str[code2][i]] := Str[code1][i];
      for i := 1 to Length(s) do
        s[i] := Chars[s[i]];
      fillchar(count, sizeof(count), 0);
      for i := 1 to Length(s) do
        inc(count[s[i]]);
      d := 0;
      for c := 'À' to 'ÿ' do

        d := d + sqr(count[c] / Length(s) - norm[c]); 
      if d < min then begin
        min1 := code1;
        min2 := code2;
        min := d; 
      end;
    end; 
  end; 
 Result:=CodeStrings[min2];
end;

{------------------------------------------------------------------------------}
function ContentGetSupportedField(FieldIndex:integer;FieldName:pchar;Units:pchar;maxlen:integer):integer; stdcall;
Begin
 Case FieldIndex of
 0: Begin
     Strlcopy (FieldName,'Codepage',MaxLen-1);
     result:=ft_string;
    end;
 else result:=ft_nomorefields;
 End;
End;
{------------------------------------------------------------------------------}
function ContentGetValue(FileName:pchar;FieldIndex,UnitIndex:integer;FieldValue:pbyte;maxlen,flags:integer):integer; stdcall;
var
FileInfo:tWIN32FINDDATA;
F:HFile;
Buf:array [1..1024] of char;
Read:DWORD;
S:AnsiString;
Begin
Result:=ft_nomorefields;
if ExtractFileExt(FileName)='.txt' then
 Begin
 F:=CreateFile (FileName,GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,0,0);
 ReadFile (F,buf,sizeof(buf),READ,nil);
 FileClose (F);
 S:=String (buf);
 result:=ft_string;
 S:=GetCode (S);
 end;
Strlcopy (pchar (Fieldvalue), Pchar(S),maxlen-1);

End;

exports
       ContentGetSupportedField,
       ContentGetValue;
begin
end.
