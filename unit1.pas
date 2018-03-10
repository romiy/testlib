unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  dynlibs, lazUTF8;

type

  TTransliterateFunc = function(p1: PChar): PChar;

  { TForm1 }

  TForm1 = class(TForm)
    btnLoadDLL: TButton;
    btnGetFunc: TButton;
    btnGo: TButton;
    edDLLName: TEdit;
    edFuncName: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    memoLog: TMemo;
    procedure btnGetFuncClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnLoadDLLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    LibHandle: THandle;
    Transliterate : TTransliterateFunc;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnLoadDLLClick(Sender: TObject);
begin
  if LibHandle = 0 then
  begin
    LibHandle := SafeLoadLibrary(GetCurrentDir+edDLLName.Text);
    if LibHandle <> 0 then
      memoLog.Lines.Add('DLL load, handle = '+intToStr(LibHandle))
    else
      memoLog.Lines.Add('No '+edDLLName.Text+' in '+GetCurrentDir+' found');
  end
  else
    memoLog.Lines.Add('DLL already load, handle = '+intToStr(LibHandle))
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  LibHandle := 0;
  pointer(Transliterate) := nil;
end;

procedure TForm1.btnGetFuncClick(Sender: TObject);
begin
  if LibHandle <> 0 then
    if pointer(Transliterate) = nil then
    begin
      pointer(Transliterate) := GetProcAddress(LibHandle, edFuncName.Text);
      if pointer(Transliterate) = nil then
        memoLog.Lines.Add('No '+edFuncName.Text+' in '+edDLLName.Text+' found')
      else
        memoLog.Lines.Add(edFuncName.Text+'''s address is '+inttostr(QWord(Transliterate)));
    end
    else
      memoLog.Lines.Add('Function '+edFuncName.Text+' already loaded, address '+inttostr(QWord(Transliterate)))
  else
    memoLog.Lines.Add('Library '+edDLLName.Text+' not loaded');
end;

procedure TForm1.btnGoClick(Sender: TObject);
var
  p, p1 :PChar;
begin
  if LibHandle <> 0 then
    if pointer(Transliterate) <> nil then
    begin
      p1 := '';
      p := PChar(Edit1.Text);
      p1 := Transliterate(p);
      Edit2.Text := string(p1);
    end
    else
      memoLog.Lines.Add('Function '+edFuncName.Text+' not loaded')
  else
    memoLog.Lines.Add('Library '+edDLLName.Text+' not loaded');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if LibHandle <> 0 then if FreeLibrary(LibHandle) then begin
    LibHandle := 0;
    pointer(Transliterate) := nil;
    memoLog.Lines.Add(edDLLName.Text+' unloaded');
  end
  else
    memoLog.Lines.Add('Something went wrong and '+edDLLName.Text+' not unloaded but anyway app is closing and it''s don''t matter');
end;

end.

