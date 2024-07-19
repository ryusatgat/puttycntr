object FormMingw: TFormMingw
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'MinGW '#53552#48120#45328' '#49444#51221
  ClientHeight = 131
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 24
    Height = 13
    Caption = #50948#52824
  end
  object Label2: TLabel
    Left = 24
    Top = 56
    Width = 24
    Height = 13
    Caption = #50741#49496
  end
  object btPosition: TSpeedButton
    Left = 282
    Top = 20
    Width = 23
    Height = 21
    Caption = '...'
    Flat = True
    OnClick = btPositionClick
  end
  object edPath: TEdit
    Left = 62
    Top = 20
    Width = 217
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 0
  end
  object edArgs: TEdit
    Left = 62
    Top = 53
    Width = 243
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 1
  end
  object btOk: TButton
    Left = 144
    Top = 91
    Width = 75
    Height = 25
    Caption = #54869#51064
    Default = True
    TabOrder = 2
    OnClick = btOkClick
  end
  object btCancle: TButton
    Left = 230
    Top = 91
    Width = 75
    Height = 25
    Cancel = True
    Caption = #52712#49548
    TabOrder = 3
    OnClick = btCancleClick
  end
  object OpenDialog: TOpenDialog
    FileName = 'rxvt.exe'
    Title = 'rxvt '#50948#52824
    Left = 16
    Top = 88
  end
end
