object dlgCashflowOptions: TdlgCashflowOptions
  Left = 304
  Top = 245
  BorderStyle = bsDialog
  Caption = 'Custom Cash Flow Reports'
  ClientHeight = 482
  ClientWidth = 632
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShortCut = FormShortCut
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 447
    Width = 632
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      632
      35)
    object btnPrint: TButton
      Left = 471
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Print'
      TabOrder = 4
      OnClick = btnPrintClick
    end
    object btnCancel: TButton
      Left = 551
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 5
      OnClick = btnCancelClick
    end
    object btnPreview: TButton
      Left = 10
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Previe&w'
      Default = True
      TabOrder = 0
      OnClick = btnPreviewClick
    end
    object btnFile: TButton
      Left = 90
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Fil&e'
      TabOrder = 1
      OnClick = btnFileClick
    end
    object BtnSave: TBitBtn
      Left = 391
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Sa&ve'
      TabOrder = 3
      OnClick = BtnSaveClick
    end
    object btnEmail: TButton
      Left = 171
      Top = 4
      Width = 75
      Height = 25
      Caption = 'E&mail'
      TabOrder = 2
      OnClick = btnEmailClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 632
    Height = 447
    ActivePage = tbsAdvanced
    Align = alClient
    TabOrder = 0
    object tbsOptions: TTabSheet
      Caption = '&Options'
      object pnlReportStyle: TPanel
        Left = 0
        Top = 0
        Width = 623
        Height = 145
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label6: TLabel
          Left = 8
          Top = 11
          Width = 60
          Height = 13
          Caption = 'Report Style'
          FocusControl = cmbStyle
        end
        object Label2: TLabel
          Left = 8
          Top = 51
          Width = 66
          Height = 13
          Caption = 'Report Period'
          FocusControl = cmbDetail
        end
        object Label1: TLabel
          Left = 296
          Top = 12
          Width = 104
          Height = 13
          Caption = 'Reporting Year Starts'
          FocusControl = cmbStartMonth
        end
        object Label5: TLabel
          Left = 296
          Top = 51
          Width = 70
          Height = 13
          Caption = 'Report Format'
        end
        object pnlPeriodDates: TPanel
          Left = 0
          Top = 75
          Width = 611
          Height = 61
          BevelOuter = bvNone
          TabOrder = 2
          object Label3: TLabel
            Left = 10
            Top = 8
            Width = 38
            Height = 13
            Caption = 'Starting'
          end
          object Label4: TLabel
            Left = 10
            Top = 38
            Width = 32
            Height = 13
            Caption = 'Ending'
            FocusControl = cmbPeriod
          end
          object stReportStarts: TLabel
            Left = 104
            Top = 8
            Width = 71
            Height = 13
            Caption = 'stReportStarts'
          end
          object lblLast: TLabel
            Left = 322
            Top = 38
            Width = 209
            Height = 13
            Caption = 'This last period of  CODED data is Dec 1998'
          end
          object cmbPeriod: TComboBox
            Left = 104
            Top = 34
            Width = 197
            Height = 22
            Style = csOwnerDrawFixed
            DropDownCount = 12
            ItemHeight = 16
            TabOrder = 0
            OnChange = cmbPeriodChange
            OnDrawItem = cmbPeriodDrawItem
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
              '10'
              '11'
              '12')
          end
        end
        object cmbDetail: TComboBox
          Left = 104
          Top = 48
          Width = 177
          Height = 21
          Style = csDropDownList
          DropDownCount = 10
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 1
          Text = 'One Month'
          OnChange = cmbDetailChange
          Items.Strings = (
            'One Month'
            'Two Months'
            'Quarter'
            'Half Year'
            'Year'
            'Custom...')
        end
        object cmbStyle: TComboBox
          Left = 104
          Top = 8
          Width = 177
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = 'Single Period (Actual)'
          OnChange = cmbStyleChange
          Items.Strings = (
            'Single Period (Actual)'
            'Multiple Periods (12 Month Actual)'
            'Budget Remaining')
        end
        object cmbStartMonth: TComboBox
          Left = 430
          Top = 8
          Width = 90
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
          OnChange = cmbStartMonthChange
        end
        object spnStartYear: TRzSpinEdit
          Left = 528
          Top = 8
          Width = 73
          Height = 21
          Max = 2070.000000000000000000
          Min = 1980.000000000000000000
          Value = 2002.000000000000000000
          TabOrder = 5
          OnChange = spnStartYearChange
        end
        object rbDetailedFormat: TRadioButton
          Left = 430
          Top = 50
          Width = 75
          Height = 17
          Caption = 'De&tailed'
          Checked = True
          TabOrder = 6
          TabStop = True
          OnClick = ControlChange
        end
        object rbSummarisedFormat: TRadioButton
          Left = 512
          Top = 50
          Width = 105
          Height = 17
          Caption = '&Summarised'
          TabOrder = 7
          OnClick = ControlChange
        end
        object pnlCustomDates: TPanel
          Left = 0
          Top = 72
          Width = 369
          Height = 68
          BevelOuter = bvNone
          TabOrder = 3
          inline ecDateSelector: TfmeDateSelector
            Left = 0
            Top = 1
            Width = 366
            Height = 62
            TabOrder = 0
            TabStop = True
            ExplicitTop = 1
            ExplicitWidth = 366
            ExplicitHeight = 62
            inherited Label2: TLabel
              Left = 8
              Top = 11
              Width = 51
              Caption = 'Starting'
              FocusControl = nil
              ExplicitLeft = 8
              ExplicitTop = 11
              ExplicitWidth = 51
            end
            inherited btnPrev: TSpeedButton
              Left = 283
              ExplicitLeft = 283
            end
            inherited btnNext: TSpeedButton
              Left = 307
              ExplicitLeft = 307
            end
            inherited btnQuik: TSpeedButton
              Left = 336
              ExplicitLeft = 336
            end
            inherited Label3: TLabel
              Left = 8
              Top = 39
              Width = 52
              Caption = 'Ending'
              FocusControl = nil
              ExplicitLeft = 8
              ExplicitTop = 39
              ExplicitWidth = 52
            end
            inherited eDateFrom: TOvcPictureField
              Left = 104
              Width = 177
              Height = 23
              BorderStyle = bsSingle
              Epoch = 0
              ExplicitLeft = 104
              ExplicitWidth = 177
              ExplicitHeight = 23
              RangeHigh = {25600D00000000000000}
              RangeLow = {00000000000000000000}
            end
            inherited eDateTo: TOvcPictureField
              Left = 104
              Top = 37
              Width = 177
              Height = 24
              BorderStyle = bsSingle
              Epoch = 0
              ExplicitLeft = 104
              ExplicitTop = 37
              ExplicitWidth = 177
              ExplicitHeight = 24
              RangeHigh = {25600D00000000000000}
              RangeLow = {00000000000000000000}
            end
            inherited OvcController1: TOvcController
              EntryCommands.TableList = (
                'Default'
                True
                ()
                'WordStar'
                False
                ()
                'Grid'
                False
                ())
            end
          end
        end
      end
      object pnlCompare: TPanel
        Left = 0
        Top = 191
        Width = 623
        Height = 85
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        object chkCompare: TCheckBox
          Left = 8
          Top = 8
          Width = 185
          Height = 17
          Caption = 'Compare Actual &Values To'
          TabOrder = 0
          OnClick = ControlChange
        end
        object rbToBudget: TRadioButton
          Left = 340
          Top = 8
          Width = 79
          Height = 17
          Caption = '&Budget'
          Enabled = False
          TabOrder = 2
          OnClick = ControlChange
        end
        object rbToLastYear: TRadioButton
          Left = 200
          Top = 8
          Width = 81
          Height = 17
          Caption = '&Last Year'
          Checked = True
          Enabled = False
          TabOrder = 1
          TabStop = True
          OnClick = ControlChange
        end
        object chkIncludeVariance: TCheckBox
          Left = 8
          Top = 33
          Width = 225
          Height = 17
          Caption = 'Incl&ude Variance'
          Enabled = False
          TabOrder = 4
          OnClick = ControlChange
        end
        object chkIncludeYTD: TCheckBox
          Left = 8
          Top = 58
          Width = 257
          Height = 17
          Caption = 'I&nclude Year-to-Date'
          TabOrder = 5
          OnClick = ControlChange
        end
        object cmbBudget: TComboBox
          Left = 426
          Top = 6
          Width = 186
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemHeight = 13
          TabOrder = 3
          OnChange = ControlChange
          OnDropDown = cmbBudgetDropDown
        end
      end
      object pnlInclude: TPanel
        Left = 0
        Top = 279
        Width = 352
        Height = 55
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 3
        object chkIncludeQuantity: TCheckBox
          Left = 8
          Top = 30
          Width = 161
          Height = 17
          Caption = 'Include &Quantities'
          TabOrder = 1
        end
        object chkIncludeCodes: TCheckBox
          Left = 8
          Top = 7
          Width = 161
          Height = 17
          Caption = 'Include &Chart Codes'
          TabOrder = 0
        end
        object chkGSTInclusive: TCheckBox
          Left = 200
          Top = 7
          Width = 150
          Height = 17
          Caption = '&GST Inclusive'
          TabOrder = 2
        end
      end
      object pnlCashSummary: TPanel
        Left = 0
        Top = 337
        Width = 623
        Height = 34
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 5
        object chkIncludeCash: TCheckBox
          Left = 8
          Top = 7
          Width = 161
          Height = 17
          Caption = 'Include Cash on &Hand'
          TabOrder = 0
          OnClick = ControlChange
        end
        object rbDetailedCash: TRadioButton
          Left = 200
          Top = 7
          Width = 81
          Height = 17
          Caption = 'Deta&iled'
          Enabled = False
          TabOrder = 1
          OnClick = ControlChange
        end
        object rbSummarisedCash: TRadioButton
          Left = 340
          Top = 7
          Width = 113
          Height = 17
          Caption = 'Su&mmarised'
          Checked = True
          Enabled = False
          TabOrder = 2
          TabStop = True
          OnClick = ControlChange
        end
      end
      object pnlDivision: TPanel
        Left = 0
        Top = 148
        Width = 623
        Height = 40
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object Label8: TLabel
          Left = 8
          Top = 11
          Width = 17
          Height = 13
          Caption = 'Job'
        end
        object cbJobs: TComboBox
          Left = 104
          Top = 8
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          Sorted = True
          TabOrder = 0
          OnChange = ControlChange
        end
        object ckAllJobs: TCheckBox
          Left = 340
          Top = 11
          Width = 177
          Height = 17
          Caption = 'Include C&ompleted'
          TabOrder = 1
          OnClick = ckAllJobsClick
        end
      end
      object pnlAdvBudget: TPanel
        Left = 0
        Top = 374
        Width = 623
        Height = 37
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 6
        object chkPromptToUseBudget: TCheckBox
          Left = 8
          Top = 8
          Width = 578
          Height = 17
          Caption = 
            'P&rompt to use budgeted figures when no actual figures are avail' +
            'able.'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
      end
      object Panel3: TPanel
        Left = 355
        Top = 279
        Width = 268
        Height = 55
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 4
        object rbSummarisedNonPost: TRadioButton
          Left = 133
          Top = 30
          Width = 113
          Height = 17
          Caption = 'Summarised'
          TabOrder = 2
          OnClick = ControlChange
        end
        object rbDetailedNonPost: TRadioButton
          Left = 25
          Top = 30
          Width = 94
          Height = 17
          Caption = 'Detailed'
          Checked = True
          TabOrder = 1
          TabStop = True
          OnClick = ControlChange
        end
        object chkPrintNonPostingChartCodeTitles: TCheckBox
          Left = 8
          Top = 7
          Width = 253
          Height = 17
          Caption = 'Include Non-Posting Chart Code Titles'
          TabOrder = 0
          OnClick = ControlChange
        end
      end
    end
    object tbsAdvanced: TTabSheet
      Caption = '&Advanced'
      ImageIndex = 1
      object pnlAdvAccounts: TPanel
        Left = 0
        Top = 4
        Width = 623
        Height = 333
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'pnlAdvAccounts'
        TabOrder = 0
        inline fmeAccountSelector1: TfmeAccountSelector
          Left = 24
          Top = 12
          Width = 465
          Height = 245
          TabOrder = 0
          TabStop = True
          ExplicitLeft = 24
          ExplicitTop = 12
          ExplicitWidth = 465
          ExplicitHeight = 245
          inherited chkAccounts: TCheckListBox
            Height = 186
            OnClickCheck = ControlChange
            Ctl3D = True
            ExplicitHeight = 186
          end
          inherited btnSelectAllAccounts: TButton
            Caption = '&Select All'
            OnClick = fmeAccountSelector1btnSelectAllAccountsClick
          end
          inherited btnClearAllAccounts: TButton
            OnClick = fmeAccountSelector1btnClearAllAccountsClick
          end
        end
      end
    end
    object tbsDivisions: TTabSheet
      Caption = 'Divisions'
      ImageIndex = 2
      object Panel1: TPanel
        Left = 0
        Top = 4
        Width = 623
        Height = 333
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        inline fmeDivisionSelector1: TfmeDivisionSelector
          Left = 24
          Top = 12
          Width = 460
          Height = 269
          TabOrder = 0
          ExplicitLeft = 24
          ExplicitTop = 12
          inherited chkDivisions: TCheckListBox
            OnClick = ControlChange
          end
          inherited btnSelectAllDivisions: TButton
            OnClick = fmeDivisionSelector1btnSelectAllDivisionsClick
          end
          inherited btnClearAllDivisions: TButton
            OnClick = fmeDivisionSelector1btnClearAllDivisionsClick
          end
        end
      end
    end
  end
end
