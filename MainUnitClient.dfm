object MainFormClient: TMainFormClient
  Left = 420
  Top = 313
  Width = 296
  Height = 120
  BorderStyle = bsSizeToolWin
  Caption = 'Screen Thief CLIENT'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProtocolLabel: TLabel
    Left = 0
    Top = 0
    Width = 288
    Height = 13
    Align = alTop
    Caption = 'Protocol messages:'
  end
  object IncomingMessages: TMemo
    Left = 0
    Top = 13
    Width = 288
    Height = 80
    Align = alClient
    ReadOnly = True
    TabOrder = 0
  end
  object TCPClient: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = TCPClientDisconnected
    Host = '127.0.0.1'
    OnConnected = TCPClientConnected
    Port = 7676
    Left = 60
    Top = 28
  end
  object Timer: TTimer
    Interval = 500
    OnTimer = TimerTimer
    Left = 128
    Top = 28
  end
  object IdAntiFreeze: TIdAntiFreeze
    Left = 200
    Top = 32
  end
end
