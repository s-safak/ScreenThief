object MainFormServer: TMainFormServer
  Left = 300
  Top = 190
  Width = 529
  Height = 430
  Caption = 'Screen Thief Server'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000000FFFFFFFFFFF0000000000000000000000F
    0F0F0F0F000091111111000000000000FFFFFFF0000099999999000000000FF8
    00000008FF0000000009110000000F9FFFFFFFF0000000000009910000000FFF
    FFFFFFFFFF000000000091100000000000000000004444000000991000000000
    00000000C4C4C4C40000991000000000FFFFFFF0444444444000991000000040
    F00000F0C4C4C4C4C400991000000440F0AAE0F04C444C444C40991000000440
    F0DAD0F0C4C4C4C4C499991110004440F00000F04CCC4C4C4C49999100004440
    FFFFFFF0C4C4C4C4C4C0991000004440000000003CCCCC4CCC40010000004444
    4C4433333CCCC40000000000000044C4C4C4333333C4CC0FFFFFFFFFFF004444
    4C43333333CCCCC0F0F0F0F0F0004444C4C333333CC4C0000FFFFFFF00004444
    4C433333CCCCC0FF800000008FF044C4C4C334C4C4CCC0F9FFFFFFFF00004444
    44433CCCC3CCC0FFFFFFFFFFFFF00444C4C433C433C4CC000000000000000444
    4343333333CCCC4C0000000000000044C333333333C4C4C40FFFFFFF00000044
    4333333333CCCCCC0F00000F00000004C333333333C4C3C40F0AAE0F00000000
    4333333C333CC3430F0DAD0F0000000004333334C333C4C30F00000F00000000
    00044433444C44000FFFFFFF00000000000004C4C4C400000000000000008003
    FFFF8003FFFFC00700FF000100FF0001FE3F0001FE3F0001FF1F80003F1FE000
    0F1FE000071FC000031F8000011F800000070000000F0000011F000001BF0000
    0001000000010000000300000000000000000000000000000000800000018000
    0007C0000007C0000007E0000007F0000007F8000007FE003007FF80F007}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 185
    Top = 0
    Width = 336
    Height = 403
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object ImageScrollBox: TScrollBox
      Left = 1
      Top = 18
      Width = 334
      Height = 327
      HorzScrollBar.Smooth = True
      VertScrollBar.Smooth = True
      Align = alClient
      TabOrder = 0
      object Image: TImage
        Left = 0
        Top = 0
        Width = 153
        Height = 177
        AutoSize = True
      end
    end
    object InfoLabel: TStaticText
      Left = 1
      Top = 1
      Width = 334
      Height = 17
      Align = alTop
      Alignment = taCenter
      Caption = 'InfoLabel'
      Color = clMedGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
    object Protocol: TMemo
      Left = 1
      Top = 345
      Width = 334
      Height = 57
      Align = alBottom
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 403
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object ClientsBox: TGroupBox
      Left = 4
      Top = 4
      Width = 177
      Height = 139
      Align = alClient
      Caption = 'Connected clients:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object ClientsListBox: TListBox
        Left = 2
        Top = 15
        Width = 173
        Height = 122
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
        OnClick = ClientsListBoxClick
      end
    end
    object DetailsBox: TGroupBox
      Left = 4
      Top = 143
      Width = 177
      Height = 160
      Align = alBottom
      Caption = 'Client details:'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object DetailsMemo: TMemo
        Left = 2
        Top = 15
        Width = 173
        Height = 143
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'DetailsMemo')
        ParentFont = False
        TabOrder = 0
      end
    end
    object ActionPanel: TPanel
      Left = 4
      Top = 303
      Width = 177
      Height = 96
      Align = alBottom
      TabOrder = 2
      object AutoCaptureCheckBox: TCheckBox
        Left = 8
        Top = 8
        Width = 125
        Height = 29
        Caption = 'Auto capture every (in seconds)'
        TabOrder = 0
        WordWrap = True
        OnClick = AutoCaptureCheckBoxClick
      end
      object SecondsCombo: TComboBox
        Left = 128
        Top = 12
        Width = 41
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10')
      end
      object GetImageNowButton: TBitBtn
        Left = 8
        Top = 56
        Width = 161
        Height = 29
        Caption = 'Screen capture NOW'
        TabOrder = 2
        OnClick = GetImageNowButtonClick
        Glyph.Data = {
          66010000424D6601000000000000760000002800000014000000140000000100
          040000000000F000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
          00333333000030FFFFFFFFFFF03333330000330F0F0F0F0F0333333300000000
          FFFFFFF00003333300000FF800000008FF03333300000F9FFFFFFFF000033333
          00000FFFFFFFFFFFFF0333330000300000000000003333330000333000000000
          3333333300003330FFFF00703333333300003330F0000B307833333300003330
          F0CCC0BB0078333300003330F0CCC00BB300733300003330F00000F0BBB00733
          00003330FFFFFFF00BBB00830000333000000000BBB008330000333333333330
          0BBB00830000333333333333300BB008000033333333333333300B0000003333
          33333333333330000000}
      end
    end
  end
  object TCPServer: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 7676
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = TCPServerConnect
    OnExecute = TCPServerExecute
    OnDisconnect = TCPServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    ThreadMgr = ThreadManager
    Left = 76
    Top = 216
  end
  object ThreadManager: TIdThreadMgrDefault
    Left = 232
    Top = 40
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 270
    Top = 102
  end
  object IdAntiFreeze: TIdAntiFreeze
    Left = 398
    Top = 42
  end
end
