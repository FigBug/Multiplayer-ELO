object frmMatchResult: TfrmMatchResult
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Match Result'
  ClientHeight = 402
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 361
    Width = 401
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      401
      41)
    object btnCancel: TButton
      Left = 315
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 234
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 401
    Height = 361
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 300
      end
      item
        Alignment = taRightJustify
        Caption = 'Place'
        Width = 75
      end>
    MultiSelect = True
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
    OnData = ListView1Data
  end
  object PopupMenu1: TPopupMenu
    Left = 192
    Top = 200
  end
end
