unit MonitorUtils;
//------------------------------------------------------------------------------
//  Title:   Monitor Utilities
//
//  Written: Dec 1999
//  Authors: Matthew
//
//  Purpose: Provide utilities to read screen and/or desktop settings
//
//  Notes:   The multimonitor stubs don't see to work for Win95 so test if
//           mm is supported and use a difference call.
//------------------------------------------------------------------------------
interface

uses
  windows,
  forms;

function GetDesktopWorkArea : TRect;
procedure SetFormWorkArea(aForm : TForm; MaxWidth : integer; HMargin : integer = 40; VMargin : integer = 80);

var
  MultiMonitorsOK : boolean;

//------------------------------------------------------------------------------
implementation

uses
  multimon,
  math;

//------------------------------------------------------------------------------
function GetDesktopWorkArea : TRect;
var
   Mon      : HMonitor;
   pMonInfo  : pMonitorInfo;
   WorkArea : TRect;
begin
   if MultiMonitorsOK then begin
      //get screen info, need to handle for multiple monitors
      GetMem(pMonInfo, Sizeof(tMonitorInfo));
      try
         pMonInfo.cbSize := SizeOf(TMonitorInfo);
         Mon := MonitorFromWindow( Application.MainForm.Handle, 0);
         GetMonitorInfo( Mon, pMonInfo );
         with pMonInfo^ do begin
            result := rcWork;
         end;
      finally
         Freemem( pMonInfo, SizeOf( TMonitorInfo));
      end;
   end
   else begin
      SystemParametersInfo(SPI_GETWORKAREA,0,@workArea,0);
      result := WorkArea;
   end;
end;

//------------------------------------------------------------------------------
function MultiMonitorsSupported : boolean;
//Test this during initialization
const
   ApiName = 'MonitorFromWindow';
   sUser32 = 'USER32.DLL';
var
   Addr : pointer;
   User32Dll : THandle;
begin
   //See if the api MonitorFromWindow exists in the User32.dll
   //Use this to determine if multiple monitors is supported in this version of windows
   result := false;
   User32Dll := GetModuleHandle(sUser32);
   if User32Dll <> 0 then begin
      Addr := GetProcAddress(User32Dll, PChar(ApiName));
      result := Assigned(Addr);
   end;
end;

//------------------------------------------------------------------------------
procedure SetFormWorkArea(aForm : TForm; MaxWidth : integer; HMargin : integer = 40; VMargin : integer = 80);
var
  WorkArea  : TRect;
  dskWidth  : integer;
  dskHeight : integer;
  vsbWidth  : integer;
begin
  //Get Width Vertical Scroll Bar, Size of desktop (excludes taskbar)
  vsbWidth    := GetSystemMetrics( SM_CXVSCROLL );
  //Find out what area we have to work with
  WorkArea    := GetDesktopWorkArea;
  dskWidth    := WorkArea.Right - WorkArea.Left;
  dskHeight   := WorkArea.Bottom - WorkArea.Top;
  //Set Size and Position, Center in Desktop area
  aForm.ClientWidth := Min(MaxWidth + vsbWidth, dskWidth - HMargin);
  aForm.Height      := (dskHeight - VMargin);
  aForm.Top         := WorkArea.Top + (dskHeight - aForm.Height) div 2;
  aForm.Left        := WorkArea.Left +(dskWidth - aForm.Width) div 2;
end;

//------------------------------------------------------------------------------
initialization
  MultiMonitorsOK := MultiMonitorsSupported;

end.
