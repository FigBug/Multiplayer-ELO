object frmELOTest: TfrmELOTest
  Left = 0
  Top = 0
  Caption = 'ELO Test'
  ClientHeight = 438
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CheckListBox1: TCheckListBox
    Left = 8
    Top = 8
    Width = 217
    Height = 393
    ItemHeight = 13
    TabOrder = 0
  end
  object btnPlayMatch: TButton
    Left = 240
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Play Match'
    TabOrder = 1
    OnClick = btnPlayMatchClick
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 288
    Top = 184
  end
end
