{******************************************************************************}
{                                                                              }
{  FMX.ButtonStyles: Style definitions for Styled FMX Components              }
{  Material Design, Cupertino, Bootstrap, and Fluent Design styles            }
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
unit FMX.ButtonStyles;

interface

{$I StyledComponents.FMX.inc}

uses
  System.UITypes,
  System.SysUtils,
  FMX.Graphics;

type
  { Style Families }
  TButtonStyleFamily = (
    bsfMaterial,    // Material Design (Google)
    bsfCupertino,   // iOS/macOS style
    bsfBootstrap,   // Bootstrap web framework
    bsfFluent       // Windows 11 Fluent Design
  );

  { Style Classes - Semantic button types }
  TButtonStyleClass = (
    bscPrimary,
    bscSecondary,
    bscSuccess,
    bscDanger,
    bscWarning,
    bscInfo,
    bscLight,
    bscDark,
    bscLink
  );

  { Style Appearance - Visual variants }
  TButtonStyleAppearance = (
    bsaNormal,      // Standard filled button
    bsaOutlined,    // Outlined/bordered button
    bsaText,        // Text-only button (no background)
    bsaRaised,      // Raised with shadow
    bsaFlat         // Flat without elevation
  );

  { Button Style Configuration }
  TButtonStyleConfig = record
    BackgroundColor: TAlphaColor;
    BorderColor: TAlphaColor;
    TextColor: TAlphaColor;
    BorderWidth: Single;
    CornerRadius: Single;
    Elevation: Single;
    class function Create(ABackground, ABorder, AText: TAlphaColor;
      ABorderWidth: Single = 1; ARadius: Single = 4; AElevation: Single = 0): TButtonStyleConfig; static;
  end;

  { Theme Mode }
  TThemeMode = (tmLight, tmDark, tmAuto);

{ Material Design Colors }
const
  // Primary colors
  MD_PRIMARY = $FF6200EE;           // Purple 500
  MD_PRIMARY_VARIANT = $FF3700B3;   // Purple 700
  MD_SECONDARY = $FF03DAC6;         // Teal 200
  MD_SECONDARY_VARIANT = $FF018786; // Teal 700

  // Semantic colors
  MD_ERROR = $FFB00020;             // Red 700
  MD_SUCCESS = $FF4CAF50;           // Green 500
  MD_WARNING = $FFFFC107;           // Amber 500
  MD_INFO = $FF2196F3;              // Blue 500

  // Surface colors
  MD_SURFACE_LIGHT = $FFFFFFFF;     // White
  MD_SURFACE_DARK = $FF121212;      // Near black
  MD_BACKGROUND_LIGHT = $FFFAFAFA;  // Very light gray
  MD_BACKGROUND_DARK = $FF000000;   // Black

  // Text colors
  MD_TEXT_PRIMARY_LIGHT = $DE000000;   // 87% black
  MD_TEXT_SECONDARY_LIGHT = $99000000; // 60% black
  MD_TEXT_PRIMARY_DARK = $FFFFFFFF;    // White
  MD_TEXT_SECONDARY_DARK = $B3FFFFFF;  // 70% white

{ Cupertino (iOS/macOS) Colors }
const
  CUP_BLUE = $FF007AFF;             // iOS Blue
  CUP_GREEN = $FF34C759;            // iOS Green
  CUP_ORANGE = $FFFF9500;           // iOS Orange
  CUP_RED = $FFFF3B30;              // iOS Red
  CUP_YELLOW = $FFFFC107;           // iOS Yellow
  CUP_GRAY = $FF8E8E93;             // iOS Gray

  CUP_BACKGROUND_LIGHT = $FFF2F2F7;
  CUP_BACKGROUND_DARK = $FF000000;
  CUP_SURFACE_LIGHT = $FFFFFFFF;
  CUP_SURFACE_DARK = $FF1C1C1E;

  CUP_TEXT_LIGHT = $FF000000;
  CUP_TEXT_DARK = $FFFFFFFF;

{ Bootstrap Colors }
const
  BS_PRIMARY = $FF0D6EFD;           // Blue
  BS_SECONDARY = $FF6C757D;         // Gray
  BS_SUCCESS = $FF198754;           // Green
  BS_DANGER = $FFDC3545;            // Red
  BS_WARNING = $FFFFC107;           // Yellow
  BS_INFO = $FF0DCAF0;              // Cyan
  BS_LIGHT = $FFF8F9FA;             // Light gray
  BS_DARK = $FF212529;              // Dark gray

  BS_TEXT_LIGHT = $FF212529;
  BS_TEXT_DARK = $FFFFFFFF;

{ Fluent Design Colors }
const
  FD_ACCENT = $FF0078D4;            // Windows Blue
  FD_SUCCESS = $FF107C10;           // Green
  FD_DANGER = $FFE81123;            // Red
  FD_WARNING = $FFFFC107;           // Yellow
  FD_INFO = $FF00BCF2;              // Cyan

  FD_BACKGROUND_LIGHT = $FFF3F3F3;
  FD_BACKGROUND_DARK = $FF202020;
  FD_SURFACE_LIGHT = $FFFFFFFF;
  FD_SURFACE_DARK = $FF2D2D2D;

  FD_TEXT_LIGHT = $FF000000;
  FD_TEXT_DARK = $FFFFFFFF;

{ Helper Functions }
function GetStyleConfig(AFamily: TButtonStyleFamily; AClass: TButtonStyleClass;
  AAppearance: TButtonStyleAppearance; AIsDark: Boolean = False): TButtonStyleConfig;

function GetMaterialConfig(AClass: TButtonStyleClass; AAppearance: TButtonStyleAppearance;
  AIsDark: Boolean): TButtonStyleConfig;

function GetCupertinoConfig(AClass: TButtonStyleClass; AAppearance: TButtonStyleAppearance;
  AIsDark: Boolean): TButtonStyleConfig;

function GetBootstrapConfig(AClass: TButtonStyleClass; AAppearance: TButtonStyleAppearance;
  AIsDark: Boolean): TButtonStyleConfig;

function GetFluentConfig(AClass: TButtonStyleClass; AAppearance: TButtonStyleAppearance;
  AIsDark: Boolean): TButtonStyleConfig;

implementation

{ TButtonStyleConfig }

class function TButtonStyleConfig.Create(ABackground, ABorder, AText: TAlphaColor;
  ABorderWidth, ARadius, AElevation: Single): TButtonStyleConfig;
begin
  Result.BackgroundColor := ABackground;
  Result.BorderColor := ABorder;
  Result.TextColor := AText;
  Result.BorderWidth := ABorderWidth;
  Result.CornerRadius := ARadius;
  Result.Elevation := AElevation;
end;

{ Material Design Styles }

function GetMaterialConfig(AClass: TButtonStyleClass; AAppearance: TButtonStyleAppearance;
  AIsDark: Boolean): TButtonStyleConfig;
var
  LBgColor, LBorderColor, LTextColor: TAlphaColor;
  LRadius, LElevation: Single;
begin
  // Default Material Design values
  LRadius := 4;
  LElevation := 0;

  case AClass of
    bscPrimary:
      begin
        LBgColor := MD_PRIMARY;
        LTextColor := MD_TEXT_PRIMARY_DARK;
      end;
    bscSecondary:
      begin
        LBgColor := MD_SECONDARY;
        LTextColor := MD_TEXT_PRIMARY_DARK;
      end;
    bscSuccess:
      begin
        LBgColor := MD_SUCCESS;
        LTextColor := MD_TEXT_PRIMARY_DARK;
      end;
    bscDanger:
      begin
        LBgColor := MD_ERROR;
        LTextColor := MD_TEXT_PRIMARY_DARK;
      end;
    bscWarning:
      begin
        LBgColor := MD_WARNING;
        LTextColor := MD_TEXT_PRIMARY_LIGHT;
      end;
    bscInfo:
      begin
        LBgColor := MD_INFO;
        LTextColor := MD_TEXT_PRIMARY_DARK;
      end;
  else
    if AIsDark then
    begin
      LBgColor := MD_SURFACE_DARK;
      LTextColor := MD_TEXT_PRIMARY_DARK;
    end
    else
    begin
      LBgColor := MD_SURFACE_LIGHT;
      LTextColor := MD_TEXT_PRIMARY_LIGHT;
    end;
  end;

  LBorderColor := LBgColor;

  case AAppearance of
    bsaOutlined:
      begin
        if AIsDark then
          LBgColor := TAlphaColorRec.Null
        else
          LBgColor := TAlphaColorRec.Null;
        LElevation := 0;
      end;
    bsaText:
      begin
        LBgColor := TAlphaColorRec.Null;
        LBorderColor := TAlphaColorRec.Null;
        LElevation := 0;
      end;
    bsaRaised:
      LElevation := 4;
    bsaFlat:
      LElevation := 0;
  end;

  Result := TButtonStyleConfig.Create(LBgColor, LBorderColor, LTextColor, 1, LRadius, LElevation);
end;

{ Cupertino Styles }

function GetCupertinoConfig(AClass: TButtonStyleClass; AAppearance: TButtonStyleAppearance;
  AIsDark: Boolean): TButtonStyleConfig;
var
  LBgColor, LBorderColor, LTextColor: TAlphaColor;
  LRadius: Single;
begin
  LRadius := 8; // iOS uses more rounded corners

  case AClass of
    bscPrimary:
      begin
        LBgColor := CUP_BLUE;
        LTextColor := CUP_TEXT_DARK;
      end;
    bscSuccess:
      begin
        LBgColor := CUP_GREEN;
        LTextColor := CUP_TEXT_DARK;
      end;
    bscDanger:
      begin
        LBgColor := CUP_RED;
        LTextColor := CUP_TEXT_DARK;
      end;
    bscWarning:
      begin
        LBgColor := CUP_ORANGE;
        LTextColor := CUP_TEXT_DARK;
      end;
  else
    if AIsDark then
    begin
      LBgColor := CUP_SURFACE_DARK;
      LTextColor := CUP_TEXT_DARK;
    end
    else
    begin
      LBgColor := CUP_SURFACE_LIGHT;
      LTextColor := CUP_TEXT_LIGHT;
    end;
  end;

  LBorderColor := LBgColor;

  if AAppearance = bsaOutlined then
  begin
    LBgColor := TAlphaColorRec.Null;
  end
  else if AAppearance = bsaText then
  begin
    LBgColor := TAlphaColorRec.Null;
    LBorderColor := TAlphaColorRec.Null;
  end;

  Result := TButtonStyleConfig.Create(LBgColor, LBorderColor, LTextColor, 1, LRadius, 0);
end;

{ Bootstrap Styles }

function GetBootstrapConfig(AClass: TButtonStyleClass; AAppearance: TButtonStyleAppearance;
  AIsDark: Boolean): TButtonStyleConfig;
var
  LBgColor, LBorderColor, LTextColor: TAlphaColor;
begin
  case AClass of
    bscPrimary:
      begin
        LBgColor := BS_PRIMARY;
        LBorderColor := BS_PRIMARY;
        LTextColor := BS_TEXT_DARK;
      end;
    bscSecondary:
      begin
        LBgColor := BS_SECONDARY;
        LBorderColor := BS_SECONDARY;
        LTextColor := BS_TEXT_DARK;
      end;
    bscSuccess:
      begin
        LBgColor := BS_SUCCESS;
        LBorderColor := BS_SUCCESS;
        LTextColor := BS_TEXT_DARK;
      end;
    bscDanger:
      begin
        LBgColor := BS_DANGER;
        LBorderColor := BS_DANGER;
        LTextColor := BS_TEXT_DARK;
      end;
    bscWarning:
      begin
        LBgColor := BS_WARNING;
        LBorderColor := BS_WARNING;
        LTextColor := BS_TEXT_LIGHT;
      end;
    bscInfo:
      begin
        LBgColor := BS_INFO;
        LBorderColor := BS_INFO;
        LTextColor := BS_TEXT_LIGHT;
      end;
    bscLight:
      begin
        LBgColor := BS_LIGHT;
        LBorderColor := BS_LIGHT;
        LTextColor := BS_TEXT_LIGHT;
      end;
    bscDark:
      begin
        LBgColor := BS_DARK;
        LBorderColor := BS_DARK;
        LTextColor := BS_TEXT_DARK;
      end;
  else
    LBgColor := BS_SECONDARY;
    LBorderColor := BS_SECONDARY;
    LTextColor := BS_TEXT_DARK;
  end;

  if AAppearance = bsaOutlined then
  begin
    LTextColor := LBgColor;
    LBgColor := TAlphaColorRec.Null;
  end
  else if AAppearance = bsaText then
  begin
    LTextColor := LBgColor;
    LBgColor := TAlphaColorRec.Null;
    LBorderColor := TAlphaColorRec.Null;
  end;

  Result := TButtonStyleConfig.Create(LBgColor, LBorderColor, LTextColor, 1, 4, 0);
end;

{ Fluent Design Styles }

function GetFluentConfig(AClass: TButtonStyleClass; AAppearance: TButtonStyleAppearance;
  AIsDark: Boolean): TButtonStyleConfig;
var
  LBgColor, LBorderColor, LTextColor: TAlphaColor;
begin
  case AClass of
    bscPrimary:
      begin
        LBgColor := FD_ACCENT;
        LTextColor := FD_TEXT_DARK;
      end;
    bscSuccess:
      begin
        LBgColor := FD_SUCCESS;
        LTextColor := FD_TEXT_DARK;
      end;
    bscDanger:
      begin
        LBgColor := FD_DANGER;
        LTextColor := FD_TEXT_DARK;
      end;
    bscWarning:
      begin
        LBgColor := FD_WARNING;
        LTextColor := FD_TEXT_LIGHT;
      end;
    bscInfo:
      begin
        LBgColor := FD_INFO;
        LTextColor := FD_TEXT_LIGHT;
      end;
  else
    if AIsDark then
    begin
      LBgColor := FD_SURFACE_DARK;
      LTextColor := FD_TEXT_DARK;
    end
    else
    begin
      LBgColor := FD_SURFACE_LIGHT;
      LTextColor := FD_TEXT_LIGHT;
    end;
  end;

  LBorderColor := LBgColor;

  if AAppearance = bsaOutlined then
  begin
    LBgColor := TAlphaColorRec.Null;
  end
  else if AAppearance = bsaText then
  begin
    LBgColor := TAlphaColorRec.Null;
    LBorderColor := TAlphaColorRec.Null;
  end;

  Result := TButtonStyleConfig.Create(LBgColor, LBorderColor, LTextColor, 1, 2, 0);
end;

{ Main Style Configuration Function }

function GetStyleConfig(AFamily: TButtonStyleFamily; AClass: TButtonStyleClass;
  AAppearance: TButtonStyleAppearance; AIsDark: Boolean): TButtonStyleConfig;
begin
  case AFamily of
    bsfMaterial: Result := GetMaterialConfig(AClass, AAppearance, AIsDark);
    bsfCupertino: Result := GetCupertinoConfig(AClass, AAppearance, AIsDark);
    bsfBootstrap: Result := GetBootstrapConfig(AClass, AAppearance, AIsDark);
    bsfFluent: Result := GetFluentConfig(AClass, AAppearance, AIsDark);
  else
    Result := GetMaterialConfig(AClass, AAppearance, AIsDark);
  end;
end;

end.
