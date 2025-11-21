{******************************************************************************}
{                                                                              }
{  FMX.StyledButtonGroup: Multi-platform Styled Button Group                  }
{  Adapted from VCL StyledButtonGroup for FireMonkey                          }
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
unit FMX.StyledButtonGroup;

interface

{$I StyledComponents.FMX.inc}

uses
  System.UITypes,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Math,
  System.Generics.Collections,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  FMX.Graphics,
  FMX.ImgList,
  FMX.Objects,
  FMX.StyledButton;

const
  DEFAULT_BUTTON_HEIGHT = 44;
  DEFAULT_BUTTON_SPACING = 4;

type
  EFMXStyledButtonGroupError = Exception;

  TFMXStyledButtonGroup = class;
  TFMXButtonGroupItem = class;

  TButtonGroupLayout = (bglVertical, bglHorizontal);

  TFMXButtonGroupClickEvent = procedure(Sender: TObject; Index: Integer) of object;

  { TFMXButtonGroupItem }
  TFMXButtonGroupItem = class(TCollectionItem)
  private
    FCaption: string;
    FHint: string;
    FImageIndex: Integer;
    FEnabled: Boolean;
    FVisible: Boolean;
    FData: TObject;
    FTag: NativeInt;
    procedure SetCaption(const Value: string);
    procedure SetHint(const Value: string);
    procedure SetImageIndex(const Value: Integer);
    procedure SetEnabled(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
  protected
    function GetDisplayName: string; override;
    procedure Changed;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    property Data: TObject read FData write FData;
  published
    property Caption: string read FCaption write SetCaption;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Hint: string read FHint write SetHint;
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
    property Tag: NativeInt read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

  { TFMXButtonGroupItems }
  TFMXButtonGroupItems = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TFMXButtonGroupItem;
    procedure SetItem(Index: Integer; const Value: TFMXButtonGroupItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TFMXButtonGroupItem;
    function Insert(Index: Integer): TFMXButtonGroupItem;
    property Items[Index: Integer]: TFMXButtonGroupItem read GetItem write SetItem; default;
  end;

  { TFMXStyledButtonGroup }
  TFMXStyledButtonGroup = class(TLayout)
  private
    FItems: TFMXButtonGroupItems;
    FButtons: TList<TFMXStyledButton>;
    FImages: TCustomImageList;
    FItemIndex: Integer;
    FButtonHeight: Single;
    FButtonSpacing: Single;
    FLayout: TButtonGroupLayout;
    FStyleFamily: string;
    FStyleClass: string;
    FStyleAppearance: string;
    FOnButtonClick: TFMXButtonGroupClickEvent;
    procedure SetItems(const Value: TFMXButtonGroupItems);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetItemIndex(const Value: Integer);
    procedure SetButtonHeight(const Value: Single);
    procedure SetButtonSpacing(const Value: Single);
    procedure SetLayout(const Value: TButtonGroupLayout);
    procedure SetStyleFamily(const Value: string);
    procedure SetStyleClass(const Value: string);
    procedure SetStyleAppearance(const Value: string);
    procedure ItemButtonClick(Sender: TObject);
    procedure RebuildButtons;
    procedure UpdateButtonSelection;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoRealign; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateButtons;
  published
    property Align;
    property Anchors;
    property ButtonHeight: Single read FButtonHeight write SetButtonHeight;
    property ButtonSpacing: Single read FButtonSpacing write SetButtonSpacing;
    property ClipChildren default False;
    property ClipParent default False;
    property Cursor default crDefault;
    property DesignVisible default True;
    property DragMode default TDragMode.dmManual;
    property EnableDragHighlight default True;
    property Enabled default True;
    property Height;
    property HitTest default True;
    property Images: TCustomImageList read FImages write SetImages;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TFMXButtonGroupItems read FItems write SetItems;
    property Layout: TButtonGroupLayout read FLayout write SetLayout default bglVertical;
    property Locked default False;
    property Margins;
    property Opacity;
    property Padding;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property StyleAppearance: string read FStyleAppearance write SetStyleAppearance;
    property StyleClass: string read FStyleClass write SetStyleClass;
    property StyleFamily: string read FStyleFamily write SetStyleFamily;
    property TabOrder;
    property TabStop;
    property TouchTargetExpansion;
    property Visible default True;
    property Width;
    property OnButtonClick: TFMXButtonGroupClickEvent read FOnButtonClick write FOnButtonClick;
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

procedure Register;
begin
  RegisterComponents('Styled FMX', [TFMXStyledButtonGroup]);
end;

{ TFMXButtonGroupItem }

constructor TFMXButtonGroupItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FCaption := 'Button ' + IntToStr(Index);
  FHint := '';
  FImageIndex := -1;
  FEnabled := True;
  FVisible := True;
  FData := nil;
  FTag := 0;
end;

procedure TFMXButtonGroupItem.Assign(Source: TPersistent);
begin
  if Source is TFMXButtonGroupItem then
  begin
    FCaption := TFMXButtonGroupItem(Source).Caption;
    FHint := TFMXButtonGroupItem(Source).Hint;
    FImageIndex := TFMXButtonGroupItem(Source).ImageIndex;
    FEnabled := TFMXButtonGroupItem(Source).Enabled;
    FVisible := TFMXButtonGroupItem(Source).Visible;
    FTag := TFMXButtonGroupItem(Source).Tag;
    Changed;
  end
  else
    inherited Assign(Source);
end;

procedure TFMXButtonGroupItem.Changed;
begin
  if Assigned(Collection) then
    TFMXButtonGroupItems(Collection).Update(Self);
end;

function TFMXButtonGroupItem.GetDisplayName: string;
begin
  if FCaption <> '' then
    Result := FCaption
  else
    Result := inherited GetDisplayName;
end;

procedure TFMXButtonGroupItem.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed;
  end;
end;

procedure TFMXButtonGroupItem.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed;
  end;
end;

procedure TFMXButtonGroupItem.SetHint(const Value: string);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    Changed;
  end;
end;

procedure TFMXButtonGroupItem.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed;
  end;
end;

procedure TFMXButtonGroupItem.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed;
  end;
end;

{ TFMXButtonGroupItems }

constructor TFMXButtonGroupItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TFMXButtonGroupItem);
end;

function TFMXButtonGroupItems.Add: TFMXButtonGroupItem;
begin
  Result := TFMXButtonGroupItem(inherited Add);
end;

function TFMXButtonGroupItems.Insert(Index: Integer): TFMXButtonGroupItem;
begin
  Result := TFMXButtonGroupItem(inherited Insert(Index));
end;

function TFMXButtonGroupItems.GetItem(Index: Integer): TFMXButtonGroupItem;
begin
  Result := TFMXButtonGroupItem(inherited GetItem(Index));
end;

procedure TFMXButtonGroupItems.SetItem(Index: Integer; const Value: TFMXButtonGroupItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TFMXButtonGroupItems.Update(Item: TCollectionItem);
begin
  inherited;
  if Owner is TFMXStyledButtonGroup then
    TFMXStyledButtonGroup(Owner).UpdateButtons;
end;

{ TFMXStyledButtonGroup }

constructor TFMXStyledButtonGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TFMXButtonGroupItems.Create(Self);
  FButtons := TList<TFMXStyledButton>.Create;
  FItemIndex := -1;
  FButtonHeight := DEFAULT_BUTTON_HEIGHT;
  FButtonSpacing := DEFAULT_BUTTON_SPACING;
  FLayout := bglVertical;
  FStyleFamily := 'Material';
  FStyleClass := '';
  FStyleAppearance := '';

  Width := 200;
  Height := 300;
  ClipChildren := False;
end;

destructor TFMXStyledButtonGroup.Destroy;
begin
  FreeAndNil(FButtons);
  FreeAndNil(FItems);
  inherited;
end;

procedure TFMXStyledButtonGroup.ItemButtonClick(Sender: TObject);
var
  I: Integer;
  LButton: TFMXStyledButton;
begin
  if Sender is TFMXStyledButton then
  begin
    LButton := TFMXStyledButton(Sender);
    I := FButtons.IndexOf(LButton);
    if I >= 0 then
    begin
      FItemIndex := I;
      UpdateButtonSelection;

      if Assigned(FOnButtonClick) then
        FOnButtonClick(Self, I);
    end;
  end;
end;

procedure TFMXStyledButtonGroup.RebuildButtons;
var
  I: Integer;
  LButton: TFMXStyledButton;
  LItem: TFMXButtonGroupItem;
  LCurrentPos: Single;
begin
  // Clear existing buttons
  for I := FButtons.Count - 1 downto 0 do
  begin
    FButtons[I].Free;
  end;
  FButtons.Clear;

  // Create new buttons
  LCurrentPos := Padding.Top;

  for I := 0 to FItems.Count - 1 do
  begin
    LItem := FItems[I];
    if not LItem.Visible then
      Continue;

    LButton := TFMXStyledButton.Create(Self);
    LButton.Parent := Self;
    LButton.Stored := False;
    LButton.Text := LItem.Caption;
    LButton.Hint := LItem.Hint;
    LButton.ShowHint := LItem.Hint <> '';
    LButton.Enabled := LItem.Enabled;
    LButton.Tag := I;
    LButton.OnClick := ItemButtonClick;

    // Set images if available
    if Assigned(FImages) and (LItem.ImageIndex >= 0) then
    begin
      LButton.Images := FImages;
      LButton.ImageIndex := LItem.ImageIndex;
    end;

    // Position and size
    if FLayout = bglVertical then
    begin
      LButton.Position.X := Padding.Left;
      LButton.Position.Y := LCurrentPos;
      LButton.Width := Width - Padding.Left - Padding.Right;
      LButton.Height := FButtonHeight;
      LButton.Align := TAlignLayout.Top;

      LCurrentPos := LCurrentPos + FButtonHeight + FButtonSpacing;
    end
    else // Horizontal
    begin
      LButton.Position.X := LCurrentPos;
      LButton.Position.Y := Padding.Top;
      LButton.Width := (Width - Padding.Left - Padding.Right - (FItems.Count - 1) * FButtonSpacing) / FItems.Count;
      LButton.Height := FButtonHeight;

      LCurrentPos := LCurrentPos + LButton.Width + FButtonSpacing;
    end;

    FButtons.Add(LButton);
  end;

  UpdateButtonSelection;
end;

procedure TFMXStyledButtonGroup.UpdateButtons;
begin
  RebuildButtons;
end;

procedure TFMXStyledButtonGroup.UpdateButtonSelection;
var
  I: Integer;
begin
  for I := 0 to FButtons.Count - 1 do
  begin
    if I = FItemIndex then
    begin
      FButtons[I].IsPressed := True;
      FButtons[I].StyleDrawType := btRounded;
    end
    else
    begin
      FButtons[I].IsPressed := False;
      FButtons[I].StyleDrawType := btRoundRect;
    end;
  end;
end;

procedure TFMXStyledButtonGroup.DoRealign;
begin
  inherited;
  // Update layout if needed
end;

procedure TFMXStyledButtonGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImages) then
    FImages := nil;
end;

procedure TFMXStyledButtonGroup.SetButtonHeight(const Value: Single);
begin
  if FButtonHeight <> Value then
  begin
    FButtonHeight := Value;
    RebuildButtons;
  end;
end;

procedure TFMXStyledButtonGroup.SetButtonSpacing(const Value: Single);
begin
  if FButtonSpacing <> Value then
  begin
    FButtonSpacing := Value;
    RebuildButtons;
  end;
end;

procedure TFMXStyledButtonGroup.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    RebuildButtons;
  end;
end;

procedure TFMXStyledButtonGroup.SetItemIndex(const Value: Integer);
begin
  if FItemIndex <> Value then
  begin
    if (Value >= -1) and (Value < FItems.Count) then
    begin
      FItemIndex := Value;
      UpdateButtonSelection;
    end;
  end;
end;

procedure TFMXStyledButtonGroup.SetItems(const Value: TFMXButtonGroupItems);
begin
  FItems.Assign(Value);
end;

procedure TFMXStyledButtonGroup.SetLayout(const Value: TButtonGroupLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    RebuildButtons;
  end;
end;

procedure TFMXStyledButtonGroup.SetStyleAppearance(const Value: string);
var
  I: Integer;
begin
  if FStyleAppearance <> Value then
  begin
    FStyleAppearance := Value;
    for I := 0 to FButtons.Count - 1 do
    begin
      // Apply style appearance to buttons
      // This would be extended with actual style application
    end;
  end;
end;

procedure TFMXStyledButtonGroup.SetStyleClass(const Value: string);
var
  I: Integer;
begin
  if FStyleClass <> Value then
  begin
    FStyleClass := Value;
    for I := 0 to FButtons.Count - 1 do
    begin
      // Apply style class to buttons
      // This would be extended with actual style application
    end;
  end;
end;

procedure TFMXStyledButtonGroup.SetStyleFamily(const Value: string);
var
  I: Integer;
begin
  if FStyleFamily <> Value then
  begin
    FStyleFamily := Value;
    for I := 0 to FButtons.Count - 1 do
    begin
      // Apply style family to buttons
      // This would be extended with actual style application
    end;
  end;
end;

end.
