object FormPassword: TFormPassword
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Windows '#49324#50857#51088' '#48708#48128#48264#54840' '#51077#47141
  ClientHeight = 77
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 32
    Width = 48
    Height = 13
    Caption = #48708#48128#48264#54840
  end
  object edPassword: TEdit
    Left = 88
    Top = 29
    Width = 121
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    MaxLength = 20
    PasswordChar = '*'
    TabOrder = 0
    OnKeyPress = edPasswordKeyPress
  end
  object btOk: TButton
    Left = 215
    Top = 27
    Width = 63
    Height = 25
    Caption = #54869#51064
    TabOrder = 1
    OnClick = btOkClick
  end
end
