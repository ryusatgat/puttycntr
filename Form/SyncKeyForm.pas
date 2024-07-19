unit SyncKeyForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, CheckLst, AppEvnts;

type
  TFormSyncKey = class(TForm)
    sbPaste: TSpeedButton;
    Label1: TLabel;
    cklList: TCheckListBox;
    Label2: TLabel;
    edChar: TEdit;
    Label3: TLabel;
    edString: TEdit;
    ckTransparant: TCheckBox;
    procedure sbPasteClick(Sender: TObject);
    procedure edCharKeyPress(Sender: TObject; var Key: Char);
    procedure edStringKeyPress(Sender: TObject; var Key: Char);
    procedure ckTransparantClick(Sender: TObject);
  private
    { Private declarations }
    procedure CMDialogKey(var Msg: TWMKey); message CM_DIALOGKEY;
  public
    { Public declarations }
    procedure SendKey(Str: String); overload;
    procedure SendKey(Key: Char); overload;
  end;

var
  FormSyncKey: TFormSyncKey;

implementation

uses
  ChildForm, ClipBrd;

{$R *.dfm}

procedure TFormSyncKey.ckTransparantClick(Sender: TObject);
begin
  AlphaBlend := ckTransparant.Checked;
end;

procedure TFormSyncKey.CMDialogKey(var Msg: TWMKey);
begin
  if (ActiveControl is TEdit) and (Msg.CharCode = VK_TAB) then
    exit;

  inherited;
end;

procedure TFormSyncKey.edCharKeyPress(Sender: TObject; var Key: Char);
begin
  SendKey(Key);
end;

procedure TFormSyncKey.edStringKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then
  begin
    Clipboard.SetTextBuf(PChar(edString.Text));
    sbPaste.Click;
    edString.Clear;
  end;
end;

procedure TFormSyncKey.sbPasteClick(Sender: TObject);
const
  IDM_PASTE = $0190;
var
  i: Integer;
begin
  for i:=0 to cklList.Count-1 do
  begin
    if cklList.Checked[i] then
      SendMessage(TFormChild(cklList.Items.Objects[i]).Wnd, WM_SYSCOMMAND, IDM_PASTE, 0);
  end;
end;

procedure TFormSyncKey.SendKey(Str: String);
var
  i: Integer;
begin
  for i:=1 to Length(Str) do
    SendKey(Char(Str[i]));
end;

procedure TFormSyncKey.SendKey(Key: Char);
var
  i: Integer;
begin
  for i:=0 to cklList.Count-1 do
  begin
    if cklList.Checked[i] then
    begin
      SendMessage(TFormChild(cklList.Items.Objects[i]).Wnd, WM_CHAR, Ord(Key), 0);
    end;
  end;
end;

end.
