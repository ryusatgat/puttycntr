unit TermThread;

interface

uses
  Classes, Windows, Forms;

type
  TTermThread = Class(TThread)
    private
      hProcess: THandle;
      ChildHandle: THandle;
      PuttyWnd: HWnd;
    protected
      procedure Execute; override;
    public
      constructor Create(ChildHandle: THandle; hProcess: THandle; PuttyWnd: HWnd);
//      destructor Destroy; override;
  end;

implementation


uses
  MainForm, RsCommon, Messages;
{ TTermThread }

constructor TTermThread.Create(ChildHandle: THandle; hProcess: THandle; PuttyWnd: HWnd);
begin
  inherited Create(True);

  FreeOnTerminate := True;
  Self.hProcess := hProcess;
  Self.ChildHandle := ChildHandle;
  Self.PuttyWnd := PuttyWnd;
end;
{
destructor TTermThread.Destroy;
begin
  inherited;
end;
}
procedure TTermThread.Execute;
begin
  inherited;
  WaitForSingleObject(hProcess, INFINITE);
  SendMessage(PuttyWnd, WM_DESTROY, 0, 0);
  SendMessage(PuttyWnd, WM_CLOSE, 0, 0);
  SetParent(PuttyWnd, HWND_DESKTOP);
  SendMessage(ChildHandle, WM_DESTROY, 0, 0);
  SendMessage(ChildHandle, WM_CLOSE, 0, 0);
end;

end.
