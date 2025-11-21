{******************************************************************************}
{                                                                              }
{  FMX.StyledToolbar: Multi-platform Toolbar with Styled Tool Buttons         }
{  Adapted from VCL StyledToolbar for FireMonkey                              }
{                                                                              }
{  Copyright (c) 2025 (Ethea S.r.l.)                                          }
{  Author: Claude AI / Carlo Barazzetta                                       }
{                                                                              }
{  https://github.com/EtheaDev/StyledComponents                               }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit FMX.StyledToolbar;

interface

{$I StyledComponents.FMX.inc}

uses
  System.UITypes,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Math,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  FMX.Graphics,
  FMX.ImgList,
  FMX.ActnList,
  FMX.Menus,
  FMX.Objects,
  FMX.Effects,
  FMX.StyledButton;

resourcestring
  ERROR_SETTING_TOOLBAR_STYLE = 'Error setting Toolbar Style: %s/%s/%s not available';

const
  DEFAULT_TOOLBUTTON_SEP_WIDTH = 6;
  DEFAULT_TOOLBUTTON_WIDTH = 44;
  DEFAULT_TOOLBUTTON_HEIGHT = 44;
  DEFAULT_SORT_ORDER = -1;

type
  EFMXStyledToolbarError = Exception;

  TFMXStyledToolbar = class;
  TFMXStyledToolButton = class;

  TToolButtonStyle = (tbsButton, tbsCheck, tbsDropDown, tbsSeparator, tbsDivider);

  TButtonProc = reference to procedure(Button: TFMXStyledToolButton);
  TControlProc = reference to procedure(Control: TControl);

  { TFMXStyledToolButton }
  TFMXStyledToolButton = class(TFMXStyledButton)
  private
    FAutoSize: Boolean;
    FGrouped: Boolean;
    FMarked: Boolean;
    FStyle: TToolButtonStyle;
    FImageAlignment: TImageAlignment;
    FMenuItem: TMenuItem;
    FSortOrder: Integer;
    FWrap: Boolean;
    FSeparatorLine: TLine;
    procedure SetGrouped(const AValue: Boolean);
    procedure SetMarked(const AValue: Boolean);
    procedure SetStyle(const AValue: TToolButtonStyle);
    procedure SetImageAlignment(const AValue: TImageAlignment);
    procedure SetMenuItem(const AValue: TMenuItem);
    procedure SetWrap(const AValue: Boolean);
    procedure UpdateButtonContent;
    procedure UpdateSeparator;
    function IsSeparator: Boolean;
    function IsDivider: Boolean;
    function GetToolbar: TFMXStyledToolbar;
    function GetIndex: Integer;
  protected
    procedure SetParent(const Value: TFmxObject); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoRealign; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Index: Integer read GetIndex;
    property Toolbar: TFMXStyledToolbar read GetToolbar;
  published
    property AutoSize: Boolean read FAutoSize write FAutoSize default False;
    property Grouped: Boolean read FGrouped write SetGrouped default False;
    property ImageAlignment: TImageAlignment read FImageAlignment write SetImageAlignment default TImageAlignment.Center;
    property Marked: Boolean read FMarked write SetMarked default False;
    property MenuItem: TMenuItem read FMenuItem write SetMenuItem;
    property SortOrder: Integer read FSortOrder write FSortOrder default DEFAULT_SORT_ORDER;
    property Style: TToolButtonStyle read FStyle write SetStyle default tbsButton;
    property Wrap: Boolean read FWrap write SetWrap default False;
  end;

  TSTBNewButtonEvent = procedure(Sender: TFMXStyledToolbar; AIndex: Integer;
    var AButton: TFMXStyledToolButton) of object;
  TSTBButtonEvent = procedure(Sender: TFMXStyledToolbar;
    AButton: TFMXStyledToolButton) of object;

  { TFMXStyledToolbar }
  TFMXStyledToolbar = class(TLayout)
  private
    FButtons: TList;
    FImages: TCustomImageList;
    FButtonWidth: Single;
    FButtonHeight: Single;
    FShowCaptions: Boolean;
    FFlat: Boolean;
    FAutoSize: Boolean;
    FOrientation: TOrientation;
    FStyleFamily: string;
    FStyleClass: string;
    FStyleAppearance: string;
    FOnNewButton: TSTBNewButtonEvent;
    FOnButtonClick: TSTBButtonEvent;
    procedure SetImages(const Value: TCustomImageList);
    procedure SetButtonWidth(const Value: Single);
    procedure SetButtonHeight(const Value: Single);
    procedure SetShowCaptions(const Value: Boolean);
    procedure SetFlat(const Value: Boolean);
    procedure SetOrientation(const Value: TOrientation);
    procedure SetStyleFamily(const Value: string);
    procedure SetStyleClass(const Value: string);
    procedure SetStyleAppearance(const Value: string);
    procedure UpdateButtonsSize;
    procedure UpdateButtonsStyle;
    function GetButton(Index: Integer): TFMXStyledToolButton;
    function GetButtonCount: Integer;
  protected
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
    procedure DoRealign; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoButtonClick(AButton: TFMXStyledToolButton); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddButton: TFMXStyledToolButton;
    function InsertButton(AIndex: Integer): TFMXStyledToolButton;
    procedure RemoveButton(AButton: TFMXStyledToolButton);
    procedure ClearButtons;
    procedure UpdateButtons;
    property Buttons[Index: Integer]: TFMXStyledToolButton read GetButton;
    property ButtonCount: Integer read GetButtonCount;
  published
    property Align;
    property Anchors;
    property AutoSize: Boolean read FAutoSize write FAutoSize default False;
    property ButtonHeight: Single read FButtonHeight write SetButtonHeight;
    property ButtonWidth: Single read FButtonWidth write SetButtonWidth;
    property ClipChildren default False;
    property ClipParent default False;
    property Cursor default crDefault;
    property DesignVisible default True;
    property DragMode default TDragMode.dmManual;
    property EnableDragHighlight default True;
    property Enabled default True;
    property Flat: Boolean read FFlat write SetFlat default True;
    property Height;
    property HitTest default True;
    property Images: TCustomImageList read FImages write SetImages;
    property Locked default False;
    property Margins;
    property Opacity;
    property Orientation: TOrientation read FOrientation write SetOrientation default TOrientation.Horizontal;
    property Padding;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions default True;
    property Size;
    property StyleFamily: string read FStyleFamily write SetStyleFamily;
    property StyleClass: string read FStyleClass write SetStyleClass;
    property StyleAppearance: string read FStyleAppearance write SetStyleAppearance;
    property TabOrder;
    property TabStop;
    property TouchTargetExpansion;
    property Visible default True;
    property Width;
    property OnButtonClick: TSTBButtonEvent read FOnButtonClick write FOnButtonClick;
    property OnNewButton: TSTBNewButtonEvent read FOnNewButton write FOnNewButton;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnPainting;
    property OnPaint;
    property OnResize;
  end;

procedure Register;

implementation

uses
  System.Math.Vectors;

procedure Register;
begin
  RegisterComponents('Styled FMX', [TFMXStyledToolbar, TFMXStyledToolButton]);
end;

{ TFMXStyledToolButton }

constructor TFMXStyledToolButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoSize := False;
  FGrouped := False;
  FMarked := False;
  FStyle := tbsButton;
  FImageAlignment := TImageAlignment.Center;
  FSortOrder := DEFAULT_SORT_ORDER;
  FWrap := False;
  Width := DEFAULT_TOOLBUTTON_WIDTH;
  Height := DEFAULT_TOOLBUTTON_HEIGHT;
end;

destructor TFMXStyledToolButton.Destroy;
begin
  if Assigned(FSeparatorLine) then
    FreeAndNil(FSeparatorLine);
  inherited;
end;

function TFMXStyledToolButton.GetIndex: Integer;
var
  LToolbar: TFMXStyledToolbar;
begin
  Result := -1;
  LToolbar := GetToolbar;
  if Assigned(LToolbar) then
    Result := LToolbar.FButtons.IndexOf(Self);
end;

function TFMXStyledToolButton.GetToolbar: TFMXStyledToolbar;
begin
  if Parent is TFMXStyledToolbar then
    Result := TFMXStyledToolbar(Parent)
  else
    Result := nil;
end;

function TFMXStyledToolButton.IsSeparator: Boolean;
begin
  Result := FStyle = tbsSeparator;
end;

function TFMXStyledToolButton.IsDivider: Boolean;
begin
  Result := FStyle = tbsDivider;
end;

procedure TFMXStyledToolButton.SetGrouped(const AValue: Boolean);
begin
  if FGrouped <> AValue then
  begin
    FGrouped := AValue;
    if FGrouped then
    begin
      // In grouped mode, buttons act like radio buttons
      if FStyle = tbsButton then
        FStyle := tbsCheck;
    end;
  end;
end;

procedure TFMXStyledToolButton.SetImageAlignment(const AValue: TImageAlignment);
begin
  if FImageAlignment <> AValue then
  begin
    FImageAlignment := AValue;
    UpdateButtonContent;
  end;
end;

procedure TFMXStyledToolButton.SetMarked(const AValue: Boolean);
begin
  if FMarked <> AValue then
  begin
    FMarked := AValue;
    Repaint;
  end;
end;

procedure TFMXStyledToolButton.SetMenuItem(const AValue: TMenuItem);
begin
  if FMenuItem <> AValue then
  begin
    FMenuItem := AValue;
    if Assigned(FMenuItem) then
    begin
      Text := FMenuItem.Text;
      Enabled := FMenuItem.Enabled;
      Visible := FMenuItem.Visible;
    end;
  end;
end;

procedure TFMXStyledToolButton.SetParent(const Value: TFmxObject);
begin
  inherited;
  if Value is TFMXStyledToolbar then
    UpdateButtonContent;
end;

procedure TFMXStyledToolButton.SetStyle(const AValue: TToolButtonStyle);
begin
  if FStyle <> AValue then
  begin
    FStyle := AValue;
    UpdateButtonContent;
    UpdateSeparator;
  end;
end;

procedure TFMXStyledToolButton.SetWrap(const AValue: Boolean);
var
  LToolbar: TFMXStyledToolbar;
begin
  if FWrap <> AValue then
  begin
    FWrap := AValue;
    LToolbar := GetToolbar;
    if Assigned(LToolbar) then
      LToolbar.Realign;
  end;
end;

procedure TFMXStyledToolButton.UpdateButtonContent;
var
  LToolbar: TFMXStyledToolbar;
begin
  LToolbar := GetToolbar;
  if not Assigned(LToolbar) then
    Exit;

  // Update visibility based on style
  if IsSeparator or IsDivider then
  begin
    Text := '';
    Visible := True;
    HitTest := False;
  end
  else
  begin
    HitTest := True;
    if not LToolbar.ShowCaptions then
      Text := '';
  end;
end;

procedure TFMXStyledToolButton.UpdateSeparator;
begin
  if IsDivider then
  begin
    if not Assigned(FSeparatorLine) then
    begin
      FSeparatorLine := TLine.Create(Self);
      FSeparatorLine.Parent := Self;
      FSeparatorLine.Stored := False;
      FSeparatorLine.HitTest := False;
    end;

    // Update separator line position
    if Assigned(GetToolbar) and (GetToolbar.Orientation = TOrientation.Horizontal) then
    begin
      FSeparatorLine.Position.X := Width / 2;
      FSeparatorLine.Position.Y := 4;
      FSeparatorLine.Width := 1;
      FSeparatorLine.Height := Height - 8;
      FSeparatorLine.LineType := TLineType.Top;
    end
    else
    begin
      FSeparatorLine.Position.X := 4;
      FSeparatorLine.Position.Y := Height / 2;
      FSeparatorLine.Width := Width - 8;
      FSeparatorLine.Height := 1;
      FSeparatorLine.LineType := TLineType.Left;
    end;

    FSeparatorLine.Stroke.Color := $FF808080;
    FSeparatorLine.Visible := True;
  end
  else if Assigned(FSeparatorLine) then
  begin
    FreeAndNil(FSeparatorLine);
  end;
end;

procedure TFMXStyledToolButton.DoRealign;
begin
  inherited;
  UpdateSeparator;
end;

procedure TFMXStyledToolButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FMenuItem) then
    FMenuItem := nil;
end;

{ TFMXStyledToolbar }

constructor TFMXStyledToolbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtons := TList.Create;
  FButtonWidth := DEFAULT_TOOLBUTTON_WIDTH;
  FButtonHeight := DEFAULT_TOOLBUTTON_HEIGHT;
  FShowCaptions := True;
  FFlat := True;
  FAutoSize := False;
  FOrientation := TOrientation.Horizontal;
  FStyleFamily := 'Material';
  FStyleClass := '';
  FStyleAppearance := '';

  Width := 400;
  Height := DEFAULT_TOOLBUTTON_HEIGHT + 8;
  ClipChildren := False;
end;

destructor TFMXStyledToolbar.Destroy;
begin
  ClearButtons;
  FreeAndNil(FButtons);
  inherited;
end;

function TFMXStyledToolbar.AddButton: TFMXStyledToolButton;
begin
  Result := TFMXStyledToolButton.Create(Self);
  Result.Parent := Self;
  Result.Stored := False;

  // Apply toolbar settings
  Result.Width := FButtonWidth;
  Result.Height := FButtonHeight;

  if Assigned(FOnNewButton) then
    FOnNewButton(Self, FButtons.Count - 1, Result);
end;

function TFMXStyledToolbar.InsertButton(AIndex: Integer): TFMXStyledToolButton;
begin
  Result := TFMXStyledToolButton.Create(Self);
  Result.Parent := Self;
  Result.Stored := False;

  // Apply toolbar settings
  Result.Width := FButtonWidth;
  Result.Height := FButtonHeight;

  if (AIndex >= 0) and (AIndex < FButtons.Count) then
  begin
    FButtons.Insert(AIndex, Result);
    Realign;
  end;

  if Assigned(FOnNewButton) then
    FOnNewButton(Self, AIndex, Result);
end;

procedure TFMXStyledToolbar.RemoveButton(AButton: TFMXStyledToolButton);
begin
  if Assigned(AButton) and (FButtons.IndexOf(AButton) >= 0) then
  begin
    FButtons.Remove(AButton);
    AButton.Parent := nil;
    AButton.Free;
    Realign;
  end;
end;

procedure TFMXStyledToolbar.ClearButtons;
var
  I: Integer;
begin
  for I := FButtons.Count - 1 downto 0 do
  begin
    TFMXStyledToolButton(FButtons[I]).Free;
  end;
  FButtons.Clear;
end;

procedure TFMXStyledToolbar.UpdateButtons;
begin
  UpdateButtonsSize;
  UpdateButtonsStyle;
  Realign;
end;

function TFMXStyledToolbar.GetButton(Index: Integer): TFMXStyledToolButton;
begin
  if (Index >= 0) and (Index < FButtons.Count) then
    Result := TFMXStyledToolButton(FButtons[Index])
  else
    Result := nil;
end;

function TFMXStyledToolbar.GetButtonCount: Integer;
begin
  Result := FButtons.Count;
end;

procedure TFMXStyledToolbar.DoAddObject(const AObject: TFmxObject);
begin
  inherited;
  if (AObject is TFMXStyledToolButton) and (FButtons.IndexOf(AObject) < 0) then
  begin
    FButtons.Add(AObject);
    UpdateButtonsStyle;
  end;
end;

procedure TFMXStyledToolbar.DoRemoveObject(const AObject: TFmxObject);
begin
  if AObject is TFMXStyledToolButton then
    FButtons.Remove(AObject);
  inherited;
end;

procedure TFMXStyledToolbar.DoRealign;
var
  I: Integer;
  LButton: TFMXStyledToolButton;
  LCurrentPos: Single;
  LMaxSize: Single;
  LRowStart: Single;
begin
  inherited;

  if FButtons.Count = 0 then
    Exit;

  LCurrentPos := Padding.Left;
  LRowStart := Padding.Top;
  LMaxSize := 0;

  for I := 0 to FButtons.Count - 1 do
  begin
    LButton := TFMXStyledToolButton(FButtons[I]);
    if not LButton.Visible then
      Continue;

    if FOrientation = TOrientation.Horizontal then
    begin
      // Check if we need to wrap to next row
      if LButton.Wrap and (I > 0) then
      begin
        LCurrentPos := Padding.Left;
        LRowStart := LRowStart + LMaxSize + 4;
        LMaxSize := 0;
      end;

      LButton.Position.X := LCurrentPos;
      LButton.Position.Y := LRowStart;

      if LButton.IsSeparator then
        LCurrentPos := LCurrentPos + DEFAULT_TOOLBUTTON_SEP_WIDTH
      else
        LCurrentPos := LCurrentPos + LButton.Width + 2;

      LMaxSize := Max(LMaxSize, LButton.Height);
    end
    else // Vertical
    begin
      LButton.Position.X := Padding.Left;
      LButton.Position.Y := LCurrentPos;

      if LButton.IsSeparator then
        LCurrentPos := LCurrentPos + DEFAULT_TOOLBUTTON_SEP_WIDTH
      else
        LCurrentPos := LCurrentPos + LButton.Height + 2;
    end;
  end;

  // Auto-size if enabled
  if FAutoSize then
  begin
    if FOrientation = TOrientation.Horizontal then
      Height := LRowStart + LMaxSize + Padding.Bottom
    else
      Width := FButtonWidth + Padding.Left + Padding.Right;
  end;
end;

procedure TFMXStyledToolbar.DoButtonClick(AButton: TFMXStyledToolButton);
begin
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self, AButton);
end;

procedure TFMXStyledToolbar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImages) then
    FImages := nil;
end;

procedure TFMXStyledToolbar.SetButtonHeight(const Value: Single);
var
  I: Integer;
begin
  if FButtonHeight <> Value then
  begin
    FButtonHeight := Value;
    for I := 0 to FButtons.Count - 1 do
      TFMXStyledToolButton(FButtons[I]).Height := Value;
    Realign;
  end;
end;

procedure TFMXStyledToolbar.SetButtonWidth(const Value: Single);
var
  I: Integer;
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    for I := 0 to FButtons.Count - 1 do
      TFMXStyledToolButton(FButtons[I]).Width := Value;
    Realign;
  end;
end;

procedure TFMXStyledToolbar.SetFlat(const Value: Boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    UpdateButtonsStyle;
  end;
end;

procedure TFMXStyledToolbar.SetImages(const Value: TCustomImageList);
var
  I: Integer;
begin
  if FImages <> Value then
  begin
    FImages := Value;
    for I := 0 to FButtons.Count - 1 do
      TFMXStyledToolButton(FButtons[I]).Images := Value;
  end;
end;

procedure TFMXStyledToolbar.SetOrientation(const Value: TOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    Realign;
  end;
end;

procedure TFMXStyledToolbar.SetShowCaptions(const Value: Boolean);
var
  I: Integer;
begin
  if FShowCaptions <> Value then
  begin
    FShowCaptions := Value;
    for I := 0 to FButtons.Count - 1 do
      TFMXStyledToolButton(FButtons[I]).UpdateButtonContent;
    Realign;
  end;
end;

procedure TFMXStyledToolbar.SetStyleAppearance(const Value: string);
begin
  if FStyleAppearance <> Value then
  begin
    FStyleAppearance := Value;
    UpdateButtonsStyle;
  end;
end;

procedure TFMXStyledToolbar.SetStyleClass(const Value: string);
begin
  if FStyleClass <> Value then
  begin
    FStyleClass := Value;
    UpdateButtonsStyle;
  end;
end;

procedure TFMXStyledToolbar.SetStyleFamily(const Value: string);
begin
  if FStyleFamily <> Value then
  begin
    FStyleFamily := Value;
    UpdateButtonsStyle;
  end;
end;

procedure TFMXStyledToolbar.UpdateButtonsSize;
var
  I: Integer;
begin
  for I := 0 to FButtons.Count - 1 do
  begin
    TFMXStyledToolButton(FButtons[I]).Width := FButtonWidth;
    TFMXStyledToolButton(FButtons[I]).Height := FButtonHeight;
  end;
end;

procedure TFMXStyledToolbar.UpdateButtonsStyle;
var
  I: Integer;
  LButton: TFMXStyledToolButton;
begin
  for I := 0 to FButtons.Count - 1 do
  begin
    LButton := TFMXStyledToolButton(FButtons[I]);
    // Apply toolbar style settings to each button
    // This can be extended with StyleFamily, StyleClass, StyleAppearance
    LButton.UpdateButtonContent;
  end;
end;

end.
