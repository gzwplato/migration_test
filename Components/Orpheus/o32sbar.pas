{*********************************************************}
{*                    O32SBAR.PAS 4.05                   *}
{*       Copyright (c) 1996,99 Inprise Corporation       *}
{*       Copyright (c) 2001 TurboPower Software Co       *}
{*                 All rights reserved.                  *}
{*********************************************************}

(*Changes)
  {!!.02}
    - When status Bar attempts to resize contained controls, non-visual
      components caused an "Invalid Typecast error".  Added checks to make sure
      that non-TControl and non-TGraphicControl items are ignored.
      - 8-31-01 - PB.
*)


{$I OVC.INC}
unit o32sbar;
  { Orpheus status bar component }
  { A modified version of the standard VCL TO32StatusPanel with the ability to }
  { contain components in each of the panels. }

interface

{ TODO :
The Design HitTest in the container is a brute force method of forcing
the contained controls to size and position themselves.  It should be fixed
ASAP. }

uses
  Windows, Messages, SysUtils, Classes, ExtCtrls, Controls, Graphics, Commctrl,
  ComCtrls, Forms, {$IFDEF Version4}StdActns,{$ENDIF} OvcBase;

type
  {Forward Declarations}
  TO32CustomStatusBar = class;
  TO32StatusPanel = class;

  {Styles}
  TO32StatusPanelStyle = (spsText, spsContainer, spsOwnerDraw);
  TO32StatusPanelBevel = (spbNone, spbLowered, spbRaised);

  {Container Class}
  TO32SBContainer = class(TPanel)
  protected {Private}
    FStatusBar    : TO32CustomStatusBar;
    FIndex        : Integer;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetChildOwner: TComponent; override;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest);
      message CM_DESIGNHITTEST;
    procedure CMNotifyParent(var Message: TWMNotify); message WM_PARENTNOTIFY;
    procedure FixControls;
    procedure InvalidateControls;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    property Index: Integer Read FIndex;
    property StatusBar: TO32CustomStatusBar read FStatusBar;
  end;

  {Panel class}
  TO32StatusPanel = class(TCollectionItem)
  protected {private}
    FText: string;
    FStatusBar : TO32CustomStatusBar;
    FContainerIndex: Integer;
    FWidth: Integer;
    FAlignment: TAlignment;
    FBevel: TO32StatusPanelBevel;
    {$IFDEF VERSION4}
    FBiDiMode: TBiDiMode;
    {$ENDIF}
    FParentBiDiMode: Boolean;
    FStyle: TO32StatusPanelStyle;
    FUpdateNeeded: Boolean;

    {internal methods}
    function CreateContainer: Integer;
    function IsBiDiModeStored: Boolean;

    {property methods}
    procedure SetAlignment(Value: TAlignment);
    procedure SetBevel(Value: TO32StatusPanelBevel);
    {$IFDEF VERSION4}
    procedure SetBiDiMode(Value: TBiDiMode);
    procedure SetParentBiDiMode(Value: Boolean);
    {$ENDIF}
    procedure SetStyle(Value: TO32StatusPanelStyle);
    procedure SetText(const Value: string);
    procedure SetWidth(Value: Integer);
    function GetDisplayName: string; override;
    function GetContainer: TO32SBContainer;

    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadIndex(Reader: TReader);
    procedure WriteIndex(Writer: TWriter);
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    {$IFDEF VERSION4}
    procedure ParentBiDiModeChanged;
    function UseRightToLeftAlignment: Boolean;
    function UseRightToLeftReading: Boolean;
    {$ENDIF}
    property Container: TO32SBContainer read GetContainer;
    property ContainerIndex : Integer read FContainerIndex write FContainerIndex;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Bevel: TO32StatusPanelBevel read FBevel write SetBevel default spbLowered;
    {$IFDEF VERSION4}
    property BiDiMode: TBiDiMode read FBiDiMode write SetBiDiMode stored IsBiDiModeStored;
    property ParentBiDiMode: Boolean read FParentBiDiMode write SetParentBiDiMode default True;
    {$ENDIF}
    property Style: TO32StatusPanelStyle read FStyle write SetStyle default spsText;
    property Text: string read FText write SetText;
    property Width: Integer read FWidth write SetWidth;
  end;

  {Panel events}
  TO32DrawPanelEvent = procedure(StatusBar: TO32CustomStatusBar; Panel: TO32StatusPanel;
    const Rect: TRect) of object;

  {Panels class}
  TO32StatusPanels = class(TCollection)
  protected {private}
    FStatusBar: TO32CustomStatusBar;
    function GetItem(Index: Integer): TO32StatusPanel;
    procedure SetItem(Index: Integer; Value: TO32StatusPanel);
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(StatusBar: TO32CustomStatusBar);
    function Add: TO32StatusPanel;
    property Items[Index: Integer]: TO32StatusPanel read GetItem write SetItem; default;
  end;

  {Custom StatusBar Class}
  TO32CustomStatusBar = class(TWinControl)
  protected {private}
    FPanels         : TO32StatusPanels;
    FCanvas         : TCanvas;
    FContainers     : TO32ContainerList;
    FSimpleText     : string;
    FSimplePanel    : Boolean;
    FSizeGrip       : Boolean;
    FUseSystemFont  : Boolean;
    FAutoHint       : Boolean;
    FOnDrawPanel    : TO32DrawPanelEvent;
    FOnHint         : TNotifyEvent;

    procedure DoRightToLeftAlignment(var Str: string;
                                     AAlignment: TAlignment;
                                     ARTLAlignment: Boolean);
    function  IsFontStored: Boolean;
    procedure SetAbout(const Value: string);
    function  GetAbout: string;
    procedure SetPanels(Value: TO32StatusPanels);
    procedure SetSimplePanel(Value: Boolean);
    procedure UpdateSimpleText;
    procedure SetSimpleText(const Value: string);
    procedure SetSizeGrip(Value: Boolean);
    procedure SyncToSystemFont;
    procedure UpdatePanel(Index: Integer; Repaint: Boolean);
    procedure UpdatePanels(UpdateRects, UpdateText: Boolean);
    {$IFDEF VERSION4}
    procedure CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    {$ENDIF}
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMWinIniChange(var Message: TMessage); message CM_WININICHANGE;
    procedure CMSysFontChanged(var Message: TMessage); message CM_SYSFONTCHANGED;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WMGetTextLength(var Message: TWMGetTextLength); message WM_GETTEXTLENGTH;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetUseSystemFont(const Value: Boolean);

    procedure ChangeScale(M, D: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    function  DoHint: Boolean; virtual;
    procedure DrawPanel(Panel: TO32StatusPanel; const Rect: TRect); dynamic;

    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetChildOwner: TComponent; override;
    function AddContainer(Container: TO32SBContainer): Integer;
    procedure RemoveContainer(Container: TO32SBContainer);
    function GetContainer(Index: Integer):TO32SBContainer;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {$IFDEF VERSION4}
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure FlipChildren(AllLevels: Boolean); override;
    function GetPanelAt(X, Y: Integer): TO32StatusPanel;                 {!!.05}
    {$ENDIF}
    property Canvas: TCanvas read FCanvas;

    property About : string read GetAbout write SetAbout
       stored False;                                                     {!!.05}
    property Containers[Index: Integer]: TO32SBContainer read GetContainer;
    property AutoHint: Boolean read FAutoHint write FAutoHint default False;
    property Align default alBottom;
    {$IFDEF VERSION4}
    property BorderWidth;
    {$ENDIF}
    property Color default clBtnFace;
    property Font stored IsFontStored;
    property Panels: TO32StatusPanels read FPanels write SetPanels;
    property ParentColor default False;
    property ParentFont default False;
    property SimplePanel: Boolean read FSimplePanel write SetSimplePanel;
    property SimpleText: string read FSimpleText write SetSimpleText;
    property SizeGrip: Boolean read FSizeGrip write SetSizeGrip default True;
    property UseSystemFont: Boolean read FUseSystemFont write SetUseSystemFont default True;
    property OnHint: TNotifyEvent read FOnHint write FOnHint;
    property OnDrawPanel: TO32DrawPanelEvent read FOnDrawPanel write FOnDrawPanel;
  end;

  TO32StatusBar = class(TO32CustomStatusBar)
  published
    property About;
    {$IFDEF VERSION4}
    property Action;
    property Anchors;
    property BiDiMode;
    property BorderWidth;
    property DragKind;
    property Constraints;
    property ParentBiDiMode;
    property OnEndDock;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    {$ENDIF}
    property AutoHint;
    property Align;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Panels;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property SimplePanel default False;                                {!!.05}
    property SimpleText;
    property SizeGrip;
    property UseSystemFont;
    property Visible;
    property OnClick;
    {$IFDEF Version5}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnHint;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDrawPanel;
  end;

implementation

uses
  OvcVer, StdCtrls;

type
  {protected class member access}
  ProtectedEdit = class(TCustomEdit);

{===== TO32Container==================================================}

constructor TO32SBContainer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStatusBar := TO32CustomStatusBar(AOwner);
  BevelInner := bvNone;
  BevelOuter := bvNone;
  FIndex := FStatusBar.AddContainer(Self);
end;
{=====}

destructor TO32SBContainer.Destroy;
begin
  inherited;
end;
{=====}

function TO32SBContainer.GetChildOwner: TComponent;
begin
  Result := Owner.Owner;
end;
{=====}

procedure TO32SBContainer.CMDesignHitTest(var Message: TCMDesignHitTest);
begin
  FixControls;
end;
{=====}

procedure TO32SBContainer.CMNotifyParent(var Message: TWMNotify);
begin
  FixControls;
end;
{=====}

{!!.02 - rewritten for optimization}
procedure TO32SBContainer.FixControls;
var
  Control    : TControl;
  I          : Integer;
begin
  if FStatusBar = nil then exit;

  {Set component height to that of the container}
  for I := 0 to ComponentCount - 1 do begin
    Control := nil;
    try
      {Ignore non-visual controls...}
      if Components[I] is TCustomEdit then begin
        Control := TCustomEdit(Components[I]);
        ProtectedEdit(Components[I]).AutoSize := false;
        ProtectedEdit(Components[I]).BorderStyle := bsNone;
      end else
      if Components[I] is TControl then
        Control := TControl(Components[I])
      else
      if Components[I] is TGraphicControl then
        Control := TGraphicControl(Components[I]);
      if Control <> nil then begin
        {Resize TControls as necessary}
        Control.Height := Self.Height;
        Control.Top := 0;
      end;
    except
      {swallow exceptions}
    end;
  end;
end;
{=====}

procedure TO32SBContainer.Invalidate;
begin
  inherited;
  InvalidateControls;
end;
{=====}

procedure TO32SBContainer.InvalidateControls;
var
  ParentForm : TCustomForm;
  I          : Integer;
begin
  if FStatusBar = nil then exit;
  ParentForm := TCustomForm(FStatusBar.Owner);
  for I := 0 to ParentForm.ComponentCount - 1 do
    if(ParentForm.Components[I] is TControl)                          {!!.02}
    and ((ParentForm.Components[I] as TControl).Parent = self) then   {!!.02}
      (ParentForm.Components[I] as TControl).Invalidate;
end;
{=====}

procedure TO32SBContainer.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  C: TControl;
begin
  inherited GetChildren(Proc, Self);

  for I := 0 to ControlCount - 1 do begin
    C := Controls[I];
    C.Parent := Self;
    Proc(C);
  end;
end;

{===== TO32StatusPanel ==================================================}

constructor TO32StatusPanel.Create(Collection: TCollection);
begin
  FWidth := 50;
  FBevel := spbLowered;
  FStatusBar := TO32CustomStatusBar(TO32Collection(Collection).GetOwner);
  RegisterClass(TO32SBContainer);
  FParentBiDiMode := True;
  inherited Create(Collection);
  {$IFDEF VERSION4}
  ParentBiDiModeChanged;
  {$ENDIF}
end;
{=====}

procedure TO32StatusPanel.Assign(Source: TPersistent);
begin
  if Source is TO32StatusPanel then
  begin
    Text := TO32StatusPanel(Source).Text;
    Width := TO32StatusPanel(Source).Width;
    Alignment := TO32StatusPanel(Source).Alignment;
    Bevel := TO32StatusPanel(Source).Bevel;
    Style := TO32StatusPanel(Source).Style;
  end
  else inherited Assign(Source);
end;
{=====}

procedure TO32StatusPanel.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('ContainerIndex', ReadIndex, WriteIndex,
    Style = spsContainer);
end;
{=====}

procedure TO32StatusPanel.ReadIndex(Reader: TReader);
begin
  ContainerIndex := trunc(Reader.ReadFloat);
end;
{=====}

procedure TO32StatusPanel.WriteIndex(Writer: TWriter);
begin
  Writer.WriteFloat(ContainerIndex);
end;
{=====}

{$IFDEF VERSION4}
procedure TO32StatusPanel.SetBiDiMode(Value: TBiDiMode);
begin
  if Value <> FBiDiMode then
  begin
    FBiDiMode := Value;
    FParentBiDiMode := False;
    Changed(False);
  end;
end;
{=====}
{$ENDIF}

function TO32StatusPanel.IsBiDiModeStored: Boolean;
begin
  Result := not FParentBiDiMode;
end;
{=====}

{$IFDEF VERSION4}
procedure TO32StatusPanel.SetParentBiDiMode(Value: Boolean);
begin
  if FParentBiDiMode <> Value then
  begin
    FParentBiDiMode := Value;
    ParentBiDiModeChanged;
  end;
end;
{=====}

procedure TO32StatusPanel.ParentBiDiModeChanged;
begin
  if FParentBiDiMode then
  begin
    if GetOwner <> nil then
    begin
      BiDiMode := TO32StatusPanels(GetOwner).FStatusBar.BiDiMode;
      FParentBiDiMode := True;
    end;
  end;
end;
{=====}

function TO32StatusPanel.UseRightToLeftReading: Boolean;
begin
  Result := SysLocale.MiddleEast and (BiDiMode <> bdLeftToRight);
end;
{=====}

function TO32StatusPanel.UseRightToLeftAlignment: Boolean;
begin
  Result := SysLocale.MiddleEast and (BiDiMode = bdRightToLeft);
end;
{=====}
{$ENDIF}

function TO32StatusPanel.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then Result := inherited GetDisplayName;
end;
{=====}

function TO32StatusPanel.GetContainer: TO32SBContainer;
begin
  if Style = spsContainer then
    result := FStatusBar.FContainers[FContainerIndex]
  else
    result := nil;
end;
{=====}

procedure TO32StatusPanel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;
{=====}

procedure TO32StatusPanel.SetBevel(Value: TO32StatusPanelBevel);
begin
  if FBevel <> Value then
  begin
    FBevel := Value;
    Changed(False);
  end;
end;
{=====}

procedure TO32StatusPanel.SetStyle(Value: TO32StatusPanelStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    if not (csLoading in FStatusBar.ComponentState) then begin
      if FStyle = spsContainer then
        FContainerIndex := CreateContainer
      else begin
        if FContainerIndex > -1 then begin
          TO32SBContainer(FStatusBar.FContainers.Items[FContainerIndex]).Free;
          FStatusBar.FContainers.Delete(FContainerIndex);
          FContainerIndex := -1;
        end;
      end;
    end;
    Changed(False);
  end;
end;
{=====}

function TO32StatusPanel.CreateContainer: Integer;
var
  Container: TO32SBContainer;
begin
  Container := TO32SBContainer.Create(FStatusBar);
  result := Container.Index;
  with Container do begin
    Parent := FStatusBar;
    Name := 'Container' + IntToStr(result);
    Caption := '';
    BevelOuter := bvNone;
    BevelInner := bvNone;
    Color := FStatusBar.Color;
  end;
end;
{=====}

procedure TO32StatusPanel.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(False);
  end;
end;
{=====}

procedure TO32StatusPanel.SetWidth(Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    Changed(True);
  end;
end;

{===== TO32StatusPanels ==============================================}

constructor TO32StatusPanels.Create(StatusBar: TO32CustomStatusBar);
begin
  inherited Create(TO32StatusPanel);
  FStatusBar := StatusBar;
end;
{=====}

function TO32StatusPanels.Add: TO32StatusPanel;
begin
  Result := TO32StatusPanel(inherited Add);
end;
{=====}

function TO32StatusPanels.GetItem(Index: Integer): TO32StatusPanel;
begin
  Result := TO32StatusPanel(inherited GetItem(Index));
end;
{=====}

function TO32StatusPanels.GetOwner: TPersistent;
begin
  Result := FStatusBar;
end;
{=====}

procedure TO32StatusPanels.SetItem(Index: Integer; Value: TO32StatusPanel);
begin
  inherited SetItem(Index, Value);
end;
{=====}

procedure TO32StatusPanels.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    FStatusBar.UpdatePanel(Item.Index, False)
  else
    FStatusBar.UpdatePanels(True, False);
end;

{===== TO32CustonStatusBar ===========================================}

constructor TO32CustomStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Color := clBtnFace;
  Height := 19;
  Align := alBottom;
  FPanels := TO32StatusPanels.Create(Self);
  FCanvas := TControlCanvas.Create;
  FContainers := TO32ContainerList.Create(self);
  TControlCanvas(FCanvas).Control := Self;
  FSizeGrip := True;
  ParentFont := False;
  FUseSystemFont := True;
  SyncToSystemFont;
end;
{=====}

destructor TO32CustomStatusBar.Destroy;
begin
  FCanvas.Free;
  FPanels.Free;
  FContainers.Free;
  inherited Destroy;
end;
{=====}

procedure TO32CustomStatusBar.CreateParams(var Params: TCreateParams);
const
  GripStyles: array[Boolean] of DWORD = (CCS_TOP, SBARS_SIZEGRIP);
begin
  InitCommonControl(ICC_BAR_CLASSES);
  inherited CreateParams(Params);
  CreateSubClass(Params, STATUSCLASSNAME);
  with Params do
  begin
    Style := Style or GripStyles[FSizeGrip and (Parent is TCustomForm)
    {$IFDEF VERSION4}
    and (TCustomForm(Parent).BorderStyle in [bsSizeable, bsSizeToolWin])
    {$ENDIF}];
    WindowClass.style := WindowClass.style and not CS_HREDRAW;
  end;
end;
{=====}

procedure TO32CustomStatusBar.CreateWnd;
begin
  inherited CreateWnd;
  {$IFNDEF VERSION4}
    {$IFNDEF CBUILDER}
      {D3}
      SendMessage(Handle, WM_CTLCOLOR, 0, ColorToRGB(Color));
    {$ENDIF}
  {$ELSE}
  SendMessage(Handle, SB_SETBKCOLOR, 0, ColorToRGB(Color));
  {$ENDIF}
  UpdatePanels(True, False);
  if FSimpleText <> '' then
    SendMessage(Handle, SB_SETTEXT, 255, Integer(PChar(FSimpleText)));
  if FSimplePanel then
    SendMessage(Handle, SB_SIMPLE, 1, 0);
end;
{=====}

function TO32CustomStatusBar.DoHint: Boolean;
begin
  if Assigned(FOnHint) then
  begin
    FOnHint(Self);
    Result := True;
  end
  else Result := False;
end;
{=====}

procedure TO32CustomStatusBar.DrawPanel(Panel: TO32StatusPanel;
                                        const Rect: TRect);
begin
  if Assigned(FOnDrawPanel) then
    FOnDrawPanel(Self, Panel, Rect)
  else begin
    FCanvas.FillRect(Rect);
  end;
end;
{=====}

procedure TO32CustomStatusBar.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
begin
  for I := 0 to FContainers.Count - 1 do
    Proc(TComponent(FContainers[I]));
end;
{=====}

function TO32CustomStatusBar.GetChildOwner: TComponent;
begin
  Result := Self;
end;
{=====}

function TO32CustomStatusBar.AddContainer(Container: TO32SBContainer): Integer;
begin
  result := FContainers.Add(Container);
end;
{=====}

procedure TO32CustomStatusBar.RemoveContainer(Container: TO32SBContainer);
begin
  FContainers.Remove(Container);
  Container.Free;
end;
{=====}

function TO32CustomStatusBar.GetContainer(Index: Integer):TO32SBContainer;
begin
  try
    result := FContainers[Index];
  except
    result := nil;
  end;
end;
{=====}

procedure TO32CustomStatusBar.SetPanels(Value: TO32StatusPanels);
begin
  FPanels.Assign(Value);
end;
{=====}

procedure TO32CustomStatusBar.SetSimplePanel(Value: Boolean);
begin
  if FSimplePanel <> Value then
  begin
    FSimplePanel := Value;
    if HandleAllocated then
      SendMessage(Handle, SB_SIMPLE, Ord(FSimplePanel), 0);
  end;
end;
{=====}

procedure TO32CustomStatusBar.DoRightToLeftAlignment(var Str: string;
  AAlignment: TAlignment; ARTLAlignment: Boolean);
begin
  {$IFDEF VERSION4}
  if ARTLAlignment then ChangeBiDiModeAlignment(AAlignment);
  {$ENDIF}

  case AAlignment of
    taCenter: Insert(#9, Str, 1);
    taRightJustify: Insert(#9#9, Str, 1);
  end;
end;
{=====}

procedure TO32CustomStatusBar.UpdateSimpleText;
const
  RTLReading: array[Boolean] of Longint = (0, SBT_RTLREADING);
begin
  {$IFDEF VERSION4}
  DoRightToLeftAlignment(FSimpleText, taLeftJustify, UseRightToLeftAlignment);
  if HandleAllocated then
    SendMessage(Handle, SB_SETTEXT, 255 or RTLREADING[UseRightToLeftReading],
      Integer(PChar(FSimpleText)));
  {$ELSE}
  if HandleAllocated then
    SendMessage(Handle, SB_SETTEXT, 255, Integer(PChar(FSimpleText)));
  {$ENDIF}
end;
{=====}

procedure TO32CustomStatusBar.SetSimpleText(const Value: string);
begin
  if FSimpleText <> Value then
  begin
    FSimpleText := Value;
    UpdateSimpleText;
  end;
end;
{=====}

{$IFDEF VERSION4}
procedure TO32CustomStatusBar.CMBiDiModeChanged(var Message: TMessage);
var
  Loop: Integer;
begin
  inherited;
  if HandleAllocated then
    if not SimplePanel then
    begin
      for Loop := 0 to Panels.Count - 1 do
        if Panels[Loop].ParentBiDiMode then
          Panels[Loop].ParentBiDiModeChanged;
      UpdatePanels(True, True);
    end
    else
      UpdateSimpleText;
end;
{=====}

procedure TO32CustomStatusBar.FlipChildren(AllLevels: Boolean);
var
  Loop, FirstWidth, LastWidth: Integer;
  APanels: TO32StatusPanels;
begin
  if HandleAllocated and
     (not SimplePanel) and (Panels.Count > 0) then
  begin
    { Get the true width of the last panel }
    LastWidth := ClientWidth;
    FirstWidth := Panels[0].Width;
    for Loop := 0 to Panels.Count - 2 do Dec(LastWidth, Panels[Loop].Width);
    { Flip 'em }
    APanels := TO32StatusPanels.Create(Self);
    try
      for Loop := 0 to Panels.Count - 1 do with APanels.Add do
        Assign(Self.Panels[Loop]);
      for Loop := 0 to Panels.Count - 1 do
        Panels[Loop].Assign(APanels[Panels.Count - Loop - 1]);
    finally
      APanels.Free;
    end;
    { Set the width of the last panel }
    if Panels.Count > 1 then
    begin
      Panels[Panels.Count-1].Width := FirstWidth;
      Panels[0].Width := LastWidth;
    end;
    UpdatePanels(True, True);
  end;
end;
{=====}

function TO32CustomStatusBar.GetPanelAt(X, Y: Integer): TO32StatusPanel; {!!.05}
var                                                                      {!!.05}
  I: Integer;                                                            {!!.05}
  Pnl : TO32StatusPanel;                                                 {!!.05}
  Lft: Integer;                                                          {!!.05}
begin                                                                    {!!.05}
  result := nil;                                                         {!!.05}
  Lft := Left;                                                           {!!.05}
  for I := 0 to pred(FPanels.Count) do begin                             {!!.05}
    Pnl := FPanels.Items[I];                                             {!!.05}
    if (X >= Lft) and (X <= Lft + Pnl.Width) then begin                  {!!.05}
      Result := Pnl;                                                     {!!.05}
      Exit;                                                              {!!.05}
    end;                                                                 {!!.05}
    Inc(Lft, Pnl.Width);                                                 {!!.05}
  end;                                                                   {!!.05}
end;                                                                     {!!.05}
{=====}                                                                  {!!.05}
{$ENDIF}

procedure TO32CustomStatusBar.SetSizeGrip(Value: Boolean);
begin
  if FSizeGrip <> Value then
  begin
    FSizeGrip := Value;
    RecreateWnd;
  end;
end;
{=====}

procedure TO32CustomStatusBar.SyncToSystemFont;
begin
  {$IFDEF Version5}
  if FUseSystemFont then
    Font := Screen.HintFont;
  {$ENDIF}
end;
{=====}

procedure TO32CustomStatusBar.UpdatePanel(Index: Integer; Repaint: Boolean);
var
  Flags: Integer;
  S: string;
  PanelRect: TRect;
begin
  if HandleAllocated then begin

    with Panels[Index] do begin

      if Style = spsContainer then begin
        FUpdateNeeded := True;
        SendMessage(Handle, SB_GETRECT, Index, Integer(@PanelRect));
        Panels[Index].Container.Color := Color;;
        with Panels[Index].Container do begin
          Visible := true;
          if (Panels[Index].FBevel = spbNone) then begin
            Left := PanelRect.Left;
            Top := PanelRect.Top;
            Width := PanelRect.Right - PanelRect.Left;
            Height := PanelRect.Bottom - PanelRect.Top;
          end else begin
            Left := PanelRect.Left + 1;
            Top := PanelRect.Top + 1;
            Width := PanelRect.Right - PanelRect.Left - 2;
            Height := PanelRect.Bottom - PanelRect.Top - 2;
          end;
        end;
      end {Panel.Style = spsContainer}

      else begin
        if not Repaint then begin
          FUpdateNeeded := True;
          SendMessage(Handle, SB_GETRECT, Index, Integer(@PanelRect));
          InvalidateRect(Handle, @PanelRect, True);
          Exit;
        end else
          if not FUpdateNeeded then Exit;

        FUpdateNeeded := False;
        Flags := 0;

        case Bevel of
          spbNone:
            Flags := SBT_NOBORDERS;
          spbRaised:
            Flags := SBT_POPOUT;
        end;

        {$IFDEF VERSION4}
        if UseRightToLeftReading then
          Flags := Flags or SBT_RTLREADING;
        {$ENDIF}

        if Style = spsOwnerDraw then
          Flags := Flags or SBT_OWNERDRAW;

        S := Text;

        {$IFDEF VERSION4}
        if UseRightToLeftAlignment then
          DoRightToLeftAlignment(S, Alignment, UseRightToLeftAlignment)
        else
          case Alignment of
            taCenter:
              Insert(#9, S, 1);
            taRightJustify:
              Insert(#9#9, S, 1);
          end;
        {$ENDIF}

        SendMessage(Handle, SB_SETTEXT, Index or Flags, Integer(PChar(S)));

      end; {Panel.Style = spsContainer - else}
    end; {Panels[index]}
  end; {Handle Allocated}
end;
{=====}

procedure TO32CustomStatusBar.UpdatePanels(UpdateRects, UpdateText: Boolean);
const
  MaxPanelCount = 128;
var
  I, Count, PanelPos: Integer;
  PanelEdges: array[0..MaxPanelCount - 1] of Integer;
begin
  if HandleAllocated then
  begin
    Count := Panels.Count;
    if UpdateRects then
    begin
      if Count > MaxPanelCount then Count := MaxPanelCount;
      if Count = 0 then
      begin
        PanelEdges[0] := -1;
        SendMessage(Handle, SB_SETPARTS, 1, Integer(@PanelEdges));
        SendMessage(Handle, SB_SETTEXT, 0, Integer(PChar('')));
      end else
      begin
        PanelPos := 0;
        for I := 0 to Count - 2 do
        begin
          Inc(PanelPos, Panels[I].Width);
          PanelEdges[I] := PanelPos;
        end;
        PanelEdges[Count - 1] := -1;
        SendMessage(Handle, SB_SETPARTS, Count, Integer(@PanelEdges));
      end;
    end;
    for I := 0 to Count - 1 do begin
      UpdatePanel(I, UpdateText);
      if Panels[I].Style = spsContainer then begin
        { Set the contained component's height to that of the container }
        Panels[I].Container.FixControls;
        { invalidate the container and its controls }
        Panels[I].Container.Invalidate;
      end;
    end;
  end;
end;
{=====}

procedure TO32CustomStatusBar.CMWinIniChange(var Message: TMessage);
begin
  inherited;
  if (Message.WParam = 0) or (Message.WParam = SPI_SETNONCLIENTMETRICS) then
    SyncToSystemFont;
end;
{=====}

procedure TO32CustomStatusBar.CNDrawItem(var Message: TWMDrawItem);
var
  SaveIndex: Integer;
begin
  with Message.DrawItemStruct^ do
  begin
    SaveIndex := SaveDC(hDC);
    FCanvas.Lock;
    try
      FCanvas.Handle := hDC;
      FCanvas.Font := Font;
      FCanvas.Brush.Color := clBtnFace;
      FCanvas.Brush.Style := bsSolid;
      DrawPanel(Panels[itemID], rcItem);
    finally
      FCanvas.Handle := 0;
      FCanvas.Unlock;
      RestoreDC(hDC, SaveIndex);
    end;
  end;
  Message.Result := 1;
end;
{=====}

procedure TO32CustomStatusBar.WMGetTextLength(var Message: TWMGetTextLength);
begin
  Message.Result := Length(FSimpleText);
end;
{=====}

procedure TO32CustomStatusBar.WMPaint(var Message: TWMPaint);
begin
  UpdatePanels(False, True);
  inherited;
end;
{=====}

procedure TO32CustomStatusBar.WMSize(var Message: TWMSize);
begin
  { Eat WM_SIZE message to prevent control from doing alignment }
  {$IFDEF VERSION4}
  if not (csLoading in ComponentState) then Resize;
  {$ENDIF}
  Repaint;
end;
{=====}

function TO32CustomStatusBar.IsFontStored: Boolean;
begin
  Result := not FUseSystemFont and not ParentFont and not DesktopFont;
end;
{=====}

function TO32CustomStatusBar.GetAbout : string;
begin
  Result := OrVersionStr;
end;
{=====}

procedure TO32CustomStatusBar.SetAbout(const Value : string);
begin
  {Leave Empty}
end;
{=====}

procedure TO32CustomStatusBar.SetUseSystemFont(const Value: Boolean);
begin
  if FUseSystemFont <> Value then
  begin
    FUseSystemFont := Value;
    if Value then
    begin
      if ParentFont then ParentFont := False;
      SyncToSystemFont;
    end;
  end;
end;
{=====}

procedure TO32CustomStatusBar.CMColorChanged(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;
{=====}

procedure TO32CustomStatusBar.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if FUseSystemFont and ParentFont then FUseSystemFont := False;
end;
{=====}

{$IFDEF VERSION4}
function TO32CustomStatusBar.ExecuteAction(Action: TBasicAction): Boolean;
begin
  if AutoHint and (Action is THintAction) and not DoHint then
  begin
    if SimplePanel or (Panels.Count = 0) then
      SimpleText := THintAction(Action).Hint else
      Panels[0].Text := THintAction(Action).Hint;
    Result := True;
  end
  else Result := inherited ExecuteAction(Action);
end;
{=====}
{$ENDIF}

procedure TO32CustomStatusBar.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;
{=====}

procedure TO32CustomStatusBar.CMSysFontChanged(var Message: TMessage);
begin
  inherited;
  SyncToSystemFont;
end;
{=====}

procedure TO32CustomStatusBar.ChangeScale(M, D: Integer);
begin
  if UseSystemFont then  // status bar size based on system font size
    ScalingFlags := [sfTop];
  inherited;
end;

end.
