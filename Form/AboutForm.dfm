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
  Font.Name = #44404#47548
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 12
  object Label1: TLabel
    Left = 88
    Top = 16
    Width = 125
    Height = 12
    Caption = 'PuTTY '#52968#53580#51060#45320' 2.5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 244
    Top = 16
    Width = 135
    Height = 12
    Caption = 'Copyright (C) 2009-2024'
  end
  object Label3: TLabel
    Left = 88
    Top = 74
    Width = 52
    Height = 12
    Caption = #54856#54168#51060#51648':'
  end
  object Label4: TLabel
    Left = 88
    Top = 56
    Width = 52
    Height = 12
    Caption = #47564#46304#49324#46988':'
  end
  object lbHomepage: TLabel
    Left = 166
    Top = 74
    Width = 218
    Height = 12
    Cursor = crHandPoint
    Caption = 'https://github.com/ryusatgat/puttycntr'
    OnClick = lbHomepageClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object lbEmail: TLabel
    Left = 166
    Top = 56
    Width = 36
    Height = 12
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
    Top = 103
    Width = 43
    Height = 12
    Caption = 'PuTTY:'
  end
  object Label6: TLabel
    Left = 166
    Top = 103
    Width = 300
    Height = 12
    Cursor = crHandPoint
    Caption = 'http://www.chiark.greenend.org.uk/~sgtatham/putty'
    OnClick = lbHomepageClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object Label7: TLabel
    Left = 88
    Top = 200
    Width = 319
    Height = 12
    Caption = 'PuTTY '#52968#53580#51060#45320#45716' '#50612#46356#50640#49436#45208' '#47924#47308#47196' '#49324#50857#54624' '#49688' '#51080#49845#45768#45796'.'
  end
  object Label8: TLabel
    Left = 166
    Top = 120
    Width = 213
    Height = 12
    Cursor = crHandPoint
    Caption = 'http://bitbucket.org/daybreaker/iputty'
    OnClick = lbHomepageClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object Label9: TLabel
    Left = 88
    Top = 120
    Width = 71
    Height = 12
    Caption = #54620#44544' PuTTY:'
  end
  object Label10: TLabel
    Left = 166
    Top = 137
    Width = 140
    Height = 12
    Cursor = crHandPoint
    Caption = 'http://www.cygwin.com'
    OnClick = lbHomepageClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object Label11: TLabel
    Left = 88
    Top = 137
    Width = 47
    Height = 12
    Caption = 'Cygwin:'
  end
  object Label12: TLabel
    Left = 166
    Top = 155
    Width = 136
    Height = 12
    Cursor = crHandPoint
    Caption = 'http://www.mingw.org/'
    OnClick = lbHomepageClick
    OnMouseEnter = lbHomepageMouseEnter
    OnMouseLeave = lbHomepageMouseLeave
  end
  object Label13: TLabel
    Left = 88
    Top = 155
    Width = 44
    Height = 12
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
