unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, MSHTML, RsRawInput, ChromeTabs, ChromeTabsGlassForm,
  Buttons, ActnList, StdCtrls, ExtCtrls, ComCtrls,
  Menus, StdActns, AppEvnts, rkSmartTabs, ToolWin, ConnectionForm,
  ChildForm, System.ImageList, System.Actions, System.Types;

type
  TFormPuttyMain = class(TChromeTabsGlassForm)
    ActionList: TActionList;
    acFileNewConnection: TAction;
    MainMenu: TMainMenu;
    acFileExit: TAction;
    Newconnection1: TMenuItem;
    Newconnection2: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    Help1: TMenuItem;
    acHelpAbout: TAction;
    About1: TMenuItem;
    acFileDisconnect: TAction;
    Disconnect1: TMenuItem;
    pmTab: TPopupMenu;
    Connection1: TMenuItem;
    Disconnect2: TMenuItem;
    acViewHideToolbar: TAction;
    View1: TMenuItem;
    acViewQuickConnection1: TMenuItem;
    acViewBottomTab: TAction;
    Bottomtab1: TMenuItem;
    acViewQuickConnection2: TMenuItem;
    Bottomtab2: TMenuItem;
    N4: TMenuItem;
    OpenDialog: TOpenDialog;
    acFileCloseAll: TAction;
    Window1: TMenuItem;
    Cascade1: TMenuItem;
    ileHorizontally1: TMenuItem;
    ileVertically1: TMenuItem;
    N2: TMenuItem;
    acViewSettings: TAction;
    PuTTY1: TMenuItem;
    PuTTY2: TMenuItem;
    ImageList: TImageList;
    acViewFullScreen: TAction;
    acWindowCascade: TWindowCascade;
    acWindowTileHorizontal: TWindowTileHorizontal;
    acWindowTileVertical: TWindowTileVertical;
    acWindowMinimizeAll: TWindowMinimizeAll;
    acWindowArrange: TWindowArrange;
    M1: TMenuItem;
    A1: TMenuItem;
    N5: TMenuItem;
    acWindowEntire: TAction;
    N6: TMenuItem;
    acWindowSmart: TAction;
    S1: TMenuItem;
    A2: TMenuItem;
    N7: TMenuItem;
    A3: TMenuItem;
    N8: TMenuItem;
    acFileDupConnection: TAction;
    D1: TMenuItem;
    D2: TMenuItem;
    acFileNewConsole: TAction;
    acFileNewCygwin: TAction;
    S2: TMenuItem;
    Cygwin1: TMenuItem;
    N3: TMenuItem;
    S4: TMenuItem;
    Cygwin2: TMenuItem;
    S5: TMenuItem;
    N10: TMenuItem;
    acViewPuttyMenu: TAction;
    N11: TMenuItem;
    E1: TMenuItem;
    E2: TMenuItem;
    acViewAlphaBlending: TAction;
    A4: TMenuItem;
    tbToolbar: TToolBar;
    tbFileNewConnection: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    X1: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    C1: TMenuItem;
    H1: TMenuItem;
    T1: TMenuItem;
    E3: TMenuItem;
    S6: TMenuItem;
    mnPopupNewConnection: TMenuItem;
    N15: TMenuItem;
    acViewHideMenu: TAction;
    M2: TMenuItem;
    M3: TMenuItem;
    pmNewConnections: TPopupMenu;
    miAlphaBlending: TMenuItem;
    N201: TMenuItem;
    N202: TMenuItem;
    N203: TMenuItem;
    N101: TMenuItem;
    ToolButton1: TToolButton;
    acFileNewMingw: TAction;
    acSettingsMingwPath: TAction;
    PuTTY4: TMenuItem;
    MinGW1: TMenuItem;
    MinGW2: TMenuItem;
    MinGW3: TMenuItem;
    acSettingsCheckPassword: TAction;
    S3: TMenuItem;
    P1: TMenuItem;
    VSplitter: TSplitter;
    acViewSyncKey: TAction;
    T2: TMenuItem;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    acViewHideTabSet: TAction;
    O1: TMenuItem;
    O2: TMenuItem;
    pnQuickConnect: TPanel;
    lbProtocol: TLabel;
    lbHost: TLabel;
    lbPort: TLabel;
    cbProtocol: TComboBox;
    edHost: TEdit;
    edPort: TEdit;
    btQuickConnect: TButton;
    ToolButton4: TToolButton;
    acPuTTYPath: TAction;
    PuTTY3: TMenuItem;
    procedure acFileNewConnectionExecute(Sender: TObject);
    procedure btQuickConnectClick(Sender: TObject);
    procedure cbProtocolChange(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure acViewHideToolbarExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acFileExitExecute(Sender: TObject);
    procedure acViewSettingsExecute(Sender: TObject);
    procedure acViewBottomTabExecute(Sender: TObject);
    procedure acFileDisconnectExecute(Sender: TObject);
    procedure acFileDisconnectUpdate(Sender: TObject);
    procedure acViewFullScreenExecute(Sender: TObject);
    procedure acWindowEntireUpdate(Sender: TObject);
    procedure acWindowEntireExecute(Sender: TObject);
    procedure acWindowSmartExecute(Sender: TObject);
    procedure acFileCloseAllExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acFileDupConnectionExecute(Sender: TObject);
    procedure acFileNewConsoleExecute(Sender: TObject);
    procedure acFileNewCygwinExecute(Sender: TObject);
    procedure acFileNewCygwinUpdate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acViewSettingsUpdate(Sender: TObject);
    procedure acViewPuttyMenuExecute(Sender: TObject);
//    procedure IceTabSetDblClick(Sender: TObject; ATab: TIceTab);
//    procedure IceTabSetTabClose(Sender: TObject; ATab: TIceTab);
//    procedure IceTabSetTabSelected(Sender: TObject; ATab: TIceTab;
//      ASelected: Boolean);
    procedure OnTabSetClick(Sender: TObject);
    procedure OnTabSetClose(Sender: TObject; Index: Integer; var Close: Boolean);
    procedure OnTabSetDblClick(Sender: TObject);
    procedure OnTabSetGetImageIdx(Sender: TObject; Tab: Integer; var Index: Integer);
    procedure OnTabSetAddClick(Sender: TObject);
    procedure OnButtonAddClick(Sender: TObject; var Handled: Boolean);
    procedure OnTabSetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OnTabSetKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
//    procedure IceTabSetNewButtonClick(Sender: TObject);
    procedure pmTabPopup(Sender: TObject);
    procedure acViewHideMenuExecute(Sender: TObject);
    procedure lbCloseQuickConnectClick(Sender: TObject);
    procedure miAlphaBlendingClick(Sender: TObject);
    procedure acFileNewMingwExecute(Sender: TObject);
    procedure acSettingsMingwPathExecute(Sender: TObject);
    procedure acSettingsCheckPasswordExecute(Sender: TObject);
    procedure acWindowCascadeExecute(Sender: TObject);
    procedure acWindowTileHorizontalExecute(Sender: TObject);
    procedure acWindowTileVerticalExecute(Sender: TObject);
    procedure acViewSyncKeyExecute(Sender: TObject);
    procedure acViewHideTabSetExecute(Sender: TObject);
    procedure acPuTTYPathExecute(Sender: TObject);
  private
    { Private declarations }
    TileTp: Integer;
    DragImage: TImageList;
    procedure RegisterHotkey;
    procedure WMNCRBUTTONUP(var msg: TMessage); message WM_NCRBUTTONDOWN;
  protected
    procedure WndProc(var Msg : TMessage); override;
    procedure NextTab;
    procedure PreviousTab;
  public
    { Public declarations }
    ConnectionForm: TFormConnection;
    TabSet: TrkSmartTabs;
    procedure ActivateTabWindow;
    function NewPuttyConnection(SessionName: String): Boolean;
    function GetPuTTYPath: String;
    procedure NewConnection(Protocol: Integer; IP, Port: String; SessionName: String=''; Id: String=''; Password: String=''); overload;
    procedure NewConnection(FileName, Args: String; Protocol: Integer); overload;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure OnActivateMDIChild(Form: TForm);
    procedure OnCloseMDIChild(Form: TForm);
    procedure OnPuttyConnectionMenuClick(Sender: TObject);
    procedure ClickMainForm;
    procedure ArrangeZOrder;
  end;

var
  FormPuttyMain: TFormPuttyMain;

implementation

uses RsCommon, AboutForm, ShellAPI, ClipBrd, Registry,
  MingwForm, PasswordForm, SyncKeyForm;

var
  FormPassword: TFormPassword;
//  LastInputTime: TDateTime;
{$R *.dfm}
{$R cursor.res}
{ TFormMain }

procedure TFormPuttyMain.acFileCloseAllExecute(Sender: TObject);
var
  i: Integer;
begin
  for i:=MDIChildCount-1 downto 0 do
    MDIChildren[i].Close;
end;

procedure TFormPuttyMain.acFileDisconnectExecute(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
    ActiveMDIChild.Close;
end;

procedure TFormPuttyMain.acFileDisconnectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := ActiveMDIChild <> nil;
end;

procedure TFormPuttyMain.acFileDupConnectionExecute(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
  begin
    with TFormChild(ActiveMDIChild) do
    begin
      if (Protocol in [PROTOCOL_CONSOLE, PROTOCOL_DKW]) then
        acFileNewConsole.Execute
      else if Protocol = PROTOCOL_CYGWIN then
        acFileNewCygwin.Execute
      else if Protocol = PROTOCOL_MINGW then
        acFileNewMingw.Execute
      else
        NewConnection(Protocol, IP, Port, SessionName, InfoId, InfoPassword);
    end;
  end;
end;

procedure TFormPuttyMain.acFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormPuttyMain.acFileNewConnectionExecute(Sender: TObject);
var
  i: Integer;
begin
  if ConnectionForm = nil then
    ConnectionForm := TFormConnection.Create(Self);

  if ConnectionForm.Visible then
    exit;

  ClickMainForm;
  Application.ProcessMessages;
  if ConnectionForm.ShowModal = mrOk then
  begin
    with ConnectionForm do
    begin
//      NewConnection(cbProtocol.ItemIndex, edHost.Text, edPort.Text, edName.Text, edUser.Text, edPassword.Text);
      ConnInfo.Name := tvConnection.Selected.Text;
      for i:=tvConnection.SelectionCount-1 downto 0 do
      begin
        ConnInfo.Name := tvConnection.Selections[i].Text;
        if LoadPuttyInfo(ConnInfo) then
          with ConnInfo do
            NewConnection(Protocol, Host, Port, Name, User, Password);
      end;
    end;
  end;
  pmNewConnections.Items.Clear;
  ConnectionForm.GetConnectionMenu(pmNewConnections.Items, OnPuttyConnectionMenuClick);
end;

procedure TFormPuttyMain.acFileNewConsoleExecute(Sender: TObject);
var
  DkwPath: String;
begin
  DkwPath := ExtractFilePath(Application.ExeName) + '\dkw.exe';
  if FileExists(DkwPath) then
    NewConnection(DkwPath, '', PROTOCOL_DKW)
  else
    NewConnection(GetEnvVar('ComSpec'), '-t:0a', PROTOCOL_CONSOLE);
end;

procedure TFormPuttyMain.acFileNewCygwinExecute(Sender: TObject);
var
  Reg: TRegistry;
  FileName: String;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  try
    if reg.OpenKey('\SOFTWARE\Cygwin\setup', false) then
    begin
      FileName := Reg.ReadString('rootdir') + '\bin\mintty.exe';
      reg.CloseKey;
    end;
  finally
      Reg.Free;
  end;

  NewConnection(FileName, '-i /Cygwin-Terminal.ico -', PROTOCOL_CYGWIN);
end;

procedure TFormPuttyMain.acFileNewCygwinUpdate(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  try
    TAction(Sender).Enabled := reg.OpenKey('\SOFTWARE\Cygwin\setup', false);
    if TAction(Sender).Enabled then
      reg.CloseKey;
  finally
      Reg.Free;
  end;
end;

procedure TFormPuttyMain.acFileNewMingwExecute(Sender: TObject);
var
  Reg: TRegistry;
  FileName: String;
  Args: String;
begin
  Reg := TRegistry.Create;

  try
    reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(PUTTY_KEY_SESSIONS, False) then
    begin
      if not FileExists(Reg.ReadString('rxvt')) then
      begin
        if not acSettingsMingwPath.Execute then
          exit;
      end;
    end else if not acSettingsMingwPath.Execute then
      exit;

    if Reg.OpenKey(PUTTY_KEY_SESSIONS, False) then
    begin
      FileName := Reg.ReadString('rxvt');
      Args := Reg.ReadString('rxvtArgs');
    end;
  finally
      Reg.Free;
  end;

  NewConnection(FileName, '-backspacekey  -sl 2500 -fg White -bg Black -sr -fn Courier-12 -tn msys -e /bin/sh --login -i', PROTOCOL_MINGW);
end;

procedure TFormPuttyMain.acHelpAboutExecute(Sender: TObject);
begin
  TFormAbout.Create(Self).ShowModal;
end;

procedure TFormPuttyMain.acPuTTYPathExecute(Sender: TObject);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;

  try
    if reg.OpenKey(PUTTY_KEY_SESSIONS, True) then
    begin
      OpenDialog.FileName := Reg.ReadString('putty');

      if OpenDialog.Execute then
      begin
        if not FileExists(OpenDialog.FileName) then
        begin
          ShowMessage('PuTTY 찾기를 실패했습니다');
          exit;
        end;
        Reg.WriteString('putty', OpenDialog.FileName);
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TFormPuttyMain.ActivateTabWindow;
begin
  if ActiveMDIChild <> nil then
    SetWindowPos(TFormChild(ActiveMDIChild).Wnd, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TFormPuttyMain.acViewBottomTabExecute(Sender: TObject);
begin
  if TabSet.Align = alTop then
  begin
    TabSet.Align := alBottom;
  end else
  begin
    TabSet.Align := alTop;
  end;
  acViewBottomTab.Checked := TabSet.Align = alBottom;
end;

procedure TFormPuttyMain.acViewFullScreenExecute(Sender: TObject);
begin
  if acViewFullScreen.Checked then
  begin
    acViewFullScreen.Checked := False;
    if not acViewHideMenu.Checked then
      Menu := MainMenu;
    BorderStyle := bsSizeable;
    WindowState := wsNormal;
//    ShowWindow(Application.Handle, SW_SHOW);
  end else
  begin
//    WindowState := wsNormal;
    acViewFullScreen.Checked := True;
    Menu := nil;
    BorderStyle := bsNone;
    with Screen.MonitorFromWindow(Handle).WorkareaRect do
      SetBounds(Left, Top, Right-Left, Bottom-Top);
    SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure TFormPuttyMain.acViewHideMenuExecute(Sender: TObject);
begin
  if acViewHideMenu.Checked then
    Menu := nil
  else
    Menu := MainMenu;
end;

procedure TFormPuttyMain.acViewHideTabSetExecute(Sender: TObject);
begin
  TabSet.Visible := not acViewHideTabSet.Checked;
end;

procedure TFormPuttyMain.acSettingsCheckPasswordExecute(Sender: TObject);
var
  FormPassword: TFormPassword;
begin
  if acSettingsCheckPassword.Checked then
  begin
    FormPassword := TFormPassword.Create(Self);

    try
      if FormPassword.ShowModal <> mrOk then
        exit;
    finally
      FormPassword.Free;
    end;
  end;

  acSettingsCheckPassword.Checked := not acSettingsCheckPassword.Checked;
end;

procedure TFormPuttyMain.acSettingsMingwPathExecute(Sender: TObject);
var
  Form: TFormMingw;
begin
  Form := TFormMingw.Create(Self);
  try
    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

procedure TFormPuttyMain.acViewPuttyMenuExecute(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
  begin
    with TFormChild(ActiveMDIChild) do
    begin
      PostMessage(Wnd, WM_RBUTTONDOWN, MK_CONTROL, 0);
      PostMessage(Wnd, WM_RBUTTONUP, MK_CONTROL, 0);
    end;
  end;
end;

procedure TFormPuttyMain.acViewHideToolbarExecute(Sender: TObject);
begin
  tbToolbar.Visible := not acViewHideToolbar.Checked;
  pnQuickConnect.Visible := False;
end;

procedure TFormPuttyMain.acViewSettingsExecute(Sender: TObject);
const
   IDM_RECONF = $0050;
var
  i: Integer;
  PuttyHandle: THandle;
begin
  if ActiveMDIChild <> nil then
  begin
    ShowWindow(TFormChild(ActiveMDIChild).Wnd, SW_SHOW);

    with TFormChild(ActiveMDIChild) do
    begin
      PostMessage(Wnd, WM_SYSCOMMAND, IDM_RECONF, 0);
      for i:=0 to 10 do
      begin
        Sleep(1);
        PuttyHandle := Windows.FindWindow('puttyconfigbox', nil);
        if PuttyHandle > 0  then
        begin
          SetForegroundWindow(PuttyHandle);
          break;
        end;
      end;
    end;
  end;
end;

procedure TFormPuttyMain.acViewSettingsUpdate(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
  begin
     TAction(Sender).Enabled :=
         not ((TFormChild(ActiveMDIChild).Protocol = PROTOCOL_CYGWIN) or
              (TFormChild(ActiveMDIChild).Protocol in [PROTOCOL_CONSOLE, PROTOCOL_DKW]) or
              (TFormChild(ActiveMDIChild).Protocol = PROTOCOL_MINGW))
  end else
    TAction(Sender).Enabled := False;
end;

procedure TFormPuttyMain.acViewSyncKeyExecute(Sender: TObject);
var
  Form: TFormSyncKey;
  i: Integer;
begin
  Form := TFormSyncKey.Create(Self);
  try
    Form.cklList.Clear;
    for i:=0 to MDIChildCount-1 do
    begin
      if  (TFormChild(MDIChildren[i]).Protocol in [PROTOCOL_CONSOLE, PROTOCOL_DKW]) then
        continue;

      Form.cklList.AddItem(MDIChildren[i].Caption, MDIChildren[i]);
      Form.cklList.Checked[Form.cklList.Count-1] := True;
    end;
    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

procedure TFormPuttyMain.acWindowCascadeExecute(Sender: TObject);
begin
  ArrangeZOrder;
  Cascade;
end;

procedure TFormPuttyMain.acWindowEntireExecute(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
    with ActiveMDIChild do
    begin
      WindowState := wsNormal;
      Left := 0;
      Top := 0;
      Width := Self.Width - GetSystemMetrics(SM_CXFRAME);
      Height := VSplitter.Height - GetSystemMetrics(SM_CYFRAME);
    end;
end;

procedure TFormPuttyMain.acWindowEntireUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := ActiveMDIChild <> nil;
end;

procedure TFormPuttyMain.acWindowSmartExecute(Sender: TObject);
var
  i: Integer;
  BackWidth, BackHeight: Integer;
begin
  ArrangeZOrder;
  if (ActiveMDIChild <> nil) and (MDIChildCount = 3) then
  begin
    ActiveMDIChild.WindowState := wsNormal;
    Inc(TileTp);
    if TileTp > 3 then
      TileTp := 0;
    BackWidth := Self.Width - GetSystemMetrics(SM_CXFRAME) -
                 (Self.Width - GetSystemMetrics(SM_CXFRAME)) Mod 2;
    BackHeight := VSplitter.Height - GetSystemMetrics(SM_CYFRAME) -
                 (VSplitter.Height - GetSystemMetrics(SM_CYFRAME)) Mod 2;
    case TileTp of
    0:begin
        MDIChildren[2].Width  := BackWidth;
        MDIChildren[2].Height := BackHeight div 2;
        MDIChildren[2].Left   := 0;
        MDIChildren[2].Top    := 0;
        MDIChildren[1].Width  := BackWidth div 2;
        MDIChildren[1].Height := BackHeight div 2;
        MDIChildren[1].Left   := 0;
        MDIChildren[1].Top    := BackHeight div 2;
        MDIChildren[0].Width  := BackWidth div 2;
        MDIChildren[0].Height := BackHeight div 2;
        MDIChildren[0].Left   := BackWidth div 2;
        MDIChildren[0].Top    := BackHeight div 2;
      end;
    1:begin
        MDIChildren[2].Width  := BackWidth div 2;
        MDIChildren[2].Height := BackHeight;
        MDIChildren[2].Left   := 0;
        MDIChildren[2].Top    := 0;
        MDIChildren[1].Width  := BackWidth div 2;
        MDIChildren[1].Height := BackHeight div 2;
        MDIChildren[1].Left   := BackWidth div 2;
        MDIChildren[1].Top    := 0;
        MDIChildren[0].Width  := BackWidth div 2;
        MDIChildren[0].Height := BackHeight div 2;
        MDIChildren[0].Left   := BackWidth div 2;
        MDIChildren[0].Top    := BackHeight div 2;
      end;
    2:begin
        MDIChildren[2].Width  := BackWidth div 2;
        MDIChildren[2].Height := BackHeight div 2;
        MDIChildren[2].Left   := 0;
        MDIChildren[2].Top    := 0;
        MDIChildren[1].Width  := BackWidth div 2;
        MDIChildren[1].Height := BackHeight div 2;
        MDIChildren[1].Left   := BackWidth div 2;
        MDIChildren[1].Top    := 0;
        MDIChildren[0].Width  := BackWidth;
        MDIChildren[0].Height := BackHeight div 2;
        MDIChildren[0].Left   := 0;
        MDIChildren[0].Top    := BackHeight div 2;
      end;
    3:begin
        MDIChildren[2].Width  := BackWidth div 2;
        MDIChildren[2].Height := BackHeight div 2;
        MDIChildren[2].Left   := 0;
        MDIChildren[2].Top    := 0;
        MDIChildren[1].Width  := BackWidth div 2;
        MDIChildren[1].Height := BackHeight div 2;
        MDIChildren[1].Left   := 0;
        MDIChildren[1].Top    := BackHeight div 2;
        MDIChildren[0].Width  := BackWidth div 2;
        MDIChildren[0].Height := BackHeight;
        MDIChildren[0].Left   := BackWidth div 2;
        MDIChildren[0].Top    := 0;
      end;
    end;

    for i:=0 to MDIChildCount - 1 do
    begin

    end;
  end else
  begin
    if TileMode = tbHorizontal then
      TileMode := tbVertical
    else
      TileMode := tbHorizontal;
    Tile;
  end;
end;

procedure TFormPuttyMain.acWindowTileHorizontalExecute(Sender: TObject);
begin
  ArrangeZOrder;
  TileMode := tbHorizontal;
  Tile;
end;

procedure TFormPuttyMain.acWindowTileVerticalExecute(Sender: TObject);
begin
  ArrangeZOrder;
  TileMode := tbVertical;
  Tile;
end;

procedure TFormPuttyMain.ArrangeZOrder;
var
  i: Integer;
begin
  for i:=TabSet.Tabs.Count-1 downto 0 do
  begin
    TFormChild(TabSet.Tabs.Objects[i]).BringToFront;
  end;
end;

procedure TFormPuttyMain.btQuickConnectClick(Sender: TObject);
begin
  if Trim(edHost.Text) = '' then
    exit;

  if Trim(cbProtocol.Text) = '' then
  begin
    ShowMessage('프로토콜이 선택되지 않았습니다');
    if cbProtocol.CanFocus then cbProtocol.SetFocus;
    exit;
  end;

  if (cbProtocol.ItemIndex <> PROTOCOL_SERIAL) and not IsInteger(edPort.Text) then
  begin
    ShowMessage('포트가 입력되지 않았습니다');
    if edPort.CanFocus then edPort.SetFocus;
    exit;
  end;

  if Trim(edPort.Text) = '' then
    edPort.Text := '22';

  Application.ProcessMessages;
  NewConnection(cbProtocol.ItemIndex, edHost.Text, edPort.Text);
end;

procedure TFormPuttyMain.cbProtocolChange(Sender: TObject);
begin
  if cbProtocol.ItemIndex = 3 then
  begin
    lbHost.Caption := '통신포트';
    edHost.Text := 'COM1';
    lbPort.Visible := False;
    edPort.Visible := False;
  end else
  begin
    if cbProtocol.ItemIndex = 0 then
      edPort.Text := '22'
    else if cbProtocol.ItemIndex = 1 then
      edPort.Text := '23'
    else
      edPort.Clear;
    lbHost.Caption := '접속주소';
    lbPort.Caption := '포트';
    lbPort.Visible := True;
    edPort.Visible := True;
  end;
end;

procedure TFormPuttyMain.ClickMainForm;
var
  Pt: TPoint;
  BefPt: TPoint;
begin
  ShowCursor(False);

  try
    BefPt := Mouse.CursorPos;
    if TabSet.Visible then
    begin
      Pt := TabSet.ClientToScreen(Point(0, 0));

      SetCursorPos(Pt.X, Pt.Y);

      if WindowFromPoint(Pt) = TabSet.Handle then
      begin
        Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
        Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
      end;
    end else
    begin
      Pt := ClientToScreen(Point(30, -5));

      SetCursorPos(Pt.X, Pt.Y);

      if WindowFromPoint(Pt) = Handle then
      begin
        Mouse_Event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
        Mouse_Event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
      end;
    end;
    SetCursorPos(BefPt.X, BefPt.Y);
  finally
    ShowCursor(True);
  end;
end;

procedure TFormPuttyMain.NewConnection(Protocol: Integer; IP, Port, SessionName, Id, Password: String);
const
  IDM_FULLSCREEN = $0180;
var
  suInfo: STARTUPINFO;
  procInfo: PROCESS_INFORMATION;
  sa: SECURITY_ATTRIBUTES;
  Wnd: HWND;
  ret: LongBool;
  FileName: String;
  NewStyle: Integer;
begin
  if acSettingsCheckPassword.Checked and (Password <> '') then
  begin
    FormPassword := TFormPassword.Create(Self);

    try
      if FormPassword.ShowModal <> mrOk then
        exit;
    finally
      FormPassword.Free;
    end;
  end;

  ZeroMemory(@suInfo, sizeof(suInfo));
  ZeroMemory(@sa, sizeof(sa));
  suInfo.dwX := 0;
  suInfo.dwY := 0;
  suInfo.cb := sizeof(suInfo);
  suInfo.wShowWindow := SW_HIDE;
  suInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USEPOSITION;
  sa.nLength := sizeof(sa);
  FileName := ExtractFilePath(Application.ExeName) + '\PuTTY.exe';
  if not FileExists(FileName) then
    Filename := GetPuTTYPath;

  if Trim(SessionName) <> '' then
  begin
    FileName := '"' + FileName + '" -load "' + SessionName + '"';
    if Trim(Id) <> '' then
      FileName := FileName + ' -l  "' + Id + '"';
    if (Protocol = PROTOCOL_SSH) and (Password <> '') then
      FileName := FileName + ' -pw  "' + Password + '"';
  end else begin
    FileName := '"' + FileName + '" -' + GetProtocolStr(Protocol);

    if Protocol = PROTOCOL_SERIAL then
      FileName := FileName + ' ' + edHost.Text
    else if Port = '' then
      FileName := FileName + ' ' + IP
    else
      FileName := FileName + ' -P ' + Port + ' ' + IP;
  end;

  ret := CreateProcess(nil,
    PChar(FileName),
    @sa,
    nil,
    False,
    NORMAL_PRIORITY_CLASS,
    nil,
    nil,
    suInfo,
    procInfo);

  if not ret then
  begin
    ShowMessage('PuTTY 실행을 실패했습니다: ' + FileName);
    exit;
  end;

  if WaitForInputIdle(procInfo.hProcess, 10000) <> 0 then
  begin
    ShowMessage('대기시간이 초과되었습니다');
    CloseHandle(procInfo.hProcess);
    CloseHandle(procInfo.hThread);
    exit;
  end;

  Wnd := GetWindowFromProcessID(procInfo.dwProcessId);
  Application.CreateForm(TFormChild, FormChild);

  if Trim(SessionName) <> '' then
  begin
    if FormChild.Caption <> Ip then
      FormChild.Caption := SessionName + '@' + Ip + ':' + Port
    else
      FormChild.Caption := SessionName;
  end else
    FormChild.Caption := Ip;

  FormChild.SessionName := SessionName;
  FormChild.Wnd := Wnd;

  FormChild.InfoId := Id;
  FormChild.InfoPassword := Password;

  if protocol = PROTOCOL_TELNET then
  begin
    FormChild.Id := Id;
    FormChild.Password := Password;
  end;

  FormChild.Ip := Ip;
  FormChild.Port := Port;
  FormChild.Protocol := Protocol;
  FormChild.ProcessId := procInfo.dwProcessId;
  Windows.SetParent(Wnd, FormChild.Handle);
  NewStyle := GetWindowLong(Wnd, GWL_EXSTYLE) or WS_EX_TOPMOST;
  SetWindowLong(Wnd, GWL_EXSTYLE, NewStyle);
  ShowWindow(Wnd, SW_SHOW);
  ResumeThread(procInfo.hProcess);
  FormChild.CreateTermThread(procInfo.hProcess);
  FormChild.hProcess := procInfo.hProcess;
  SendMessage(Wnd, WM_SYSCOMMAND, IDM_FULLSCREEN, 0);
  FormChild.FormResize(FormChild);
  FormChild.Show;

  ImageList.GetIcon(0, FormChild.Icon);
  TabSet.AddObject(FormChild.Caption, FormChild);
  FormChild.Tag := 0;

  if MDIChildCount = 1 then
    FormChild.WindowState := wsMaximized;
end;

procedure TFormPuttyMain.NewConnection(FileName, Args: String; Protocol: Integer);
var
  suInfo: STARTUPINFO;
  procInfo: PROCESS_INFORMATION;
  sa: SECURITY_ATTRIBUTES;
  Wnd: HWND;
  ret: LongBool;
  NewStyle: Integer;
  CommandLine: String;
  i: Integer;
begin
  ZeroMemory(@suInfo, sizeof(suInfo));
  ZeroMemory(@sa, sizeof(sa));
  suInfo.dwX := 0;
  suInfo.dwY := 0;
  suInfo.cb := sizeof(suInfo);
  suInfo.wShowWindow := SW_HIDE;
  suInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_USEPOSITION;
  sa.nLength := sizeof(sa);

  if not FileExists(FileName) then
  begin
    ShowMessage(FileName + ' 파일이 존재하지 않습니다');
    exit;
  end;

  CommandLine := FileName + ' ' + Args;

  ret := CreateProcess(nil,
    PChar(CommandLine),
    @sa,
    nil,
    True,
    NORMAL_PRIORITY_CLASS,
    nil,
    nil,
    suInfo,
    procInfo);

  if not ret then
  begin
    ShowMessage('실행 요청을 실패했습니다: ' + FileName);
    exit;
  end;

  if (Protocol in [PROTOCOL_TELNET, PROTOCOL_SSH, PROTOCOL_RAW, PROTOCOL_SERIAL, PROTOCOL_CYGWIN, PROTOCOL_DKW])
      and (WaitForInputIdle(procInfo.hProcess, 10000) <> 0) then
  begin
    ShowMessage('대기시간이 초과되었습니다');
    CloseHandle(procInfo.hProcess);
    CloseHandle(procInfo.hThread);
    exit;
  end;

  for i:=0 to 500 do
  begin
    Wnd := GetWindowFromProcessID(procInfo.dwProcessId);
    if Wnd > 0 then
    begin
      if (Protocol = PROTOCOL_MINGW) then
      begin
        if (Copy(LowerCase(GetWindowClass(Wnd)), 1, 4) = 'rxvt') then
          break;
      end else
        break;
    end;
    Application.ProcessMessages;
    Sleep(10);
  end;

  if Wnd = 0 then
  begin
    ShowMessage('실행 요청을 실패했습니다: ' + FileName);
    CloseHandle(procInfo.hProcess);
    CloseHandle(procInfo.hThread);
    exit;
  end;

  Wnd := GetWindowFromProcessID(procInfo.dwProcessId);
  Application.CreateForm(TFormChild, FormChild);
  FormChild.SessionName := ExtractFileName(FileName);
  FormChild.Wnd := Wnd;
  FormChild.ProcessId := procInfo.dwProcessId;

  Windows.SetParent(Wnd, FormChild.Handle);

  FormChild.Protocol := Protocol;
  if Protocol in [PROTOCOL_CONSOLE, PROTOCOL_DKW] then
  begin
    FormChild.Caption := '명령 프롬프트';
    if Protocol = PROTOCOL_DKW then
    begin
      NewStyle := (GetWindowLong(Wnd, GWL_STYLE) or WS_MAXIMIZE) and
              not (WS_THICKFRAME or WS_CAPTION or WS_VSCROLL);
      SetWindowLong(Wnd, GWL_STYLE, NewStyle);
    end;
  end else if Protocol = PROTOCOL_CYGWIN then
  begin
    FormChild.Caption := 'Cygwin 터미널';
    NewStyle := (GetWindowLong(Wnd, GWL_STYLE) or WS_MAXIMIZE) and
            not (WS_THICKFRAME or WS_CAPTION or WS_VSCROLL);
    SetWindowLong(Wnd, GWL_STYLE, NewStyle);
  end else if Protocol = PROTOCOL_MINGW then
  begin
    FormChild.Caption := 'MinGW 터미널';
    NewStyle := (GetWindowLong(Wnd, GWL_STYLE) or WS_MAXIMIZE) and
            not (WS_THICKFRAME or WS_CAPTION or WS_VSCROLL);
    SetWindowLong(Wnd, GWL_STYLE, NewStyle);
  end;
  ShowWindow(Wnd, SW_SHOW);

  FormChild.CreateTermThread(procInfo.hProcess);
  FormChild.hProcess := procInfo.hProcess;

  if MDIChildCount = 1 then
    FormChild.WindowState := wsMaximized;
  FormChild.Show;
  FormChild.FormResize(FormChild);

  TabSet.AddObject(FormChild.Caption, FormChild);
  if Protocol in [PROTOCOL_CONSOLE, PROTOCOL_DKW] then
  begin
    FormChild.Tag := 8;
    ImageList.GetIcon(8, FormChild.Icon);
  end else if Protocol = PROTOCOL_CYGWIN then
  begin
    FormChild.Tag := 9;
    ImageList.GetIcon(9, FormChild.Icon);
  end else if Protocol = PROTOCOL_MINGW then
  begin
    FormChild.Tag := 11;
    ImageList.GetIcon(11, FormChild.Icon);
  end
end;

function TFormPuttyMain.NewPuttyConnection(SessionName: String): Boolean;
var
  ConnInfo: TConnInfo;
begin
  ConnInfo.Name := SessionName;
  ConnInfo.Font := nil;
  LoadPuttyInfo(ConnInfo);
  if not LoadPuttyInfo(ConnInfo) then
  begin
    ShowMessage(ConnInfo.Name + ' 세션이 PuTTY 설정에 없습니다');
    acFileNewConnection.Execute;
    Result := False;
    exit;
  end;
  NewConnection(ConnInfo.Protocol, ConnInfo.Host, ConnInfo.Port, ConnInfo.Name,
      ConnInfo.User, ConnInfo.Password);
  Result := True;
end;

procedure TFormPuttyMain.NextTab;
begin
  if TabSet.ActiveTab + 1 >= TabSet.Tabs.Count then
    TabSet.ActiveTab := 0
  else
    TabSet.ActiveTab := TabSet.ActiveTab + 1;
  TabSet.OnClick(TabSet);
end;

procedure TFormPuttyMain.OnActivateMDIChild(Form: TForm);
var
  Index: Integer;
begin
  Index := TabSet.Tabs.IndexOfObject(Form);
  if (Index < TabSet.Tabs.Count) and (Index >= 0) then
  begin
    TabSet.ActiveTab := Index;
  end;
end;

procedure TFormPuttyMain.OnButtonAddClick(Sender: TObject;
  var Handled: Boolean);
begin
  acFileNewConnection.Execute;
end;

procedure TFormPuttyMain.OnCloseMDIChild(Form: TForm);
var
  Index: Integer;
begin
  Index := TabSet.Tabs.IndexOfObject(Form);

  if (Index >= 0) and (Index < TabSet.Tabs.Count) then
    TabSet.DeleteTab(Index);
end;

procedure TFormPuttyMain.OnPuttyConnectionMenuClick(Sender: TObject);
begin
  NewPuttyConnection(TMenuItem(Sender).Caption);
end;

procedure TFormPuttyMain.OnTabSetAddClick(Sender: TObject);
begin
  acFileNewConnection.Execute;
end;

procedure TFormPuttyMain.OnTabSetClick(Sender: TObject);
begin
  if (TabSet.ActiveTab < TabSet.Tabs.Count) and (TabSet.ActiveTab >= 0) then
    TFormChild(TabSet.Tabs.Objects[TabSet.ActiveTab]).Show;
end;

procedure TFormPuttyMain.OnTabSetClose(Sender: TObject; Index: Integer; var Close: Boolean);
begin
  Close := False;

  if (Index >= 0) and (Index < TabSet.Tabs.Count) then
    TForm(TabSet.Tabs.Objects[Index]).Close;
end;

procedure TFormPuttyMain.OnTabSetDblClick(Sender: TObject);
begin
  acViewFullScreen.Execute;
end;

procedure TFormPuttyMain.OnTabSetGetImageIdx(Sender: TObject; Tab: Integer; var Index: Integer);
begin
  Index := TForm(TabSet.Tabs.Objects[Tab]).Tag;
end;

procedure TFormPuttyMain.OnTabSetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift <> [ssAlt] then
    ActivateTabWindow;
end;

procedure TFormPuttyMain.OnTabSetKeyPress(Sender: TObject; var Key: Char);
begin
  if ActiveMDIChild <> nil then
    SendMessage(ActiveMDIChild.Handle, WM_CHAR, Ord(Key), 0);
end;

procedure TFormPuttyMain.pmTabPopup(Sender: TObject);
begin
  mnPopupNewConnection.Clear;
  if ConnectionForm = nil then
  begin
    acFileNewConnection.Execute;
    exit
  end;
  ConnectionForm.GetConnectionMenu(mnPopupNewConnection, OnPuttyConnectionMenuClick);
end;

procedure TFormPuttyMain.PreviousTab;
begin
  if TabSet.ActiveTab - 1 < 0 then
    TabSet.ActiveTab := TabSet.Tabs.Count - 1
  else
    TabSet.ActiveTab := TabSet.ActiveTab - 1;
  TabSet.OnClick(TabSet);
end;

procedure TFormPuttyMain.RegisterHotkey;
var
  Rid: array [0..0] of RAWINPUTDEVICE;
begin
  Rid[0].usUsagePage := $01;
  Rid[0].usUsage := $06;
  Rid[0].dwFlags := RIDEV_INPUTSINK;
  Rid[0].hwndTarget := Application.MainFormHandle;

  if RegisterRawInputDevices(@Rid, 1, sizeof(RAWINPUTDEVICE)) = FALSE then
  begin
    ShowMessage('Cannot register raw input devices: ' + IntToStr(GetLastError()));
    exit;
  end;
end;

procedure TFormPuttyMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveSettings;
  acFileCloseAll.Execute;
end;

procedure TFormPuttyMain.FormCreate(Sender: TObject);
begin
  DragImage := TImageList.Create(Self);

  TabSet := TrkSmartTabs.Create(Self);
  TabSet.Transparent := True;
  TabSet.ColorTabActive := clBtnFace;
  TabSet.ColorTabInActive := clBtnShadow;
  TabSet.ShowImages := True;
  TabSet.AllowTabDrag := True;
  TabSet.GdiPlusText := False;
  TabSet.PopupMenu := pmTab;
  TabSet.OnClick := OnTabSetClick;
  TabSet.OnCloseTab := OnTabSetClose;
  TabSet.OnAddClick := OnTabSetAddClick;
  TabSet.OnGetImageIndex := OnTabSetGetImageIdx;
  TabSet.OnKeyDown := OnTabSetKeyDown;
  TabSet.OnKeyPress := OnTabSetKeyPress;
  TabSet.TabStop := False;
  TabSet.Images := ImageList;
  TabSet.SendToBack;
end;

procedure TFormPuttyMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(TabSet);
  FreeAndNil(ConnectionForm);
  FreeAndNil(DragImage);
end;

procedure TFormPuttyMain.FormShow(Sender: TObject);
begin
  LoadSettings;
  cbProtocol.ItemIndex := 0;
  RegisterHotkey;
  TileTp := -1;

  if ParamCount > 0 then
    NewPuttyConnection(ParamStr(1))
  else
    acFileNewConnection.Execute;
end;

function TFormPuttyMain.GetPuTTYPath: String;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;

    try
      if reg.OpenKey(PUTTY_KEY_SESSIONS, True) then
      begin
        Result := Reg.ReadString('putty');
        while True do
        begin
          if Trim(Result) = '' then
          begin
            if OpenDialog.Execute then
              Result := OpenDialog.FileName
            else exit;
          end;

          if not FileExists(Result) then
          begin
            ShowMessage('PuTTY 찾기를 실패했습니다');
            Result := '';
            continue;
          end;
          Reg.WriteString('putty', Result);
          Reg.CloseKey;
          break;
        end;
      end;
    finally
        Reg.Free;
    end;
end;

procedure TFormPuttyMain.lbCloseQuickConnectClick(Sender: TObject);
begin
  pnQuickConnect.Visible := False;
end;

procedure TFormPuttyMain.LoadSettings;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;

  try
    if reg.OpenKey(PUTTY_KEY_SESSIONS, True) then
    begin
      try
        Width := Reg.ReadInteger('Width');
        Height := Reg.ReadInteger('Height');
        Left := Reg.ReadInteger('Left');
        Top  := Reg.ReadInteger('Top');

        if Left < 0 then
          Left := 0;
        if Top < 0 then
          Top := 0;

        if Reg.ReadBool('HideMenu') then
          acViewHideMenu.Execute;

        if Reg.ReadBool('HideToolbar') then
          acViewHideToolbar.Execute;

        if Reg.ReadBool('HideTabSet') then
          acViewHideTabSet.Execute;

        acSettingsCheckPassword.Checked := Reg.ReadBool('CheckPassword');

        if Reg.ReadBool('BottomTab') then
        begin
          TabSet.Align := alBottom;
          acViewBottomTab.Checked := True;
        end else
        begin
          TabSet.Align := alTop;
          acViewBottomTab.Checked := False;
        end;
      except
        TabSet.Align := alTop;
      end;

      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
  tbToolbar.Top := 0;
end;

procedure TFormPuttyMain.miAlphaBlendingClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  AlphaBlendValue := Trunc(256*(100-TMenuItem(Sender).Tag)/100);
  AlphaBlend := AlphaBlendValue > 0;
end;

procedure TFormPuttyMain.SaveSettings;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;

  try
    if reg.OpenKey(PUTTY_KEY_SESSIONS, True) then
    begin
      if Self.WindowState <> wsMaximized then
      begin
        Reg.WriteInteger('Width', Width);
        Reg.WriteInteger('Height', Height);
        Reg.WriteInteger('Top', Top);
        Reg.WriteInteger('Left', Left);
      end;

      Reg.WriteBool('HideMenu', acViewHideMenu.Checked);
      Reg.WriteBool('HideToolbar', acViewHideToolbar.Checked);
      Reg.WriteBool('HideTabSet', acViewHideTabSet.Checked);
      Reg.WriteBool('BottomTab', TabSet.Align = alBottom);
      Reg.WriteBool('CheckPassword', acSettingsCheckPassword.Checked);

      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;

procedure TFormPuttyMain.WMNCRBUTTONUP(var msg: TMessage);
begin
  if (msg.WParam = HTCAPTION) or (msg.WParam = HTMENU) then
  begin
    pmTab.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    exit;
  end;
  inherited;
end;

procedure TFormPuttyMain.WndProc(var Msg: TMessage);
var
  i: Integer;
  Found: Boolean;
  ProcessId: DWORD;
  function GetFocusedHandle: THandle;
  var
    info: TGUITHREADINFO;
  begin
    info.cbSize := sizeof(info);
    if not GetGUIThreadInfo(0, info) then
      Result := 0
    else
      Result := info.hwndFocus;
  end;
begin
  if (Msg.Msg = WM_INPUT) and (Msg.WParam = RIM_INPUTSINK) then
  begin
    if FormPassword <> nil then
      exit;

    GetWindowThreadProcessId(GetFocusedHandle, ProcessId);

    Found := False;
    for i:=MDIChildCount-1 downto 0 do
    begin
      if (TFormChild(MDIChildren[i]).ProcessId = ProcessId) then
      begin
        Found := True;
        break;
      end;
    end;

    if Found then
    begin
      Application.ProcessMessages;

      if ((GetAsyncKeyState(VK_CONTROL) and $8001) > 0) then
      begin
        if ((GetAsyncKeyState(VK_TAB) and $8000) > 0) then
        begin
          if ((GetAsyncKeyState(VK_SHIFT) and $8001) > 0) then
            PreviousTab
          else NextTab;

          ClickMainForm;

          ActivateTabWindow;
          exit;
        end else
        if ((GetAsyncKeyState(VK_SPACE) and $8000) > 0) then
          acViewPuttyMenu.Execute
        else if ((GetAsyncKeyState(VK_SHIFT) and $8001) > 0) then
        begin
          if ((GetAsyncKeyState(Ord('N')) and $8000) > 0) then
            acFileNewConnection.Execute
          else if ((GetAsyncKeyState(VK_BACK) and $8000) > 0) then
          begin
            if ActiveMDIChild <> nil then
              TFormChild(ActiveMDIChild).ShowConnectionInfo;
          end;
        end;
      end else
      if ((GetAsyncKeyState(VK_MENU) and $8001) > 0) and
         ((GetAsyncKeyState(VK_SPACE) and $8000) > 0) then
      begin
          acViewSettings.Execute;
      end else if ((GetAsyncKeyState(VK_MENU) and $8001) > 0) and
                  ((GetAsyncKeyState(VK_LBUTTON) and $8000) = 0) then
        ClickMainForm;
    end;
    Msg.Result := 0;
    exit;
  end;

  inherited WndProc(Msg);
end;

end.
