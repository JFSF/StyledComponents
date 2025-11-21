{******************************************************************************}
{                                                                              }
{  FMX.StyledTaskDialog: Multi-platform Task Dialog with Styled Buttons       }
{  Adapted from VCL StyledTaskDialog for FireMonkey                           }
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
unit FMX.StyledTaskDialog;

interface

{$I StyledComponents.FMX.inc}

uses
  System.UITypes,
  System.SysUtils,
  System.Types,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.StyledButton;

const
  DEFAULT_DIALOG_WIDTH = 500;
  DEFAULT_DIALOG_HEIGHT = 280;
  DEFAULT_BUTTON_WIDTH = 100;
  DEFAULT_BUTTON_HEIGHT = 40;

type
  TFMXTaskDialogIcon = (tdiNone, tdiWarning, tdiError, tdiInformation, tdiShield, tdiQuestion);
  TFMXTaskDialogButton = (tdbOK, tdbYes, tdbNo, tdbCancel, tdbRetry, tdbClose);
  TFMXTaskDialogButtons = set of TFMXTaskDialogButton;

  TFMXTaskDialogButtonClickEvent = procedure(Sender: TObject; Button: TFMXTaskDialogButton;
    var CanClose: Boolean) of object;

  { TFMXStyledTaskDialogForm }
  TFMXStyledTaskDialogForm = class(TForm)
  private
    FTitleLabel: TLabel;
    FMessageLabel: TLabel;
    FIconImage: TImage;
    FButtonPanel: TLayout;
    FContentLayout: TLayout;
    FButtons: array of TFMXStyledButton;
    FModalResult: TModalResult;
    FOnButtonClick: TFMXTaskDialogButtonClickEvent;
    procedure CreateFormComponents;
    procedure CreateButtons(AButtons: TFMXTaskDialogButtons;
      const AButtonFamily, AButtonClass, AButtonAppearance: string);
    procedure ButtonClick(Sender: TObject);
    function GetIconFromType(AIcon: TFMXTaskDialogIcon): TBitmap;
  protected
    procedure DoShow; override;
  public
    constructor CreateDialog(AOwner: TComponent; const ATitle, AMessage: string;
      AIcon: TFMXTaskDialogIcon; AButtons: TFMXTaskDialogButtons;
      const AButtonFamily: string = ''; const AButtonClass: string = '';
      const AButtonAppearance: string = ''); reintroduce;
    property OnButtonClick: TFMXTaskDialogButtonClickEvent read FOnButtonClick write FOnButtonClick;
  end;

  { TFMXStyledTaskDialog }
  TFMXStyledTaskDialog = class(TComponent)
  private
    FTitle: string;
    FText: string;
    FIcon: TFMXTaskDialogIcon;
    FButtons: TFMXTaskDialogButtons;
    FDefaultButton: TFMXTaskDialogButton;
    FButtonFamily: string;
    FButtonClass: string;
    FButtonAppearance: string;
    FCustomButtonCaptions: TStringList;
    FOnButtonClick: TFMXTaskDialogButtonClickEvent;
    FDialogWidth: Single;
    FDialogHeight: Single;
    FParentForm: TCommonCustomForm;
    procedure SetCustomButtonCaptions(const Value: TStringList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: TModalResult; overload;
    function Execute(ParentForm: TCommonCustomForm): TModalResult; overload;
  published
    property Title: string read FTitle write FTitle;
    property Text: string read FText write FText;
    property Icon: TFMXTaskDialogIcon read FIcon write FIcon default tdiInformation;
    property Buttons: TFMXTaskDialogButtons read FButtons write FButtons default [tdbOK];
    property DefaultButton: TFMXTaskDialogButton read FDefaultButton write FDefaultButton default tdbOK;
    property ButtonFamily: string read FButtonFamily write FButtonFamily;
    property ButtonClass: string read FButtonClass write FButtonClass;
    property ButtonAppearance: string read FButtonAppearance write FButtonAppearance;
    property CustomButtonCaptions: TStringList read FCustomButtonCaptions write SetCustomButtonCaptions;
    property DialogWidth: Single read FDialogWidth write FDialogWidth;
    property DialogHeight: Single read FDialogHeight write FDialogHeight;
    property OnButtonClick: TFMXTaskDialogButtonClickEvent read FOnButtonClick write FOnButtonClick;
  end;

// Helper functions
function StyledTaskMessageDlg(const ATitle, AMessage: string;
  const ADlgType: TMsgDlgType; const AButtons: TMsgDlgButtons;
  const ADefaultButton: TMsgDlgBtn = TMsgDlgBtn.mbOK): TModalResult;

function StyledShowMessage(const ATitle, AMessage: string;
  const ADlgType: TMsgDlgType = TMsgDlgType.mtInformation): TModalResult;

procedure Register;

implementation

uses
  System.Math;

procedure Register;
begin
  RegisterComponents('Styled FMX', [TFMXStyledTaskDialog]);
end;

{ Helper functions }

function StyledTaskMessageDlg(const ATitle, AMessage: string;
  const ADlgType: TMsgDlgType; const AButtons: TMsgDlgButtons;
  const ADefaultButton: TMsgDlgBtn): TModalResult;
var
  LDialog: TFMXStyledTaskDialog;
  LTaskButtons: TFMXTaskDialogButtons;
begin
  LDialog := TFMXStyledTaskDialog.Create(nil);
  try
    LDialog.Title := ATitle;
    LDialog.Text := AMessage;

    // Convert TMsgDlgType to TFMXTaskDialogIcon
    case ADlgType of
      TMsgDlgType.mtWarning: LDialog.Icon := tdiWarning;
      TMsgDlgType.mtError: LDialog.Icon := tdiError;
      TMsgDlgType.mtInformation: LDialog.Icon := tdiInformation;
      TMsgDlgType.mtConfirmation: LDialog.Icon := tdiQuestion;
      TMsgDlgType.mtCustom: LDialog.Icon := tdiNone;
    else
      LDialog.Icon := tdiInformation;
    end;

    // Convert TMsgDlgButtons to TFMXTaskDialogButtons
    LTaskButtons := [];
    if TMsgDlgBtn.mbOK in AButtons then
      Include(LTaskButtons, tdbOK);
    if TMsgDlgBtn.mbYes in AButtons then
      Include(LTaskButtons, tdbYes);
    if TMsgDlgBtn.mbNo in AButtons then
      Include(LTaskButtons, tdbNo);
    if TMsgDlgBtn.mbCancel in AButtons then
      Include(LTaskButtons, tdbCancel);
    if TMsgDlgBtn.mbRetry in AButtons then
      Include(LTaskButtons, tdbRetry);
    if TMsgDlgBtn.mbClose in AButtons then
      Include(LTaskButtons, tdbClose);

    if LTaskButtons = [] then
      LTaskButtons := [tdbOK];

    LDialog.Buttons := LTaskButtons;

    // Set default button
    case ADefaultButton of
      TMsgDlgBtn.mbOK: LDialog.DefaultButton := tdbOK;
      TMsgDlgBtn.mbYes: LDialog.DefaultButton := tdbYes;
      TMsgDlgBtn.mbNo: LDialog.DefaultButton := tdbNo;
      TMsgDlgBtn.mbCancel: LDialog.DefaultButton := tdbCancel;
      TMsgDlgBtn.mbRetry: LDialog.DefaultButton := tdbRetry;
      TMsgDlgBtn.mbClose: LDialog.DefaultButton := tdbClose;
    else
      LDialog.DefaultButton := tdbOK;
    end;

    Result := LDialog.Execute;
  finally
    LDialog.Free;
  end;
end;

function StyledShowMessage(const ATitle, AMessage: string;
  const ADlgType: TMsgDlgType): TModalResult;
begin
  Result := StyledTaskMessageDlg(ATitle, AMessage, ADlgType, [TMsgDlgBtn.mbOK]);
end;

{ TFMXStyledTaskDialogForm }

constructor TFMXStyledTaskDialogForm.CreateDialog(AOwner: TComponent;
  const ATitle, AMessage: string; AIcon: TFMXTaskDialogIcon;
  AButtons: TFMXTaskDialogButtons; const AButtonFamily, AButtonClass,
  AButtonAppearance: string);
begin
  inherited Create(AOwner);

  BorderStyle := TFmxFormBorderStyle.Single;
  Position := TFormPosition.ScreenCenter;
  Caption := ATitle;
  Width := DEFAULT_DIALOG_WIDTH;
  Height := DEFAULT_DIALOG_HEIGHT;

  CreateFormComponents;

  FTitleLabel.Text := ATitle;
  FMessageLabel.Text := AMessage;

  if AIcon <> tdiNone then
  begin
    FIconImage.Bitmap := GetIconFromType(AIcon);
    FIconImage.Visible := True;
  end
  else
    FIconImage.Visible := False;

  // Create buttons
  if AButtons = [] then
    AButtons := [tdbOK];

  CreateButtons(AButtons, AButtonFamily, AButtonClass, AButtonAppearance);
end;

procedure TFMXStyledTaskDialogForm.CreateFormComponents;
begin
  // Main content layout
  FContentLayout := TLayout.Create(Self);
  FContentLayout.Parent := Self;
  FContentLayout.Align := TAlignLayout.Client;
  FContentLayout.Padding.Left := 20;
  FContentLayout.Padding.Top := 20;
  FContentLayout.Padding.Right := 20;
  FContentLayout.Padding.Bottom := 20;

  // Icon
  FIconImage := TImage.Create(Self);
  FIconImage.Parent := FContentLayout;
  FIconImage.Position.X := 20;
  FIconImage.Position.Y := 20;
  FIconImage.Width := 64;
  FIconImage.Height := 64;
  FIconImage.WrapMode := TImageWrapMode.Fit;

  // Title label
  FTitleLabel := TLabel.Create(Self);
  FTitleLabel.Parent := FContentLayout;
  FTitleLabel.Position.X := 100;
  FTitleLabel.Position.Y := 20;
  FTitleLabel.Width := DEFAULT_DIALOG_WIDTH - 140;
  FTitleLabel.AutoSize := False;
  FTitleLabel.WordWrap := True;
  FTitleLabel.Font.Size := 14;
  FTitleLabel.TextSettings.FontColor := TAlphaColorRec.Black;
  FTitleLabel.StyledSettings := FTitleLabel.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];

  // Message label
  FMessageLabel := TLabel.Create(Self);
  FMessageLabel.Parent := FContentLayout;
  FMessageLabel.Position.X := 100;
  FMessageLabel.Position.Y := 60;
  FMessageLabel.Width := DEFAULT_DIALOG_WIDTH - 140;
  FMessageLabel.Height := 100;
  FMessageLabel.AutoSize := False;
  FMessageLabel.WordWrap := True;
  FMessageLabel.Font.Size := 12;

  // Button panel
  FButtonPanel := TLayout.Create(Self);
  FButtonPanel.Parent := Self;
  FButtonPanel.Align := TAlignLayout.Bottom;
  FButtonPanel.Height := 60;
  FButtonPanel.Padding.Left := 10;
  FButtonPanel.Padding.Right := 10;
  FButtonPanel.Padding.Bottom := 10;
end;

procedure TFMXStyledTaskDialogForm.CreateButtons(AButtons: TFMXTaskDialogButtons;
  const AButtonFamily, AButtonClass, AButtonAppearance: string);
var
  LButtonCount: Integer;
  LCurrentX: Single;
  LButton: TFMXStyledButton;
  LButtonText: string;
  LModalRes: TModalResult;

  procedure AddButton(const ACaption: string; AModalResult: TModalResult);
  begin
    LButton := TFMXStyledButton.Create(Self);
    LButton.Parent := FButtonPanel;
    LButton.Text := ACaption;
    LButton.ModalResult := AModalResult;
    LButton.Width := DEFAULT_BUTTON_WIDTH;
    LButton.Height := DEFAULT_BUTTON_HEIGHT;
    LButton.Position.X := LCurrentX;
    LButton.Position.Y := 10;
    LButton.OnClick := ButtonClick;

    SetLength(FButtons, Length(FButtons) + 1);
    FButtons[High(FButtons)] := LButton;

    LCurrentX := LCurrentX + DEFAULT_BUTTON_WIDTH + 10;
  end;

begin
  LButtonCount := 0;
  if tdbOK in AButtons then Inc(LButtonCount);
  if tdbYes in AButtons then Inc(LButtonCount);
  if tdbNo in AButtons then Inc(LButtonCount);
  if tdbCancel in AButtons then Inc(LButtonCount);
  if tdbRetry in AButtons then Inc(LButtonCount);
  if tdbClose in AButtons then Inc(LButtonCount);

  // Calculate starting position for centered buttons
  LCurrentX := (DEFAULT_DIALOG_WIDTH - (LButtonCount * DEFAULT_BUTTON_WIDTH + (LButtonCount - 1) * 10)) / 2;

  if tdbOK in AButtons then
    AddButton('OK', mrOk);
  if tdbYes in AButtons then
    AddButton('Yes', mrYes);
  if tdbNo in AButtons then
    AddButton('No', mrNo);
  if tdbCancel in AButtons then
    AddButton('Cancel', mrCancel);
  if tdbRetry in AButtons then
    AddButton('Retry', mrRetry);
  if tdbClose in AButtons then
    AddButton('Close', mrClose);
end;

procedure TFMXStyledTaskDialogForm.ButtonClick(Sender: TObject);
var
  LButton: TFMXStyledButton;
  LTaskButton: TFMXTaskDialogButton;
  LCanClose: Boolean;
begin
  if Sender is TFMXStyledButton then
  begin
    LButton := TFMXStyledButton(Sender);
    FModalResult := LButton.ModalResult;

    // Convert ModalResult to TFMXTaskDialogButton
    case LButton.ModalResult of
      mrOk: LTaskButton := tdbOK;
      mrYes: LTaskButton := tdbYes;
      mrNo: LTaskButton := tdbNo;
      mrCancel: LTaskButton := tdbCancel;
      mrRetry: LTaskButton := tdbRetry;
      mrClose: LTaskButton := tdbClose;
    else
      LTaskButton := tdbOK;
    end;

    LCanClose := True;
    if Assigned(FOnButtonClick) then
      FOnButtonClick(Self, LTaskButton, LCanClose);

    if LCanClose then
      ModalResult := FModalResult;
  end;
end;

function TFMXStyledTaskDialogForm.GetIconFromType(AIcon: TFMXTaskDialogIcon): TBitmap;
var
  LBitmap: TBitmap;
  LRect: TRectF;
  LColor: TAlphaColor;
begin
  Result := TBitmap.Create(64, 64);

  // Draw a simple icon based on type
  if Result.Canvas.BeginScene then
  try
    LRect := RectF(0, 0, 64, 64);

    case AIcon of
      tdiWarning:
        LColor := TAlphaColorRec.Orange;
      tdiError:
        LColor := TAlphaColorRec.Red;
      tdiInformation:
        LColor := TAlphaColorRec.Dodgerblue;
      tdiQuestion:
        LColor := TAlphaColorRec.Mediumseagreen;
      tdiShield:
        LColor := TAlphaColorRec.Gold;
    else
      LColor := TAlphaColorRec.Gray;
    end;

    Result.Canvas.Fill.Color := LColor;
    Result.Canvas.FillEllipse(LRect, 1);

    // Draw symbol
    Result.Canvas.Fill.Color := TAlphaColorRec.White;
    Result.Canvas.Font.Size := 32;

    case AIcon of
      tdiWarning: Result.Canvas.FillText(LRect, '!', False, 1, [], TTextAlign.Center);
      tdiError: Result.Canvas.FillText(LRect, '×', False, 1, [], TTextAlign.Center);
      tdiInformation: Result.Canvas.FillText(LRect, 'i', False, 1, [], TTextAlign.Center);
      tdiQuestion: Result.Canvas.FillText(LRect, '?', False, 1, [], TTextAlign.Center);
      tdiShield: Result.Canvas.FillText(LRect, '🛡', False, 1, [], TTextAlign.Center);
    end;
  finally
    Result.Canvas.EndScene;
  end;
end;

procedure TFMXStyledTaskDialogForm.DoShow;
begin
  inherited;
  // Additional show logic if needed
end;

{ TFMXStyledTaskDialog }

constructor TFMXStyledTaskDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTitle := 'Dialog';
  FText := '';
  FIcon := tdiInformation;
  FButtons := [tdbOK];
  FDefaultButton := tdbOK;
  FButtonFamily := '';
  FButtonClass := '';
  FButtonAppearance := '';
  FCustomButtonCaptions := TStringList.Create;
  FDialogWidth := DEFAULT_DIALOG_WIDTH;
  FDialogHeight := DEFAULT_DIALOG_HEIGHT;
  FParentForm := nil;
end;

destructor TFMXStyledTaskDialog.Destroy;
begin
  FreeAndNil(FCustomButtonCaptions);
  inherited;
end;

function TFMXStyledTaskDialog.Execute: TModalResult;
begin
  Result := Execute(nil);
end;

function TFMXStyledTaskDialog.Execute(ParentForm: TCommonCustomForm): TModalResult;
var
  LForm: TFMXStyledTaskDialogForm;
begin
  LForm := TFMXStyledTaskDialogForm.CreateDialog(ParentForm, FTitle, FText,
    FIcon, FButtons, FButtonFamily, FButtonClass, FButtonAppearance);
  try
    LForm.OnButtonClick := FOnButtonClick;

    if FDialogWidth > 0 then
      LForm.Width := FDialogWidth;
    if FDialogHeight > 0 then
      LForm.Height := FDialogHeight;

    Result := LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

procedure TFMXStyledTaskDialog.SetCustomButtonCaptions(const Value: TStringList);
begin
  FCustomButtonCaptions.Assign(Value);
end;

end.
