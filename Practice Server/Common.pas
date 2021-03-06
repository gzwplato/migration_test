unit Common;

interface

uses
  Windows, SysUtils, IdContext, PracticeClientServer;

type
  TConnectionRecord = class
  private
    FID: ULongLong;
    FContext: TIdContext;
    FTimeConnected: TDateTime;

    FUserCode: String;
    FWorkstation: String;
    FIPAddress: String;
    FGroupId: TGroupId;

    procedure SetUserCode(const Value: String);
    procedure SetWorkstation(const Value: String);
    procedure SetGroupId(const Value: TGroupId);
  public
    constructor Create(AID: ULongLong; AContext: TIdContext);

    property ID: ULongLong read FID;
    
    property Context: TIdContext read FContext;

    property UserCode: String read FUserCode write SetUserCode;
    property Workstation: String read FWorkstation write SetWorkstation;
    property IPAddress: String read FIPAddress;

    property TimeConnected: TDateTime read FTimeConnected;

    property GroupId: TGroupId read FGroupId write SetGroupId;
  end;

  TLockRecord = class
  private
    FID: ULongLong;
    FToken: DWord;
    FLockType: DWord;
    FStatus: TLockStatus;
    FContext: TIdContext;
    FTimeCreated: TDateTime;
    FTimeAquired: TDateTime;
    FIPAddress: String;
    FGroupId: TGroupId;
        
    procedure SetStatus(const Value: TLockStatus);
    procedure SetTimeAquired(const Value: TDateTime);
  public
    constructor Create(AID: ULongLong; AToken: DWord; AContext: TIdContext; ALockType: DWord; AStatus: TLockStatus; AGroupId: TGroupId);

    property ID: ULongLong read FID;
    
    property Token: DWord read FToken;
    property LockType: DWord read FLockType;
    property Context: TIdContext read FContext;

    property IPAddress: String read FIPAddress;

    property Status: TLockStatus read FStatus write SetStatus;

    property TimeCreated: TDateTime read FTimeCreated;
    property TimeAquired: TDateTime read FTimeAquired write SetTimeAquired;

    property GroupId: TGroupId read FGroupId;
  end;
  
implementation

{ TConnectionRecord }

constructor TConnectionRecord.Create(AID: ULongLong; AContext: TIdContext);
begin
  FID := AID;
  
  FContext := AContext;

  FIPAddress := FContext.Binding.PeerIP;

  FTimeConnected := Now;
end;

procedure TConnectionRecord.SetGroupId(const Value: TGroupId);
begin
  FGroupId := Value;
end;

procedure TConnectionRecord.SetUserCode(const Value: String);
begin
  FUserCode := Value;
end;

procedure TConnectionRecord.SetWorkstation(const Value: String);
begin
  FWorkstation := Value;
end;

{ TLockRecord }

constructor TLockRecord.Create(AID: ULongLong; AToken: DWord; AContext: TIdContext; ALockType: DWord; AStatus: TLockStatus; AGroupId: TGroupId);
begin
  FID := AID;
  
  FToken := AToken;
  
  FLockType := ALockType;

  FStatus := AStatus;

  FContext := AContext;

  FIPAddress := FContext.Binding.PeerIP;

  FTimeCreated := Now;

  if AStatus = lsAquired then
  begin
    FTimeAquired := FTimeCreated;
  end
  else
  begin
    FTimeAquired := 0;
  end;

  FGroupId := AGroupId;
end;

procedure TLockRecord.SetStatus(const Value: TLockStatus);
begin
  FStatus := Value;
end;

procedure TLockRecord.SetTimeAquired(const Value: TDateTime);
begin
  FTimeAquired := Value;
end;

end.
