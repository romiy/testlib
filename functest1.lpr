program functest1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, lazUtf8
  { you can add units after this };

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TMyApplication }

function getLatinStr(a,b : byte): string;
begin
  if a = $D0 then begin
    {А}if b = $90 then result := 'A';
    {Б}if b = $91 then result := 'B';
    {В}if b = $92 then result := 'V';
    {Г}if b = $93 then result := 'G';
    {Д}if b = $94 then result := 'D';
    {Е}if b = $95 then result := 'E';
    {Ж}if b = $96 then result := 'Zh';
    {З}if b = $97 then result := 'Z';
    {И}if b = $98 then result := 'I';
    {Й}if b = $99 then result := 'Iy';
    {К}if b = $9A then result := 'K';
    {Л}if b = $9B then result := 'L';
    {М}if b = $9C then result := 'M';
    {Н}if b = $9D then result := 'N';
    {О}if b = $9E then result := 'O';
    {П}if b = $9F then result := 'P';
    {Р}if b = $A0 then result := 'R';
    {С}if b = $A1 then result := 'S';
    {Т}if b = $A2 then result := 'T';
    {У}if b = $A3 then result := 'U';
    {Ф}if b = $A4 then result := 'F';
    {Х}if b = $A5 then result := 'Kh';
    {Ц}if b = $A6 then result := 'Ts';
    {Ч}if b = $A7 then result := 'Ch';
    {Ш}if b = $A8 then result := 'Sh';
    {Щ}if b = $A9 then result := 'Tsch';
    {Ъ}if b = $AA then result := '';
    {Ы}if b = $AB then result := 'Y';
    {Ь}if b = $AC then result := '';
    {Э}if b = $AD then result := 'E';
    {Ю}if b = $AE then result := 'Yu';
    {Я}if b = $AF then result := 'Ya';
    {а}if b = $B0 then result := 'a';
    {б}if b = $B1 then result := 'b';
    {в}if b = $B2 then result := 'v';
    {г}if b = $B3 then result := 'g';
    {д}if b = $B4 then result := 'd';
    {е}if b = $B5 then result := 'e';
    {ж}if b = $B6 then result := 'zh';
    {з}if b = $B7 then result := 'z';
    {и}if b = $B8 then result := 'i';
    {й}if b = $B9 then result := 'iy';
    {к}if b = $BA then result := 'k';
    {л}if b = $BB then result := 'l';
    {м}if b = $BC then result := 'm';
    {н}if b = $BD then result := 'n';
    {о}if b = $BE then result := 'o';
    {п}if b = $BF then result := 'p';
    {Ё}if b = $01 then result := 'Yo';
  end
  else
  if a = $D1 then begin
    {р}if b = $80 then result := 'r';
    {с}if b = $81 then result := 's';
    {т}if b = $82 then result := 't';
    {у}if b = $83 then result := 'u';
    {ф}if b = $84 then result := 'f';
    {х}if b = $85 then result := 'kh';
    {ц}if b = $86 then result := 'ts';
    {ч}if b = $87 then result := 'ch';
    {ш}if b = $88 then result := 'sh';
    {щ}if b = $89 then result := 'tsch';
    {ъ}if b = $8A then result := '';
    {ы}if b = $8B then result := 'y';
    {ь}if b = $8C then result := '';
    {э}if b = $8D then result := 'e';
    {ю}if b = $8E then result := 'yu';
    {я}if b = $8F then result := 'ya';
    {ё}if b = $91 then result := 'yo';
  end
  else
    result := '';
end;

function transliterate_ex(s: PChar): PChar; //export; stdcall;
var
  cl, i : integer;
  _res: string;
begin
  _res:='';
  repeat
    cl := UTF8CharacterLength(s);
    if cl = 2 then
      _res := _res + getLatinStr(Byte(s[0]),Byte(s[1]))
    else
      for i := 1 to cl do _res := _res + s[i-1];
    inc(s,cl);
  until (cl = 0) or (s^ = #0);
  result := PChar(_res);
end;

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
  ErrorMsg := 'фы9ва';

  writeln(transliterate_ex(PChar(ErrorMsg)));
  readln;
  // stop program loop
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

