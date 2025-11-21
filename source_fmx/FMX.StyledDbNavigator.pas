{******************************************************************************}
{                                                                              }
{  FMX.StyledDbNavigator: Multi-platform Database Navigator                   }
{  Adapted from VCL StyledDbNavigator for FireMonkey                          }
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
unit FMX.StyledDbNavigator;

interface

{$I StyledComponents.FMX.inc}

uses
  System.UITypes,
  System.SysUtils,
  System.Types,
  System.Classes,
  Data.DB,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  FMX.Graphics,
  FMX.ImgList,
  FMX.Bind.Navigator,
  FMX.StyledButton;

const
  DEFAULT_NAV_BUTTON_WIDTH = 44;
  DEFAULT_NAV_BUTTON_HEIGHT = 44;

type
  TFMXNavigateBtn = (nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete,
    nbEdit, nbPost, nbCancel, nbRefresh);
  TFMXNavigateButtons = set of TFMXNavigateBtn;

  TFMXStyledDbNavigator = class;

  TFMXNavButtonClickEvent = procedure(Sender: TObject; Button: TFMXNavigateBtn) of object;

  { TFMXStyledDbNavigator }
  TFMXStyledDbNavigator = class(TLayout)
  private
    FDataSource: TDataSource;
    FVisibleButtons: TFMXNavigateButtons;
    FButtons: array[TFMXNavigateBtn] of TFMXStyledButton;
    FHints: TStrings;
    FConfirmDelete: Boolean;
    FShowCaptions: Boolean;
    FOrientation: TOrientation;
    FButtonWidth: Single;
    FButtonHeight: Single;
    FStyleFamily: string;
    FStyleClass: string;
    FStyleAppearance: string;
    FOnButtonClick: TFMXNavButtonClickEvent;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetVisibleButtons(const Value: TFMXNavigateButtons);
    procedure SetHints(const Value: TStrings);
    procedure SetShowCaptions(const Value: Boolean);
    procedure SetOrientation(const Value: TOrientation);
    procedure SetButtonWidth(const Value: Single);
    procedure SetButtonHeight(const Value: Single);
    procedure SetStyleFamily(const Value: string);
    procedure SetStyleClass(const Value: string);
    procedure SetStyleAppearance(const Value: string);
    procedure DataChanged;
    procedure EditingChanged;
    procedure ActiveChanged;
    procedure ButtonClick(Sender: TObject);
    procedure CreateButtons;
    procedure UpdateButtonsState;
    procedure UpdateButtonsLayout;
    procedure InitHints;
    function GetButtonCaption(Button: TFMXNavigateBtn): string;
    function GetButtonHint(Button: TFMXNavigateBtn): string;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoRealign; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BtnClick(Button: TFMXNavigateBtn); virtual;
  published
    property Align;
    property Anchors;
    property ButtonHeight: Single read FButtonHeight write SetButtonHeight;
    property ButtonWidth: Single read FButtonWidth write SetButtonWidth;
    property ClipChildren default False;
    property ClipParent default False;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property Cursor default crDefault;
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property DesignVisible default True;
    property DragMode default TDragMode.dmManual;
    property EnableDragHighlight default True;
    property Enabled default True;
    property Height;
    property Hints: TStrings read FHints write SetHints;
    property HitTest default True;
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
    property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions default False;
    property Size;
    property StyleAppearance: string read FStyleAppearance write SetStyleAppearance;
    property StyleClass: string read FStyleClass write SetStyleClass;
    property StyleFamily: string read FStyleFamily write SetStyleFamily;
    property TabOrder;
    property TabStop;
    property TouchTargetExpansion;
    property Visible default True;
    property VisibleButtons: TFMXNavigateButtons read FVisibleButtons write SetVisibleButtons default [nbFirst..nbRefresh];
    property Width;
    property OnButtonClick: TFMXNavButtonClickEvent read FOnButtonClick write FOnButtonClick;
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
  FMX.Dialogs;

procedure Register;
begin
  RegisterComponents('Styled FMX', [TFMXStyledDbNavigator]);
end;

{ TFMXStyledDbNavigator }

constructor TFMXStyledDbNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisibleButtons := [nbFirst..nbRefresh];
  FHints := TStringList.Create;
  FConfirmDelete := True;
  FShowCaptions := False;
  FOrientation := TOrientation.Horizontal;
  FButtonWidth := DEFAULT_NAV_BUTTON_WIDTH;
  FButtonHeight := DEFAULT_NAV_BUTTON_HEIGHT;
  FStyleFamily := 'Material';
  FStyleClass := '';
  FStyleAppearance := '';

  Width := 440;
  Height := DEFAULT_NAV_BUTTON_HEIGHT + 8;
  ClipChildren := False;

  CreateButtons;
  InitHints;
end;

destructor TFMXStyledDbNavigator.Destroy;
begin
  FreeAndNil(FHints);
  inherited;
end;

procedure TFMXStyledDbNavigator.InitHints;
begin
  FHints.Clear;
  FHints.Add('First record');    // nbFirst
  FHints.Add('Prior record');    // nbPrior
  FHints.Add('Next record');     // nbNext
  FHints.Add('Last record');     // nbLast
  FHints.Add('Insert record');   // nbInsert
  FHints.Add('Delete record');   // nbDelete
  FHints.Add('Edit record');     // nbEdit
  FHints.Add('Post edit');       // nbPost
  FHints.Add('Cancel edit');     // nbCancel
  FHints.Add('Refresh data');    // nbRefresh
end;

procedure TFMXStyledDbNavigator.CreateButtons;
var
  LBtn: TFMXNavigateBtn;
  LButton: TFMXStyledButton;
  LCurrentPos: Single;
begin
  LCurrentPos := Padding.Left;

  for LBtn := Low(TFMXNavigateBtn) to High(TFMXNavigateBtn) do
  begin
    LButton := TFMXStyledButton.Create(Self);
    LButton.Parent := Self;
    LButton.Stored := False;
    LButton.Width := FButtonWidth;
    LButton.Height := FButtonHeight;
    LButton.Tag := Ord(LBtn);
    LButton.OnClick := ButtonClick;
    LButton.Text := GetButtonCaption(LBtn);
    LButton.Hint := GetButtonHint(LBtn);
    LButton.ShowHint := True;

    if FOrientation = TOrientation.Horizontal then
    begin
      LButton.Position.X := LCurrentPos;
      LButton.Position.Y := Padding.Top;
      LCurrentPos := LCurrentPos + FButtonWidth + 2;
    end
    else
    begin
      LButton.Position.X := Padding.Left;
      LButton.Position.Y := LCurrentPos;
      LCurrentPos := LCurrentPos + FButtonHeight + 2;
    end;

    LButton.Visible := LBtn in FVisibleButtons;
    FButtons[LBtn] := LButton;
  end;

  UpdateButtonsState;
end;

function TFMXStyledDbNavigator.GetButtonCaption(Button: TFMXNavigateBtn): string;
begin
  if not FShowCaptions then
  begin
    Result := '';
    Exit;
  end;

  case Button of
    nbFirst: Result := '|◀';
    nbPrior: Result := '◀';
    nbNext: Result := '▶';
    nbLast: Result := '▶|';
    nbInsert: Result := '+';
    nbDelete: Result := '×';
    nbEdit: Result := '✎';
    nbPost: Result := '✓';
    nbCancel: Result := '✕';
    nbRefresh: Result := '⟳';
  else
    Result := '';
  end;
end;

function TFMXStyledDbNavigator.GetButtonHint(Button: TFMXNavigateBtn): string;
var
  LIndex: Integer;
begin
  LIndex := Ord(Button);
  if (LIndex >= 0) and (LIndex < FHints.Count) then
    Result := FHints[LIndex]
  else
    Result := '';
end;

procedure TFMXStyledDbNavigator.ButtonClick(Sender: TObject);
var
  LButton: TFMXNavigateBtn;
begin
  if Sender is TFMXStyledButton then
  begin
    LButton := TFMXNavigateBtn(TFMXStyledButton(Sender).Tag);
    BtnClick(LButton);
  end;
end;

procedure TFMXStyledDbNavigator.BtnClick(Button: TFMXNavigateBtn);
begin
  if not Assigned(FDataSource) or not Assigned(FDataSource.DataSet) then
    Exit;

  if not FDataSource.DataSet.Active then
    Exit;

  case Button of
    nbFirst: FDataSource.DataSet.First;
    nbPrior: FDataSource.DataSet.Prior;
    nbNext: FDataSource.DataSet.Next;
    nbLast: FDataSource.DataSet.Last;
    nbInsert: FDataSource.DataSet.Insert;
    nbDelete:
      begin
        if FConfirmDelete then
        begin
          if MessageDlg('Delete record?', TMsgDlgType.mtConfirmation,
            [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
            FDataSource.DataSet.Delete;
        end
        else
          FDataSource.DataSet.Delete;
      end;
    nbEdit: FDataSource.DataSet.Edit;
    nbPost: FDataSource.DataSet.Post;
    nbCancel: FDataSource.DataSet.Cancel;
    nbRefresh: FDataSource.DataSet.Refresh;
  end;

  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self, Button);
end;

procedure TFMXStyledDbNavigator.DataChanged;
begin
  UpdateButtonsState;
end;

procedure TFMXStyledDbNavigator.EditingChanged;
begin
  UpdateButtonsState;
end;

procedure TFMXStyledDbNavigator.ActiveChanged;
begin
  UpdateButtonsState;
end;

procedure TFMXStyledDbNavigator.UpdateButtonsState;
var
  LUpEnable, LDownEnable: Boolean;
  LDataSet: TDataSet;
begin
  LUpEnable := False;
  LDownEnable := False;

  if Assigned(FDataSource) and Assigned(FDataSource.DataSet) then
  begin
    LDataSet := FDataSource.DataSet;
    if LDataSet.Active then
    begin
      LUpEnable := not LDataSet.BOF;
      LDownEnable := not LDataSet.EOF;
    end;
  end;

  // Navigation buttons
  if Assigned(FButtons[nbFirst]) then
    FButtons[nbFirst].Enabled := LUpEnable;
  if Assigned(FButtons[nbPrior]) then
    FButtons[nbPrior].Enabled := LUpEnable;
  if Assigned(FButtons[nbNext]) then
    FButtons[nbNext].Enabled := LDownEnable;
  if Assigned(FButtons[nbLast]) then
    FButtons[nbLast].Enabled := LDownEnable;

  // Edit buttons
  if Assigned(FDataSource) and Assigned(FDataSource.DataSet) then
  begin
    LDataSet := FDataSource.DataSet;
    if Assigned(FButtons[nbInsert]) then
      FButtons[nbInsert].Enabled := LDataSet.Active and LDataSet.CanModify;
    if Assigned(FButtons[nbDelete]) then
      FButtons[nbDelete].Enabled := LDataSet.Active and LDataSet.CanModify and not LDataSet.IsEmpty;
    if Assigned(FButtons[nbEdit]) then
      FButtons[nbEdit].Enabled := LDataSet.Active and LDataSet.CanModify and not (LDataSet.State in [dsEdit, dsInsert]);
    if Assigned(FButtons[nbPost]) then
      FButtons[nbPost].Enabled := LDataSet.State in [dsEdit, dsInsert];
    if Assigned(FButtons[nbCancel]) then
      FButtons[nbCancel].Enabled := LDataSet.State in [dsEdit, dsInsert];
    if Assigned(FButtons[nbRefresh]) then
      FButtons[nbRefresh].Enabled := LDataSet.Active;
  end;
end;

procedure TFMXStyledDbNavigator.UpdateButtonsLayout;
var
  LBtn: TFMXNavigateBtn;
  LCurrentPos: Single;
begin
  LCurrentPos := Padding.Left;

  for LBtn := Low(TFMXNavigateBtn) to High(TFMXNavigateBtn) do
  begin
    if not (LBtn in FVisibleButtons) then
      Continue;

    if FOrientation = TOrientation.Horizontal then
    begin
      FButtons[LBtn].Position.X := LCurrentPos;
      FButtons[LBtn].Position.Y := Padding.Top;
      FButtons[LBtn].Width := FButtonWidth;
      FButtons[LBtn].Height := FButtonHeight;
      LCurrentPos := LCurrentPos + FButtonWidth + 2;
    end
    else
    begin
      FButtons[LBtn].Position.X := Padding.Left;
      FButtons[LBtn].Position.Y := LCurrentPos;
      FButtons[LBtn].Width := FButtonWidth;
      FButtons[LBtn].Height := FButtonHeight;
      LCurrentPos := LCurrentPos + FButtonHeight + 2;
    end;
  end;
end;

procedure TFMXStyledDbNavigator.DoRealign;
begin
  inherited;
  UpdateButtonsLayout;
end;

procedure TFMXStyledDbNavigator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDataSource) then
    FDataSource := nil;
end;

procedure TFMXStyledDbNavigator.SetButtonHeight(const Value: Single);
begin
  if FButtonHeight <> Value then
  begin
    FButtonHeight := Value;
    UpdateButtonsLayout;
  end;
end;

procedure TFMXStyledDbNavigator.SetButtonWidth(const Value: Single);
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    UpdateButtonsLayout;
  end;
end;

procedure TFMXStyledDbNavigator.SetDataSource(const Value: TDataSource);
begin
  if FDataSource <> Value then
  begin
    if Assigned(FDataSource) then
      FDataSource.RemoveFreeNotification(Self);

    FDataSource := Value;

    if Assigned(FDataSource) then
      FDataSource.FreeNotification(Self);

    UpdateButtonsState;
  end;
end;

procedure TFMXStyledDbNavigator.SetHints(const Value: TStrings);
begin
  FHints.Assign(Value);
end;

procedure TFMXStyledDbNavigator.SetOrientation(const Value: TOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    UpdateButtonsLayout;
  end;
end;

procedure TFMXStyledDbNavigator.SetShowCaptions(const Value: Boolean);
var
  LBtn: TFMXNavigateBtn;
begin
  if FShowCaptions <> Value then
  begin
    FShowCaptions := Value;
    for LBtn := Low(TFMXNavigateBtn) to High(TFMXNavigateBtn) do
    begin
      FButtons[LBtn].Text := GetButtonCaption(LBtn);
    end;
  end;
end;

procedure TFMXStyledDbNavigator.SetStyleAppearance(const Value: string);
begin
  if FStyleAppearance <> Value then
  begin
    FStyleAppearance := Value;
    // Apply style to buttons
  end;
end;

procedure TFMXStyledDbNavigator.SetStyleClass(const Value: string);
begin
  if FStyleClass <> Value then
  begin
    FStyleClass := Value;
    // Apply style to buttons
  end;
end;

procedure TFMXStyledDbNavigator.SetStyleFamily(const Value: string);
begin
  if FStyleFamily <> Value then
  begin
    FStyleFamily := Value;
    // Apply style to buttons
  end;
end;

procedure TFMXStyledDbNavigator.SetVisibleButtons(const Value: TFMXNavigateButtons);
var
  LBtn: TFMXNavigateBtn;
begin
  if FVisibleButtons <> Value then
  begin
    FVisibleButtons := Value;
    for LBtn := Low(TFMXNavigateBtn) to High(TFMXNavigateBtn) do
    begin
      FButtons[LBtn].Visible := LBtn in FVisibleButtons;
    end;
    UpdateButtonsLayout;
  end;
end;

end.
