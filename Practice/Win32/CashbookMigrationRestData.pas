unit CashbookMigrationRestData;

interface

uses
  Windows,
  SysUtils,
  Classes,
  uLkJSON;

const
  UPLOAD_RESP_ERROR = -1;
  UPLOAD_RESP_UKNOWN = 0;
  UPLOAD_RESP_SUCESS = 1;
  UPLOAD_RESP_DUPLICATE = 2;
  UPLOAD_RESP_CORUPT = 3;

type
  //----------------------------------------------------------------------------
  TSelectedData = record
    FirmId : string;
    Bankfeeds : boolean;
    ChartOfAccount : boolean;
    ChartOfAccountBalances : boolean;
    NonTransferedTransactions : boolean;
  end;

  //----------------------------------------------------------------------------
  TListDestroy = class(TList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  end;

  //----------------------------------------------------------------------------
  TFirm = class
  private
    fID: string;
    fName: string;

  public
    procedure Read(const aJson: TlkJSONobject);

    property  ID: string read fID write fID;
    property  Name: string read fName write fName;
  end;

  //----------------------------------------------------------------------------
  TFirms = class(TListDestroy)
  public
    function  GetItem(const aIndex: integer): TFirm;
    property  Items[const aIndex: integer]: TFirm read GetItem; default;

    procedure Read(const aJson: TlkJSONlist);
  end;

  //----------------------------------------------------------------------------
  TAllocationData = class(TCollectionItem)
  private
    fAccountNumber : string;
    fAmount : string;
    fTaxRate : string;
    fTaxAmount : string;
  public
    procedure Write(const aJson: TlkJSONobject);

    property AccountNumber : string read fAccountNumber write fAccountNumber;
    property Amount : string read fAmount write fAmount;
    property TaxRate : string read fTaxRate write fTaxRate;
    property TaxAmount : string read fTaxAmount write fTaxAmount;
  end;

  //----------------------------------------------------------------------------
  TAllocationsData = class(TCollection)
  private
  public
    function ItemAs(aIndex : integer) : TAllocationData;

    procedure Write(const aJson: TlkJSONobject);
  end;

  //----------------------------------------------------------------------------
  TJournalData = class(TCollectionItem)
  private
    fReferenceId : string;
    fDate        : string;
    fDescription : string;

    fAllocations : TAllocationsData;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;

    procedure Write(const aJson: TlkJSONobject);

    property ReferenceId : string read fReferenceId write fReferenceId;
    property Date : string read fDate write fDate;
    property Description : string read fDescription write fDescription;
  end;

  //----------------------------------------------------------------------------
  TJournalsData = class(TCollection)
  private
  public
    function ItemAs(aIndex : integer) : TJournalData;

    procedure Write(const aJson: TlkJSONobject);
  end;

  //----------------------------------------------------------------------------
  TTransactionData = class(TCollectionItem)
  private
    fDate : string;
    fDescription : string;
    fBankAccNumber : string;
    fCoreTransactionId : string;

    fAllocations : TAllocationsData;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;

    procedure Write(const aJson: TlkJSONobject);

    property Date : string read fDate write fDate;
    property Description : string read fDescription write fDescription;
    property BankAccNumber : string read fBankAccNumber write fBankAccNumber;
    property CoreTransactionId : string read fCoreTransactionId write fCoreTransactionId;
  end;

  //----------------------------------------------------------------------------
  TTransactionsData = class(TCollection)
  private
  public
    function ItemAs(aIndex : integer) : TTransactionData;

    procedure Write(const aJson: TlkJSONobject);
  end;

  //----------------------------------------------------------------------------
  TChartOfAccountData = class(TCollectionItem)
  private
    fCode : string;
    fName : string;
    fAccountType : string;
    fGstType : string;
    fOrigAccountType : string;
    fOrigGstType : string;
    fOpeningBalance : integer;
    fAccountTypeGroup : string;
    fBankOrCreditFlag : boolean;
    fInActive : boolean;
    fPostingAllowed : boolean;
    fDivision : integer;
  public
    procedure Write(const aJson: TlkJSONobject);

    property Code : string read fCode write fCode;
    property Name : string read fName write fName;
    property AccountType : string read fAccountType write fAccountType;
    property GstType : string read fGstType write fGstType;
    property OrigAccountType : string read fOrigAccountType write fOrigAccountType;
    property OrigGstType : string read fOrigGstType write fOrigGstType;
    property OpeningBalance : integer read fOpeningBalance write fOpeningBalance;
    property AccountTypeGroup : string read fAccountTypeGroup write fAccountTypeGroup;
    property BankOrCreditFlag : boolean read fBankOrCreditFlag write fBankOrCreditFlag;
    property InActive : boolean read fInActive write fInActive;
    property PostingAllowed : boolean read fPostingAllowed write fPostingAllowed;
    property Division : integer read fDivision write fDivision;
  end;

  //----------------------------------------------------------------------------
  TChartOfAccountsData = class(TCollection)
  private
  public
    function ItemAs(aIndex : integer) : TChartOfAccountData;

    procedure Write(const aJson: TlkJSONobject);
  end;

  //----------------------------------------------------------------------------
  TBusinessData = class
  private
    fABN : string;
    fIRD : string;
    fName : string;
    fClientCode : string;
    fOrigClientCode : string;
    fFinancialYearStartMonth : integer;
    fOpeningBalanceDate : string;
    fFirmId : string;
  public
    procedure Write(const aJson: TlkJSONobject);

    property  ABN : string read fABN write fABN;
    property  IRD : string read fIRD write fIRD;
    property  Name : string read fName write fName;
    property  ClientCode : string read fClientCode write fClientCode;
    property  OrigClientCode : string read fOrigClientCode write fOrigClientCode;
    property  FinancialYearStartMonth : integer read fFinancialYearStartMonth write fFinancialYearStartMonth;
    property  OpeningBalanceDate : string read fOpeningBalanceDate write fOpeningBalanceDate;
    property  FirmId : string read fFirmId write fFirmId;
  end;

  //----------------------------------------------------------------------------
  TClientData = class
  private
    fBusinessData: TBusinessData;
    fChartOfAccountsData : TChartOfAccountsData;
    fTransactionsData : TTransactionsData;
    fJournalsData : TJournalsData;
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Write(const aJson: TlkJSONobject; aSelectedData: TSelectedData);

    property BusinessData: TBusinessData read fBusinessData write fBusinessData;
    property ChartOfAccountsData: TChartOfAccountsData read fChartOfAccountsData write fChartOfAccountsData;
    property TransactionsData: TTransactionsData read fTransactionsData write fTransactionsData;
    property JournalsData: TJournalsData read fJournalsData write fJournalsData;
  end;

  //----------------------------------------------------------------------------
  TClientBase = class
  private
    fClientData : TClientData;

    fToken : string;
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Write(const aJson: TlkJSONobject; aSelectedData: TSelectedData);

    function GetData(aSelectedData: TSelectedData) : string;

    property ClientData: TClientData read fClientData write fClientData;

    property Token : string read fToken write fToken;
  end;

  //----------------------------------------------------------------------------
  TFile = class
  private
    fID: string;
    fFileName: string;
    fDataLength: integer;
    fData: string;

    function  GetFileHash: string;
    function  GetDataAsZipBase64: string;
  public
    constructor Create;

    procedure Write(const aJson: TlkJSONobject);

    property  ID: string read fID write fID;
    property  FileName: string read fFileName write fFileName;
    property  DataLength: integer read fDataLength write fDataLength;
    property  Data: string read fData write fData;
  end;

  //----------------------------------------------------------------------------
  TParameters = class(TListDestroy)
  private
    fDataStore: string;
    fQueue: string;
    fRegion: string;
  public
    procedure Write(const aJson: TlkJSONlist);

    property  DataStore: string read fDataStore write fDataStore;
    property  Queue: string read fQueue write fQueue;
    property  Region: string read fRegion write fRegion;
  end;

    //----------------------------------------------------------------------------
  TMigrationUpload = class
  private
    fID: string;
    fUploadType: integer;
    fFile: TFile;
    fParameters: TParameters;
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Write(const aJson: TlkJSONobject);

    property  ID: string read fID;
    property  UploadType: integer read fUploadType write fUploadType;
    property  Files: TFile read fFile;
    property  Parameters: TParameters read fParameters;
  end;

  //----------------------------------------------------------------------------
  TUrlsMap = class
  private
    fName: string;
    fValue: string;
  public
    procedure Read(const aJson: TlkJSONobject);

    property  Name: string read fName write fName;
    property  Value: string read fValue write fValue;
  end;

  //----------------------------------------------------------------------------
  TMigrationUploadResponse = class
  private
    fUploadID: string;
    fResponseCode: integer;
    fUrlsMap: TUrlsMap;
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Read(const aJson: TlkJSONobject);

    property  UploadID: string read fUploadID write fUploadID;
    property  RespondeCode: integer read fResponseCode write fResponseCode;
    property  UrlsMap: TUrlsMap read fUrlsMap;
  end;

//------------------------------------------------------------------------------
implementation

uses
  IdCoder,
  IdCoderMIME,
  CryptUtils,
  GenUtils,
  LogUtil,
  ZlibExGZ,
  Globals,
  ZipUtils;

const
  UnitName = 'CashbookMigrationRestData';

var
  DebugMe : boolean = false;

//------------------------------------------------------------------------------
{ TListDestroy }
procedure TListDestroy.Notify(Ptr: Pointer; Action: TListNotification);
var
  Item: TObject;
begin
  inherited;

  if (Action = lnDeleted) then
  begin
    Item := TObject(Ptr);
    FreeAndNil(Item);
  end;
end;

//------------------------------------------------------------------------------
{ TFirm }
procedure TFirm.Read(const aJson: TlkJSONobject);
begin
  ASSERT(assigned(aJson));

  ID := aJson.getString('id');
  Name := aJson.getString('name');
end;

//------------------------------------------------------------------------------
{ TFirms }
function TFirms.GetItem(const aIndex: integer): TFirm;
begin
  result := TFirm(Get(aIndex));
end;

//------------------------------------------------------------------------------
procedure TFirms.Read(const aJson: TlkJSONlist);
var
  i: integer;
  Child: TlkJSONobject;
  Firm: TFirm;
begin
  ASSERT(assigned(aJson));

  for i := 0 to aJson.Count-1 do
  begin
    Child := aJson.Child[i] as TlkJSONobject;

    // New firm
    Firm := TFirm.Create;
    Add(Firm);

    // Read firm
    Firm.Read(Child);
  end;
end;

{ TAllocationData }
//------------------------------------------------------------------------------
procedure TAllocationData.Write(const aJson: TlkJSONobject);
begin
  aJson.Add('account_number', AccountNumber);
  aJson.Add('amount', Amount);
  aJson.Add('tax_rate', TaxRate);
  aJson.Add('tax_amount', TaxAmount);
end;

{ TAllocationsData }
//------------------------------------------------------------------------------
function TAllocationsData.ItemAs(aIndex: integer): TAllocationData;
begin
  Result := TAllocationData(Self.Items[aIndex]);
end;

//------------------------------------------------------------------------------
procedure TAllocationsData.Write(const aJson: TlkJSONobject);
var
  Allocations: TlkJSONlist;
  AllocationIndex : integer;
  Allocation : TAllocationData;
  AllocationData : TlkJSONobject;
begin
  Allocations := TlkJSONlist.Create;
  aJson.Add('bank_transactions', Allocations);

  for AllocationIndex := 0 to self.Count-1 do
  begin
    AllocationData := TlkJSONobject.Create;
    Allocations.Add(AllocationData);

    Allocation := ItemAs(AllocationIndex);
    Allocation.Write(AllocationData);
  end;
end;

{ TJournalData }
//------------------------------------------------------------------------------
constructor TJournalData.Create(Collection: TCollection);
begin
  inherited;

  fAllocations := TAllocationsData.Create(TAllocationData);
end;

//------------------------------------------------------------------------------
destructor TJournalData.Destroy;
begin
  FreeAndNil(fAllocations);

  inherited;
end;

//------------------------------------------------------------------------------
procedure TJournalData.Write(const aJson: TlkJSONobject);
begin
  aJson.Add('reference_id', ReferenceId);
  aJson.Add('date', Date);
  aJson.Add('description', Description);
end;

{ TJournalsData }
//------------------------------------------------------------------------------
function TJournalsData.ItemAs(aIndex: integer): TJournalData;
begin
  Result := TJournalData(Self.Items[aIndex]);
end;

//------------------------------------------------------------------------------
procedure TJournalsData.Write(const aJson: TlkJSONobject);
var
  Journals: TlkJSONlist;
  JournalIndex : integer;
  Journal : TJournalData;
  JournalData : TlkJSONobject;
begin
  Journals := TlkJSONlist.Create;
  aJson.Add('bank_transactions', Journals);

  for JournalIndex := 0 to self.Count-1 do
  begin
    JournalData := TlkJSONobject.Create;
    Journals.Add(JournalData);

    Journal := ItemAs(JournalIndex);
    Journal.Write(JournalData);
  end;
end;

{ TTransactionData }
//------------------------------------------------------------------------------
constructor TTransactionData.Create(Collection: TCollection);
begin
  inherited;

  fAllocations := TAllocationsData.Create(TAllocationData);
end;

//------------------------------------------------------------------------------
destructor TTransactionData.Destroy;
begin
  FreeAndNil(fAllocations);

  inherited;
end;

//------------------------------------------------------------------------------
procedure TTransactionData.Write(const aJson: TlkJSONobject);
begin
  aJson.Add('date', Date);
  aJson.Add('description', Description);
  aJson.Add('bank_account_number', BankAccNumber);
  aJson.Add('core_transaction_id', CoreTransactionId);
end;

{ TTransactionsData }
//------------------------------------------------------------------------------
function TTransactionsData.ItemAs(aIndex: integer): TTransactionData;
begin
  Result := TTransactionData(Self.Items[aIndex]);
end;

//------------------------------------------------------------------------------
procedure TTransactionsData.Write(const aJson: TlkJSONobject);
var
  Transactions: TlkJSONlist;
  TransactionIndex : integer;
  Transaction : TTransactionData;
  TransactionData : TlkJSONobject;
begin
  Transactions := TlkJSONlist.Create;
  aJson.Add('bank_transactions', Transactions);

  for TransactionIndex := 0 to self.Count-1 do
  begin
    TransactionData := TlkJSONobject.Create;
    Transactions.Add(TransactionData);

    Transaction := ItemAs(TransactionIndex);
    Transaction.Write(TransactionData);
  end;
end;

{ TChartOfAccountData }
//------------------------------------------------------------------------------
procedure TChartOfAccountData.Write(const aJson: TlkJSONobject);
begin
  aJson.Add('Code', Code);
  aJson.Add('Name', Name);
  aJson.Add('AccountType', AccountType);
  aJson.Add('GstType', GstType);
  aJson.Add('OrigAccountType', OrigAccountType);
  aJson.Add('OrigGstType', OrigGstType);
  aJson.Add('Openingbalance', OpeningBalance);
  aJson.Add('AccountTypeGroup', AccountTypeGroup);
  aJson.Add('BankOrCreditFlag', BankOrCreditFlag);
  aJson.Add('InActive', InActive);
  aJson.Add('PostingAllowed', PostingAllowed);
end;

{ TChartOfAccountsData }
//------------------------------------------------------------------------------
function TChartOfAccountsData.ItemAs(aIndex: integer): TChartOfAccountData;
begin
  Result := TChartOfAccountData(Self.Items[aIndex]);
end;

//------------------------------------------------------------------------------
procedure TChartOfAccountsData.Write(const aJson: TlkJSONobject);
var
  Accounts: TlkJSONlist;
  AccountIndex : integer;
  ChartOfAccount : TChartOfAccountData;
  ChartOfAccountData : TlkJSONobject;
begin
  Accounts := TlkJSONlist.Create;
  aJson.Add('accounts', Accounts);

  for AccountIndex := 0 to self.Count-1 do
  begin
    ChartOfAccountData := TlkJSONobject.Create;
    Accounts.Add(ChartOfAccountData);

    ChartOfAccount := ItemAs(AccountIndex);
    ChartOfAccount.Write(ChartOfAccountData);
  end;
end;

//------------------------------------------------------------------------------
{ TBusinessData }
procedure TBusinessData.Write(const aJson: TlkJSONobject);
begin
  ASSERT(assigned(aJson));

  if (ABN <> '') then
    aJson.Add('Abn', ABN);

  if (IRD <> '') then
    aJson.Add('Ird', IRD);

  aJson.Add('LedgerName', Name);
  aJson.Add('ClientCode', ClientCode);
  if ClientCode <> OrigClientCode then
    aJson.Add('OrigClientCode', OrigClientCode);

  aJson.Add('FinancialYearStartMonth', FinancialYearStartMonth);
  aJson.Add('OpeningBalanceDate', OpeningBalanceDate);
  aJson.Add('FirmId', FirmId);
end;

//------------------------------------------------------------------------------
{ TClientData }
constructor TClientData.Create;
begin
  fBusinessData := TBusinessData.Create;
  fChartOfAccountsData := TChartOfAccountsData.Create(TChartOfAccountData);
  fTransactionsData := TTransactionsData.Create(TTransactionData);
  fJournalsData := TJournalsData.Create(TJournalData);
end;

//------------------------------------------------------------------------------
destructor TClientData.Destroy;
begin
  FreeAndNil(fBusinessData);
  FreeAndNil(fChartOfAccountsData);
  FreeAndNil(fTransactionsData);
  FreeAndNil(fJournalsData);

  inherited;
end;

//------------------------------------------------------------------------------
procedure TClientData.Write(const aJson: TlkJSONobject; aSelectedData: TSelectedData);
var
  JsonBusiness : TlkJSONobject;
  JsonChartOfAccounts : TlkJSONobject;
begin
  // Business data, create the ledger on cashbook
  JsonBusiness := TlkJSONobject.Create;
  aJson.Add('ledger', JsonBusiness);
  BusinessData.Write(JsonBusiness);

  if aSelectedData.ChartOfAccount then
  begin
    // Business data
    //JsonChartOfAccounts := TlkJSONobject.Create;
    //aJson.Add('accounts', JsonChartOfAccounts);
    ChartOfAccountsData.Write(aJson);
  end;
end;

//------------------------------------------------------------------------------
{ TClientBase }
//------------------------------------------------------------------------------
constructor TClientBase.Create;
begin
  fClientData := TClientData.Create;
end;

//------------------------------------------------------------------------------
destructor TClientBase.Destroy;
begin
  FreeAndNil(fClientData);

  inherited;
end;

//------------------------------------------------------------------------------
procedure TClientBase.Write(const aJson: TlkJSONobject; aSelectedData: TSelectedData);
var
  JsonClientData : TlkJSONobject;
begin
  aJson.Add('Token', Token);

  // Client data
  JsonClientData := TlkJSONobject.Create;
  aJson.Add('Data', JsonClientData);
  ClientData.Write(JsonClientData, aSelectedData);
end;

//------------------------------------------------------------------------------
function TClientBase.GetData(aSelectedData: TSelectedData): string;
var
  Json: TlkJSONobject;
begin
  Json := nil;
  try
    // Write Json
    Json := TlkJSONobject.Create;
    Write(Json, aSelectedData);

    // Jason to text
    result := FixJsonString(TlkJSON.GenerateText(Json));

  finally
    FreeAndNil(Json);
  end;
end;

//------------------------------------------------------------------------------
{ TFile }
constructor TFile.Create;
var
  NewID: TGUID;
begin
  CreateGUID(NewID);
  fID := TrimedGuid(NewID);
end;

//------------------------------------------------------------------------------
function TFile.GetFileHash: string;
begin
  result := Lowercase(HashStr(fData, false));
end;

//------------------------------------------------------------------------------
function TFile.GetDataAsZipBase64: string;
begin
  result := GZCompressStr(fData);

  result := EncodeString(TidEncoderMIME, result);
end;

//------------------------------------------------------------------------------
procedure TFile.Write(const aJson: TlkJSONobject);
var
  iDataLength: integer;
  sData: string;
begin
  aJson.Add('Id', fId);

  aJson.Add('FileName', fFileName);

  aJson.Add('FileHash', GetFileHash);

  sData := GetDataAsZipBase64;

  iDataLength := Length(fData);

  if DebugMe then
    LogUtil.LogMsg(lmDebug, UnitName, 'Business Data Original Size : ' + inttostr(Length(fData)) +
                                      ', Zipped and Base64 Size : ' + inttostr(Length(sData)) +
                                      ', Size Change : ' + inttostr(trunc((Length(sData)/Length(fData))*100)) + '%' +
                                      ' of the Original Size.');

  aJson.Add('DataLength', iDataLength);

  aJson.Add('Data', sData);
end;

//------------------------------------------------------------------------------
{ TParameters }
procedure TParameters.Write(const aJson: TlkJSONlist);
var
  Parameter: TlkJSONobject;
begin
  // DataStore
  Parameter := TlkJSONobject.Create;
  aJson.Add(Parameter);
  Parameter.Add('Key', 'DataStore');
  Parameter.Add('Value', fDataStore);

  // Queue
  Parameter := TlkJSONobject.Create;
  aJson.Add(Parameter);
  Parameter.Add('Key', 'Queue');
  Parameter.Add('Value', fQueue);

  // Queue
  Parameter := TlkJSONobject.Create;
  aJson.Add(Parameter);
  Parameter.Add('Key', 'Region');
  Parameter.Add('Value', fRegion);
end;

//------------------------------------------------------------------------------
{ TFileUpload }
constructor TMigrationUpload.Create;
var
  NewID: TGUID;
begin
  CreateGUID(NewID);
  fID := TrimedGuid(NewID);

  fUploadType := 7;

  fFile := TFile.Create;

  fParameters := TParameters.Create;
end;

//------------------------------------------------------------------------------
destructor TMigrationUpload.Destroy;
begin
  FreeAndNil(fFile);
  FreeAndNil(fParameters);

  inherited;
end;

//------------------------------------------------------------------------------
procedure TMigrationUpload.Write(const aJson: TlkJSONobject);
var
  Files: TlkJSONlist;
  NewFile: TlkJSONobject;
  Parameters: TlkJSONlist;
begin
  aJson.Add('Id', fID);

  aJson.Add('UploadType', fUploadType);

  // File
  Files := TlkJSONlist.Create;
  aJson.Add('Files', Files);
  NewFile := TlkJSONobject.Create;
  Files.Add(NewFile);
  fFile.Write(NewFile);

  // Parameters
  Parameters := TlkJSONlist.Create;
  aJson.Add('Parameters', Parameters);
  fParameters.Write(Parameters);
end;

//------------------------------------------------------------------------------
{ TUrlsMap }
procedure TUrlsMap.Read(const aJson: TlkJSONobject);
begin
  fName := aJson.NameOf[0];

  fValue := aJson.getString(0);
end;

//------------------------------------------------------------------------------
{ TFileUploadResult }
constructor TMigrationUploadResponse.Create;
begin
  fUrlsMap := TUrlsMap.Create;
end;

//------------------------------------------------------------------------------
destructor TMigrationUploadResponse.Destroy;
begin
  FreeAndNil(fUrlsMap);

  inherited;
end;

//------------------------------------------------------------------------------
procedure TMigrationUploadResponse.Read(const aJson: TlkJSONobject);
var
  UrlsMap: TlkJSONobject;
begin
  fUploadId := aJson.getString('UploadId');

  fResponseCode := aJson.getInt('ResponseCode');

  if fResponseCode = UPLOAD_RESP_SUCESS then
  begin
    UrlsMap := (aJson.Field['UrlsMap'] as TlkJSONobject);
    fUrlsMap.Read(UrlsMap);
  end;
end;

//------------------------------------------------------------------------------
initialization
begin
  DebugMe := DebugUnit(UnitName);
end;

end.