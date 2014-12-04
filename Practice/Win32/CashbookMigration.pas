unit CashbookMigration;

//------------------------------------------------------------------------------
interface

uses
  Windows,
  SysUtils,
  Classes,
  uLkJSON;

type
  { 
  "business": {
    "abn": "53004085616�, 
    "name": �Business Name�, 
    "business_type": "Products�,
    "client_code": �BIZ1�, 
    "firm_id": "1-14TBO0P�,
    �financial_year_start_month�: 9 
  }



  //----------------------------------------------------------------------------
  TBusinessData = class
  private
    fJson : TlkJSONobject;

    fABN : string;
    fBusinessName : string;
    fBusinessType : string;
    fClientCode : string;
    fFirmId : string;
    fFinancialYearStartMonth : integer;
  protected
  public
    constructor Create(aJson : TlkJSONobject);

    procedure CreateData();

    property ABN : string read fABN write fABN;
    property BusinessName : string read fBusinessName write fBusinessName;
    property BusinessType : string read fBusinessType write fBusinessType;
    property ClientCode : string read fClientCode write fClientCode;
    property FirmId : string read fFirmId write fFirmId;
    property FinancialYearStartMonth : integer read fFinancialYearStartMonth write fFinancialYearStartMonth;
  end;

  //----------------------------------------------------------------------------
  TCashbookClientData = class
  private
    fBusinessData : TBusinessData;
    fJson : TlkJSONobject;
  protected
  public
    constructor Create(aJson : TlkJSONobject);
    destructor Destroy; override;

    procedure CreateData();

    property BusinessData : TBusinessData read fBusinessData write fBusinessData;
  end;

  //----------------------------------------------------------------------------
  TCashbookMigration = class
  private
    fCashbookClientData : TCashbookClientData;
    fJson : TlkJSONobject;

  protected
  public
    constructor Create;
    destructor Destroy; override;

    function PostDataToCashBook() : boolean;

    property CashbookClientData : TCashbookClientData read fCashbookClientData write fCashbookClientData;
  end;

  //----------------------------------------------------------------------------
  function MigrateCashbook : TCashbookMigration;

//------------------------------------------------------------------------------
implementation

var
  fCashbookMigration : TCashbookMigration;

//------------------------------------------------------------------------------
function MigrateCashbook : TCashbookMigration;
begin
  if Not Assigned(fCashbookMigration) then
  begin
    fCashbookMigration := TCashbookMigration.Create();
  end;

  Result := fCashbookMigration;
end;

//------------------------------------------------------------------------------
{ TBusinessData }
constructor TBusinessData.Create(aJson: TlkJSONobject);
begin
  fJson := aJson;
end;

//------------------------------------------------------------------------------
procedure TBusinessData.CreateData();
var
  Id : integer;
  JSONobject : TlkJSONobject;
begin
  JSONobject := TlkJSONobject.Create();
  JSONobject.Add('abn', fABN);
  JSONobject.Add('name', fBusinessName);
  JSONobject.Add('business_type', fBusinessType);
  JSONobject.Add('client_code', fClientCode);
  JSONobject.Add('firm_id', fFirmId);
  JSONobject.Add('financial_year_start_month', fFinancialYearStartMonth);

  fJson.Add('Business',JSONobject);
end;

//------------------------------------------------------------------------------
{ TCashbookClientData }
constructor TCashbookClientData.Create(aJson : TlkJSONobject);
begin
  fJson := aJson;
  fBusinessData := TBusinessData.create(fJson);
end;

//------------------------------------------------------------------------------
destructor TCashbookClientData.Destroy;
begin
  FreeAndNil(fBusinessData);
  inherited;
end;

//------------------------------------------------------------------------------
procedure TCashbookClientData.CreateData;
begin
  BusinessData.CreateData();
end;

//------------------------------------------------------------------------------
{ TCashbookMigration }
constructor TCashbookMigration.Create;
begin
  fJson := TlkJSONobject.Create;
  fCashbookClientData := TCashbookClientData.create(fJson);
end;

//------------------------------------------------------------------------------
destructor TCashbookMigration.Destroy;
begin
  FreeAndNil(fCashbookClientData);
  FreeAndNil(fJson);
  inherited;
end;

//------------------------------------------------------------------------------
function TCashbookMigration.PostDataToCashBook: boolean;
var
  Level : integer;
  JsonFile : TextFile;
  OutString : string;
begin
  Result := false;

  CashbookClientData.BusinessData.ABN := '53004085616';
  CashbookClientData.BusinessData.BusinessName := 'Business Name';
  CashbookClientData.BusinessData.BusinessType := 'Products';
  CashbookClientData.BusinessData.ClientCode := 'BIZ1';
  CashbookClientData.BusinessData.FirmId := '1-14TBO0P';
  CashbookClientData.BusinessData.FinancialYearStartMonth := 9;
  CashbookClientData.CreateData;

  AssignFile(JsonFile, 'c:\testing\CashbookData.json');
  try
    Rewrite(JsonFile);


    Level := 0;
    OutString := GenerateReadableText(fJson,Level);
    writeln(JsonFile, OutString);
  finally
    Closefile(JsonFile);
  end;

  Result := true;
end;

//------------------------------------------------------------------------------
initialization
  fCashbookMigration := nil;

//------------------------------------------------------------------------------
finalization
  FreeAndNil(fCashbookMigration);

end.
