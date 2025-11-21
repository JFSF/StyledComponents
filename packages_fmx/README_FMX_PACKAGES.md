# StyledComponents FMX Packages

## Installation Instructions

### Supported Delphi Versions

- **Delphi 10.4 Sydney** - Use `D10_4/StyledComponentsFMX.dpk`
- **Delphi 11 Alexandria** - Use `D11/StyledComponentsFMX.dpk`
- **Delphi 12 Athens** - Use `D12/StyledComponentsFMX.dpk`

### Installation Steps

1. **Open the Package**
   - Navigate to the appropriate folder for your Delphi version
   - Open `StyledComponentsFMX.dpk` in Delphi IDE

2. **Compile the Package**
   - Right-click on the package project in Project Manager
   - Select "Compile"
   - Ensure there are no compilation errors

3. **Install the Package**
   - Right-click on the package project
   - Select "Install"
   - The components will be registered in the IDE

4. **Verify Installation**
   - Open the Tool Palette
   - Look for the "Styled FMX" category
   - You should see all FMX styled components listed

### Package Contents

The FMX package includes the following components:

#### Components
- **TFMXStyledButton** - Styled button with multiple themes and effects
- **TFMXStyledToolbar** - Toolbar with styled tool buttons
- **TFMXStyledTaskDialog** - Customizable task dialog with styled buttons
- **TFMXStyledButtonGroup** - Group of styled buttons with selection support
- **TFMXStyledDbNavigator** - Database navigator with styled buttons

#### Support Units
- **FMX.ButtonStyles** - Style definitions (Material, Cupertino, Bootstrap, Fluent)

### Platform Support

All components support the following platforms:

- ✅ Windows (32-bit and 64-bit)
- ✅ macOS (64-bit)
- ✅ iOS (Device and Simulator)
- ✅ Android (32-bit and 64-bit)
- ✅ Linux (64-bit) - Delphi 12+

### Dependencies

The package requires the following Delphi runtime packages:

- `rtl` - Runtime Library
- `fmx` - FireMonkey Framework
- `dbrtl` - Database Runtime Library
- `fmxase` - FMX Application Services
- `bindengine` - LiveBindings Engine
- `bindcomp` - LiveBindings Components

### Features by Component

#### TFMXStyledButton
- Multiple style families (Material, Cupertino, Bootstrap, Fluent)
- Draw types: Rounded, Rectangle, Ellipse
- Dark mode auto-detection
- Loading state with animated spinner
- Ripple effect (Material Design)
- Notification badge support
- Gradient support
- Shadow effects

#### TFMXStyledToolbar
- Horizontal and vertical orientation
- Dynamic button creation
- Button grouping
- Separator and divider support
- Image support via ImageList
- Custom button styles

#### TFMXStyledTaskDialog
- Customizable title and message
- Multiple button combinations
- Icon support (Warning, Error, Information, Question, Shield)
- Event handling for button clicks
- Custom button captions
- Modal dialogs

#### TFMXStyledButtonGroup
- Vertical and horizontal layouts
- Item-based button creation
- Single selection mode
- Image support
- Custom spacing and sizing

#### TFMXStyledDbNavigator
- All standard navigator buttons (First, Prior, Next, Last, etc.)
- Horizontal and vertical orientation
- Optional button captions
- Confirm delete option
- Custom hints
- DataSource binding

### Conditional Compilation

The FMX components use conditional compilation to enable/disable features:

```pascal
{$DEFINE FEATURE_ANIMATIONS}       // FMX native animation support
{$DEFINE FEATURE_DARK_MODE}        // Dark mode detection (all platforms)
{$DEFINE FEATURE_LOADING_STATE}    // Loading state with spinner
{$DEFINE FEATURE_RIPPLE_EFFECT}    // Material Design ripple effect
{$DEFINE FEATURE_GRADIENTS}        // Native FMX gradient support
{$DEFINE FEATURE_SHADOWS}          // Drop shadows (FMX native)
```

All features are enabled by default. To disable a feature, comment out the corresponding define in `source_fmx/StyledComponents.FMX.inc`.

### Troubleshooting

**Component palette doesn't show components:**
- Verify the package installed successfully
- Restart Delphi IDE
- Check Tools → Options → Library → Library Path includes the source_fmx folder

**Compilation errors:**
- Ensure you're using the correct package for your Delphi version
- Verify all required runtime packages are available
- Check that the source_fmx folder path is correct

**Platform-specific issues:**
- Some features may behave differently on different platforms
- Dark mode detection is platform-specific (Windows Registry on Windows, NSUserDefaults on macOS)
- Ripple effects are optimized for touch devices (iOS/Android)

### License

Copyright (c) 2025 Ethea S.r.l.

Licensed under the Apache License, Version 2.0
See the LICENSE file in the project root for full license information.

### Support

For issues, questions, or contributions:
- GitHub: https://github.com/EtheaDev/StyledComponents
- Report bugs: https://github.com/EtheaDev/StyledComponents/issues

### Version Information

- **FMX Port Version**: 1.0.0
- **Based on VCL Version**: 3.8.1
- **Initial Release**: 2025
