program PuttyCtnr;



uses
  Forms,
  MainForm in 'Form\MainForm.pas' {FormPuttyMain},
  RsCommon in 'Lib\RsCommon.pas',
  TermThread in 'Lib\TermThread.pas',
  AboutForm in 'Form\AboutForm.pas' {FormAbout},
  ConnectionForm in 'Form\ConnectionForm.pas' {FormConnection},
  RsCrypt in 'Lib\RsCrypt.pas',
  RsRawInput in 'Lib\RsRawInput.pas',
  ChildForm in 'Form\ChildForm.pas' {FormChild},
  MingwForm in 'Form\MingwForm.pas' {FormMingw},
  PasswordForm in 'Form\PasswordForm.pas' {FormPassword},
  NTLogon in 'Lib\NTLogon.pas',
  DirectDraw in 'Component\SmartTabs21\DirectDraw.pas',
  GDIPAPI in 'Component\SmartTabs21\GDIPAPI.pas',
  GDIPOBJ in 'Component\SmartTabs21\GDIPOBJ.pas',
  GDIPUTIL in 'Component\SmartTabs21\GDIPUTIL.pas',
  rkSmartTabs in 'Component\SmartTabs21\rkSmartTabs.pas',
  SyncKeyForm in 'Form\SyncKeyForm.pas' {FormSyncKey},
  ChromeTabs in 'Component\TChromeTabs\Lib\ChromeTabs.pas',
  ChromeTabsClasses in 'Component\TChromeTabs\Lib\ChromeTabsClasses.pas',
  ChromeTabsControls in 'Component\TChromeTabs\Lib\ChromeTabsControls.pas',
  ChromeTabsGlassForm in 'Component\TChromeTabs\Lib\ChromeTabsGlassForm.pas',
  ChromeTabsLog in 'Component\TChromeTabs\Lib\ChromeTabsLog.pas',
  ChromeTabsThreadTimer in 'Component\TChromeTabs\Lib\ChromeTabsThreadTimer.pas',
  ChromeTabsTypes in 'Component\TChromeTabs\Lib\ChromeTabsTypes.pas',
  ChromeTabsUtils in 'Component\TChromeTabs\Lib\ChromeTabsUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'PuTTY 컨테이너';
  Application.CreateForm(TFormPuttyMain, FormPuttyMain);
  Application.Run;
end.
