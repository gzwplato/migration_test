�
 TDLGEXCEPTRPT 0  TPF0TdlgExceptRptdlgExceptRptLeftGTop� BorderStylebsDialogCaptionException ReportClientHeight�ClientWidth�Color	clBtnFace
ParentFont	OldCreateOrderPositionpoScreenCenterScaledOnCreate
FormCreateOnShowFormShow
DesignSize�� PixelsPerInch`
TextHeight TButtonbtnOKLeftITopkWidthKHeightAnchorsakLeftakBottom Caption&PrintTabOrderOnClick
btnOKClick  TButton	btnCancelLeft�TopkWidthKHeightAnchorsakLeftakBottom Cancel	CaptionCancelTabOrder	OnClickbtnCancelClick  TButton
btnPreviewLeftTopkWidthKHeightAnchorsakLeftakBottom CaptionPrevie&wDefault	TabOrderOnClickbtnPreviewClick  TButtonbtnFileLeftXTopkWidthKHeightAnchorsakLeftakBottom CaptionFil&eTabOrderOnClickbtnFileClick  TPanelPanel1LeftTop3Width�Height2TabOrder 	TCheckBoxchkGSTLeft TopWidth� HeightCaptionPrint &GST InclusiveTabOrder    TPanelPanel2LeftTopWidth�Height2TabOrder  TLabelLabel3LeftTopWidthhHeightCaptionReporting Year &StartsFocusControlCmbStartMonth  	TComboBoxCmbStartMonthLeft� TopWidth]HeightStylecsDropDownList
ItemHeightTabOrder OnChangeCmbStartMonthChange  TRzSpinEditspnStartYearLeft'TopWidthIHeightMax      `�
@Min      ��	@Value      @�	@TabOrder   TPanelPanel3LeftTop@Width�HeightITabOrder TLabellblLastLeftHTop*Width� HeightCaption+This last period of  CODED data is Dec 1998  TLabelLabel1LeftTop
WidthHeightCaptionPeriod  	TComboBox	cmbPeriodLeftHTop
Width(HeightStylecsOwnerDrawFixedDropDownCount
ItemHeightTabOrder 
OnDrawItemcmbPeriodDrawItemItems.Strings123456789101112    TPanelPanel4LeftTop� Width�Height� TabOrder TLabelLabel2LeftTopWidth.HeightCaptionCompare   TLabelLabel4LeftTopzWidth"HeightCaptionBudget  	TCheckBox	chkYTDBudLeft"Top_Width� HeightCaptionYTD with &Budgeted YTDTabOrder  	TCheckBox
chkYTDLastLeft"TopHWidth� HeightCaption&YTD with Last Year YTDTabOrder  	TCheckBoxchkThisPeriodBudLeft"Top0Width� HeightCaptionThis Period with B&udgetTabOrder  	TCheckBoxchkThisPeriodLYLeft"TopWidthHeightCaption'&This Period with This Period Last YearTabOrder   	TComboBox	cmbBudgetLeftHTopxWidth(HeightStylecsDropDownList
ItemHeightTabOrder   TBitBtnbtnSaveLeft� TopkWidthKHeightCaptionSa&veTabOrderOnClickbtnSaveClick  TButtonbtnEmailLeft� TopkWidthKHeightAnchorsakLeftakBottom CaptionE&mailTabOrderOnClickbtnEmailClick  TOvcControllerOvcController1EntryCommands.TableListDefault	 WordStar Grid  EpochlLeftTop   