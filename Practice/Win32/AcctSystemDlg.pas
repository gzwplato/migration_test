unit AcctSystemDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Software, ExtCtrls,
  OsFont;

type
  TdlgAcctSystem = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    gbxAccounting: TGroupBox;
    lblFrom: TLabel;                     
    eFrom: TEdit;                                                                               
    eTo: TEdit;
    lblSaveTo: TLabel;                                                        
    btnFromFolder: TSpeedButton;
    btnToFolder: TSpeedButton;
    btnCheckBankManID: TButton;
    Label1: TLabel;
    Label2: TLabel;
    cmbSystem: TComboBox;
    eMask: TEdit;
    chkLockChart: TCheckBox;
    btnSetBankpath: TButton;
    pnlMASLedgerCode: TPanel;
    btnMasLedgerCode: TSpeedButton;
    edtExtractID: TEdit;
    chkUseCustomLedgerCode: TCheckBox;
    gbxTaxInterface: TGroupBox;
    Label5: TLabel;
    Label8: TLabel;
    lblTaxLedger: TLabel;
    eTaxLedger: TEdit;
    edtSaveTaxTo: TEdit;
    cmbTaxInterface: TComboBox;
    btnTaxFolder: TSpeedButton;
    gbxWebExport: TGroupBox;
    Label4: TLabel;
    cmbWebFormats: TComboBox;
    gbType: TGroupBox;
    lblLoadDefaults: TLabel;
    rbAccounting: TRadioButton;
    rbSuper: TRadioButton;
    btndefault: TButton;
    GBExtract: TGroupBox;
    cbExtract: TComboBox;
    ckExtract: TCheckBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SetUpHelp;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnFromFolderClick(Sender: TObject);
    procedure btnToFolderClick(Sender: TObject);
    procedure cmbSystemChange(Sender: TObject);
    procedure cmbTaxInterfaceChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnTaxFolderClick(Sender: TObject);
    procedure btnCheckBankManIDClick(Sender: TObject);
    procedure eFromChange(Sender: TObject);
    procedure chkUseCustomLedgerCodeClick(Sender: TObject);
    procedure btnMasLedgerCodeClick(Sender: TObject);
    procedure btnSetBankpathClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbAccountingClick(Sender: TObject);
    procedure btndefaultClick(Sender: TObject);
    procedure ckExtractClick(Sender: TObject);
  private
    { Private declarations }
    okPressed : boolean;
    AutoRefreshFlag : Boolean;
    fAlternateID : string;
    InSetup: Boolean;
    function VerifyForm : boolean;
    procedure FillSystemList;
  protected
    procedure UpdateActions; override;
  public
    { Public declarations }
    function Execute(var AutoRefreshDone : Boolean) : boolean;
  end;

function EditAccountingSystem(var AutoRefreshDone : Boolean; ContextID : Integer) : boolean;
//******************************************************************************
implementation

{$R *.DFM}

uses
   BulkExtractFrm,
   Admin32,
   ComObj,
   ComboUtils,
   BKHelp,
   globals,
   glConst,
   bkconst,
   imagesfrm,
   LogUtil,
   updatemf,
   InfoMoreFrm,
   WarningMoreFrm,
   ErrorMoreFrm,
   YesNoDlg,
   SyDefs,
   Import32,
   bkXPThemes,
   ShellUtils,
   XPAUtils,
   Sol6_Const,
   Select_Mas_GlFrm,
   Registry,
   myobao_utils, BKDEFS, clObj32,
   WinUtils, DesktopSuper_Utils;

const
  UnitName = 'PRACDETAILSFRM';
  NO_DEFAULT_SYSTEM = 'No defaults were loaded because a default %s system has not been set up.';

//------------------------------------------------------------------------------
procedure TdlgAcctSystem.FormCreate(Sender: TObject);
begin
   bkXPThemes.ThemeForm( Self);

   btnFromFolder.Glyph := ImagesFrm.AppImages.imgFindStates.Picture.Bitmap;
   ImagesFrm.AppImages.Misc.GetBitmap(MISC_FINDFOLDER_BMP,btnToFolder.Glyph);
   ImagesFrm.AppImages.Misc.GetBitmap(MISC_FINDFOLDER_BMP,btnMasLedgerCode.Glyph);
   ImagesFrm.AppImages.Misc.GetBitmap(MISC_FINDFOLDER_BMP,btnTaxFolder.Glyph);

   //btnCheckBankManID.Top := eTo.Top;
   //btnCheckBankManID.Left := eTo.Left;

   eMask.MaxLength := BKCONST.MaxBK5CodeLen;

   SetUpHelp;
end;
procedure TdlgAcctSystem.FormShow(Sender: TObject);
begin
  if cmbSystem.CanFocus then
    cmbSystem.SetFocus;
end;

procedure TdlgAcctSystem.rbAccountingClick(Sender: TObject);
begin
   if not assigned(AdminSystem) then
      Exit; // why would it not be...
   if Insetup then
      Exit;

   FillSystemlist;
   if rbaccounting.Checked then
      ComboUtils.SetComboIndexByIntObject(AdminSystem.fdFields.fdAccounting_System_Used, cmbSystem)
   else
      ComboUtils.SetComboIndexByIntObject(AdminSystem.fdFields.fdSuperfund_System, cmbSystem);

   cmbSystemChange(nil);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.SetUpHelp;
begin
   Self.ShowHint    := INI_ShowFormHints;
   Self.HelpContext := 0;
   //Components
   cmbSystem.Hint   :=
                    'Select the main accounting system used for this client|'+
                    'Select the main accounting system used for this client';
   eMask.Hint       :=
                    'Enter the Account Code Mask used for client|'+
                    'Enter the Account Code Mask used for client';
   chkLockChart.Hint   :=
                    'Lock the Chart of Accounts|'+
                    'If the Chart is locked then it cannot be refreshed from your accounting system';
   eFrom.Hint       :=
                    'Enter a directory path or filename to refresh the client''s Chart of Accounts from|'+
                    'Enter a directory path or filename to refresh the client''s Chart of Accounts from';
   eTo.Hint         :=
                    'Enter a directory path to Extract Data to|'+
                    'Enter a directory path  to Extract Data to';
   eTaxLedger.Hint  :=
                    'Enter the Tax Ledger Code used by your Account System for this Client';
end;


procedure TdlgAcctSystem.UpdateActions;
begin
  inherited;
  cbExtract.Enabled := ckExtract.Checked;
end;

//------------------------------------------------------------------------------
procedure TdlgAcctSystem.btnOkClick(Sender: TObject);
begin
  okPressed := true;
  close;
end;
//------------------------------------------------------------------------------
procedure TdlgAcctSystem.btnCancelClick(Sender: TObject);
begin
  OkPressed := false;
  close;
end;
procedure TdlgAcctSystem.btnFromFolderClick(Sender: TObject);
var
  Path : string;
  AcctSystem : integer;
  result : integer;
begin
  //is the accounting system APS
  with cmbSystem do
  begin
    AcctSystem := Integer( Items.Objects[ ItemIndex ] );
  end;

  //if interface specifc action then
  //  browse using interface
  //else
  //  using standard file interface
  if Software.IsPA7Interface( MyClient.clFields.clCountry, AcctSystem) then
  begin
    Path := eFrom.Text;
    result := GetXPALedgerPath( Path);
    case result of
      bkXPA_COM_Refresh_Supported_User_Cancelled :
        Exit;
      bkXPA_COM_Refresh_Supported_User_Selected_Ledger :
      begin
        eFrom.Text := Path;
        Exit;
      end;
    end;
  end
  else
  if Software.IsXPA8Interface( MyClient.clFields.clCountry, AcctSystem) then
  begin
    Path := eFrom.Text;
    result := GetXPALedgerPath( Path);
    case result of
      bkXPA_COM_Refresh_Supported_User_Selected_Ledger :
        eFrom.Text := Path;
      bkXPA_COM_Refresh_NotSupported :
        HelpfulErrorMsg( 'Could not access the list of ' + bkConst.snNames[ snXPA] +
                         ' ledgers.  Please ensure the correct software is installed.', 0);
    end;
    //Dont browse folders, need to exit
    Exit;
  end
  else
  if Software.CanUseMYOBAO_DLL_Refresh( MyClient.clFields.clCountry, AcctSystem) then
  begin
    //can use bclink.dll to get a list of account ledgers

    Path := ExtractFileName(ExcludeTrailingBackslash(eFrom.Text));
    result := GetMYOBLedgerPath( Path);
    case result of
      bkMYOBAO_COM_Refresh_Supported_User_Selected_Ledger :
      begin
        eFrom.Text := Path;
      end;
      bkMYOBAO_COM_Refresh_AccessDenied :
        HelpfulErrorMsg( 'Could not access the list of ' + GetMYOBAO_Name(MyClient.clFields.clCountry) +
                         ' ledgers.  Access Denied.', 0);
      bkMYOBAO_COM_Refresh_NotSupported :
        HelpfulErrorMsg( 'Could not access the list of ' + GetMYOBAO_Name(MyClient.clFields.clCountry) +
                         ' ledgers.  Please ensure the correct software is installed.', 0);
    end;
    Exit;
  end
  else
  if Software.IsSol6_COM_Interface( MyClient.clFields.clCountry, AcctSystem) then
  begin
    //can use bclink.dll to get a list of account ledgers
    Path := ExtractFileName( eFrom.Text);
    result := SelectMAS_GL_Path( Path, INI_SOL6_SYSTEM_PATH);
    case result of
      bkS6_COM_Refresh_Supported_User_Selected_Ledger :
      begin
        eFrom.Text := Path;
      end;
      bkS6_COM_Refresh_NotSupported :
        HelpfulErrorMsg( 'Could not access the list of ' + GetMYOBAO_Name(MyClient.clFields.clCountry) +
                         ' ledgers.  Please ensure the correct software is installed.', 0);
    end;
    Exit;
  end;


  Path := eFrom.Text;
  if BrowseFolder( Path, 'Select the Folder to Load Chart From' ) then
     eFrom.Text := Path;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.btnToFolderClick(Sender: TObject);
var
  Path : string;
  AcctSystem : integer;
  result : integer;
begin
  with cmbSystem do
  begin
    AcctSystem := Integer( Items.Objects[ ItemIndex ] );
  end;
  //if interface specifc action then
  //  browse using interface
  //else
  //  using standard file interface
  if Software.IsXPA8Interface( MyClient.clFields.clCountry, AcctSystem) then
  begin
    Path := eTo.Text;
    result := GetXPALedgerPath( Path);
    case result of
      bkXPA_COM_Refresh_Supported_User_Selected_Ledger :
        eTo.Text := Path;
      bkXPA_COM_Refresh_NotSupported :
        HelpfulErrorMsg( 'Could not access the list of ' + bkConst.snNames[ snXPA] +
                         ' ledgers.  Please ensure the correct software is installed.', 0);
    end;

    Exit;
  end;

  Path := eTo.Text;
  if BrowseFolder( Path, 'Select the Folder to Save Entries To' ) then
     eTo.Text := Path;
end;
//------------------------------------------------------------------------------
procedure TdlgAcctSystem.cmbSystemChange(Sender: TObject);
var
   SelectedSystem : integer;

   procedure SetSaveToField(Value: Boolean);
   begin
      lblSaveTo.Enabled := Value;
      eTo.Enabled := Value;
      btnToFolder.Enabled := Value;
   end;

   procedure SetCanRefresh(Value: Boolean);
   begin
      lblFrom.Enabled := Value;
      eFrom.Enabled   := Value;
      btnFromFolder.Enabled := Value;
   end;

begin
   if Assigned(Sender)
   and Insetup then
      Exit;

   if cmbSystem.ItemIndex < 0 then
      Exit;

   SelectedSystem := Integer( cmbSystem.Items.Objects[ cmbSystem.ItemIndex ] );

   SetCanRefresh(Software.CanRefreshChart(MyClient.clFields.clCountry, SelectedSystem));
   SetSaveToField(Software.UseSaveToField(MyClient.clFields.clCountry, SelectedSystem));

   btnCheckBankManID.Visible := Software.CanUseMYOBAO_DLL_Refresh( MyClient.clFields.clCountry, SelectedSystem);

   //check current bank path variable
   if Software.IsMYOBAO_7( MyClient.clFields.clCountry, SelectedSystem) and WinUtils.IsWin2000_or_later then
   begin
     //only show button if is not set or is different
     btnSetBankpath.Visible := not myobao_utils.BankPathIsSet;
   end
   else
     btnSetBankPath.Visible := false;

   if Software.IsSol6_COM_Interface( MyClient.clFields.clCountry, SelectedSystem) then
   begin
     if not pnlMASLedgerCode.visible then begin
       Self.Height := Self.Height + pnlMASLedgerCode.Height;
       gbxAccounting.Height := gbxAccounting.Height + pnlMASLedgerCode.Height;
       pnlMASLedgerCode.visible := true;
     end;
   end
   else
   begin
     if pnlMASLedgerCode.visible then begin
       gbxAccounting.Height := gbxAccounting.Height - pnlMASLedgerCode.Height;
       Self.Height := Self.Height - pnlMASLedgerCode.Height;
       pnlMASLedgerCode.visible := false;       
     end;
   end;
 end;
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function TdlgAcctSystem.Execute(var AutoRefreshDone : Boolean) : boolean;
var
  i : integer;
  OldLoadFrom : String;
  S : String;
  LCLRec: pClient_File_Rec;
begin
   okPressed := false;
   AutoRefreshFlag := False;
   cmbSystem.Items.Clear;

   if Assigned(AdminSystem) then begin
      RefreshAdmin;
      if CanBulkExtract then begin
         GBExtract.Visible := True;
         LCLRec := AdminSystem.fdSystem_Client_File_List.FindCode(MyClient.clFields.clCode);
         if Assigned(lCLRec) then begin
            // Fill in the details
            CkExtract.Checked := FillExtractorComboBox(cbExtract, LCLRec.cfBulk_Extract_Code, False);
         end else begin
            CkExtract.Checked := FillExtractorComboBox(cbExtract, MyClient.clFields.clTemp_FRS_Job_To_Use, False);
         end;
      end else
         GBExtract.Visible := False;

      btnDefault.Visible := True;
   end else begin
      btnDefault.Visible := False;
      GBExtract.Visible := False;
   end;


   with MyClient.clFields do begin
      Insetup := true;
      cmbWebFormats.Clear;
      for i := wfMin to wfMax do
        cmbWebFormats.Items.AddObject(wfNames[i], TObject(i));

      if clWeb_Export_Format = 255 then
         clWeb_Export_Format := wfDefault;
      ComboUtils.SetComboIndexByIntObject(clWeb_Export_Format, cmbWebFormats);



      case clCountry of
       whNewZealand :
         begin
            gbxTaxInterface.Visible := False;
            gbType.Visible := False;

            FillSystemList;

            if clAccounting_System_Used in [snMin..snMax] then begin
               ComboUtils.SetComboIndexByIntObject(claccounting_system_used, cmbSystem);
            end else
               ComboUtils.SetComboIndexByIntObject(snOther, cmbSystem);

            cmbTaxInterface.Items.AddObject( tsNames[ tsMin], TObject( tsMin));
            cmbTaxInterface.ItemIndex := 0;
            edtSaveTaxTo.Text         := '';
         end;

       whAustralia :
         begin
            if assigned(AdminSystem)
            and AdminSystem.DualAccountingSystem then begin
               gbType.Visible := True;
               if software.IsSuperFund(whAustralia,clAccounting_System_Used) then
                  rbSuper.Checked := True
               else
                  rbAccounting.Checked := True;
            end else
               gbType.Visible := False;
            FillSystemList;

            if clAccounting_System_Used in [saMin..saMax] then begin
               ComboUtils.SetComboIndexByIntObject(claccounting_system_used, cmbSystem);
            end else
               ComboUtils.SetComboIndexByIntObject(snOther, cmbSystem);

            gbxTaxInterface.Visible  := True;

            for i := tsMin to tsMax do begin
              cmbTaxInterface.Items.AddObject( tsNames[ tsSortOrder[i]], TObject( tsSortOrder[i]));
            end;
            cmbTaxInterface.ItemIndex := 0;
            ComboUtils.SetComboIndexByIntObject( clTax_Interface_Used, cmbTaxInterface);

            edtSaveTaxTo.Text    := clSave_Tax_Files_To;
            eTaxLedger.Text      := clTax_Ledger_Code;
            eTaxLedger.Visible   := clTax_Interface_Used = tsBAS_Sol6ELS;
            lblTaxLedger.Visible := clTax_Interface_Used = tsBAS_Sol6ELS;
         end;

       whUK :
         begin
            gbxTaxInterface.Visible := False;
            gbType.Visible := False;

            for i := suMin to suMax do begin
              if (not Software.ExcludeFromAccSysList(clCountry, i)) or ( i = claccounting_system_used) then
                cmbSystem.items.AddObject(suNames[i], TObject( i ) );
            end;
            cmbSystem.ItemIndex := suOther;
            if clAccounting_System_Used in [suMin..suMax] then begin
               for i := 0 to ( cmbSystem.Items.Count - 1 ) do begin
                  if ( Integer( cmbSystem.Items.Objects[i] ) = claccounting_system_used ) then begin
                     cmbSystem.ItemIndex := i;
                  end;
               end;
            end;

            cmbTaxInterface.Items.AddObject( tsNames[ tsMin], TObject( tsMin));
            cmbTaxInterface.ItemIndex := 0;
            edtSaveTaxTo.Text         := '';
         end;
     end; {case}
     cmbSystemChange(nil);

     chkLockChart.Checked := clChart_Is_Locked;
     chkUseCustomLedgerCode.Checked := clUse_Alterate_ID_for_extract;
     if clUse_Alterate_ID_for_extract then
     begin
       edtExtractID.text := clAlternate_Extract_ID;
       fAlternateID := clAlternate_Extract_ID;
       edtExtractID.Enabled := true;
       btnMasLedgerCode.Enabled := true;
     end
     else
     begin
       edtExtractID.text := clCode;
       edtExtractID.Enabled := false;
       btnMasLedgerCode.Enabled := false;
     end;

     eMask.text  := clAccount_Code_Mask;
     eFrom.Text  := clLoad_Client_Files_From;
     eTo.text    := clSave_Client_Files_To;

     OldLoadFrom := clLoad_Client_Files_From;
     Insetup := False;

     Self.ClientHeight := gbxWebExport.Top + 81;
     //*****************
     Self.ShowModal;
     //*****************

     if okPressed then
     begin
        with cmbSystem do begin
           clAccounting_System_Used := Integer( Items.Objects[ ItemIndex ] );
        end;
        clChart_Is_Locked           := chkLockChart.Checked;
        clAccount_Code_Mask         := eMask.text;
        clSave_Client_Files_To      := Trim( eTo.text);
        clAlternate_Extract_ID      := Trim(edtExtractID.Text);
        clUse_Alterate_ID_for_extract := chkUseCustomLedgerCode.Checked;
        clTax_Ledger_Code           := eTaxLedger.Text;
        if CanRefreshChart( clCountry, clAccounting_System_Used ) then begin
           clLoad_Client_Files_From := Trim( eFrom.text);
           // Set Dialog Question
           if ( OldLoadFrom = '' ) then begin
              S := 'Do you want to Load the Chart Now?';
           end
           else begin
              S := 'You have changed the Folder where the Chart is Loaded From.'#13+
                   'Do you want to Refresh the Chart Now?';
           end;
           if ( clLoad_Client_Files_From <> '' ) and
              ( clLoad_Client_Files_From <> OldLoadFrom ) and
              ( AskYesNo( 'Refresh Chart', S, DLG_YES, 0 ) = DLG_YES ) then begin
              RefreshChart;
              AutoRefreshFlag := True;
           end;
        end
        else begin
           clLoad_Client_Files_From := '';
        end;

        clTax_Interface_Used       := ComboUtils.GetComboCurrentIntObject( cmbTaxInterface);

        clWeb_Export_Format        := ComboUtils.GetComboCurrentIntObject(cmbWebFormats);

        S := Trim( edtSaveTaxTo.Text);
        if ( clTax_Interface_Used = tsNone) or ( S = '') then
          clSave_Tax_Files_To      := ''
        else
          clSave_Tax_Files_To      := IncludeTrailingPathDelimiter( S);

        if GBExtract.Visible then begin
           LoadAdminSystem(True,'BulkExtract');
           try
              LCLRec := AdminSystem.fdSystem_Client_File_List.FindCode(MyClient.clFields.clCode);
              if Assigned(lCLRec) then begin
                 if CkExtract.Checked then
                    LCLRec.cfBulk_Extract_Code :=  GetComboBoxExtractorCode(CBExtract)
                 else
                    LCLRec.cfBulk_Extract_Code := '';
              end else begin
                 // New Client use ?
                 // use clTemp_FRS_Job_To_Use as a temp. holder
                 if CkExtract.Checked then
                    clTemp_FRS_Job_To_Use := GetComboBoxExtractorCode(CBExtract)
                 else
                    clTemp_FRS_Job_To_Use := '';
              end;
           finally
              if Assigned(LCLRec) then
                 SaveAdminSystem
              else
                 UnlockAdmin;
           end;
         end;


        UpdateMenus;
     end;
   end;
   result := okPressed;
end;
//------------------------------------------------------------------------------
function EditAccountingSystem(var AutoRefreshDone: Boolean; ContextID : Integer) : boolean;
var
   Mydlg : TdlgAcctSystem;
begin
   MyDlg := TdlgAcctSystem.Create(Application.MainForm);
   try
      BKHelpSetUp(MyDlg, ContextID);
      result := MyDlg.Execute(AutoRefreshDone);
      AutoRefreshDone := MyDlg.AutoRefreshFlag;
   finally
      Mydlg.Free;
   end;
end;
//------------------------------------------------------------------------------
procedure TdlgAcctSystem.cmbTaxInterfaceChange(Sender: TObject);
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
  eTaxLedger.Visible := CurrType = tsBAS_Sol6ELS;
  lblTaxLedger.Visible := CurrType = tsBAS_Sol6ELS;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.FillSystemList;
var i: Integer;
begin
    cmbSystem.items.Clear;

    with MyClient.clFields do begin
       case clCountry of
          whNewZealand : begin
             for i := snMin to snMax do begin
              if (not Software.ExcludeFromAccSysList( clCountry, i)) or ( i = claccounting_system_used) then
                 cmbSystem.items.AddObject(snNames[i], TObject( i ) );
            end;
          end;

          whAustralia : begin
            if GBType.Visible then begin
               for i := saMin to saMax do begin
                  if ((not Software.ExcludeFromAccSysList(clCountry, i)) or ( i = claccounting_system_used))
                  and (Software.IsSuperFund(whAustralia,I) = RBSuper.Checked )then
                    cmbSystem.items.AddObject(saNames[i], TObject( i ) );
               end;
            end else begin
               for i := saMin to saMax do begin
                  if (not Software.ExcludeFromAccSysList(clCountry, i)) or ( i = claccounting_system_used) then
                    cmbSystem.items.AddObject(saNames[i], TObject( i ) );
               end;
            end;
          end;
       end;
    end;
end;

procedure TdlgAcctSystem.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if OkPressed then
    CanClose := VerifyForm;
end;

function TdlgAcctSystem.VerifyForm: boolean;
const
  ThisMethodName = 'VerifyForm';
var
  Path : string;
  aMSg : string;
  CurrType : integer;
begin
  result := False;

  //alternate id
  if ( chkUseCustomLedgerCode.Checked) and ( Trim(edtExtractID.text) = '') then
  begin
    HelpfulWarningMsg( 'You must specify a Ledger Code to use', 0);
    exit;
  end;

  //tax invoice dir
  CurrType := ComboUtils.GetComboCurrentIntObject( cmbTaxInterface);
  if ( CurrType <> -1) and ( not( CurrType = tsNone)) then
  begin
    Path := Trim( edtSaveTaxTo.Text);
    if ( Path <> '') then
    begin
      Path := IncludeTrailingPathDelimiter(Path);

      //make sure the current directory is the bK5 one
      SetCurrentDir( DATADIR);
      if not DirectoryExists( Path) then
      begin
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
  end;

  //No superfund selected
  if rbSuper.Checked and (cmbSystem.ItemIndex = -1) then begin
    if cmbSystem.CanFocus then
      cmbSystem.SetFocus;
    aMsg := 'Please select a superfund system';
    HelpfulWarningMsg(aMsg, 0);
    Exit;
  end;

  // Check WebNotes
  if (ComboUtils.GetComboCurrentIntObject(cmbWebFormats) = wfWebNotes) then begin
      if (MyClient.clFields.clClient_EMail_Address = '')
      or (MyClient.clFields.clContact_Name = '') then  begin
          aMsg := Format( 'Web export to %s requires both an Email address and a contact name'#13#10'Please update the Client Details before selecting this option',
              [WebNotesName]);
          HelpfulWarningMsg(aMsg, 0);
          Exit;
      end;
  end;

  Result := True;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.btnTaxFolderClick(Sender: TObject);
var
  test : string;
begin
  test := edtSaveTaxTo.Text;

  if BrowseFolder( test, 'Select the Default Folder for exporting Tax File to' ) then
    edtSaveTaxTo.Text := test;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.btnCheckBankManIDClick(Sender: TObject);
//check that the bank man id in the save to field is set
var
  Ledger : string;
begin
  Ledger := Trim( ExtractFileName( ExcludeTrailingBackslash(eFrom.Text)));
  myobao_utils.CheckBankManID( Ledger, MyClient.clFields.clCode);
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.btndefaultClick(Sender: TObject);
   procedure LoadSuper;
   begin
      cmbSystem.ItemIndex := cmbSystem.Items.IndexOfObject(TObject(AdminSystem.fdFields.fdSuperfund_System));
      eMask.Text := AdminSystem.fdFields.fdSuperfund_Code_Mask;
      eFrom.Text := AdminSystem.fdFields.fdLoad_Client_Super_Files_From;
      eTo.Text   := AdminSystem.fdFields.fdSave_Client_Super_Files_To;
   end;
   procedure LoadAccounting;
   begin
      cmbSystem.ItemIndex := cmbSystem.Items.IndexOfObject(TObject(AdminSystem.fdFields.fdAccounting_System_Used));
      eMask.Text := AdminSystem.fdFields.fdAccount_Code_Mask;
      eFrom.Text := AdminSystem.fdFields.fdLoad_Client_Files_From;
      eTo.Text   := AdminSystem.fdFields.fdSave_Client_Files_To;
   end;
begin
   if not Assigned(AdminSystem) then
      Exit;
   if InSetup then
      Exit;

   if gbType.Visible then begin
      // Have a Dual system
      if rbSuper.Checked then
         LoadSuper
      else
         LoadAccounting
   end else begin
      if AdminSystem.fdFields.fdAccounting_System_Used = asNone then
         loadsuper
      else
         LoadAccounting
   end;

   if CanBulkExtract then
   if AdminSystem.fdFields.fdBulk_Export_Code > '' then
      ckExtract.Checked := BulkExtractFrm.SelectExtractor(AdminSystem.fdFields.fdBulk_Export_Code,cbExtract)
   else
      ckExtract.Checked := False;

   cmbSystemChange(nil);
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.eFromChange(Sender: TObject);
begin
  btnCheckBankManID.Enabled := (Trim(eFrom.Text) <> '');
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.chkUseCustomLedgerCodeClick(Sender: TObject);
begin
  edtExtractID.Enabled := chkUseCustomLedgerCode.Checked;
  btnMasLedgerCode.Enabled := edtExtractID.Enabled;

  if not chkUseCustomLedgerCode.Checked then
  begin
    FAlternateID := edtExtractID.Text;
    edtExtractid.Text := MyClient.clFields.clCode
  end
  else
    edtExtractID.Text := FAlternateID;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TdlgAcctSystem.ckExtractClick(Sender: TObject);
begin
   if ckExtract.Checked then
      if cbExtract.ItemIndex < 0 then begin
         if AdminSystem.fdFields.fdBulk_Export_Code > '' then
            BulkExtractFrm.SelectExtractor(AdminSystem.fdFields.fdBulk_Export_Code,cbExtract)
         else
            cbExtract.ItemIndex := 0;
      end;

end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.btnMasLedgerCodeClick(Sender: TObject);
var
  LedgerCode : string;
  LedgerPath : string;
  AcctSystem : integer;
  result : integer;
begin
  //is the accounting system APS
  with cmbSystem do
  begin
    AcctSystem := Integer( Items.Objects[ ItemIndex ] );
  end;
  if Software.IsSol6_COM_Interface( MyClient.clFields.clCountry, AcctSystem) then
  begin
    //can use bclink.dll to get a list of account ledgers
    LedgerCode := edtExtractID.text;
    LedgerPath := '';
    result := SelectMAS_GL_Code( LedgerCode, LedgerPath, INI_SOL6_SYSTEM_PATH);
    case result of
      bkS6_COM_Refresh_Supported_User_Selected_Ledger :
      begin
        edtExtractID.Text := LedgerCode;
        if eFrom.Text = '' then
          eFrom.Text := LedgerPath;
      end;
    end;
  end;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgAcctSystem.btnSetBankpathClick(Sender: TObject);
begin
  MYOBAO_Utils.SetBankPath;
end;

end.
