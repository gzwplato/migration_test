object frmCAF: TfrmCAF
  Left = 256
  Top = 163
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Client Authority Form'
  ClientHeight = 507
  ClientWidth = 628
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
  object Panel6: TPanel
    Left = 0
    Top = 466
    Width = 628
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    object btnPreview: TButton
      Left = 8
      Top = 8
      Width = 83
      Height = 25
      Hint = 'Preview the Client Authority Form'
      Caption = 'Preview'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnPreviewClick
    end
    object btnFile: TButton
      Left = 96
      Top = 8
      Width = 83
      Height = 25
      Hint = 'Save the Client Authority Form to a file'
      Caption = 'File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnFileClick
    end
    object btnCancel: TButton
      Left = 536
      Top = 8
      Width = 83
      Height = 25
      Hint = 'Close the Client Authority Form'
      Cancel = True
      Caption = 'Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = btnCancelClick
    end
    object btnPrint: TButton
      Left = 272
      Top = 8
      Width = 83
      Height = 25
      Hint = 'Print the Client Authority Form'
      Caption = 'Print'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnPrintClick
    end
    object btnEmail: TButton
      Left = 183
      Top = 8
      Width = 83
      Height = 25
      Hint = 'E-mail the Client Authority Form to the client'
      Caption = 'E-mail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnEmailClick
    end
    object btnClear: TButton
      Left = 448
      Top = 8
      Width = 83
      Height = 25
      Hint = 'Clear the form'
      Caption = 'Clear'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btnClearClick
    end
    object btnImport: TButton
      Left = 360
      Top = 8
      Width = 83
      Height = 25
      Caption = 'Import'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnImportClick
    end
  end
  object pnlMain: TPanel
    Left = 8
    Top = 8
    Width = 611
    Height = 449
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object pnlInstTop: TPanel
      Left = 0
      Top = 0
      Width = 607
      Height = 65
      Align = alTop
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        607
        65)
      object lblInstitution: TLabel
        Left = 24
        Top = 22
        Width = 60
        Height = 16
        Caption = 'Institution :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblInstitutionOther: TLabel
        Left = 24
        Top = 46
        Width = 563
        Height = 16
        Caption = 
          #39'Other'#39' is for provisional accounts. For non-provisional account' +
          's, please select a valid institution.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object cmbInstitution: TComboBox
        Left = 153
        Top = 16
        Width = 374
        Height = 24
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 0
        OnChange = cmbInstitutionChange
      end
      object edtInstitutionName: TEdit
        Left = 267
        Top = 16
        Width = 260
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 50
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Visible = False
      end
    end
    object pnlInstitution: TPanel
      Left = 0
      Top = 65
      Width = 607
      Height = 133
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object pnlInstData: TPanel
        Left = 145
        Top = 1
        Width = 387
        Height = 131
        Align = alClient
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        DesignSize = (
          387
          131)
        object lblAccountHintLine: TLabel
          Left = 8
          Top = 75
          Width = 374
          Height = 31
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'Account Hint Line'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          ExplicitWidth = 379
        end
        object edtBranch: TEdit
          Left = 8
          Top = 0
          Width = 374
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 100
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnExit = edtExit
        end
        object edtNameOfAccount: TEdit
          Left = 7
          Top = 45
          Width = 374
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 100
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnEnter = edtExit
        end
        object mskAccountNumber: TMaskValidateEdit
          Left = 8
          Top = 106
          Width = 373
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          AutoSelect = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnEnter = mskAccountNumberEnter
          OnExit = mskAccountNumberExit
          OnKeyUp = mskAccountNumberKeyUp
          OnMouseDown = mskAccountNumberMouseDown
          OnValidateError = mskAccountNumberValidateError
          OnValidateEdit = mskAccountNumberValidateEdit
        end
        object edtAccountNumber: TEdit
          Left = 8
          Top = 106
          Width = 374
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 20
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnExit = edtAccountNumberExit
        end
      end
      object pnlInstLabels: TPanel
        Left = 1
        Top = 1
        Width = 144
        Height = 131
        Align = alLeft
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object lblBranch: TLabel
          Left = 24
          Top = 5
          Width = 48
          Height = 16
          Caption = 'Branch :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblAccount: TLabel
          Left = 24
          Top = 109
          Width = 105
          Height = 16
          Caption = 'Account Number :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblNameOfAccount: TLabel
          Left = 21
          Top = 48
          Width = 108
          Height = 16
          Caption = 'Name of Account :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
      end
      object pnlInstSpacer: TPanel
        Left = 532
        Top = 1
        Width = 74
        Height = 131
        Align = alRight
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
      end
    end
    object pnlClient: TPanel
      Left = 0
      Top = 225
      Width = 607
      Height = 118
      Align = alTop
      TabOrder = 2
      object pnlClientLabel: TPanel
        Left = 1
        Top = 1
        Width = 144
        Height = 116
        Align = alLeft
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object lblCostCode: TLabel
          Left = 24
          Top = 46
          Width = 69
          Height = 16
          Caption = 'Cost Code :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblClientCode: TLabel
          Left = 24
          Top = 5
          Width = 75
          Height = 16
          Caption = 'Client Code :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblStartDate: TLabel
          Left = 24
          Top = 94
          Width = 65
          Height = 16
          Caption = 'Start Date :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
      end
      object pnlClientData: TPanel
        Left = 145
        Top = 1
        Width = 117
        Height = 116
        Align = alClient
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        DesignSize = (
          117
          116)
        object edtClientCode: TEdit
          Left = 8
          Top = 0
          Width = 103
          Height = 24
          Hint = 'The client code from BankLink or your general ledger'
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 8
          ParentFont = False
          TabOrder = 0
          OnExit = edtExit
          OnKeyPress = edtKeyPress
        end
        object edtClientStartDte: TOvcPictureField
          Left = 6
          Top = 88
          Width = 85
          Height = 24
          Cursor = crIBeam
          DataType = pftDate
          AutoSize = False
          CaretOvr.Shape = csBlock
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Epoch = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          InitDateTime = False
          MaxLength = 8
          Options = [efoCaretToEnd]
          ParentFont = False
          PictureMask = 'DD/mm/yy'
          TabOrder = 2
          RangeHigh = {25600D00000000000000}
          RangeLow = {00000000000000000000}
        end
        object edtCostCode: TEdit
          Left = 8
          Top = 45
          Width = 103
          Height = 24
          Hint = 'The cost code from your practice management or billing system'
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 10
          ParentFont = False
          TabOrder = 1
          OnExit = edtExit
          OnKeyPress = edtKeyPress
        end
      end
      object pnlClientSpacer: TPanel
        Left = 262
        Top = 1
        Width = 344
        Height = 116
        Align = alRight
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
      end
    end
    object pnlData: TPanel
      Left = 0
      Top = 343
      Width = 607
      Height = 104
      Align = alTop
      Color = clWhite
      ParentBackground = False
      TabOrder = 3
      DesignSize = (
        607
        104)
      object lblRecieved: TLabel
        Left = 261
        Top = 27
        Width = 111
        Height = 16
        Caption = 'To be received in :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblSecureCode: TLabel
        Left = 261
        Top = 72
        Width = 85
        Height = 16
        Caption = 'Secure Code :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object chkExistingClient: TCheckBox
        Left = 22
        Top = 72
        Width = 162
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Existing Client'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = chkExistingClientClick
      end
      object chkDataToClient: TCheckBox
        Left = 22
        Top = 27
        Width = 157
        Height = 17
        Hint = 'For BankLink Books Secure or BankLink Online Secure clients'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Data sent direct to client'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = chkDataToClientClick
      end
      object cmbRecieved: TComboBox
        Left = 381
        Top = 25
        Width = 205
        Height = 24
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 1
      end
      object edtSecureCode: TEdit
        Left = 381
        Top = 70
        Width = 205
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 8
        ParentFont = False
        TabOrder = 3
      end
    end
    object pnlAccountError: TPanel
      Left = 0
      Top = 198
      Width = 607
      Height = 27
      Align = alTop
      TabOrder = 4
      object lblAccountValidationError: TLabel
        Left = 1
        Top = 4
        Width = 608
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'Account Error hint'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object Opendlg: TOpenDialog
    Filter = 'Excel file*.xls|*.xls'
    Left = 8
    Top = 8
  end
end
