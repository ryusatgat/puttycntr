unit ConnectionForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ImgList, Buttons, Menus, ActnList,
  RsCommon, System.Actions, System.ImageList;

type
  TFormConnection = class(TForm)
    pgInfo: TPageControl;
    tsConnection: TTabSheet;
    Label1: TLabel;
    lbHost: TLabel;
    lbPort: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel2: TBevel;
    Label7: TLabel;
    edHost: TEdit;
    cbProtocol: TComboBox;
    edPort: TEdit;
    edUser: TEdit;
    edPassword: TEdit;
    btNew: TButton;
    btDelete: TButton;
    edName: TEdit;
    btCopy: TButton;
    btNewFolder: TButton;
    tsOption: TTabSheet;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    cbColor: TComboBox;
    Label9: TLabel;
    edR: TEdit;
    edG: TEdit;
    edB: TEdit;
    btColor: TButton;
    spColor: TShape;
    tsEtc: TTabSheet;
    btLoadPutty: TButton;
    btLoadDefault: TButton;
    btSaveDefault: TButton;
    btExportPuttySettings: TButton;
    GroupBox2: TGroupBox;
    btFont: TButton;
    pnFont: TPanel;
    Label3: TLabel;
    edScrollbackLines: TEdit;
    ImageList: TImageList;
    pmMenu: TPopupMenu;
    mnNewSession: TMenuItem;
    mnNewFolder: TMenuItem;
    N3: TMenuItem;
    mnCopy: TMenuItem;
    mnDelete: TMenuItem;
    alConnect: TActionList;
    acNewSession: TAction;
    acNewFolder: TAction;
    acCopy: TAction;
    acDelete: TAction;
    dlgColor: TColorDialog;
    dlgExportPuttySettings: TSaveDialog;
    dlgFont: TFontDialog;
    Label2: TLabel;
    sbUp: TSpeedButton;
    sbDown: TSpeedButton;
    tvConnection: TTreeView;
    edSearch: TEdit;
    btClose: TButton;
    btSave: TButton;
    chbNewWindow: TCheckBox;
    btConnect: TButton;
    procedure cbProtocolChange(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btNewClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadConnections;
    procedure SaveConnections;
    procedure ApplyConnection;
    procedure tvConnectionDblClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure tvConnectionChange(Sender: TObject; Node: TTreeNode);
    procedure btLoadPuttyClick(Sender: TObject);
    procedure btCopyClick(Sender: TObject);
    procedure btNewFolderClick(Sender: TObject);
    procedure tvConnectionDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvConnectionDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure acNewSessionExecute(Sender: TObject);
    procedure acNewFolderExecute(Sender: TObject);
    procedure acCopyExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure btSaveDefaultClick(Sender: TObject);
    procedure btLoadDefaultClick(Sender: TObject);
    procedure btColorClick(Sender: TObject);
    procedure cbColorChange(Sender: TObject);
    procedure edRChange(Sender: TObject);
    procedure tvConnectionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btExportPuttySettingsClick(Sender: TObject);
    procedure btFontClick(Sender: TObject);
    procedure sbUpClick(Sender: TObject);
    procedure sbDownClick(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
    procedure edSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ClearConnections;
    procedure SavePuttyInfo(const ConnInfo: TConnInfo);
    function CopyPuttyInfo(OldName, Name: String; Delete: Boolean; DupCheck: Boolean=True; OnlyOptions: Boolean=False): Boolean;
    procedure NewPuttySession(SessionName: String);
    function ConnExists(Name: String): Boolean;
  public
    { Public declarations }
    ConnInfo: TConnInfo;
    procedure EnableControls(Enabled: Boolean);
    procedure GetConnectionMenu(MenuItem: TMenuItem; OnClick: TNotifyEvent);
    function SearchNext(SearchIndex: Integer; Next: Boolean=True): Boolean;
  end;

var
  FormConnection: TFormConnection;

implementation

uses
  RsCrypt, MainForm, Registry, ShellApi, Types;

{$R *.dfm}

procedure TFormConnection.acCopyExecute(Sender: TObject);
var
  SessionName: String;
begin
  SessionName := '사본 - ' + tvConnection.Selected.Text;
  if (tvConnection.Selected <> nil) and (tvConnection.Selected.Level <> 0) and
     (tvConnection.Selected.ImageIndex = 1) then
  begin
    if not CopyPuttyInfo(tvConnection.Selected.Text, SessionName, False) then
    begin
      ShowMessage('복사에 실패했습니다');
      exit;
    end;

    NewPuttySession(SessionName);

    if edName.CanFocus then
      edName.SetFocus;
  end;
end;

procedure TFormConnection.acDeleteExecute(Sender: TObject);
var
  reg: TRegistry;
  Msg: String;
begin
  if (tvConnection.Selected <> nil) and (tvConnection.Selected.Level <> 0) then
  begin
    Msg := tvConnection.Selected.Text + ' 항목을 삭제합니다';
    if Application.MessageBox(PChar(Msg), '확인',
       MB_OKCANCEL) <> IDOK then
      exit;

//    ConnList.Delete(Integer(tvConnection.Selected.ItemId));

    reg := TRegistry.Create;

    try
      if reg.OpenKey(PUTTY_KEY_SESSIONS, False) then
      begin
        reg.DeleteKey(URLEncode(tvConnection.Selected.Text));
        reg.CloseKey;
      end;
    finally
      reg.Free;
    end;

    tvConnection.Items.Delete(tvConnection.Selected);
    SaveConnections;
  end;
end;

procedure TFormConnection.acNewFolderExecute(Sender: TObject);
var
  Node: TTreeNode;
begin
  if tvConnection.Selected = nil then
    exit;
  EnableControls(False);
  if tvConnection.Selected.ImageIndex = 1 then
    Node := tvConnection.Items.AddChild(tvConnection.Selected.Parent, '새 폴더')
  else
    Node := tvConnection.Items.AddChild(tvConnection.Selected, '새 폴더');
  edName.Text := '새 폴더';
  edName.Hint := '새 폴더';
  with Node do
  begin
    ImageIndex := 0;
    SelectedIndex := 0;
    Selected := True;
//    ConnList.Add(Integer(tvConnection.Selected.ItemId), 'folder', '', '', 'New Folder');
  end;
  if edName.CanFocus then
    edName.SetFocus;
end;

procedure TFormConnection.acNewSessionExecute(Sender: TObject);
const
  NewName = '신규 세션';
var
  i: Integer;
begin
  i := 1;
  while ConnExists(NewName + IntToStr(i)) do
    Inc(i);
  NewPuttySession(NewName + IntToStr(i));
  ApplyConnection;
end;

procedure TFormConnection.ApplyConnection;
begin
  if (tvConnection.Selected <> nil) and
    (tvConnection.Selected.ItemId <> tvConnection.Items.GetFirstNode.ItemId) then
  begin
    tvConnection.Selected.Text := edName.Text;
    if (tvConnection.Selected.ImageIndex <> 0) then
    begin
      ConnInfo.Name := edName.Text;
      ConnInfo.Host := edHost.Text;
      ConnInfo.Port := edPort.Text;
      ConnInfo.Protocol := GetProtocolInt(cbProtocol.Text);
      ConnInfo.User := edUser.Text;
      ConnInfo.Password := edPassword.Text;
      ConnInfo.Font := pnFont.Font;
      try
        connInfo.ScrollbackLines := StrToInt(edScrollbackLines.Text);
      except
        connInfo.ScrollbackLines := 200;
      end;
      SavePuttyInfo(ConnInfo);
    end;
  end;
end;

procedure TFormConnection.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormConnection.btColorClick(Sender: TObject);
begin
  dlgColor.Color := spColor.Brush.Color;
  if dlgColor.Execute then
  begin
    edR.Text := IntToStr(GetRValue(dlgColor.Color));
    edG.Text := IntToStr(GetGValue(dlgColor.Color));
    edB.Text := IntToStr(GetBValue(dlgColor.Color));
    spColor.Brush.Color := dlgColor.Color;
    ConnInfo.Colors[cbColor.ItemIndex] := dlgColor.Color;
  end;
end;

procedure TFormConnection.btConnectClick(Sender: TObject);
begin
  if (tvConnection.Selected = nil) or (tvConnection.Selected.ImageIndex = 0) then
    exit;

  btSave.Click;

  if not chbNewWindow.Checked then
  begin
{    ConnInfo.Name := edName.Text;
    if not LoadPuttyInfo(ConnInfo) then
      ShowMessage(edName.Text + ' 세션이 PuTTY 설정에 없습니다')
    else
    begin
      ModalResult := mrOk;
      exit;
    end;
}
    ModalResult := mrOk;
    exit;
  end else
    ShellExecute(Handle, 'open', PChar(Application.ExeName), PChar(edName.Text), nil, SW_SHOWNORMAL);

  ModalResult := mrCancel;
end;

procedure TFormConnection.btCopyClick(Sender: TObject);
begin
  acCopy.Execute;
end;

procedure TFormConnection.btDeleteClick(Sender: TObject);
begin
  acDelete.Execute;
end;

procedure TFormConnection.btExportPuttySettingsClick(Sender: TObject);
var
  Cmd: String;
begin
  if dlgExportPuttySettings.InitialDir = '' then
    dlgExportPuttySettings.InitialDir := ExtractFileDir(Application.ExeName);

  if dlgExportPuttySettings.Execute then
  begin
    Cmd := 'export ' + PUTTY_KEY_ROOT + ' "' + dlgExportPuttySettings.FileName + '"';
    ShellExecute(0, nil, 'Reg.exe', PChar(Cmd), nil, 0);
  end;
end;

procedure TFormConnection.btFontClick(Sender: TObject);
begin
  dlgFont.Font := pnFont.Font;
  if dlgFont.Execute then
  begin
    pnFont.Font := dlgFont.Font;
  end;
end;

procedure TFormConnection.btSaveDefaultClick(Sender: TObject);
begin
  if (tvConnection.Selected <> nil) and (tvConnection.Selected.Level <> 0) and
     (tvConnection.Selected.ImageIndex = 1) then
  begin
    if not CopyPuttyInfo(tvConnection.Selected.Text, '기본 설정', False, False, True) then
      CopyPuttyInfo(tvConnection.Selected.Text, 'Default Settings', False, False, True);
  end;
end;

procedure TFormConnection.btLoadDefaultClick(Sender: TObject);
begin
  if (tvConnection.Selected <> nil) and (tvConnection.Selected.Level <> 0) and
     (tvConnection.Selected.ImageIndex = 1) then
  begin
    if not CopyPuttyInfo('기본 설정', tvConnection.Selected.Text, False, False, True) then
      CopyPuttyInfo('Default Settings', tvConnection.Selected.Text, False, False, True);
    ConnInfo.Name := edName.Text;
    LoadPuttyInfo(ConnInfo);
  end;
end;

procedure TFormConnection.btLoadPuttyClick(Sender: TObject);
var
  reg: TRegistry;
  ValueNames: TStringList;
  i: Integer;
  Node: TTreeNode;
  KeyName: String;
begin
  reg := TRegistry.Create;
  ValueNames := TStringList.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey(PUTTY_KEY_SESSIONS, False) then
      reg.GetKeyNames(ValueNames);

    reg.CloseKey;
    for i:=0 to ValueNames.Count-1 do
    begin
      if reg.OpenKey(PUTTY_KEY_SESSIONS + '\' + ValueNames[i], False) then
      begin
        KeyName := URLDecode(ValueNames[i]);
        if (UpperCase(KeyName) = 'DEFAULT%20SETTINGS') or (KeyName = '기본 설정') or
           (UpperCase(KeyName) = 'DEFAULT SETTINGS') then
        begin
          reg.CloseKey;
          continue;
        end;

        if ConnExists(KeyName) then
          continue;

        Node := tvConnection.Items.AddChild(tvConnection.Items.GetFirstNode, KeyName);
        Node.ImageIndex := 1;
        Node.SelectedIndex := 1;
        reg.CloseKey;
      end;
    end;
  finally
    reg.Free;
    ValueNames.Free;
  end;
end;

procedure TFormConnection.btNewClick(Sender: TObject);
begin
  acNewSession.Execute;
end;

procedure TFormConnection.btNewFolderClick(Sender: TObject);
begin
  acNewFolder.Execute;
end;

procedure TFormConnection.btSaveClick(Sender: TObject);
begin
  if tvConnection.Selected.ImageIndex <> 0 then
  begin
    if edName.Text <> edName.Hint then
    begin
      if not CopyPuttyInfo(edName.Hint, edName.Text, True) then
        exit;

      edName.Hint := edName.Text;
    end;
  end;
  ApplyConnection;
  SaveConnections;
  LoadPuttyInfo(ConnInfo);
end;

procedure TFormConnection.btCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormConnection.cbColorChange(Sender: TObject);
var
  Color: TColor;
begin
  try
    with ConnInfo do
    begin
      if Colors[cbColor.ItemIndex] = -1 then
        Color := DEF_COLORS[cbColor.ItemIndex]
      else
        Color := Colors[cbColor.ItemIndex];

      edR.Text := IntToStr(GetRValue(Color));
      edG.Text := IntToStr(GetGValue(Color));
      edB.Text := IntToStr(GetBValue(Color));

      spColor.Brush.Color := Colors[cbColor.ItemIndex];
    end;
  except
  end;
end;

procedure TFormConnection.cbProtocolChange(Sender: TObject);
begin
  if cbProtocol.ItemIndex = 3 then
  begin
    lbHost.Caption := '통신포트';
    edHost.Text := 'COM1';
    lbPort.Caption := '전송속도';
    edPort.Text := '9600';
  end else
  begin
    if cbProtocol.ItemIndex = 0 then
      edPort.Text := '23'
    else if cbProtocol.ItemIndex = 1 then
      edPort.Text := '22'
    else
      edPort.Clear;
    lbHost.Caption := '접속주소';
    lbPort.Caption := '포트';
  end;
end;

procedure TFormConnection.ClearConnections;
begin
  tvConnection.Items.Clear;
  with tvConnection.Items.AddChildFirst(nil, 'PuTTY 연결') do
  begin
    SelectedIndex := 2;
    ImageIndex := 2;
  end;
end;

procedure TFormConnection.edNameChange(Sender: TObject);
begin
  if (Trim(edName.Text) <> '') then
  begin
    btConnect.Enabled := True;
  end else
  begin
    btConnect.Enabled := False;
    exit;
  end;

{  if (tvConnection.Selected <> nil) and
     (tvConnection.Selected.ItemId <> tvConnection.TopItem.ItemId) then
    tvConnection.Selected.Text := edName.Text;
}
end;

procedure TFormConnection.edRChange(Sender: TObject);
begin
  try
    if TEdit(Sender).Modified then
    begin
      TEdit(Sender).Modified := False;
      with ConnInfo do
      begin
        Colors[cbColor.ItemIndex] :=
          RGB(StrToInt(edR.Text)
            , StrToInt(edG.Text), StrToInt(edB.Text));
      end;
    end;
  except
  end;

  spColor.Brush.Color := ConnInfo.Colors[cbColor.ItemIndex];
end;

procedure TFormConnection.edSearchChange(Sender: TObject);
begin
  SearchNext(0);
end;

function TFormConnection.SearchNext(SearchIndex: Integer; Next: Boolean): Boolean;
var
  i: Integer;
begin
  tvConnection.MultiSelect := False;
  try
    if edSearch.Text = '' then
    begin
      Result := False;
      exit;
    end;
    if Next then
    begin
      for i:=SearchIndex+1 to tvConnection.Items.Count-1 do
      begin
        if Pos(edSearch.Text, tvConnection.Items.Item[i].Text) > 0 then
        begin
          tvConnection.Items.Item[i].Selected := True;
          Result := True;
          exit;
        end;
      end;
    end else
    begin
      for i:=SearchIndex-1 downto 0 do
      begin
        if Pos(edSearch.Text, tvConnection.Items.Item[i].Text) > 0 then
        begin
          tvConnection.Items.Item[i].Selected := True;
          Result := True;
          exit;
        end;
      end;
    end;
    Result := False;
  finally
    tvConnection.MultiSelect := True;
  end;
end;

procedure TFormConnection.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) then
  begin
    SearchNext(tvConnection.Selected.AbsoluteIndex, False);
    Key := $0;
  end else if (Key = VK_DOWN) then
  begin
    SearchNext(tvConnection.Selected.AbsoluteIndex, True);
    Key := $0;
  end;
end;

procedure TFormConnection.EnableControls(Enabled: Boolean);
begin
  edName.Enabled := Enabled;
  cbProtocol.Enabled := Enabled;
  edHost.Enabled := Enabled;
  edPort.Enabled := Enabled;
  edUser.Enabled := Enabled;
  edPassword.Enabled := Enabled;
end;

procedure TFormConnection.FormCreate(Sender: TObject);
begin
  ConnInfo.Font := pnFont.Font;
  cbProtocol.ItemIndex := 0;
  ClearConnections;
  LoadConnections;

  if tvConnection.Items.GetFirstNode.getFirstChild <> nil then
    tvConnection.Items.GetFirstNode.getFirstChild.Selected := True
  else
    tvConnection.Items.GetFirstNode.Selected := True;

  cbColor.ItemIndex := 0;
  pgInfo.ActivePageIndex := 0;
  DefaultPuttyInfo(ConnInfo);
end;

procedure TFormConnection.FormShow(Sender: TObject);
var
  TreeNode: TTreeNode;
  Selected: TTreeNode;
begin
  tvConnection.MultiSelect := False;

  try
    Selected := tvConnection.Selected;
    TreeNode := tvConnection.Items.GetFirstNode.GetNext;
    if TreeNode <> nil then
    begin
      tvConnection.Items.GetFirstNode.Selected := True;

      if Selected <> nil then
        Selected.Selected := True
      else
        TreeNode.Selected := True;
    end;
  finally
    tvConnection.MultiSelect := True;
  end;
end;

procedure TFormConnection.GetConnectionMenu(MenuItem: TMenuItem; OnClick: TNotifyEvent);
begin
  TreeViewToMenu(tvConnection.Items.GetFirstNode.GetFirstChild, MenuItem, OnClick);
end;

procedure TFormConnection.LoadConnections;
var
  MemStream: TMemoryStream;
  FileName: String;
  Rect: TRect;
  TreeView: TTreeView;
begin
  FileName := ExtractFilePath(Application.ExeName) + '/ConnInfo.dat';

  if not FileExists(FileName) then
    exit;

  MemStream := TMemoryStream.Create;
  TreeView := TTreeView.Create(Self);
  try
    Rect.Left := tvConnection.Left;
    Rect.Top := tvConnection.Top;
    Rect.Right := tvConnection.Width;
    Rect.Bottom := tvConnection.Height;
    MemStream.LoadFromFile(FileName);
    MemStream.ReadComponent(tvConnection);
    tvConnection.Left := Rect.Left;
    tvConnection.Top := Rect.Top;
    tvConnection.Width := Rect.Right;
    tvConnection.Height := Rect.Bottom;
  finally
    MemStream.Free;
    TreeView.Free;
  end;
end;

procedure TFormConnection.NewPuttySession(SessionName: String);
var
  Node: TTreeNode;
begin
  EnableControls(True);
  Node := tvConnection.Items.GetFirstNode;

  if (tvConnection.Selected <> nil) and (tvConnection.Selected.Level <> 0) then
  begin
    if tvConnection.Selected.ImageIndex = 0 then // folder
      Node := tvConnection.Selected
    else
      Node := tvConnection.Selected.Parent;
  end;

  with Node.Owner.AddChild(Node, SessionName) do
  begin
    ImageIndex := 1;
    SelectedIndex := 1;
    Selected := True;
    tvConnection.Items.GetFirstNode.Selected := True;
    Selected := True;
  end;

{  cbProtocol.ItemIndex := 1;
  edPort.Text := '22';
}
  edName.Text := SessionName;
  edName.Hint := SessionName;
  if edName.CanFocus then
    edName.SetFocus;

  ConnInfo.Name := SessionName;
  SavePuttyInfo(ConnInfo);
  cbColorChange(cbColor);
end;

function TFormConnection.ConnExists(Name: String): Boolean;
var
  i: Integer;
begin
  for i:=0 to tvConnection.Items.Count-1 do
  begin
    if tvConnection.Items.Item[i].Text = Name then
    begin
      Result := True;
      exit;
    end;
  end;
  Result := False;
end;

function TFormConnection.CopyPuttyInfo(OldName, Name: String; Delete: Boolean; DupCheck: Boolean; OnlyOptions: Boolean): Boolean;
var
  reg, destReg: TRegistry;
  keyNames: TStringList;
  i: Integer;
begin
  Result := False;

  if Name = '' then
    exit;

  reg := TRegistry.Create;
  destReg := TRegistry.Create;
  keyNames := TStringList.Create;

  try
    reg.RootKey := HKEY_CURRENT_USER;

    if DupCheck and destReg.OpenKey(PUTTY_KEY_SESSIONS + '\' + URLEncode(Name), False) then
    begin
      destReg.CloseKey;
      ShowMessage('PuTTY 설정에 동일한 세션명이 존재합니다');
      exit;
    end;

    if not destReg.OpenKey(PUTTY_KEY_SESSIONS + '\' + URLEncode(Name), True) then
    begin
      ShowMessage('세션 생성에 실패했습니다(대상)');
      exit;
    end;

    if reg.OpenKey(PUTTY_KEY_SESSIONS + '\' + URLEncode(OldName), False) then
    begin
      reg.GetValueNames(keyNames);

      for i:=0 to keyNames.Count-1 do
      begin
        if OnlyOptions then
        begin
          if (KeyNames[i] = 'HostName') or (KeyNames[i] = 'PortNumber') or
             (KeyNames[i] = 'Protocol') or (KeyNames[i] = 'UserName'  ) or
             (KeyNames[i] = 'Password') then
            continue;
        end;

        if reg.GetDataType(KeyNames[i]) in [rdInteger] then
          destReg.WriteInteger(KeyNames[i], reg.ReadInteger(KeyNames[i]))
        else
          destReg.WriteString(KeyNames[i], reg.ReadString(KeyNames[i]));
      end;

      reg.CloseKey;

      if Delete then
      begin
        if (Trim(OldName) <> '') and (reg.OpenKey(PUTTY_KEY_SESSIONS, False)) then
        begin
          reg.DeleteKey(URLEncode(OldName));
          reg.CloseKey;
        end;
      end;

      Result := True;
    end;

  finally
    reg.Free;
    destReg.CloseKey;
    destReg.Free;
    keyNames.Free;
  end;
end;

procedure TFormConnection.SaveConnections;
var
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  try
    MemStream.WriteComponent(tvConnection);
    MemStream.SaveToFile(ExtractFilePath(Application.ExeName) + '/ConnInfo.dat');
  finally
    MemStream.Free;
  end;
end;

procedure TFormConnection.SavePuttyInfo(const ConnInfo: TConnInfo);
var
  i: Integer;
  reg: TRegistry;
  keyNames: TStringList;
//  FontCharSet: Integer;
  Color: TColor;
begin
  reg := TRegistry.Create;
  keyNames := TStringList.Create;

  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey(PUTTY_KEY_SESSIONS + '\' + URLEncode(ConnInfo.Name), True) then
    begin
      if reg.ReadString('Font') = '' then
      begin
        if CopyPuttyInfo('기본 설정', ConnInfo.Name, False, False) then
          CopyPuttyInfo('Default Settings', ConnInfo.Name, False, False);
      end;

      with ConnInfo do
      begin
        if ScrollbackLines > 0 then
          reg.WriteInteger('ScrollbackLines', ScrollbackLines);
        if Protocol <> PROTOCOL_SERIAL then
        begin
          reg.WriteString('HostName', URLEncode(Host));
          if Port <> '' then
          begin
            try
              reg.WriteInteger('PortNumber', StrToInt(Port));
            except
            end;
          end;
        end else
        begin
          reg.WriteString('SerialLine', URLEncode(Host));
          if Port <> '' then
            reg.WriteInteger('SerialSpeed', StrToInt(Port));
        end;
        reg.WriteString('Protocol', GetProtocolStr(Protocol));
        reg.WriteString('UserName', User);
        reg.WriteString('Password', EncryptStr(Password, SECURITY_KEY));
{        try
          FontCharSet := reg.ReadInteger('FontCharSet');
        except
          FontCharSet := 0;
        end;
}
        for i:=0 to Length(Colors)-1 do
        begin
          if Colors[i] = -1 then
            Color := DEF_COLORS[i]
          else
            Color := Colors[i];

          reg.WriteString('Colour' + IntToStr(i),
            IntToStr(GetRValue(Color)) + ',' +
            IntToStr(GetGValue(Color)) + ',' +
            IntToStr(GetBValue(Color)));
        end;
{
        if FontCharSet = 0 then
          reg.WriteInteger('FontCharSet', 129);
}
        reg.WriteString('Font', pnFont.Font.Name);
        reg.WriteInteger('FontHeight', pnFont.Font.Size);

        if fsBold in Font.Style then
          reg.WriteInteger('FontIsBold', 1)
        else
          reg.WriteInteger('FontIsBold', 0);
      end;
      reg.CloseKey;
    end;
  finally
    reg.Free;
    keyNames.Free;
  end;
end;

procedure TFormConnection.sbDownClick(Sender: TObject);
begin
  if (tvConnection.Selected <> nil) and (tvConnection.Selected.Level <> 0) and
     (tvConnection.Selected.GetNextSibling <> nil) then
  begin
    if (tvConnection.Selected.GetNextSibling.Level = tvConnection.Selected.Level) then
    begin
      if (tvConnection.Selected.GetNextSibling.GetNextSibling <> nil) then
        tvConnection.Selected.MoveTo(tvConnection.Selected.GetNextSibling.GetNextSibling, naInsert)
      else
        tvConnection.Selected.MoveTo(tvConnection.Selected.GetNextSibling, naAdd);
    end;
  end;
end;

procedure TFormConnection.sbUpClick(Sender: TObject);
begin
  if (tvConnection.Selected <> nil) and (tvConnection.Selected.Level <> 0) and
     (tvConnection.Selected.GetPrevSibling <> nil) then
  begin
    if (tvConnection.Selected.GetPrevSibling.Level = tvConnection.Selected.Level) then
    begin
      tvConnection.Selected.MoveTo(tvConnection.Selected.GetPrevSibling, naInsert);
    end;
  end;
end;

procedure TFormConnection.tvConnectionChange(Sender: TObject; Node: TTreeNode);
var
  Color: TColor;
begin
  if tvConnection.Selected = nil then
    exit;

  if (tvConnection.Selected.Level <> 0) and (tvConnection.Selected.ImageIndex = 1) then
  begin
    acCopy.Enabled := True;
    acDelete.Enabled := True;
//    acNewFolder.Enabled := False;
    ConnInfo.Name := tvConnection.Selected.Text;

    cbProtocol.ItemIndex := 1;
    edPort.Text := '22';

    if LoadPuttyInfo(ConnInfo) then
    begin
      with ConnInfo do
      begin
        cbProtocol.ItemIndex := Protocol;
        edPort.Text := Port;
        try
          edScrollbackLines.Text := IntToStr(ScrollbackLines);
        except
          edScrollbackLines.Text := '200';
        end;

        edName.Text := Trim(Name);
        edName.Hint := Name;

        edHost.Text := Host;

        edUser.Text := User;
        edPassword.Text := Password;

        if Colors[cbColor.ItemIndex] = -1 then
          Color := DEF_COLORS[cbColor.ItemIndex]
        else
          Color := Colors[cbColor.ItemIndex];

        edR.Text := IntToStr(GetRValue(Color));
        edG.Text := IntToStr(GetGValue(Color));
        edB.Text := IntToStr(GetBValue(Color));
        pnFont.Font := Font;
      end;
    end else if Trim(cbProtocol.Text) <> '' then
    begin
      edName.Text := tvConnection.Selected.Text;
      edName.Hint := tvConnection.Selected.Text;
    end;

    EnableControls(True);
  end else
  begin
//    acNewFolder.Enabled := True;
    if tvConnection.Selected.ImageIndex = 0 then
    begin
      EnableControls(False);
      edName.Enabled := True;
      edName.Text := tvConnection.Selected.Text;
      edName.Hint := tvConnection.Selected.Text;
      btConnect.Enabled := False;
      acCopy.Enabled := False;
      acDelete.Enabled := True;
      edPort.Clear;
    end else
    begin
      acCopy.Enabled := False;
      acDelete.Enabled := False;
      EnableControls(False);
      edName.Clear;
      edPort.Text := '22';
    end;
    cbProtocol.ItemIndex := 1;
    edHost.Clear;
    edUser.Clear;
    edPassword.Clear;
    cbColorChange(cbColor);
  end;
end;

procedure TFormConnection.tvConnectionDblClick(Sender: TObject);
begin
  if btConnect.Enabled then
    btConnect.Click;
end;

procedure TFormConnection.tvConnectionDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
   Node: TTreeNode;
   AttachMode: TNodeAttachMode;
   HT: THitTests;
begin
  if tvConnection.Selected = nil then exit;

  HT := tvConnection.GetHitTestInfoAt(X, Y);
  Node := tvConnection.GetNodeAt(X, Y);

  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then
  begin
    if (htOnItem in HT) or (htOnIcon in HT) then
      AttachMode := naAddChild
    else if htNowhere in HT then
      AttachMode := naAdd
    else if htOnIndent in HT then
      AttachMode := naInsert
    else
      exit;
    tvConnection.Selected.MoveTo(Node, AttachMode);
  end;
end;

procedure TFormConnection.tvConnectionDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
   Node: TTreeNode;
   Ht: THitTests;
begin
  Ht := tvConnection.GetHitTestInfoAt(X, Y);
  Node := tvConnection.GetNodeAt(X, Y);
  if Node = nil then
  begin
    Accept := False;
    exit;
  end;

  if (Ht - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then
  begin
    Accept := (Node.ImageIndex = 0) or (Node.Level = 0);
  end else
    Accept := False;
{
  if (Source is TTreeNode) and not (TTreeNode(Sender).Level <> 0)
      and (TTreeNode(Sender).ImageIndex = 0) then
    Accept := True
  else
    Accept := False;
}
end;

procedure TFormConnection.tvConnectionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F2) then
  begin
    pgInfo.ActivePageIndex := 0;
    if edName.CanFocus then edName.SetFocus;
  end else if (Key = VK_DELETE) and btDelete.Enabled then
    btDelete.Click;
end;

end.
