unit Extract1Place;

interface
uses
  ExtractCommon,
  Windows,
  Graphics;


function GetExtractVersion: Integer; stdcall;
procedure procInitDllApplication(ApplicationHandle : HWnd; BaseFont: TFont); stdcall;
function DoBulkExport(var Session: TExtractSession): Integer; stdcall;
function GetExtractType(Index: integer; var EType: ExtractType): Boolean; stdcall;
function CheckFeature(const index, Feature: Integer): Integer; stdcall;

implementation

uses
  ExtractHelpers,
  Controls,
  frm1PlaceConfig,
  Forms,
  SysUtils,
  OmniXMLUtils,
  OmniXML,
  Classes;


const
  SIMPLE1Place = 0;

  keySeparateClientFiles = 'SeparateClientFiles';
  keyExtractPath = 'ExtractPath';

var // General Extract vars
   MyFont: TFont;

   OutputFileName: string;
   FilePerClient: Boolean;

   //Export Specific
   CurrentClientCode: string;
   CurrentAccount: string;
   CurrentContra: string;
   Country: string;
   DateText: string;

var
   FExtractFieldHelper: TExtractFieldHelper;

function  ExtractFieldHelper: TExtractFieldHelper;
begin
   if not Assigned(FExtractFieldHelper) then
      FExtractFieldHelper := TExtractFieldHelper.Create;

   Result := FExtractFieldHelper;
end;


//*****************************************************************************
//
//    REQUIRED EXPORTED FUNCTIONS
//
//*****************************************************************************

function GetExtractVersion: Integer; stdcall;
begin
   Result :=  Version_1;
end;

function GetExtractType(Index: integer; var EType: ExtractType): Boolean; stdcall;
begin
   Result := False;
   case Index of
   SIMPLE1Place : begin
          EType.Index := SIMPLE1Place;
          EType.Code  := OnePlaceBasicCode;
          EType.Description := '1place';
          EType.ExtractClass := ClassBase;
          Result := True;
      end;
   end;
end;




//*****************************************************************************
//
//   CONFIGUATION
//
//*****************************************************************************

function GetPrivateProfileText(anApp, AKey, Default, Inifile: string; bufsize: Integer = 400): string;
var LB: PChar;
begin
   Result := Default;
   if (Length(IniFile) = 0)
   or (Length(AnApp) = 0)
   or (Length(AKey) = 0) then
      Exit;

   GetMem(LB, bufsize);
   try
      GetPrivateProfileString(pchar(AnApp),pChar(AKey),pchar(Default),LB,bufsize,Pchar(IniFile));
      Result := string(LB);
   finally
      FreeMem(LB,bufsize);
   End;
End;

function FindExtractPath(Session: TExtractSession): string;
begin
   // Does not have a default, so I know if it has been set
   Result := '';
   if Session.IniFile <> nil then
     case Session.Index of
     SIMPLE1Place : Result :=  GetPrivateProfileText(OnePlaceBasicCode,keyExtractPath, '', string(Session.IniFile));
     end;
end;

function GetExtractPath(Session: TExtractSession): string;
begin
   // Forces a default, so we have a strarting point
   Result := FindExtractPath(Session);

   if Result = '' then
      Result := ExtractFilePath(Application.ExeName) + '1placeExport.xml';
end;

function Do1PlaceConfig (var Session: TExtractSession): Integer; stdcall;
var ldlg: TOnePlaceConfig;
begin
   Result := er_Cancel; // Cancel by default
   ldlg := TonePlaceConfig.Create(nil);
   try
      if Assigned(MyFont) then begin
         ldlg.Font.Assign(MyFont);
      end;
      ldlg.Caption := '1place Export Setup';
      ldlg.eFilename.Text := GetExtractPath(Session);
      ldlg.rbSplit.Checked := Bool(GetPrivateProfileInt(OnePlaceBasicCode,keySeparateClientFiles,0,Session.IniFile));
      if ldlg.ShowModal = mrOK then begin
         WritePrivateProfileString(OnePlaceBasicCode,keyExtractPath,pchar(Trim(ldlg.eFilename.Text)), Session.IniFile);
         WritePrivateProfilestring(OnePlaceBasicCode,keySeparateClientFiles,pchar(intToStr(Integer(ldlg.rbSplit.Checked))),Session.IniFile);


         Result := er_OK; // Extract path is set..
      end;
   finally
      ldlg.Free;
   end;
end;


function CheckFeature(const index, Feature: Integer): Integer; stdcall;
begin
   Result := 0;
   if Index = SIMPLE1Place then
      case Feature of
       tf_TransactionID : Result := tr_GUID;
       //tf_TransactionType :


       //tf_BankAccountType : Result := tr_Contra;
       //tf_ClientType = 4;
      end;
end;


//*****************************************************************************
//
//    XML File Handeling
//
//*****************************************************************************

var
  FOutputDocument: IXMLDocument;
  BaseNode: IxmlNode;
  ClientsNode: IxmlNode;
  AccountsNode: IxmlNode;
  AccountNode: IXMLNode;
  TransactionsNode: IxmlNode;

function OutputDocument :IXMLDocument;
begin
   if FOutputDocument = nil then begin
      FOutputDocument := CreateXMLDoc;
   end;

   Result := FOutputDocument;
end;

procedure AddFieldNode(var ToNode:IxmlNode; const Name,Value: string);
begin
   if Value > '' then // No empty Tags...
      SetNodeTextStr(ToNode,Name,Value);
end;


procedure StartFile;
begin

   OutputDocument.LoadXML(''); // Clear
   BaseNode := EnsureNode(OutputDocument,'BankLink');
   SetNodeTextStr(BaseNode,'Version','1');

   ClientsNode := OutputDocument.CreateElement('Clients');
   BaseNode.AppendChild(ClientsNode);

   AccountsNode := nil;
   AccountNode := nil;
   TransactionsNode := nil;
end;

procedure SaveFile(Filename: string);
begin
   OutputDocument.Save(FileName,ofIndent);
end;


//*****************************************************************************
//
//   Local Export Event Helpers
//
//*****************************************************************************


function TrapException (var Session: TExtractSession; value: ProcBulkExport):Integer; stdcall;
begin  // Helper to trap any IO or other exeptions
   try
      Result := Value(Session);
   except
     on E: exception do begin
        Result := er_Abort;
        Session.Data := PChar(E.Message);
     end;
   end;
end;


function CleanTextField(const Value: string): string;
begin
   Result := ExtractFieldHelper.ReplaceQuotesAndCommas
             (
                ExtractFieldHelper.RemoveQuotes(Value)
             );
end;


//*****************************************************************************
//
//   SESSION Start Stop
//
//*****************************************************************************

function OnePlaceSessionStart(var Session: TExtractSession): Integer; stdcall;
begin
   Result := er_OK;
   OutputFileName := FindExtractPath(Session);
   if OutputFileName = '' then
      if Do1PlaceConfig(Session) = er_OK then
         OutputFileName := FindExtractPath(Session);


   if OutputFileName > '' then begin
      // Can Have a Go...
      FilePerClient := Bool(GetPrivateProfileInt(OnePlaceBasicCode,keySeparateClientFiles,0,Session.IniFile));
      ExtractFieldHelper.SetFields(Session.Data);
      DateText := CleanTextField(ExtractFieldHelper.GetField(f_Date));

      if not FilePerClient then begin
         // Open File for the Whole session..
         OutputFileName := ExtractFilePath(OutputFileName)
                         + 'BankLink_1place_'
                         + DateText
                         + '.xml';

         StartFile;
         SaveFile(OutputFileName); // Test if we can write it rather than find out too late
      end;

   end else
      Result := er_Cancel; // User must have canceled
end;



function SessionEnd(var Session: TExtractSession): Integer; stdcall;
begin
   if not FilePerClient  then
      SaveFile(OutputFileName);

   FOutputDocument := nil;
   TransactionsNode := nil;
   AccountsNode := nil;
   AccountNode := nil;
   Basenode := nil;

   Result := er_OK;
end;

//******************************************************************************
//
//   CLIENT Start Stop
//
//******************************************************************************


function ClientStart(var Session: TExtractSession): Integer; stdcall;
var ClientNode: IXMLNode;
begin
   ExtractFieldHelper.SetFields(Session.Data);
   CurrentClientCode := CleanTextField(ExtractFieldHelper.GetField(f_Code));
   Country := CleanTextField(ExtractFieldHelper.GetField(f_Country));
   if FilePerClient then begin
      OutputFileName := ExtractFilePath(OutputFileName)
                      + 'BankLink_1place_'
                      + CurrentClientCode + '_'
                      + DateText
                      + '.xml';
      StartFile;
      SaveFile(OutputFileName); // Test if we can write it rather than find out at the end
   end;

   // Build the Entity Details for the Client
   ClientNode := OutputDocument.CreateElement('Client');
   ClientsNode.AppendChild(ClientNode);

   SetNodeTextStr(ClientNode,'Client_Code',CurrentClientCode);
   SetNodeTextStr(ClientNode,'Client_Name',CleanTextField(ExtractFieldHelper.GetField(f_Name)));

   AccountsNode := OutputDocument.CreateElement('Accounts');
   ClientNode.AppendChild(AccountsNode);

   TransactionsNode := nil;

   Result := er_OK;
end;

function ClientEnd (var Session: TExtractSession): Integer; stdcall;
begin
   if FilePerClient then begin
      SaveFile(OutputFileName);

   end;
   AccountsNode := nil;


   Result := er_OK;
end;

//******************************************************************************
//
//   ACCOUNT Start
//
//******************************************************************************

const // from bkConst // did not want to link it in...
   btBank            = 0; btMin = 0;
   btCashJournals    = 1;
   btAccrualJournals = 2;
   btGSTJournals     = 3;
   btStockJournals   = 4;          //non transferring
   btOpeningBalances = 5;          //non transferring
   btYearEndAdjustments = 6;       //non transferring
   btStockBalances = 7;



function AccountStart(var Session: TExtractSession): Integer; stdcall;


   function TypeText: string;
   begin
      case Session.AccountType of
      btBank            : Result := 'Bank Account';
      btCashJournals    : Result := 'Cash Journal';
      btAccrualJournals : Result := 'Accrual Journal';
      btGSTJournals     : Result := 'TAX Journal';
      else Result := ''
      end;
   end;


begin
   ExtractFieldHelper.SetFields(Session.Data);
   CurrentAccount := CleanTextField(ExtractFieldHelper.GetField(f_Number));
   CurrentContra := CleanTextField(ExtractFieldHelper.GetField(f_ContraCode));

   AccountNode := OutputDocument.CreateElement('Account');
   AccountsNode.AppendChild(AccountNode);

   AddFieldNode(AccountNode,'Account_Number',CurrentAccount);
   AddFieldNode(AccountNode,'Account_Type',TypeText);
   AddFieldNode(AccountNode,'Account_Name',CleanTextField(ExtractFieldHelper.GetField(f_Name)));
   AddFieldNode(AccountNode,'Account_Contra_Code',CurrentContra);
   AddFieldNode(AccountNode,'Opening_Balance',CleanTextField(ExtractFieldHelper.GetField(f_balance)));

   TransactionsNode := OutputDocument.CreateElement('Transactions');
   AccountNode.AppendChild(TransactionsNode);

   Result := er_OK;
end;



function AccountEnd(var Session: TExtractSession): Integer; stdcall;
begin
   AddFieldNode(AccountNode,'Closing_Balance',CleanTextField(ExtractFieldHelper.GetField(f_balance)));
   TransactionsNode := nil;
   AccountNode := nil;
   Result := er_OK;
end;


//******************************************************************************
//
//   TRANSACTION / DISSECTION
//
//******************************************************************************


procedure WriteOnePlaceFields(var Session: TExtractSession);
var LTrans: IXMLNode;


    procedure AddGuid(const Value: string);
    var id: string;
        i,o : integer;
    begin   //1234567890123456789
       id := '               ';
       o := Length(id);
       for i := Length(Value) downto 1 do begin
          if Value[i] in ['0'..'9', 'A'..'F'] then begin
             id[o] := Value[i];
             dec(o);
             if o < 1 then
                Break; // Thats all we can fit..
          end;
       end;
       AddFieldNode(lTrans,'Transaction_UID',id);
    end;

    function TaxText: string;
    begin
      if SameText(Country,'UK') then
         Result := 'VAT'
      else
         Result := 'GST';
    end;

begin
   LTrans := TransactionsNode.AppendChild(FOutputDocument.CreateElement('Transaction'));
   with ExtractFieldHelper do begin

     AddGuid(Uppercase(GetField(f_TransID)));



     //AddCode(GetField(f_Code));

     AddFieldNode(lTrans,'Date',GetField(f_Date));

     AddFieldNode(lTrans,'Narration',CleanTextField(GetField(f_Narration)));
     AddFieldNode(lTrans,'Reference',CleanTextField(GetField(f_Reference)));

     AddFieldNode(lTrans,'Code',CleanTextField(GetField(f_Code)));
     AddFieldNode(lTrans,'Code_Desc',CleanTextField(GetField(f_Desc)));

     AddFieldNode(lTrans,'Amount',GetField(f_amount));
     AddFieldNode(lTrans,TaxText,GetField(f_tax));
     AddFieldNode(lTrans,TaxText + '_Class',GetField(f_taxCode));
     AddFieldNode(lTrans,TaxText + '_Desc',GetField(f_TaxDesc));

     AddFieldNode(lTrans,'Quantity',GetField(f_Quantity));

     // Supper fields

     AddFieldNode(lTrans,'CGT_Transaction_Date',GetField(f_CGTDate));
     AddFieldNode(lTrans,'Franked_Dividend',GetField(f_Franked));
     AddFieldNode(lTrans,'UnFranked_Dividend',GetField(f_UnFranked));
     AddFieldNode(lTrans,'Imputation_Credit',GetField(f_Imp_Credit));

     AddFieldNode(lTrans,'Tax_Free_Distribution',GetField(f_TF_Dist));

     AddFieldNode(lTrans,'Tax_Exempt_Distribution',GetField(f_TE_Dist));
     AddFieldNode(lTrans,'Tax_Defered_Distribution',GetField(f_TD_Dist));
     AddFieldNode(lTrans,'TFN_Credit',GetField(f_TFN_Credit));
     AddFieldNode(lTrans,'Foreign_Income',GetField(f_Frn_Income));
     AddFieldNode(lTrans,'Foreign_Credit',GetField(f_Frn_Credit));

     AddFieldNode(lTrans,'Other_Expenses',GetField(f_OExpences));

     AddFieldNode(lTrans,'Indexed_Capital_Gain',GetField(f_CGI));
     AddFieldNode(lTrans,'Discount_Capital_Gain',GetField(f_CGD));
     AddFieldNode(lTrans,'Other_Capital_Gain',GetField(f_CGO));
     AddFieldNode(lTrans,'Member_Component',CleanTextField(GetField(f_MemComp)));

   end;
end;



function Transaction(var Session: TExtractSession): Integer; stdcall;
begin
   ExtractFieldHelper.SetFields(Session.Data);
   case Session.Index of
   SIMPLE1Place:  WriteOnePlaceFields(Session);
   end;
   Result := er_OK;
end;






//*****************************************************************************
//
//    MAIN EXPORTED EXPORT FUNCTION
//
//*****************************************************************************

function DoBulkExport(var Session: TExtractSession): Integer; stdcall;
begin
   Result := er_NotImplemented; // Do not fail
   case Session.ExtractFunction of

   ef_SessionStart  : case Session.Index of
                        SIMPLE1Place: Result := TrapException(Session,OnePlaceSessionStart);
                      end;
   ef_SessionEnd    : Result := TrapException(Session,SessionEnd);

   ef_ClientStart   : Result := TrapException(Session,ClientStart);
   ef_ClientEnd     : Result := TrapException(Session,ClientEnd);
   ef_AccountStart  : Result := TrapException(Session,AccountStart);
   ef_AccountEnd    : Result := TrapException(Session,AccountEnd);

   ef_Transaction   : Result := TrapException(Session,Transaction);
   ef_Dissection    : Result := TrapException(Session,Transaction);

   ef_CanConfig    : case Session.Index of
                       SIMPLE1Place: begin // Also Doubles as get initial settings...
                            Result := er_OK;
                       end;
                     end;
   ef_DoConfig     : case Session.Index of
                       SIMPLE1Place: Result := Do1PlaceConfig(Session);
                     end;

   end;

end;



//*****************************************************************************
//
//    Optional Export Procedures..
//
//*****************************************************************************


procedure procInitDllApplication(ApplicationHandle : HWnd; BaseFont: TFont); stdcall;
begin
  if ApplicationHandle <> 0 then
     Application.Handle := ApplicationHandle;

  if Assigned(BaseFont) then begin
     if not assigned(MyFont) then
        MyFont := TFont.Create;
     // cannot use assign because the class is not the same.
     MyFont.Name :=  BaseFont.Name;
     MyFont.Height := BaseFont.Height;
  end;
end;


initialization
  FOutputDocument := nil;
  TransactionsNode := nil;
  BaseNode := nil;

  MyFont := nil;
  OutputFileName := '';
  CurrentClientCode := '';
  CurrentAccount := '';
  CurrentContra := '';
finalization
   OutputFileName := '';

   if assigned(MyFont) then begin
      MyFont.Free;
      MyFont := nil;
   end;

   if Application.Handle <> 0 then
      Application.Handle := 0;

   FOutputDocument := nil;
   TransactionsNode := nil;
   BaseNode := nil;
end.
