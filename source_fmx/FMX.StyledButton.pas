{******************************************************************************}
{                                                                              }
{  FMX.StyledButton: FireMonkey Styled Button Component                       }
{                                                                              }
{  Copyright (c) 2025 (Ethea S.r.l.)                                          }
{  Author: Claude AI / Carlo Barazzetta                                       }
{  Contributors:                                                               }
{                                                                              }
{  https://github.com/EtheaDev/StyledComponents                               }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");            }
{  you may not use this file except in compliance with the License.           }
{  You may obtain a copy of the License at                                    }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                             }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software        }
{  distributed under the License is distributed on an "AS IS" BASIS,          }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   }
{  See the License for the specific language governing permissions and        }
{  limitations under the License.                                             }
{                                                                              }
{******************************************************************************}
unit FMX.StyledButton;

interface

{$I StyledComponents.FMX.inc}

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Rtti,
  FMX.Types,
  FMX.Controls,
  FMX.Graphics,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects,
  FMX.Ani,
  FMX.Layouts;

type
  // Button drawing types
  TStyledButtonDrawType = (
    btRoundRect,  // Rounded rectangle (default)
    btRect,       // Sharp rectangle
    btRounded,    // Fully rounded (pill shape)
    btEllipse     // Circular/elliptical
  );

  // Button style families (similar to VCL but adapted for FMX)
  TStyledButtonFamily = string;

  // Button style class
  TStyledButtonClass = string;

  // Button appearance
  TStyledButtonAppearance = string;

  // Rounded corners configuration
  TStyledButtonRoundedCorners = set of (rcTopLeft, rcTopRight, rcBottomLeft, rcBottomRight);

{$IFDEF FEATURE_DARK_MODE}
  // Theme mode for automatic dark/light detection
  TStyledButtonThemeMode = (
    tmAuto,      // Auto-detect from system
    tmLight,     // Force light theme
    tmDark,      // Force dark theme
    tmCustom     // Custom colors (ignore theme)
  );
{$ENDIF}

  // Notification badge position
  TNotificationBadgePosition = (
    nbpTopLeft,
    nbpTopRight,
    nbpBottomLeft,
    nbpBottomRight
  );

  // Forward declaration
  TFMXStyledButton = class;

  // Notification Badge Component
  TNotificationBadge = class(TControl)
  private
    FValue: Integer;
    FMaxValue: Integer;
    FCustomText: string;
    FBadgeColor: TAlphaColor;
    FTextColor: TAlphaColor;
    FPosition: TNotificationBadgePosition;
    FOwnerButton: TFMXStyledButton;
    procedure SetValue(const AValue: Integer);
    procedure SetMaxValue(const AValue: Integer);
    procedure SetCustomText(const AValue: string);
    procedure SetBadgeColor(const AValue: TAlphaColor);
    procedure SetTextColor(const AValue: TAlphaColor);
    procedure SetPosition(const AValue: TNotificationBadgePosition);
    function GetBadgeText: string;
    function GetIsVisible: Boolean;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property IsVisible: Boolean read GetIsVisible;
    property BadgeText: string read GetBadgeText;
  published
    property Value: Integer read FValue write SetValue default 0;
    property MaxValue: Integer read FMaxValue write SetMaxValue default 99;
    property CustomText: string read FCustomText write SetCustomText;
    property BadgeColor: TAlphaColor read FBadgeColor write SetBadgeColor;
    property TextColor: TAlphaColor read FTextColor write SetTextColor;
    property Position: TNotificationBadgePosition read FPosition write SetPosition default nbpTopRight;
  end;

{$IFDEF FEATURE_LOADING_STATE}
  // Loading spinner for FMX
  TLoadingSpinner = class(TControl)
  private
    FAniTimer: TTimer;
    FAngle: Single;
    FSpinnerColor: TAlphaColor;
    FDotCount: Integer;
    procedure OnTimer(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    property SpinnerColor: TAlphaColor read FSpinnerColor write FSpinnerColor;
  end;
{$ENDIF}

{$IFDEF FEATURE_RIPPLE_EFFECT}
  // Ripple effect for Material Design
  TRippleEffect = class
  private
    FCenter: TPointF;
    FRadius: Single;
    FMaxRadius: Single;
    FAlpha: Single;
    FAnimation: TFloatAnimation;
    FOwner: TFMXStyledButton;
    procedure OnAnimationFinish(Sender: TObject);
  public
    constructor Create(AOwner: TFMXStyledButton);
    destructor Destroy; override;
    procedure Start(const APoint: TPointF);
    procedure Draw(ACanvas: TCanvas; const ARect: TRectF);
    property IsAnimating: Boolean read GetIsAnimating;
  end;
{$ENDIF}

  // Main Styled Button Component for FMX
  TFMXStyledButton = class(TButton)
  private
    // Visual properties
    FStyleDrawType: TStyledButtonDrawType;
    FStyleFamily: TStyledButtonFamily;
    FStyleClass: TStyledButtonClass;
    FStyleAppearance: TStyledButtonAppearance;
    FStyleRadius: Single;
    FRoundedCorners: TStyledButtonRoundedCorners;

    // Colors
    FButtonColor: TAlphaColor;
    FBorderColor: TAlphaColor;
    FBorderWidth: Single;

    // Badge
    FNotificationBadge: TNotificationBadge;

    // Effects
    FShadowEffect: TShadowEffect;

{$IFDEF FEATURE_DARK_MODE}
    FThemeMode: TStyledButtonThemeMode;
    procedure ApplyThemeColors;
{$ENDIF}

{$IFDEF FEATURE_LOADING_STATE}
    FLoadingSpinner: TLoadingSpinner;
    FIsLoading: Boolean;
    FSavedText: string;
    FSavedEnabled: Boolean;
{$ENDIF}

{$IFDEF FEATURE_RIPPLE_EFFECT}
    FRippleEffect: TRippleEffect;
    FEnableRipple: Boolean;
{$ENDIF}

{$IFDEF FEATURE_GRADIENTS}
    FUseGradient: Boolean;
    FGradientStartColor: TAlphaColor;
    FGradientEndColor: TAlphaColor;
{$ENDIF}

    // Setters
    procedure SetStyleDrawType(const Value: TStyledButtonDrawType);
    procedure SetStyleRadius(const Value: Single);
    procedure SetRoundedCorners(const Value: TStyledButtonRoundedCorners);
    procedure SetButtonColor(const Value: TAlphaColor);
    procedure SetBorderColor(const Value: TAlphaColor);
    procedure SetBorderWidth(const Value: Single);

{$IFDEF FEATURE_DARK_MODE}
    procedure SetThemeMode(const Value: TStyledButtonThemeMode);
{$ENDIF}

{$IFDEF FEATURE_GRADIENTS}
    procedure SetUseGradient(const Value: Boolean);
    procedure SetGradientStartColor(const Value: TAlphaColor);
    procedure SetGradientEndColor(const Value: TAlphaColor);
{$ENDIF}

  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    function GetCornerRadius: TCorners;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

{$IFDEF FEATURE_LOADING_STATE}
    procedure SetLoading(const ALoading: Boolean; const AText: string = 'Loading...');
    property IsLoading: Boolean read FIsLoading;
{$ENDIF}

  published
    // Style properties
    property StyleDrawType: TStyledButtonDrawType read FStyleDrawType write SetStyleDrawType default btRoundRect;
    property StyleRadius: Single read FStyleRadius write SetStyleRadius;
    property RoundedCorners: TStyledButtonRoundedCorners read FRoundedCorners write SetRoundedCorners;

    // Color properties
    property ButtonColor: TAlphaColor read FButtonColor write SetButtonColor;
    property BorderColor: TAlphaColor read FBorderColor write SetBorderColor;
    property BorderWidth: Single read FBorderWidth write SetBorderWidth;

    // Badge
    property NotificationBadge: TNotificationBadge read FNotificationBadge;

{$IFDEF FEATURE_DARK_MODE}
    property ThemeMode: TStyledButtonThemeMode read FThemeMode write SetThemeMode default tmCustom;
{$ENDIF}

{$IFDEF FEATURE_RIPPLE_EFFECT}
    property EnableRipple: Boolean read FEnableRipple write FEnableRipple default False;
{$ENDIF}

{$IFDEF FEATURE_GRADIENTS}
    property UseGradient: Boolean read FUseGradient write SetUseGradient default False;
    property GradientStartColor: TAlphaColor read FGradientStartColor write SetGradientStartColor;
    property GradientEndColor: TAlphaColor read FGradientEndColor write SetGradientEndColor;
{$ENDIF}
  end;

procedure Register;

implementation

uses
  System.Math
{$IFDEF PLATFORM_WINDOWS}
  , Winapi.Windows
  , System.Win.Registry
{$ENDIF}
{$IFDEF PLATFORM_MACOS}
  , Macapi.AppKit
{$ENDIF}
  ;

{ TNotificationBadge }

constructor TNotificationBadge.Create(AOwner: TComponent);
begin
  inherited;
  FValue := 0;
  FMaxValue := 99;
  FCustomText := '';
  FBadgeColor := TAlphaColorRec.Red;
  FTextColor := TAlphaColorRec.White;
  FPosition := nbpTopRight;
  SetBounds(0, 0, 20, 20);
  HitTest := False;  // Badge doesn't intercept clicks
end;

procedure TNotificationBadge.SetValue(const AValue: Integer);
begin
  if FValue <> AValue then
  begin
    FValue := AValue;
    Repaint;
  end;
end;

procedure TNotificationBadge.SetMaxValue(const AValue: Integer);
begin
  if FMaxValue <> AValue then
  begin
    FMaxValue := AValue;
    Repaint;
  end;
end;

procedure TNotificationBadge.SetCustomText(const AValue: string);
begin
  if FCustomText <> AValue then
  begin
    FCustomText := AValue;
    Repaint;
  end;
end;

procedure TNotificationBadge.SetBadgeColor(const AValue: TAlphaColor);
begin
  if FBadgeColor <> AValue then
  begin
    FBadgeColor := AValue;
    Repaint;
  end;
end;

procedure TNotificationBadge.SetTextColor(const AValue: TAlphaColor);
begin
  if FTextColor <> AValue then
  begin
    FTextColor := AValue;
    Repaint;
  end;
end;

procedure TNotificationBadge.SetPosition(const AValue: TNotificationBadgePosition);
begin
  if FPosition <> AValue then
  begin
    FPosition := AValue;
    Repaint;
  end;
end;

function TNotificationBadge.GetBadgeText: string;
begin
  if FCustomText <> '' then
    Result := FCustomText
  else if FValue > FMaxValue then
    Result := IntToStr(FMaxValue) + '+'
  else if FValue > 0 then
    Result := IntToStr(FValue)
  else
    Result := '';
end;

function TNotificationBadge.GetIsVisible: Boolean;
begin
  Result := (FValue > 0) or (FCustomText <> '');
end;

procedure TNotificationBadge.Paint;
var
  R: TRectF;
  TextLayout: TTextLayout;
begin
  inherited;

  if not IsVisible then
    Exit;

  // Draw badge background (circle)
  R := LocalRect;
  Canvas.BeginScene;
  try
    Canvas.Fill.Color := FBadgeColor;
    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.FillEllipse(R, 1.0);

    // Draw badge text
    TextLayout := TTextLayoutManager.DefaultTextLayout.Create;
    try
      TextLayout.BeginUpdate;
      try
        TextLayout.Font.Size := 10;
        TextLayout.Color := FTextColor;
        TextLayout.Text := BadgeText;
        TextLayout.HorizontalAlign := TTextAlign.Center;
        TextLayout.VerticalAlign := TTextAlign.Center;
        TextLayout.TopLeft := R.TopLeft;
        TextLayout.MaxSize := PointF(R.Width, R.Height);
      finally
        TextLayout.EndUpdate;
      end;
      TextLayout.RenderLayout(Canvas);
    finally
      TextLayout.Free;
    end;
  finally
    Canvas.EndScene;
  end;
end;

{$IFDEF FEATURE_LOADING_STATE}

{ TLoadingSpinner }

constructor TLoadingSpinner.Create(AOwner: TComponent);
begin
  inherited;
  FAngle := 0;
  FSpinnerColor := TAlphaColorRec.Gray;
  FDotCount := 8;
  SetBounds(0, 0, 24, 24);
  HitTest := False;

  FAniTimer := TTimer.Create(Self);
  FAniTimer.Interval := 50;  // 20 FPS
  FAniTimer.OnTimer := OnTimer;
  FAniTimer.Enabled := False;
end;

destructor TLoadingSpinner.Destroy;
begin
  FAniTimer.Free;
  inherited;
end;

procedure TLoadingSpinner.OnTimer(Sender: TObject);
begin
  FAngle := FAngle + 45;
  if FAngle >= 360 then
    FAngle := FAngle - 360;
  Repaint;
end;

procedure TLoadingSpinner.Start;
begin
  FAngle := 0;
  FAniTimer.Enabled := True;
  Visible := True;
end;

procedure TLoadingSpinner.Stop;
begin
  FAniTimer.Enabled := False;
  Visible := False;
end;

procedure TLoadingSpinner.Paint;
var
  I: Integer;
  Radius, DotRadius: Single;
  CenterX, CenterY: Single;
  X, Y: Single;
  Angle: Single;
  Alpha: Single;
  R: TRectF;
begin
  inherited;

  if not Visible then
    Exit;

  Canvas.BeginScene;
  try
    CenterX := Width / 2;
    CenterY := Height / 2;
    Radius := Min(Width, Height) / 3;
    DotRadius := Radius / 4;

    Canvas.Fill.Kind := TBrushKind.Solid;

    // Draw 8 dots in a circle with fading effect
    for I := 0 to FDotCount - 1 do
    begin
      Angle := DegToRad(FAngle + (I * (360 / FDotCount)));
      X := CenterX + Radius * Cos(Angle);
      Y := CenterY + Radius * Sin(Angle);

      // Calculate alpha for fade effect
      Alpha := 1.0 - (I / FDotCount);

      Canvas.Fill.Color := MakeColor(FSpinnerColor, Alpha);

      R := RectF(X - DotRadius, Y - DotRadius, X + DotRadius, Y + DotRadius);
      Canvas.FillEllipse(R, 1.0);
    end;
  finally
    Canvas.EndScene;
  end;
end;

{$ENDIF}

{$IFDEF FEATURE_RIPPLE_EFFECT}

{ TRippleEffect }

constructor TRippleEffect.Create(AOwner: TFMXStyledButton);
begin
  inherited Create;
  FOwner := AOwner;
  FRadius := 0;
  FAlpha := 0;
end;

destructor TRippleEffect.Destroy;
begin
  if Assigned(FAnimation) then
    FAnimation.Free;
  inherited;
end;

procedure TRippleEffect.Start(const APoint: TPointF);
begin
  FCenter := APoint;
  FRadius := 0;
  FAlpha := 0.5;

  // Calculate max radius (diagonal of button)
  FMaxRadius := Sqrt(Sqr(FOwner.Width) + Sqr(FOwner.Height));

  // Create animation
  if Assigned(FAnimation) then
    FAnimation.Free;

  FAnimation := TFloatAnimation.Create(nil);
  FAnimation.Parent := FOwner;
  FAnimation.Duration := 0.6;
  FAnimation.StartValue := 0;
  FAnimation.StopValue := FMaxRadius;
  FAnimation.PropertyName := 'Tag';  // Dummy property
  FAnimation.OnFinish := OnAnimationFinish;
  FAnimation.OnProcess := procedure(Sender: TObject)
    begin
      FRadius := FAnimation.CurrentValue;
      FAlpha := 0.5 * (1 - (FRadius / FMaxRadius));
      FOwner.Repaint;
    end;
  FAnimation.Start;
end;

procedure TRippleEffect.OnAnimationFinish(Sender: TObject);
begin
  FRadius := 0;
  FAlpha := 0;
  FOwner.Repaint;
end;

procedure TRippleEffect.Draw(ACanvas: TCanvas; const ARect: TRectF);
var
  R: TRectF;
begin
  if FRadius > 0 then
  begin
    ACanvas.Fill.Kind := TBrushKind.Solid;
    ACanvas.Fill.Color := MakeColor(TAlphaColorRec.White, FAlpha);

    R := RectF(
      FCenter.X - FRadius,
      FCenter.Y - FRadius,
      FCenter.X + FRadius,
      FCenter.Y + FRadius
    );

    ACanvas.FillEllipse(R, 1.0);
  end;
end;

function TRippleEffect.GetIsAnimating: Boolean;
begin
  Result := Assigned(FAnimation) and FAnimation.Running;
end;

{$ENDIF}

{ TFMXStyledButton }

constructor TFMXStyledButton.Create(AOwner: TComponent);
begin
  inherited;

  // Default values
  FStyleDrawType := btRoundRect;
  FStyleRadius := 4;
  FRoundedCorners := [rcTopLeft, rcTopRight, rcBottomLeft, rcBottomRight];
  FButtonColor := TAlphaColorRec.Dodgerblue;
  FBorderColor := TAlphaColorRec.Null;
  FBorderWidth := 0;

  // Create badge
  FNotificationBadge := TNotificationBadge.Create(Self);
  FNotificationBadge.Parent := Self;
  FNotificationBadge.Stored := False;

  // Add shadow effect
  FShadowEffect := TShadowEffect.Create(Self);
  FShadowEffect.Parent := Self;
  FShadowEffect.Enabled := True;
  FShadowEffect.Distance := 2;
  FShadowEffect.Opacity := 0.3;
  FShadowEffect.Softness := 0.2;

{$IFDEF FEATURE_DARK_MODE}
  FThemeMode := tmCustom;
{$ENDIF}

{$IFDEF FEATURE_LOADING_STATE}
  FLoadingSpinner := TLoadingSpinner.Create(Self);
  FLoadingSpinner.Parent := Self;
  FLoadingSpinner.Visible := False;
  FLoadingSpinner.Stored := False;
  FIsLoading := False;
{$ENDIF}

{$IFDEF FEATURE_RIPPLE_EFFECT}
  FRippleEffect := TRippleEffect.Create(Self);
  FEnableRipple := False;
{$ENDIF}

{$IFDEF FEATURE_GRADIENTS}
  FUseGradient := False;
  FGradientStartColor := TAlphaColorRec.Dodgerblue;
  FGradientEndColor := TAlphaColorRec.Deepskyblue;
{$ENDIF}
end;

destructor TFMXStyledButton.Destroy;
begin
{$IFDEF FEATURE_RIPPLE_EFFECT}
  FRippleEffect.Free;
{$ENDIF}
  inherited;
end;

procedure TFMXStyledButton.SetStyleDrawType(const Value: TStyledButtonDrawType);
begin
  if FStyleDrawType <> Value then
  begin
    FStyleDrawType := Value;
    Repaint;
  end;
end;

procedure TFMXStyledButton.SetStyleRadius(const Value: Single);
begin
  if FStyleRadius <> Value then
  begin
    FStyleRadius := Value;
    Repaint;
  end;
end;

procedure TFMXStyledButton.SetRoundedCorners(const Value: TStyledButtonRoundedCorners);
begin
  if FRoundedCorners <> Value then
  begin
    FRoundedCorners := Value;
    Repaint;
  end;
end;

procedure TFMXStyledButton.SetButtonColor(const Value: TAlphaColor);
begin
  if FButtonColor <> Value then
  begin
    FButtonColor := Value;
    Repaint;
  end;
end;

procedure TFMXStyledButton.SetBorderColor(const Value: TAlphaColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Repaint;
  end;
end;

procedure TFMXStyledButton.SetBorderWidth(const Value: Single);
begin
  if FBorderWidth <> Value then
  begin
    FBorderWidth := Value;
    Repaint;
  end;
end;

{$IFDEF FEATURE_DARK_MODE}
procedure TFMXStyledButton.SetThemeMode(const Value: TStyledButtonThemeMode);
begin
  if FThemeMode <> Value then
  begin
    FThemeMode := Value;
    ApplyThemeColors;
    Repaint;
  end;
end;

procedure TFMXStyledButton.ApplyThemeColors;
{$IFDEF PLATFORM_WINDOWS}
var
  Reg: TRegistry;
  UseLightTheme: Integer;
  IsDark: Boolean;
{$ENDIF}
begin
  if FThemeMode = tmAuto then
  begin
{$IFDEF PLATFORM_WINDOWS}
    IsDark := False;
    Reg := TRegistry.Create(KEY_READ);
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Themes\Personalize') then
      begin
        if Reg.ValueExists('AppsUseLightTheme') then
        begin
          UseLightTheme := Reg.ReadInteger('AppsUseLightTheme');
          IsDark := (UseLightTheme = 0);
        end;
        Reg.CloseKey;
      end;
    finally
      Reg.Free;
    end;

    if IsDark then
    begin
      FButtonColor := $FF2B2B2B;
      TextSettings.FontColor := TAlphaColorRec.White;
    end
    else
    begin
      FButtonColor := TAlphaColorRec.Dodgerblue;
      TextSettings.FontColor := TAlphaColorRec.White;
    end;
{$ENDIF}
{$IFDEF PLATFORM_MACOS}
    // TODO: Implement macOS dark mode detection
{$ENDIF}
  end
  else if FThemeMode = tmDark then
  begin
    FButtonColor := $FF2B2B2B;
    TextSettings.FontColor := TAlphaColorRec.White;
  end
  else if FThemeMode = tmLight then
  begin
    FButtonColor := TAlphaColorRec.Dodgerblue;
    TextSettings.FontColor := TAlphaColorRec.White;
  end;
end;
{$ENDIF}

{$IFDEF FEATURE_GRADIENTS}
procedure TFMXStyledButton.SetUseGradient(const Value: Boolean);
begin
  if FUseGradient <> Value then
  begin
    FUseGradient := Value;
    Repaint;
  end;
end;

procedure TFMXStyledButton.SetGradientStartColor(const Value: TAlphaColor);
begin
  if FGradientStartColor <> Value then
  begin
    FGradientStartColor := Value;
    if FUseGradient then
      Repaint;
  end;
end;

procedure TFMXStyledButton.SetGradientEndColor(const Value: TAlphaColor);
begin
  if FGradientEndColor <> Value then
  begin
    FGradientEndColor := Value;
    if FUseGradient then
      Repaint;
  end;
end;
{$ENDIF}

{$IFDEF FEATURE_LOADING_STATE}
procedure TFMXStyledButton.SetLoading(const ALoading: Boolean; const AText: string);
begin
  if FIsLoading <> ALoading then
  begin
    FIsLoading := ALoading;

    if FIsLoading then
    begin
      FSavedText := Text;
      FSavedEnabled := Enabled;
      Text := AText;
      Enabled := False;
      FLoadingSpinner.Start;

      // Position spinner in center
      FLoadingSpinner.Position.X := (Width - FLoadingSpinner.Width) / 2;
      FLoadingSpinner.Position.Y := (Height - FLoadingSpinner.Height) / 2;
    end
    else
    begin
      FLoadingSpinner.Stop;
      Enabled := FSavedEnabled;
      Text := FSavedText;
    end;
  end;
end;
{$ENDIF}

function TFMXStyledButton.GetCornerRadius: TCorners;
begin
  Result := [];
  if rcTopLeft in FRoundedCorners then
    Include(Result, TCorner.TopLeft);
  if rcTopRight in FRoundedCorners then
    Include(Result, TCorner.TopRight);
  if rcBottomLeft in FRoundedCorners then
    Include(Result, TCorner.BottomLeft);
  if rcBottomRight in FRoundedCorners then
    Include(Result, TCorner.BottomRight);
end;

procedure TFMXStyledButton.Paint;
var
  R: TRectF;
  Radius: Single;
begin
  R := LocalRect;

  Canvas.BeginScene;
  try
    // Determine radius based on draw type
    case FStyleDrawType of
      btRoundRect: Radius := FStyleRadius;
      btRect: Radius := 0;
      btRounded: Radius := Min(R.Width, R.Height) / 2;
      btEllipse: Radius := Min(R.Width, R.Height) / 2;
    end;

    // Fill button
{$IFDEF FEATURE_GRADIENTS}
    if FUseGradient then
    begin
      Canvas.Fill.Kind := TBrushKind.Gradient;
      Canvas.Fill.Gradient.Color := FGradientStartColor;
      Canvas.Fill.Gradient.Color1 := FGradientEndColor;
      Canvas.Fill.Gradient.Style := TGradientStyle.Linear;
    end
    else
{$ENDIF}
    begin
      Canvas.Fill.Kind := TBrushKind.Solid;
      Canvas.Fill.Color := FButtonColor;
    end;

    if FStyleDrawType = btEllipse then
      Canvas.FillEllipse(R, 1.0)
    else
      Canvas.FillRect(R, Radius, Radius, GetCornerRadius, 1.0);

    // Draw border
    if FBorderWidth > 0 then
    begin
      Canvas.Stroke.Kind := TBrushKind.Solid;
      Canvas.Stroke.Color := FBorderColor;
      Canvas.Stroke.Thickness := FBorderWidth;

      if FStyleDrawType = btEllipse then
        Canvas.DrawEllipse(R, 1.0)
      else
        Canvas.DrawRect(R, Radius, Radius, GetCornerRadius, 1.0);
    end;

{$IFDEF FEATURE_RIPPLE_EFFECT}
    // Draw ripple effect
    if FEnableRipple and Assigned(FRippleEffect) then
      FRippleEffect.Draw(Canvas, R);
{$ENDIF}

  finally
    Canvas.EndScene;
  end;

  inherited;  // Draw text and other standard button elements
end;

procedure TFMXStyledButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;

{$IFDEF FEATURE_RIPPLE_EFFECT}
  if FEnableRipple and (Button = TMouseButton.mbLeft) then
    FRippleEffect.Start(PointF(X, Y));
{$ENDIF}
end;

procedure TFMXStyledButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;
end;

procedure Register;
begin
  RegisterComponents('Styled FMX', [TFMXStyledButton]);
end;

end.
