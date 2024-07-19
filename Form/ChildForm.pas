unit ChildForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, AppEvnts, TermThread, ComCtrls;

type
  TFormChild = class(TForm)
    TimerLogin: TTimer;
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerLoginTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    TermThread: TTermThread;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    Wnd: HWND;
    ProcessId: DWORD;
    Protocol: Integer;
    Port: String;
    Id: String;
    IP: String;
    SessionName: String;
    Password: String;
    OldProc: TFarProc;
    hProcess: THandle;
    InfoId, InfoPassword: String;
    procedure ShowConnectionInfo;
    procedure CreateTermThread(hProcess: THandle);
  end;

var
  FormChild: TFormChild;

implementation

uses
  MainForm;

{$R *.dfm}

{ TFormChild }
procedure TFormChild.CreateParams(var Params: TCreateParams);
begin
  inherited;
//  Params.Style := Params.Style and not WS_CAPTION;
end;

procedure TFormChild.CreateTermThread(hProcess: THandle);
begin
  TermThread := TTermThread.Create(Self.Handle, hProcess, Wnd);
  TermThread.Start;
end;

procedure TFormChild.FormActivate(Sender: TObject);
begin
  if ((GetAsyncKeyState(VK_MENU) and $8001) > 0) then
    exit;
  SetWindowPos(Wnd, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  with TFormPuttyMain(Application.MainForm) do
  begin
    OnActivateMDIChild(Self);
  end;
end;

procedure TFormChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TFormPuttyMain(Application.MainForm).OnCloseMDIChild(Self);
  Action := caFree;
end;

procedure TFormChild.FormCreate(Sender: TObject);
begin
  TermThread := nil;
  Width := TFormPuttyMain(Application.MainForm).Width - GetSystemMetrics(SM_CXFRAME);
  Height := TFormPuttyMain(Application.MainForm).VSplitter.Height - GetSystemMetrics(SM_CYFRAME);
  Left := 0;
  Top := 0;
end;

procedure TFormChild.FormDestroy(Sender: TObject);
begin
  SendMessage(Wnd, WM_DESTROY, 0, 0);
  SendMessage(Wnd, WM_CLOSE, 0, 0);

  if Assigned(TermThread) then
    TermThread.Terminate;
end;

procedure TFormChild.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift <> [ssAlt] then
  begin
    if not TFormPuttyMain(Application.MainForm).ConnectionForm.Visible then
      SetWindowPos(Wnd, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure TFormChild.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not TFormPuttyMain(Application.MainForm).ConnectionForm.Visible then
    SendMessage(Wnd, WM_CHAR, Ord(Key), 0);
end;

procedure TFormChild.FormResize(Sender: TObject);
begin
  SendMessage(Wnd, WM_ENTERSIZEMOVE, 0, 0);
  SetWindowPos(Wnd, 0, 0, 0,
      ClientWidth-1,
      ClientHeight-1, SWP_NOACTIVATE);
  SendMessage(Wnd, WM_EXITSIZEMOVE, 0, 0);
end;

procedure TFormChild.FormShow(Sender: TObject);
begin
  SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
  SetWindowLong(Wnd, GWL_EXSTYLE, GetWindowLong(Wnd, GWL_EXSTYLE) and not(WS_EX_STATICEDGE or WS_EX_WINDOWEDGE or WS_EX_CLIENTEDGE ));
end;

procedure TFormChild.ShowConnectionInfo;
begin
  ShowMessage(
    '---- ' + Self.Caption + ' ----' + #13 +
    'Ip      : ' + IP + #13 +
    'Port    : ' + Port + #13 +
    'User    : ' + InfoId + #13 +
    'Password: ' + InfoPassword + #13
  );
end;

procedure TFormChild.TimerLoginTimer(Sender: TObject);
var
  CharKey: LParam;
begin
  if Wnd = NULL then
    exit;

  TimerLogin.Enabled := False;

  if (Id = '') and (Password = '') then
    exit;

  if TimerLogin.Interval > 20 then
  begin
    if Id = '' then
      exit;
  end;

  if Length(Id) > 0 then
  begin
    CharKey := Ord(Id[1]);
    Id := Copy(Id, 2, Length(Id)-1);
    SendMessage(Wnd, WM_CHAR, CharKey, 0);
    if Length(Id) = 0 then
      SendMessage(Wnd, WM_CHAR, VK_RETURN, 0);
  end else
  begin
    CharKey := Ord(Password[1]);
    Password := Copy(Password, 2, Length(Password)-1);
    SendMessage(Wnd, WM_CHAR, CharKey, 0);
    if Length(Password) = 0 then
      SendMessage(Wnd, WM_CHAR, VK_RETURN, 0);
  end;

  TimerLogin.Interval := 20;

  TimerLogin.Enabled := True;
end;

end.
