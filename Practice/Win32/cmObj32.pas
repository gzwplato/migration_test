unit cmObj32;

interface

uses
  BKDEFS, IOSTREAM, BKcmIO, TOKENS, SysUtils, LogUtil, BKDbExcept;

type
  { ----------------------------------------------------------------------------
    TCandidate_Mem
  ---------------------------------------------------------------------------- }
  TCandidate_Mem = class
  private
    fStatementDetailsLowerCase: string;
  public
    cmFields: tCandidate_Mem_Rec;
  public
    constructor Create;
    destructor  Destroy; override;

    procedure SaveToFile(var S: TIOStream);
    procedure LoadFromFile(var S: TIOStream);

    function  GetStatementDetailsLowerCase: string;
    property  StatementDetailsLowerCase: string read GetStatementDetailsLowerCase;

    function  GetAs_pRec: pCandidate_Mem_Rec;
    property  As_pRec: pCandidate_Mem_Rec read GetAs_pRec;
  end;


implementation

const
   UnitName = 'cmObj32';
   DebugMe: boolean = false;


{ ------------------------------------------------------------------------------
  TCandidate_Mem
------------------------------------------------------------------------------ }
constructor TCandidate_Mem.Create;
begin
  inherited;

  FillChar(cmFields, SizeOf(cmFields), 0);
  with cmFields do
  begin
    cmRecord_Type := tkBegin_Candidate_Mem;
    cmEOR := tkEnd_Candidate_Mem;
  end;
end;

{------------------------------------------------------------------------------}
destructor TCandidate_Mem.Destroy;
begin
  Free_Candidate_Mem_Rec_Dynamic_Fields(cmFields);

  inherited;
end;

{------------------------------------------------------------------------------}
procedure TCandidate_Mem.SaveToFile(var S: TIOStream);
const
  ThisMethodName = 'TCandidate_Mem.SaveToFile';
begin
  if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, ThisMethodName + ' Begins');

  Write_Candidate_Mem_Rec(cmFields, S);
  S.WriteToken(tkEndSection);

  if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, ThisMethodName + ' Ends');
end;

{------------------------------------------------------------------------------}
procedure TCandidate_Mem.LoadFromFile(var S: TIOStream);
const
  ThisMethodName = 'TCandidate_Mem.LoadFromFile';
var
  Token: byte;
  Msg: string;
begin
  if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, ThisMethodName + ' Begins');

  Token := tkBegin_Candidate_Mem;
  While (Token <> tkEndSection) do
  Begin
    if (Token <> tkBegin_Candidate_Mem) then
    begin
      Msg := Format('%s : Unknown Token %d', [ThisMethodName, Token]);
      LogUtil.LogMsg(lmError, UnitName, Msg );
      raise ETokenException.CreateFmt('%s - %s', [UnitName, Msg]);
    end;

    Read_Candidate_Mem_Rec(cmFields, S);

    Token := S.ReadToken;
  end;

  if DebugMe then LogUtil.LogMsg(lmDebug, UnitName, ThisMethodName + ' Ends');
end;

{------------------------------------------------------------------------------}
function TCandidate_Mem.GetStatementDetailsLowerCase: string;
begin
  { Note: on first use this value will be cached to lowercase for use with
    mems2. }
  if (fStatementDetailsLowerCase = '') and (cmFields.cmStatement_Details <> '') then
    fStatementDetailsLowerCase := LowerCase(cmFields.cmStatement_Details);

  result := fStatementDetailsLowerCase;
end;

{------------------------------------------------------------------------------}
function TCandidate_Mem.GetAs_pRec: pCandidate_Mem_Rec;
begin
  result := @cmFields;
end;

{------------------------------------------------------------------------------}
initialization
  DebugMe := DebugUnit(UnitName);


end.
