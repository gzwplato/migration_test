unit PracDetailsFrm;

//------------------------------------------------------------------------------
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  OvcBase,
  OvcEF,
  OvcPB,
  OvcNF,
  Buttons,
  ExtCtrls,
  ExtDlgs,
  ComCtrls,
  BankLinkOnlineServices,
  OSFont,
  VirtualTrees,
  ActnList, CheckLst;

type
  TCheckListBoxHelper = class helper for TCheckListBox
  public
    function CountCheckedItems: Integer;
  end;

  TfrmPracticeDetails = class(TForm)
    OvcController1: TOvcController;
    btnOK: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    tbsDetails: TTabSheet;
    tbsInterfaces: TTabSheet;
    gbxClientDefault: TGroupBox;
    Label4: TLabel;
    lblLoad: TLabel;
    lblSave: TLabel;
    btnLoadFolder: TSpeedButton;
    btnSaveFolder: TSpeedButton;
    lblMask: TLabel;
    cmbSystem: TComboBox;
    eLoad: TEdit;
    eSave: TEdit;
    eMask: TEdit;
    Label1: TLabel;
    ePracName: TEdit;
    edtPhone: TEdit;
    Label9: TLabel;
    Label7: TLabel;
    ePracEmail: TEdit;
    edtWebSite: TEdit;
    Label10: TLabel;
    gbxDownLoad: TGroupBox;
    lblConnect: TLabel;
    Label3: TLabel;
    eBCode: TEdit;
    Label15: TLabel;
    edtLogoBitmapFilename: TEdit;
    btnBrowseLogoBitmap: TSpeedButton;
    lblLogoBitmapNote: TLabel;
    lblCountry: TLabel;
    OpenPictureDlg: TOpenPictureDialog;
    imgPracticeLogo: TImage;
    txtLastDiskID: TEdit;
    tsSuperFundSystem: TTabSheet;
    gbxSuperSystem: TGroupBox;
    lblSuperfundSystem: TLabel;
    lblSuperLoad: TLabel;
    lblSuperSave: TLabel;
    btnSuperLoadFolder: TSpeedButton;
    btnSuperSaveFolder: TSpeedButton;
    lblSuperMask: TLabel;
    cmbSuperSystem: TComboBox;
    eSuperLoad: TEdit;
    eSuperSave: TEdit;
    eSuperMask: TEdit;
    gbxWebExport: TGroupBox;
    Label11: TLabel;
    cmbWebFormats: TComboBox;
    gbxTaxInterface: TGroupBox;
    Label5: TLabel;
    cmbTaxInterface: TComboBox;
    Label8: TLabel;
    edtSaveTaxTo: TEdit;
    btnTaxFolder: TSpeedButton;
    tbsPracticeManagementSystem: TTabSheet;
    gbxPracticeManagementSystem: TGroupBox;
    lblPracticeManagementSystem: TLabel;
    cmbPracticeManagementSystem: TComboBox;
    Label2: TLabel;
    btnEdit: TButton;
    tsBankLinkOnline: TTabSheet;
    ckUseBankLinkOnline: TCheckBox;
    lblURL: TLabel;
    edtURL: TEdit;
    lblPrimaryContact: TLabel;
    cbPrimaryContact: TComboBox;
    lblSelectProducts: TLabel;
    vtProducts: TVirtualStringTree;
    btnSelectAll: TButton;
    btnClearAll: TButton;
    ActionList1: TActionList;
    actSelectAllProducts: TAction;
    actClearAllProducts: TAction;
    tbsDataExport: TTabSheet;
    chklistExportTo: TCheckListBox;
    Label6: TLabel;
    lblAcclipseCode: TLabel;
    edtAcclipseCode: TEdit;
    
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadFolderClick(Sender: TObject);
    procedure btnSaveFolderClick(Sender: TObject);
    procedure cmbSystemChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnTaxFolderClick(Sender: TObject);
    procedure cmbTaxInterfaceChange(Sender: TObject);
    procedure btnBrowseLogoBitmapClick(Sender: TObject);
    procedure edtLogoBitmapFilenameChange(Sender: TObject);
    procedure txtLastDiskIDChange(Sender: TObject);
    procedure btnSuperLoadFolderClick(Sender: TObject);
    procedure btnSuperSaveFolderClick(Sender: TObject);
    procedure cmbSuperSystemChange(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure vtProductsBeforeItemPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var CustomDraw: Boolean);
    procedure vtProductsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ckUseBankLinkOnlineClick(Sender: TObject);
    procedure vtProductsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vtProductsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure tbsInterfacesShow(Sender: TObject);
    procedure cbPrimaryContactClick(Sender: TObject);
    procedure TreeCompare(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex;
    var Result: Integer);
    procedure actSelectAllProductsExecute(Sender: TObject);
    procedure actClearAllProductsExecute(Sender: TObject);
    procedure tbsDetailsShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure chklistExportToClickCheck(Sender: TObject);
  private
    { Private declarations }
    okPressed : boolean;
    PassGenCodeEntered : boolean;
    ChangingDiskID : boolean;
    InSetup: Boolean;
    FPrac: TBloPracticeRead;
    FPreviousPage: integer;
    FOnlineSettingsChanged: Boolean;

    procedure SetUpHelp;
    function AddTreeNode(AVST: TCustomVirtualStringTree; ANode:
                               PVirtualNode; ACaption: widestring;
                               AObject: TObject): PVirtualNode;
    function VerifyForm: boolean;
    procedure ReloadLogo;
    procedure SetUpAccounting(const AccountingSystem: Byte);
    procedure SetUpSuper(const SuperfundSystem: Byte);
    procedure SetUpWebExport(const WebExportFormat: Byte);
    procedure LoadPracticeDetails;
  public
    { Public declarations }
    function Execute(SelPracticeMan: Boolean) : boolean;
  end;

  //Node data record
  PTreeData = ^TTreeData;
  TTreeData = record
    tdCaption: widestring;
    tdObject: TObject;
  end;

  { "http://www.banklinkonline.com/2011/11/Blopi"[GblSmpl] }
  Status = (Active, Suspended, Deactivated);

  //----------------------------------------------------------------------
  function EditPracticeDetails (w_PopupParent: TForm; SelPracticeMan: Boolean = False): boolean;

//------------------------------------------------------------------------------
implementation

{$R *.DFM}

uses
  MailFrm,
  BKHelp,
  bkXPThemes,
  globals,
  glConst,
  GenUtils,
  Admin32,
  bkconst,
  LogUtil,
  ErrorMoreFrm,
  WarningMoreFrm,
  InfoMoreFrm,
  imagesfrm,
  Software,
  ShellUtils,
  StdHints,
  EnterPwdDlg,
  ComboUtils,
  DownloadUtils,
  WinUtils,
  YesNoDlg, SYDEFS,
  UsageUtils,
  AuditMgr,
  RequestRegFrm,
  ServiceAgreementDlg,
  UpdateMF,
  commctrl;

const
  UnitName = 'PRACDETAILSFRM';

type
  TVendorExport = class
  private
    FId: TBloGuid;
  public
    constructor Create(VendorExportID: TBloGuid);
    
    property Id: TBloGuid read FId;
  end;

var
  DebugMe : boolean = false;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.FormCreate(Sender: TObject);
begin
  bkXPThemes.ThemeForm( Self);

  lblConnect.caption := BCONNECTNAME+' &Code';

  // btnLoadFolder.Glyph := ImagesFrm.AppImages.imgFindStates.Picture.Bitmap;
  ImagesFrm.AppImages.Misc.GetBitmap(MISC_FINDFOLDER_BMP,btnLoadFolder.Glyph);
  ImagesFrm.AppImages.Misc.GetBitmap(MISC_FINDFOLDER_BMP,btnSaveFolder.Glyph);
  ImagesFrm.AppImages.Misc.GetBitmap(MISC_FINDFOLDER_BMP,btnTaxFolder.Glyph);
  SetUpHelp;
  lblLogoBitmapNote.Caption   := 'Note: This image will be added to ' + glConst.ECODING_APP_NAME + ' files and ' +
                               BKBOOKSNAME + ' files';

  ImagesFrm.AppImages.Maintain.GetBitmap(MAINTAIN_PREVIEW_BMP,btnBrowseLogoBitmap.Glyph);
  ChangingDiskID := false;

  btnSuperLoadFolder.Glyph := btnLoadFolder.Glyph;
  ImagesFrm.AppImages.Misc.GetBitmap(MISC_FINDFOLDER_BMP,btnSuperSaveFolder.Glyph);

  FPreviousPage := 0;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.SetUpAccounting(const AccountingSystem: Byte);
var
  CanRefresh,
  UseSaveTo : Boolean;
  AccountingSystemSelected: Boolean;
begin
  CanRefresh := CanRefreshChart( AdminSystem.fdFields.fdCountry, AccountingSystem);
  UseSaveTo := UseSaveToField(AdminSystem.fdFields.fdCountry, AccountingSystem);

  AccountingSystemSelected := not ( AccountingSystem = asNone);

  lblMask.Enabled := AccountingSystemSelected;
  eMask.Enabled := AccountingSystemSelected;
  lblLoad.Enabled := AccountingSystemSelected and CanRefresh;
  eLoad.Enabled   := AccountingSystemSelected and CanRefresh;
  btnLoadFolder.Enabled := AccountingSystemSelected and CanRefresh;
  lblSave.Enabled := AccountingSystemSelected and UseSaveTo;
  eSave.Enabled := AccountingSystemSelected and UseSaveTo;
  btnSaveFolder.Enabled := AccountingSystemSelected and UseSaveTo;

  if (AccountingSystem = asNone) then begin
    eMask.Text := '';
    eLoad.Text := '';
    eSave.Text := '';
  end else begin
    eMask.Text := AdminSystem.fdFields.fdAccount_Code_Mask;
    eLoad.Text := AdminSystem.fdFields.fdLoad_Client_Files_From;
    eSave.Text := AdminSystem.fdFields.fdSave_Client_Files_To;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.SetUpHelp;
begin
  Self.ShowHint    := INI_ShowFormHints;
  Self.HelpContext := 0;
  //Components
  ePracName.Hint   :=
    'Enter your Practice Name|'+
    'Enter your Practice Name';
  ePracEMail.Hint   :=
    'Enter your Practice E-mail address|'+
    'Enter your Practice E-mail address';
  edtPhone.Hint    := 'Enter your contact phone number for clients';

  edtWebSite.Hint  := 'Enter the address of your practice web site';

  eBCode.Hint      :=
    'Enter the '+SHORTAPPNAME+' Code assigned to your Practice|'+
    'Enter the '+SHORTAPPNAME+' Code assigned to your Practice';
  txtLastDiskID.Hint :=
    'Enter the number of the last '+SHORTAPPNAME+' data file processed|'+
    'Enter the number of the last '+SHORTAPPNAME+' data file processed';
  cmbSystem.Hint   :=
    'Select the main accounting system used in your Practice|'+
    'Select the main accounting system used in your Practice' ;
  eLoad.Hint       :=
    'Enter the default directory path to your chart files|'+
    'Enter the default directory path to your chart files';
  eSave.Hint       :=
    'Enter the default directory path to extract transactions to|'+
    'Enter the default directory path to extract transactions to';
  eMask.Hint       :=
    'Enter the default Account Code mask|'+
    'Enter the default Account Code mask';

  btnLoadFolder.Hint    := STDHINTS.DirButtonHint;

  btnSaveFolder.Hint    := STDHINTS.DirButtonHint;

  //Superfund system hints
  eSuperMask.Hint := eMask.Hint;
  eSuperLoad.Hint := eLoad.Hint;
  eSuperSave.Hint := eSave.Hint;
  btnSuperLoadFolder.Hint := STDHINTS.DirButtonHint;
  btnSuperSaveFolder.Hint := STDHINTS.DirButtonHint;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.SetUpSuper(const SuperfundSystem: Byte);
var
  CanRefresh : Boolean;
  SuperSystemSelected: Boolean;
begin
  CanRefresh := CanRefreshChart( AdminSystem.fdFields.fdCountry, SuperfundSystem);
  SuperSystemSelected := not ( SuperfundSystem = asNone);

  lblSuperMask.Enabled := SuperSystemSelected;
  eSuperMask.Enabled := SuperSystemSelected;
  lblSuperLoad.Enabled := SuperSystemSelected and CanRefresh;
  eSuperLoad.Enabled   := SuperSystemSelected and CanRefresh;
  btnSuperLoadFolder.Enabled := SuperSystemSelected and CanRefresh;
  lblSuperSave.Enabled := SuperSystemSelected;
  eSuperSave.Enabled := SuperSystemSelected;
  btnSuperSaveFolder.Enabled := SuperSystemSelected;

  if (SuperfundSystem = asNone) then begin
    eSuperMask.Text := '';
    eSuperLoad.Text := '';
    eSuperSave.Text := '';
  end else begin
    eSuperMask.Text := AdminSystem.fdFields.fdSuperfund_Code_Mask;
    eSuperLoad.Text := AdminSystem.fdFields.fdLoad_Client_Super_Files_From;
    eSuperSave.Text := AdminSystem.fdFields.fdSave_Client_Super_Files_To;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.SetUpWebExport(const WebExportFormat: Byte);
var
  i: integer;
begin
  //Notes online option is dependant on the service being enabled
  cmbWebFormats.Clear;
  for i := wfMin to wfMax do
    if (wfNames[i] = WebNotesName) then begin
      if (UseBankLinkOnline) then
        if (ProductConfigService.IsNotesOnlineEnabled) then
          cmbWebFormats.Items.AddObject(wfNames[i], TObject(i));
    end else
      cmbWebFormats.Items.AddObject(wfNames[i], TObject(i));

  //Set to default if currently Notes Online and Notes Online is disabled
  ComboUtils.SetComboIndexByIntObject(WebExportFormat, cmbWebFormats);
  if UseBankLinkOnline then begin
    //If web export format currently WebNotes and product not enabled then set to None
    if (wfNames[WebExportFormat] = WebNotesName) and (not ProductConfigService.IsNotesOnlineEnabled) then
      ComboUtils.SetComboIndexByIntObject(wfDefault, cmbWebFormats);
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.btnOKClick(Sender: TObject);
begin
  // Make sure we have an accounting System
  if (GetComboCurrentIntObject(cmbSuperSystem,asNone) = asNone)
  and (GetComboCurrentIntObject(cmbSystem,asNone) = asNone) then begin
     PageControl1.ActivePage := tbsInterfaces;
     cmbSystem.SetFocus;
     HelpfulErrorMsg('Please select either an Accounting or Superfund sytem.',0);
     Exit;
  end;

  okPressed := true;

  Close;  
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.btnCancelClick(Sender: TObject);
begin
  OkPressed := False;
  close;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.btnEditClick(Sender: TObject);
begin
  EditSignature;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.btnLoadFolderClick(Sender: TObject);
var
  test : string;
begin
  test := eLoad.Text;

  if BrowseFolder( test, 'Select the Default Folder for Loading Charts From' ) then
    eLoad.Text := test;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.btnSaveFolderClick(Sender: TObject);
var
  test : string;
begin
  test := eSave.Text;

  if BrowseFolder( test, 'Select the Default Folder for Saving Entries To' ) then
    eSave.Text := test;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.btnSuperLoadFolderClick(Sender: TObject);
var
  test : string;
begin
  test := eSuperLoad.Text;

  if BrowseFolder( test, 'Select the Default Folder for Loading Charts From' ) then
    eSuperLoad.Text := test;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.btnSuperSaveFolderClick(Sender: TObject);
var
  test : string;
begin
  test := eSuperSave.Text;

  if BrowseFolder( test, 'Select the Default Folder for Saving Entries To' ) then
    eSuperSave.Text := test;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.cbPrimaryContactClick(Sender: TObject);
var
  TempUser: TBloUserRead;
begin
  //Set primary contact
  TempUser := TBloUserRead(cbPrimaryContact.Items.Objects[cbPrimaryContact.ItemIndex]);
  ProductConfigService.SetPrimaryContact(TempUser);
end;

procedure TfrmPracticeDetails.chklistExportToClickCheck(Sender: TObject);
begin
  if chklistExportTo.ItemIndex > -1 then
  begin
    if chklistExportTo.Checked[chklistExportTo.ItemIndex] then
    begin
      ProductConfigService.AddVendorExport(TVendorExport(chklistExportTo.Items.Objects[chklistExportTo.ItemIndex]).Id);
    end
    else
    begin
      ProductConfigService.RemoveVendorExport(TVendorExport(chklistExportTo.Items.Objects[chklistExportTo.ItemIndex]).Id);
    end;

    if ProductConfigService.GuidsEqual(TVendorExport(chklistExportTo.Items.Objects[chklistExportTo.ItemIndex]).Id, ProductConfigService.GetIBizzExportGuid) then
    begin
      if chklistExportTo.Checked[chklistExportTo.ItemIndex] then
      begin
        lblAcclipseCode.Enabled := True;
        edtAcclipseCode.Enabled := True;
      end
      else
      begin
        lblAcclipseCode.Enabled := False;
        edtAcclipseCode.Enabled := False;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.ckUseBankLinkOnlineClick(Sender: TObject);
var
  i: integer;
  EventHolder : TNotifyEvent;
begin
  EventHolder := ckUseBankLinkOnline.OnClick;
  ckUseBankLinkOnline.OnClick := nil;
  try
    if ckUseBankLinkOnline.Checked then begin
      UseBankLinkOnline := True;
      FPrac := ProductConfigService.GetPractice(False);
      if (FPrac.id <> '') then begin
        if ProductConfigService.Registered  then begin
          //Need the client list for checking if clients are using products before
          //they are removed. Only load if practice details have been received
          //from BankLink Online (not from cache).
          ProductConfigService.LoadClientList;
        end;
      end else
      begin
        UseBankLinkOnline := False;
      end;
    end else
      UseBankLinkOnline := False;

    LoadPracticeDetails;
      
    if ckUseBankLinkOnline.Checked and ProductConfigService.OnLine then
    begin
      //Not registered
      if (not ProductConfigService.Registered) then
      begin
        ckUseBankLinkOnline.Checked := False;
        edtURL.Text := 'Not registered for BankLink Online';
        if ProductConfigService.ValidBConnectDetails then
        begin
          cbPrimaryContact.Enabled := False;
          if Visible then
          begin
            if YesNoDlg.AskYesNo(Globals.BANKLINK_ONLINE_NAME,
                                 'You are not currently registered for BankLink Online. ' +
                                 'Would you like to register now?', dlg_no, 0) = DLG_YES then
            begin
              if ServiceAgreementAccepted then
                RequestBankLinkOnlineRegistration;
            end;
          end;
        end;
        UseBankLinkOnline := False;        
      end;
    end;

    for i := 0 to tsBanklinkOnline.ControlCount - 1 do
      tsBanklinkOnline.Controls[i].Enabled := UseBankLinkOnline and
                                              ProductConfigService.OnLine and
                                              ProductConfigService.Registered and
                                              ProductConfigService.IsPracticeActive(False);

    ckUseBankLinkOnline.Enabled := ProductConfigService.OnLine;
  finally
    ckUseBankLinkOnline.OnClick := EventHolder;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.cmbSuperSystemChange(Sender: TObject);
var
  CurrentSuperSystem: Byte;
begin
  with cmbSuperSystem do
    if ItemIndex >=0 then
    begin
      CurrentSuperSystem := Byte( Items.Objects[ ItemIndex ] );
      SetUpSuper(CurrentSuperSystem);
    end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.cmbSystemChange(Sender: TObject);
var
  AccountingSystem: Byte;
begin
  if Insetup and
     Assigned(Sender) then
    Exit;

  with cmbSystem do
    if ItemIndex >=0 then
    begin
      AccountingSystem := Integer( Items.Objects[ ItemIndex ] );
      SetUpAccounting(AccountingSystem);
    end;
end;

//------------------------------------------------------------------------------
function TfrmPracticeDetails.Execute(SelPracticeMan: Boolean): boolean;
const
  ThisMethodName = 'TfrmPracticeDetails.Execute';
var
  i :integer;
  LastDiskSequenceNo : integer;
begin
  okPressed := false;
  InSetup := true;
  {load values}
  with AdminSystem do
  begin
    ePracName.Text  := fdFields.fdPractice_Name_for_Reports;
    eBCode.Text     := fdFields.fdBankLink_Code;

    ChangingDiskID := true;
    try
      txtLastDiskID.Text     := MakeSuffix(fdFields.fdDisk_Sequence_No);
    finally
      ChangingDiskID := false;
    end;
    //prompt can be turned off
    PassGenCodeEntered  := False;

    eLoad.Text             := fdFields.fdLoad_Client_Files_From;
    eSave.Text             := fdFields.fdSave_Client_Files_To;
    ePracEmail.Text        := fdFields.fdPractice_EMail_Address;
    edtPhone.Text          := fdFields.fdPractice_Phone;
    edtWebSite.Text        := fdFields.fdPractice_Web_Site;
    edtLogoBitmapFilename.Text := fdFields.fdPractice_Logo_Filename;
    ReloadLogo;

    eMask.Text             := fdFields.fdAccount_Code_Mask;
    edtSaveTaxTo.Text      := fdFields.fdSave_Tax_Files_To;

    {load accounting system dlg}
    cmbSystem.Items.Clear;
    cmbTaxInterface.Items.Clear;

    //superfund system
    cmbSuperSystem.Clear;
    tsSuperFundSystem.TabVisible := (fdFields.fdCountry = whAustralia);

    //Use BankLink Online
    UseBankLinkOnline := Adminsystem.fdFields.fdUse_BankLink_Online;
    ckUseBankLinkOnline.Checked := Adminsystem.fdFields.fdUse_BankLink_Online;
    for i := 0 to tsBanklinkOnline.ControlCount - 1 do
      tsBanklinkOnline.Controls[i].Enabled := UseBankLinkOnline and
                                              ProductConfigService.OnLine and
                                              ProductConfigService.Registered and
                                              ProductConfigService.IsPracticeActive(False);
    ckUseBankLinkOnline.Enabled := ProductConfigService.OnLine or (not UseBankLinkOnline);


    //Web export format
    if fdFields.fdWeb_Export_Format = 255 then
       fdFields.fdWeb_Export_Format := wfDefault;
    SetUpWebExport(fdFields.fdWeb_Export_Format);

    lblCountry.caption := whShortNames[ fdFields.fdCountry ];
    case fdFields.fdCountry of
      whNewZealand :
        begin
            for i := snMin to snMax do begin
              if (not Software.ExcludeFromAccSysList( fdFields.fdCountry, i)) or ( i = fdFields.fdAccounting_System_Used) then
                  cmbSystem.items.AddObject(snNames[i], TObject( i ) );
            end;

            SetComboIndexByIntObject(fdFields.fdAccounting_System_Used,cmbSystem);


            gbxTaxInterface.Visible   := false;
            gbxWebExport.Top := gbxTaxInterface.Top;
            cmbTaxInterface.Items.AddObject( tsNames[ tsMin], TObject( tsMin));
            cmbTaxInterface.ItemIndex := 0;
            edtSaveTaxTo.Text         := '';
        end;

      whAustralia :
        begin
            cmbSuperSystem.items.AddObject( asNoneName, TObject( asNone ) );
            cmbSystem.items.AddObject( asNoneName, TObject( asNone ) );

            for i := saMin to saMax do begin
              if ( not Software.ExcludeFromAccSysList( fdFields.fdCountry, i)) or ( i = fdFields.fdAccounting_System_Used) then
              begin
                if Software.IsSuperFund(fdFields.fdCountry, i) then
                  cmbSuperSystem.items.AddObject(saNames[i], TObject( i ) )
                else
                  cmbSystem.items.AddObject(saNames[i], TObject( i ) );
              end;
            end;

            //select accounting system
            SetComboIndexByIntObject(fdFields.fdAccounting_System_Used,cmbSystem);

            SetupAccounting(fdFields.fdAccounting_System_Used);

            //select superfund system
            SetComboIndexByIntObject(fdFields.fdSuperfund_System ,cmbSuperSystem);
            SetupSuper(fdFields.fdSuperfund_System);


            gbxTaxInterface.Visible  := True;
            for i := tsMin to tsMax do
            begin
              cmbTaxInterface.Items.AddObject( tsNames[ tsSortOrder[i]], TObject( tsSortOrder[i]));
            end;
            cmbTaxInterface.ItemIndex := 0;
            ComboUtils.SetComboIndexByIntObject( fdFields.fdTax_Interface_Used, cmbTaxInterface);

            edtSaveTaxTo.Text := fdFields.fdSave_Tax_Files_To;
        end;
      whUK :
        begin
            for i := suMin to suMax do begin
              if ( not Software.ExcludeFromAccSysList( fdFields.fdCountry, i)) or ( i = fdFields.fdAccounting_System_Used) then
               cmbSystem.items.AddObject(suNames[i], TObject( i ) );
            end;

            SetComboIndexByIntObject(fdFields.fdAccounting_System_Used,cmbSystem);

            gbxTaxInterface.Visible   := false;
            gbxWebExport.Top := gbxTaxInterface.Top;
            cmbTaxInterface.Items.AddObject( tsNames[ tsMin], TObject( tsMin));
            cmbTaxInterface.ItemIndex := 0;
            edtSaveTaxTo.Text         := '';
        end;

      else
      begin
         cmbSystem.Items.Add('None');
         cmbsystem.ItemIndex := 0;

         cmbTaxInterface.Items.Add('None');
         cmbTaxInterface.ItemIndex := 0;

         edtSaveTaxTo.Text := '';
      end;
    end; {case}

    //Practice Management System
    for i := xcMin to xcMax do begin
      if not ((fdFields.fdCountry = whNewZealand) and (i = xcHandi)) then
        if not ((fdFields.fdCountry = whUK) and not (i in [xcNA, xcOther])) then // Fix for bug 25375
          cmbPracticeManagementSystem.items.AddObject(xcNames[i], TObject( i ) );
    end;
    //Temp - use practice mgmt setting from System.db
    ComboUtils.SetComboIndexByIntObject( fdFields.fdPractice_Management_System, cmbPracticeManagementSystem);

    cmbSystemChange(nil);

    if SelPracticeMan then begin
       PageControl1.ActivePage := tbsPracticeManagementSystem;
       // Anything else..
    end else
       PageControl1.ActivePage := tbsDetails;

  end; {with}

  InSetup := False;

  self.
  ShowModal;

  if okPressed then
  begin
    if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, 'Update Practice Details Starts');

    if LoadAdminSystem(true, ThisMethodName ) then with AdminSystem.fdFields do
    begin
       //log change of last download no!!!
       LastDiskSequenceNo := SuffixToSequenceNo( txtLastDiskID.Text);

       if fdDisk_Sequence_No <> LastDiskSequenceNo then begin
          LogUtil.LogMsg(lmInfo, UnitName, 'Last Download No changed from ' +
                                           MakeSuffix( fdDisk_Sequence_No) +
                                           ' to ' +
                                           txtLastDiskID.Text);
       end;
       fdPractice_Name_for_Reports := ePracName.Text;
       fdBankLink_Code             := eBCode.Text;
       fdDisk_Sequence_No          := LastDiskSequenceNo;
       fdPractice_EMail_Address    := Trim( ePracEmail.Text);
       fdAccount_Code_Mask         := eMask.Text;
       fdPractice_Phone            := edtPhone.Text;
       fdPractice_Web_Site         := edtWebSite.Text;
       fdPractice_Logo_Filename    := edtLogoBitmapFilename.Text;

       fdAccounting_System_Used := GetComboCurrentIntObject(cmbSystem,snOther);

       fdSave_Client_Files_To      := eSave.Text;
       if CanRefreshChart( fdCountry, fdAccounting_System_Used ) then begin
          fdLoad_Client_Files_From := eLoad.text;
       end else begin
          fdLoad_Client_Files_From := '';
       end;

       //Superfund system
       fdSuperfund_System := GetComboCurrentIntObject(cmbSuperSystem,asNone);

       //only save values if superfund selected
       if not (fdSuperfund_System = asNone) then begin
          fdSuperfund_Code_Mask         := eSuperMask.Text;
          fdSave_Client_Super_Files_To  := eSuperSave.Text;
          if CanRefreshChart( fdCountry, fdSuperfund_System ) then
             fdLoad_Client_Super_Files_From := eSuperLoad.text
          else
             fdLoad_Client_Super_Files_From := '';
       end;

       //Tax
       fdTax_Interface_Used        := ComboUtils.GetComboCurrentIntObject( cmbTaxInterface);
       if fdTax_Interface_Used = tsNone then
         fdSave_Tax_Files_To       := ''
       else
         fdSave_Tax_Files_To       := AddSlash( Trim( edtSaveTaxTo.Text));

       //Save BankLink Online settings
       //Saved to BankLink Online in VerifyForm - form can't be closed unless online changes are saved
       AdminSystem.fdFields.fdUse_BankLink_Online := UseBankLinkOnline;
       //Saved a copy of BankLink Online settings locally for display when offline
       if UseBankLinkOnline and ProductConfigService.OnLine then
         ProductConfigService.SavePracticeDetailsToSystemDB(FPrac);

       //Web
       fdWeb_Export_Format         := ComboUtils.GetComboCurrentIntObject(cmbWebFormats);
       if (wfNames[fdWeb_Export_Format] = WebNotesName) and
          (not ProductConfigService.IsNotesOnlineEnabled) then
         fdWeb_Export_Format := wfDefault;

       //Practice Management System
       fdPractice_Management_System := ComboUtils.GetComboCurrentIntObject(cmbPracticeManagementSystem);

       //*** Flag Audit ***
       SystemAuditMgr.FlagAudit(arPracticeSetup);

       SaveAdminSystem;
       UpdateMenus;

       if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, 'Update Practice Details Completed');
    end
    else
       HelpfulErrorMsg('Could not update Practice Details at this time. Admin System unavailable.',0);
  end;
  result := okPressed;
end;

//------------------------------------------------------------------------------
function EditPracticeDetails(w_PopupParent: TForm; SelPracticeMan: Boolean = False) : boolean;
var
  PracticeDetails : TfrmPracticeDetails;
begin
  Result := false;
  if not RefreshAdmin then
    exit;

  PracticeDetails := TfrmPracticeDetails.Create(Application.MainForm);
  with PracticeDetails do
  begin
    try
      PopupParent := w_PopupParent;
      PopupMode := pmExplicit;
      
      BKHelpSetUp(PracticeDetails, BKH_Practice_details);
      Result := Execute(SelPracticeMan);
    finally
      Free;
    end;
  end;
end;

function SortList(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := CompareText(List.ValueFromIndex[Index1], List.ValueFromIndex[Index2]);  
end;

//------------------------------------------------------------------------------
function TfrmPracticeDetails.VerifyForm: boolean;
const
  ThisMethodName = 'VerifyForm';
var
  aMsg : string;
  Path : string;
  CurrType : integer;
  MailTo, MailSubject, MailBody: string;
  NewProducts: TStringList;
  RemovedProducts: TStringList;
  AllProducts: TStringList;
  Index: Integer;
  Catalogue: TBloCatalogueEntry;
  PrimaryContact: TBloUserRead;
  ContactName: String;
  ContactEmail: String;
begin
  result := false;

  //practice code specified
  if Trim( EBCode.Text) = '' then
  begin
    tbsDetails.Show;
    ebCode.SetFocus;
    aMsg := 'You must specify a ' + ShortAppName + ' code for the Practice.';
    HelpfulWarningMsg( aMSg, 0);
    Exit;
  end;

  //last disk id
  if not IsValidSuffix(txtLastDiskID.Text) then
  begin
    tbsDetails.Show;
    txtLastDiskID.SetFocus;
    aMsg := 'The Last Disk Processed ID is invalid.';
    HelpfulWarningMsg( aMSg, 0);
    Exit;
  end;

  //tax interface directory
  CurrType := ComboUtils.GetComboCurrentIntObject( cmbTaxInterface);
  if ( CurrType <> -1) and ( not( CurrType = tsNone)) then
  begin
    Path := AddSlash( Trim( edtSaveTaxTo.Text));
    SetCurrentDir( DATADIR);

    if ( Path <> '') and (not DirectoryExists( Path)) then
    begin
      tbsInterfaces.Show;
      if YesNoDlg.AskYesNo( 'Export Tax File To',
         'The "Export Tax File To" directory you have specified does not exist. Do you want to create it?',
         DLG_YES, 0) = DLG_YES then
      begin
        if not CreateDir(Path) then
        begin
          aMsg := 'Unable To Create Directory ' + Path;
          LogUtil.LogMsg( lmError, UnitName, ThisMethodName + ' - ' + aMsg );
          HelpfulWarningMsg(aMsg, 0);
          edtSaveTaxTo.SetFocus;
          Exit;
        end;
      end else
      begin
        edtSaveTaxTo.SetFocus;
        Exit;
      end;
    end;
  end;

  //Save BankLink Online settings
  UseBankLinkOnline := ckUseBankLinkOnline.Checked;

  if UseBankLinkOnline and ProductConfigService.PracticeChanged then
  begin
    aMsg := 'Changing the BankLink Online products and services that are available ' +
            'for this practice will affect how client files can be individually setup ' +
            'for these products and services. Such products and services may incur ' +
            'charges per client use.' + #13#10 + #13#10 +
            'Please contact BankLink Client Services if you require further charges ' +
            'information.' + #13#10 + #13#10 +
            'Are you sure you want to continue?';

    if not (YesNoDlg.AskYesNo('BankLink Online products and services change', aMsg, DLG_YES, 0) = DLG_YES) then
      Exit;

    if ProductConfigService.HasProductJustBeenTicked(ProductConfigService.GetExportDataId) then
    begin
      if (chklistExportTo.Count > 0) and (chklistExportTo.CountCheckedItems = 0) and ProductConfigService.VendorExportsChanged then
      begin
        if YesNoDlg.AskYesNo('Banklink Online Data Export', 'You have not selected a vendor export type.' + #10#13#10#13 + 'Are you sure you want to continue saving?', DLG_YES, 0) = DLG_NO then
        begin
          Exit;
        end;
      end;
    end;

    NewProducts := TStringList.Create;

    try
      NewProducts.Sorted := True;
      
      RemovedProducts := TStringList.Create;

      try
        RemovedProducts.Sorted := True;
        
        for Index := Low(FPrac.Catalogue) to High(FPrac.Catalogue) do
        begin
          Catalogue := TBloCatalogueEntry(FPrac.Catalogue[Index]);

          if ProductConfigService.HasProductJustBeenTicked(Catalogue.Id) then
          begin
            NewProducts.Add(Catalogue.Description);
          end
          else
          if ProductConfigService.HasProductJustBeenUnTicked(Catalogue.Id) then
          begin
            RemovedProducts.Add(Catalogue.Description);
          end;
        end;

        if not ProductConfigService.SavePractice then
        begin
          //Don't exit dialog if online settings were not updated
          if UseBankLinkOnline then
            Exit;
        end;
    
         // Send email to support
        if (NewProducts.Count > 0) or (RemovedProducts.Count > 0) then
        begin
          MailTo := whSupportEmail[AdminSystem.fdFields.fdCountry];

          MailSubject := 'Banklink Online product and service updates (' + AdminSystem.fdFields.fdBankLink_Code + ')';

          PrimaryContact := ProductConfigService.GetPrimaryContact(False);

          if Assigned(PrimaryContact) then
          begin
            ContactName := PrimaryContact.Fullname;
            ContactEmail := PrimaryContact.Email;
          end;

          MailBody := 'This practice has changed its Banklink Online product and service settings' + #10#10 +
                      'Practice Name: ' + AdminSystem.fdFields.fdPractice_Name_for_Reports + #10 +
                      'Practice Code: ' + AdminSystem.fdFields.fdBankLink_Code + #10#10 +
                      'The BankLink Online Administrator (Primary Contact) for the practice' + #10 +
                      'Name: ' + ContactName + #10 +
                      // Can't find phone number... do we have this at all for the practice administrator?
                      'Email Address: ' + ContactEmail + #10#10 +
                      'Updated settings:' + #10;

          for Index := 0 to NewProducts.Count - 1 do
          begin
            MailBody := MailBody + NewProducts[Index] + ' is now enabled' + #10;
          end;

          for Index := 0 to RemovedProducts.Count - 1 do
          begin
            MailBody := MailBody + RemovedProducts[Index] + ' is now disabled' + #10;
          end;

          MailBody := MailBody + #10 + 'Product and service settings:' + #10;

          AllProducts := TStringList.Create;

          try
            for Index := Low(FPrac.Catalogue) to High(FPrac.Catalogue) do
            begin
              Catalogue := TBloCatalogueEntry(FPrac.Catalogue[Index]);

              AllProducts.Add(Catalogue.Id + '=' + Catalogue.Description);
            end;

            AllProducts.CustomSort(SortList);

            for Index := 0 to AllProducts.Count -1 do
            begin
              MailBody := MailBody + AllProducts.ValueFromIndex[Index] + ' - ';

              if ProductConfigService.IsPracticeProductEnabled(AllProducts.Names[Index], False) then
              begin
                MailBody := MailBody + 'enabled' + #10
              end
              else
              begin
                MailBody := MailBody + 'disabled' + #10;
              end;
            end;
          finally
            AllProducts.Free;
          end;

          SendMailTo('Email to Support', MailTo, MailSubject, MailBody);
        end;
      finally
        RemovedProducts.Free;
      end;
    finally
      NewProducts.Free;
    end;
  end;

  Result := True;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.vtProductsBeforeItemPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var CustomDraw: Boolean);
var
  NodeData: pTreeData;
  NodeCaption: string;
  i: integer;
begin
  NodeData := Sender.GetNodeData(Node);
  if (NodeData.tdObject = nil) then begin
    CustomDraw := True;
    //Paint background
    TargetCanvas.Brush.Color := clWindow;
    TargetCanvas.FillRect(ItemRect);
    //Paint text
    TargetCanvas.Font := appimages.Font;
    TargetCanvas.Font.Color := clBlue;
    NodeCaption := Globals.BANKLINK_ONLINE_NAME + ' ' + NodeData.tdCaption;
    InflateRect(ItemRect, -6, -2);
    DrawText(TargetCanvas.Handle, PChar(NodeCaption), StrLen(PChar(NodeCaption)),
             ItemRect, DT_LEFT or DT_VCENTER or DT_SINGLELINE);
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.vtProductsChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeData;
  Cat: TBloCatalogueEntry;
begin
  vtProducts.BeginUpdate;
  try
    Data := vtProducts.GetNodeData(Node);
    if Assigned(Data.tdObject) then begin
      Cat := TBloCatalogueEntry(Data.tdObject);
      if Node.CheckState = csCheckedNormal then
      begin
        //Add product
        ProductConfigService.AddProduct(Cat.Id);

        if ProductConfigService.GuidsEqual(Cat.Id, ProductConfigService.GetExportDataId) and not tbsDataExport.TabVisible then
        begin
          tbsDataExport.TabVisible := True;
        end;
      end
      else
      begin
        //Remove product
        if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, 'Start remove product: ' + Cat.Id);
        ProductConfigService.RemoveProduct(Cat.Id);
        if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, 'End remove product: ' + Cat.Id);

        if ProductConfigService.GuidsEqual(Cat.Id, ProductConfigService.GetExportDataId) and tbsDataExport.TabVisible then
        begin
          tbsDataExport.TabVisible := False;
        end;
      end;
    end;
  finally
    vtProducts.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.vtProductsFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PTreeData;
begin
  Data := vtProducts.GetNodeData(Node);
  if Assigned(Data) then begin
    Data.tdCaption := '';
    Data.tdObject := nil;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.vtProductsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PTreeData;
  Cat: TBloCatalogueEntry;
begin
  Data := vtProducts.GetNodeData(Node);
  if (Data.tdObject <> nil) then
  begin
    case Column of
      0: begin
           if not (Assigned(Data.tdObject)) and DebugMe then
             LogUtil.LogMsg(lmDebug, UnitName, 'No Node Data!!');
           Cat := TBloCatalogueEntry(Data.tdObject);
           if Assigned(Cat) then begin
             if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, 'Start set product check state:' + Cat.Id);
             Node.CheckState := csUncheckedNormal;
             if ProductConfigService.IsPracticeProductEnabled(Cat.Id, True) then
               Node.CheckState := csCheckedNormal;
             if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, 'End set product check state:' + Cat.Id);
           end;
         end;
      1: CellText := Data.tdCaption;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if OKPressed then
  begin
    Screen.Cursor := crHourGlass;
    try
      CanClose := VerifyForm;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.btnTaxFolderClick(Sender: TObject);
var
  test : string;
begin
  test := edtSaveTaxTo.Text;

  if BrowseFolder( test, 'Select the Default Folder for exporting Tax File to' ) then
    edtSaveTaxTo.Text := test;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.cmbTaxInterfaceChange(Sender: TObject);
//set the default directory if the directory is currently blank
var
  CurrType : integer;
begin
  CurrType := ComboUtils.GetComboCurrentIntObject( cmbTaxInterface);

  case CurrType of
    tsBAS_XML, tsBAS_MYOB, tsBAS_HANDI,
    tsElite_XML,
    tsBAS_APS_XML : edtSaveTaxTo.Text := 'XML\';
    tsBAS_Sol6ELS : edtSaveTaxTo.Text := 'ELS\';
  else
    edtSaveTaxTo.Text := '';
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.LoadPracticeDetails;
var
  i: integer;
  Cat: TBloCatalogueEntry;
  TreeColumn: TVirtualTreeColumn;
  ProductNode, ServiceNode: PVirtualNode;
  RoleIndex : integer;
  AdminRollName : WideString;
begin
  //Clear
  edtURL.Text := '';
  cbPrimaryContact.Clear;
  vtProducts.Header.Columns.Clear;
  vtProducts.Clear;
  try
    //Setup Columns
    TreeColumn := vtProducts.Header.Columns.Add;
    TreeColumn.Text := 'TestCol1';
    TreeColumn.Width := 20;
    TreeColumn := vtProducts.Header.Columns.Add;
    TreeColumn.Text := 'TestCol2';
    TreeColumn.Width := 450;

    if ((FPrac.Id <> '') and ProductConfigService.Registered) or
       ((FPrac.Id <> '') and (not ProductConfigService.OnLine)) then begin
      //URL
      edtURL.Text := 'https://' + FPrac.DomainName + '.' +
                     Copy(Globals.BANKLINK_ONLINE_BOOKS_DEFAULT_URL, 13 ,
                          Length(Globals.BANKLINK_ONLINE_BOOKS_DEFAULT_URL));
      //Primary Contacts
      cbPrimaryContact.Enabled := True;
      AdminRollName := FPrac.GetRoleFromPracUserType(ustSystem, FPrac).RoleName;

      for i := Low(FPrac.Users) to High(FPrac.Users) do
      begin
        for RoleIndex := Low(FPrac.Users[i].RoleNames) to High(FPrac.Users[i].RoleNames) do
        begin
          // Add only Admin User Types
          if FPrac.Users[i].RoleNames[RoleIndex] = AdminRollName then
          begin
            cbPrimaryContact.Items.AddObject(FPrac.Users[i].FullName, TObject(FPrac.Users[i]));
            break;
          end;
        end;
      end;

      //Select default admin
      cbPrimaryContact.ItemIndex := -1;
      for i := 0 to cbPrimaryContact.Items.Count - 1 do
        if TBloUserRead(cbPrimaryContact.Items.Objects[i]).Id = FPrac.DefaultAdminUserId then
          cbPrimaryContact.ItemIndex := i;

      //Products and Service
      vtProducts.TreeOptions.PaintOptions := (vtProducts.TreeOptions.PaintOptions - [toShowTreeLines, toShowButtons]);
      vtProducts.NodeDataSize := SizeOf(TTreeData);
      vtProducts.Indent := 0;

      if Length(FPrac.Catalogue) > 0 then begin
        ProductNode := AddTreeNode(vtProducts, nil, 'Products', nil);
        ServiceNode := AddTreeNode(vtProducts, nil, 'Services', nil);
        for i := Low(FPrac.Catalogue) to High(FPrac.Catalogue) do begin
          Cat := TBloCatalogueEntry(FPrac.Catalogue[i]);
          if Cat.CatalogueType = 'Application' then
            AddTreeNode(vtProducts, ProductNode, Cat.Description, Cat)
          else if Cat.CatalogueType = 'Service' then
            AddTreeNode(vtProducts, ServiceNode, Cat.Description, Cat)  ;
        end;
      end;

      vtProducts.Expanded[ProductNode] := True;
      vtProducts.Expanded[ServiceNode] := True;
      vtProducts.ScrollIntoView(ProductNode, False);

      vtProducts.OnCompareNodes := TreeCompare;
      vtProducts.SortTree(0, sdAscending);

      tbsDataExport.TabVisible := ProductConfigService.IsPracticeProductEnabled(ProductConfigService.GetExportDataId, False);

      //Test data since we don't yet have the service calls to retrieve the available vendor export types.  Remove this when they are available.
      chklistExportTo.AddItem('BGL Simple Fund', TVendorExport.Create('53E1E0EB-DBAD-4D20-ABA9-2F32AC9A1A0D'));
      chklistExportTo.AddItem('iBizz Export', TVendorExport.Create('C048EEB5-978D-4768-87C2-CAD43B8D888D'));
      chklistExportTo.AddItem('{BanklinkOnlineExportFormat1}', TVendorExport.Create('8CE9B867-F1A7-40E0-9B23-3D28C5B4DA98'));
      chklistExportTo.AddItem('{BanklinkOnlineExportFormat2}', TVendorExport.Create('71CA8468-0C24-473D-87D1-2D0D65F29C51'));
      chklistExportTo.AddItem('{BanklinkOnlineExportFormat3}', TVendorExport.Create('0BB13981-D35E-4A89-BE4E-CAFEAB9C802A'));
    end;
  except
    on E: Exception do begin
      HelpfulErrorMsg(E.Message ,0);
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.PageControl1Change(Sender: TObject);
begin
  if (PageControl1.ActivePage = tsBankLinkOnline) and
     (ProductConfigService.IsPracticeDeactivated) then
    PageControl1.ActivePageIndex := FPreviousPage;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  FPreviousPage := PageControl1.ActivePageIndex;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.actClearAllProductsExecute(Sender: TObject);
begin
  ProductConfigService.ClearAllProducts;
  vtProducts.Invalidate;
  Refresh;
  if vtProducts.CanFocus then
    vtProducts.SetFocus;
  if btnClearAll.CanFocus then
    btnClearAll.SetFocus;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.actSelectAllProductsExecute(Sender: TObject);
begin
  ProductConfigService.SelectAllProducts;
  vtProducts.Invalidate;
  Refresh;
  if vtProducts.CanFocus then
    vtProducts.SetFocus;
  if btnSelectAll.CanFocus then
    btnSelectAll.SetFocus;
end;

//------------------------------------------------------------------------------
function TfrmPracticeDetails.AddTreeNode(AVST: TCustomVirtualStringTree;
  ANode: PVirtualNode; ACaption: widestring; AObject: TObject): PVirtualNode;
var
  Data: PTreeData;
begin
  Result := AVST.AddChild(ANode);
  AVST.ValidateNode(Result, False);
  Data := AVST.GetNodeData(Result);
  Data^.tdCaption := ACaption;
  Data^.tdObject := AObject;
  if (AObject <> nil) then
    Result.CheckType := ctCheckBox;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.btnBrowseLogoBitmapClick(Sender: TObject);
const
  RecommendedMaxSize = 100000;   //100K
var
  TempFilename : string;
  Ext          : string;
  fsize        : int64;
begin
  try
    with OpenPictureDlg do
    begin
      FileName := ExtractFileName(edtLogoBitmapFilename.text);
      InitialDir := ExtractFilePath(edtLogoBitmapFilename.text);

      if Execute then
      begin
        TempFilename := Filename;
        Ext          := LowerCase( ExtractFileExt( TempFilename));

        //check the file type
        if ( Ext = '.jpg')
        or ( Ext = '.jpeg')
        or ( Ext = '.bmp') then
        begin
          //warn the user if the file size is too big  > 200K
          fSize := WinUtils.GetFileSize( TempFilename);
          if fSize > RecommendedMaxSize then
          begin
            if YesNoDlg.AskYesNo( 'Confirm Logo',
                                  'The file that you have selected is quite large ' +
                                  ' (' + IntToStr( fSize div 1024) + 'Kb) and will greatly increase the size '+
                                  'of your ' + glConst.ECODING_APP_NAME + ' and ' +
                                   BKBOOKSNAME + ' files.'#13#13 +
                                   'Please confirm that you wish to use this file.',
                                   DLG_YES, 0) <> DLG_YES then
            begin
              Exit;
            end;
          end;
          edtLogoBitmapFilename.text := TempFilename;
        end
        else
        begin
          //if not a known format then ignore it
          HelpfulWarningMsg( 'The file you selected in not a recognised format.', 0);
        end;
      end;
    end;
  finally
    //make sure all relative paths are relative to data dir after browse
    SysUtils.SetCurrentDir( Globals.DataDir);
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.ReloadLogo;
var
  filename : string;
begin
  Filename := edtLogoBitmapFilename.Text;
  if BKFileExists( filename) then
  begin
    try
      imgPracticeLogo.Picture.LoadFromFile( filename);
      imgPracticeLogo.Visible := true;
      SetUsage('Practice Logo', 1);
    except
      on E: EInvalidGraphic do
      begin
        HelpfulErrorMsg( E.Message, 0);
        edtLogoBitmapFilename.Text := '';
        imgPracticeLogo.Visible := false;
      end;
    end;
  end
  else
  begin
    imgPracticeLogo.Visible := false;
    SetUsage('Practice Logo', 0);
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.edtLogoBitmapFilenameChange(Sender: TObject);
begin
  ReloadLogo;
  edtLogoBitmapFilename.Hint := edtLogoBitmapFilename.Text;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.tbsDetailsShow(Sender: TObject);
begin
  btnBrowseLogoBitmap.Top := edtLogoBitmapFilename.Top;
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.tbsInterfacesShow(Sender: TObject);
begin
  if (cmbWebFormats.ItemIndex >= 0) then
    SetUpWebExport(Byte(cmbWebFormats.Items.Objects[cmbWebFormats.ItemIndex]))
  else
    SetUpWebExport(wfDefault);
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.TreeCompare(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: pTreeData;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  // folder are always before files
  if (Data1.tdObject = nil) and (Data2.tdObject <> nil) then begin
    // one is a folder the other a file
    if (Data1.tdObject = nil) then
      Result := -1
    else
      Result := 1;
  end else // both are of same type (folder or file)
    Result := CompareText(Data1.tdCaption, Data2.tdCaption);
end;

//------------------------------------------------------------------------------
procedure TfrmPracticeDetails.txtLastDiskIDChange(Sender: TObject);
begin
  if PassGenCodeEntered or PRACINI_DontAskForPGDiskNo then
    exit;

  if ChangingDiskID then
  begin
    exit;
  end;

  //trying to change code, ask for password
  PassGenCodeEntered := EnterPassword('Change Last Disk Processed', 'LASTDOWNLOAD', 0, true, false);
  if not PassGenCodeEntered then
  begin
     //reset disk id
     ChangingDiskID := true;
     try
       txtLastDiskID.Text := MakeSuffix( AdminSystem.fdFields.fdDisk_Sequence_No)
     finally
       ChangingDiskID := false;
     end;
  end
  else begin
     //log the fact that the user can change the download no
     LogUtil.LogMsg(lmInfo, UnitName, 'Password Used to Access Last Download No');
  end;
end;

{ TCheckBoxListHelper }

function TCheckListBoxHelper.CountCheckedItems: Integer;
var
  Index: Integer;
begin
  Result := 0;
  
  for Index := 0 to Count - 1 do
  begin
    if Checked[Index] then
    begin
      Inc(Result);
    end;
  end;
end;

{ TVendorExport }

constructor TVendorExport.Create(VendorExportID: TBloGuid);
begin
  FId := VendorExportID;
end;

initialization
   DebugMe := DebugUnit(UnitName);
end.




