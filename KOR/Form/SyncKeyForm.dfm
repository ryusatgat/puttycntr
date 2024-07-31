object FormSyncKey: TFormSyncKey
  Left = 0
  Top = 0
  AlphaBlendValue = 127
  BorderIcons = [biSystemMenu]
  Caption = 'PuTTY '#45796#51473#54868#47732' '#46041#49884#53412' '#51077#47141
  ClientHeight = 219
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  DesignSize = (
    332
    219)
  TextHeight = 13
  object sbPaste: TSpeedButton
    Left = 288
    Top = 156
    Width = 22
    Height = 22
    Hint = #45796#51473' '#54868#47732#51004#47196' '#53364#47549#48372#46300' '#45236#50857#51012' '#48537#50668#45347#44592' '#54633#45768#45796
    Anchors = [akRight, akBottom]
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
      00669A00669A00669AB88989B88989B88989B88989B88989B88989B88989B889
      89B88989B88989FF00FFFF00FF00669A3CBEE336BAE130B6DFB88989FEFEFDFE
      FEFEFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDB88989FF00FFFF00FF00669A
      45C4E63FC0E438BCE2B88989FEFBF8B27E73B27E73B27E73B27E73B27E73B27E
      73FEFBF8B88989FF00FFFF00FF00669A4DC9E947C4E741C0E5B88989FEF8F3FF
      F4ECFEF6EEFEF8F1FFF9F4FEFBF6FEFCF9FEF8F3B88989FF00FFFF00FF00669A
      56CDED50C9EA4AC5E8B88989FEF6EDB27E73B27E73B27E73B27E73B27E73B27E
      73FEF6EDB88989FF00FFFF00FF00669A5ED2F058CFED52CBEBB88989FFF0E3FF
      F0E3FFF0E3FFF1E5FFF2E6FFF3E9FFF5EBFFF0E3B88989FF00FFFF00FF00669A
      66D7F360D4F15AD0EEB88989FFEDDDB27E73B27E73B27E73B27E73CDA99ECCAA
      9ED7C5BAB88989FF00FFFF00FF00669A6DDBF667D8F362D4F2B88989FFEBD8FF
      EAD7FFEBD8FFEBD8FFEBD8C4AAA7C5ABA8CDB5B0CD9999FF00FFFF00FF00669A
      74DFF86FDCF66ADAF4B88989FFE8D2FFE8D2FFE8D2FFE8D2FBE4CFC6ACA9FEFE
      FECD9999FF00FFFF00FFFF00FF00669A7AE3FA76E1F870DDF6B88989FFE6CFFF
      E6CFFFE6CFFFE6CFE9CFBFD2BAB4CD999900669AFF00FFFF00FFFF00FF00669A
      7FE6FC7BE4FA77E1F9B88989B88989B88989B88989B88989B88989CD999952CA
      EB00669AFF00FFFF00FFFF00FF00669A83E8FE80E6FC7DE5FC7DE5FC78E2FA72
      DFF86BDAF564D5F25DD0EF56CDED52CAEB00669AFF00FFFF00FFFF00FF00669A
      84E9FE84E9FE73737373737373737373737373737373737373737360D4F05ACF
      EE00669AFF00FFFF00FFFF00FF00669A84E9FE84E9FE737373CFC1BCCFC1BBCF
      C1BBCFC1BBCEBEB773737368D8F462D4F100669AFF00FFFF00FFFF00FFFF00FF
      00669A00669A737373E2D8D3FAF9F8F9F8F7F9F8F7D0C5BF73737300669A0066
      9AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF73737373737373
      7373737373737373FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    ParentShowHint = False
    ShowHint = True
    OnClick = sbPasteClick
    ExplicitLeft = 251
  end
  object Label1: TLabel
    Left = 18
    Top = 16
    Width = 182
    Height = 13
    Caption = #54868#47732' '#47785#47197'(&L)'
  end
  object Label2: TLabel
    Left = 9
    Top = 159
    Width = 88
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #48372#45244' '#47928#51088'(&C)'
    FocusControl = edChar
  end
  object Label3: TLabel
    Left = 29
    Top = 186
    Width = 68
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = #48372#45244' '#47928#51088#50676'(&S)'
    FocusControl = edString
  end
  object cklList: TCheckListBox
    Left = 18
    Top = 35
    Width = 292
    Height = 110
    Anchors = [akLeft, akTop, akRight, akBottom]
    ImeName = 'Microsoft Office IME 2007'
    ItemHeight = 17
    Items.Strings = (
      'a'
      'b'
      'c'
      'd')
    TabOrder = 2
    ExplicitWidth = 288
    ExplicitHeight = 109
  end
  object edChar: TEdit
    Left = 104
    Top = 156
    Width = 178
    Height = 21
    Hint = #53412#48372#46300#50640' '#51077#47141#54620' '#45236#50857#51012' '#48148#47196' '#51204#49569#54633#45768#45796'. '#54620#44544#44284' '#44057#51008' '#50976#45768#53076#46300#45716' '#51204#49569#46104#51648' '#50506#49845#45768#45796'.'
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMedGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = 'Microsoft Office IME 2007'
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 0
    Text = #50668#44592#50640#49436' '#51077#47141#54616#49464#50836
    OnKeyPress = edCharKeyPress
    ExplicitTop = 155
    ExplicitWidth = 174
  end
  object edString: TEdit
    Left = 104
    Top = 183
    Width = 178
    Height = 21
    Hint = #48373#49324#54616#44256' '#48537#50668#45347#51004#49464#50836'. '#50976#45768#53076#46300#46020' '#51204#49569#54624' '#49688' '#51080#49845#45768#45796'.'
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = 'Microsoft Office IME 2007'
    MaxLength = 1024
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnKeyPress = edStringKeyPress
    ExplicitTop = 182
    ExplicitWidth = 174
  end
  object ckTransparant: TCheckBox
    Left = 240
    Top = 15
    Width = 74
    Height = 17
    Caption = #53804#47749'(&T)'
    TabOrder = 3
    OnClick = ckTransparantClick
  end
  object ckNewLine: TCheckBox
    Left = 288
    Top = 185
    Width = 74
    Height = 17
    Hint = #51204#49569' '#49884#50640' '#44060#54665#47928#51088#47484' '#52628#44032#54633#45768#45796
    Caption = '&LF'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = ckTransparantClick
  end
end
