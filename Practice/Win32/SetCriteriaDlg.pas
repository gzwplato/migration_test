unit SetCriteriaDlg;
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//Setup Exception Criteria
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BkConst,
  ComCtrls, OvcBase, StdCtrls, ExtCtrls, ImgList, OvcTCmmn, OvcTCell,
  OvcTCStr, OvcTCHdr, OvcTable, OvcTCBEF, OvcTCNum, OvcTCEdt,
  OSFont;

type
  TdlgSetCriteria = class(TForm)
    Bevel1: TBevel;
    btnCancel: TButton;
    OvcController1: TOvcController;
    tbData: TOvcTable;
    OvcTCColHead1: TOvcTCColHead;
    colCode: TOvcTCString;
    colDesc: TOvcTCString;
    colDollarPlus: TOvcTCNumericField;
    colDollarminus: TOvcTCNumericField;
    colPercPlus: TOvcTCNumericField;
    colPercMinus: TOvcTCNumericField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnOK: TButton;
    btnRepeat: TButton;
    lblCodeName: TStaticText;
    lblMoneyVar: TStaticText;
    lblPercentVar: TStaticText;
    procedure tbDataGetCellData(Sender: TObject; RowNum,
      ColNum: Integer; var Data: Pointer; Purpose: TOvcCellDataPurpose);
    procedure tbDataGetCellAttributes(Sender: TObject; RowNum,
      ColNum: Integer; var CellAttr: TOvcCellAttributes);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbDataActiveCellMoving(Sender: TObject; Command: Word;
      var RowNum, ColNum: Integer);
    procedure colDollarPlusOwnerDraw(Sender: TObject; TableCanvas: TCanvas;
      const CellRect: TRect; RowNum, ColNum: Integer;
      const CellAttr: TOvcCellAttributes; Data: Pointer;
      var DoneIt: Boolean);
    procedure tbDataBeginEdit(Sender: TObject; RowNum, ColNum: Integer;
      var AllowIt: Boolean);
    procedure tbDataEndEdit(Sender: TObject; Cell: TOvcTableCellAncestor;
      RowNum, ColNum: Integer; var AllowIt: Boolean);
    procedure tbDataExit(Sender: TObject);
    procedure tbDataUserCommand(Sender: TObject; Command: Word);
    procedure tbDataActiveCellChanged(Sender: TObject; RowNum,
      ColNum: Integer);
    procedure btnRepeatClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tbDataEnter(Sender: TObject);
  private
    { Private declarations }
    EditMode : boolean;
    FCountry : Byte;
    procedure DuplicateLine;
    procedure RedrawInfo;
    procedure SaveInfo;
    procedure SetUpHelp;
  public
    { Public declarations }
  end;

procedure SetExceptionCriteria;

//******************************************************************************
implementation

{$R *.DFM}

uses
  bkHelp,
  bkXPThemes,
  globals,
  GenUtils,
  bkutil32,
  CanvasUtils,
  ovcConst,
  errorMoreFrm,
  warningMorefrm,
  CountryUtils;

const
   tcDitto   = ccUserFirst + 1;
   tcDeleteCell = ccUserFirst + 2;

type
   TChartInfo = record
          Code       : Bk5CodeStr;
          Desc       : string[60];
          PostAllow  : Boolean;
          dvUp,
          dvDown,
          dpvUp,
          dpvDown : double;
   end;

var
   DataArray : Array of TChartInfo;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.FormCreate(Sender: TObject);
var
  i : Integer;
  W : Integer;
begin
  bkXPThemes.ThemeForm( Self);
  FCountry := MyClient.clFields.clCountry;
  With Label2 do Caption := Localise( FCountry, Caption );

  With OvcTCColHead1 do
  Begin
    for i := 0 to Headings.Count - 1 do
      Headings[ i ] := Localise( FCountry, Headings[ i ] );
  End;

  //Load Data
  with MyClient.clChart do begin
     SetLength(DataArray, ItemCount);
     for i := 0 to ItemCount -1 do with Account_At(i)^, DataArray[i] do begin
        Code      := chAccount_Code;
        Desc      := chAccount_Description;
        PostAllow := chPosting_Allowed;
        dvUp      := Money2Double(chMoney_Variance_Up);
        dvDown    := Money2Double(chMoney_Variance_Down);
        dpvUp     := Money2Double(chPercent_Variance_Up);
        dpvDown   := Money2Double(chPercent_Variance_Down);
     end;
     tbData.rowLimit := itemCount+1;
  end;

  //Set width of form to use more of the available area if greater than 640
  if Screen.WorkAreaWidth < 800 then
     Width := 640
  else
     Width := 760;

  //resize the account col so that longest account code fits
  tbData.Columns[ 0 ].Width := CalcAcctColWidth( tbData.Canvas, tbData.Font, 70);

  // Resize the table to fit whole rows and
  // the Desc Column to fit the table size
  with tbData do begin
     // Resize the table to show a whole number of rows
     Height := Height - ( Height mod Rows.DefaultHeight );
     // Now resize the Desc Column to fit the table width
     W := 0;
     for i := 0 to Pred( Columns.Count ) do begin
        if not Columns[i].Hidden then
           W := W + Columns.Width[i];
     end;
     i := GetSystemMetrics( SM_CXVSCROLL ); //Get Width Vertical Scroll Bar
     W := W + i + 2;
     Columns[ 1 ].Width := Columns[ 1 ].Width + ( Width - W ); //Col 1 is DescCol
  end;

  with tbData.Controller.EntryCommands do begin
    {remove F2 functionallity}
    DeleteCommand('Grid',VK_F2,0,0,0);
    DeleteCommand('Grid',VK_DELETE,0,0,0);

    {add our commands}
    AddCommand('Grid',VK_F6,0,0,0,ccTableEdit);
    AddCommand('Grid',VK_ADD,0,0,0,tcDitto);
    AddCommand('Grid',VK_DELETE,0,0,0,tcDeleteCell);
  end;

  tbData.CommandOnEnter:= ccRight;

  Editmode := false;
  SetUpHelp;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.SetUpHelp;
begin
   Self.ShowHint    := INI_ShowFormHints;
   Self.HelpContext := 0;
   //Components
   tbData.Hint      :=
      'Enter the Exception Criteria for each Account|'+
      'Enter the Exception Criteria for each Account';
   btnRepeat.Hint   :=
      'Repeat the criteria from the line above|'+
      'Repeat the Exception Criteria from the line above';
   BKHelpSetUp( Self, BKH_Exception_report);
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.FormDestroy(Sender: TObject);
begin
   DataArray := nil;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.btnOKClick(Sender: TObject);
begin
   SaveInfo;
   Close;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.btnCancelClick(Sender: TObject);
begin
   Close;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.tbDataGetCellData(Sender: TObject; RowNum,
  ColNum: Integer; var Data: Pointer; Purpose: TOvcCellDataPurpose);
begin
   data := nil;

   with MyClient.clChart do
   begin
      if (rowNum > 0) and ((rowNum -1) < ItemCount) and  Assigned(DataArray) then begin
         with DataArray[RowNum-1] do begin
            case ColNum of
              0: data := @Code;
              1: data := @Desc;
              2: data := @dvUp;
              3: data := @dvDown;
              4: data := @dpvUp;
              5: data := @dpvDown;
            end; {case}
         end;
      end;
   end;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.tbDataGetCellAttributes(Sender: TObject;
  RowNum, ColNum: Integer; var CellAttr: TOvcCellAttributes);
begin
  if not Assigned(DataArray) then exit;

  if (rowNum > 0) and (rowNum < tbdata.RowLimit) then
     if pos('*',DataArray[RowNum-1].Code) > 0 then CellAttr.caFont.Style := [fsBold];
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.tbDataActiveCellMoving(Sender: TObject;
  Command: Word; var RowNum, ColNum: Integer);
begin
  if (command = ccRight) and (colNum > 5) then begin
    if RowNuM < tbData.RowLimit-1 then begin
      colNum := 2;
      Inc(RowNum);
    end
    else
      colNum := 5;
  end;
  if colNum < 2 then colNum := 2;
  if colNum > 5 then colNum := 5;
  
  //Skip Heading Rows in Chart
  if not DataArray[ RowNum - 1 ].PostAllow then begin
     case Command of
        ccUp: begin
           if RowNum > 1 then
              Dec(RowNum)
           else
              Inc(RowNum);
        end;
        else begin
           if RowNum = tbData.RowLimit then
              Dec(RowNum)
           else
              Inc(RowNum);
        end;
     end; {case}
  end;  
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.colDollarPlusOwnerDraw(Sender: TObject;
  TableCanvas: TCanvas; const CellRect: TRect; RowNum, ColNum: Integer;
  const CellAttr: TOvcCellAttributes; Data: Pointer; var DoneIt: Boolean);
begin
  if not Assigned(data) then exit;

  if Double(data^) = 0 then
  begin
    {draw blank rect}
    TableCanvas.Brush.Color := CellAttr.caColor;
    TableCanvas.FillRect(CellRect);
    doneit := true;
  end;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.tbDataBeginEdit(Sender: TObject; RowNum,
  ColNum: Integer; var AllowIt: Boolean);
begin
  if pos('*',DataArray[RowNum-1].Code) > 0 then
  begin
    allowit := false;
    exit;
  end;

  EditMode := true;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.tbDataEndEdit(Sender: TObject;
  Cell: TOvcTableCellAncestor; RowNum, ColNum: Integer;
  var AllowIt: Boolean);
begin
   EditMode := false;
   RedrawInfo;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.tbDataExit(Sender: TObject);
var
  Msg : TWMKey;
begin
  {lost focus so finalise edit if in edit mode}
   if EditMode then
   begin
      Msg.CharCode := vk_f6;
      ColCode.SendKeyToTable(Msg);
   end;

   btnOk.Default := true;
   btnCancel.Cancel := true;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.tbDataUserCommand(Sender: TObject;
  Command: Word);
begin
   case Command of
     tcDitto : if not EditMode then
                  DuplicateLine;

     tcDeleteCell : begin
                      if EditMode then exit;
                      Keybd_event(VK_SPACE,0,0,0);
                      Keybd_event(VK_BACK ,0,0,0);
                      Keybd_event(VK_F6   ,0,0,0);
                    end;
   end;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.DuplicateLine;
var
   RowNum : integer;
   Msg : TWMKey;
begin
   RowNum := tbData.ActiveRow-1;

   if RowNum <= 0 then exit;
   if (pos('*',DataArray[RowNum].code) > 0) or (pos('*',DataArray[RowNum-1].code)> 0) then exit;

   DataArray[RowNum].dvUp := DataArray[Rownum-1].dvUp;
   DataArray[RowNum].dvDown := DataArray[Rownum-1].dvDown;
   DataArray[RowNum].dpvUp := DataArray[Rownum-1].dpvUp;
   DataArray[RowNum].dpvDown := DataArray[Rownum-1].dpvDown;

   tbData.InvalidateRow(tbData.ActiveRow);

   Msg.CharCode := vk_down;
   ColCode.SendKeyToTable(Msg);
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.tbDataActiveCellChanged(Sender: TObject; RowNum,
  ColNum: Integer);
begin
  {redraw information at bottom}
  RedrawInfo;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.RedrawInfo;
var
   RowNum : integer;
begin
   RowNum := tbData.ActiveRow -1;
   if RowNum < 0 then exit;

   with DataArray[RowNum] do
   begin
      lblCodeName.caption := code+' '+desc;
      lblMoneyVar.caption := UDMoney( Double2Money(dvUp),double2Money(dvDown));
      lblPercentVar.caption := UDPercent(Double2Money(dpvUp), Double2Money(dpvDown));
   end;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.btnRepeatClick(Sender: TObject);
begin
   DuplicateLine;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.SaveInfo;
var
   i : integer;
begin
   if not Assigned(DataArray) then exit;

   with MyClient.clChart do
   for i := 0 to Pred(itemCount) do with Account_At(i)^, DataArray[i] do
   if chAccount_Code = Code then
   begin
      chMoney_Variance_Up := double2Money(dvUp);
      chMoney_Variance_Down := double2Money(dvDown);
      chPercent_Variance_Up := double2Money(dpvUp);
      chPercent_Variance_Down := double2Money(dpvDown);
   end
   else
   begin
      HelpfulErrorMsg('Client Chart has changed. Cannot Save Exceptions.',0);
      exit;
   end;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure TdlgSetCriteria.tbDataEnter(Sender: TObject);
begin
   btnOk.Default    := false;
   btnCancel.Cancel := false;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
procedure SetExceptionCriteria;
begin
  if not Assigned(myClient) then Exit;
  if not HasAChart then Exit;
  with TdlgSetCriteria.Create(Application.MainForm) do begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


end.

