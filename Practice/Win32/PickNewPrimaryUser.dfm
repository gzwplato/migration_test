object PickNewPrimaryUser: TPickNewPrimaryUser
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Confirmation'
  ClientHeight = 163
  ClientWidth = 463
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
  object Image1: TImage
    Left = 15
    Top = 17
    Width = 40
    Height = 40
    AutoSize = True
    Stretch = True
    Transparent = True
  end
  object lblMainMessage: TLabel
    Left = 76
    Top = 10
    Width = 379
    Height = 50
    AutoSize = False
    Caption = 
      'This user is the current primary contact for this practice. Anot' +
      'her user will need to be set as the primary contact before the u' +
      'ser can be deleted. '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
    WordWrap = True
  end
  object Label1: TLabel
    Left = 76
    Top = 69
    Width = 125
    Height = 18
    AutoSize = False
    Caption = 'New Primary Contact'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
    WordWrap = True
  end
  object Label2: TLabel
    Left = 76
    Top = 107
    Width = 215
    Height = 18
    AutoSize = False
    Caption = 'Are you sure you want to continue?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
    WordWrap = True
  end
  object btnYes: TButton
    Left = 297
    Top = 131
    Width = 75
    Height = 25
    Caption = '&Yes'
    ModalResult = 6
    TabOrder = 0
  end
  object btnNo: TButton
    Left = 380
    Top = 131
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&No'
    Default = True
    ModalResult = 7
    TabOrder = 1
  end
  object cmbPrimaryContact: TComboBox
    Left = 215
    Top = 66
    Width = 226
    Height = 21
    ItemHeight = 0
    TabOrder = 2
  end
end
