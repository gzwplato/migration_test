unit SUIFrameHelper;
//------------------------------------------------------------------------------
{
   Title: SUI Framer Helper

   Description: Helper routines for setting up Simple UI frames

   Author: Matthew Hopkins Aug 2010

   Remarks: Helps initialise buttons



}
//------------------------------------------------------------------------------

interface
uses Forms, Classes, Controls, ExtCtrls, BkExGlassButton, Graphics;


const
  clCodingColor         = $00FF8000;
  clReportsColor        = $000080FF;

  clBankRecReports      = clOlive;
  clPLReports           = $00C19702;
  clCFReports           = $00804000;
  clGSTReports          = clGreen;
  clGraphs              = $000080FF;
  clListReports         = $00808040;
  clJournals            = clAqua;

procedure InitButtonsOnGridPanel( ButtonHolder : TGridPanel;
                                  OnKeyUpEvent : TKeyEvent;
                                  OnKeyPress : TKeyPressEvent;
                                  TickImage : TPicture = nil;
                                  ButtonSize : integer = 150;
                                  HorizMargin : integer = 5;
                                  VertMargin : integer = 5;
                                  LabelHeight : integer = 15;
                                  LabelFontSize : integer = 12);

implementation
uses
  SimpleUIHomePageFrm;

procedure InitButtonsOnGridPanel( ButtonHolder : TGridPanel;
                                  OnKeyUpEvent : TKeyEvent;
                                  OnKeyPress : TKeyPressEvent;
                                  TickImage : TPicture;
                                  ButtonSize : integer;
                                  HorizMargin : integer;
                                  VertMargin : integer;
                                  LabelHeight : integer;
                                  LabelFontSize : integer);
//given a frame, set up the buttons and associate the OnArrowEvent
var
  i : integer;
  b : tbkExGlassButton;
begin
  for i := 0 to ButtonHolder.ControlCount - 1 do
    begin
      if ButtonHolder.Controls[i] is tbkExGlassButton then
      begin
        b := tbkExGlassButton(ButtonHolder.Controls[i]);
        b.BeginUpdate;
        try
          b.OnButtonKeyUp := OnKeyUpEvent;
          b.OnButtonKeyPress := OnKeyPress;
          b.Align := alClient;
          b.ButtonSize := ButtonSize;
          b.ButtonHorizMargin := HorizMargin;
          b.ButtonVertMargin := VertMargin;
          b.ParentColor := true;
          b.LabelFontSize := LabelFontSize;
          b.LabelHeight := LabelHeight;

          if Assigned( TickImage) then
          begin
            b.SetImagePicture( TickImage);
          end;
          b.ImageVisible := false;
          b.LabelVisible := false;
        finally
          B.EndUpdate;
        end;
      end;
    end;
end;



end.
