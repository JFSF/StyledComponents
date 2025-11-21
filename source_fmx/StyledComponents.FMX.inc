{******************************************************************************}
{                                                                              }
{  StyledComponents FMX: Conditional Compilation Defines                      }
{                                                                              }
{  Copyright (c) 2025 (Ethea S.r.l.)                                          }
{  Author: Claude AI / Carlo Barazzetta                                       }
{                                                                              }
{  https://github.com/EtheaDev/StyledComponents                               }
{                                                                              }
{******************************************************************************}

{.$Define ItaMessages}
{.$Define FraMessages}

// FMX Features (all enabled by default for FMX)
{$DEFINE FEATURE_ANIMATIONS}       // FMX native animation support
{$DEFINE FEATURE_DARK_MODE}        // Dark mode detection (all platforms)
{$DEFINE FEATURE_LOADING_STATE}    // Loading state with spinner
{$DEFINE FEATURE_RIPPLE_EFFECT}    // Material Design ripple effect
{$DEFINE FEATURE_GRADIENTS}        // Native FMX gradient support
{$DEFINE FEATURE_SHADOWS}          // Drop shadows (FMX native)

// Style Families
{$DEFINE INCLUDE_MaterialDesign}   // Material Design styles
{$DEFINE INCLUDE_CupertinoStyles}  // iOS/macOS Cupertino styles
{$DEFINE INCLUDE_BootstrapStyles}  // Bootstrap styles
{$DEFINE INCLUDE_FluentDesign}     // Windows 11 Fluent Design

// Platform detection
{$IFDEF MSWINDOWS}
  {$DEFINE PLATFORM_WINDOWS}
{$ENDIF}

{$IFDEF MACOS}
  {$DEFINE PLATFORM_MACOS}
{$ENDIF}

{$IFDEF IOS}
  {$DEFINE PLATFORM_IOS}
{$ENDIF}

{$IFDEF ANDROID}
  {$DEFINE PLATFORM_ANDROID}
{$ENDIF}

{$IFDEF LINUX}
  {$DEFINE PLATFORM_LINUX}
{$ENDIF}

// Delphi 10.3 Rio (minimum version for modern FMX)
{$IFDEF VER330}
  {$DEFINE D10_3+}
{$ENDIF}

// Delphi 10.4 Sydney
{$IFDEF VER340}
  {$DEFINE D10_3+}
  {$DEFINE D10_4+}
{$ENDIF}

// Delphi 11 Alexandria
{$IFDEF VER350}
  {$DEFINE D10_3+}
  {$DEFINE D10_4+}
  {$DEFINE D11+}
{$ENDIF}

// Delphi 12 Athens
{$IFDEF VER360}
  {$DEFINE D10_3+}
  {$DEFINE D10_4+}
  {$DEFINE D11+}
  {$DEFINE D12+}
{$ENDIF}

// FMX always has animation support
{$DEFINE AnimationSupport}

// FMX always has GPU acceleration
{$DEFINE GPUAcceleration}
