program stDLLtest;

uses
  lazutf8;

function Transliterate(p: PChar): PChar; external 'testlib.dll' name 'transliterate_ex';

var
  s: string;

begin
  writeln('Input some, or "stop" for quit');
  writeln;
  repeat
    readln(s);
    writeln(Transliterate(PChar(s)));
  until s = 'stop';
end.

