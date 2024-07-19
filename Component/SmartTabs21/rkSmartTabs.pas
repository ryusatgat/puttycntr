unit rkSmartTabs;
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
// SmartTabs by Roy Magne Klever
//
// WEB: www.rmklever.com
// Mail: roymagne@rmklever.com
//
// version 2.3 April 2013  (beta version)
//
// License MPL 1.1
//
// {$Define OldGDI+}

interface

uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, Graphics, Forms, Messages,
  ImgList, Dialogs, Menus, StdCtrls, GDIPObj, GDIPAPI;

const
  MinWidth: Integer = 100;
  MaxWidth: Integer = 192;
  PinnedWidth: Integer = 48;
  PolyTabCount = 10;
  TextFadeOut = 16;
  TabExt = 36;
  TabButtonWidth = 27;
  TabOffVal = 14;

type
  PRGBA = ^TRGBA;

  TRGBA = record
    b, g, r, a: Byte;
  end;

  PRGBAArray = ^TRGBAArray;
  TRGBAArray = packed array[0..MaxInt div SizeOf(TRGBA)-1] of TRGBA;

  TPenId = (piBrdActive, piBrdHot, piBrdInActive, piBrdBottom, piBackgnd, piCloseBtnGray,
    piCloseBtnWhite, piCloseBtnBlue);
  TBrushId = (biTabInActive, biTabActive, biTabHot, biCloseBtnRed, biCloseBtnDGrey,
    biMaskWhite, biAddBtnWhite, biAddBtnWhiteBlend, biAddBtnBlack);

  TabState = (stNormal, stHot, stSelected);
  TOnCustomDrawEvent = procedure(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
    AText: string; AState: TabState; AIndex: Integer) of object;
  TOnTabCloseEvent = procedure(Sender: TObject; Index: Integer; var Close: Boolean) of object;
  TOnGetImageIndexEvent = procedure(Sender: TObject; Tab: Integer;
    var Index: Integer) of object;
  TabPoly = array [0 .. 9] of TPoint;

  TWMMouseWheel = record
    Msg: Cardinal;
    Keys: SmallInt;
    WheelDelta: SmallInt;
    case Integer of
    0:
      (XPos: SmallInt;
        YPos: SmallInt);
    1:
      (Pos: TSmallPoint;
        Result: Longint);
  end;

  TrkSmartTabs = class(TCustomControl)
  private
    { Private declarations }
    FActiveTab: Integer;
    FAutoSize: Boolean;
    FBmp: TBitmap;
    FButtonDown: Boolean;
    FCanDrag: Boolean;
    FCloseDown: Boolean;
    FCloseHide: Boolean;
    FColorBackground: TColor;
    FColorBrdBottom: TColor;
    FColorBrdActive: TColor;
    FColorBrdHot: TColor;
    FColorBrdInActive: TColor;
    FColorTabActive: TColor;
    FColorTabHot: TColor;
    FColorTabInActive: TColor;
    FColorTxtActive: TColor;
    FColorTxtHot: TColor;
    FColorTxtInActive: TColor;
    FColorOutActive: TColor;
    FColorOutHot: TColor;
    FColorOutInActive: TColor;
    FDefPopup: TPopupMenu;
    // FDragging: Boolean;
    FDragOff: Integer;
    FDragPoint: TPoint;
    FDragX: Integer;
    FDragLeft: Boolean;
    FDragTab: Integer;
    FGdiPTExt: Boolean;
    FHotButton: Boolean;
    FHotClose: Boolean;
    FHotIdx: Integer;
    FImageHide: Boolean;
    FImages: TCustomImageList;
    FLevelTabActive: Byte;
    FLevelTabHot: Byte;
    FLevelTabInActive: Byte;
    FMinCloseWidth: Integer;
    FOutline: Boolean;
    FPinnedStr: String;
    FShowButton: Boolean;
    FPinnedTabs: Integer;
    FTabClose: Integer;
    FTabOffset: Integer;
    FTabOffsetTop: Integer;
    FTabX: Integer;
    FTabs: TStringList;
    FTabsFont: TGPFont;
    FTabsHeight: Integer;
    FTabOverLap: Integer;
    FTabWidth: Integer;
    FShowImages: Boolean;
    FShowClose: Boolean;
    FTransparent: Boolean;
    TabsCanvas: TGPGraphics;
    FOnAddClick: TNotifyEvent;
    FOnCloseTab: TOnTabCloseEvent;
    FOnCustomDraw: TOnCustomDrawEvent;
    FOnGetImageIdx: TOnGetImageIndexEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnTabChange: TNotifyEvent;
    FSeeThruTabs: Boolean;
    ScrollTimer: TTimer;
    procedure CalcTabWidth;
    procedure PaintTabs;
    procedure SetTabs(const Value: TStringList);
    procedure SetActiveTab(const Value: Integer);
    procedure SetTabOffset(const Value: Integer);
    procedure SetShowButton(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    function OverButton(x, y: Integer): Boolean;
    function OverClose(x, y: Integer): Integer;
    procedure SetShowClose(const Value: Boolean);
    procedure SetShowImages(const Value: Boolean);
    procedure SetBackground(const Value: TColor);
    procedure SetColors;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure DoMouseWheel(var Msg: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure DoPopup(Sender: TObject; APoint: TPoint);
    procedure DoPopupClick(Sender: TObject);
    procedure SetCloseHide(const Value: Boolean);
    procedure SetColorActive(const Value: TColor);
    procedure SetColorHot(const Value: TColor);
    procedure SetColorInActive(const Value: TColor);
    procedure SetInView(Idx: Integer; Id: Integer);
    procedure SetPinnedStr(const Value: String);
    procedure SetLevelTabActive(const Value: Byte);
    procedure SetLevelTabHot(const Value: Byte);
    procedure SetLevelTabInActive(const Value: Byte);
    procedure SetColTxtActive(const Value: TColor);
    procedure SetColTxtHot(const Value: TColor);
    procedure SetColTxtInActive(const Value: TColor);
    procedure SetColBrdActive(const Value: TColor);
    procedure SetColBrdHot(const Value: TColor);
    procedure SetColBrdInActive(const Value: TColor);
    procedure SetSeeThruTabs(const Value: Boolean);
    procedure SetOutline(const Value: Boolean);
    procedure SetGdiPText(const Value: Boolean);
    procedure SetOutActive(const Value: TColor);
    procedure SetOutHot(const Value: TColor);
    procedure SetOutInActive(const Value: TColor);
    procedure SetImageHide(const Value: Boolean);
    function GetTabPolyS(Idx: Integer): TabPoly;
    procedure PaintSimpleTabs(TabsCanvas: TGPGraphics; Back, Mask: TBitmap);
    procedure PaintScrollingTabs(TabsCanvas: TGPGraphics; Back, Mask: TBitmap);
    function TabWidth(AIndex: Integer): Integer;
    procedure SetAutoTabSize(const Value: Boolean);
    function TabWidthA(AIndex: Integer): Integer;
    function GetTabPolyA(Idx: Integer): TabPoly;
    function ARGBColor(a, r, g, b: Byte): TGPColor;
    function ColorToARGB(anAlpha: Byte; aColor: TColor): TGPColor;
    procedure SetColBrdBottom(const Value: TColor);
  protected
    { Protected declarations }
    ClsBtnX: Integer;
    FirstRun: Boolean;
    InCreate: Boolean;
    BmPWidth: Integer;
    BmTWidth: Integer;
    BmTabs: TRect;
    Brushes: array [TBrushId] of TGPSolidBrush;
    CMP: TPoint;
    Pens: array [TPenId] of TGPPen;
    ScrollLeft: Boolean;
    ScrollMode: Boolean;
    ScrollVar: Boolean;
    ScrollOff: Integer;
    ScrollView: TPoint;
    ScrollMax: Integer;
    ScrollTabs: Integer;
    procedure Click; override;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure DoScroll(Sender: TObject; ScrollDir: Integer);
    procedure DoTimer(Sender: TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; x, y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; x, y: Integer); override;
    procedure MouseMove(Shift: TShiftState; x, y: Integer); override;
  public
    { Public declarations }
    PopUpTab: Integer;
    FDragging: Boolean;
    CR: TRect;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddTab(ATab: string);
    procedure AddObject(ATab: string; AObject: TObject);
    procedure DeleteTab(AIndex: Integer);
    function GetTabAtXY(x, y: Integer): Integer;
    procedure InsertTab(AIndex: Integer; ATab: string);
    procedure InsertObj(AIndex: Integer; ATab: string; AObject: TObject);
    procedure PinTab(AIndex: Integer);
    procedure UnPinTab(AIndex: Integer);
    function GetTabName(AIndex: Integer): String;
    procedure SetTabName(AIndex: Integer; AName: String);
    function TabPinned(AIndex: Integer): Boolean;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMERASEBKGND(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure PaintWindow(DC: HDC); override;
    procedure Resize; override;
    property InScrollMode: Boolean read ScrollMode;
  published
    { Published declarations }
    property Align;
    property Anchors;
    property ActiveTab: Integer read FActiveTab write SetActiveTab;
    property AllowTabDrag: Boolean read FCanDrag Write FCanDrag default False;
    property AutoHideClose: Boolean read FCloseHide write SetCloseHide default False;
    property AutoHideImages: Boolean read FImageHide write SetImageHide default False;
    property AutoSizeTabs: Boolean read FAutoSize write SetAutoTabSize default False;
    property ColorTabActive: TColor read FColorTabActive write SetColorActive;
    property ColorTabHot: TColor read FColorTabHot write SetColorHot;
    property ColorTabInActive: TColor read FColorTabInActive write SetColorInActive;
    property ColorTxtActive: TColor read FColorTxtActive write SetColTxtActive;
    property ColorTxtHot: TColor read FColorTxtHot write SetColTxtHot;
    property ColorTxtInActive: TColor read FColorTxtInActive write SetColTxtInActive;
    property ColorBrdActive: TColor read FColorBrdActive write SetColBrdActive;
    property ColorBrdHot: TColor read FColorBrdHot write SetColBrdHot;
    property ColorBrdInActive: TColor read FColorBrdInActive write SetColBrdInActive;
    property ColorBrdBottom: TColor read FColorBrdBottom write SetColBrdBottom default clGray;
    property ColorBackground
      : TColor read FColorBackground write SetBackground default clBtnFace;
    property ColorOutActive: TColor read FColorOutActive write SetOutActive default clGray;
    property ColorOutHot: TColor read FColorOutHot write SetOutHot default clGray;
    property ColorOutInActive
      : TColor read FColorOutInActive write SetOutInActive default clGray;
    property Enabled;
    property Font;
    property GdiPlusText: Boolean read FGdiPTExt write SetGdiPText default False;
    property Images: TCustomImageList read FImages write FImages;
    property LevelTabActive: Byte read FLevelTabActive write SetLevelTabActive;
    property LevelTabHot: Byte read FLevelTabHot write SetLevelTabHot;
    property LevelTabInActive: Byte read FLevelTabInActive write SetLevelTabInActive;
    property Outline: Boolean read FOutline write SetOutline default False;
    property PinnedStr: String read FPinnedStr write SetPinnedStr;
    property PopupMenu;
    property SeeThruTabs: Boolean read FSeeThruTabs write SetSeeThruTabs;
    property ShowButton: Boolean read FShowButton write SetShowButton default True;
    property ShowClose: Boolean read FShowClose write SetShowClose default True;
    property ShowHint;
    property ShowImages: Boolean read FShowImages write SetShowImages default False;
    property TabOffset: Integer read FTabOffset write SetTabOffset default 0;
    property Tabs: TStringList read FTabs write SetTabs;
    property TabStop;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property Visible;
    property OnAddClick: TNotifyEvent read FOnAddClick write FOnAddClick;
    property OnClick;
    property OnCloseTab: TOnTabCloseEvent read FOnCloseTab write FOnCloseTab;
    property OnCustomDraw: TOnCustomDrawEvent read FOnCustomDraw write FOnCustomDraw;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex: TOnGetImageIndexEvent read FOnGetImageIdx write FOnGetImageIdx;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnTabChange: TNotifyEvent read FOnTabChange write FOnTabChange;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('rmklever', [TrkSmartTabs]);
end;

{ TrkSmartTabs }

function Blend(Color1, Color2: TColor; Value: Byte): TColor;
var
  i, j: Longint;
begin
  Value := Round(2.56 * Value);
  i := ColorToRGB(Color1);
  j := ColorToRGB(Color2);
  Result := Byte((Value * (Byte(i) - Byte(j))) shr 8 + Byte(j));
  Result := Result + (Byte((Value * (Byte(i shr 8) - Byte(j shr 8))) shr 8 + Byte(j shr 8))
      shl 8);
  Result := Result + (Byte((Value * (Byte(i shr 16) - Byte(j shr 16))) shr 8 + Byte(j shr 16))
      shl 16);
end;

function GetTabsPoly(x1, y1, x2, y2: Integer): TabPoly; inline;
begin
  Result[0].x := x1;
  Result[0].y := y2;
  Result[1].x := x1 + 2;
  Result[1].y := y2 - 3;
  Result[2].x := x1 + 11;
  Result[2].y := y1 + 2;
  Result[3].x := x1 + 12;
  Result[3].y := y1 + 1;
  Result[4].x := x1 + 14;
  Result[4].y := y1;
  Result[5].x := x2 - 14;
  Result[5].y := y1;
  Result[6].x := x2 - 12;
  Result[6].y := y1 + 1;
  Result[7].x := x2 - 11;
  Result[7].y := y1 + 2;
  Result[8].x := x2 - 2;
  Result[8].y := y2 - 3;
  Result[9].x := x2;
  Result[9].y := y2;
end;

procedure TrkSmartTabs.AddObject(ATab: string; AObject: TObject);
begin
  if AObject <> nil then
    Tabs.AddObject(ATab, AObject)
  else
    Tabs.Add(ATab);
  FActiveTab := Tabs.Count - 1;

  if (ScrollMode) and (ActiveTab >= FPinnedTabs) then
  begin
    CalcTabWidth;
    ScrollOff := 0;
    ScrollView := Point(0, BmTWidth);
    SetInView(FActiveTab - FPinnedTabs, 0);
  end
  else
    Invalidate;

  if Assigned(FOnTabChange) and (not InCreate) then
    FOnTabChange(Self);
end;

procedure TrkSmartTabs.AddTab(ATab: string);
begin
  AddObject(ATab, nil);
end;

function TrkSmartTabs.TabWidth(AIndex: Integer): Integer;
var
  n, i: Integer;
  l: Integer;
  layoutRect: TGPRectF;
  TxtFormat: TGPSTRINGFORMAT;
  boundingBox: TGPRectF;
  codepointsFitted: Integer;
  linesFilled: Integer;
  stat: GPSTATUS;
  s: String;
begin
  if InCreate then
    Exit;

  if AIndex + FPinnedTabs >= FTabs.Count then
    Result := 0
  else
  if FAutoSize then
  begin
    i:= 0;
    s:= GetTabName(AIndex + FPinnedTabs);

    if FGdiPTExt then
    begin

      TxtFormat := TGPStringFormat.Create();
      TxtFormat.SetLineAlignment(StringAlignmentCenter);
      TxtFormat.SetFormatFlags(StringFormatFlagsNoWrap);
      layoutRect.X:= 0;
      layoutRect.Y:= 0;
      layoutRect.Width:= Screen.Width;
      layoutRect.Height:= Screen.Height;
      stat:= GdipMeasureString(TabsCanvas, PWCHAR(s), Length(s), FTabsFont, @layoutRect,
             TxtFormat, @boundingBox, @codepointsFitted, @linesFilled) ;

      i:= Round(boundingBox.Width - boundingBox.X);
      TxtFormat.Free;
    end
    else
      i:= FBmp.Canvas.TextWidth(s);

    Result := TabExt + i;
    if FShowClose then
    begin
      if FCloseHide then
      begin
        if (AIndex + FPinnedTabs = FActiveTab) then
          Result := Result + 14;
      end
      else
        Result := Result + 14;
    end;
    if FShowImages then
    begin
      if Assigned(FOnGetImageIdx) and Assigned(FImages) then
      begin
        FOnGetImageIdx(Self, AIndex + FPinnedTabs, n);
        if n <> -1 then
          Result := Result + 16;
      end;
    end;
  end
  else
    Result := FTabWidth;
end;

function TrkSmartTabs.TabWidthA(AIndex: Integer): Integer;
var
  n: Integer;
begin
  Result := 0;
  if AIndex < FTabs.Count then
  begin
    if AIndex < FPinnedTabs then
      Result := PinnedWidth
    else if FAutoSize then
    begin
      Result := TabExt + FBmp.Canvas.TextWidth(GetTabName(AIndex));
      if FShowClose then
      begin
        if FCloseHide then
        begin
          if AIndex = FActiveTab then
            Result := Result + 14;
        end
        else
          Result := Result + 14;
      end;
      if FShowImages then
      begin
        if Assigned(FOnGetImageIdx) and Assigned(FImages) then
        begin
          FOnGetImageIdx(Self, AIndex, n);
          if n <> -1 then
            Result := Result + 16;
        end;
      end;
    end
    else
      Result := FTabWidth;
  end;
end;

procedure TrkSmartTabs.CalcTabWidth;
var
  i, pw, tc, tw, w: Integer;
  bool: Boolean;
begin
  bool := ScrollMode;
  ScrollMode := False;
  tw := Width - (FTabOffset + FTabOverLap);
  if FShowButton then
    tw := tw - (TabButtonWidth + 5);
  FPinnedTabs := 0;
  for i := 0 to Tabs.Count - 1 do
    if TabPinned(i) then
      inc(FPinnedTabs);

  tc := Tabs.Count - FPinnedTabs;
  pw := FTabOffset + (FPinnedTabs * (PinnedWidth - FTabOverLap));
  tw := tw - pw;
  if tc > 0 then
    w := tw div tc
  else
    w := 0;
  if w < MinWidth then
    w := MinWidth;
  if ((w - FTabOverLap) * tc) > tw then
    w := MaxWidth;
  if w > MaxWidth then
    w := MaxWidth;
  FTabWidth := w + FTabOverLap;

  BmPWidth := pw + FTabOverLap;
  if FPinnedTabs = 0 then
    BmPWidth := 0;
  BmTWidth := (Width - BmPWidth) - 64;

  if tc > 0 then
  begin
    if FAutoSize then
    begin
      tw := 0;
      for i := 0 to tc - 1 do
        tw := tw + (TabWidth(i) - FTabOverLap);
      tw := pw + tw + FTabOverLap;
    end
    else
      tw := pw + (tc * w) + FTabOverLap;

    if tw > Width - (TabButtonWidth + 5) then
    begin
      ScrollMode := True;
      FTabWidth := MinWidth + FTabOverLap;
      BmTWidth := (Width - BmPWidth) - 64;

      if FAutoSize then
      begin
        tw := 0;
        for i := 0 to ScrollTabs - 1 do
        begin
          tw := tw + (TabWidth(i) - FTabOverLap);
        end;
        ScrollMax := ((tw + FTabOverLap) + 1) - BmTWidth;
      end
      else
        ScrollMax := (((ScrollTabs * (FTabWidth - FTabOverLap)) + FTabOverLap) - BmTWidth) + 1;

      ScrollView.x := ScrollOff;
      ScrollView.y := ScrollOff + BmTWidth;
      ScrollTabs := Tabs.Count - FPinnedTabs;
    end;
  end;
  BmTabs := Rect(BmPWidth + 20, 0, Width - 44, Height);
  if (not bool) and (ScrollMode) and (FActiveTab > FPinnedTabs) then
    SetInView(FActiveTab - FPinnedTabs, 6);
end;

procedure TrkSmartTabs.Click;
begin
  inherited;
end;

procedure TrkSmartTabs.CMMouseEnter(var Msg: TMessage);
begin
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure TrkSmartTabs.CMMouseLeave(var Msg: TMessage);
begin
  FHotIdx := -1;
  FHotButton := False;
  if not FCloseDown then
    FTabX := -1;
  Invalidate;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

function TrkSmartTabs.ColorToARGB(anAlpha: Byte; aColor: TColor): TGPColor;
var
  i: Integer;
begin
  i := ColorToRGB(aColor);
  Result := MakeColor(anAlpha, Byte(i), Byte(i shr 8), Byte(i shr 16));
end;
function TrkSmartTabs.ARGBColor(a, r, g, b: Byte): TGPColor;
begin
  Result := MakeColor(a, r, g, b);
end;

procedure TrkSmartTabs.SetColors;
var
  bId: TBrushId;
  pId: TPenId;
begin
  // Tabs border
  if not FirstRun then
  begin
    for bId := Low(Brushes) to High(Brushes) do
      Brushes[bId].Free;
    for pId := Low(Pens) to High(Pens) do
      Pens[pId].Free;
  end;
  FirstRun := False;
  // Tabs
  Brushes[biTabInActive] := TGPSolidBrush.Create(ColorToARGB(FLevelTabInActive,
      FColorTabInActive));
  Brushes[biTabHot] := TGPSolidBrush.Create(ColorToARGB(FLevelTabHot, FColorTabHot));
  Brushes[biTabActive] := TGPSolidBrush.Create(ColorToARGB(FLevelTabActive, FColorTabActive));
  Pens[piBrdInActive] := TGPPen.Create(ColorToARGB(255, FColorBrdInActive));
  Pens[piBrdHot] := TGPPen.Create(ColorToARGB(255, FColorBrdHot));
  Pens[piBrdActive] := TGPPen.Create(ColorToARGB(255, FColorBrdActive));
  Pens[piBrdBottom] := TGPPen.Create(ColorToARGB(255, FColorBrdBottom));
  Pens[piBackgnd] := TGPPen.Create(ColorToARGB(255, FColorBackground));
  // Tab close button
  Pens[piCloseBtnGray] := TGPPen.Create(ARGBColor(255, 175, 175, 175));
  Pens[piCloseBtnWhite] := TGPPen.Create(ARGBColor(255, 255, 255, 255));
  Pens[piCloseBtnBlue] := TGPPen.Create(ARGBColor(255, 74, 103, 140));
  Pens[piCloseBtnGray].SetWidth(1.6);
  Pens[piCloseBtnWhite].SetWidth(1.6);
  // Close tab
  Brushes[biCloseBtnRed] := TGPSolidBrush.Create(ARGBColor(255, 192, 52, 52));
  Brushes[biCloseBtnDGrey] := TGPSolidBrush.Create(ARGBColor(255, 52, 52, 52));
  // Mask brush
  Brushes[biMaskWhite] := TGPSolidBrush.Create(ARGBColor(255, 255, 255, 255));
  // Add button
  Brushes[biAddBtnWhite] := TGPSolidBrush.Create(ARGBColor(255, 255, 255, 255));
  Brushes[biAddBtnWhiteBlend] := TGPSolidBrush.Create(ARGBColor(64, 255, 255, 255));
  Brushes[biAddBtnBlack] := TGPSolidBrush.Create(ARGBColor(255, 0, 0, 0));
end;

procedure TrkSmartTabs.SetColTxtActive(const Value: TColor);
begin
  FColorTxtActive := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetColTxtHot(const Value: TColor);
begin
  FColorTxtHot := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetColTxtInActive(const Value: TColor);
begin
  FColorTxtInActive := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetGdiPText(const Value: Boolean);
begin
  FGdiPTExt := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetImageHide(const Value: Boolean);
begin
  FImageHide := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetLevelTabActive(const Value: Byte);
begin
  FLevelTabActive := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetLevelTabHot(const Value: Byte);
begin
  FLevelTabHot := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetLevelTabInActive(const Value: Byte);
begin
  FLevelTabInActive := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetOutActive(const Value: TColor);
begin
  FColorOutActive := Value;
  Invalidate
end;

procedure TrkSmartTabs.SetOutHot(const Value: TColor);
begin
  FColorOutHot := Value;
  Invalidate
end;

procedure TrkSmartTabs.SetOutInActive(const Value: TColor);
begin
  FColorOutInActive := Value;
  Invalidate
end;

procedure TrkSmartTabs.SetOutline(const Value: Boolean);
begin
  FOutline := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetPinnedStr(const Value: String);
begin
  FPinnedStr := Value;
  Invalidate;
end;

procedure TrkSmartTabs.DoPopupClick(Sender: TObject);
var
  i: Integer;
begin
  i := (Sender as TMenuItem).Tag;
  if (i = 95) and (PopUpTab <> -1) then
    PinTab(PopUpTab)
  else if (i = 96) and (PopUpTab <> -1) then
    UnPinTab(PopUpTab)
  else if i = 99 then
  begin
    if Assigned(FOnAddClick) then
      FOnAddClick(Self);
  end
  else
  begin
    ActiveTab := i
  end;
  Invalidate;
end;

procedure TrkSmartTabs.DoScroll(Sender: TObject; ScrollDir: Integer);
var
  y, i, Step: Integer;
begin
  if FDragging then
    Step := (MinWidth div 4)
  else
    Step := (MinWidth div 4);

  if ScrollDir = -1 then
  begin
    if ScrollOff > 0 then
      ScrollOff := ScrollOff - Step;
    if ScrollOff < 0 then
      ScrollOff := 0;
  end
  else
  begin
    if ScrollOff + Step > ScrollMax then
      ScrollOff := ScrollMax
    else
      ScrollOff := ScrollOff + Step;
  end;

  if FDragging then
  begin
    y := Height shr 1;
    if ScrollDir = -1 then
      i := GetTabAtXY(BmPWidth + 21, y)
    else
      i := GetTabAtXY(Width - 45, y);
    if (i <> FDragTab) and (i <> -1) then
    begin
      Tabs.Move(FDragTab, i);
      FActiveTab := i;
      FDragTab := i;
      FHotClose := False;
    end;
  end;

  Invalidate;
end;

procedure TrkSmartTabs.DoTimer(Sender: TObject);
var
  i: Integer;
begin
  i := 0;
  if ScrollLeft then
    i := -1;
  DoScroll(Self, i);
end;

procedure TrkSmartTabs.DoMouseWheel(var Msg: TWMMouseWheel);
begin
  if (not Visible) or (not ScrollMode) then
    Exit;
  if Msg.WheelDelta <> 0 then
  begin
    if Msg.WheelDelta < 0 then
      DoScroll(Self, -1)
    else
      DoScroll(Self, 1);
    Msg.Result := 1;
  end;
end;

procedure TrkSmartTabs.DoPopup(Sender: TObject; APoint: TPoint);
var
  i: Integer;
  AMenuItem: TMenuItem;

  procedure AddMenuItem(Name: string; Idx: Integer);
  begin
    AMenuItem := TMenuItem.Create(FDefPopup);
    AMenuItem.Caption := Name;
    AMenuItem.OnClick := DoPopupClick;
    AMenuItem.Tag := Idx;
    AMenuItem.RadioItem := (Idx <> -1) and (Idx < 95);
    AMenuItem.Checked := Idx = FActiveTab;
    FDefPopup.Items.Add(AMenuItem);
  end;

begin
  if FDefPopup <> nil then
    FreeAndNil(FDefPopup);
  FDefPopup := TPopupMenu.Create(nil);
  AddMenuItem('New tab', 99);
  AddMenuItem('-', -1);
  if PopUpTab <> -1 then
  begin
    if not TabPinned(PopUpTab) then
      AddMenuItem('Pin this tab', 95)
    else if TabPinned(PopUpTab) then
      AddMenuItem('Unpin this tab', 96);
    AddMenuItem('-', -1);
  end;
  for i := 0 to Tabs.Count - 1 do
    AddMenuItem(GetTabName(i), i);
  FDefPopup.Popup(APoint.x, APoint.y);
end;

constructor TrkSmartTabs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InCreate := True;
  if AOwner is TWinControl then
    Parent := TWinControl(AOwner);
  ControlStyle := ControlStyle + [csReplicatable, csFixedHeight, csAcceptsControls,
    csCaptureMouse];
  Width := 150;
  Height := 30;
  FBmp := TBitmap.Create;
  FBmp.PixelFormat := pf32Bit;
  FCanDrag := False;
  FColorBackground := clBtnFace;
  FColorBrdBottom := clGray;
  FColorOutActive := clGray;
  FColorOutHot := clGray;
  FColorOutInActive := clGray;
  FColorTabActive := clWhite;
  FColorTabHot := clWhite;
  FColorTabInActive := clWhite;
  FGdiPText := False;
  FImageHide := False;
  FLevelTabActive := 255;
  FLevelTabHot := 192;
  FLevelTabInActive := 224;
  FOutline := False;
  FirstRun := True;
  SetColors;
  FMinCloseWidth := 100;
  FPinnedStr := '!';
  ScrollMode := False;
  FShowButton := True;
  FShowImages := False;
  FShowClose := True;
  FTabOffset := 0;
  FTabOffsetTop := 4;
  FTabs := TStringList.Create;
  FTabOverLap := 15;
  ActiveTab := 0;
  FHotButton := False;
  FHotIdx := -1;
  FCloseDown := False;
  FTabX := -1;
  InCreate := False;
  ScrollTimer := TTimer.Create(Self);
  ScrollTimer.Enabled := False;
  ScrollTimer.OnTimer := DoTimer;
  ScrollTimer.Interval := 25;
end;

procedure TrkSmartTabs.DeleteTab(AIndex: Integer);
begin
  if (AIndex >= 0) and (AIndex < Tabs.Count) then
  begin
    Tabs.Delete(AIndex);
    if (FActiveTab > Tabs.Count - 1) then
      FActiveTab := Tabs.Count - 1;
    if Assigned(FOnTabChange) then
      FOnTabChange(Self);
    if Tabs.Count = 0 then
      FPinnedTabs := 0;
    if (ScrollMode) and (ActiveTab >= FPinnedTabs) then
    begin
      if ActiveTab = Tabs.Count - 1 then
      begin
        ScrollOff := 0;
        ScrollView := Point(0, BmTWidth);
      end;
      SetInView(FActiveTab - FPinnedTabs, 2)
    end
    else
      Invalidate;
  end;
end;

destructor TrkSmartTabs.Destroy;
var
  bId: TBrushId;
  pId: TPenId;
begin
  for bId := Low(Brushes) to High(Brushes) do
    Brushes[bId].Free;
  for pId := Low(Pens) to High(Pens) do
    Pens[pId].Free;
  FTabs.Free;
  FBmp.Free;
  if FDefPopup <> nil then
    FDefPopup.Free;
  inherited Destroy;
end;

function PtInPoly(const Points: array of TPoint; x, y: Integer): Boolean;
var
  Count, K, j: Integer;
begin
  Result := False;
  Count := Length(Points);
  j := Count - 1;
  for K := 0 to Count - 1 do
  begin
    if ((Points[K].y <= y) and (y < Points[j].y)) or ((Points[j].y <= y) and (y < Points[K].y))
      then
    begin
      if (x < (Points[j].x - Points[K].x) * (y - Points[K].y) / (Points[j].y - Points[K].y)
          + Points[K].x) then
        Result := not Result;
    end;
    j := K;
  end;
end;

function PtInEllipse(const Pt: TPoint; const EBR: TRect): Boolean;
begin
  Result := (Sqr((Pt.x * 2 - EBR.Left - EBR.Right) / (EBR.Right - EBR.Left)) + Sqr
      ((Pt.y * 2 - EBR.Top - EBR.Bottom) / (EBR.Bottom - EBR.Top))) <= 1;
end;

procedure TrkSmartTabs.InsertObj(AIndex: Integer; ATab: string; AObject: TObject);
begin
  if (AIndex >= 0) and (AIndex < Tabs.Count) then
  begin
    if AObject <> nil then
      Tabs.InsertObject(AIndex, ATab, AObject)
    else
      Tabs.Insert(AIndex, ATab);

    CalcTabWidth;
    if TabPinned(AIndex) then
    begin
      if AIndex > FPinnedTabs then
      begin
        Tabs.Move(AIndex, FPinnedTabs);
        AIndex := FPinnedTabs;
      end;
    end
    else
    begin
      if AIndex < FPinnedTabs then
      begin
        Tabs.Move(AIndex, FPinnedTabs);
        AIndex := FPinnedTabs;
      end;
    end;

    FActiveTab := AIndex;

    if (ScrollMode) and (ActiveTab >= FPinnedTabs) then
    begin
      if ActiveTab = Tabs.Count - 1 then
      begin
        ScrollOff := 0;
        ScrollView := Point(0, BmTWidth);
      end;
      SetInView(FActiveTab - FPinnedTabs, 0);
    end
    else
      Invalidate;

    if Assigned(FOnTabChange) then
      FOnTabChange(Self);
  end;
end;

procedure TrkSmartTabs.InsertTab(AIndex: Integer; ATab: string);
begin
  InsertObj(AIndex, ATab, nil);
end;

function TrkSmartTabs.GetTabAtXY(x, y: Integer): Integer;
var
  i, n: Integer;
  InFrontOf, InBackOf: Boolean;
  Tab: TabPoly;
begin
  Result := -1;
  if ScrollMode and (x > BmPWidth) then
  begin
    if (FAutoSize) and (x >= BmPWidth + 20) and (x <= Width - 44) then
    begin
      x := (x + ScrollOff) - (BmPWidth + 20);
      n := 0;
      i := 0;
      repeat
        n := n + TabWidth(i) - FTabOverLap;
        i := i + 1;
      until (n >= x) or (i + FPinnedTabs = Tabs.Count + 1);
      if i > 0 then
        i := i - 1;

      if (i > 0) then
      begin
        Tab := GetTabPolyS(i - 1);
        InFrontOf := PtInPoly(Tab, x, y);
        if InFrontOf and (ActiveTab = i + FPinnedTabs) then
        begin
          Tab := GetTabPolyS(i);
          InFrontOf := not PtInPoly(Tab, x, y);
        end;
      end
      else
        InFrontOf := False;
      if i + FPinnedTabs < Tabs.Count - 1 then
      begin
        Tab := GetTabPolyS(i + 1);
        InBackOf := PtInPoly(Tab, x, y);
      end
      else
        InBackOf := False;
      if InFrontOf then
        i := i - 1;
      if InBackOf then
        i := i + 1;
      Tab := GetTabPolyS(i);
      if not PtInPoly(Tab, x, y) then
        i := -1;
      if (i <> -1) and (i < ScrollTabs) then
        Result := i + FPinnedTabs;
    end
    else if (x >= BmPWidth + 20) and (x <= Width - 44) then
    begin
      x := (x + ScrollOff) - (BmPWidth + 20);
      i := x div (FTabWidth - FTabOverLap);
      if (i > 0) then
      begin
        Tab := GetTabPolyS(i - 1);
        InFrontOf := PtInPoly(Tab, x, y);
        if InFrontOf and (ActiveTab = i + FPinnedTabs) then
        begin
          Tab := GetTabPolyS(i);
          InFrontOf := not PtInPoly(Tab, x, y);
        end;
      end
      else
        InFrontOf := False;
      if i + FPinnedTabs < Tabs.Count - 1 then
      begin
        Tab := GetTabPolyS(i + 1);
        InBackOf := PtInPoly(Tab, x, y);
      end
      else
        InBackOf := False;
      if InFrontOf then
        i := i - 1;
      if InBackOf then
        i := i + 1;
      Tab := GetTabPolyS(i);
      if not PtInPoly(Tab, x, y) then
        i := -1;
      if (i <> -1) and (i < ScrollTabs) then
        Result := i + FPinnedTabs;
    end;
  end
  else
  begin
    n := FTabOffset;
    i := 0;
    while (x > n) and (i < FTabs.Count) do
    begin
      n := n + (TabWidthA(i) - FTabOverLap);
      inc(i);
    end;
    i := i - 1;

    if (i > 0) then
    begin
      if (i = FTabs.Count) then
        InFrontOf := True
      else
      begin
        Tab := GetTabPolyA(i - 1);
        InFrontOf := PtInPoly(Tab, x, y);
        if InFrontOf and (ActiveTab = i) then
        begin
          Tab := GetTabPolyA(i);
          InFrontOf := not PtInPoly(Tab, x, y);
        end;
      end;
    end
    else
      InFrontOf := False;

    if i < Tabs.Count - 1 then
    begin
      Tab := GetTabPolyA(i + 1);
      InBackOf := PtInPoly(Tab, x, y);
    end
    else
      InBackOf := False;
    if InFrontOf then
      i := i - 1;
    if InBackOf then
      i := i + 1;
    Tab := GetTabPolyA(i);
    if not PtInPoly(Tab, x, y) then
      i := -1;

    if (ScrollMode) and (i = FPinnedTabs) then
      i := -1;

    if i <> -1 then
      Result := i;
  end;
end;

function TrkSmartTabs.GetTabName(AIndex: Integer): String;
begin
  Result := '';
  if not((AIndex >= 0) and (AIndex < Tabs.Count)) then
    Exit;
  Result := Tabs[AIndex];
  if TabPinned(AIndex) then
    Delete(Result, 1, Length(FPinnedStr));
end;

function TrkSmartTabs.OverButton(x, y: Integer): Boolean;
var
  x1, y1, x2, y2: Integer;
  Button: array [0 .. 7] of TPoint;
begin
  x1 := ClsBtnX;
  y1 := FTabOffsetTop + 6;
  x2 := x1 + TabButtonWidth;
  y2 := y1 + 15;
  Button[0].x := x1 + 4;
  Button[0].y := y2;
  Button[1].x := x1 + 1;
  Button[1].y := y2 - 2;
  Button[2].x := x1 - 3;
  Button[2].y := y1 + 1;
  Button[3].x := x1 - 2;
  Button[3].y := y1;
  Button[4].x := x2 - 6;
  Button[4].y := y1;
  Button[5].x := x2 - 4;
  Button[5].y := y1 + 2;
  Button[6].x := x2;
  Button[6].y := y2 - 1;
  Button[7].x := x2 - 1;
  Button[7].y := y2;
  Result := PtInPoly(Button, x, y);
end;

function TrkSmartTabs.OverClose(x, y: Integer): Integer;
var
  i, n, m: Integer;
  r: TRect;
  Tab: TabPoly;
begin
  Result := -1;
  i := GetTabAtXY(x, y);
  if TabPinned(i) then
    Exit;
  if FShowClose then
  begin
    if FCloseHide then
    begin
      if (i <> ActiveTab) and ((FTabWidth < FMinCloseWidth) or FAutoSize) then
        Exit;
    end;
  end;
  FTabClose := i;
  if i <> -1 then
  begin
    Tab := GetTabPolyA(i);
    n := Tab[ High(TabPoly)].x - 24;
    m := FTabOffsetTop + ((FTabsHeight) shr 1) + 4;
    r.Left := n - 3;
    r.Top := m - 8;
    r.Right := r.Left + 12;
    r.Bottom := r.Top + 12;
    if PtInRect(r, Point(x, y)) then
      Result := i;
  end;
end;

procedure TrkSmartTabs.SetInView(Idx: Integer; Id: Integer);
var
  t: TabPoly;
begin
  if Idx = -1 then
    Exit;
  t := GetTabPolyS(Idx);
  if t[9].x > ScrollView.y then
    ScrollOff := ScrollOff + (t[9].x - ScrollView.y) + 1
  else if t[0].x < ScrollView.x then
    ScrollOff := t[0].x;
end;

function TrkSmartTabs.GetTabPolyS(Idx: Integer): TabPoly;
var
  i, x1, y1, x2, y2: Integer;
begin
  x1 := 0;
  if Idx > 0 then
    for i := 0 to Idx - 1 do
      x1 := x1 + (TabWidth(i) - FTabOverLap);
  x2 := x1 + TabWidth(Idx);
  y1 := FTabOffsetTop;
  y2 := Height - 1;
  Result := GetTabsPoly(x1, y1, x2, y2);
end;

function TrkSmartTabs.GetTabPolyA(Idx: Integer): TabPoly;
var
  i, x1, y1, x2, y2: Integer;
begin
  x1 := FTabOffset;
  if Idx > 0 then
    for i := 0 to Idx - 1 do
      x1 := x1 + (TabWidthA(i) - FTabOverLap);
  x2 := x1 + TabWidthA(Idx);
  y1 := FTabOffsetTop;
  y2 := Height - 1;
  Result := GetTabsPoly(x1, y1, x2, y2);
end;

procedure TrkSmartTabs.MouseDown(Button: TMouseButton; Shift: TShiftState; x, y: Integer);
var
  i, j, n, m: Integer;
  bool, sl, sr, upd: Boolean;
  Pt: TPoint;
  r: TRect;
  Tab: TabPoly;
begin
  inherited;
  upd := False;
  if CanFocus then
    SetFocus;
  FTabX := -1;
  FCloseDown := False;
  FDragging := False;
  FDragPoint.x := -1;
  FDragPoint.y := -1;

  if (ScrollMode) then
  begin
    if Button = mbLeft then
    begin
      i := GetTabAtXY(x, y);
      if i > -1 then
      begin
        FTabClose := i;
        if FShowClose then
        begin
          if (i = ActiveTab) or (not FCloseHide) then
          begin
            Tab := GetTabPolyS(i - FPinnedTabs);
            n := Tab[ High(TabPoly)].x - 24;
            m := FTabOffsetTop + ((FTabsHeight) shr 1) + 4;
            r.Left := n - 3;
            r.Top := m - 8;
            r.Right := r.Left + 12;
            r.Bottom := r.Top + 12;
            j := (x + ScrollOff) - (BmPWidth + 20);
            if PtInRect(r, Point(j, y)) and (FTabX <> FTabClose) then
              FTabX := i;
          end;
        end;
        if (FTabX = -1) then
        begin
          ActiveTab := i;
          if Assigned(FOnTabChange) then
            FOnTabChange(Self);
          upd := True;
          FDragTab := ActiveTab;
          FDragPoint.x := x;
          FDragPoint.y := y;
        end
        else
        begin
          FCloseDown := True;
          upd := True;
        end;
      end;
      if FShowButton then
      begin
        bool := PtInRect(Rect(Width - 24, Height - 20, Width - 6, Height - 4), Point(x, y));
        if bool <> FButtonDown then
          upd := True;
        FButtonDown := bool;
      end;
      sr := PtInRect(Rect(Width - 44, 0, Width - 24, Height), Point(x, y));
      sl := PtInRect(Rect(BmPWidth, 0, BmPWidth + 20, Height), Point(x, y));
      ScrollLeft := sl;
      ScrollTimer.Enabled := sr or sl;
    end
    else if Button = mbRight then
      if not Assigned(PopupMenu) then
      begin
        GetCursorPos(Pt);
        PopUpTab := GetTabAtXY(x, y);
        DoPopup(Self, Pt);
      end;
  end
  else
  begin
    if Button = mbLeft then
    begin
      FTabX := OverClose(x, y);

      if FTabX <> -1 then
      begin
        if (FCloseHide and (ActiveTab <> FTabX)) then
          FTabX:= -1
        else
          FCloseDown := True;
        upd := True;
      end;

      if (FTabX = -1) then
      begin
        i := GetTabAtXY(x, y);
        if ScrollMode then
          if i = FPinnedTabs then
            i := -1;
        if (i <> -1) then
        begin
          ActiveTab := i;
          if Assigned(FOnTabChange) then
            FOnTabChange(Self);
          upd := True;
          FDragTab := i;
          FDragPoint.x := x;
          FDragPoint.y := y;
        end;
      end;

      if FShowButton then
      begin
        bool := OverButton(x, y);
        if bool <> FButtonDown then
          upd := True;
        FButtonDown := bool;
      end;
    end
    else if Button = mbRight then
      if not Assigned(PopupMenu) then
      begin
        GetCursorPos(Pt);
        PopUpTab := GetTabAtXY(x, y);
        DoPopup(Self, Pt);
      end;
  end;

  if upd = True then
  begin
    CalcTabWidth;
    if ScrollOff > ScrollMax then
      ScrollOff := ScrollMax;
    Invalidate;
  end;
end;

procedure TrkSmartTabs.CMHintShow(var Message: TCMHintShow);
var
  i, t: Integer;
  TabR: TRect;
  Pt: TPoint;
  Tab: TabPoly;
  bool: Boolean;
begin
  Message.Result := 1;

  if FDragging then
  begin
    inherited;
    Exit;
  end;

  bool := False;
  Pt := Message.HintInfo.CursorPos;

  t := FTabWidth;
  if (FShowImages) then
    t := t - (16 + (2 * FTabOverLap))
  else
    t := t - (2 * FTabOverLap);

  i := GetTabAtXY(Pt.x, Pt.y);
  if (i <> -1) then
  begin
    if ScrollMode and (Pt.x > BmPWidth) then
    begin
      if (FBmp.Canvas.TextWidth(GetTabName(i)) > t) then
      begin
        Tab := GetTabPolyS(i - FPinnedTabs);
        TabR.Left := (Tab[ High(TabPoly)].x) - ScrollOff;
        TabR.Left := (TabR.Left - t) + BmPWidth;
        if FActiveTab = i then
          t := t - 8;
        TabR.Right := TabR.Left + t;
        TabR.Top := Tab[4].y;
        TabR.Bottom := Tab[ High(TabPoly)].y;
        if TabR.Left < BmPWidth + 20 then
          TabR.Left := BmPWidth + 20;
        if TabR.Right > Width - 44 then
          TabR.Right := Width - 44;

        if (Pt.x > TabR.Left) and (Pt.x < TabR.Right) then
          bool := True;
      end;
    end
    else
    begin
      if (FBmp.Canvas.TextWidth(Tabs[i]) > t) or (TabPinned(i)) then
      begin
        Tab := GetTabPolyA(i);
        TabR.TopLeft := Point(Tab[0].x, Tab[4].y);
        TabR.BottomRight := Point(Tab[ High(TabPoly)].x, Tab[ High(TabPoly)].y);
        bool := True;
      end;
    end;
  end;
  if bool then
  begin
    Message.HintInfo.HintStr := GetTabName(i);
    Message.HintInfo.CursorRect := TabR;
    Message.HintInfo.HideTimeout := 5000;
    Message.Result := 0;
    Invalidate;
  end
  else
    inherited;
end;

procedure TrkSmartTabs.MouseMove(Shift: TShiftState; x, y: Integer);
var
  i, j, n, m, mx: Integer;
  b, bool, sl, sr: Boolean;
  Tab, t2: TabPoly;
  r: TRect;
begin
  inherited;
  CMP.x := x;
  CMP.y := y;
  mx := x;
  if (ScrollMode) and (x > BmPWidth) then
  begin
    if not FDragging then
    begin
      Hint := '';
      i := GetTabAtXY(x, y);
      if (i > -1) and (i <> FHotIdx) then
      begin
        FHotIdx := i;
        Invalidate;
      end
      else if (i = -1) and (FHotIdx <> -1) then
      begin
        FHotIdx := -1;
        Invalidate;
      end;

      FTabClose := i - FPinnedTabs;
      Tab := GetTabPolyS(i - FPinnedTabs);
      n := Tab[ High(TabPoly)].x - 24;
      m := FTabOffsetTop + ((FTabsHeight) shr 1) + 4;
      r.Left := n - 3;
      r.Top := m - 8;
      r.Right := r.Left + 12;
      r.Bottom := r.Top + 12;
      j := (x + ScrollOff) - (BmPWidth + 20);
      n := -1;
      if PtInRect(r, Point(j, y)) { and (FTabX <> FTabClose) } then
        n := i;

      if not FCloseDown then
      begin
        j := FTabX;
        FTabX := n;
        if FTabX <> j then
          Invalidate;
      end;
      b := FHotClose;
      FHotClose := (FTabX = n);
      if b <> FHotClose then
        Invalidate;

      if FShowButton then
      begin
        b := FHotButton;
        bool := PtInRect(Rect(Width - 24, Height - 20, Width - 6, Height - 4), Point(x, y));
        if bool <> FHotButton then
          FHotButton := bool;
        if b <> FHotButton then
          Invalidate;
      end;

      if (ssLeft in Shift) then
      begin
        if (FCanDrag) then
        begin
          if (FDragPoint.x <> -1) and (FDragPoint.y <> -1) then
          begin
            i := Trunc(SQRT(Sqr(x - FDragPoint.x) + Sqr(y - FDragPoint.y)));
            if (i < 10) then
            begin
              FDragging := True;
              FDragPoint.x := -1;
              FDragPoint.y := -1;
              FDragTab := FActiveTab;
              FDragX := -1972;
              FDragOff := (ScrollOff + (CMP.x - (BmPWidth + 20))) - Tab[0].x;
            end;
          end;
        end;
      end;
    end
    else if (FDragging) and (FDragTab >= FPinnedTabs) then
    begin
      y := Height shr 1;

      i := GetTabAtXY(FDragX + (TabWidthA(FDragTab) shr 1), y);
      if i < FPinnedTabs then
        i := -1;

      if FAutoSize then
      begin
        if FDragLeft then
        begin
          i := GetTabAtXY(FDragX, y);
          if i < FPinnedTabs then
            i := -1;
          if (i <> -1) and (i <> FDragTab) then
          begin
            t2 := GetTabPolyS(i - FPinnedTabs);
            n := (ScrollOff + FDragX) - (BmPWidth + 28);
            m := t2[0].x + FTabOverLap;
            if n > m then
              i := -1;
          end;
        end
        else
        begin
          i := GetTabAtXY(FDragX + TabWidthA(FDragTab), y);
          if i < FPinnedTabs then
            i := -1;
          if (i <> -1) and (i <> FDragTab) then
          begin
            t2 := GetTabPolyS(i - FPinnedTabs);
            n := ((ScrollOff + FDragX) - (BmPWidth + 28)) + TabWidthA(FDragTab);
            m := t2[9].x - FTabOverLap;
            if n < m then
              i := -1;
          end;
        end;
      end;

      if (i <> FDragTab) and (i <> -1) then
      begin
        Tabs.Move(FDragTab, i);
        FActiveTab := i;
        FDragTab := i;
        FHotClose := False;
      end;
      FDragLeft := (x - FDragOff) < FDragX;
      FDragX := x - FDragOff;
      Invalidate;
    end;
  end
  else
  begin
    if not FDragging then
    begin
      Hint := '';
      i := GetTabAtXY(x, y);
      if ScrollMode then
        if i = FPinnedTabs then
          i := -1;
      if (i <> FHotIdx) then
      begin
        if ScrollMode then
          if i > FPinnedTabs then
            i := -1;
        FHotIdx := i;
        Invalidate;
      end;
      i := OverClose(x, y);
      if not FCloseDown then
      begin
        j := FTabX;
        FTabX := i;
        if FTabX <> j then
          Invalidate;
      end;
      b := FHotClose;
      FHotClose := (FTabX = i);
      if b <> FHotClose then
        Invalidate;

      if FShowButton then
      begin
        b := FHotButton;
        bool := OverButton(x, y);
        if bool <> FHotButton then
          FHotButton := bool;
        if b <> FHotButton then
          Invalidate;
      end;
      if (ssLeft in Shift) and (not FDragging) then
      begin
        if (FCanDrag) then
        begin
          if (FDragPoint.x <> -1) and (FDragPoint.y <> -1) then
          begin
            i := Trunc(SQRT(Sqr(x - FDragPoint.x) + Sqr(y - FDragPoint.y)));
            if (i < 10) then
            begin
              FDragging := True;
              FDragPoint.x := -1;
              FDragPoint.y := -1;
              if FActiveTab < FPinnedTabs then
                FDragOff := x - (FTabOffset + ((PinnedWidth - FTabOverLap) * FActiveTab))
              else
              begin
                n := FTabOffset;
                for i := 0 to FActiveTab - 1 do
                  n := n + (TabWidthA(i) - FTabOverLap);
                FDragOff := x - n;
              end;
            end;
          end;
        end;
      end;
    end;
    if FDragging then
    begin
      y := ClientHeight shr 1;

      i := GetTabAtXY(FDragX + (TabWidthA(FDragTab) shr 1), y);

      if i > FPinnedTabs - 1 then
      begin
        if FAutoSize then
        begin
          if FDragLeft then
          begin
            i := GetTabAtXY(FDragX, y);
            if i < FPinnedTabs then
              i := -1;
            if (i <> -1) and (i <> FDragTab) then
            begin
              t2 := GetTabPolyA(i);
              m := t2[0].x + FTabOverLap;
              if FDragX > m then
                i := -1;
            end;
          end
          else
          begin
            i := GetTabAtXY(FDragX + TabWidthA(FDragTab), y);
            if i < FPinnedTabs then
              i := -1;
            if (i <> -1) and (i <> FDragTab) then
            begin
              t2 := GetTabPolyA(i);
              m := t2[9].x - FTabOverLap;
              if FDragX + TabWidthA(FDragTab) < m then
                i := -1;
            end;
          end;
        end;
      end
      else
        i := GetTabAtXY(x, y);

      if (i <> FDragTab) and (i <> -1) then
      begin
        if ((TabPinned(FDragTab)) and TabPinned(i)) or
          ((not TabPinned(FDragTab)) and not TabPinned(i)) then
        begin
          Tabs.Move(FDragTab, i);
          FActiveTab := i;
          FDragTab := i;
        end;
        FHotClose := False;
      end;
      x := x - FDragOff;
      if x < FTabOffset then
        x := FTabOffset;
      i := TabWidthA(FDragTab);
      if ScrollMode then
      begin
        if x > BmPWidth - i then
          x := BmPWidth - i;
      end
      else if x > Width - i then
        x := Width - i;
      FDragLeft := x < FDragX;
      FDragX := x;
      Invalidate;
    end;
  end;

  if (ScrollMode) and (ssLeft in Shift) then
  begin
    sr := PtInRect(Rect(Width - 44, 0, Width - 24, Height), Point(mx, y));
    sl := PtInRect(Rect(BmPWidth, 0, BmPWidth + 20, Height), Point(mx, y));
    ScrollLeft := sl;
    if (FDragging and (FDragTab >= FPinnedTabs)) or (not FDragging) then
      ScrollTimer.Enabled := sr or sl;
  end;
end;

procedure TrkSmartTabs.MouseUp(Button: TMouseButton; Shift: TShiftState; x, y: Integer);
var
  CloseTab: Boolean;
  i, j, n, m: Integer;
  Tab: TabPoly;
  r: TRect;
  ABut: Boolean;
begin
  inherited;

  ScrollTimer.Enabled := False;

  if FDragging then
  begin
    FDragging := False;
    FDragOff := 0;
    if ScrollMode then
      ActiveTab := ActiveTab
    else
      Invalidate;
  end;

  if ScrollMode then
    ABut := PtInRect(Rect(Width - 24, Height - 20, Width - 6, Height - 4), Point(x, y))
  else
    ABut := OverButton(x, y);

  if (FShowButton) and (ABut and FButtonDown) then
  begin
    if Assigned(FOnAddClick) then
      FOnAddClick(Self);
    Invalidate;
  end;

  if ScrollMode then
  begin
    i := GetTabAtXY(x, y);
    Tab := GetTabPolyS(i - FPinnedTabs);
    n := Tab[ High(TabPoly)].x - 24;
    m := FTabOffsetTop + ((FTabsHeight) shr 1) + 4;
    r.Left := n - 3;
    r.Top := m - 8;
    r.Right := r.Left + 12;
    r.Bottom := r.Top + 12;
    j := (x + ScrollOff) - (BmPWidth + 20);
    if PtInRect(r, Point(j, y)) then
      n := i;
    ABut := n = FTabX;
  end
  else
    ABut := OverClose(x, y) = FTabX;

  if FShowClose then
  begin
    if (ABut) and (FCloseDown) then
    begin
      if Assigned(FOnCloseTab) then
      begin
        FOnCloseTab(Self, FTabX, CloseTab);
        if CloseTab then
          DeleteTab(FTabX);
      end;
      Invalidate;
    end;
  end;

  FButtonDown := False;
  FHotButton := False;
  FCloseDown := False;
  FHotClose := False;
  FTabX := -1;
end;

procedure DrawParentImage(Control: TControl; Dest: TCanvas);
var
  SaveIndex: Integer;
  DC: HDC;
  Position: TPoint;
begin
  with Control do
  begin
    if Parent = nil then
      Exit;
    DC := Dest.Handle;
    SaveIndex := SaveDC(DC);
{$IFDEF DFS_COMPILER_2}
    GetViewportOrgEx(DC, @Position);
{$ELSE}
    GetViewportOrgEx(DC, Position);
{$ENDIF}
    SetViewportOrgEx(DC, Position.x - Left, Position.y - Top, nil);
    IntersectClipRect(DC, 0, 0, Parent.ClientWidth, Parent.ClientHeight);
    Parent.Perform(WM_ERASEBKGND,WParam(DC),0);
    Parent.Perform(WM_PAINT,WParam(DC),0);
    RestoreDC(DC, SaveIndex);
  end;
end;

procedure TrkSmartTabs.PaintScrollingTabs(TabsCanvas: TGPGraphics; Back, Mask: TBitmap);
var
  x, c1, i, n, m, x1, x2, x3, y1, y2, bx, by, ts, ax, tw, bo: Integer;
  txt: string;
  TabsR, TabR, R2: TRect;
  Tab: TabPoly;
  TabAdd: array [0 .. 12] of TPoint;
  Arrow : array [0..7] of TGPPoint;
  DownColor: array [0 .. 1] of GDIPAPI.ARGB;
  TabsTxtBrush: TGPSolidBrush;
  TxtRect: TGPRectF;
  TxtFormat: TGPStringFormat;
  brushButtonDown: TGPPathGradientBrush;
  baGB: TGPLinearGradientBrush;
  baGP: TGPPen;
  p1, p2: TGPPoint;
  bImages, bClose, Pinned: Boolean;
  slSize, slPtr: Integer;
  w, h: Integer;
  Row: PRGBAArray;
  slSize2, slPtr2: Integer;
  Row2: PRGBAArray;
  slSize3, slPtr3: Integer;
  Row3: PRGBAArray;
  a: Byte;
  ScrollBmp: TBitmap;
  ScrollCanvas: TGPGraphics;
  State: TabState;
  c2: Longint;
  r, g, b, v1, v2: Byte;
  p, t1, t2, tn: Integer;
  w3: Integer;
  pId : TPenId;
  bId : TBrushId;
begin
  TabsR := ClientRect;
  TabsCanvas := TGPGraphics.Create(FBmp.Canvas.Handle);
  TabsCanvas.SetSmoothingMode(SmoothingModeHighQuality);

  Pinned := TabPinned(FTabs.Count - 1);
  ts := ((PinnedWidth - FTabOverLap) * FPinnedTabs);
  ts := ts + ((FTabWidth - FTabOverLap) * (FTabs.Count - FPinnedTabs));

  if Pinned then
  begin
    ts := ts - (PinnedWidth - FTabOverLap);
    x1 := FTabOffset + ts;
    bx := (x1 + PinnedWidth);
  end
  else
  begin
    ts := ts - (FTabWidth - FTabOverLap);
    x1 := FTabOffset + ts;
    bx := (x1 + FTabWidth);
  end;
  ClsBtnX := bx;
  y1 := FTabOffsetTop;
  y2 := ClientHeight - 1;
  by := y1 + 4;

  if FCloseHide then
    bClose := FShowClose and (FTabWidth > FMinCloseWidth)
  else
    bClose := FShowClose;

  if ScrollMode then
  begin
    p := 0;
    if FPinnedTabs > 0 then
    begin
      x1 := BmPWidth - PinnedWidth;
      x2 := x1 + PinnedWidth;
      bx := (x1 + PinnedWidth);
      ax := -1;
      for i := FPinnedTabs - 1 downto 0 do
      begin
        if i <> FActiveTab then
        begin
          bImages := Assigned(FOnGetImageIdx) and Assigned(FImages);
          Tab := GetTabsPoly(x1, y1, x2, y2);
          State := stNormal;
          if i = FHotIdx then
            State := stHot;
          if i = FHotIdx then
          begin
            pId := piBrdHot;
            bId := biTabHot;
          end
          else
          begin
            pId := piBrdInActive;
            bId := biTabInActive;
          end;

          TabsCanvas.FillPolygon(Brushes[bId], PGPPoint(@Tab), PolyTabCount);
          TabsCanvas.DrawPolygon(Pens[pId], PGPPoint(@Tab), PolyTabCount);

          // use mask image to restore overlaping tab area
          if (i > 0) and (i <> FActiveTab + 1) and (not FSeeThruTabs) then
          begin
            slPtr := Integer(FBmp.ScanLine[y1]);
            slSize := Integer(FBmp.ScanLine[y1 + 1]) - slPtr;
            slPtr2 := Integer(Mask.ScanLine[y1]);
            slSize2 := Integer(Mask.ScanLine[y1 + 1]) - slPtr2;
            slPtr3 := Integer(Back.ScanLine[y1]);
            slSize3 := Integer(Back.ScanLine[y1 + 1]) - slPtr3;
            for h := y1 to y2 - 1 do
            begin
              Row := PRGBAArray(slPtr);
              Row2 := PRGBAArray(slPtr2);
              Row3 := PRGBAArray(slPtr3);
              for w := 0 to FTabOverLap - 1 do
                if Row2[w + (Mask.Width - FTabOverLap)].a <> 0 then
                begin
                  Row[w + x1].r := Row3[w + x1].r;
                  Row[w + x1].g := Row3[w + x1].g;
                  Row[w + x1].b := Row3[w + x1].b;
                  Row[w + x1].a := Row3[w + x1].a;
                end;
              slPtr := slPtr + slSize;
              slPtr2 := slPtr2 + slSize2;
              slPtr3 := slPtr3 + slSize3;
            end;
          end;
          // overlaping tab area restored

          TabR.TopLeft := Point(x1 + TabOffVal, y1);
          TabR.BottomRight := Point(x2 - TabOffVal, y2);
          if bImages then
          begin
            FOnGetImageIdx(Self, i, n);
            if n <> -1 then
            begin
              m := ((ClientHeight - FTabOffsetTop) div 2) - 8;
              w := ((TabR.Right - TabR.Left) - FImages.Width) div 2;
              if n > -1 then
                FImages.Draw(FBmp.Canvas, TabR.Left + w, FTabOffsetTop + m, n);
              TabR.Left := TabR.Left + 16;
            end;
          end;
          if Assigned(FOnCustomDraw) then
            FOnCustomDraw(Self, FBmp.Canvas, Rect(x1, y1, x2, y2), txt, State, i);
        end
        else
          ax := x1;
        w := PinnedWidth;
        x1 := x1 - (w - FTabOverLap);
        x2 := x1 + w;
      end;

      if ax <> -1 then
      begin
        txt := FTabs[FActiveTab];
        bImages := Assigned(FOnGetImageIdx) and Assigned(FImages);
        tw := PinnedWidth;
        bClose := False;
        x1 := ax;
        if FDragging then
          x1 := FDragX;
        x2 := x1 + tw;

        if (not FDragging) and (not FSeeThruTabs) then
        begin
          slPtr := Integer(FBmp.ScanLine[y1]);
          slSize := Integer(FBmp.ScanLine[y1 + 1]) - slPtr;
          slPtr2 := Integer(Mask.ScanLine[y1]);
          slSize2 := Integer(Mask.ScanLine[y1 + 1]) - slPtr2;
          slPtr3 := Integer(Back.ScanLine[y1]);
          slSize3 := Integer(Back.ScanLine[y1 + 1]) - slPtr3;
          x3 := x2 - FTabOverLap;
          for h := y1 to y2 - 1 do
          begin
            Row := PRGBAArray(slPtr);
            Row2 := PRGBAArray(slPtr2);
            Row3 := PRGBAArray(slPtr3);
            for w := 0 to FTabOverLap - 1 do
              if Row2[w + (Mask.Width - FTabOverLap)].a <> 0 then
              begin
                Row[w + x3].r := Row3[w + x3].r;
                Row[w + x3].g := Row3[w + x3].g;
                Row[w + x3].b := Row3[w + x3].b;
                Row[w + x3].a := Row3[w + x3].a;
                Row[x1 + FTabOverLap - w].r := Row3[x1 + FTabOverLap - w].r;
                Row[x1 + FTabOverLap - w].g := Row3[x1 + FTabOverLap - w].g;
                Row[x1 + FTabOverLap - w].b := Row3[x1 + FTabOverLap - w].b;
                Row[x1 + FTabOverLap - w].a := Row3[x1 + FTabOverLap - w].a;
              end;
            slPtr := slPtr + slSize;
            slPtr2 := slPtr2 + slSize2;
            slPtr3 := slPtr3 + slSize3;
          end;
        end;

        Tab := GetTabsPoly(x1, y1, x2, y2);
        TabsCanvas.FillPolygon(Brushes[biTabActive],PGPPoint(@Tab), PolyTabCount);
        TabsCanvas.DrawPolygon(Pens[piBrdActive],PGPPoint(@Tab), PolyTabCount);
        TabsCanvas.DrawLine(Pens[piBrdBottom], 0, y2, ClientWidth, y2);
        TabsCanvas.DrawLine(Pens[piBackgnd], x1 + 1, y2, x2 - 1, y2);

        TabR.TopLeft := Point(x1 + FTabOverLap, y1);
        TabR.BottomRight := Point((x2) - FTabOverLap, y2);
        if bImages then
        begin
          FOnGetImageIdx(Self, FActiveTab, n);
          m := ((ClientHeight - FTabOffsetTop) div 2) - 8;
          w := ((TabR.Right - TabR.Left) - FImages.Width) div 2;
          if n > -1 then
            FImages.Draw(FBmp.Canvas, TabR.Left + w, FTabOffsetTop + m, n);
          TabR.Left := TabR.Left + 16;
        end;
        if Assigned(FOnCustomDraw) then
          FOnCustomDraw(Self, FBmp.Canvas, Rect(x1, y1, x2, y2), txt, stSelected, FActiveTab);
      end
      else TabsCanvas.DrawLine(Pens[piBrdBottom],0, y2, Width, y2);
    end;

    if FPinnedTabs = 0 then TabsCanvas.DrawLine(Pens[piBrdBottom], 0, y2, Width, y2);

    p := p + BmPWidth;

    p1.x := 0;
    p1.y := 0;
    p2.x := 0;
    p2.y := 8;
    baGB := TGPLinearGradientBrush.Create(p1, p2, MakeColor(88, 48, 48, 48),
      MakeColor(94, 0, 0, 0));
    baGP := TGPPen.Create(baGB);
    baGP.SetWidth(0.5);
    x1 := p + 12;
    y1 := Height - 7;
    Arrow[0].x := x1;
    Arrow[0].y := y1;
    Arrow[1].x := x1 - 6;
    Arrow[1].y := y1 - 6;
    Arrow[2].x := x1 - 6;
    Arrow[2].y := y1 - 7;
    Arrow[3].x := x1;
    Arrow[3].y := y1 - 13;
    Arrow[4].x := x1 + 2;
    Arrow[4].y := y1 - 11;
    Arrow[5].x := x1 - 2;
    Arrow[5].y := y1 - 7;
    Arrow[6].x := x1 - 2;
    Arrow[6].y := y1 - 6;
    Arrow[7].x := x1 + 2;
    Arrow[7].y := y1 - 2;

    if ScrollOff = 0 then
      TabsCanvas.FillPolygon(Brushes[biTabInActive],PGPPoint(@Arrow),8)
    else
      TabsCanvas.FillPolygon(Brushes[biTabActive],PGPPoint(@Arrow),8);
    TabsCanvas.DrawPolygon(baGP,PGPPoint(@Arrow),8);

    p := p + 20;

    // t1 = FirstTab t2 = LastTab we gone render

    t1 := 0;
    i := 0;
    while (ScrollOff - FTabOverLap) > i do
    begin
      i := i + (TabWidth(t1) - FTabOverLap);
      inc(t1);
    end;

    if t1 > 0 then
      t1 := t1 - 1;
    if t1 < 0 then
      t1 := 0;

    t2 := t1;
    i := 0;
    bo := ScrollView.y - ScrollView.x;
    while (((bo + TabWidth(t1)) - FTabOverLap) > i) and (t2 < ScrollTabs) do
    begin
      i := i + (TabWidth(t2) - FTabOverLap);
      inc(t2);
    end;

    if t2 > ScrollTabs - 1 then
      t2 := ScrollTabs - 1;

    ScrollBmp := TBitmap.Create;
    ScrollBmp.PixelFormat := pf32Bit;

    bo := 0;
    for i := t2 downto t1 do
      bo := bo + (TabWidth(i) - FTabOverLap);

    ScrollBmp.Width := bo + FTabOverLap + 1;
    ScrollBmp.Height := Height;
    ScrollCanvas := TGPGraphics.Create(ScrollBmp.Canvas.Handle);
    ScrollCanvas.SetSmoothingMode(SmoothingModeHighQuality);
    ScrollBmp.Canvas.Brush.Style := bsClear;
    ScrollBmp.Canvas.Font.Assign(Font);

    bo := 0;
    for i := 0 to t1 - 1 do
      bo := bo + (TabWidth(i) - FTabOverLap);
    i := ScrollOff - bo;
    bo := BmTabs.Left - i;

    if FTransparent then
      ScrollBmp.Canvas.CopyRect(Rect(i, 0, BmTWidth + i, Height), Back.Canvas,
        Rect(BmTabs.Left, 0, BmTWidth + BmTabs.Left, Height))
    else
    begin
      // Clear canvas
      slPtr := Integer(ScrollBmp.ScanLine[0]);
      slSize := Integer(ScrollBmp.ScanLine[1]) - slPtr;
      for h := 0 to ScrollBmp.Height - 1 do
      begin
        Row := PRGBAArray(slPtr);
        for w := 0 to ScrollBmp.Width - 1 do
        begin
          Row[w].r := Byte(ColorToRGB(FColorBackground));
          Row[w].g := Byte(ColorToRGB(FColorBackground) shr 8);
          Row[w].b := Byte(ColorToRGB(FColorBackground) shr 16);
          Row[w].a := 0;
        end;
        slPtr := slPtr + slSize;
      end;
      // canvas cleared
    end;

    y1 := FTabOffsetTop;
    y2 := Height - 1;
    by := y1 + 4;
    w3 := TabWidth(t2); // w3 = TabSize
    x1 := (ScrollBmp.Width - w3) - 1;
    x2 := x1 + w3;
    bx := x1 + w3;
    ClsBtnX := bx;
    bClose := False;
    ax := -1;
    for i := t2 downto t1 do
    begin
      if (i + FPinnedTabs) <> FActiveTab then
      begin
        txt := FTabs[i + FPinnedTabs];
        bImages := (FShowImages) and Assigned(FOnGetImageIdx) and Assigned(FImages) and
          ((FTabWidth > 80) or not FImageHide);
        Tab := GetTabsPoly(x1, y1, x2, y2);

        State := stNormal;
        if i + FPinnedTabs = FHotIdx then // Readability fix
        begin
          State := stHot;
          pId := piBrdHot;
          bId := biTabHot;
        end
        else
        begin
          pId := piBrdInActive;
          bId := biTabInActive;
        end;

        ScrollCanvas.FillPolygon(Brushes[bId], PGPPoint(@Tab), PolyTabCount);
        ScrollCanvas.DrawPolygon(Pens[pId], PGPPoint(@Tab), PolyTabCount);

        // use mask image to restore overlaping tab area
        if (i > 0) and ((i + FPinnedTabs) <> FActiveTab + 1) and (not FSeeThruTabs) then
        begin
          slPtr := Integer(ScrollBmp.ScanLine[y1]);
          slSize := Integer(ScrollBmp.ScanLine[y1 + 1]) - slPtr;
          slPtr2 := Integer(Mask.ScanLine[y1]);
          slSize2 := Integer(Mask.ScanLine[y1 + 1]) - slPtr2;
          slPtr3 := Integer(Back.ScanLine[y1]);
          slSize3 := Integer(Back.ScanLine[y1 + 1]) - slPtr3;
          for h := y1 to y2 - 1 do
          begin
            Row := PRGBAArray(slPtr);
            Row2 := PRGBAArray(slPtr2);
            Row3 := PRGBAArray(slPtr3);
            for w := 0 to FTabOverLap - 2 do
              if Row2[w + (Mask.Width - FTabOverLap)].a <> 0 then
              begin    //rmk
                if bo < 0 then
                  bo:= 0;
                Row[w + x1] := Row3[w + x1 + bo];
              end;
            slPtr := slPtr + slSize;
            slPtr2 := slPtr2 + slSize2;
            slPtr3 := slPtr3 + slSize3;
          end;
        end;
        // overlaping tab area restored

        TabR.TopLeft := Point(x1 + TabOffVal, y1);
        TabR.BottomRight := Point(x2 - TabOffVal, y2);
        if bImages then
        begin
          FOnGetImageIdx(Self, i + FPinnedTabs, n);
          if n <> -1 then
          begin
            m := ((ClientHeight - FTabOffsetTop) div 2) - 8;
            if n > -1 then
              FImages.Draw(ScrollBmp.Canvas, TabR.Left + 1, FTabOffsetTop + m, n);
            TabR.Left := TabR.Left + 22;
          end;
        end;
        if (FShowClose) and not(FCloseHide) then
        begin
          n := x2 - 24;
          m := FTabOffsetTop + (FTabsHeight shr 1) + 4;
          if (FTabX = i + FPinnedTabs) and FHotClose then
          begin
            if FCloseDown then
              ScrollCanvas.FillEllipse(Brushes[biCloseBtnDGrey], n - 3, m - 9, 12, 12)
            else
              ScrollCanvas.FillEllipse(Brushes[biCloseBtnRed], n - 3, m - 9, 12, 12);
            ScrollCanvas.DrawLine(Pens[piCloseBtnWhite], n, m, n + 6, m - 6);
            ScrollCanvas.DrawLine(Pens[piCloseBtnWhite], n + 6, m, n, m - 6);
          end
          else
          begin
            ScrollCanvas.DrawLine(Pens[piCloseBtnGray], n, m, n + 6, m - 6);
            ScrollCanvas.DrawLine(Pens[piCloseBtnGray], n + 6, m, n, m - 6);
          end;
          TabR.Right := TabR.Right - 6;
        end;
        if FGdiPTExt then
        begin
          if i + FPinnedTabs = FHotIdx then
            w := ColorToRGB(FColorTxtHot)
          else
            w := ColorToRGB(FColorTxtInActive);
          TabsTxtBrush := TGPSolidBrush.Create(MakeColor(255, Byte(w), Byte(w shr 8),
              Byte(w shr 16)));
          TxtRect.x := TabR.Left;
          TxtRect.y := TabR.Top;
          TxtRect.Width := TabR.Right - TabR.Left;
          TxtRect.Height := TabR.Bottom - 4;
          TxtFormat := TGPStringFormat.Create();
          TxtFormat.SetLineAlignment(StringAlignmentCenter);
          TxtFormat.SetFormatFlags(StringFormatFlagsNoWrap);
          ScrollCanvas.DrawString(PChar(txt), Length(txt), FTabsFont, TxtRect, TxtFormat,
            TabsTxtBrush);
          TxtFormat.Free;
          TabsTxtBrush.Free;
        end
        else
        begin
          FBmp.Canvas.Brush.Style := bsClear;
          if FOutline then
          begin
            if i + FPinnedTabs = FHotIdx then
              ScrollBmp.Canvas.Font.Color := FColorOutHot
            else
              ScrollBmp.Canvas.Font.Color := FColorOutInActive;
            R2 := TabR;
            R2.Left := R2.Left - 1;
            R2.Right := R2.Right - 1;
            DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
              DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
            R2 := TabR;
            R2.Left := R2.Left + 1;
            R2.Right := R2.Right + 1;
            DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
              DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
            R2 := TabR;
            R2.Top := R2.Top + 1;
            R2.Bottom := R2.Bottom + 1;
            DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
              DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
            R2 := TabR;
            R2.Top := R2.Top - 1;
            R2.Bottom := R2.Bottom - 1;
            DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
              DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
          end;
          if i + FPinnedTabs = FHotIdx then
            ScrollBmp.Canvas.Font.Color := FColorTxtHot
          else
            ScrollBmp.Canvas.Font.Color := FColorTxtInActive;
          DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), TabR,
            DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
        end;

        if (ScrollBmp.Canvas.TextWidth(txt) > (TabR.Right - TabR.Left)) and (not(FAutoSize))
          then
        begin
          // Fade out text at right side ...
          slPtr := Integer(ScrollBmp.ScanLine[y1 + 1]);
          slSize := Integer(ScrollBmp.ScanLine[y1 + 2]) - slPtr;
          slPtr2 := Integer(Back.ScanLine[y1 + 1]);
          slSize2 := Integer(Back.ScanLine[y1 + 2]) - slPtr2;
          if i + FPinnedTabs = FHotIdx then
          begin
            a := FLevelTabHot;
            c1 := ColorToRGB(FColorTabHot)
          end
          else
          begin
            a := FLevelTabInActive;
            c1 := ColorToRGB(FColorTabInActive);
          end;
          r := Byte(c1);
          g := Byte(c1 shr 8);
          b := Byte(c1 shr 16);
          x := TabR.Right - TextFadeOut;
          for h := y1 + 1 to y2 - 1 do
          begin
            Row := PRGBAArray(slPtr);
            Row2 := PRGBAArray(slPtr2);
            c1 := 255;
            for w := x to x + TextFadeOut do
            begin
              v2 := Byte(Row2[w + bo].r);
              v2 := Byte(a * (r - v2) shr 8 + v2);
              Row[w].r := Byte(c1 * (Row[w].r - v2) shr 8 + v2);
              v2 := Byte(Row2[w + bo].g);
              v2 := Byte(a * (g - v2) shr 8 + v2);
              Row[w].g := Byte(c1 * (Row[w].g - v2) shr 8 + v2);
              v2 := Byte(Row2[w + bo].b);
              v2 := Byte(a * (b - v2) shr 8 + v2);
              Row[w].b := Byte(c1 * (Row[w].b - v2) shr 8 + v2);
              c1 := c1 - 15;
            end;
            slPtr := slPtr + slSize;
            slPtr2 := slPtr2 + slSize2;
          end;
        end;
        // Fade done...

        if Assigned(FOnCustomDraw) then
          FOnCustomDraw(Self, ScrollBmp.Canvas, Rect(x1, y1, x2, y2), txt, State,
            i + FPinnedTabs);
      end
      else
        ax := x1;

      w := TabWidth(i - 1);
      x1 := x1 - (w - FTabOverLap);
      x2 := x1 + w;
    end;

    // Paint active tab if neded...
    if ax > -1 then
    begin
      txt := FTabs[FActiveTab];
      bImages := (FShowImages) and Assigned(FOnGetImageIdx) and Assigned(FImages) and
        ((FTabWidth > 80) or not FImageHide);
      tw := TabWidthA(FActiveTab);
      bClose := FShowClose;
      x1 := ax;
      if (FDragging) and (FDragX <> -1972) then
      begin
        x1 := FDragX - bo;
        if x1 < 0 then
          x1 := 0
        else if x1 + tw > ScrollBmp.Width - 1 then
          x1 := ScrollBmp.Width - (tw + 1);
      end;
      x2 := x1 + tw;

      // use mask image to restore overlaping tab area
      if (not FDragging) and (not FSeeThruTabs) then
      begin
        slPtr := Integer(ScrollBmp.ScanLine[y1]);
        slSize := Integer(ScrollBmp.ScanLine[y1 + 1]) - slPtr;
        slPtr2 := Integer(Mask.ScanLine[y1]);
        slSize2 := Integer(Mask.ScanLine[y1 + 1]) - slPtr2;
        slPtr3 := Integer(Back.ScanLine[y1]);
        slSize3 := Integer(Back.ScanLine[y1 + 1]) - slPtr3;
        x3 := x2 - FTabOverLap;
        for h := y1 to y2 - 1 do
        begin
          Row := PRGBAArray(slPtr);
          Row2 := PRGBAArray(slPtr2);
          Row3 := PRGBAArray(slPtr3);
          for w := 0 to FTabOverLap - 1 do
            if Row2[w + (Mask.Width - FTabOverLap)].a <> 0 then
            begin
              Row[w + x3].r := Row3[w + x3 + bo].r;
              Row[w + x3].g := Row3[w + x3 + bo].g;
              Row[w + x3].b := Row3[w + x3 + bo].b;
              Row[w + x3].a := Row3[w + x3 + bo].a;
              Row[x1 + FTabOverLap - w].r := Row3[x1 + bo + FTabOverLap - w].r;
              Row[x1 + FTabOverLap - w].g := Row3[x1 + bo + FTabOverLap - w].g;
              Row[x1 + FTabOverLap - w].b := Row3[x1 + bo + FTabOverLap - w].b;
              Row[x1 + FTabOverLap - w].a := Row3[x1 + bo + FTabOverLap - w].a;
            end;
          slPtr := slPtr + slSize;
          slPtr2 := slPtr2 + slSize2;
          slPtr3 := slPtr3 + slSize3;
        end;
      end;
      // overlaping tab area restored

      txt := FTabs[FActiveTab];
      Tab := GetTabsPoly(x1, y1, x2, y2);
      ScrollCanvas.FillPolygon(Brushes[biTabActive], PGPPoint(@Tab), PolyTabCount);
      ScrollCanvas.DrawPolygon(Pens[piBrdActive], PGPPoint(@Tab), PolyTabCount);

      ScrollCanvas.DrawLine(Pens[piBrdBottom], 0, y2, ScrollBmp.Width, y2);
      ScrollCanvas.DrawLine(Pens[piBackgnd], x1 + 1, y2, x2 - 1, y2);

      TabR.TopLeft := Point(x1 + TabOffVal, y1);
      TabR.BottomRight := Point((x2) - TabOffVal, y2);
      if bImages then
      begin
        FOnGetImageIdx(Self, FActiveTab, n);
        m := ((ClientHeight - FTabOffsetTop) div 2) - 8;
        if Pinned then
          w := ((TabR.Right - TabR.Left) - FImages.Width) div 2
        else
          w := 1;
        if n <> -1 then
        begin
          if n > -1 then
            FImages.Draw(ScrollBmp.Canvas, TabR.Left + w, FTabOffsetTop + m, n);
          TabR.Left := TabR.Left + 22;
        end;
      end;
      if bClose then
      begin
        n := x2 - 24;
        m := FTabOffsetTop + (FTabsHeight shr 1) + 4;
        if (FTabX = ActiveTab) and FHotClose then
        begin
          if FCloseDown then
            ScrollCanvas.FillEllipse(Brushes[biCloseBtnDGrey], n - 3, m - 9, 12, 12)
          else
            ScrollCanvas.FillEllipse(Brushes[biCloseBtnRed], n - 3, m - 9, 12, 12);
          ScrollCanvas.DrawLine(Pens[piCloseBtnWhite], n, m, n + 6, m - 6);
          ScrollCanvas.DrawLine(Pens[piCloseBtnWhite], n + 6, m, n, m - 6);
        end
        else
        begin
          ScrollCanvas.DrawLine(Pens[piCloseBtnGray], n, m, n + 6, m - 6);
          ScrollCanvas.DrawLine(Pens[piCloseBtnGray], n + 6, m, n, m - 6);
        end;
        TabR.Right := TabR.Right - 16;
      end;
      if FGdiPTExt then
      begin
        w := ColorToRGB(FColorTxtActive);
        TabsTxtBrush := TGPSolidBrush.Create(MakeColor(255, Byte(w), Byte(w shr 8),
            Byte(w shr 16)));
        TxtRect.x := TabR.Left;
        TxtRect.y := TabR.Top;
        TxtRect.Width := TabR.Right - TabR.Left;
        TxtRect.Height := TabR.Bottom - 4;
        TxtFormat := TGPStringFormat.Create();
        TxtFormat.SetLineAlignment(StringAlignmentCenter);
        TxtFormat.SetFormatFlags(StringFormatFlagsNoWrap);
        ScrollCanvas.DrawString(PChar(txt), Length(txt), FTabsFont, TxtRect, TxtFormat,
          TabsTxtBrush);
        TxtFormat.Free;
        TabsTxtBrush.Free;
      end
      else
      begin
        ScrollBmp.Canvas.Brush.Style := bsClear;
        if FOutline then
        begin
          ScrollBmp.Canvas.Font.Color := FColorOutActive;
          R2 := TabR;
          R2.Left := R2.Left - 1;
          R2.Right := R2.Right - 1;
          DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
            DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
          R2 := TabR;
          R2.Left := R2.Left + 1;
          R2.Right := R2.Right + 1;
          DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
            DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
          R2 := TabR;
          R2.Top := R2.Top + 1;
          R2.Bottom := R2.Bottom + 1;
          DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
            DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
          R2 := TabR;
          R2.Top := R2.Top - 1;
          R2.Bottom := R2.Bottom - 1;
          DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
            DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
        end;
        ScrollBmp.Canvas.Font.Color := FColorTxtActive;
        DrawText(ScrollBmp.Canvas.Handle, PChar(txt), Length(txt), TabR,
          DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
      end;
      // Fade out text at right side ...
      if not FAutoSize then
      begin
        slPtr := Integer(ScrollBmp.ScanLine[y1 + 1]);
        slSize := Integer(ScrollBmp.ScanLine[y1 + 2]) - slPtr;
        slPtr2 := Integer(Back.ScanLine[y1 + 1]);
        slSize2 := Integer(Back.ScanLine[y1 + 2]) - slPtr2;
        a := FLevelTabActive;
        c1 := ColorToRGB(FColorTabActive);
        r := Byte(c1);
        g := Byte(c1 shr 8);
        b := Byte(c1 shr 16);
        x := TabR.Right - TextFadeOut;
        for h := y1 + 1 to y2 - 1 do
        begin
          Row := PRGBAArray(slPtr);
          Row2 := PRGBAArray(slPtr2);
          c1 := 255;
          for w := x to x + TextFadeOut do
          begin
            v2 := Byte(Row2[w + bo].r);
            v2 := Byte(a * (r - v2) shr 8 + v2);
            Row[w].r := Byte(c1 * (Row[w].r - v2) shr 8 + v2);
            v2 := Byte(Row2[w + bo].g);
            v2 := Byte(a * (g - v2) shr 8 + v2);
            Row[w].g := Byte(c1 * (Row[w].g - v2) shr 8 + v2);
            v2 := Byte(Row2[w + bo].b);
            v2 := Byte(a * (b - v2) shr 8 + v2);
            Row[w].b := Byte(c1 * (Row[w].b - v2) shr 8 + v2);
            c1 := c1 - 15;
          end;
          slPtr := slPtr + slSize;
          slPtr2 := slPtr2 + slSize2;
        end;
        // Fade done...
      end;
      if Assigned(FOnCustomDraw) then
        FOnCustomDraw(Self, ScrollBmp.Canvas, Rect(x1, y1, x2, y2), txt, stSelected,
          FActiveTab);
    end
    else ScrollCanvas.DrawLine(Pens[piBrdBottom], 0, y2, ScrollBmp.Width, y2);

    // Done active tab...

    bo := 0;
    for i := 0 to t1 - 1 do
      bo := bo + (TabWidth(i) - FTabOverLap);
    i := ScrollOff - bo;

    FBmp.Canvas.CopyRect(BmTabs, ScrollBmp.Canvas, Rect(i, 0, BmTWidth + i, Height));

    ScrollCanvas.Free;
    ScrollBmp.Free;

    p := p + BmTWidth;

    x1 := p + 7;
    y1 := Height - 7;
    Arrow[0].x := x1;
    Arrow[0].y := y1;
    Arrow[1].x := x1 + 6;
    Arrow[1].y := y1 - 6;
    Arrow[2].x := x1 + 6;
    Arrow[2].y := y1 - 7;
    Arrow[3].x := x1;
    Arrow[3].y := y1 - 13;
    Arrow[4].x := x1 - 2;
    Arrow[4].y := y1 - 11;
    Arrow[5].x := x1 + 2;
    Arrow[5].y := y1 - 7;
    Arrow[6].x := x1 + 2;
    Arrow[6].y := y1 - 6;
    Arrow[7].x := x1 - 2;
    Arrow[7].y := y1 - 2;
    if ScrollOff = ScrollMax then
      TabsCanvas.FillPolygon(Brushes[biTabInActive], PGPPoint(@Arrow), 8)
    else
      TabsCanvas.FillPolygon(Brushes[biTabActive], PGPPoint(@Arrow), 8);
    TabsCanvas.DrawPolygon(baGP, PGPPoint(@Arrow), 8);

    p := p + 20;

    // Paint add button...
    if FShowButton then
    begin
      x1 := p;
      x2 := x1 + 17;
      y1 := by; // + 1;
      y2 := y1 + 17;
      Tab[0].x := x1 + 1;
      Tab[0].y := y2;
      Tab[1].x := x1;
      Tab[1].y := y2 - 1;
      Tab[2].x := x1;
      Tab[2].y := y1 + 1;
      Tab[3].x := x1 + 1;
      Tab[3].y := y1;
      Tab[4].x := x2 - 1;
      Tab[4].y := y1;
      Tab[5].x := x2;
      Tab[5].y := y1 + 1;
      Tab[6].x := x2;
      Tab[6].y := y2 - 1;
      Tab[7].x := x2 - 1;
      Tab[7].y := y2;
      if FButtonDown then
      begin
        TabsCanvas.DrawPolygon(Pens[piBrdHot], PGPPoint(@Tab), 8);
        brushButtonDown := TGPPathGradientBrush.Create(PGPPoint(@Tab), 8);
        brushButtonDown.SetCenterColor(MakeColor(64, 255, 255, 255));
        n := 1;
        DownColor[0] := MakeColor(48, 220, 220, 220);
        brushButtonDown.SetSurroundColors(PARGB(@DownColor), n);
        TabsCanvas.FillPolygon(brushButtonDown, PGPPoint(@Tab), 8);
        brushButtonDown.Free;
      end
      else
      begin
        if FHotButton then
        begin
          TabsCanvas.DrawPolygon(Pens[piBrdHot], PGPPoint(@Tab), 8);
          TabsCanvas.FillPolygon(Brushes[biTabHot], PGPPoint(@Tab), 8);
        end
      end;
      x1 := p + 4;
      y1 := by + 7;
      TabAdd[0].x := x1;
      TabAdd[0].y := y1;
      TabAdd[1].x := x1 + 3;
      TabAdd[1].y := y1;
      TabAdd[2].x := x1 + 3;
      TabAdd[2].y := y1 - 3;
      TabAdd[3].x := x1 + 6;
      TabAdd[3].y := y1 - 3;
      TabAdd[4].x := x1 + 6;
      TabAdd[4].y := y1;
      TabAdd[5].x := x1 + 9;
      TabAdd[5].y := y1;
      TabAdd[6].x := x1 + 9;
      TabAdd[6].y := y1 + 3;
      TabAdd[7].x := x1 + 6;
      TabAdd[7].y := y1 + 3;
      TabAdd[8].x := x1 + 6;
      TabAdd[8].y := y1 + 6;
      TabAdd[9].x := x1 + 3;
      TabAdd[9].y := y1 + 6;
      TabAdd[10].x := x1 + 3;
      TabAdd[10].y := y1 + 3;
      TabAdd[11].x := x1;
      TabAdd[11].y := y1 + 3;
      TabAdd[12].x := x1;
      TabAdd[12].y := y1;
      TabsCanvas.FillPolygon(Brushes[biAddBtnWhite], PGPPoint(@TabAdd), 13);
      p1.x := 0;
      p1.y := 0;
      p2.x := 0;
      p2.y := 12;
      baGP.SetWidth(0.5);
      TabsCanvas.DrawPolygon(baGP, PGPPoint(@TabAdd), 13);
      baGB.Free;
      baGP.Free;
    end;
  end;
end;

procedure TrkSmartTabs.PaintSimpleTabs(TabsCanvas: TGPGraphics; Back, Mask: TBitmap);
var
  x, c1, i, n, m, x1, x2, x3, y1, y2, bx, by, ts, ax, tw: Integer;
  txt: string;
  TabsR, TabR, R2: TRect;
  Tab: TabPoly;
  TabAdd: array [0 .. 12] of TPoint;
  DownColor: array [0 .. 1] of GDIPAPI.ARGB;
  TabsTxtBrush: TGPSolidBrush;
  TxtRect: TGPRectF;
  TxtFormat: TGPStringFormat;
  brushButtonDown: TGPPathGradientBrush;
  baGB: TGPLinearGradientBrush;
  baGP: TGPPen;
  p1, p2: TGPPoint;
  bImages, bClose, Pinned: Boolean;
  slSize, slPtr: Integer;
  w, h: Integer;
  Row: PRGBAArray;
  slSize2, slPtr2: Integer;
  Row2: PRGBAArray;
  slSize3, slPtr3: Integer;
  Row3: PRGBAArray;
  a: Byte;
  c2: Longint;
  r, g, b, v1, v2: Byte;
  p, t1, t2, tn: Integer;
  State: TabState;
  pId : TPenId;
  bId : TBrushId;

begin
  TabsR := ClientRect;

  Pinned := TabPinned(FTabs.Count - 1);
  ts := (PinnedWidth - FTabOverLap) * FPinnedTabs;
  for i := 0 to (FTabs.Count - FPinnedTabs) - 1 do
    ts := ts + (TabWidth(i) - FTabOverLap);

  if Pinned then
  begin
    ts := ts - (PinnedWidth - FTabOverLap);
    x1 := FTabOffset + ts;
    x2 := x1 + PinnedWidth;
    bx := (x1 + PinnedWidth);
  end
  else
  begin
    w := TabWidth(FTabs.Count - (FPinnedTabs + 1));
    ts := ts - (w - FTabOverLap);
    x1 := FTabOffset + ts;
    x2 := x1 + w;
    bx := x2;
  end;
  ClsBtnX := bx + 1;
  y1 := FTabOffsetTop;
  y2 := ClientHeight - 1;
  by := y1 + 4;

  if FCloseHide then
    bClose := FShowClose and (FTabWidth > FMinCloseWidth)
  else
    bClose := FShowClose;

  bClose := False;

  for i := FTabs.Count - 1 downto 0 do
  begin
    if i <> FActiveTab then
    begin
      txt := FTabs[i];
      Pinned := TabPinned(i);

      if Pinned then
        bImages := Assigned(FOnGetImageIdx) and Assigned(FImages)
      else
        bImages := (FShowImages) and Assigned(FOnGetImageIdx) and Assigned(FImages) and
          ((FTabWidth > 80) or not FImageHide);

      bClose := bClose and not Pinned;
      Tab := GetTabsPoly(x1, y1, x2, y2);

      State := stNormal;
      if i = FHotIdx then
        State := stHot;

      if i = FHotIdx then
      begin
        pId := piBrdHot;
        bId := biTabHot;
      end
      else
      begin
        pId := piBrdInActive;
        bId := biTabInActive
      end;
      TabsCanvas.FillPolygon(Brushes[bId], PGPPoint(@Tab), PolyTabCount);
      TabsCanvas.DrawPolygon(Pens[pId], PGPPoint(@Tab), PolyTabCount);

      // use mask image to restore overlaping tab area
      if (i > 0) and (i <> FActiveTab + 1) and (not FSeeThruTabs) then
      begin
        slPtr := Integer(FBmp.ScanLine[y1]);
        slSize := Integer(FBmp.ScanLine[y1 + 1]) - slPtr;
        slPtr2 := Integer(Mask.ScanLine[y1]);
        slSize2 := Integer(Mask.ScanLine[y1 + 1]) - slPtr2;
        slPtr3 := Integer(Back.ScanLine[y1]);
        slSize3 := Integer(Back.ScanLine[y1 + 1]) - slPtr3;
        for h := y1 to y2 - 1 do
        begin
          Row := PRGBAArray(slPtr);
          Row2 := PRGBAArray(slPtr2);
          Row3 := PRGBAArray(slPtr3);
          for w := 0 to FTabOverLap - 1 do
            if Row2[w + (Mask.Width - FTabOverLap) + 1].a <> 0 then
            begin
              Row[w + x1].r := Row3[w + x1].r;
              Row[w + x1].g := Row3[w + x1].g;
              Row[w + x1].b := Row3[w + x1].b;
              Row[w + x1].a := Row3[w + x1].a;
            end;
          slPtr := slPtr + slSize;
          slPtr2 := slPtr2 + slSize2;
          slPtr3 := slPtr3 + slSize3;
        end;
      end;
      // overlaping tab area restored

      TabR.TopLeft := Point(x1 + TabOffVal, y1); // TabOffVal = FTabOverLap
      TabR.BottomRight := Point(x2 - TabOffVal, y2);
      if bImages then
      begin
        FOnGetImageIdx(Self, i, n);
        if n <> -1 then
        begin
          m := ((ClientHeight - FTabOffsetTop) div 2) - 8;
          if Pinned then
            w := ((TabR.Right - TabR.Left) - Images.Width) div 2
          else
            w := 1;
          if n > -1 then
            FImages.Draw(FBmp.Canvas, TabR.Left + w, FTabOffsetTop + m, n);
          TabR.Left := TabR.Left + 22;
        end;
      end;

      if (FShowClose) and not(FCloseHide) and (i >= FPinnedTabs) then
      begin
        n := x2 - 24;
        m := FTabOffsetTop + (FTabsHeight shr 1) + 4;
        if (FTabX = i) and FHotClose then
        begin
          if FCloseDown then
            TabsCanvas.FillEllipse(Brushes[biCloseBtnDGrey], n - 3, m - 9, 12, 12)
          else
            TabsCanvas.FillEllipse(Brushes[biCloseBtnRed], n - 3, m - 9, 12, 12);
          TabsCanvas.DrawLine(Pens[piCloseBtnWhite], n, m, n + 6, m - 6);
          TabsCanvas.DrawLine(Pens[piCloseBtnWhite], n + 6, m, n, m - 6);
        end
        else
        begin
          TabsCanvas.DrawLine(Pens[piCloseBtnGray], n, m, n + 6, m - 6);
          TabsCanvas.DrawLine(Pens[piCloseBtnGray], n + 6, m, n, m - 6);
        end;
        TabR.Right := TabR.Right - 16;
      end;

      if not Pinned then
      begin
        if FGdiPTExt then
        begin
          if i = FHotIdx then
            w := ColorToRGB(FColorTxtHot)
          else
            w := ColorToRGB(FColorTxtInActive);
          TabsTxtBrush := TGPSolidBrush.Create(MakeColor(255, Byte(w), Byte(w shr 8),
              Byte(w shr 16)));
          TxtRect.x := TabR.Left;
          TxtRect.y := TabR.Top;
          TxtRect.Width := TabR.Right - TabR.Left;
          TxtRect.Height := TabR.Bottom - 4;
          TxtFormat := TGPStringFormat.Create();
          // TxtFormat.SetTrimming(StringTrimmingEllipsisCharacter);
          TxtFormat.SetLineAlignment(StringAlignmentCenter);
          TxtFormat.SetFormatFlags(StringFormatFlagsNoWrap);
          TabsCanvas.DrawString(PChar(txt), Length(txt), FTabsFont, TxtRect, TxtFormat,
            TabsTxtBrush);
          TxtFormat.Free;
          TabsTxtBrush.Free;
        end
        else
        begin
          FBmp.Canvas.Brush.Style := bsClear;
          if FOutline then
          begin
            if i = FHotIdx then
              FBmp.Canvas.Font.Color := FColorOutHot
            else
              FBmp.Canvas.Font.Color := FColorOutInActive;
            R2 := TabR;
            R2.Left := R2.Left - 1;
            R2.Right := R2.Right - 1;
            DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
              DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
            R2 := TabR;
            R2.Left := R2.Left + 1;
            R2.Right := R2.Right + 1;
            DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
              DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
            R2 := TabR;
            R2.Top := R2.Top + 1;
            R2.Bottom := R2.Bottom + 1;
            DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
              DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
            R2 := TabR;
            R2.Top := R2.Top - 1;
            R2.Bottom := R2.Bottom - 1;
            DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
              DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
          end;
          if i = FHotIdx then
            FBmp.Canvas.Font.Color := FColorTxtHot
          else
            FBmp.Canvas.Font.Color := FColorTxtInActive;
          DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), TabR,
            DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
        end;

        if not FAutoSize then
        begin
          // Fade out text at right side ...
          slPtr := Integer(FBmp.ScanLine[y1 + 1]);
          slSize := Integer(FBmp.ScanLine[y1 + 2]) - slPtr;
          slPtr2 := Integer(Back.ScanLine[y1 + 1]);
          slSize2 := Integer(Back.ScanLine[y1 + 2]) - slPtr2;
          if i = FHotIdx then
          begin
            a := FLevelTabHot;
            c1 := ColorToRGB(FColorTabHot)
          end
          else
          begin
            a := FLevelTabInActive;
            c1 := ColorToRGB(FColorTabInActive);
          end;
          r := Byte(c1);
          g := Byte(c1 shr 8);
          b := Byte(c1 shr 16);
          x := TabR.Right - TextFadeOut;
          for h := y1 + 1 to y2 - 1 do
          begin
            Row := PRGBAArray(slPtr);
            Row2 := PRGBAArray(slPtr2);
            c1 := 255;
            for w := x to x + TextFadeOut do
            begin
              v2 := Byte(Row2[w].r);
              v2 := Byte(a * (r - v2) shr 8 + v2);
              Row[w].r := Byte(c1 * (Row[w].r - v2) shr 8 + v2);
              v2 := Byte(Row2[w].g);
              v2 := Byte(a * (g - v2) shr 8 + v2);
              Row[w].g := Byte(c1 * (Row[w].g - v2) shr 8 + v2);
              v2 := Byte(Row2[w].b);
              v2 := Byte(a * (b - v2) shr 8 + v2);
              Row[w].b := Byte(c1 * (Row[w].b - v2) shr 8 + v2);
              c1 := c1 - 15;
            end;
            slPtr := slPtr + slSize;
            slPtr2 := slPtr2 + slSize2;
          end;
          // Fade done...
        end;
      end;
      if Assigned(FOnCustomDraw) then
        FOnCustomDraw(Self, FBmp.Canvas, Rect(x1, y1, x2, y2), txt, State, i);
    end
    else
      ax := x1;
    Pinned := TabPinned(i - 1);
    if Pinned then
      w := PinnedWidth
    else
      w := TabWidth(i - FPinnedTabs - 1);
    x1 := x1 - (w - FTabOverLap);
    x2 := x1 + w;
  end;

  // Paint Active Tab

  txt := FTabs[FActiveTab];
  Pinned := TabPinned(FActiveTab);
  if Pinned then
    bImages := Assigned(FOnGetImageIdx) and Assigned(FImages)
  else
    bImages := (FShowImages) and Assigned(FOnGetImageIdx) and Assigned(FImages) and
      ((FTabWidth > 80) or not FImageHide);
  if Pinned then
    tw := PinnedWidth
  else
    tw := TabWidthA(FActiveTab);
  bClose := FShowClose and not Pinned;
  x1 := ax;
  if FDragging then
    x1 := FDragX;
  x2 := x1 + tw;
  // use mask image to restore overlaping tab area
  if (not FDragging) and (not FSeeThruTabs) then
  begin
    slPtr := Integer(FBmp.ScanLine[y1]);
    slSize := Integer(FBmp.ScanLine[y1 + 1]) - slPtr;
    slPtr2 := Integer(Mask.ScanLine[y1]);
    slSize2 := Integer(Mask.ScanLine[y1 + 1]) - slPtr2;
    slPtr3 := Integer(Back.ScanLine[y1]);
    slSize3 := Integer(Back.ScanLine[y1 + 1]) - slPtr3;
    x3 := x2 - FTabOverLap;
    for h := y1 to y2 - 1 do
    begin
      Row := PRGBAArray(slPtr);
      Row2 := PRGBAArray(slPtr2);
      Row3 := PRGBAArray(slPtr3);
      for w := 0 to FTabOverLap - 1 do
        if Row2[w + (Mask.Width - FTabOverLap) + 1].a <> 0 then
        begin
          Row[w + x3].r := Row3[w + x3].r;
          Row[w + x3].g := Row3[w + x3].g;
          Row[w + x3].b := Row3[w + x3].b;
          Row[w + x3].a := Row3[w + x3].a;
          Row[x1 + FTabOverLap - w].r := Row3[x1 + FTabOverLap - w].r;
          Row[x1 + FTabOverLap - w].g := Row3[x1 + FTabOverLap - w].g;
          Row[x1 + FTabOverLap - w].b := Row3[x1 + FTabOverLap - w].b;
          Row[x1 + FTabOverLap - w].a := Row3[x1 + FTabOverLap - w].a;
        end;
      slPtr := slPtr + slSize;
      slPtr2 := slPtr2 + slSize2;
      slPtr3 := slPtr3 + slSize3;
    end;
  end;
  // overlaping tab area restored
  txt := FTabs[FActiveTab];
  Tab := GetTabsPoly(x1, y1, x2, y2);
  TabsCanvas.FillPolygon(Brushes[biTabActive], PGPPoint(@Tab), PolyTabCount);
  TabsCanvas.DrawPolygon(Pens[piBrdActive], PGPPoint(@Tab), PolyTabCount);

  TabsCanvas.DrawLine(Pens[piBrdBottom],0, y2, ClientWidth, y2);
  TabsCanvas.DrawLine(Pens[piBackgnd], x1+1, y2, x2, y2);

  TabR.TopLeft := Point(x1 + TabOffVal, y1);
  TabR.BottomRight := Point((x2) - TabOffVal, y2);
  if bImages then
  begin
    FOnGetImageIdx(Self, FActiveTab, n);
    m := ((ClientHeight - FTabOffsetTop) div 2) - 8;
    if Pinned then
      w := ((TabR.Right - TabR.Left) - FImages.Width) div 2
    else
      w := 1;
    if n <> -1 then
    begin
      if n > -1 then
        FImages.Draw(FBmp.Canvas, TabR.Left + w, FTabOffsetTop + m, n);
      TabR.Left := TabR.Left + 22;
    end;
  end;
  if bClose then
  begin
    n := x2 - 24;
    m := FTabOffsetTop + (FTabsHeight shr 1) + 4;
    if (FTabX = ActiveTab) and FHotClose then
    begin
      if FCloseDown then
        TabsCanvas.FillEllipse(Brushes[biCloseBtnDGrey], n - 3, m - 9, 12, 12)
      else
        TabsCanvas.FillEllipse(Brushes[biCloseBtnRed], n - 3, m - 9, 12, 12);
      TabsCanvas.DrawLine(Pens[piCloseBtnWhite], n, m, n + 6, m - 6);
      TabsCanvas.DrawLine(Pens[piCloseBtnWhite], n + 6, m, n, m - 6);
    end
    else
    begin
      TabsCanvas.DrawLine(Pens[piCloseBtnGray], n, m, n + 6, m - 6);
      TabsCanvas.DrawLine(Pens[piCloseBtnGray], n + 6, m, n, m - 6);
    end;
    TabR.Right := TabR.Right - 16;
  end;
  if not Pinned then
  begin
    if FGdiPTExt then
    begin
      w := ColorToRGB(FColorTxtActive);
      TabsTxtBrush := TGPSolidBrush.Create(MakeColor(255, Byte(w), Byte(w shr 8),
          Byte(w shr 16)));
      TxtRect.x := TabR.Left;
      TxtRect.y := TabR.Top;
      TxtRect.Width := TabR.Right - TabR.Left;
      TxtRect.Height := TabR.Bottom - 4;
      TxtFormat := TGPStringFormat.Create();
      TxtFormat.SetLineAlignment(StringAlignmentCenter);
      TxtFormat.SetFormatFlags(StringFormatFlagsNoWrap);
      TabsCanvas.DrawString(PChar(txt), Length(txt), FTabsFont, TxtRect, TxtFormat,
        TabsTxtBrush);
      TxtFormat.Free;
      TabsTxtBrush.Free;
    end
    else
    begin
      FBmp.Canvas.Brush.Style := bsClear;
      if FOutline then
      begin
        FBmp.Canvas.Font.Color := FColorOutActive;
        R2 := TabR;
        R2.Left := R2.Left - 1;
        R2.Right := R2.Right - 1;
        DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
          DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
        R2 := TabR;
        R2.Left := R2.Left + 1;
        R2.Right := R2.Right + 1;
        DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
          DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
        R2 := TabR;
        R2.Top := R2.Top + 1;
        R2.Bottom := R2.Bottom + 1;
        DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
          DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
        R2 := TabR;
        R2.Top := R2.Top - 1;
        R2.Bottom := R2.Bottom - 1;
        DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), R2,
          DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
      end;
      FBmp.Canvas.Font.Color := FColorTxtActive;
      DrawText(FBmp.Canvas.Handle, PChar(txt), Length(txt), TabR,
        DT_SINGLELINE or DT_NOPREFIX or DT_VCENTER);
    end;

    if not FAutoSize then
    begin
      // Fade out text at right side ...
      slPtr := Integer(FBmp.ScanLine[y1 + 1]);
      slSize := Integer(FBmp.ScanLine[y1 + 2]) - slPtr;
      slPtr2 := Integer(Back.ScanLine[y1 + 1]);
      slSize2 := Integer(Back.ScanLine[y1 + 2]) - slPtr2;
      a := FLevelTabActive;
      c1 := ColorToRGB(FColorTabActive);
      r := Byte(c1);
      g := Byte(c1 shr 8);
      b := Byte(c1 shr 16);
      x := TabR.Right - TextFadeOut;
      for h := y1 + 1 to y2 - 1 do
      begin
        Row := PRGBAArray(slPtr);
        Row2 := PRGBAArray(slPtr2);
        c1 := 255;
        for w := x to x + TextFadeOut do
        begin
          v2 := Byte(Row2[w].r);
          v2 := Byte(a * (r - v2) shr 8 + v2);
          Row[w].r := Byte(c1 * (Row[w].r - v2) shr 8 + v2);
          v2 := Byte(Row2[w].g);
          v2 := Byte(a * (g - v2) shr 8 + v2);
          Row[w].g := Byte(c1 * (Row[w].g - v2) shr 8 + v2);
          v2 := Byte(Row2[w].b);
          v2 := Byte(a * (b - v2) shr 8 + v2);
          Row[w].b := Byte(c1 * (Row[w].b - v2) shr 8 + v2);
          c1 := c1 - 15;
        end;
        slPtr := slPtr + slSize;
        slPtr2 := slPtr2 + slSize2;
      end;
      // Fade done...
    end;
  end;
  if Assigned(FOnCustomDraw) then
    FOnCustomDraw(Self, FBmp.Canvas, Rect(x1, y1, x2, y2), txt, stSelected, FActiveTab);
  // Paint Add button
  if FShowButton then
  begin
    x1 := bx;
    x2 := x1 + TabButtonWidth;
    y1 := by + 2;
    y2 := y1 + 15;
    Tab[0].x := x1 + 4;
    Tab[0].y := y2;
    Tab[1].x := x1 + 1;
    Tab[1].y := y2 - 2;
    Tab[2].x := x1 - 3;
    Tab[2].y := y1 + 1;
    Tab[3].x := x1 - 2;
    Tab[3].y := y1;
    Tab[4].x := x2 - 6;
    Tab[4].y := y1;
    Tab[5].x := x2 - 4;
    Tab[5].y := y1 + 2;
    Tab[6].x := x2;
    Tab[6].y := y2 - 1;
    Tab[7].x := x2 - 1;
    Tab[7].y := y2;
    if FButtonDown then
    begin
      brushButtonDown := TGPPathGradientBrush.Create(PGPPoint(@Tab), 8);
      brushButtonDown.SetCenterColor(MakeColor(64, 255, 255, 255));
      n := 1;
      DownColor[0] := MakeColor(48, 220, 220, 220);
      brushButtonDown.SetSurroundColors(PARGB(@DownColor), n);
      TabsCanvas.FillPolygon(brushButtonDown, PGPPoint(@Tab), 8);
      brushButtonDown.Free;
      TabsCanvas.DrawPolygon(Pens[piBrdHot], PGPPoint(@Tab), 8);
    end
    else
    begin
      if FHotButton then
      begin
        TabsCanvas.FillPolygon(Brushes[biTabHot], PGPPoint(@Tab), 8);
        TabsCanvas.DrawPolygon(Pens[piBrdHot], PGPPoint(@Tab), 8);
      end
      else
      begin
        TabsCanvas.FillPolygon(Brushes[biAddBtnWhiteBlend { 7 } ], PGPPoint(@Tab), 8);
        TabsCanvas.DrawPolygon(Pens[piBrdHot], PGPPoint(@Tab), 8);
      end
    end;
  end;
end;

procedure TrkSmartTabs.PaintTabs;
var
  Tab: TabPoly;
  SCL, SCLOff: Integer;
  Row: PRGBAArray;
  Mask, Back: TBitmap;
  MaskCanvas: TGPGraphics;
  w, h, x1, x2, y1, y2: Integer;

begin
  if InCreate then
    Exit;
  FBmp.Width := ClientWidth;
  FBmp.Height := ClientHeight;
  FBmp.Canvas.Font.Assign(Font);
  FBmp.Canvas.Brush.Color := ColorToRGB(FColorBackground);;
  Back := TBitmap.Create;
  Back.PixelFormat := pf32Bit;
  Back.Width := ClientWidth;
  Back.Height := ClientHeight;
  FTabsFont := TGPFont.Create(Font.Name, Font.Size);

  if FTransparent then
    DrawParentImage(Self, FBmp.Canvas)
  else
  begin
    // Clear canvas
    SCL := Integer(FBmp.ScanLine[0]);
    SCLOff := Integer(FBmp.ScanLine[1]) - SCL;
    for h := 0 to FBmp.Height - 1 do
    begin
      Row := PRGBAArray(SCL);
      for w := 0 to FBmp.Width - 1 do
      begin
        Row[w].r := Byte(ColorToRGB(FColorBackground));
        Row[w].g := Byte(ColorToRGB(FColorBackground) shr 8);
        Row[w].b := Byte(ColorToRGB(FColorBackground) shr 16);
        Row[w].a := 0;
      end;
      SCL := SCL + SCLOff;
    end;
    // canvas cleared
  end;

  Back.Canvas.CopyRect(ClientRect, FBmp.Canvas, ClientRect);
  Back.Canvas.Font.Assign(Font);

  if Tabs.Count > 0 then
  begin
    CalcTabWidth;

    // Make mask image
    Mask := TBitmap.Create;
    Mask.PixelFormat := pf32Bit;
    Mask.Width := FTabWidth + 1;
    Mask.Height := ClientHeight;
    MaskCanvas := TGPGraphics.Create(Mask.Canvas.Handle);
    MaskCanvas.SetSmoothingMode(SmoothingModeHighQuality);
    Mask.Canvas.Brush.Color := clBlack;
    Mask.Canvas.FillRect(Mask.Canvas.ClipRect);
    x1 := 0;
    x2 := x1 + FTabWidth;
    y1 := FTabOffsetTop;
    y2 := ClientHeight - 1;
    FTabsHeight := y2 - y1;
    Tab := GetTabsPoly(x1, y1, x2, y2);
    MaskCanvas.FillPolygon(Brushes[biMaskWhite], PGPPoint(@Tab), PolyTabCount);
    MaskCanvas.DrawPolygon(Pens[piBrdHot], PGPPoint(@Tab), PolyTabCount);
    // mask done

    TabsCanvas := TGPGraphics.Create(FBmp.Canvas.Handle);
    TabsCanvas.SetSmoothingMode(SmoothingModeHighQuality);
    TabsCanvas.SetTextRenderingHint(TextRenderingHintAntiAlias);

    // Do the painting...

    if ScrollMode then
      PaintScrollingTabs(TabsCanvas, Back, Mask)
    else
      PaintSimpleTabs(TabsCanvas, Back, Mask);

    FTabsFont.Free;
    TabsCanvas.Free;
    MaskCanvas.Free;
    Mask.Free;
  end;

  BitBlt(Canvas.Handle, 0, 0, FBmp.Width, FBmp.Height, FBmp.Canvas.Handle, 0, 0, SRCCOPY);
  Back.Free;
end;

procedure TrkSmartTabs.PaintWindow(DC: HDC);
begin
  Canvas.Lock;
  try
    Canvas.Handle := DC;
    try
      PaintTabs;
    finally
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Unlock;
  end;
end;

procedure TrkSmartTabs.PinTab(AIndex: Integer);
begin
  if not TabPinned(AIndex) then
  begin
    Tabs.Move(AIndex, FPinnedTabs);
    Tabs[FPinnedTabs] := FPinnedStr + Tabs[FPinnedTabs];
    if AIndex = FActiveTab then
      ActiveTab := FPinnedTabs
    else if AIndex > FActiveTab then
      if (FActiveTab >= FPinnedTabs) and (FActiveTab < FTabs.Count - 1) then
        inc(FActiveTab);
    Invalidate;
  end;
end;

procedure TrkSmartTabs.Resize;
var
  t: TabPoly;
begin
  if InCreate then
    Exit;

  t := GetTabPolyS((FTabs.Count - 1) - FPinnedTabs);
  if t[9].x < ScrollView.y then
    ScrollOff := ScrollMax;
  Height := 26 + FTabOffsetTop;
  Invalidate;
end;

procedure TrkSmartTabs.SetActiveTab(const Value: Integer);
begin
  if (Value >= 0) and (Value < FTabs.Count) then
  begin
    FActiveTab := Value;
    if (ScrollMode) and (ActiveTab >= FPinnedTabs) then
    begin
      if ActiveTab = Tabs.Count - 1 then
      begin
        ScrollOff := 0;
        ScrollView := Point(0, BmTWidth);
      end;
      SetInView(FActiveTab - FPinnedTabs, 4);
    end
    else
      Invalidate;
    if Assigned(FOnTabChange) then
      FOnTabChange(Self);
  end
  else
  begin
    FActiveTab := 0;
    if (ScrollMode) and (ActiveTab >= FPinnedTabs) then
      SetInView(FActiveTab - FPinnedTabs, 5)
    else
      Invalidate;
  end;
end;

procedure TrkSmartTabs.SetAutoTabSize(const Value: Boolean);
begin
  FAutoSize := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetBackground(const Value: TColor);
begin
  FColorBackground := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetCloseHide(const Value: Boolean);
begin
  FCloseHide := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetColBrdActive(const Value: TColor);
begin
  FColorBrdActive := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetColBrdBottom(const Value: TColor);
begin
  FColorBrdBottom := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetColBrdHot(const Value: TColor);
begin
  FColorBrdHot := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetColBrdInActive(const Value: TColor);
begin
  FColorBrdInActive := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetColorActive(const Value: TColor);
begin
  FColorTabActive := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetColorHot(const Value: TColor);
begin
  FColorTabHot := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetColorInActive(const Value: TColor);
begin
  FColorTabInActive := Value;
  SetColors;
  Invalidate;
end;

procedure TrkSmartTabs.SetSeeThruTabs(const Value: Boolean);
begin
  FSeeThruTabs := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetShowButton(const Value: Boolean);
begin
  FShowButton := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetShowClose(const Value: Boolean);
begin
  FShowClose := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetShowImages(const Value: Boolean);
begin
  FShowImages := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetTabName(AIndex: Integer; AName: String);
begin
  if not((AIndex >= 0) and (AIndex < Tabs.Count)) then
    Exit;
  if TabPinned(AIndex) then
    AName := FPinnedStr + AName;
  Tabs[AIndex] := AName;
end;

procedure TrkSmartTabs.SetTabOffset(const Value: Integer);
begin
  FTabOffset := Value;
  Invalidate;
end;

procedure TrkSmartTabs.SetTabs(const Value: TStringList);
begin
  FTabs.Assign(Value);
  CalcTabWidth;
  if FActiveTab > Tabs.Count - 1 then
    ActiveTab := Tabs.Count - 1;
  if Assigned(FOnTabChange) then
    FOnTabChange(Self);
end;

procedure TrkSmartTabs.SetTransparent(const Value: Boolean);
begin
  FTransparent := Value;
  Invalidate;
end;

function TrkSmartTabs.TabPinned(AIndex: Integer): Boolean;
begin
  Result := False;
  if (AIndex > -1) and (AIndex < FTabs.Count) then
    Result := (Pos(PinnedStr, FTabs[AIndex]) = 1);
end;

procedure TrkSmartTabs.UnPinTab(AIndex: Integer);
var
  s: String;
begin
  if TabPinned(AIndex) then
  begin
    Dec(FPinnedTabs);
    Tabs.Move(AIndex, FPinnedTabs);
    s := Tabs[FPinnedTabs];
    Delete(s, 1, Length(FPinnedStr));
    Tabs[FPinnedTabs] := s;
    if AIndex = FActiveTab then
      ActiveTab := FPinnedTabs
    else if AIndex < FActiveTab then
      if (FActiveTab <= FPinnedTabs) and (FActiveTab > 0) then
        Dec(FActiveTab);
    Invalidate;
  end;
end;

procedure TrkSmartTabs.WMERASEBKGND(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TrkSmartTabs.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TrkSmartTabs.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;
  if not(csLoading in ComponentState) then
    Invalidate;
end;

end.
