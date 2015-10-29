object RecommendedMemorisationsFrm: TRecommendedMemorisationsFrm
  Left = 0
  Top = 0
  Caption = 'Suggested Memorisations for '
  ClientHeight = 448
  ClientWidth = 696
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 534
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 408
    Width = 696
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      696
      40)
    object btnClose: TButton
      Left = 611
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
    end
    object btnCreate: TButton
      Left = 530
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Create'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnCreateClick
    end
    object chkAllowSuggMemPopup: TCheckBox
      Left = 89
      Top = 14
      Width = 435
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Allow Suggested Memorisation '#39'Pop-up'#39
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object btnHide: TButton
      Left = 8
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Hide'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnHideClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 696
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblBankAccount: TLabel
      Left = 8
      Top = 8
      Width = 85
      Height = 16
      Caption = 'lblBankAccount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnlLayout1: TPanel
    Left = 0
    Top = 33
    Width = 696
    Height = 375
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pnlLayout2: TPanel
      Left = 0
      Top = 0
      Width = 696
      Height = 375
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        696
        375)
      object tblSuggMems: TOvcTable
        Left = 0
        Top = 0
        Width = 696
        Height = 375
        RowLimit = 2
        LockedCols = 0
        LeftCol = 0
        ActiveCol = 0
        Access = otxReadOnly
        Align = alClient
        Color = clWindow
        Colors.ActiveUnfocused = clBtnFace
        Colors.ActiveUnfocusedText = clWindowText
        Colors.Locked = clGray
        Colors.LockedText = clWhite
        Colors.Editing = clWindow
        Controller = cntSuggMems
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        GridPenSet.NormalGrid.NormalColor = clSilver
        GridPenSet.NormalGrid.SecondColor = clWhite
        GridPenSet.NormalGrid.Style = psSolid
        GridPenSet.NormalGrid.Effect = geVertical
        GridPenSet.LockedGrid.NormalColor = clBtnShadow
        GridPenSet.LockedGrid.Style = psSolid
        GridPenSet.LockedGrid.Effect = ge3D
        GridPenSet.CellWhenFocused.NormalColor = clBlack
        GridPenSet.CellWhenFocused.Style = psSolid
        GridPenSet.CellWhenFocused.Effect = geBoth
        GridPenSet.CellWhenUnfocused.NormalColor = clWindowText
        GridPenSet.CellWhenUnfocused.Style = psSolid
        GridPenSet.CellWhenUnfocused.Effect = geBoth
        LockedRowsCell = hdrSuggMems
        Options = [otoTabToArrow, otoEnterToArrow, otoRowSelection]
        ParentCtl3D = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        OnActiveCellChanged = tblSuggMemsActiveCellChanged
        OnDblClick = tblSuggMemsDblClick
        OnGetCellData = tblSuggMemsGetCellData
        OnGetCellAttributes = tblSuggMemsGetCellAttributes
        OnLeavingRow = tblSuggMemsLeavingRow
        OnLockedCellClick = tblSuggMemsLockedCellClick
        CellData = (
          'RecommendedMemorisationsFrm.hdrSuggMems')
        RowData = (
          21
          0
          False
          42)
        ColData = (
          90
          False
          True
          'RecommendedMemorisationsFrm.colEntryType'
          377
          False
          True
          'RecommendedMemorisationsFrm.colStatementDetails'
          72
          False
          True
          'RecommendedMemorisationsFrm.colCode'
          67
          False
          True
          'RecommendedMemorisationsFrm.colCodedMatch'
          67
          False
          True
          'RecommendedMemorisationsFrm.spi')
      end
      object pnlMessage: TPanel
        Left = 0
        Top = 143
        Width = 696
        Height = 90
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        Visible = False
        object lblMessage: TLabel
          Left = 0
          Top = 0
          Width = 696
          Height = 90
          Align = alClient
          Alignment = taCenter
          AutoSize = False
          Caption = 'Message'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitLeft = 8
          ExplicitTop = 24
          ExplicitHeight = 57
        end
      end
    end
  end
  object Images: TImageList
    Left = 480
    Bitmap = {
      494C010101000800FC0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000909090007070
      7000707070007070700070707000707070007070700070707000707070007070
      7000707070009090900000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009090900090909000DADA
      DA00DADADA00DADADA00DADADA00DADADA00DADADA00DADADA00DADADA00DADA
      DA00DADADA009090900090909000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000090909000DADADA00DADA
      DA00DADADA00DADADA00DADADA00DADADA00DADADA00DADADA00DADADA00DADA
      DA00DADADA00DADADA0090909000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000DADADA00DADA
      DA00DADADA00DADADA00DADADA000000000000000000DADADA00DADADA00DADA
      DA00DADADA00DADADA0070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000DADADA00DADA
      DA00DADADA00DADADA00DADADA000000000000000000DADADA00DADADA00DADA
      DA00DADADA00D8D8D80070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000DADADA00DADA
      DA00DADADA00DADADA00DADADA000000000000000000DADADA00DADADA00DADA
      DA00DADADA00DADADA0070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000DADADA00DADA
      DA00000000000000000000000000000000000000000000000000000000000000
      0000DADADA00DBDBDB0070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000ECECEC00ECEC
      EC00000000000000000000000000000000000000000000000000000000000000
      0000ECECEC00ECECEC0070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000ECECEC00ECEC
      EC00ECECEC00ECECEC00ECECEC000000000000000000ECECEC00ECECEC00ECEC
      EC00ECECEC00EBEBEB0070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000ECECEC00ECEC
      EC00ECECEC00ECECEC00ECECEC000000000000000000ECECEC00ECECEC00ECEC
      EC00ECECEC00ECECEC0070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000ECECEC00ECEC
      EC00ECECEC00ECECEC00ECECEC000000000000000000ECECEC00ECECEC00ECEC
      EC00ECECEC00EDEDED0070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000ECECEC00ECEC
      EC00ECECEC00ECECEC00ECECEC00ECECEC00ECECEC00ECECEC00ECECEC00ECEC
      EC00ECECEC00ECECEC0070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009090900090909000ECEC
      EC00ECECEC00ECECEC00ECECEC00ECECEC00ECECEC00ECECEC00ECECEC00ECEC
      EC00ECECEC009090900090909000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000909090007070
      7000707070007070700070707000707070007070700070707000707070007070
      7000707070009090900000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000C003000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      C003000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object hdrSuggMems: TOvcTCColHead
    Headings.Strings = (
      'Entry Type'
      'Statement Details'
      'Code'
      'Coded Matches'
      'Uncoded Matches')
    ShowLetters = False
    Table = tblSuggMems
    UseWordWrap = True
    OnClick = hdrSuggMemsClick
    OnOwnerDraw = hdrSuggMemsOwnerDraw
    Left = 80
    Top = 122
  end
  object cntSuggMems: TOvcController
    EntryCommands.TableList = (
      'Grid'
      True
      (
        113
        0))
    Epoch = 1900
    Left = 42
    Top = 120
  end
  object colStatementDetails: TOvcTCString
    Adjust = otaCenterLeft
    MaxLength = 10
    ShowHint = True
    Table = tblSuggMems
    OnOwnerDraw = colStatementDetailsOwnerDraw
    Left = 80
    Top = 169
  end
  object colCodedMatch: TOvcTCString
    Adjust = otaCenterLeft
    MaxLength = 10
    ShowHint = True
    Table = tblSuggMems
    OnOwnerDraw = colCodedMatchOwnerDraw
    Left = 144
    Top = 169
  end
  object colCode: TOvcTCString
    Adjust = otaCenterLeft
    MaxLength = 10
    ShowHint = True
    Table = tblSuggMems
    OnOwnerDraw = colCodeOwnerDraw
    Left = 112
    Top = 169
  end
  object colEntryType: TOvcTCString
    Adjust = otaCenterLeft
    MaxLength = 10
    ShowHint = True
    Table = tblSuggMems
    OnOwnerDraw = colEntryTypeOwnerDraw
    Left = 48
    Top = 169
  end
  object spi: TOvcTCString
    Adjust = otaCenterLeft
    MaxLength = 10
    ShowHint = True
    Table = tblSuggMems
    OnOwnerDraw = spiOwnerDraw
    Left = 176
    Top = 169
  end
end
