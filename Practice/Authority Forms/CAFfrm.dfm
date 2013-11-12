object frmCAF: TfrmCAF
  Left = 256
  Top = 163
  BorderIcons = [biSystemMenu]
  Caption = 'Client Authority Form'
  ClientHeight = 431
  ClientWidth = 709
  Color = clBtnFace
  Constraints.MinWidth = 350
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 709
    Height = 390
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitTop = 2
    ExplicitHeight = 454
    object pnlMaskdata: TPanel
      Left = 0
      Top = 73
      Width = 705
      Height = 96
      Align = alTop
      TabOrder = 0
      ExplicitTop = 217
      ExplicitWidth = 688
      object lblEditMask: TLabel
        Left = 13
        Top = 6
        Width = 54
        Height = 13
        Caption = 'lblEditMask'
      end
      object lblEditText: TLabel
        Left = 13
        Top = 29
        Width = 49
        Height = 13
        Caption = 'lblEditText'
      end
      object lblText: TLabel
        Left = 13
        Top = 56
        Width = 31
        Height = 13
        Caption = 'lblText'
      end
    end
    object grpRural: TGroupBox
      Left = 0
      Top = 265
      Width = 705
      Height = 48
      Align = alTop
      Caption = 'Rural'
      TabOrder = 1
      Visible = False
      ExplicitTop = 169
      ExplicitWidth = 688
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 3
        Height = 13
      end
    end
    object pnlAccount: TPanel
      Left = 0
      Top = 169
      Width = 705
      Height = 96
      Align = alTop
      TabOrder = 2
      ExplicitTop = 73
      ExplicitWidth = 688
      object lblAcName: TLabel
        Left = 13
        Top = 10
        Width = 86
        Height = 13
        Caption = 'Name of Account '
      end
      object lblAcNum: TLabel
        Left = 13
        Top = 48
        Width = 83
        Height = 13
        Caption = 'Account Number '
      end
      object lblClient: TLabel
        Left = 416
        Top = 7
        Width = 57
        Height = 13
        Caption = 'Client Code '
      end
      object lblCost: TLabel
        Left = 416
        Top = 52
        Width = 52
        Height = 13
        Caption = 'Cost Code '
      end
      object lblAccountNumberLine: TLabel
        Left = 112
        Top = 64
        Width = 281
        Height = 21
        Alignment = taCenter
        AutoSize = False
      end
      object lblAccountNumberHint: TLabel
        Left = 232
        Top = 64
        Width = 3
        Height = 13
      end
      object lblAccountValidationError: TLabel
        Left = 112
        Top = 28
        Width = 118
        Height = 13
        Caption = 'lblAccountValidationError'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object edtAccountName: TEdit
        Left = 112
        Top = 6
        Width = 281
        Height = 21
        Hint = 'Enter the account name'
        MaxLength = 50
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnExit = edtExit
      end
      object edtClientCode: TEdit
        Left = 493
        Top = 6
        Width = 160
        Height = 21
        Hint = 'Enter the code your practice uses for this client'
        CharCase = ecUpperCase
        MaxLength = 8
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnExit = edtExit
        OnKeyPress = edtKeyPress
      end
      object edtCost1: TEdit
        Left = 493
        Top = 48
        Width = 160
        Height = 21
        Hint = 'Enter the cost code your practice uses for this client'
        CharCase = ecUpperCase
        MaxLength = 8
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnExit = edtExit
        OnKeyPress = edtKeyPress
      end
      object mskAccountNumber: TMaskEdit
        Left = 112
        Top = 45
        Width = 281
        Height = 21
        TabOrder = 2
        OnEnter = mskAccountNumberEnter
        OnExit = mskAccountNumberExit
        OnKeyUp = mskAccountNumberKeyUp
        OnMouseDown = mskAccountNumberMouseDown
      end
    end
    object pnlInstitution: TPanel
      Left = 0
      Top = 0
      Width = 705
      Height = 73
      Align = alTop
      TabOrder = 3
      ExplicitWidth = 688
      object lblInstitution: TLabel
        Left = 16
        Top = 11
        Width = 51
        Height = 13
        Caption = 'Institution :'
      end
      object Label2: TLabel
        Left = 16
        Top = 40
        Width = 3
        Height = 13
      end
      object cmbInstitutionName: TComboBox
        Left = 112
        Top = 8
        Width = 281
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        OnChange = cmbInstitutionNameChange
      end
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 390
    Width = 709
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    ExplicitTop = 707
    DesignSize = (
      709
      41)
    object btnPreview: TButton
      Left = 16
      Top = 8
      Width = 85
      Height = 25
      Hint = 'Preview the Client Authority Form'
      Caption = 'Preview'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnPreviewClick
    end
    object btnFile: TButton
      Left = 107
      Top = 8
      Width = 85
      Height = 25
      Hint = 'Save the Client Authority Form to a file'
      Caption = 'File'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnFileClick
    end
    object btnCancel: TButton
      Left = 616
      Top = 8
      Width = 85
      Height = 25
      Hint = 'Close the Client Authority Form'
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Close'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btnCancelClick
    end
    object btnPrint: TButton
      Left = 434
      Top = 8
      Width = 85
      Height = 25
      Hint = 'Print the Client Authority Form'
      Anchors = [akRight, akBottom]
      Caption = 'Print'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnPrintClick
    end
    object btnEmail: TButton
      Left = 197
      Top = 8
      Width = 85
      Height = 25
      Hint = 'E-mail the Client Authority Form to the client'
      Caption = 'E-mail'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnEmailClick
    end
    object btnClear: TButton
      Left = 525
      Top = 8
      Width = 85
      Height = 25
      Hint = 'Clear the form'
      Anchors = [akRight, akBottom]
      Caption = 'Reset Form'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnClearClick
    end
    object btnImport: TButton
      Left = 353
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Import'
      TabOrder = 6
      OnClick = btnImportClick
    end
  end
  object Opendlg: TOpenDialog
    Filter = 'Excel file*.xls|*.xls'
    Left = 304
    Top = 456
  end
end
