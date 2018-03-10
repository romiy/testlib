program dlltest1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, dynlibs, lazutf8
  { you can add units after this };

type

  //Loaded from DLL function type
  TTransliterationFunc = function (par1: PChar): PChar;

  { TDLLTestApplication }

  TDLLTestApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  private
    LibHandle: THandle;
    Transliterate: TTransliterationFunc;
  end;

const
  LibName = '\testlib.dll'; // library file name with leading (back, if windows)slash
  FuncName = 'transliterate_ex'; //exporting function name

{ TDLLTestApplication }

procedure TDLLTestApplication.DoRun;
var
  s: String;
begin
while not Terminated do begin //call Terminate if you want to stop application
  //First we need to load DLL and assign TTransliterationFunc type variable
  LibHandle := 0;
  LibHandle := SafeLoadLibrary(GetCurrentDir+LibName);

  if LibHandle <> 0 then // if DLL was loaded
  begin
    writeln(GetCurrentDir+LibName+' loaded successfully!');
    pointer(Transliterate) := GetProcAddress(LibHandle, FuncName);
  end
  else // else type error and go exit
  begin
    writeln('In '+GetCurrentDir+' '+LibName+' not found. Press Enter to quit.');
    readln;
    Terminate;
    break;
  end;

  if pointer(Transliterate) <> nil then begin // if function found
    writeln(FuncName+'''s address is '+inttostr(QWord(Transliterate)));
    writeln('Input some, or "stop" for quit');
    writeln;
    // use this function until we saying stop
    while s <> 'stop' do begin
      //p := ''; p1 := '';
      readln(s);
      //writeln(s);
      //p := PChar(s);
      //writeln(p);
      //p1 := Transliterate(p);
      writeln(Transliterate(PChar(s)));
    end;
  end
  else begin // else type error and go exit
    writeln('No '+FuncName+' in '+LibName+' found. Press Enter to quit.');
    readln;
    Terminate;
    break;
  end;

  // if stop was sayed
  // here we need to unload and DLL and clean TTransliterationFunc type variable
  if LibHandle <> 0 then if FreeLibrary(LibHandle) then begin
    LibHandle := 0;
    pointer(Transliterate) := nil;
    Terminate; // and don't forget to say application to be terminated
  end;

end;// stop program loop
end;

constructor TDLLTestApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TDLLTestApplication.Destroy;
begin
  inherited Destroy;
end;

var
  Application: TDLLTestApplication;
begin
  Application:=TDLLTestApplication.Create(nil);
  Application.Title:='DLL test 1';
  Application.Run;
  Application.Free;
end.

