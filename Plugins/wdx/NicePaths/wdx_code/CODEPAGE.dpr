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
  norm: array ['�'..'�'] of single; 
  code1, code2: TCode; 
  min1, min2: TCode; 
  count: array [char] of integer; 
  d, min: single; 

  s: string;
  chars: array [char] of char; 
  c: char; 
  i: integer;
Begin
norm['�'] := 0.001; 
  norm['�'] := 0; 
  norm['�'] := 0.002; 
  norm['�'] := 0; 
  norm['�'] := 0.001; 
  norm['�'] := 0.001; 
  norm['�'] := 0; 
  norm['�'] := 0; 
  norm['�'] := 0.001; 
  norm['�'] := 0; 
  norm['�'] := 0.001; 
  norm['�'] := 0; 

  norm['�'] := 0.001; 
  norm['�'] := 0.001; 
  norm['�'] := 0.001; 
  norm['�'] := 0.002; 
  norm['�'] := 0.002; 
  norm['�'] := 0.001; 
  norm['�'] := 0.001; 
  norm['�'] := 0; 
  norm['�'] := 0; 
  norm['�'] := 0; 
  norm['�'] := 0; 
  norm['�'] := 0.001; 
  norm['�'] := 0.001; 
  norm['�'] := 0; 
  norm['�'] := 0; 
  norm['�'] := 0; 
  norm['�'] := 0; 

  norm['�'] := 0.001; 
  norm['�'] := 0; 
  norm['�'] := 0; 
  norm['�'] := 0.057; 
  norm['�'] := 0.01; 
  norm['�'] := 0.031; 
  norm['�'] := 0.011; 
  norm['�'] := 0.021; 
  norm['�'] := 0.067; 
  norm['�'] := 0.007; 
  norm['�'] := 0.013; 
  norm['�'] := 0.052; 
  norm['�'] := 0.011; 
  norm['�'] := 0.023; 
  norm['�'] := 0.03; 
  norm['�'] := 0.024; 

  norm['�'] := 0.043; 
  norm['�'] := 0.075; 
  norm['�'] := 0.026; 
  norm['�'] := 0.038; 
  norm['�'] := 0.034; 
  norm['�'] := 0.046; 
  norm['�'] := 0.016; 
  norm['�'] := 0.001; 
  norm['�'] := 0.006; 
  norm['�'] := 0.002; 
  norm['�'] := 0.011; 
  norm['�'] := 0.004; 
  norm['�'] := 0.004; 
  norm['�'] := 0; 
  norm['�'] := 0.012; 
  norm['�'] := 0.012; 

  norm['�'] := 0.003; 
  norm['�'] := 0.005; 
  norm['�'] := 0.015; 

  Str[win] := '����������������������������������������������������������������'; 
  Str[koi] := '����������������������������������������������������������������'; 
  Str[iso] := '������������������������������������������������';
  Str[dos] := '���������������������������������㪥�������뢠�஫�����ᬨ���';

  
  for c := #0 to #255 do
    Chars[c] := c;

  min1 := win;
  min2 := win;
  min := 0;
  s := so;
  fillchar(count, sizeof(count), 0);
  for i := 1 to Length(s) do
    inc(count[s[i]]);
  for c := '�' to '�' do
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
      for c := '�' to '�' do

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
