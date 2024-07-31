object FormAbout: TFormAbout
  Left = 88
  Top = 186
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'PuTTY '#52968#53580#51060#45320' '#51221#48372
  ClientHeight = 233
  ClientWidth = 496
  Color = clBtnFace
  TransparentColorValue = 16579836
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 88
    Top = 16
    Width = 118
    Height = 15
    Caption = 'PuTTY Container 2.6a'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 244
    Top = 16
    Width = 128
    Height = 15
    Caption = 'Copyright (C) 2009-2024'
  end
  object Label3: TLabel
    Left = 88
    Top = 74
    Width = 39
    Height = 15
    Caption = 'Github:'
  end
  object Label4: TLabel
    Left = 88
    Top = 56
    Width = 40
    Height = 15
    Caption = #51228#51089#51088':'
  end
  object lbHomepage: TLabel
    Left = 166
    Top = 74
    Width = 210
    Height = 15
    Cursor = crHandPoint
    Caption = 'https://github.com/ryusatgat/puttycntr'
    OnClick = lbHomepageClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object lbEmail: TLabel
    Left = 166
    Top = 56
    Width = 52
    Height = 15
    Cursor = crHandPoint
    Caption = #47448#49343#44051
    OnClick = lbEmailClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object imgIcon: TImage
    Left = 32
    Top = 32
    Width = 32
    Height = 32
    AutoSize = True
    Transparent = True
  end
  object Label5: TLabel
    Left = 88
    Top = 115
    Width = 36
    Height = 15
    Caption = 'PuTTY:'
  end
  object Label6: TLabel
    Left = 166
    Top = 115
    Width = 283
    Height = 15
    Cursor = crHandPoint
    Caption = 'http://www.chiark.greenend.org.uk/~sgtatham/putty'
    OnClick = lbHomepageClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object Label7: TLabel
    Left = 88
    Top = 200
    Width = 214
    Height = 15
    Caption = 'PuTTY '#52968#53580#51060#45320#45716' '#50612#46356#50640#49436#45208' '#47924#47308#47196' '#49324#50857#44032#45733#54633#45768#45796'.'
  end
  object Label10: TLabel
    Left = 166
    Top = 135
    Width = 130
    Height = 15
    Cursor = crHandPoint
    Caption = 'http://www.cygwin.com'
    OnClick = lbHomepageClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object Label11: TLabel
    Left = 88
    Top = 135
    Width = 43
    Height = 15
    Caption = 'Cygwin:'
  end
  object Label12: TLabel
    Left = 166
    Top = 155
    Width = 123
    Height = 15
    Cursor = crHandPoint
    Caption = 'http://www.mingw.org'
    OnClick = lbHomepageClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object Label13: TLabel
    Left = 88
    Top = 155
    Width = 43
    Height = 15
    Caption = 'MinGW:'
  end
  object btOk: TButton
    Left = 405
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = #54869#51064
    Default = True
    TabOrder = 0
    OnClick = btOkClick
  end
end
