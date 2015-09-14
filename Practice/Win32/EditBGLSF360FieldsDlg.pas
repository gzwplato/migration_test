unit EditBGLSF360FieldsDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ovcbase, ovcef, ovcpb, ovcnf, MoneyDef,
  ovcpf, bkconst, Buttons, cxGraphics, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, OsFont, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls,
  BGLCapitalGainsFme, BGLFrankingFme, BGLInterestIncomeFme, BGLForeignTaxFme;

const
  // Transaction Type equivalent account numbers
  cttanDistribution = 23800;
  cttanDividend     = 23900;
  cttanInterest     = 25000;
  cttanShareTrade   = 70000;

type
  TTransactionTypes = (ttDistribution, ttDividend, ttInterest, ttShareTrade, ttOtherTx );

  TdlgEditBGLSF360Fields = class(TForm)
    pnlFooters: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pnlHeaderInfo: TPanel;
    lblDate: TLabel;
    lbldispDate: TLabel;
    lbldispAmount: TLabel;
    lblAmount: TLabel;
    lblNarration: TLabel;
    lbldispNarration: TLabel;
    btnClear: TButton;
    btnBack: TBitBtn;
    btnNext: TBitBtn;
    pnlTransactionInfo: TPanel;
    lblAccount: TLabel;
    cmbxAccount: TcxComboBox;
    btnChart: TSpeedButton;
    lblUnits: TLabel;
    nfUnits: TOvcNumericField;
    lblEntryType: TLabel;
    lbldispEntryType: TLabel;
    lblCashDate: TLabel;
    eCashDate: TOvcPictureField;
    lblAccrualDate: TLabel;
    eAccrualDate: TOvcPictureField;
    lblRecordDate: TLabel;
    eRecordDate: TOvcPictureField;
    pnlDistribution: TPanel;
    pcDistribution: TPageControl;
    tsAustralianIncome: TTabSheet;
    tsCapitalGains: TTabSheet;
    tsForeignIncome: TTabSheet;
    tsNonCashCapitalGains: TTabSheet;
    fmeFranking: TfmeBGLFranking;
    fmeInterestIncome: TfmeBGLInterestIncome;
    lblLessOtherAllowableTrustDeductions: TLabel;
    nfLessOtherAllowableTrustDeductions: TOvcNumericField;
    lpLessOtherAllowableTrustDeductions: TLabel;
    lblCGTConcession: TLabel;
    nfCGTConcession: TOvcNumericField;
    lpCGTConcession: TLabel;
    lpCGTCapitalLosses: TLabel;
    nfCGTCapitalLosses: TOvcNumericField;
    lblCGTCapitalLosses: TLabel;
    fmeBGLCashCapitalGainsTax: TfmeBGLCapitalGainsTax;
    fmeBGLNonCashCapitalGainsTax: TfmeBGLCapitalGainsTax;
    grpForeign: TGroupBox;
    lblForeignCGT: TLabel;
    lblTaxPaid: TLabel;
    lblBeforeDiscount: TLabel;
    lblIndexationMethod: TLabel;
    lblOtherMethod: TLabel;
    nfForeignCGTBeforeDiscount: TOvcNumericField;
    nfForeignCGTIndexationMethod: TOvcNumericField;
    nfForeignCGTOtherMethod: TOvcNumericField;
    nfTaxPaidBeforeDiscount: TOvcNumericField;
    nfTaxPaidIndexationMethod: TOvcNumericField;
    nfTaxPaidOtherMethod: TOvcNumericField;
    lblAssessableForeignSourceIncome: TLabel;
    nfAssessableForeignSourceIncome: TOvcNumericField;
    lpAssessableForeignSourceIncome: TLabel;
    lblOtherNetForeignSourceIncome: TLabel;
    nfOtherNetForeignSourceIncome: TOvcNumericField;
    lpOtherNetForeignSourceIncome: TLabel;
    lblCashDistribution: TLabel;
    nfCashDistribution: TOvcNumericField;
    lpCashDistribution: TLabel;
    lblTaxExemptedAmounts: TLabel;
    nfTaxExemptedAmounts: TOvcNumericField;
    lpTaxExemptedAmounts: TLabel;
    lblTaxFreeAmounts: TLabel;
    nfTaxFreeAmounts: TOvcNumericField;
    lpTaxFreeAmounts: TLabel;
    nfTaxDeferredAmounts: TOvcNumericField;
    lblTaxDeferredAmounts: TLabel;
    lpTaxDeferredAmounts: TLabel;
    fmeBGLForeignTax1: TfmeBGLForeignTax;
    pnlDividend: TPanel;
    fmeBGLFranking: TfmeBGLFranking;
    fmeBGLForeignTax2: TfmeBGLForeignTax;
    lpForeignIncome: TLabel;
    lblForeignIncome: TLabel;
    nfForeignIncome: TOvcNumericField;
    pnlInterest: TPanel;
    lblInterest: TLabel;
    nfInterest: TOvcNumericField;
    lpInterest: TLabel;
    lblOtherIncome: TLabel;
    nfOtherIncome: TOvcNumericField;
    lpOtherIncome: TLabel;
    lblTFNAmountsWithheld: TLabel;
    nfTFNAmountsWithheld: TOvcNumericField;
    lpTFNAmountsWithheld: TLabel;
    lblNonResidentWithholdingTax: TLabel;
    nfNonResidentWithholdingTax: TOvcNumericField;
    lpNonResidentWithholdingTax: TLabel;
    pnlShareTrade: TPanel;
    lblShareBrokerage: TLabel;
    nfShareBrokerage: TOvcNumericField;
    lpShareBrokerage: TLabel;
    lblShareConsideration: TLabel;
    nfShareConsideration: TOvcNumericField;
    lpShareConsideration: TLabel;
    lblShareGSTAmount: TLabel;
    nfShareGSTAmount: TOvcNumericField;
    lpShareGSTAmount: TLabel;
    lblShareGSTRate: TLabel;
    cmbxShareGSTRate: TcxComboBox;
    lpShareTradeUnits: TLabel;
    nfShareTradeUnits: TOvcNumericField;
    lblShareTradeUnits: TLabel;
    lblOtherExpenses: TLabel;
    nfOtherExpenses: TOvcNumericField;
    lpOtherExpenses: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure nfTFNCreditsKeyPress(Sender: TObject; var Key: Char);
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnChartClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmbxAccountPropertiesChange(Sender: TObject);
    procedure cmbxAccountPropertiesDrawItem(AControl: TcxCustomComboBox;
      ACanvas: TcxCanvas; AIndex: Integer; const ARect: TRect;
      AState: TOwnerDrawState);
    procedure cmbxAccountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure nfUnitsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure fmeFrankingnfFrankedChange(Sender: TObject);
    procedure fmeFrankingnfFrankingCreditsChange(Sender: TObject);
    procedure fmeFrankingbtnCalcClick(Sender: TObject);
    procedure fmeFrankingnfUnfrankedChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FReadOnly, FAutoPresSMinus: boolean;
    FMoveDirection: TFundNavigation;
    FTop, FLeft, FCurrentAccountIndex, FSkip: Integer;
    Glyph: TBitMap;
    FActualAmount: Money;
    FDate: Integer;
    FFrankPercentage: Boolean;
    crModified: Boolean;
    UFModified: Boolean;
    FRevenuePercentage: Boolean;
    FMemOnly: Boolean;
    fTranAccount : string;
    fTransactionType : TTransactionTypes;

    procedure SetReadOnly(const Value: boolean);
    procedure SetMoveDirection(const Value: TFundNavigation);
    function GetFrankPercentage : boolean;
    procedure SetFrankPercentage(const Value: boolean);
    procedure SetUpHelp;
    procedure SetRevenuePercentage(const Value: boolean);
    procedure SetMemOnly(const Value: boolean);
    procedure RefreshChartCodeCombo();
    procedure SetTransactionType( const Value : TTransactionTypes );
    procedure SetTranAccount( const Value : string );
    { Private declarations }
  public
    { Public declarations }
//    procedure InitializeForm( aTranAccount : string );

    procedure SetFields( mImputedCredit,
                         mTaxFreeDist,
                         mTaxExemptDist,
                         mTaxDeferredDist,
                         mTFNCredits,
                         mForeignIncome,
                         mForeignTaxCredits,
                         mCapitalGains,
                         mDiscountedCapitalGains,
                         mOtherExpenses,
                         mCapitalGainsOther,
                         mFranked,
                         mUnfranked,
                         mInterest,
                         mOtherIncome,
                         mOtherTrustDeductions,
                         mCGTConcessionAmount,
                         mForeignCGTBeforeDiscount,
                         mForeignCGTIndexationMethod,
                         mForeignCGTOtherMethod,
                         mTaxPaidBeforeDiscount,
                         mTaxPaidIndexationMethod,
                         mTaxPaidOtherMethod,
                         (* mCapitalGainsForeignDisc, *)
                         mOtherNetForeignSourceIncome,
                         mCashDistribution,
                         mAUFrankingCreditsFromNZCompany,
                         mNonResidentWithholdingTax,
                         mLICDeductions,
                         mNon_Cash_CGT_Discounted_Before_Discount,
                         mNon_Cash_CGT_Indexation,
                         mNon_Cash_CGT_Other,
                         mNon_Cash_CGT_Capital_Losses,
                         mShareBrokerage,
                         mShareConsideration,
                         mShareGSTAmount : Money;
                         dCGTDate: integer;
                         mComponent : byte;
                         mUnits: Money;
                         mAccount,
                         mShareGSTRate: shortstring);

    procedure SetInfo(iDate : integer; sNarration: string; mAmount : Money);

    function GetFields( var mImputedCredit : Money;
                        var mTaxFreeDist : Money;
                        var mTaxExemptDist : Money;
                        var mTaxDeferredDist : Money;
                        var mTFNCredits : Money;
                        var mForeignIncome : Money;
                        var mForeignTaxCredits : Money;
                        var mCapitalGains : Money;
                        var mDiscountedCapitalGains : Money;
                        var mOtherExpenses : Money;
                        var mCapitalGainsOther : Money;
                        var mFranked : Money;
                        var mUnfranked : Money;
                        var mInterest : Money;
                        var mOtherIncome : Money;
                        var mOtherTrustDeductions : Money;
                        var mCGTConcessionAmount : Money;
                        var mForeignCGTBeforeDiscount : Money;
                        var mForeignCGTIndexationMethod : Money;
                        var mForeignCGTOtherMethod : Money;
                        var mTaxPaidBeforeDiscount : Money;
                        var mTaxPaidIndexationMethod : Money;
                        var mTaxPaidOtherMethod : Money;
                         (* mCapitalGainsForeignDisc, *)
                        var mOtherNetForeignSourceIncome : Money;
                        var mCashDistribution : Money;
                        var mAUFrankingCreditsFromNZCompany : Money;
                        var mNonResidentWithholdingTax : Money;
                        var mLICDeductions : Money;
                        var mNon_Cash_CGT_Discounted_Before_Discount : Money;
                        var mNon_Cash_CGT_Indexation : Money;
                        var mNon_Cash_CGT_Other : Money;
                        var mNon_Cash_CGT_Capital_Losses : Money;
                        var mShareBrokerage : Money;
                        var mShareConsideration : Money;
                        var mShareGSTAmount : Money;
                        var dCGTDate: integer;
                        var mComponent : byte;
                        var mUnits: Money;
                        var mAccount: shortstring;
                        var mShareGSTRate: shortstring) : boolean;

    property ReadOnly : boolean read FReadOnly write SetReadOnly;
    property MoveDirection : TFundNavigation read FMoveDirection write SetMoveDirection;
    property FormTop: Integer read FTop write FTop;
    property FormLeft: Integer read FLeft write FLeft;
    property FrankPercentage: boolean read GetFrankPercentage write SetFrankPercentage;
    property RevenuePercentage: boolean read FRevenuePercentage write SetRevenuePercentage;
    property MemOnly: boolean read FMemOnly write SetMemOnly;
    property TranAccount : string read fTranAccount write SetTranAccount;
    property TransactionType : TTransactionTypes read fTransactionType write SetTransactionType;
  end;

//******************************************************************************
implementation
uses
  glConst,
  bkDateUtils,
  GenUtils,
  bkXPThemes,
  SelectDate,
  WarningMoreFrm,
  SuperFieldsutils,
  AccountLookupFrm, BKDefs, Globals, imagesfrm, bkhelp;

{$R *.dfm}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function TdlgEditBGLSF360Fields.GetFields( var mImputedCredit : Money;
                        var mTaxFreeDist : Money;
                        var mTaxExemptDist : Money;
                        var mTaxDeferredDist : Money;
                        var mTFNCredits : Money;
                        var mForeignIncome : Money;
                        var mForeignTaxCredits : Money;
                        var mCapitalGains : Money;
                        var mDiscountedCapitalGains : Money;
                        var mOtherExpenses : Money;
                        var mCapitalGainsOther : Money;
                        var mFranked : Money;
                        var mUnfranked : Money;
                        var mInterest : Money;
                        var mOtherIncome : Money;
                        var mOtherTrustDeductions : Money;
                        var mCGTConcessionAmount : Money;
                        var mForeignCGTBeforeDiscount : Money;
                        var mForeignCGTIndexationMethod : Money;
                        var mForeignCGTOtherMethod : Money;
                        var mTaxPaidBeforeDiscount : Money;
                        var mTaxPaidIndexationMethod : Money;
                        var mTaxPaidOtherMethod : Money;
                         (* mCapitalGainsForeignDisc, *)
                        var mOtherNetForeignSourceIncome : Money;
                        var mCashDistribution : Money;
                        var mAUFrankingCreditsFromNZCompany : Money;
                        var mNonResidentWithholdingTax : Money;
                        var mLICDeductions : Money;
                        var mNon_Cash_CGT_Discounted_Before_Discount : Money;
                        var mNon_Cash_CGT_Indexation : Money;
                        var mNon_Cash_CGT_Other : Money;
                        var mNon_Cash_CGT_Capital_Losses : Money;
                        var mShareBrokerage : Money;
                        var mShareConsideration : Money;
                        var mShareGSTAmount : Money;
                        var dCGTDate: integer;
                        var mComponent : byte;
                        var mUnits: Money;
                        var mAccount: shortstring;
                        var mShareGSTRate: shortstring) : boolean;
(*function TdlgEditBGLSF360Fields.GetFields(var mImputedCredit,
                         mTaxFreeDist,
                         mTaxExemptDist,
                         mTaxDeferredDist,
                         mTFNCredits,
                         mForeignIncome,
                         mForeignTaxCredits,
                         mCapitalGains,
                         mDiscountedCapitalGains,
                         mOtherExpenses,
                         mCapitalGainsOther,
                         mFranked,
                         mUnfranked,
                         mInterest,
                         mOtherIncome,
                         mOtherTrustDeductions,
                         mCGTConcessionAmount,
                         mForeignCGTBeforeDiscount,
                         mForeignCGTIndexationMethod,
                         mForeignCGTOtherMethod,
                         mTaxPaidBeforeDiscount,
                         mTaxPaidIndexationMethod,
                         mTaxPaidOtherMethod,
                         {mCapitalGainsForeignDisc,}
                         mOtherNetForeignSourceIncome,
                         mCashDistribution,
                         mAUFrankingCreditsFromNZCompany,
                         mNonResidentWithholdingTax,
                         mLICDeductions,
                         mNon_Cash_CGT_Discounted_Before_Discount,
                         mNon_Cash_CGT_Indexation,
                         mNon_Cash_CGT_Other,
                         mNon_Cash_CGT_Capital_Losses,
                         mShareBrokerage,
                         mShareConsideration,
                         mShareGSTAmount : Money;
                         var dCGTDate: integer;
                         var mComponent : byte;
                         var mUnits: Money;
                         var mAccount,
                         mShareGSTRate: shortstring ) : boolean; *)
//- - - - - - - - - - - - - - - - - - - -
// Purpose:     take the values from the form and return into vars
//
// Parameters:
//
// Result:      Returns true if any of the fields are no zero
//- - - - - - - - - - - - - - - - - - - -
var
  ChartIndex : integer;
begin

  case TransactionType of
    ttDistribution : begin
    // ** Panel Distribution Panel **
      // Australian Income Tab
      if assigned( fmeFranking ) then begin
        mFranked := GetNumericValue(fmeFranking.nfFranked,              RevenuePercentage);
        mUnfranked := GetNumericValue(fmeFranking.nfUnfranked,            RevenuePercentage);
        mImputedCredit := GetNumericValue(fmeFranking.nfFrankingCredits,      RevenuePercentage);
      end;

      if assigned( fmeInterestIncome ) then begin
        mInterest := GetNumericValue(fmeInterestIncome.nfInterest,       RevenuePercentage);
        mOtherIncome := GetNumericValue(fmeInterestIncome.nfOtherIncome,    RevenuePercentage);
      end;
      mOtherTrustDeductions := GetNumericValue(nfLessOtherAllowableTrustDeductions,  RevenuePercentage);
      // Capital Gains Tab
      mCapitalGains := GetNumericValue(fmeBGLCashCapitalGainsTax.nfCGTIndexation, RevenuePercentage);
      mDiscountedCapitalGains := GetNumericValue(fmeBGLCashCapitalGainsTax.nfCGTDiscounted, RevenuePercentage);
      mCapitalGainsOther := GetNumericValue(fmeBGLCashCapitalGainsTax.nfCGTOther, RevenuePercentage);
      mCGTConcessionAmount := GetNumericValue(nfCGTConcession,                      RevenuePercentage);

      mForeignCGTBeforeDiscount := GetNumericValue(nfForeignCGTBeforeDiscount,           RevenuePercentage);
      mForeignCGTIndexationMethod := GetNumericValue(nfForeignCGTIndexationMethod,         RevenuePercentage);
      mForeignCGTOtherMethod := GetNumericValue(nfForeignCGTOtherMethod,              RevenuePercentage);

      mTaxPaidBeforeDiscount := GetNumericValue(nfTaxPaidBeforeDiscount,              RevenuePercentage);
      mTaxPaidIndexationMethod := GetNumericValue(nfTaxPaidIndexationMethod,            RevenuePercentage);
      mTaxPaidOtherMethod := GetNumericValue(nfTaxPaidOtherMethod,                 RevenuePercentage);

      //Foreign Income Tab
      mForeignIncome := GetNumericValue(nfAssessableForeignSourceIncome,      RevenuePercentage);
      mOtherNetForeignSourceIncome := GetNumericValue(nfOtherNetForeignSourceIncome,        RevenuePercentage);
      mCashDistribution := GetNumericValue(nfCashDistribution,                   RevenuePercentage);

      if assigned( fmeBGLForeignTax1 ) then begin
        mForeignTaxCredits := GetNumericValue(fmeBGLForeignTax1.nfForeignIncomeTaxOffset, RevenuePercentage);
        mAUFrankingCreditsFromNZCompany := GetNumericValue(fmeBGLForeignTax1.nfAUFrankingCreditsFromNZCompany, RevenuePercentage);
        mTFNCredits := GetNumericValue(fmeBGLForeignTax1.nfTFNAmountsWithheld, RevenuePercentage);

        mNonResidentWithholdingTax := GetNumericValue(fmeBGLForeignTax1.nfNonResidentWithholdingTax, RevenuePercentage);

        mLICDeductions := GetNumericValue(fmeBGLForeignTax1.nfLICDeductions, RevenuePercentage);

      end;

      mTaxFreeDist := GetNumericValue(nfTaxFreeAmounts,                     RevenuePercentage);
      mTaxExemptDist := GetNumericValue(nfTaxExemptedAmounts,                 RevenuePercentage);
      mTaxDeferredDist := GetNumericValue(nfTaxDeferredAmounts,                 RevenuePercentage);
      mOtherExpenses := GetNumericValue(nfOtherExpenses,                      RevenuePercentage);

      //Non-Cash Capital Gains/Loses
      if assigned( fmeBGLNonCashCapitalGainsTax ) then begin
        mNon_Cash_CGT_Discounted_Before_Discount := GetNumericValue(fmeBGLNonCashCapitalGainsTax.nfCGTDiscounted, RevenuePercentage);
        mNon_Cash_CGT_Indexation := GetNumericValue(fmeBGLNonCashCapitalGainsTax.nfCGTIndexation, RevenuePercentage);
        mNon_Cash_CGT_Other := GetNumericValue(fmeBGLNonCashCapitalGainsTax.nfCGTOther, RevenuePercentage);
      end;
      mNon_Cash_CGT_Capital_Losses := GetNumericValue(nfCGTCapitalLosses, RevenuePercentage);
    end;
    ttShareTrade : begin
    // ** Panel Share Trade Panel **
      mShareBrokerage := GetNumericValue(nfShareBrokerage,     RevenuePercentage);
      mShareConsideration := GetNumericValue(nfShareConsideration, RevenuePercentage);
      mShareGSTAmount := GetNumericValue(nfShareGSTAmount,     RevenuePercentage);

      mShareGSTRate := cmbxShareGSTRate.Properties.Items[ cmbxShareGSTRate.ItemIndex ];
    end;
    ttInterest : begin
    // ** Panel Interest Panel **
      mInterest := GetNumericValue(nfInterest,                  RevenuePercentage);
      mOtherIncome := GetNumericValue(nfOtherIncome,               RevenuePercentage);
      mTFNCredits := GetNumericValue(nfTFNAmountsWithheld,        RevenuePercentage);
      mNonResidentWithholdingTax := GetNumericValue(nfNonResidentWithholdingTax, RevenuePercentage);
    end;
    ttDividend : begin
    // ** Panel Dividend Panel **
      if assigned( fmeBGLFranking ) then begin
        mFranked := GetNumericValue(fmeBGLFranking.nfFranked,         RevenuePercentage);
        mUnfranked := GetNumericValue(fmeBGLFranking.nfUnfranked,       RevenuePercentage);
        mImputedCredit := GetNumericValue(fmeBGLFranking.nfFrankingCredits, RevenuePercentage);
      end;
      mForeignIncome := GetNumericValue(nfForeignIncome,                       RevenuePercentage);
      if assigned( fmeBGLForeignTax2 ) then begin
        mForeignTaxCredits := GetNumericValue(fmeBGLForeignTax2.nfForeignIncomeTaxOffset,         RevenuePercentage);
        mAUFrankingCreditsFromNZCompany := GetNumericValue(fmeBGLForeignTax2.nfAUFrankingCreditsFromNZCompany, RevenuePercentage);
        mTFNCredits := GetNumericValue(fmeBGLForeignTax2.nfTFNAmountsWithheld,             RevenuePercentage);
        mNonResidentWithholdingTax := GetNumericValue(fmeBGLForeignTax2.nfNonResidentWithholdingTax,      RevenuePercentage);
        mLICDeductions := GetNumericValue(fmeBGLForeignTax2.nfLICDeductions,                  RevenuePercentage);
      end;
    end;
  end;
  if cmbxAccount.ItemIndex > 0 then
  begin
    ChartIndex := Integer(cmbxAccount.Properties.Items.Objects[cmbxAccount.ItemIndex]);
    mAccount := MyClient.clChart.Account_At(ChartIndex).chAccount_Code;
  end
  else
    mAccount := '';

  mUnits := nfUnits.AsFloat * 10000;


  Result := (* ( mImputedCredit <> 0) or
            ( mTaxFreeDist <> 0) or
            ( mTaxExemptDist <> 0) or
            ( mTaxDeferredDist <> 0) or
            ( mTFNCredits <> 0) or
            ( mForeignIncome <> 0) or
            ( mForeignTaxCredits <> 0) or
            ( mCapitalGains <> 0) or
            ( mDiscountedCapitalGains <> 0) or
            ( mCapitalGainsOther <> 0) or
            ( mOtherExpenses <> 0) or
            ( mFranked <> 0) or
            ( mUnfranked <> 0) or *)

            ( mImputedCredit <> 0) or
            ( mTaxFreeDist <> 0) or
            ( mTaxExemptDist <> 0) or
            ( mTaxDeferredDist <> 0) or
            ( mTFNCredits <> 0) or
            ( mForeignIncome <> 0) or
            ( mForeignTaxCredits <> 0) or
            ( mCapitalGains <> 0) or
            ( mDiscountedCapitalGains <> 0) or
            ( mOtherExpenses <> 0) or
            ( mCapitalGainsOther <> 0) or
            ( mFranked <> 0) or
            ( mUnfranked <> 0) or
            ( mInterest <> 0) or
            ( mOtherIncome <> 0) or
            ( mOtherTrustDeductions <> 0) or
            ( mCGTConcessionAmount <> 0) or
            ( mForeignCGTBeforeDiscount <> 0) or
            ( mForeignCGTIndexationMethod <> 0) or
            ( mForeignCGTOtherMethod <> 0) or
            ( mTaxPaidBeforeDiscount <> 0) or
            ( mTaxPaidIndexationMethod <> 0) or
            ( mTaxPaidOtherMethod <> 0) or
            {mCapitalGainsForeignDisc,}
            ( mOtherNetForeignSourceIncome <> 0) or
            ( mCashDistribution <> 0) or
            ( mAUFrankingCreditsFromNZCompany <> 0) or
            ( mNonResidentWithholdingTax <> 0) or
            ( mLICDeductions <> 0) or
            ( mNon_Cash_CGT_Discounted_Before_Discount <> 0) or
            ( mNon_Cash_CGT_Indexation <> 0) or
            ( mNon_Cash_CGT_Other <> 0) or
            ( mNon_Cash_CGT_Capital_Losses <> 0) or
            ( mShareBrokerage <> 0) or
            ( mShareConsideration <> 0) or
            ( mShareGSTAmount <> 0) or
            ( dCGTDate <> 0) or
            ( mComponent <> 0) or
            ( mUnits <> 0) or
            ( mAccount <>  '' ) or
            ( mShareGSTRate <> '' );


            
(*  mTaxFreeDist := GetNumericValue(nfTaxFreeAmounts, RevenuePercentage);
  mTaxExemptDist := GetNumericValue(nfTaxExemptedAmounts, RevenuePercentage);
  mTaxDeferredDist := GetNumericValue(nfTaxDeferredAmounts, RevenuePercentage);
  mTFNCredits := GetNumericValue(nfTFNCredits, RevenuePercentage);
  mForeignIncome := GetNumericValue(nfForeignIncome, RevenuePercentage);
  mForeignTaxCredits := GetNumericValue(nfForeignTaxCredits, RevenuePercentage);
  mCapitalGains := GetNumericValue(nfCapitalGains, RevenuePercentage);
  mDiscountedCapitalGains := GetNumericValue(fmeBGLCashCapitalGainsTax.nfCGTDiscounted, RevenuePercentage);

  mOtherExpenses := GetNumericValue(nfOtherExpenses, RevenuePercentage);
  mCapitalGainsOther := GetNumericValue(nfCapitalGainsOther, RevenuePercentage);

  dCGTDate := stNull2Bk(eCGTDate.AsStDate);

  mFranked := GetNumericValue(fmeFranking.nfFranked, FrankPercentage);
  mUnfranked := GetNumericValue(fmeFranking.nfUnFranked, FrankPercentage);

  mImputedCredit := Double2Money(fmeFranking.nfFrankingCredits.AsFloat);

  mComponent := cmbMember.ItemIndex;

  if cmbxAccount.ItemIndex > 0 then
  begin
    ChartIndex := Integer(cmbxAccount.Properties.Items.Objects[cmbxAccount.ItemIndex]);
    mAccount := MyClient.clChart.Account_At(ChartIndex).chAccount_Code;
  end
  else
    mAccount := '';

  mUnits := nfUnits.AsFloat * 10000;

  if ((FActualAmount < 0) and (mUnits > 0)) or
     ((FActualAmount > 0) and (mUnits < 0)) then
    mUnits := -mUnits;

  Result := ( mImputedCredit <> 0) or
            ( mTaxFreeDist <> 0) or
            ( mTaxExemptDist <> 0) or
            ( mTaxDeferredDist <> 0) or
            ( mTFNCredits <> 0) or
            ( mForeignIncome <> 0) or
            ( mForeignTaxCredits <> 0) or
            ( mCapitalGains <> 0) or
            ( mDiscountedCapitalGains <> 0) or
            ( mCapitalGainsOther <> 0) or
            ( mOtherExpenses <> 0) or
            ( mFranked <> 0) or
            ( mUnfranked <> 0) or
            ( dCGTDate <> 0) or
            ( mComponent <> 0); *)
end;

//procedure TdlgEditBGLSF360Fields.InitializeForm( aTranAccount : string );
//begin
//end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgEditBGLSF360Fields.SetFields(
            mImputedCredit,
            mTaxFreeDist,
            mTaxExemptDist,
            mTaxDeferredDist,
            mTFNCredits,
            mForeignIncome,
            mForeignTaxCredits,
            mCapitalGains,
            mDiscountedCapitalGains,
            mOtherExpenses,
            mCapitalGainsOther,
            mFranked,
            mUnfranked,
            mInterest,
            mOtherIncome,
            mOtherTrustDeductions,
            mCGTConcessionAmount,
            mForeignCGTBeforeDiscount,
            mForeignCGTIndexationMethod,
            mForeignCGTOtherMethod,
            mTaxPaidBeforeDiscount,
            mTaxPaidIndexationMethod,
            mTaxPaidOtherMethod,
            (* mCapitalGainsForeignDisc, *)
            mOtherNetForeignSourceIncome,
            mCashDistribution,
            mAUFrankingCreditsFromNZCompany,
            mNonResidentWithholdingTax,
            mLICDeductions,
            mNon_Cash_CGT_Discounted_Before_Discount,
            mNon_Cash_CGT_Indexation,
            mNon_Cash_CGT_Other,
            mNon_Cash_CGT_Capital_Losses,
            mShareBrokerage,
            mShareConsideration,
            mShareGSTAmount: Money;
            dCGTDate: integer;
            mComponent : byte;
            mUnits: Money;
            mAccount,
            mShareGSTRate: shortstring);
begin

// ** Panel Distribution Panel **
  // Australian Income Tab
  if assigned( fmeFranking ) then begin
    SetNumericValue(fmeFranking.nfFranked,              mFranked, RevenuePercentage);
    SetNumericValue(fmeFranking.nfUnfranked,            mUnfranked, RevenuePercentage);
    SetNumericValue(fmeFranking.nfFrankingCredits,      mImputedCredit, RevenuePercentage);
  end;

  if assigned( fmeInterestIncome ) then begin
    SetNumericValue(fmeInterestIncome.nfInterest,       mInterest, RevenuePercentage);
    SetNumericValue(fmeInterestIncome.nfOtherIncome,    mOtherIncome, RevenuePercentage);
  end;
  SetNumericValue(nfLessOtherAllowableTrustDeductions,  mOtherTrustDeductions, RevenuePercentage);

  // Capital Gains Tab
  SetNumericValue(fmeBGLCashCapitalGainsTax.nfCGTIndexation,
    mCapitalGains, RevenuePercentage);
  SetNumericValue(fmeBGLCashCapitalGainsTax.nfCGTDiscounted,
    mDiscountedCapitalGains, RevenuePercentage);
  SetNumericValue(fmeBGLCashCapitalGainsTax.nfCGTOther,
    mCapitalGainsOther, RevenuePercentage);
  SetNumericValue(nfCGTConcession,                      mCGTConcessionAmount, RevenuePercentage);

  SetNumericValue(nfForeignCGTBeforeDiscount,           mForeignCGTBeforeDiscount, RevenuePercentage);
  SetNumericValue(nfForeignCGTIndexationMethod,         mForeignCGTIndexationMethod, RevenuePercentage);
  SetNumericValue(nfForeignCGTOtherMethod,              mForeignCGTOtherMethod, RevenuePercentage);

  SetNumericValue(nfTaxPaidBeforeDiscount,              mTaxPaidBeforeDiscount, RevenuePercentage);
  SetNumericValue(nfTaxPaidIndexationMethod,            mTaxPaidIndexationMethod, RevenuePercentage);
  SetNumericValue(nfTaxPaidOtherMethod,                 mTaxPaidOtherMethod, RevenuePercentage);

  //Foreign Income Tab
  SetNumericValue(nfAssessableForeignSourceIncome,      mForeignIncome, RevenuePercentage);
  SetNumericValue(nfOtherNetForeignSourceIncome,        mOtherNetForeignSourceIncome, RevenuePercentage);
  SetNumericValue(nfCashDistribution,                   mCashDistribution, RevenuePercentage);

  if assigned( fmeBGLForeignTax1 ) then begin
    SetNumericValue(fmeBGLForeignTax1.nfForeignIncomeTaxOffset,
      mForeignTaxCredits, RevenuePercentage);
    SetNumericValue(fmeBGLForeignTax1.nfAUFrankingCreditsFromNZCompany,
      mAUFrankingCreditsFromNZCompany, RevenuePercentage);
    SetNumericValue(fmeBGLForeignTax1.nfTFNAmountsWithheld,
      mTFNCredits, RevenuePercentage);

    SetNumericValue(fmeBGLForeignTax1.nfNonResidentWithholdingTax,
      mNonResidentWithholdingTax, RevenuePercentage);

    SetNumericValue(fmeBGLForeignTax1.nfLICDeductions,
      mLICDeductions, RevenuePercentage);

  end;

  SetNumericValue(nfTaxFreeAmounts,                     mTaxFreeDist, RevenuePercentage);
  SetNumericValue(nfTaxExemptedAmounts,                 mTaxExemptDist, RevenuePercentage);
  SetNumericValue(nfTaxDeferredAmounts,                 mTaxDeferredDist, RevenuePercentage);
  SetNumericValue(nfOtherExpenses,                      mOtherExpenses, RevenuePercentage);

  //Non-Cash Capital Gains/Loses
  if assigned( fmeBGLNonCashCapitalGainsTax ) then begin
    SetNumericValue(fmeBGLNonCashCapitalGainsTax.nfCGTDiscounted,
      mNon_Cash_CGT_Discounted_Before_Discount, RevenuePercentage);
    SetNumericValue(fmeBGLNonCashCapitalGainsTax.nfCGTIndexation,
      mNon_Cash_CGT_Indexation, RevenuePercentage);
    SetNumericValue(fmeBGLNonCashCapitalGainsTax.nfCGTOther,
      mNon_Cash_CGT_Other, RevenuePercentage);
  end;
  SetNumericValue(nfCGTCapitalLosses, mNon_Cash_CGT_Capital_Losses, RevenuePercentage);

// ** Panel Share Trade Panel **
  SetNumericValue(nfShareBrokerage,     mShareBrokerage, RevenuePercentage);
  SetNumericValue(nfShareConsideration, mShareConsideration, RevenuePercentage);
  SetNumericValue(nfShareGSTAmount,     mShareGSTAmount, RevenuePercentage);
  cmbxShareGSTRate.ItemIndex := cmbxShareGSTRate.Properties.Items.IndexOf(mShareGSTRate);

// ** Panel Interest Panel **
  SetNumericValue(nfInterest,                  mInterest, RevenuePercentage);
  SetNumericValue(nfOtherIncome,               mOtherIncome, RevenuePercentage);
  SetNumericValue(nfTFNAmountsWithheld,        mTFNCredits, RevenuePercentage);
  SetNumericValue(nfNonResidentWithholdingTax, mNonResidentWithholdingTax, RevenuePercentage);

// ** Panel Dividend Panel **
  if assigned( fmeBGLFranking ) then begin
    SetNumericValue(fmeBGLFranking.nfFranked,         mFranked, RevenuePercentage);
    SetNumericValue(fmeBGLFranking.nfUnfranked,       mUnfranked, RevenuePercentage);
    SetNumericValue(fmeBGLFranking.nfFrankingCredits, mImputedCredit, RevenuePercentage);
  end;
  SetNumericValue(nfForeignIncome,                       mForeignIncome, RevenuePercentage);
  if assigned( fmeBGLForeignTax2 ) then begin
    SetNumericValue(fmeBGLForeignTax2.nfForeignIncomeTaxOffset,         mForeignTaxCredits, RevenuePercentage);
    SetNumericValue(fmeBGLForeignTax2.nfAUFrankingCreditsFromNZCompany, mAUFrankingCreditsFromNZCompany, RevenuePercentage);
    SetNumericValue(fmeBGLForeignTax2.nfTFNAmountsWithheld,             mTFNCredits, RevenuePercentage);
    SetNumericValue(fmeBGLForeignTax2.nfNonResidentWithholdingTax,      mNonResidentWithholdingTax, RevenuePercentage);
    SetNumericValue(fmeBGLForeignTax2.nfLICDeductions,                  mLICDeductions, RevenuePercentage);
  end;

  TranAccount := mAccount;




  UFModified := ((mFranked <> 0) or (mUnfranked <> 0))
             and ((mFranked + mUnfranked) <> abs(FActualAmount));


  if not MemOnly then  begin
     SetNumericValue(fmeFranking.nfFrankingCredits, mImputedCredit, False);
     fmeFrankingnfFrankingCreditsChange(fmeFranking.nfFrankingCredits);
     SetNumericValue(nfTFNAmountsWithheld,        mTFNCredits, false);
     if assigned( fmeBGLForeignTax1 ) then begin
// DN Not sure if these on fmeBGLForeignTax1 and fmeBGLForeignTax2 map?
       SetNumericValue(fmeBGLForeignTax1.nfTFNAmountsWithheld,      mTFNCredits, RevenuePercentage);
       SetNumericValue(fmeBGLForeignTax1.nfForeignIncomeTaxOffset,  mForeignTaxCredits, RevenuePercentage);
     end;
     if assigned( fmeBGLForeignTax2 ) then begin
// DN Not sure if these on fmeBGLForeignTax2 and fmeBGLForeignTax1 map?
       SetNumericValue(fmeBGLForeignTax2.nfTFNAmountsWithheld,      mTFNCredits, RevenuePercentage);
       SetNumericValue(fmeBGLForeignTax2.nfForeignIncomeTaxOffset,  mForeignTaxCredits, RevenuePercentage);
     end;
  end;


// DN Not sure about whether these map?
  eCashDate.AsStDate := BkNull2St(dCGTDate);

  nfUnits.AsFloat := mUnits / 10000;

  TranAccount := mAccount;
  RefreshChartCodeCombo();
  FCurrentAccountIndex := cmbxAccount.ItemIndex;

  FAutoPressMinus := (FActualAmount < 0) and (mUnits = 0);
end;

function TdlgEditBGLSF360Fields.GetFrankPercentage: boolean;
begin
  result := false;
  if assigned( fmeFranking ) then
    result := fmeFranking.FrankPercentage;
end;

procedure TdlgEditBGLSF360Fields.SetFrankPercentage(const Value: boolean);
begin
  FFrankPercentage := Value;
  if assigned( fmeFranking ) then
    fmeFranking.FrankPercentage := Value;

(*DN Moved to Frame

   SetPercentLabel(lp1, FFrankPercentage);
   SetPercentLabel(lp2, FFrankPercentage);

   btnCalc.Visible := not FFrankPercentage;

   if FFrankPercentage then begin
      lblFranked.Caption := 'Percentage Franked';
      lblUnFranked.Caption := 'Percentage Unfranked';

   end else begin
      lblFranked.Caption := 'Franked Amount';
      lblUnFranked.Caption := 'Unfranked Amount';
   end; *)
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgEditBGLSF360Fields.FormCreate(Sender: TObject);
begin
  ThemeForm( Self);
  Self.HelpContext := BKH_Coding_transactions_for_BGL_Simple_Ledger;

  if MyClient.clFields.clAccounting_System_Used in [saBGLSimpleFund, saBGL360] then
     BKHelpSetUp(Self, BKH_Coding_transactions_for_BGL_Simple_Fund)
  else
     BKHelpSetUp(Self, BKH_Coding_transactions_for_BGL_Simple_Ledger );
  SetUpHelp;
  FReadOnly := false;
  Self.KeyPreview := True;
(*//DN  eCGTDate.Epoch       := BKDATEEPOCH;
  //DN eCGTDate.PictureMask := BKDATEFORMAT; *)
  FMoveDirection := fnNothing;
  FormTop := -999;
  FormLeft := -999;
  UFModified := False;
  FSkip := 0;
  Glyph := TBitMap.Create;
  ImagesFrm.AppImages.Maintain.GetBitmap( MAINTAIN_LOCK_BMP, Glyph );
  // showmember component options
//DN  cmbMember.Items.Clear;
end;

procedure TdlgEditBGLSF360Fields.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Glyph);
end;

procedure TdlgEditBGLSF360Fields.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F2) or ((Key = Ord('L')) and (Shift = [ssCtrl])) then
    btnChartClick(Sender);
end;

procedure TdlgEditBGLSF360Fields.FormShow(Sender: TObject);
begin
  if FTop > -999 then begin
     Top := FTop;
     Left := FLeft;
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgEditBGLSF360Fields.SetInfo( iDate : integer; sNarration: string; mAmount : Money);
var i: Integer;
begin
  lbldispDate.Caption := BkDate2Str( iDate);
  if RevenuePercentage then begin
     lbldispAmount.Caption := '100%';
     lblAmount.Caption := 'Total';
  end
  else begin
    lbldispAmount.Caption := Money2Str( mAmount);
    lblAmount.Caption := 'Amount';
  end;
  lbldispNarration.Caption := sNarration;
  FActualAmount := mAmount;
  FDate := iDate;
//DN  cmbMember.Items.Clear;
  if (fdate = 0)
  or (FDate >= mcSwitchDate) then
    for i := mcnewMin to mcnewMax do
//DN      cmbMember.Items.AddObject(mcNewNames[i], TObject(i))
  else
    for i := mcOldMin to mcOldMax do
//DN      cmbMember.Items.AddObject(mcOldNames[i], TObject(i))

end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgEditBGLSF360Fields.btnBackClick(Sender: TObject);
begin
  FMoveDirection := fnGoBack;
  ModalResult := mrOk;
end;

procedure TdlgEditBGLSF360Fields.btnChartClick(Sender: TObject);
var
  i: Integer;
  SelectedCode: string;
  HasChartBeenRefreshed : boolean;
begin
  SelectedCode := cmbxAccount.Text;
  if PickAccount(SelectedCode, HasChartBeenRefreshed) then
  begin
    if HasChartBeenRefreshed then
    begin
      cmbxAccount.Properties.Items.Clear;
      RefreshChartCodeCombo();
    end;

    for i := 0 to cmbxAccount.Properties.Items.Count-1 do
    begin
      if cmbxAccount.Properties.Items[i] = SelectedCode then
      begin
        cmbxAccount.ItemIndex := i;
        Break;
      end;
    end;
  end;
end;

procedure TdlgEditBGLSF360Fields.btnClearClick(Sender: TObject);
begin
  if assigned( fmeFranking ) then begin
    fmeFranking.nfFrankingCredits.AsFloat := 0;
    fmeFranking.nfFranked.AsFloat := 0;
    fmeFranking.nfUnFranked.AsFloat := 0;
    fmeFrankingnfFrankingCreditsChange(fmeFranking.nfFrankingCredits);
  end;
  nfTaxFreeAmounts.AsFloat := 0;
  nfTaxExemptedAmounts.AsFloat := 0;
  nfTaxDeferredAmounts.AsFloat := 0;
//DN  nfTFNCredits.AsFloat := 0;
  nfForeignIncome.AsFloat := 0;
//DN  nfForeignTaxCredits.AsFloat := 0;
//DN  nfCapitalGains.AsFloat := 0;
  if assigned( fmeBGLCashCapitalGainsTax ) then begin
    fmeBGLCashCapitalGainsTax.nfCGTDiscounted.AsFloat := 0;
  end;  
//DN  nfCapitalGainsOther.AsFloat := 0;
//DN  nfOtherExpenses.AsFloat := 0;
//DN  cmbMember.ItemIndex := 0;
//DN  eCGTDate.AsString := '';
  UFModified := False;
end;

procedure TdlgEditBGLSF360Fields.btnNextClick(Sender: TObject);
begin
  FMoveDirection := fnGoForward;
  ModalResult := mrOk;
end;

procedure TdlgEditBGLSF360Fields.cmbxAccountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) or (Key = VK_NEXT) then
    FSkip := 1
  else if (Key = VK_UP) or (Key = VK_PRIOR) then
    FSkip := -1
  else
    FSkip := 0;
end;

procedure TdlgEditBGLSF360Fields.cmbxAccountPropertiesChange(Sender: TObject);
var
  p: pAccount_Rec;
  ChartIndex : integer;
begin
  if cmbxAccount.ItemIndex < 1 then exit;

  ChartIndex := Integer(cmbxAccount.Properties.Items.Objects[cmbxAccount.ItemIndex]);

  p := MyClient.clChart.Account_At(ChartIndex);
  if not p.chPosting_Allowed then
  begin
    if FSkip = 1 then
    begin
      if cmbxAccount.Properties.Items.Count > FCurrentAccountIndex then
        cmbxAccount.ItemIndex := cmbxAccount.ItemIndex + 1
      else
        cmbxAccount.ItemIndex := FCurrentAccountIndex;
    end
    else if FSkip = -1 then
      cmbxAccount.ItemIndex := cmbxAccount.ItemIndex - 1
    else
      cmbxAccount.ItemIndex := FCurrentAccountIndex
  end
  else
    FCurrentAccountIndex := cmbxAccount.ItemIndex;
  FSkip := 0;
end;

procedure TdlgEditBGLSF360Fields.cmbxAccountPropertiesDrawItem(
  AControl: TcxCustomComboBox; ACanvas: TcxCanvas; AIndex: Integer;
  const ARect: TRect; AState: TOwnerDrawState);
var
  p: pAccount_Rec;
  l: Integer;
  R: TRect;
  ChartIndex : integer;
begin
  if AIndex = 0 then exit;
  R := ARect;

  ChartIndex := Integer(cmbxAccount.Properties.Items.Objects[AIndex]);
  p := MyClient.clChart.Account_At(ChartIndex);
  ACanvas.fillrect(ARect);
  l := 2;
  if not p.chPosting_Allowed then
  begin
    ACanvas.DrawGlyph(R.Left, R.Top, Glyph);
    l := 15;
  end;
  R.Left := R.Left + l;
  R.Right := R.Right + l;
  ACanvas.DrawText(p.chAccount_Code, R, 0, p.chPosting_Allowed);
  R.Left := R.Left + 135 - l;
  R.Right := R.Right + 135 - l;
  ACanvas.DrawText('(' + p.chAccount_Description + ')', R, 0, p.chPosting_Allowed);
end;

procedure TdlgEditBGLSF360Fields.SetReadOnly(const Value: boolean);
begin
  FReadOnly := Value;

  nfTaxFreeAmounts.Enabled := not Value;
  nfTaxExemptedAmounts.Enabled := not Value;
//DN  nfTaxDeferredDist.Enabled := not Value;
//DN  nfForeignIncome.Enabled := not Value;

//DN  nfCapitalGains.Enabled := not Value;

  if assigned( fmeBGLCashCapitalGainsTax ) then begin
    fmeBGLCashCapitalGainsTax.nfCGTDiscounted.Enabled := not Value;
  end;
//DN  nfCapitalGainsOther.Enabled := not Value;
//DN  nfOtherExpenses.Enabled := not Value;
  cmbxAccount.Enabled := not Value;
  btnChart.Enabled := not Value;
  nfUnits.Enabled := not Value;
  if assigned( fmeFranking ) then begin
    fmeFranking.nfFranked.Enabled := not Value;
    fmeFranking.nfUnFranked.Enabled := not Value;
  fmeFranking.nfFrankingCredits.Enabled := not (FReadOnly or MemOnly);
  end;
//DN  eCGTDate.Enabled := not Value;
//DN  cmbMember.Enabled := not Value;

//DN  nfTFNCredits.Enabled := not (FReadOnly or MemOnly);
//DN  nfForeignTaxCredits.Enabled := not (FReadOnly or MemOnly);

  btnClear.Enabled := not Value;
end;

procedure TdlgEditBGLSF360Fields.SetRevenuePercentage(const Value: boolean);
begin
   FRevenuePercentage := Value;

   SetPercentLabel(lpCGTConcession, FRevenuePercentage);
   SetPercentLabel(lpCGTCapitalLosses, FRevenuePercentage);
   SetPercentLabel(lpAssessableForeignSourceIncome, FRevenuePercentage);
   SetPercentLabel(lpOtherNetForeignSourceIncome, FRevenuePercentage);
   SetPercentLabel(lpCashDistribution, FRevenuePercentage);
   SetPercentLabel(lpTaxExemptedAmounts, FRevenuePercentage);
   SetPercentLabel(lpTaxFreeAmounts, FRevenuePercentage);
   SetPercentLabel(lpTaxDeferredAmounts, FRevenuePercentage);
   SetPercentLabel(lpForeignIncome, FRevenuePercentage);
   SetPercentLabel(lpInterest, FRevenuePercentage);
   SetPercentLabel(lpOtherIncome, FRevenuePercentage);
   SetPercentLabel(lpTFNAmountsWithheld, FRevenuePercentage);
   SetPercentLabel(lpNonResidentWithholdingTax, FRevenuePercentage);
   SetPercentLabel(lpShareBrokerage, FRevenuePercentage);
   SetPercentLabel(lpShareConsideration, FRevenuePercentage);
   SetPercentLabel(lpShareGSTAmount, FRevenuePercentage);
   SetPercentLabel(lpShareTradeUnits, FRevenuePercentage);
   SetPercentLabel(lpOtherExpenses, FRevenuePercentage);

   SetPercentLabel(fmeFranking.lpFranked, FRevenuePercentage);
   SetPercentLabel(fmeFranking.lpUnfranked, FRevenuePercentage);

   SetPercentLabel(fmeInterestIncome.lpInterest, FRevenuePercentage);
   SetPercentLabel(fmeInterestIncome.lpOtherIncome, FRevenuePercentage);

   SetPercentLabel(fmeBGLCashCapitalGainsTax.lpCGTDiscounted, FRevenuePercentage);
   SetPercentLabel(fmeBGLCashCapitalGainsTax.lpCGTIndexation, FRevenuePercentage);
   SetPercentLabel(fmeBGLCashCapitalGainsTax.lpCGTOther, FRevenuePercentage);


   SetPercentLabel(fmeBGLNonCashCapitalGainsTax.lpCGTDiscounted, FRevenuePercentage);
   SetPercentLabel(fmeBGLNonCashCapitalGainsTax.lpCGTIndexation, FRevenuePercentage);
   SetPercentLabel(fmeBGLNonCashCapitalGainsTax.lpCGTOther, FRevenuePercentage);

   SetPercentLabel(fmeBGLForeignTax1.lpForeignIncomeTaxOffset, FRevenuePercentage);
   SetPercentLabel(fmeBGLForeignTax1.lpAUFrankingCreditsFromNZCompany, FRevenuePercentage);
   SetPercentLabel(fmeBGLForeignTax1.lpTFNAmountsWithheld, FRevenuePercentage);
   SetPercentLabel(fmeBGLForeignTax1.lpNonResidentWithholdingTax, FRevenuePercentage);
   SetPercentLabel(fmeBGLForeignTax1.lpLICDeductions, FRevenuePercentage);

   SetPercentLabel(fmeBGLForeignTax2.lpForeignIncomeTaxOffset, FRevenuePercentage);
   SetPercentLabel(fmeBGLForeignTax2.lpAUFrankingCreditsFromNZCompany, FRevenuePercentage);
   SetPercentLabel(fmeBGLForeignTax2.lpTFNAmountsWithheld, FRevenuePercentage);
   SetPercentLabel(fmeBGLForeignTax2.lpNonResidentWithholdingTax, FRevenuePercentage);
   SetPercentLabel(fmeBGLForeignTax2.lpLICDeductions, FRevenuePercentage);

   SetPercentLabel(fmeBGLFranking.lpFranked, FRevenuePercentage);
   SetPercentLabel(fmeBGLFranking.lpUnfranked, FRevenuePercentage);
end;

procedure TdlgEditBGLSF360Fields.SetTranAccount(const Value: string);
var
  i : integer;
begin
  fTranAccount := Value;
  try
    if trim( Value ) <> '' then begin
      i := strToInt( Value );
      case i of
        cttanDistribution      : TransactionType := ttDistribution;
        cttanDividend          : TransactionType := ttDividend;
        cttanInterest          : TransactionType := ttInterest;
        cttanShareTrade..(cttanShareTrade + 9999) : TransactionType := ttShareTrade;
        else
          TransactionType := ttOtherTx;
      end;
    end;
  except
    on e:Exception do
      raise Exception.Create( 'Invalid Account Code: '  + fTranAccount );
  end;
end;

procedure TdlgEditBGLSF360Fields.SetTransactionType(
  const Value: TTransactionTypes);

  procedure ShowHeaderFields;
  begin
    lblUnits.Visible         := true;
    nfUnits.Visible          := true;
    lblCashDate.Visible      := true;
    eCashDate.Visible        := true;
    lblAccrualDate.Visible   := true;
    eAccrualDate.Visible     := true;
    lblRecordDate.Visible    := true;
    eRecordDate.Visible      := true;
    lblEntryType.Visible     := true;
    lbldispEntryType.Visible := true;
  end;

  procedure HideHeaderFields;
  begin
    lblUnits.Visible         := false;
    nfUnits.Visible          := false;
    lblCashDate.Visible      := false;
    eCashDate.Visible        := false;
    lblAccrualDate.Visible   := false;
    eAccrualDate.Visible     := false;
    lblRecordDate.Visible    := false;
    eRecordDate.Visible      := false;
    lblEntryType.Visible     := false;
    lbldispEntryType.Visible := false;
  end;

  procedure Configure_Distribution;
  begin
    ShowHeaderFields;
    lbldispEntryType.Caption := 'Distribution';
    pnlDistribution.Visible := true;
    pnlDividend.Visible     := false;
    pnlInterest.Visible     := false;
    pnlShareTrade.Visible   := false;
  end;

  procedure Configure_Dividend;
  begin
    ShowHeaderFields;
    lbldispEntryType.Caption := 'Dividend';
    pnlDistribution.Visible := false;
    pnlDividend.Visible     := true;
    pnlInterest.Visible     := false;
    pnlShareTrade.Visible   := false;
  end;

  procedure Configure_Interest;
  begin
    ShowHeaderFields;
    lbldispEntryType.Caption := 'Interest';
    pnlDistribution.Visible := false;
    pnlDividend.Visible     := false;
    pnlInterest.Visible     := true;
    pnlShareTrade.Visible   := false;
  end;

  procedure Configure_ShareTrade;
  begin
    ShowHeaderFields;
    lbldispEntryType.Caption := 'Share Trade';
    pnlDistribution.Visible := false;
    pnlDividend.Visible     := false;
    pnlInterest.Visible     := false;
    pnlShareTrade.Visible   := true;
  end;

  procedure Configure_OtherTX;
  begin
    HideHeaderFields;
    lbldispEntryType.Caption := 'Other';
    pnlDistribution.Visible := false;
    pnlDividend.Visible     := false;
    pnlInterest.Visible     := false;
    pnlShareTrade.Visible   := false;
  end;

begin
  try
    case Value of
      ttDistribution : Configure_Distribution;
      ttDividend     : Configure_Dividend;
      ttInterest     : Configure_Interest;
      ttShareTrade   : Configure_ShareTrade;
      ttOtherTx      : Configure_OtherTx;
    end;
  finally
    fTransactionType := Value;
  end;
end;

procedure TdlgEditBGLSF360Fields.SetUpHelp;
begin
  Self.ShowHint    := INI_ShowFormHints;
  btnBack.Hint := 'Goto previous line|' +
                  'Goto previous line';

  btnNext.Hint := 'Goto next line|' +
                  'Goto next line';

  if assigned( fmeBGLFranking ) then
    fmeBGLFranking.btnFrankingCredits.Hint := 'Calculate the Imputed Credit|' +
       'Calculate the Imputed Credit';

  btnChart.Hint :=  '(F2) Lookup Chart|(F2) Lookup Chart';

  cmbxAccount.Hint := 'Select Chart code|Select Chart code';
end;

procedure TdlgEditBGLSF360Fields.fmeFrankingbtnCalcClick(Sender: TObject);
begin
    crModified := False;
    if assigned( fmeFranking ) then
      fmeFrankingnfFrankingCreditsChange(nil);
end;

procedure TdlgEditBGLSF360Fields.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);

  function ValueIsValid( aNFControl : TOvcNumericField) : boolean;
  begin
    result := aNFControl.AsFloat >= 0;
    if not result then
    begin
      HelpfulWarningMsg( 'Value cannot be negative.', 0);
      aNFControl.SetFocus;
    end;
  end;

var
  CGTDate : integer;
begin
  if FReadOnly and (FMoveDirection = fnNothing) then
    ModalResult := mrCancel;


  if ModalResult = mrOK then
  begin
    CanClose := false;

(*//DN
    //verify fields
    CGTDate := stNull2Bk( eCGTDate.AsStDate);

    if not ( DateIsValid( eCGTDate.AsString) or (CGTDate = 0)) then
    begin
      HelpfulWarningMSg( 'Please enter a valid CGT date.', 0);
      Exit;
    end;

    if (CGTDate <> 0) and ((CGTDate < MinValidDate) or (CGTDate > MaxValidDate)) then
    begin
      HelpfulWarningMsg( 'Please enter a valid CGT date.', 0);
      Exit;
    end;
//DN *)

    CGTDate := stNull2Bk( eAccrualDate.AsStDate);

    if not ( DateIsValid( eAccrualDate.AsString) or (CGTDate = 0)) then
    begin
      HelpfulWarningMSg( 'Please enter a valid Accrual date.', 0);
      Exit;
    end;

    if (CGTDate <> 0) and ((CGTDate < MinValidDate) or (CGTDate > MaxValidDate)) then
    begin
      HelpfulWarningMsg( 'Please enter a valid Accrual date.', 0);
      Exit;
    end;




    if not ValueIsValid( fmeFranking.nfFrankingCredits) then
      Exit;
    if not ValueIsValid( nfTFNAmountsWithheld) then
      Exit;
    if not ValueIsValid( nfOtherExpenses) then
      Exit;

    if (TransactionType = ttDistribution) and
         not ValueIsValid( fmeBGLForeignTax1.nfForeignIncomeTaxOffset) then
      Exit;
    if (TransactionType = ttDividend) and
         not ValueIsValid( fmeBGLForeignTax2.nfForeignIncomeTaxOffset) then
      Exit;

    if not ValueIsValid( fmeBGLCashCapitalGainsTax.nfCGTDiscounted ) then
      Exit;
    if not ValueIsValid( fmeBGLCashCapitalGainsTax.nfCGTOther) then
      Exit;
    if not ValueIsValid( fmeBGLCashCapitalGainsTax.nfCGTIndexation) then
      Exit;
    if not ValueIsValid( fmeFranking.nfFranked) then
      Exit;
    if not ValueIsValid( fmeFranking.nfUnFranked) then
      Exit; 

    //no problems, allow close
    CanClose := true;
  end;
end;

procedure TdlgEditBGLSF360Fields.fmeFrankingnfFrankingCreditsChange(Sender: TObject);
var Frank: Double;
begin
  if assigned( fmeFranking ) then begin
    if FrankPercentage then
      Frank := fmeFranking.nfFranked.asFloat{ * Money2Double(FActualAmount) / 100}
    else
      Frank := fmeFranking.nfFranked.asFloat;

    crModified := CheckFrankingCredit( Frank, fDate, fmeFranking.nfFrankingCredits,
                    not((Sender = fmeFranking.nfFrankingCredits) or crModified));
  end;
end;

procedure TdlgEditBGLSF360Fields.nfTFNCreditsKeyPress(Sender: TObject;
  var Key: Char);
begin
  //ignore minus key
  if Key = '-' then
    Key := #0;
end;

procedure TdlgEditBGLSF360Fields.fmeFrankingnfFrankedChange(Sender: TObject);
var Actual: Double;

begin
   if assigned( fmeFranking ) then begin
     if not UFModified then begin
       if FrankPercentage then
          Actual := 100.0
       else
          Actual := Money2Double(FActualAmount);
       if sender = fmeFranking.nfFranked then
         CalcFrankAmount(Actual,fmeFranking.nfFranked,fmeFranking.nfUnFranked)
       else
         CalcFrankAmount(Actual,fmeFranking.nfUnFranked,fmeFranking.nfFranked)
    end;
    fmeFrankingnfFrankingCreditsChange(Sender);
  end;
end;

procedure TdlgEditBGLSF360Fields.fmeFrankingnfUnfrankedChange(Sender: TObject);
begin
  UFModified := True;
end;

procedure TdlgEditBGLSF360Fields.nfUnitsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FAutoPressMinus then
    keybd_event(vk_subtract,0,0,0);
  FAutoPresSMinus := False;
end;


procedure TdlgEditBGLSF360Fields.RefreshChartCodeCombo();
var
  ChartIndex : integer;
  pChartAcc : pAccount_Rec;
begin
  cmbxAccount.Properties.Items.Add('');
  for ChartIndex := MyClient.clChart.First to MyClient.clChart.Last do
  begin
    pChartAcc := MyClient.clChart.Account_At(ChartIndex);

    if (pChartAcc.chInactive) and
       (TranAccount <> pChartAcc.chAccount_Code) then
      Continue;

    cmbxAccount.Properties.Items.AddObject(pChartAcc.chAccount_Code, TObject(ChartIndex));
    if (TranAccount <> '') and (TranAccount = pChartAcc.chAccount_Code) then
      cmbxAccount.ItemIndex := Pred(cmbxAccount.Properties.Items.Count);
  end;
end;

procedure TdlgEditBGLSF360Fields.SetMemOnly(const Value: boolean);
begin
  FMemOnly := Value;
// Set the FrankingFme MemorisationsOnly property rather
  if assigned( fmeFranking ) then
    fmeFranking.nfFrankingCredits.Enabled := not FMemOnly;
// Set the FrankingFme MemorisationsOnly property rather

//DN  nfTFNCredits.Enabled := not FMemOnly;
//DN  nfForeignTaxCredits.Enabled := not FMemOnly;
end;

procedure TdlgEditBGLSF360Fields.SetMoveDirection(const Value: TFundNavigation);
begin
  btnBack.Enabled := not (Value in [fnNoMove,fnIsFirst]);
  btnNext.Enabled := not (Value in [fnNoMove,fnIsLast]);
  FMoveDirection := Value;
end;

end.