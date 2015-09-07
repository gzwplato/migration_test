unit CombineManualAccountsDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  OSFont;

type
  TDlgCombineManualAccounts = class(TForm)
    lblInstructions: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cmbBankAccounts: TComboBox;
    cmbCombine: TComboBox;
    Panel1: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    lblAccountFrom: TLabel;
    lblAccountTo: TLabel;
    lblFromEntries: TLabel;
    lblToEntries: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lblDateFrom: TLabel;
    lblDFrom: TLabel;
    lblDateTo: TLabel;
    lblDTo: TLabel;
    pnlControls: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    ShapeBorder: TShape;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cmbBankAccountsSelect(Sender: TObject);
    procedure cmbCombineSelect(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateStatistics;
  public
    { Public declarations }
  end;



procedure CombineManualAccounts;

implementation

uses Globals, bkConst, YesNoDlg, WarningMoreFrm, baObj32, progress, LogUtil,
  InfoMoreFrm, ErrorMoreFrm, baUtils, bkDateUtils, bkDefs, Admin32,
  MemorisationsObj, MemUtils, BKMLIO, bkHelp, bkXPThemes, ECodingUtils,
  AuditMgr;

const
   UnitName = 'CombineManualAccountsDlg';

{$R *.dfm}

procedure TDlgCombineManualAccounts.FormCreate(Sender: TObject);
begin
  inherited;
  bkXPThemes.ThemeForm( Self);
  // Fill account list
  cmbBankAccounts.Clear;
  cmbCombine.Clear;
  cmbBankAccounts.Items := GetValidManualBankAccountsForCombine(MyClient.clBank_Account_List);

  if cmbBankAccounts.Items.Count = 1 then // if only one then select it
    cmbBankAccounts.ItemIndex := 0;

  cmbBankAccountsSelect(Sender);

  UpdateStatistics;
end;

procedure TDlgCombineManualAccounts.btnOKClick(Sender: TObject);
begin
  if cmbBankAccounts.ItemIndex = -1 then
  begin
    HelpfulWarningMsg( 'Please select the manual bank accounts you wish to combine.',0);
    cmbBankAccounts.SetFocus;
    exit;
  end;
  if cmbCombine.ItemIndex = -1 then
  begin
    HelpfulWarningMsg( 'Please select the manual bank accounts you wish to combine.',0);
    cmbCombine.SetFocus;
    exit;
  end;

  if AskYesNo('Combine Accounts', 'After combining these manual bank accounts the account "' +
      cmbBankAccounts.Text + '" will be deleted and will no longer appear in your Client File.'#13#13 +
      'All of its transactions and memorisations will be moved to account "' + cmbCombine.Text + '".'#13#13 +
      'This process cannot be undone. Are you sure you want to continue?', DLG_NO, 0) = DLG_YES then
    ModalResult := mrOk;
end;

procedure TDlgCombineManualAccounts.cmbBankAccountsSelect(Sender: TObject);
var
  baFrom, baTo: TBank_Account;
  i, FromEntries, ToEntries, D1, D2, D3, D4: Integer;
begin
  if cmbBankAccounts.ItemIndex = -1 then
  begin
    cmbCombine.Clear;
    exit;
  end;
  baFrom := TBank_Account(cmbBankAccounts.Items.Objects[cmbBankAccounts.ItemIndex]);
  cmbCombine.Clear;
  if Assigned(baFrom) then
  begin
    // List all accounts with first entry date after or equal last entry date of selected account
    with MyClient.clBank_Account_List do
      for i := 0 to Pred( ItemCount) do
      begin
        baTo := Bank_Account_At( i);
        if (baTo.baFields.baAccount_Type <> btBank)
        or (not baTo.IsManual)
        or (baFrom.baFields.baCurrency_Code <> baTo.baFields.baCurrency_Code)
        or (baFrom = baTo) then
           Continue;
        GetStatsForAccount( baFrom, 0, MaxInt, FromEntries, D1, D2); // get range of selected account
        GetStatsForAccount( baTo, 0, D2, ToEntries, D3, D4); // get range of test account
        if (FromEntries = 0) or (ToEntries = 0) then
          cmbCombine.Items.AddObject( baTo.Title, baTo);
      end;
    if cmbCombine.Items.Count = 1 then // if only one then select it
      cmbCombine.ItemIndex := 0;
  end;
  if cmbCombine.Items.Count = 0 then
    HelpfulInfoMsg('There are no manual bank accounts that can be merged with the selected account.', 0);
  UpdateStatistics;
end;

procedure CombineManualAccounts;
var
  aMsg, AcctNo, AcctName: string;
  FromBa, ToBa: TBank_Account;
  i, j, TransferCount, FromX, ToX: Integer;
  pT: pTransaction_Rec;
  MemFrom, MemTo : TMemorisation;
  MemLineFrom, MemLineTo : pMemorisation_Line_Rec;
  Dissection: pDissection_Rec;
  AccList : TStringList;
begin
  if not Assigned( MyClient) then exit;
  //Check if they have outstanding BNotes or Acclipse files, and warn them against continuing. Case 8625
  if not CheckOutstandingEcodingFiles(MyClient) then Exit;


  with TDlgCombineManualAccounts.Create(Application.MainForm) do
    try
      ShowModal;
      if ModalResult = mrOK then
      begin
        UpdateAppStatus('Combining Manual Accounts','',30);
        try
          FromBa   := TBank_Account( cmbBankAccounts.Items.Objects[ cmbBankAccounts.ItemIndex]);
          ToBa   := TBank_Account( cmbCombine.Items.Objects[ cmbCombine.ItemIndex]);

          AccList := TStringList.Create;
          try
            AccList.Add(FromBa.baFields.baBank_Account_Number);
            AccList.Add(ToBa.baFields.baBank_Account_Number);
          finally
            FreeAndNil(AccList);
          end;

          TransferCount := 0;
          LogUtil.LogMsg( lmInfo, UnitName, 'Combining entries from ' + FromBa.baFields.baBank_Account_Number + ' to ' + ToBa.BaFields.baBank_Account_Number);
          // Loop around transfering the trx and then deleting trx until end of list
          // (Process copied from transfer entries)
          if FromBa.baTransaction_List.ItemCount > 0 then
          begin
            i := 0;
            with FromBa.baTransaction_List do
              repeat
                pT := Transaction_At(i);
                // Delete from old account
                FromBa.baTransaction_List.Delete(pT);
                // Change sequence no to match new bank account - important for sorting!
                pT^.txBank_Seq := ToBa.baFields.baNumber;
                // Delete the ecoding id as this is related to a bank account not to a transaction
                pT^.txECoding_Transaction_UID := 0;
                //insert into bank account
                ToBa.baTransaction_List.Insert_Transaction_Rec( pT);

                Dissection := pT^.txFirst_Dissection;

                while Dissection <> nil do
                begin
                  Dissection.dsBank_Account := pT^.txBank_Account;
                  Dissection.dsClient := pT^.txClient;
                  Dissection := Dissection.dsNext;
                end;

                Inc(TransferCount);
              until (ItemCount = 0);
          end;
          // Also copy contra, use master mems, and sched rep selection
          ToBa.baFields.baContra_Account_Code := FromBa.baFields.baContra_Account_Code;
          ToBa.baFields.baExchange_Gain_Loss_Code := FromBa.baFields.baExchange_Gain_Loss_Code;
          ToBa.baFields.baApply_Master_Memorised_Entries := FromBa.baFields.baApply_Master_Memorised_Entries;
          FromX := Pos(FromBa.baFields.baBank_Account_Number + ',', MyClient.clFields.clExclude_From_Scheduled_Reports);
          ToX := Pos(ToBa.baFields.baBank_Account_Number + ',', MyClient.clFields.clExclude_From_Scheduled_Reports);
          if (FromX = 0) and (ToX <> 0) then // From account not excluded, To account excluded - remove To account
            Delete(MyClient.clFields.clExclude_From_Scheduled_Reports, ToX, Length(ToBa.baFields.baBank_Account_Number) + 1)
          else if (FromX <> 0) and (ToX =0) then // From account excluded, To account not excluded - add To Account
            MyClient.clFields.clExclude_From_Scheduled_Reports := MyClient.clFields.clExclude_From_Scheduled_Reports +
              ToBa.baFields.baBank_Account_Number + ',';
          // Copy mems
          //items at the top have a higher sequence number
          for i := FromBa.baMemorisations_List.Last downto FromBa.baMemorisations_List.First do
          begin
            MemFrom := FromBa.baMemorisations_List.Memorisation_At(i);
            if HasDuplicateMem(MemFrom, ToBa.baMemorisations_List) then Continue;
            MemTo := TMemorisation.Create(ToBa.AuditMgr);
            MemTo.mdFields^ := MemFrom.mdFields^;
            for j := MemFrom.mdLines.First to MemFrom.mdLines.Last do
            begin
              MemLineFrom := MemFrom.mdLines.MemorisationLine_At(j);
              MemLineTo := BKMLIO.New_Memorisation_Line_Rec;
              MemLineTo^ := MemLineFrom^;
              MemTo.mdLines.Insert(MemLineTo);
            end;
            MemTo.mdFields.mdFrom_Master_List := False;
            MemTo.mdFields.mdSequence_No := 0;
            ToBa.baMemorisations_List.Insert_Memorisation(MemTo);
          end;
          // Delete the From account
          AcctName := FromBa.AccountName;
          AcctNo := FromBa.baFields.baBank_Account_Number;
          MyClient.clBank_Account_List.DelFreeItem(FromBa);
          LogUtil.LogMsg(lmInfo, UnitName,'Deleted Manual Bank Account ' + AcctNo + ' - ' + AcctName);
        finally
          ClearStatus;
        end;
        aMsg := 'Successfully combined manual bank account "' + AcctNo + ' ' + AcctName +
                    '" with "' + ToBa.baFields.baBank_Account_Number + ' ' + ToBa.AccountName + '".';
        LogUtil.LogMsg( lmInfo, UnitName, aMsg + ' ' + IntToStr(TransferCount) + ' transactions were combined.');
        HelpfulInfoMsg( aMsg, 0);

        //*** Flag Audit ***
        //Set audit info here so no system client file record
        //needs to be saved to the audit table.
        aMsg := Format('Combined manual bank accounts%sFrom %s %s%sTo %s%sTransactions Added=%d',
                       [VALUES_DELIMITER, AcctNo, AcctName, VALUES_DELIMITER,
                        ToBa.Title, VALUES_DELIMITER,
                        TransferCount]);
        MyClient.ClientAuditMgr.FlagAudit(arClientBankAccounts,
                                          ToBa.baFields.baAudit_Record_ID,
                                          aaNone,
                                          aMsg);
      end;
    finally
      Free;
    end;
end;

procedure TDlgCombineManualAccounts.UpdateStatistics;
//update all the information fields where we have enough information
var
   iEntries : integer;
   dFrom    : integer;
   dTo      : integer;
   TempFrom : integer;
   TempTo   : integer;
   FromAccount : TBank_Account;
   ToAccount   : TBank_Account;
begin
   FromAccount := nil;
   ToAccount   := nil;
   lblAccountFrom.Caption  := '-';
   lblFromEntries.Caption  := '0';
   lblDateFrom.Caption     := '-';
   lblDateTo.Caption       := '-';
   lblAccountTo.Caption  := '-';
   lblToEntries.Caption  := '0';
   lblDFrom.Caption      := '-';
   lblDTo.Caption        := '-';

   //combo boxes have valid selections
   if ( cmbBankAccounts.ItemIndex <> -1) then
      FromAccount := TBank_Account( cmbBankAccounts.Items.Objects[ cmbBankAccounts.ItemIndex]);
   if ( cmbCombine.ItemIndex <> -1) then
      ToAccount := TBank_Account( cmbCombine.Items.Objects[ cmbCombine.ItemIndex]);

   if Assigned( FromAccount) then
   begin
      lblAccountFrom.Caption := StringReplace(cmbBankAccounts.Items[ cmbBankAccounts.ItemIndex], '&', '&&', [rfReplaceAll]);
      //count entries
      GetStatsForAccount( FromAccount, 0, MaxInt , iEntries, TempFrom, TempTo);
      lblFromEntries.Caption  := IntToStr( iEntries);
      if iEntries > 0 then
      begin
         lblDateFrom.Caption     := BKDate2Str( TempFrom);
         lblDateTo.Caption       := BKDate2Str( TempTo);
      end;
   end;

   if Assigned( ToAccount) then
   begin
      lblAccountTo.Caption  := StringReplace(cmbCombine.Items[ cmbCombine.ItemIndex], '&', '&&', [rfReplaceAll]);

      GetStatsForAccount( ToAccount, 0, MaxInt, iEntries, dFrom, dTo);
      lblToEntries.Caption  := IntToStr( iEntries);
      if iEntries > 0 then
      begin
         lblDFrom.Caption     := BKDate2Str( dFrom);
         lblDTo.Caption       := BKDate2Str( dTo);
      end;
   end;
end;

procedure TDlgCombineManualAccounts.cmbCombineSelect(Sender: TObject);
begin
  UpdateStatistics;
end;

procedure TDlgCombineManualAccounts.FormShow(Sender: TObject);
begin
  BKHelpSetup(Self, BKH_Combining_manual_bank_accounts);
end;

end.
