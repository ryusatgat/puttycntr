unit PasswordForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPassword = class(TForm)
    Label1: TLabel;
    edPassword: TEdit;
    btOk: TButton;
    procedure btOkClick(Sender: TObject);
    procedure edPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPassword: TFormPassword;

implementation

uses
  NTLogon;

{$R *.dfm}

procedure TFormPassword.btOkClick(Sender: TObject);
begin
//  if edPassword.Text = 'Melong18' then
  if CheckWindowsPassword(edPassword.Text) then
  begin
    ModalResult := mrOk;
  end else
  begin
    ShowMessage('비밀번호가 잘못되었습니다');
    if edPassword.CanFocus then
      edPassword.SetFocus;
    edPassword.SelectAll;
  end;
end;

procedure TFormPassword.edPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btOk.Click;
  end else if Key = #27 then
    ModalResult := mrCancel;
end;

end.
