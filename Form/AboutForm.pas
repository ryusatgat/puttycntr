unit AboutForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg;

type
  TFormAbout = class(TForm)
    btOk: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbHomepage: TLabel;
    lbEmail: TLabel;
    imgIcon: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure btOkClick(Sender: TObject);
    procedure lbHomepageClick(Sender: TObject);
    procedure lbEmailClick(Sender: TObject);
    procedure lbHomepageMouseEnter(Sender: TObject);
    procedure lbHomepageMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

uses
  ShellApi, RsCommon;

{$R *.dfm}

procedure TFormAbout.btOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormAbout.lbHomepageClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar(TLabel(Sender).Caption), nil, nil, SW_SHOW);
end;

procedure TFormAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormAbout.FormShow(Sender: TObject);
begin
  imgIcon.Picture.Assign(Application.Icon);
end;

procedure TFormAbout.lbEmailClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar('mailto:' + lbEmail.Caption), nil, nil, SW_SHOW);
end;

procedure TFormAbout.lbHomepageMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clBlue;
  TLabel(Sender).Font.Style := [fsUnderline];
end;

procedure TFormAbout.lbHomepageMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clWindowText;
  TLabel(Sender).Font.Style := [];
end;

end.
