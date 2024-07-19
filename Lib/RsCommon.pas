unit RsCommon;

interface

uses
  Windows, SysUtils, Classes, Forms, WinSvc, Graphics, Grids, Menus, ComCtrls, Dialogs;

const
  PROTOCOL_UNKNOWN = -1;
  PROTOCOL_SSH = 0;
  PROTOCOL_TELNET = 1;
  PROTOCOL_RAW = 2;
  PROTOCOL_SERIAL = 3;
  PROTOCOL_CYGWIN = 101;
  PROTOCOL_CONSOLE = 102;
  PROTOCOL_MINGW = 103;
  PROTOCOL_DKW = 104;
  WH_KEYBOARD_LL = 13;
  SECURITY_KEY = '1a2b3c4d5e6f7g8h9i0jklmn';
  PUTTY_KEY_ROOT = 'HKCU\Software\SimonTatham';
  PUTTY_KEY_SESSIONS = '\Software\SimonTatham\PuTTY\Sessions';
  DEF_COLORS : array[0..21] of TColor =
    (
       clSilver, clWhite,
       clBlack, clGray,
       clBlack, clGreen,
       clBlack, clGray,
       clMaroon, clRed,
       clGreen, clLime,
       clOlive, clYellow,
       clNavy, clBlue,
       clPurple, clFuchsia,
       clTeal, clAqua,
       clGray, clWhite
    );

  type
    DWM_BLURBEHIND = record
      dwFlags                 : DWORD;
      fEnable                 : BOOL;
      hRgnBlur                : HRGN;
      fTransitionOnMaximized  : BOOL;
  end;

  TConnInfo = record
    Host: String;
    Port: String;
    Protocol: Integer;
    Name: String;
    User: String;
    Password: String;
    ScrollbackLines: Integer;
    Colors: array [0..21] of TColor;
    Font: TFont;
  end;

  function GetProtocolInt(Protocol: String): Integer;
  function GetProtocolStr(Protocol: Integer): String;
  function GetParentProcessID(ProcessId: DWord): DWord;
  function GetWindowFromProcessID( ProcessId: DWord): HWND;
  function GetProcessHandle(const hWnd: THandle): THandle;
  function StrToChr(AStr: String; Pos: Integer): Char;
  function IsInteger(Str: String): Boolean;
  function GetEnvVar(const EnvVar: String): String;
  function DWM_EnableBlurBehind(hwnd : HWND; AEnable: Boolean; hRgnBlur : HRGN = 0; ATransitionOnMaximized: Boolean = False; AFlags: Cardinal = 1): HRESULT;
  function GetTopHandle(Wnd: HWND): HWND;
  function URLEncode(const S: String): String;
  function URLDecode(const S: string): string;
  function GetWindowClass(Wnd:HWND): String;
  function LoadPuttyInfo(var ConnInfo: TConnInfo): Boolean;
  procedure DefaultPuttyInfo(var ConnInfo: TConnInfo);
  procedure ShowTaskBar(IsShow: Boolean);
  procedure TreeViewToMenu(const Node: TTreeNode; var Item: TMenuItem; OnClick: TNotifyEvent);

implementation

uses
  IniFiles, Tlhelp32, Registry, RsCrypt;

Type
  TEnumData = Record
    hW: HWND;
    pID: DWORD;
  End;

function DwmEnableBlurBehindWindow(hWnd : HWND; const pBlurBehind : DWM_BLURBEHIND) : HRESULT; stdcall; external  'dwmapi.dll' name 'DwmEnableBlurBehindWindow';
function GetConsoleWindow: HWND; stdcall; external kernel32 name 'GetConsoleWindow';
function NetUserChangePassword(Domain: PWideChar; UserName: PWideChar; OldPassword: PWideChar;
  NewPassword: PWideChar): Longint; stdcall; external 'netapi32.dll';

function GetProtocolStr(Protocol: Integer): String;
begin
  case Protocol of
  PROTOCOL_SSH:
    Result := 'ssh';
  PROTOCOL_TELNET:
    Result := 'telnet';
  PROTOCOL_RAW:
    Result := 'raw';
  PROTOCOL_SERIAL:
    Result := 'serial';
  PROTOCOL_CYGWIN:
    Result := 'cygwin';
  PROTOCOL_CONSOLE:
    Result := 'console';
  PROTOCOL_MINGW:
    Result := 'mingw';
  end;
end;

function GetProtocolInt(Protocol: String): Integer;
begin
  if Protocol = 'ssh' then
    Result := PROTOCOL_SSH
  else if Protocol = 'telnet' then
    Result := PROTOCOL_TELNET
  else if Protocol = 'raw' then
    Result := PROTOCOL_RAW
  else if Protocol = 'serial' then
    Result := PROTOCOL_SERIAL
  else if Protocol = 'cygwin' then
    Result := PROTOCOL_CYGWIN
  else if Protocol = 'console' then
    Result := PROTOCOL_CONSOLE
  else if Protocol = 'mingw' then
    Result := PROTOCOL_MINGW
  else
    Result := PROTOCOL_UNKNOWN;
end;

function EnumProc( hw: HWND; var data: TEnumData ): Bool; stdcall;
var
  pID: DWORD;
begin
  Result := True;
(*
  If (GetWindowLong(hw, GWL_HWNDPARENT) = 0) and
     (IsWindowVisible( hw ) or IsIconic(hw)) and
     ((GetWindowLong(hw, GWL_EXSTYLE) and WS_EX_APPWINDOW) <> 0)
  then begin
*)
    GetWindowThreadProcessID( hw, @pID );
    if pID = data.pID then
    begin

      data.hW := hW;
      Result := False;
    end;
//  end;
end;

function GetParentProcessID(ProcessId: DWord): DWord;
var
  ProcInfo: TProcessEntry32;
  hSnapShot: THandle;
begin
  hSnapShot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (hSnapShot <> THandle(-1)) then
  try
    ProcInfo.dwSize := SizeOf(ProcInfo);

    if (Process32First(hSnapshot, ProcInfo)) then
      repeat
        if ProcInfo.th32ProcessID = ProcessId then
        begin
          Result := ProcInfo.th32ParentProcessID;
          exit;
        end;
      until not Process32Next(hSnapShot, ProcInfo);
  finally
    CloseHandle(hSnapShot);
  end;
  Result := 0;
end;

function GetWindowFromProcessID( ProcessId: DWord): HWND;
var
  data: TEnumData;
begin
  data.pID := ProcessId;
  data.hW := 0;
  EnumWindows(@EnumProc, longint(@data));
  Result := data.hW;
end;

function GetDateStr: String;
var
  CurStr: String;
begin
  DateTimeToString(CurStr, 'yyyymmdd', now);
  Result := CurStr;
end;

function GetTokenStr(Source: String; Seq: integer;
  Delim: Char): String;
var
  iIndex, iCount, iBegin: Integer;
begin
  iCount := 0;
  iBegin := 0;
  Result := '';

  for iIndex := 1 To Length(Source) do begin
    if Source[iIndex] = Delim then begin
      Inc(iCount);
      if iCount = Seq then begin
         Result := Copy(Source, iBegin + 1, iIndex - iBegin-1);
         exit;
      end;
      iBegin := iIndex;
    end else if iIndex = Length(Source) then begin
      if iCount = Seq -1 then begin
        Result := Copy(Source, iBegin + 1, iIndex - iBegin);
        exit;
      end;
    end;
  end;
end;

function DigitToStr(Digit, Len: Integer): String;
var
  Str: String;
  Zero: String;
  i: Integer;
begin
  Zero := '';
  Str := IntToStr(Digit);
  if Length(Str) > Len then
  begin
    Result := Copy(Str, 1, Len);
    exit;
  end;
  for i:=0 to Len-Length(Str)-1 do
    Zero := Zero + '0';

  Result := Zero + Str;
end;

function StrToDigit(Str: String; Len: Integer): Integer;
var
  i: Integer;
begin
  for i:=1 to Len do
  begin
    if not CharInSet(Str[i], ['0'..'9']) then
    begin
      Result := -1;
      exit;
    end;
  end;

  Result := StrToInt(Copy(Str, 1, Len));
end;

function BufferToStr(Buffer: PChar; Size: Integer): String;
var
  str: String;
  i: Integer;
begin
  str := '';
  for i:=0 to Size-1 do
    if Ord(Buffer[i]) > 127 then
      str := str + '!'
    else
      str := str + Buffer[i];

  Result := str;
end;

function StrToChr(AStr: String; Pos: Integer): Char;
begin
  if Length(AStr) < Pos then
    Result := #$0
  else
    Result := AStr[Pos];
end;

function IsInteger(Str: String): Boolean;
begin
  try
    Result := StrToInt(Str) = StrToInt(Str);
  except
    Result := False;
  end;
end;

function GetEnvVar(const EnvVar: String): String;
var
  BufSize: Integer;
begin
  BufSize := GetEnvironmentVariable(PChar(EnvVar), nil, 0);
  if BufSize > 0 then
  begin
    SetLength(Result, BufSize-1);
    GetEnvironmentVariable(PChar(EnvVar), PChar(Result), BufSize);
  end else
    Result := '';  
end;

function DWM_EnableBlurBehind(hwnd : HWND; AEnable: Boolean; hRgnBlur : HRGN = 0; ATransitionOnMaximized: Boolean = False; AFlags: Cardinal = 1): HRESULT;
var
    pBlurBehind : DWM_BLURBEHIND;
begin
    pBlurBehind.dwFlags:=AFlags;
    pBlurBehind.fEnable:=AEnable;
    pBlurBehind.hRgnBlur:=hRgnBlur;
    pBlurBehind.fTransitionOnMaximized:=ATransitionOnMaximized;
    Result:=DwmEnableBlurBehindWindow(hwnd, pBlurBehind);
end;

function GetTopHandle(Wnd: HWND): HWND;
begin
  while GetParent(Wnd) <> 0 do
    Wnd := GetParent(Wnd);

  Result := Wnd;
end;

function URLEncode(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i:=1 to Length(S) do
  begin
    if CharInSet(S[i], ['A'..'Z', 'a'..'z', '0'..'9', '-', '=', '&', ':', '/', '?', ';', '_', '.', '#', '(', ')']) then
        Result := Result + S[i]
    else
      Result := Result + '%' + IntToHex(Ord(S[i]), 2);
  end;
end;

function URLDecode(const S: string): string;
var
  Idx: Integer;   // loops thru chars in string
  Hex: string;    // string of hex characters
  Code: Integer;  // hex character code (-1 on error)
begin
  // Intialise result and string index
  Result := '';
  Idx := 1;
  // Loop thru string decoding each character
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
      begin
        // % should be followed by two hex digits - exception otherwise
        if Idx <= Length(S) - 2 then
        begin
          // there are sufficient digits - try to decode hex digits
          Hex := S[Idx+1] + S[Idx+2];
          Code := SysUtils.StrToIntDef('$' + Hex, -1);
          Inc(Idx, 2);
        end
        else
          // insufficient digits - error
          Code := -1;
        // check for error and raise exception if found
        if Code = -1 then
          raise SysUtils.EConvertError.Create(
            'Invalid hex digit in URL'
          );
        // decoded OK - add character to result
        Result := Result + Chr(Code);
      end;
      '+':
        // + is decoded as a space
        Result := Result + ' '
      else
        // All other characters pass thru unchanged
        Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;
end;

function GetProcessHandle(const hWnd: THandle): THandle;
var
    PID: DWORD;
    AhProcess: THandle;
begin
  if hWnd<>0 then
  begin
    GetWindowThreadProcessID(hWnd, @PID);
    AhProcess := OpenProcess(PROCESS_ALL_ACCESS, True, PID);
    Result:=AhProcess;
    CloseHandle(AhProcess);
  end else
    Result:=0;
end;

function GetWindowClass(Wnd:HWND): String;
const
  MAXLEN = 64;
var
  Text: array[0..MAXLEN] of char;
begin
  GetClassName(Wnd, @Text, MAXLEN);
  Result := String(Text);
end;

procedure DefaultPuttyInfo(var ConnInfo: TConnInfo);
var
  i: Integer;
begin
  with ConnInfo do
  begin
    Protocol := PROTOCOL_SSH;
    Port := '22';
    ScrollbackLines := 200;
    for i:= 0 to Length(Colors)-1 do
      Colors[i] := DEF_COLORS[i];
    Font.Name := 'FixedSys';
    Font.Size := 12;
    Font.Style := [];
  end;
end;

function LoadPuttyInfo(var ConnInfo: TConnInfo): Boolean;
var
  i: Integer;
  reg: TRegistry;
  keyNames: TStringList;
  function MakeColor(Colors: String): TColor;
  var
    List: TStrings;
  begin
    Result := -1;
    if Colors = '' then
      exit;

    List := TStringList.Create;
    try
      List.Delimiter := ',';
      List.DelimitedText := Colors;
      Result := RGB(StrToInt(List.Strings[0])
        , StrToInt(List.Strings[1]), StrToInt(List.Strings[2]));
    finally
      List.Free;
    end;
  end;
begin
  reg := TRegistry.Create;
  keyNames := TStringList.Create;

  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey(PUTTY_KEY_SESSIONS + '\' + URLEncode(ConnInfo.Name), False) then
    begin
      with ConnInfo do
      begin
        Protocol := GetProtocolInt(reg.ReadString('Protocol'));
        if Protocol <> PROTOCOL_SERIAL then
        begin
          Host := URLDecode(reg.ReadString('HostName'));
          try
            Port := IntToStr(reg.ReadInteger('PortNumber'));
          except
          end;
        end else
        begin
          Host := URLDecode(reg.ReadString('SerialLine'));
          try
            Port := IntToStr(reg.ReadInteger('SerialSpeed'));
          except
            Port := '22';
          end;
        end;
        try
          ScrollbackLines := reg.ReadInteger('ScrollbackLines');
        except
          ScrollbackLines := 200;
        end;
        User := reg.ReadString('UserName');
        Password := DecryptStr(reg.ReadString('Password'), SECURITY_KEY);

        for i:=0 to Length(Colors)-1 do
        begin
          Colors[i] := MakeColor(reg.ReadString('Colour' + IntToStr(i)));
          if Colors[i] = -1 then
            Colors[i] := DEF_COLORS[i];
        end;

        if Font <> nil then
        begin
          Font.Name := reg.ReadString('Font');

          if Font.Name <> '' then
          begin
            try
              Font.Size := reg.ReadInteger('FontHeight');
            except
              Font.Size := 12;
            end;
            try
              if reg.ReadInteger('FontIsBold') <> 0 then
                Font.Style := [fsBold]
              else
                Font.Style := [];
            except
            end;
          end;
        end;

        reg.CloseKey;
      end;
      Result := True;
    end else Result := False;
  finally
    reg.Free;
    keyNames.Free;
  end;
end;

procedure ShowTaskBar(IsShow: Boolean);
var
  wndHandle: THandle;
begin
  wndHandle := FindWindow(PChar('Shell_TrayWnd'), nil);
  if IsShow then
    ShowWindow(wndHandle, SW_RESTORE)
  else
    ShowWindow(wndHandle, SW_HIDE);
end;

procedure TreeViewToMenu(const Node: TTreeNode; var Item: TMenuItem; OnClick: TNotifyEvent);
var
  NewItem: TMenuItem;
  NextNode: TTreeNode;
begin
  NextNode := Node;

  while NextNode <> nil do
  begin
    NewItem := TMenuItem.Create(Item);
    NewItem.Caption := NextNode.Text;
    Item.Add(NewItem);
    if NextNode.HasChildren then
      TreeViewToMenu(NextNode.getFirstChild, NewItem, OnClick)
    else
      NewItem.OnClick := OnClick;
    NextNode := NextNode.getNextSibling;
  end;
end;

end.

