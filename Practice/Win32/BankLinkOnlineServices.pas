unit BankLinkOnlineServices;

//------------------------------------------------------------------------------
interface

uses
  Forms,
  BlopiServiceFacade,
  InvokeRegistry,
  Windows,
  XMLIntf,
  TypInfo,
  Classes;

type
  TBanklinkOnlineStatus = (bosActive, bosSuspended, bosDeactivated);

  Guid                  = BlopiServiceFacade.Guid;
  ArrayOfString         = BlopiServiceFacade.ArrayOfString;
  Practice              = BlopiServiceFacade.Practice;
  Client                = BlopiServiceFacade.Client;
  NewClient             = BlopiServiceFacade.NewClient;
  User                  = BlopiServiceFacade.User;
  CatalogueEntry        = BlopiServiceFacade.CatalogueEntry;
  ArrayOfCatalogueEntry = BlopiServiceFacade.ArrayOfCatalogueEntry;
  ArrayOfGuid           = BlopiServiceFacade.ArrayOfguid;

  TVarTypeData = record
    Name     : String;
    TypeInfo : PTypeInfo;
  end;

  TArrVarTypeData = Array of TVarTypeData;

  TClientHelper = Class helper for BlopiServiceFacade.Client
  private
    function GetDeactivated: boolean;
    function GetClientConnectDays: string;
    function GetFreeTrialEndDate: TDateTime;
    function GetBillingEndDate: TDateTime;
    function GetUserOnTrial: boolean;
    function GetBillingFrequency: string;
    function GetUseClientDetails: boolean;
    function GetSuspended: boolean;
  public
    procedure UpdateAdminUser(AUserName, AEmail: WideString);
    procedure AddSubscription(AProductID: guid);
    property Deactivated: boolean read GetDeactivated;
    property ClientConnectDays: string read GetClientConnectDays; // 0 if client must always be online
    property FreeTrialEndDate: TDateTime read GetFreeTrialEndDate;
    property BillingEndDate: TDateTime read GetBillingEndDate;
    property UserOnTrial: boolean read GetUserOnTrial;
    property BillingFrequency: string read GetBillingFrequency;
    property UseClientDetails: boolean read GetUseClientDetails;
    property Suspended: boolean read GetSuspended;
  End;

  TPracticeHelper = Class helper for Practice
  private
    function GetUserRoleGuidFromPracUserType(aUstNameIndex : integer) : Guid;
  public
    function GetRoleFromPracUserType(aUstNameIndex : integer) : Role;
  End;

  TClientSummaryHelper = Class helper for BlopiServiceFacade.ClientSummary
  public
    procedure AddSubscription(AProductID: guid);
  End;

  TProductConfigService = class(TObject)
  private
    fMethodName: string;
    fSOAPRequest: InvString;

    FPractice, FPracticeCopy: Practice;
    FRegisteredForBankLinkOnline: boolean;
    FClientList: ClientList;
    FOnLine: Boolean;
    FRegistered: Boolean;
    FArrNameSpaceList : Array of TRemRegEntry;
    procedure CopyRemotableObject(ASource, ATarget: TRemotable);

    function IsUserCreatedOnBankLinkOnline(const APractice : Practice;
                                           const AUserId   : Guid   = '';
                                           const AUserCode : string = ''): Boolean;
//    function GetErrorMessage(aErrorMessages : ArrayOfServiceErrorMessage;
//                             aExceptions    : ArrayOfExceptionDetails) : string;

    function GetUseBankLinkOnline: Boolean;
    procedure SetUseBankLinkOnline(const Value: Boolean);
    function RemotableObjectToXML(ARemotable: TRemotable): string;
    procedure LoadRemotableObjectFromXML(const XML: string; ARemotable: TRemotable);
    procedure SaveRemotableObjectToFile(ARemotable: TRemotable);
    function LoadPracticeDetailsfromSystemDB: Boolean;
    procedure SavePracticeDetailsToSystemDB;
    function LoadRemotableObjectFromFile(ARemotable: TRemotable): Boolean;
    procedure SetRegisteredForBankLinkOnline(const Value: Boolean);
//    procedure LoadDummyClientList;
    function OnlineStatus: TBankLinkOnlineStatus;
    function GetTypeItemIndex(var aDataArray: TArrVarTypeData;
                              const aName : String) : integer;
    procedure AddTypeItem(var aDataArray : TArrVarTypeData;
                          var aDataItem  : TVarTypeData);
    procedure AddToXMLTypeNameList(const aName : String;
                                   aTypeInfo : PTypeInfo;
                                   var aNameList : TArrVarTypeData);
    procedure FindXMLTypeNamesToModify(const aMethodName : String;
                                       var aNameList : TArrVarTypeData);
    procedure AddXMLNStoArrays(const aCurrNode : IXMLNode;
                               var aNameList : TArrVarTypeData);
    procedure DoBeforeExecute(const MethodName: string;
                              var SOAPRequest: InvString);
    procedure SetTimeOuts(ConnecTimeout : DWord ;
                          SendTimeout   : DWord ;
                          ReciveTimeout : DWord);
    function GetServiceFacade : IBlopiServiceFacade;
    function GetClientGuid(const AClientCode: string): WideString;
    function GetCachedPractice: Practice;
    function MessageResponseHasError(AMesageresponse: MessageResponse; ErrorText: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    //Practice methods
    function GetPractice(aForceOnline : Boolean = False): Practice;
    function IsPracticeActive(ShowWarning: Boolean = true): Boolean;
    function GetCatalogueEntry(AProductId: Guid): CatalogueEntry;
    function IsPracticeProductEnabled(AProductId: Guid): Boolean;
    function IsNotesOnlineEnabled: Boolean;
    function IsCICOEnabled: Boolean;
    function SavePractice: Boolean;
    procedure AddProduct(AProductId: Guid);
    procedure ClearAllProducts;
    procedure RemoveProduct(AProductId: Guid);
    procedure SelectAllProducts;
    procedure SetPrimaryContact(AUser: User);
    property UseBankLinkOnline: Boolean read GetUseBankLinkOnline write SetUseBankLinkOnline;
    property CachedPractice: Practice read GetCachedPractice;
    //Client methods
    procedure LoadClientList;
    function GetClientDetails(AClientCode: string): Client; overload;
    function GetClientDetails(AClientGuid: Guid): Client; overload;
    function CreateNewClient(ANewClient: NewClient): Guid;
    function SaveClient(AClient: Client): Boolean;
    property Clients: ClientList read FClientList;
    //User methods
    function UpdateCreateUser(var   aUserId        : Guid;
                              const aEMail         : WideString;
                              const aFullName      : WideString;
                              const aUserCode      : WideString;
                              const aUstNameIndex  : integer;
                              var   aIsUserCreated : Boolean ) : Boolean;
    function DeleteUser(const aUserCode : string;
                        const aUserGuid : string;
                        aPractice : Practice = nil): Boolean;
    function IsPrimaryUser(const aUserCode : string = '';
                           aPractice : Practice = nil): Boolean;
    function GetUserGuid(const aUserCode : string;
                         aPractice : Practice): Guid;
    function ChangeUserPassword(const aUserCode: string;
                                const aOldPassword : string;
                                const aNewPassword : string) : Boolean;
    property OnLine: Boolean read FOnLine;
    property Registered: Boolean read FRegistered;
  end;

  //Product config singleton
  function ProductConfigService: TProductConfigService;

//------------------------------------------------------------------------------
implementation

uses
  Controls,
  Globals,
  SysUtils,
  XMLDoc,
  OPToSOAPDomConv,
  LogUtil,
  WarningMoreFrm,
  ErrorMoreFrm,
  IniSettings,
  WebUtils,
  stDate,
  IniFiles,
  Progress,
  BkConst,
  WinINet,
  SOAPHTTPClient,
  OpConvert,
  strUtils,
  WideStrUtils,
  WSDLIntf,
  IntfInfo,
  ObjAuto;

const
  UNIT_NAME = 'BankLinkOnlineServices';
  INIFILE_NAME = 'BankLinkOnline.ini';

var
  __BankLinkOnlineServiceMgr: TProductConfigService;
  DebugMe : Boolean = False;

//------------------------------------------------------------------------------
function ProductConfigService: TProductConfigService;
begin
  if not Assigned(__BankLinkOnlineServiceMgr) then
    __BankLinkOnlineServiceMgr := TProductConfigService.Create;
  Result := __BankLinkOnlineServiceMgr;
end;

{ TProductConfigService }
//------------------------------------------------------------------------------
procedure TProductConfigService.AddProduct(AProductId: Guid);
var
  i: integer;
  SubArray: ArrayOfGuid;
begin
  //Add product
  for i := Low(FPracticeCopy.Subscription) to High(FPracticeCopy.Subscription) do
    if AProductId = FPracticeCopy.Subscription[i] then
      Exit;
  //Add if still here
  SubArray := FPracticeCopy.Subscription;
  try
    SetLength(SubArray, Length(SubArray) + 1);
    SubArray[High(SubArray)] := AProductId;
  finally
    FPracticeCopy.Subscription := SubArray;
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.ClearAllProducts;
var
  i: integer;
  SubArray: ArrayOfGUID;
begin
  SubArray := FPracticeCopy.Subscription;
  try
    //Free subscription GUID's
    for i := Low(SubArray) to High(SubArray) do
      //Make sure no memory is left allocated
      SubArray[i] := '';
    SetLength(SubArray, 0);
  finally
    FPracticeCopy.Subscription := SubArray;
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.CopyRemotableObject(ASource,
  ATarget: TRemotable);
var
  Converter: IObjConverter;
  NodeObject: IXMLNode;
  NodeParent: IXMLNode;
  NodeRoot: IXMLNode;
  XML: IXMLDocument;
  XMLStr: WideString;
begin
  XML:= NewXMLDocument;
  NodeRoot:= XML.AddChild('Root');
  NodeParent:= NodeRoot.AddChild('Parent');
  Converter:= TSOAPDomConv.Create(NIL);
  NodeObject:= ASource.ObjectToSOAP(NodeRoot, NodeParent, Converter,
                                    'CopyObject', '', [ocoDontPrefixNode],
                                    XMLStr);
  ATarget.SOAPToObject(NodeRoot, NodeObject, Converter);
end;

//------------------------------------------------------------------------------
constructor TProductConfigService.Create;
var
  BlopiClientList: MessageResponseOfClientListMIdCYrSK;
begin
  //Create practice
  FPractice := Practice.Create;
  //Load Practice
  GetPractice;
  //Create client list
  FClientList := ClientList.Create;
  //Load client list
  LoadClientList;
end;

//------------------------------------------------------------------------------
function TProductConfigService.CreateNewClient(ANewClient: NewClient): Guid;
var
  i: integer;
  Msg: string;
  BlopiInterface: IBlopiServiceFacade;
  MsgResponse: MessageResponseOfGuid;
begin
  Result := '';

  if not Assigned(AdminSystem) then
    Exit;

  if not FRegistered then
    Exit;

  try
    BlopiInterface :=  GetServiceFacade;
    MsgResponse := BlopiInterface.CreateClient(CountryText(AdminSystem.fdFields.fdCountry),
                                               AdminSystem.fdFields.fdBankLink_Code,
                                               AdminSystem.fdFields.fdBankLink_Connect_Password,
                                               ANewClient);
   if Assigned(MsgResponse) then
     if (Length(MsgResponse.ErrorMessages) = 0) then
       Result := MsgResponse.Result
     else begin
       //Something went wrong
       for i := Low(MsgResponse.ErrorMessages) to High(MsgResponse.ErrorMessages) do
         Msg := Msg + ServiceErrorMessage(MsgResponse.ErrorMessages[i]).Message_;
       raise Exception.Create(Msg);
     end;
  except
    on E: Exception do
      HelpfulErrorMsg(Msg, 0);
  end;
end;

//------------------------------------------------------------------------------
destructor TProductConfigService.Destroy;
begin
  //Clear all created objects etc???
  FPracticeCopy.Free;
  FPractice.Free;
  inherited;
end;

function TProductConfigService.GetCachedPractice: Practice;
begin
  Result := FPractice;
end;

function TProductConfigService.GetCatalogueEntry(
  AProductId: Guid): CatalogueEntry;
var
  i: integer;
begin
  Result :=  nil;
  for i := Low(FPractice.Catalogue) to High(FPractice.Catalogue) do begin
    if (AProductId = FPractice.Catalogue[i].Id) then begin
      Result := FPractice.Catalogue[i];
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.GetClientDetails(AClientCode: string): Client;
var
  ClientGuid: WideString;
begin
  Result := nil;

  if not Assigned(AdminSystem) then
    Exit;

  if not FRegistered then
    Exit;

  //Find client code in the client list
  ClientGuid := GetClientGuid(AClientCode);
  if (ClientGuid <> '') then
    Result := GetClientDetails(ClientGuid);
end;

//------------------------------------------------------------------------------
function TProductConfigService.GetClientDetails(AClientGuid: Guid): Client;
var
  i, j: integer;
  BlopiInterface: IBlopiServiceFacade;
  ClientDetailResponse: MessageResponseOfClientMIdCYrSK;
  Msg: string;
begin
  Result := nil;

  if not Assigned(AdminSystem) then
    Exit;

  if not FRegistered then
    Exit;

  BlopiInterface :=  GetServiceFacade;
  //Get the client from BankLink Online
  ClientDetailResponse := BlopiInterface.GetClient(CountryText(AdminSystem.fdFields.fdCountry),
                                                   AdminSystem.fdFields.fdBankLink_Code,
                                                   AdminSystem.fdFields.fdBankLink_Connect_Password,
                                                   AClientGuid);
  if not MessageResponseHasError(MessageResponse(ClientDetailResponse), 'get the client settings from') then
    Result := ClientDetailResponse.Result;
end;

//------------------------------------------------------------------------------
function TProductConfigService.GetClientGuid(const aClientCode: string): WideString;
var
  i: integer;
begin
  Result := '';
  if Assigned(FClientList) then
    for i := Low(FClientList.Clients) to High(FClientList.Clients) do
      if (AClientCode = FClientList.Clients[i].ClientCode) then begin
        Result := FClientList.Clients[i].Id;
        Break;
      end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.GetPractice(aForceOnline : Boolean): Practice;
var
  i: integer;
  BlopiInterface: IBlopiServiceFacade;
  PracticeDetailResponse: MessageResponseOfPracticeMIdCYrSK;
  Msg: string;
  ShowProgress : Boolean;
begin
  ShowProgress := Progress.StatusSilent;

  if ShowProgress then
  begin
    Screen.Cursor := crHourGlass;
    Progress.StatusSilent := False;
    Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Connecting', 40);
  end;

  try
    try
      if Assigned(AdminSystem) then begin
        //Load cached practice details if they are registered or not

        if ShowProgress then
          Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Getting Practice Details', 50);

        FRegistered := True;
        try
          if LoadPracticeDetailsfromSystemDB then
            Result := FPractice;
        finally
          FRegistered := False;
        end;
        //try to load practice details from BankLink Online
        FOnLine := False;
        if (UseBankLinkOnline)
        or (aForceOnline) then
        begin
          //Reload from BankLink Online
          BlopiInterface := GetServiceFacade;
          PracticeDetailResponse := BlopiInterface.GetPractice(CountryText(AdminSystem.fdFields.fdCountry),
          AdminSystem.fdFields.fdBankLink_Code, AdminSystem.fdFields.fdBankLink_Connect_Password);
          if Assigned(PracticeDetailResponse) then begin
            FOnLine := True;
            if Assigned(PracticeDetailResponse.Result) then begin
              AdminSystem.fdFields.fdLast_BankLink_Online_Update := stDate.CurrentDate;
              FPractice := PracticeDetailResponse.Result;
              FRegistered := True;
            end else begin
              //Something went wrong
              Msg := '';
              for i := Low(PracticeDetailResponse.ErrorMessages) to High(PracticeDetailResponse.ErrorMessages) do
                Msg := Msg + ServiceErrorMessage(PracticeDetailResponse.ErrorMessages[i]).Message_;
              if Msg = 'Invalid BConnect Credentials' then begin
                //Clear the cached practice details if not registered for this practice code
                FPractice.Free;
                FPractice := Practice.Create;
                AdminSystem.fdFields.fdBankLink_Online_Config := '';
                AdminSystem.fdFields.fdUse_BankLink_Online := False;
                LoadPracticeDetailsfromSystemDB;
                FRegistered := False;
              end else
                raise Exception.Create(Msg);
            end;
          end;
        end;
      end;
      //Make a copy for editing
      FreeAndNil(FPracticeCopy);
      FPracticeCopy := Practice.Create;
      CopyRemotableObject(FPractice, FPracticeCopy);

      if ShowProgress then
        Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Getting Practice Details', 100);

      Result := FPracticeCopy;
    except
      on E: Exception do
        HelpfulErrorMsg(BKPRACTICENAME + ' is unable to connect to ' + BANKLINK_ONLINE_NAME +
                        '.' + #13#13 + E.Message, 0);
    end;
  finally
    if ShowProgress then
    begin
      Progress.StatusSilent := True;
      Progress.ClearStatus;
      Screen.Cursor := crDefault;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.GetUseBankLinkOnline: Boolean;
begin
  Result := False;
  if Assigned(AdminSystem) then
    Result := AdminSystem.fdFields.fdUse_BankLink_Online;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.LoadClientList;
var
  BlopiInterface: IBlopiServiceFacade;
  BlopiClientList: MessageResponseOfClientListMIdCYrSK;
  Msg: string;
  i: integer;
begin
  FClientList.Free;
  FClientList := ClientList.Create;
  if UseBankLinkOnline then begin
    BlopiInterface := GetServiceFacade;
    BlopiClientList := BlopiInterface.GetClientList(CountryText(AdminSystem.fdFields.fdCountry),
                                                    AdminSystem.fdFields.fdBankLink_Code,
                                                    AdminSystem.fdFields.fdBankLink_Connect_Password);
    if not MessageResponseHasError(MessageResponse(BlopiClientList), 'load the client list from') then
      if Assigned(BlopiClientList.Result) then
        FClientList := BlopiClientList.Result;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.LoadPracticeDetailsfromSystemDB: Boolean;
begin
  Result := False;
  if not Assigned(AdminSystem) then
    Exit;

  if AdminSystem.fdFields.fdBankLink_Online_Config <> '' then begin
    LoadRemotableObjectFromXML(AdminSystem.fdFields.fdBankLink_Online_Config, FPractice);
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.LoadRemotableObjectFromFile(ARemotable: TRemotable): Boolean;
var
  XMLDoc: IXMLDocument;
begin
  Result := False;
  if FileExists(ARemotable.ClassName + '.xml') then begin
    XMLDoc := NewXMLDocument;
    XMLDoc.LoadFromFile(ARemotable.ClassName + '.xml');
    LoadRemotableObjectFromXML(XMLDoc.XML.Text, ARemotable);
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.LoadRemotableObjectFromXML(const XML: string;
  ARemotable: TRemotable);
var
  Converter: IObjConverter;
  NodeObject: IXMLNode;
  NodeParent: IXMLNode;
  NodeRoot: IXMLNode;
  XMLDoc: IXMLDocument;
begin
  Converter := TSOAPDomConv.Create(NIL);
  XMLDoc := NewXMLDocument;
  XMLDoc.LoadFromXML(XML);
  NodeRoot := XMLDoc.ChildNodes.FindNode('Root');
  NodeParent := NodeRoot.ChildNodes.FindNode('Parent');
  NodeObject := NodeParent.ChildNodes.FindNode('CopyObject');
  ARemotable.SOAPToObject(NodeRoot, NodeObject, Converter);
end;

function TProductConfigService.MessageResponseHasError(
  AMesageresponse: MessageResponse; ErrorText: string): Boolean;
const
  MAIN_ERROR_MESSAGE = BKPRACTICENAME + ' is unable to %s ' + BANKLINK_ONLINE_NAME + '.';
var
  ErrorMessage: string;
  ErrIndex : integer;
  Details: TStringList;

  procedure AddLine(const aName: string; const aMessage: string);
  begin
    if aMessage = '' then
      Exit;
    if Assigned(Details) then begin
      if Details.Count > 0 then
        Details.add('');
      Details.Add(aName + ': ' + aMessage);
    end;
  end;

begin
  Result := False;
  if Assigned(AMesageresponse) then begin
    if not AMesageresponse.Success then begin
      //Error message returned by BankLink Online
      Result := True;
      ErrorMessage := Format(MAIN_ERROR_MESSAGE, [ErrorText]);
      Details := TStringList.Create;
      try
        for ErrIndex := 0 to high(AMesageresponse.ErrorMessages) do
        begin
          AddLine('Code', AMesageresponse.ErrorMessages[ErrIndex].ErrorCode);
          AddLine('Message', AMesageresponse.ErrorMessages[ErrIndex].Message_);
        end;
        for ErrIndex := 0 to high(AMesageresponse.Exceptions) do
        begin
          AddLine('Message', AMesageresponse.Exceptions[ErrIndex].Message_);
          AddLine('Source', AMesageresponse.Exceptions[ErrIndex].Source);
          AddLine('StackTrace', AMesageresponse.Exceptions[ErrIndex].StackTrace);
        end;
        HelpfulErrorMsg(ErrorMessage, 0, True, Details.Text, True);
      finally
        Details.Free;
      end;
    end;
  end else begin
    //No response from BankLink Online
    ErrorMessage := Format(MAIN_ERROR_MESSAGE, ['connect to']);
    HelpfulErrorMsg(ErrorMessage, 0);
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.OnlineStatus: TBankLinkOnlineStatus;
var
  IniFile: TIniFile;
begin
  Result := bosActive;
  IniFile := TIniFile.Create(ExecDir + INIFILE_NAME);
  try
    Result := TBankLinkOnlineStatus(IniFile.ReadInteger('Settings', 'Status', 0));
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.GetTypeItemIndex(var aDataArray: TArrVarTypeData;
                                                const aName : String) : integer;
var
  Index : integer;
begin
  Result := -1;
  for Index := 0 to high(aDataArray) do
  begin
    if UpperCase(aDataArray[Index].Name) = UpperCase(aName) then
    begin
      Result := Index;
      Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.AddTypeItem(var aDataArray: TArrVarTypeData;
                                            var aDataItem: TVarTypeData);
begin
  SetLength(aDataArray, High(aDataArray) + 2);
  aDataArray[High(aDataArray)] := aDataItem;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.AddToXMLTypeNameList(const aName : String;
                                                     aTypeInfo : PTypeInfo;
                                                     var aNameList : TArrVarTypeData);
var
  TypeData : PTypeData;
  PropList : PPropList;
  Index    : integer;
  NewItem  : TVarTypeData;
begin
  TypeData := GetTypeData(aTypeInfo);

  case aTypeInfo.Kind of
    tkClass : begin
      if TypeData.PropCount > 0 then
      begin
        // Loops through all published properties of the class
        new(PropList);

        GetPropInfos(aTypeInfo, PropList);
        for Index := 0 to TypeData.PropCount-1 do
        begin
          // Recursive call for published class properties
          AddToXMLTypeNameList(PropList[Index].Name, PropList[Index].PropType^, aNameList)
        end;

        Dispose(PropList)
      end
    end;
    tkDynArray : begin
      if TypeData.elType2^.Kind in
        [tkInteger, tkChar, tkFloat, tkString, tkWChar, tkLString, tkWString, tkVariant, tkInt64] then
      begin
        //Adds the name and TypeInfo to the Name List
        NewItem.Name     := aName;
        NewItem.TypeInfo := aTypeInfo;
        AddTypeItem(aNameList, NewItem);
      end
      else
      begin
        // Recursive call for array Element Type
        AddToXMLTypeNameList('Array', TypeData.elType2^, aNameList);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.FindXMLTypeNamesToModify(const aMethodName : String;
                                                         var aNameList : TArrVarTypeData);
var
  InterfaceMetaData : TIntfMetaData;
  InterfaceIndex    : integer;
  ParamIndex        : integer;
begin
  // Gets the RTTI info for the the Interface
  GetIntfMetaData(TypeInfo(IBlopiServiceFacade), InterfaceMetaData);

  // Searches for the passed method name in the Info List
  for InterfaceIndex := 0 to high(InterfaceMetaData.MDA) do
  begin
    if InterfaceMetaData.MDA[InterfaceIndex].Name = aMethodName then
    begin
      for ParamIndex := 0 to InterfaceMetaData.MDA[InterfaceIndex].ParamCount - 1 do
      begin
        AddToXMLTypeNameList(InterfaceMetaData.MDA[InterfaceIndex].Params[ParamIndex].Name,
                             InterfaceMetaData.MDA[InterfaceIndex].Params[ParamIndex].Info,
                             aNameList);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.AddXMLNStoArrays(const aCurrNode : IXMLNode;
                                                 var aNameList : TArrVarTypeData);
var
  NodeIndex : integer;
  NamSpcURI : WideString;
  NamSpcPre : WideString;
  ClassName : WideString;
  NodeName  : String;
  EditIndex : integer;
  FindIndex : integer;
  Values : Array of OleVariant;
  IsScalar : Boolean;
begin
  if not Assigned(aCurrNode) then
    Exit;

  // Searches for the Node Name in the passed Name List
  FindIndex := GetTypeItemIndex(aNameList, aCurrNode.LocalName);
  if FindIndex > -1 then
  begin
    if aCurrNode.ChildNodes.Count > 0 then
    begin
      NamSpcPre := 'D5P1';
      // Gets the Name Space URI from the RemClassRegistry, this is added in the
      // Service Facade by the Auto generated code
      RemClassRegistry.InfoToURI(aNameList[FindIndex].TypeInfo, NamSpcURI, ClassName, IsScalar);
      // since it is only fixing arrays it uses the first element name as the node name
      NodeName := aCurrNode.ChildNodes[0].NodeName;

      // Saves values
      SetLength(Values, aCurrNode.ChildNodes.Count);
      for EditIndex := 0 to aCurrNode.ChildNodes.Count - 1 do
        Values[EditIndex] := aCurrNode.ChildNodes[EditIndex].NodeValue;

      // removes all child nodes
      for EditIndex := aCurrNode.ChildNodes.Count - 1 downto 0 do
        aCurrNode.ChildNodes.Delete(EditIndex);

      // Adds the Names Space to the Array Node
      aCurrNode.DeclareNamespace(NamSpcPre, NamSpcURI);

      // ReAdds the Child nodes adding the Name Space Alias
      for EditIndex := 0 to High(Values) do
        aCurrNode.AddChild(NamSpcPre + ':' + NodeName).NodeValue := Values[EditIndex];

      SetLength(Values, 0);
    end;
  end
  else
  begin
    // Recursive call for child nodes
    for NodeIndex := 0 to aCurrNode.ChildNodes.Count - 1 do
      AddXMLNStoArrays(aCurrNode.ChildNodes.Nodes[NodeIndex], aNameList);
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.DoBeforeExecute(const MethodName: string;
                                                var SOAPRequest: InvString);
var
  Document : IXMLDocument;
  NameList : TArrVarTypeData;
  LogXmlFile : String;
begin
  // Fills the passed Name List Array with all the XML Node Names and thier
  // TypeInfo that are arrays and need thier xml name spaces added
  FindXMLTypeNamesToModify(MethodName, NameList);

  if (high(NameList) = -1) and
     (not DebugMe) then
    Exit;

  // Loads the SoapRequest into a XML Document
  Document := NewXMLDocument;
  try
    Document.LoadFromXML(SOAPRequest);

    if not Document.IsEmptyDoc then
    begin
      // Searchs in the XML for the Node Name in the passed NameList and adds
      // the relavant namespace to the node and all elements
      AddXMLNStoArrays(Document.DocumentElement, NameList);

      Document.SaveToXML(SOAPRequest);

      if DebugMe then
      begin
        LogXmlFile := Globals.DataDir + 'Blopi_' + MethodName + '_' +
                      FormatDateTime('yyyy-mm-dd hh-mm-ss zzz', Now) + '.xml';

        Document.SaveToFile(LogXmlFile);
      end;

    end;
  finally
    Document := nil;
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.SetTimeOuts(ConnecTimeout : DWord ;
                                            SendTimeout   : DWord ;
                                            ReciveTimeout : DWord);
begin
  InternetSetOption(nil, INTERNET_OPTION_CONNECT_TIMEOUT, Pointer(@ConnecTimeout), SizeOf(ConnecTimeout));
  InternetSetOption(nil, INTERNET_OPTION_SEND_TIMEOUT, Pointer(@SendTimeout), SizeOf(SendTimeout));
  InternetSetOption(nil, INTERNET_OPTION_RECEIVE_TIMEOUT, Pointer(@ReciveTimeout), SizeOf(ReciveTimeout));
end;

//------------------------------------------------------------------------------
function TProductConfigService.GetServiceFacade: IBlopiServiceFacade;
var
  HTTPRIO: THTTPRIO;
begin
  HTTPRIO := THTTPRIO.Create(nil);
  HTTPRIO.OnBeforeExecute := DoBeforeExecute;
  Result := GetIBlopiServiceFacade(False, '', HTTPRIO);
end;

//------------------------------------------------------------------------------
function TProductConfigService.IsCICOEnabled: Boolean;
var
  i, j: integer;
  Cat: CatalogueEntry;
begin
  Result := False;
  if Assigned(FPracticeCopy) then begin
    for i := Low(FPracticeCopy.Catalogue) to High(FPracticeCopy.Catalogue) do begin
      Cat := FPracticeCopy.Catalogue[i];
      if Cat.Description = 'Send and Receive Client Files' then begin
        for j := Low(FPracticeCopy.Subscription) to High(FPracticeCopy.Subscription) do begin
          if FPracticeCopy.Subscription[j] = Cat.Id then begin
            Result := True;
            Break;
          end;
        end;
        Break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.IsNotesOnlineEnabled: Boolean;
var
  i, j: integer;
  Cat: CatalogueEntry;
begin
  Result := False;
  if Assigned(FPractice) then begin
    for i := Low(FPracticeCopy.Catalogue) to High(FPracticeCopy.Catalogue) do begin
      Cat := FPracticeCopy.Catalogue[i];
      if Cat.Description = 'Notes Online' then begin
        for j := Low(FPracticeCopy.Subscription) to High(FPracticeCopy.Subscription) do begin
          if FPracticeCopy.Subscription[j] = Cat.Id then begin
            Result := True;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.IsPracticeActive(ShowWarning: Boolean): Boolean;
begin
  Result := not (OnlineStatus in [bosSuspended, bosDeactivated]);
  if ShowWarning then
    case OnlineStatus of
      bosSuspended: HelpfulWarningMsg(BANKLINK_ONLINE_NAME + ' is currently in suspended ' +
                                      '(read-only) mode. Please contact BankLink ' +
                                      'Support for further assistance.', 0);
      bosDeactivated: HelpfulWarningMsg(BANKLINK_ONLINE_NAME + ' is currently deactivated. ' +
                                        'Please contact BankLink Support for further ' +
                                        'assistance.', 0);
    end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.IsPracticeProductEnabled(
  AProductId: Guid): Boolean;
var
  i: integer;
begin
  Result := False;
  if Assigned(FPracticeCopy) then begin
    for i := Low(FPracticeCopy.Subscription) to High(FPracticeCopy.Subscription) do begin
      if FPracticeCopy.Subscription[i] = AProductID then begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.RemotableObjectToXML(
  ARemotable: TRemotable): string;
var
  Converter: IObjConverter;
  NodeObject: IXMLNode;
  NodeParent: IXMLNode;
  NodeRoot: IXMLNode;
  XMLDoc: IXMLDocument;
  XMLStr: WideString;
begin
  Result := '';
  try
    XMLDoc:= NewXMLDocument;
    NodeRoot:= XMLDoc.AddChild('Root');
    NodeParent:= NodeRoot.AddChild('Parent');
    Converter:= TSOAPDomConv.Create(NIL);
    NodeObject:= ARemotable.ObjectToSOAP(NodeRoot, NodeParent, Converter,
                                         'CopyObject', '', [ocoDontPrefixNode],
                                         XMLStr);
    Result := XMLDoc.XML.Text;
  except
    on E:Exception do HelpfulErrorMsg('Error converting remotable object to text: ' + E.Message, 0);
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.RemoveProduct(AProductId: Guid);
var
  i, j: integer;
  SubArray: ArrayOfGuid;
  ClientsUsingProduct: integer;
  Msg: string;
  TempCatalogueEntry: CatalogueEntry;
begin
  ClientsUsingProduct := 1;
  //Check if any clients are using the product
//  for i := Low(FClientList.Clients) to Low(FClientList.Clients) do begin
//    for j := Low(Client.SubList) to High(Client.SubList) do begin
//      if AProductId = Client.SubList[j] then
//        Inc(ClientsUsingProduct);
//    end;
//  end;

//  TempCatalogueEntry := GetCatalogueEntry(AProductId);
//  if Assigned(TempCatalogueEntry) then begin
//    if ClientsUsingProduct > 0 then begin
//      Msg := Format('There are currently %d clients using %s. Please remove ' +
//                    'access for these clients from this product before ' +
//                    'disabling it',
//                    [ClientsUsingProduct, TempCatalogueEntry.Description]);
//      HelpfulWarningMsg(MSg, 0);
//      Exit;
//    end;
//  end;

  SubArray := FPracticeCopy.Subscription;
  try
    for i := Low(SubArray) to High(SubArray) do begin
      if AProductId = SubArray[i] then begin
        if (i < 0) or (i > High(SubArray)) then
          Break;
        for j := i to High(SubArray) - 1 do begin
          SubArray[j] := SubArray[j+1];
        end;
        SubArray[High(SubArray)] := '';
        SetLength(SubArray, Length(SubArray) - 1);
        Break;
      end;
    end;
  finally
    FPracticeCopy.Subscription := SubArray;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.SaveClient(AClient: Client): Boolean;
var
  i: integer;
  Msg: string;
  BlopiInterface: IBlopiServiceFacade;
  MsgResponse: MessageResponse;
  MyClientSummary: ClientSummary;
  MyNewUser: NewUser;
begin
  Result := False;

  if not Assigned(AdminSystem) then
    Exit;

  if not FRegistered then
    Exit;

  try
    MyClientSummary := ClientSummary.Create;
    try
      //Save client
      MyClientSummary.Id := UpperCase(AClient.Id);
      MyClientSummary.ClientCode := AClient.ClientCode;
      MyClientSummary.Name_ := AClient.Name_;
      MyClientSummary.Status := AClient.Status;
      MyClientSummary.Subscription := AClient.Subscription;

      BlopiInterface := GetServiceFacade;
      MsgResponse := BlopiInterface.SaveClient(CountryText(AdminSystem.fdFields.fdCountry),
                                               AdminSystem.fdFields.fdBankLink_Code,
                                               AdminSystem.fdFields.fdBankLink_Connect_Password,
                                               MyClientSummary);
      if not MessageResponseHasError(MsgResponse, 'update this client''s settings on') then begin
        //Save client admin user
        if (Length(AClient.Users) > 0) then begin
          if User(AClient.Users[0]).Id = '' then begin
            //Create new client admin user
            MyNewUser := NewUser.Create;
            try
              MyNewUser.FullName := User(AClient.Users[0]).FullName;
              MyNewUser.EMail := User(AClient.Users[0]).EMail;
              MyNewUser.RoleNames := User(AClient.Users[0]).RoleNames;
              MyNewUser.UserCode := User(AClient.Users[0]).UserCode;
              MsgResponse := BlopiInterface.CreateClientUser(CountryText(AdminSystem.fdFields.fdCountry),
                                                             AdminSystem.fdFields.fdBankLink_Code,
                                                             AdminSystem.fdFields.fdBankLink_Connect_Password,
                                                             AClient.Id, MyNewUser);
              MessageResponseHasError(MsgResponse, 'create the client user on');
            finally
              MyNewUser.Free;
            end;
          end else begin
            //Update existing client admin user
            MsgResponse := BlopiInterface.SaveclientUser(CountryText(AdminSystem.fdFields.fdCountry),
                                                         AdminSystem.fdFields.fdBankLink_Code,
                                                         AdminSystem.fdFields.fdBankLink_Connect_Password,
                                                         User(AClient.Users[0]).Id, User(AClient.Users[0]));
            MessageResponseHasError(MsgResponse, 'update this client user on');
          end;
        end;
        Result := True;
      end;
    finally
      MyClientSummary.Free;
    end;
  except
    on E: Exception do
      HelpfulErrorMsg(Msg, 0);
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.SavePractice: Boolean;
var
  BlopiInterface : IBlopiServiceFacade;
  PracCountryCode : WideString;
  PracCode        : WideString;
  PracPassHash    : WideString;
  MsgResponce     : MessageResponse;
begin
  Result := False;
  if UseBankLinkOnline then begin
    if Assigned(FPracticeCopy) then begin
      FPractice.Free;
      FPractice := Practice.Create;
      CopyRemotableObject(FPracticeCopy, FPractice);
      //Save to the web service
      if FOnline then begin

        Screen.Cursor := crHourGlass;
        Progress.StatusSilent := False;
        Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Connecting', 10);
        try
          PracCountryCode := CountryText(AdminSystem.fdFields.fdCountry);
          PracCode        := AdminSystem.fdFields.fdBankLink_Code;
          PracPassHash    := AdminSystem.fdFields.fdBankLink_Connect_Password;

          BlopiInterface := GetServiceFacade;

          Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Saving Practice Details to ' + BANKLINK_ONLINE_NAME, 33);

          MsgResponce := BlopiInterface.SavePractice(PracCountryCode, PracCode, PracPassHash, FPractice);
          if not MessageResponseHasError(MsgResponce, 'update the Practice settings to') then
          begin
            Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Saving Practice Details to System Database', 66);

            //If save ok then save an offline copy to System DB
            SavePracticeDetailsToSystemDB;
            Result := True;
            Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Completed', 100);
          end;
        finally
          Progress.StatusSilent := True;
          Progress.ClearStatus;
          Screen.Cursor := crDefault;
        end;

      end else begin
        HelpfulErrorMsg(BKPRACTICENAME + ' is unable to update the Practice settings to ' + BANKLINK_ONLINE_NAME + '.', 0);
      end;
    end;
  end else begin
    //Settings are only saved locally if not using BankLink Online
    SavePracticeDetailsToSystemDB;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.SavePracticeDetailsToSystemDB;
begin
  if not Assigned(AdminSystem) then
    Exit;

  AdminSystem.fdFields.fdBankLink_Online_Config := RemotableObjectToXML(FPractice);
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.SaveRemotableObjectToFile(ARemotable: TRemotable);
var
  XMLDoc: IXMLDocument;
begin
  XMLDoc:= NewXMLDocument;
  XMLDoc.LoadFromXML(RemotableObjectToXML(ARemotable));
  XMLDoc.SaveToFile(ARemotable.ClassName + '.xml');
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.SelectAllProducts;
var
  i: integer;
  Cat: CatalogueEntry;
  SubArray: ArrayOfGUID;
begin
  SubArray := FPracticeCopy.Subscription;
  try
    SetLength(SubArray, Length(FPracticeCopy.Catalogue));
    for i := Low(FPracticeCopy.Catalogue) to High(FPracticeCopy.Catalogue) do begin
      Cat := FPracticeCopy.Catalogue[i];
      SubArray[i] := Cat.Id;
    end;
  finally
    FPracticeCopy.Subscription := SubArray;
  end;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.SetPrimaryContact(AUser: User);
begin
  FPracticeCopy.DefaultAdminUserId := AUser.Id;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.SetRegisteredForBankLinkOnline(
  const Value: Boolean);
begin
  FRegisteredForBankLinkOnline := Value;
end;

//------------------------------------------------------------------------------
procedure TProductConfigService.SetUseBankLinkOnline(const Value: Boolean);
begin
  if Assigned(AdminSystem) then
    AdminSystem.fdFields.fdUse_BankLink_Online := Value;
end;              

{ TClientHelper }
//------------------------------------------------------------------------------
function TClientHelper.GetClientConnectDays: string;
begin
  Result := '90';
end;

//------------------------------------------------------------------------------
function TClientHelper.GetDeactivated: boolean;
begin
  Result := true;
end;

//------------------------------------------------------------------------------
function TClientHelper.GetFreeTrialEndDate: TDateTime;
begin
  Result := StrToDate('31/12/2011');
end;

//------------------------------------------------------------------------------
function TClientHelper.GetSuspended: boolean;
begin
  Result := (Self.Status = BlopiServiceFacade.Suspended);
end;

//------------------------------------------------------------------------------
function TClientHelper.GetUseClientDetails: boolean;
begin
  Result := true;
end;

//------------------------------------------------------------------------------
function TClientHelper.GetUserOnTrial: boolean;
begin
  Result := false;
end;

procedure TClientHelper.UpdateAdminUser(AUserName, AEmail: WideString);
var
  UserArray: ArrayOfUser;
  RoleArray: ArrayOfString;
  NewUser: User;
begin
  //Should only be one client admin user
  if Length(Self.Users) = 0 then begin
    //Add
    NewUser := User.Create;
    UserArray := Self.Users;
    try
      SetLength(UserArray, Length(Self.Users) + 1);
      Self.Users := UserArray;
      Self.Users[0] := NewUser;
      RoleArray := NewUser.RoleNames;
      try
        SetLength(RoleArray, Length(NewUser.RoleNames) + 1);
        RoleArray[0] := 'Client Administrator';
      finally
        NewUser.RoleNames := RoleArray;
      end;
    finally
      Self.Users := UserArray;
    end;
  end;
  //Update
  User(Self.Users[0]).FullName := AUserName;
  User(Self.Users[0]).EMail := AEmail;
end;

procedure TClientHelper.AddSubscription(AProductID: guid);
var
  SubArray: arrayofguid;
  i: integer;
begin
  for i := Low(Subscription) to High(Subscription) do
    if (Subscription[i] = AProductID) then
      Exit;

  SubArray := Subscription;
  try
    SetLength(SubArray, Length(SubArray) + 1);
    SubArray[High(SubArray)] := UpperCase(AProductId);
  finally
    Subscription := SubArray;
  end;
end;

//------------------------------------------------------------------------------
function TClientHelper.GetBillingEndDate: TDateTime;
begin
  Result := StrToDate('31/12/2011');
end;

//------------------------------------------------------------------------------
function TClientHelper.GetBillingFrequency: string;
begin
  Result := 'Monthly';
end;

//------------------------------------------------------------------------------
function TProductConfigService.IsUserCreatedOnBankLinkOnline(const APractice : Practice;
                                                             const AUserId   : Guid   = '';
                                                             const AUserCode : string = '') : Boolean;
var
  UserIndex : Integer;
begin
  Result := False;

  // Goes through passed through Practice users and finds the first one with either
  // a matching Guid or Code
  for UserIndex := 0 to High(APractice.Users) do
  begin
    if (APractice.Users[UserIndex].Id       = AUserId)
    or (APractice.Users[UserIndex].UserCode = AUserCode) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------
//function TProductConfigService.GetErrorMessage(aErrorMessages : ArrayOfServiceErrorMessage;
//                                               aExceptions    : ArrayOfExceptionDetails ) : string;
//var
//  ErrIndex : integer;
//
//  //-----------------------------------------
//  procedure AddLine(var   aErrStr  : String;
//                    const aName    : String;
//                    const aMessage : String);
//  begin
//    if aMessage = '' then
//      Exit;
//
//    aErrStr := aErrStr + aName + ':' + #10 + aMessage + #10;
//  end;
//
//begin
//  Result := '';
//
//  for ErrIndex := 0 to high(aErrorMessages) do
//  begin
//    AddLine(Result, 'Code', aErrorMessages[ErrIndex].ErrorCode);
//    Result := Result + #10;
//    AddLine(Result, 'Message', aErrorMessages[ErrIndex].Message_);
//  end;
//
//  if not (Result = '') then
//    Result := #10 + Result;
//
//  for ErrIndex := 0 to high(aExceptions) do
//  begin
//    AddLine(Result, 'Message', aExceptions[ErrIndex].Message_);
//    Result := Result + #10;
//    AddLine(Result, 'Source', aExceptions[ErrIndex].Source);
//    Result := Result + #10;
//    AddLine(Result, 'StackTrace', aExceptions[ErrIndex].StackTrace);
//  end;
//end;

//------------------------------------------------------------------------------
function TProductConfigService.UpdateCreateUser(var   aUserId        : Guid;
                                                const aEMail         : WideString;
                                                const aFullName      : WideString;
                                                const aUserCode      : WideString;
                                                const aUstNameIndex  : integer;
                                                var   aIsUserCreated : Boolean ) : Boolean;
var
  UpdateUser      : User;
  CreateUser      : NewUser;
  PracCountryCode : WideString;
  PracCode        : WideString;
  PracPassHash    : WideString;
  MsgResponce     : MessageResponse;
  MsgResponceGuid : MessageResponseOfguid;
  ErrMsg          : String;
  CurrPractice    : Practice;
  IsUserOnline    : Boolean;
  BlopiInterface  : IBlopiServiceFacade;
  RoleNames       : ArrayOfString;
begin
  Result := false;

  aIsUserCreated := false;  
  Screen.Cursor := crHourGlass;
  Progress.StatusSilent := False;
  Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Connecting', 10);

  try
    PracCountryCode := CountryText(AdminSystem.fdFields.fdCountry);
    PracCode        := AdminSystem.fdFields.fdBankLink_Code;
    PracPassHash    := AdminSystem.fdFields.fdBankLink_Connect_Password;

    try
      // Does the User Already Exist on BankLink Online?
      Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Recieving Data from ' + BANKLINK_ONLINE_NAME, 33);
      CurrPractice := GetPractice(true);

      IsUserOnline := IsUserCreatedOnBankLinkOnline(CurrPractice, aUserId, aUserCode);

      SetLength(RoleNames,1);
      RoleNames[0] := CurrPractice.GetRoleFromPracUserType(aUstNameIndex).RoleName;
    except
      on E : Exception do
      begin
        LogUtil.LogMsg(lmError, UNIT_NAME, 'Exception running IsUserCreatedOnBankLinkOnline, Error Message : ' + E.Message);
        raise Exception.Create(BKPRACTICENAME + ' was unable to connect to ' + BANKLINK_ONLINE_NAME + '.' + #13#13 + E.Message );
      end;
    end;

    Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Sending Data to ' + BANKLINK_ONLINE_NAME, 66);
    BlopiInterface := GetServiceFacade;
    //SetTimeOuts(5000,5000,5000);

    if IsUserOnline then
    begin
      if aUserId = '' then
        aUserId := GetUserGuid(aUserCode, CurrPractice);

      UpdateUser := User.Create;
      UpdateUser.EMail        := aEMail;
      UpdateUser.FullName     := aFullName;
      UpdateUser.Id           := aUserId;
      UpdateUser.RoleNames    := RoleNames;
      UpdateUser.Subscription := CurrPractice.Subscription;
      UpdateUser.UserCode     := aUserCode;

//      try
//        MsgResponce := BlopiInterface.SavePracticeUser(PracCountryCode, PracCode, PracPassHash, UpdateUser);
//      except
//        on E : Exception do
//        begin
//          LogUtil.LogMsg(lmError, UNIT_NAME, 'Exception running SavePracticeUser, Error Message : ' + E.Message);
//          raise Exception.Create(BKPRACTICENAME + ' was unable to connect to ' + BANKLINK_ONLINE_NAME + '.' + #13#13 + E.Message );
//        end;
//      end;
//
//      Result := MsgResponce.Success;
//      if not Result then
//      begin
//        ErrMsg := GetErrorMessage(MsgResponce.ErrorMessages, MsgResponce.Exceptions);
//
//        LogUtil.LogMsg(lmError, UNIT_NAME, 'Server Error running SavePracticeUser, Error Message : ' + ErrMsg);
//        raise Exception.Create(BKPRACTICENAME + ' was unable to update ' + UpdateUser.FullName +
//                               ' on ' + BANKLINK_ONLINE_NAME + '.' + ErrMsg );
//      end;

      MsgResponce := BlopiInterface.SavePracticeUser(PracCountryCode, PracCode, PracPassHash, UpdateUser);
      if not MessageResponseHasError(MsgResponce, 'update practice user on') then
        Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Finnished', 100);
    end
    else
    begin
      CreateUser := NewUser.Create;
      CreateUser.EMail        := aEMail;
      CreateUser.FullName     := aFullName;
      CreateUser.RoleNames    := RoleNames;
      CreateUser.Subscription := CurrPractice.Subscription;
      CreateUser.UserCode     := aUserCode;

//      try
//        MsgResponceGuid := BlopiInterface.CreatePracticeUser(PracCountryCode, PracCode, PracPassHash, CreateUser);
//      except
//        on E : Exception do
//        begin
//          LogUtil.LogMsg(lmError, UNIT_NAME, 'Exception running CreatePracticeUser, Error Message : ' + E.Message);
//          raise Exception.Create(BKPRACTICENAME + ' was unable to connect to ' + BANKLINK_ONLINE_NAME + '.' + #13#13 + E.Message );
//        end;
//      end;
//      Result  := MsgResponceGuid.Success;
//      aUserId := MsgResponceGuid.Result;
//
//      if not Result then
//      begin
//        ErrMsg := GetErrorMessage(MsgResponceGuid.ErrorMessages, MsgResponceGuid.Exceptions);
//
//        LogUtil.LogMsg(lmError, UNIT_NAME, 'Server Error running CreatePracticeUser, Error Message : ' + ErrMsg);
//        raise Exception.Create(BKPRACTICENAME + ' was unable to create ' + CreateUser.FullName +
//                               ' on ' + BANKLINK_ONLINE_NAME + '.' + ErrMsg );
//      end;

      MsgResponceGuid := BlopiInterface.CreatePracticeUser(PracCountryCode, PracCode, PracPassHash, CreateUser);
      if not MessageResponseHasError(MsgResponce, 'create practice user on') then begin
        Result  := MsgResponceGuid.Success;
        aUserId := MsgResponceGuid.Result;
        aIsUserCreated := True;
        Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Finnished', 100);
      end;
    end;
  finally
    Progress.StatusSilent := True;
    Progress.ClearStatus;
    Screen.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.DeleteUser(const aUserCode : string;
                                          const aUserGuid : string;
                                          aPractice : Practice) : Boolean;
var
  PracCountryCode : WideString;
  PracCode        : WideString;
  PracPassHash    : WideString;
  MsgResponce     : MessageResponse;
  ErrMsg          : String;
  BlopiInterface  : IBlopiServiceFacade;
  UserGuid        : Guid;
begin
  Result := false;

  Screen.Cursor := crHourGlass;
  Progress.StatusSilent := False;
  Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Connecting', 10);

  try
    BlopiInterface  := GetServiceFacade;
    PracCountryCode := CountryText(AdminSystem.fdFields.fdCountry);
    PracCode        := AdminSystem.fdFields.fdBankLink_Code;
    PracPassHash    := AdminSystem.fdFields.fdBankLink_Connect_Password;

//    try
    if not Assigned(aPractice) then
      aPractice := GetPractice;

    Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Sending Data to ' + BANKLINK_ONLINE_NAME, 50);
    if aUserCode = '' then
      UserGuid := aUserGuid
    else
    UserGuid := GetUserGuid(aUserCode, aPractice);
    MsgResponce := BlopiInterface.DeletePracticeUser(PracCountryCode, PracCode, PracPassHash, UserGuid);

    if not MessageResponseHasError(MsgResponce, 'delete practice user on') then begin
      Result := MsgResponce.Success;
      Progress.UpdateAppStatus(BANKLINK_ONLINE_NAME, 'Finnished', 100);
    end;
//    except
//      on E : Exception do
//      begin
//        LogUtil.LogMsg(lmError, UNIT_NAME, 'Exception running DeletePracticeUser, Error Message : ' + E.Message);
//        raise Exception.Create(BKPRACTICENAME + ' was unable to connect to ' + BANKLINK_ONLINE_NAME + '.' + #13#13 + E.Message );
//      end;
//    end;

//    if not Result then
//    begin
//      ErrMsg := GetErrorMessage(MsgResponce.ErrorMessages, MsgResponce.Exceptions);
//
//      LogUtil.LogMsg(lmError, UNIT_NAME, 'Server Error running DeletePracticeUser, Error Message : ' + ErrMsg);
//      raise Exception.Create(BKPRACTICENAME + ' was unable to delete user' +
//                             ' from ' + BANKLINK_ONLINE_NAME + ': ' + ErrMsg );
//    end;
  finally
    Progress.StatusSilent := True;
    Progress.ClearStatus;
    Screen.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.IsPrimaryUser(const aUserCode : string;
                                             aPractice : Practice): Boolean;
begin
  if aUserCode = '' then
  begin
    Result := false;
    Exit;
  end;

  if not Assigned(aPractice) then
    aPractice := GetPractice(true);

  Result := (GetUserGuid(aUserCode, aPractice) = aPractice.DefaultAdminUserId);
end;

//------------------------------------------------------------------------------
function TProductConfigService.GetUserGuid(const aUserCode : string;
                                           aPractice : Practice): Guid;
var
  i: integer;
  TempUser: User;
begin
  Result := '';

  for i := Low(aPractice.Users) to High(aPractice.Users) do
  begin
    TempUser := aPractice.Users[i];
    if TempUser.UserCode = AUserCode then begin
      Result := TempUser.Id;
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TProductConfigService.ChangeUserPassword(const aUserCode    : string;
                                                  const aOldPassword : string;
                                                  const aNewPassword : string) : Boolean;
begin
  Result := True;
end;

{ TClientSummaryHelper }
//------------------------------------------------------------------------------
procedure TClientSummaryHelper.AddSubscription(AProductID: guid);
var
  SubArray: arrayofguid;
  i: integer;
begin
  for i := Low(Subscription) to High(Subscription) do
    if (Subscription[i] = AProductID) then
      Exit;

  SubArray := Subscription;
  try
    SetLength(SubArray, Length(SubArray) + 1);
    SubArray[High(SubArray)] := AProductId;
  finally
    Subscription := SubArray;
  end;
end;

{ TPracticeHelper }
//------------------------------------------------------------------------------
function TPracticeHelper.GetUserRoleGuidFromPracUserType(aUstNameIndex: integer): Guid;
begin
  Result := '';
  if (aUstNameIndex < ustMin)
  or (aUstNameIndex > ustMax) then
    raise Exception.Create('Practice User Type does not exist in the Admin System.');

  case aUstNameIndex of
                            // Accountant Practice Standard User
    ustRestricted : Result := '8C464F01-5071-4FC1-B257-0104D48D141B';
                            // Accountant Practice Standard User
    ustNormal     : Result := '8C464F01-5071-4FC1-B257-0104D48D141B';
                            // Accountant Practice Administrator
    ustSystem     : Result := '8C464F01-5071-4FC1-B257-0104D48D1418';
  end;
end;

//------------------------------------------------------------------------------
function TPracticeHelper.GetRoleFromPracUserType(aUstNameIndex: integer): Role;
var
  RoleGuid : Guid;
  RoleIndex : integer;
begin
  Result := Nil;
  RoleGuid := GetUserRoleGuidFromPracUserType(aUstNameIndex);

  for RoleIndex := 0 to High(Self.Roles) do
  begin
    if (UpperCase(Self.Roles[RoleIndex].Id) = RoleGuid) then
    begin
      Result := Self.Roles[RoleIndex];
      Exit;
    end;
  end;

  raise Exception.Create('Practice User Role does not exist on ' + BANKLINK_ONLINE_NAME + '.');
end;

//------------------------------------------------------------------------------
initialization
  DebugMe := DebugUnit(UNIT_NAME);

end.
