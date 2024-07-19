unit MingwForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFormMingw = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edPath: TEdit;
    edArgs: TEdit;
    btOk: TButton;
    btCancle: TButton;
    OpenDialog: TOpenDialog;
    btPosition: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure btCancleClick(Sender: TObject);
    procedure btPositionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMingw: TFormMingw;

implementation

uses
  Registry, RsCommon;

{$R *.dfm}

procedure TFormMingw.btCancleClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormMingw.btOkClick(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;

  try
    reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKey(PUTTY_KEY_SESSIONS, True) then
    begin
      Reg.WriteString('rxvt', edPath.Text);
      Reg.WriteString('rxvtArgs', edArgs.Text);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  ModalResult := mrOk;
end;

procedure TFormMingw.btPositionClick(Sender: TObject);
begin
  OpenDialog.InitialDir := ExtractFilePath(edPath.Text);
  if OpenDialog.Execute then
    edPath.Text := OpenDialog.FileName;  
end;

procedure TFormMingw.FormCreate(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;

  try
    reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKey(PUTTY_KEY_SESSIONS, False) then
    begin
      edPath.Text := Reg.ReadString('rxvt');
      edArgs.Text := Reg.ReadString('rxvtArgs');
      if edPath.Text = '' then
        edPath.Text := 'C:\MinGW\MSYS\bin\rxvt.exe';
      if edArgs.Text = '' then
        edArgs.Text := '-backspacekey  -sl 2500 -fg White -bg Black -sr -fn Courier-12 -tn msys -e /bin/sh --login -i';
      reg.CloseKey;
    end else
    begin
      ShowMessage('레지스트리를 읽지 못했습니다');
      exit;
    end;
  finally
    Reg.Free;
  end;
end;

end.
