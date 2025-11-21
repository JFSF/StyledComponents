# StyledComponents FMX - Usage Examples

Complete code examples for using all FMX Styled Components.

## Table of Contents

1. [TFMXStyledButton](#tfmxstyledbutton)
2. [TFMXStyledToolbar](#tfmxstyledtoolbar)
3. [TFMXStyledTaskDialog](#tfmxstyledtaskdialog)
4. [TFMXStyledButtonGroup](#tfmxstyledbuttongroup)
5. [TFMXStyledDbNavigator](#tfmxstyleddbnavigator)
6. [Style Families](#style-families)
7. [Platform-Specific Features](#platform-specific-features)

---

## TFMXStyledButton

### Basic Button

```pascal
uses
  FMX.StyledButton;

procedure TForm1.CreateBasicButton;
var
  Btn: TFMXStyledButton;
begin
  Btn := TFMXStyledButton.Create(Self);
  Btn.Parent := Self;
  Btn.Position.X := 20;
  Btn.Position.Y := 20;
  Btn.Width := 120;
  Btn.Height := 40;
  Btn.Text := 'Click Me';
  Btn.OnClick := ButtonClick;
end;
```

### Material Design Button

```pascal
procedure TForm1.CreateMaterialButton;
var
  Btn: TFMXStyledButton;
begin
  Btn := TFMXStyledButton.Create(Self);
  Btn.Parent := Self;
  Btn.Text := 'Material Button';
  Btn.StyleDrawType := btRounded;
  Btn.ButtonColor := TAlphaColorRec.Dodgerblue;
  Btn.EnableRipple := True;  // Material Design ripple effect
  Btn.Position.X := 20;
  Btn.Position.Y := 80;
end;
```

### Button with Loading State

```pascal
procedure TForm1.SaveButtonClick(Sender: TObject);
begin
  SaveButton.SetLoading(True, 'Saving...');
  try
    // Perform save operation
    Sleep(2000); // Simulate long operation
    SaveData;
  finally
    SaveButton.SetLoading(False);
  end;
end;
```

### Button with Notification Badge

```pascal
procedure TForm1.CreateButtonWithBadge;
var
  Btn: TFMXStyledButton;
begin
  Btn := TFMXStyledButton.Create(Self);
  Btn.Parent := Self;
  Btn.Text := 'Messages';
  Btn.NotificationBadge.Value := 5;
  Btn.NotificationBadge.Visible := True;
  Btn.NotificationBadge.BackgroundColor := TAlphaColorRec.Red;
end;
```

### Dark Mode Auto-Detection

```pascal
procedure TForm1.CreateDarkModeButton;
var
  Btn: TFMXStyledButton;
begin
  Btn := TFMXStyledButton.Create(Self);
  Btn.Parent := Self;
  Btn.Text := 'Auto Theme';
  Btn.ThemeMode := tmAuto;  // Automatically detects system theme
  // Will adjust colors based on Windows/macOS dark mode setting
end;
```

### Button with Gradient

```pascal
procedure TForm1.CreateGradientButton;
var
  Btn: TFMXStyledButton;
begin
  Btn := TFMXStyledButton.Create(Self);
  Btn.Parent := Self;
  Btn.Text := 'Gradient';
  Btn.UseGradient := True;
  Btn.GradientStartColor := TAlphaColorRec.Deepskyblue;
  Btn.GradientEndColor := TAlphaColorRec.Dodgerblue;
  Btn.GradientDirection := gdVertical;
end;
```

---

## TFMXStyledToolbar

### Basic Toolbar

```pascal
uses
  FMX.StyledToolbar;

procedure TForm1.CreateToolbar;
var
  Toolbar: TFMXStyledToolbar;
  Btn: TFMXStyledToolButton;
begin
  Toolbar := TFMXStyledToolbar.Create(Self);
  Toolbar.Parent := Self;
  Toolbar.Align := TAlignLayout.Top;
  Toolbar.Height := 50;
  Toolbar.OnButtonClick := ToolbarButtonClick;

  // Add buttons
  Btn := Toolbar.AddButton;
  Btn.Text := 'New';
  Btn.Hint := 'Create new document';

  Btn := Toolbar.AddButton;
  Btn.Text := 'Open';
  Btn.Hint := 'Open existing document';

  // Add separator
  Btn := Toolbar.AddButton;
  Btn.Style := tbsSeparator;

  Btn := Toolbar.AddButton;
  Btn.Text := 'Save';
  Btn.Hint := 'Save document';
end;
```

### Toolbar with Images

```pascal
procedure TForm1.CreateToolbarWithImages;
var
  Toolbar: TFMXStyledToolbar;
  Btn: TFMXStyledToolButton;
  ImageList: TImageList;
begin
  // Create ImageList first
  ImageList := TImageList.Create(Self);
  // Add images to ImageList...

  Toolbar := TFMXStyledToolbar.Create(Self);
  Toolbar.Parent := Self;
  Toolbar.Images := ImageList;
  Toolbar.ShowCaptions := False;  // Show only icons

  Btn := Toolbar.AddButton;
  Btn.ImageIndex := 0;  // New icon
  Btn.Hint := 'New';

  Btn := Toolbar.AddButton;
  Btn.ImageIndex := 1;  // Open icon
  Btn.Hint := 'Open';
end;
```

### Vertical Toolbar

```pascal
procedure TForm1.CreateVerticalToolbar;
var
  Toolbar: TFMXStyledToolbar;
begin
  Toolbar := TFMXStyledToolbar.Create(Self);
  Toolbar.Parent := Self;
  Toolbar.Align := TAlignLayout.Left;
  Toolbar.Width := 50;
  Toolbar.Orientation := TOrientation.Vertical;
  Toolbar.ShowCaptions := False;

  // Add buttons...
end;
```

---

## TFMXStyledTaskDialog

### Simple Message Dialog

```pascal
uses
  FMX.StyledTaskDialog;

procedure TForm1.ShowSimpleMessage;
begin
  StyledShowMessage('Success', 'Operation completed successfully!',
    TMsgDlgType.mtInformation);
end;
```

### Confirmation Dialog

```pascal
procedure TForm1.DeleteButtonClick(Sender: TObject);
var
  LResult: TModalResult;
begin
  LResult := StyledTaskMessageDlg(
    'Confirm Delete',
    'Are you sure you want to delete this item?',
    TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbNo  // Default button
  );

  if LResult = mrYes then
  begin
    // Perform delete
    DeleteItem;
  end;
end;
```

### Custom Task Dialog

```pascal
procedure TForm1.ShowCustomDialog;
var
  Dialog: TFMXStyledTaskDialog;
begin
  Dialog := TFMXStyledTaskDialog.Create(Self);
  try
    Dialog.Title := 'Save Changes?';
    Dialog.Text := 'Do you want to save changes before closing?';
    Dialog.Icon := tdiQuestion;
    Dialog.Buttons := [tdbYes, tdbNo, tdbCancel];
    Dialog.DefaultButton := tdbYes;
    Dialog.DialogWidth := 500;
    Dialog.DialogHeight := 300;
    Dialog.OnButtonClick := DialogButtonClick;

    case Dialog.Execute of
      mrYes:    SaveAndClose;
      mrNo:     CloseWithoutSaving;
      mrCancel: Exit;
    end;
  finally
    Dialog.Free;
  end;
end;

procedure TForm1.DialogButtonClick(Sender: TObject;
  Button: TFMXTaskDialogButton; var CanClose: Boolean);
begin
  // Validate before allowing close
  if Button = tdbYes then
  begin
    if not ValidateData then
    begin
      ShowMessage('Please fix errors before saving');
      CanClose := False;
    end;
  end;
end;
```

### Error Dialog with Custom Icon

```pascal
procedure TForm1.ShowError;
var
  Dialog: TFMXStyledTaskDialog;
begin
  Dialog := TFMXStyledTaskDialog.Create(Self);
  try
    Dialog.Title := 'Error';
    Dialog.Text := 'An error occurred while processing your request.' + #13#10 +
                   'Please try again or contact support.';
    Dialog.Icon := tdiError;
    Dialog.Buttons := [tdbOK, tdbRetry];
    Dialog.ButtonFamily := 'Material';
    Dialog.ButtonClass := 'Danger';

    if Dialog.Execute = mrRetry then
      RetryOperation;
  finally
    Dialog.Free;
  end;
end;
```

---

## TFMXStyledButtonGroup

### Basic Button Group

```pascal
uses
  FMX.StyledButtonGroup;

procedure TForm1.CreateButtonGroup;
var
  Group: TFMXStyledButtonGroup;
begin
  Group := TFMXStyledButtonGroup.Create(Self);
  Group.Parent := Self;
  Group.Position.X := 20;
  Group.Position.Y := 20;
  Group.Width := 200;
  Group.Height := 300;
  Group.OnButtonClick := ButtonGroupClick;

  // Add items
  with Group.Items.Add do
  begin
    Caption := 'Option 1';
    Hint := 'First option';
  end;

  with Group.Items.Add do
  begin
    Caption := 'Option 2';
    Hint := 'Second option';
  end;

  with Group.Items.Add do
  begin
    Caption := 'Option 3';
    Hint := 'Third option';
  end;

  Group.ItemIndex := 0;  // Select first item
end;

procedure TForm1.ButtonGroupClick(Sender: TObject; Index: Integer);
begin
  ShowMessage('Selected: ' + TFMXStyledButtonGroup(Sender).Items[Index].Caption);
end;
```

### Horizontal Button Group

```pascal
procedure TForm1.CreateHorizontalGroup;
var
  Group: TFMXStyledButtonGroup;
begin
  Group := TFMXStyledButtonGroup.Create(Self);
  Group.Parent := Self;
  Group.Align := TAlignLayout.Top;
  Group.Height := 50;
  Group.Layout := bglHorizontal;

  // Add items...
  Group.Items.Add.Caption := 'Day';
  Group.Items.Add.Caption := 'Week';
  Group.Items.Add.Caption := 'Month';
  Group.Items.Add.Caption := 'Year';
end;
```

### Button Group with Images

```pascal
procedure TForm1.CreateImageButtonGroup;
var
  Group: TFMXStyledButtonGroup;
  ImageList: TImageList;
begin
  ImageList := TImageList.Create(Self);
  // Load images...

  Group := TFMXStyledButtonGroup.Create(Self);
  Group.Parent := Self;
  Group.Images := ImageList;

  with Group.Items.Add do
  begin
    Caption := 'Home';
    ImageIndex := 0;
  end;

  with Group.Items.Add do
  begin
    Caption := 'Settings';
    ImageIndex := 1;
  end;
end;
```

---

## TFMXStyledDbNavigator

### Basic Database Navigator

```pascal
uses
  FMX.StyledDbNavigator, Data.DB;

procedure TForm1.CreateNavigator;
var
  Navigator: TFMXStyledDbNavigator;
begin
  Navigator := TFMXStyledDbNavigator.Create(Self);
  Navigator.Parent := Self;
  Navigator.Align := TAlignLayout.Bottom;
  Navigator.Height := 50;
  Navigator.DataSource := DataSource1;  // Connect to your DataSource
  Navigator.OnButtonClick := NavigatorButtonClick;
end;

procedure TForm1.NavigatorButtonClick(Sender: TObject; Button: TFMXNavigateBtn);
begin
  case Button of
    nbInsert: ShowMessage('Insert clicked');
    nbDelete: ShowMessage('Delete clicked');
    nbPost:   ShowMessage('Post clicked');
  end;
end;
```

### Navigator with Captions

```pascal
procedure TForm1.CreateNavigatorWithCaptions;
var
  Navigator: TFMXStyledDbNavigator;
begin
  Navigator := TFMXStyledDbNavigator.Create(Self);
  Navigator.Parent := Self;
  Navigator.DataSource := DataSource1;
  Navigator.ShowCaptions := True;
  Navigator.ButtonWidth := 80;  // Wider for captions

  // Customize hints
  Navigator.Hints.Clear;
  Navigator.Hints.Add('Go to first record');
  Navigator.Hints.Add('Go to previous record');
  Navigator.Hints.Add('Go to next record');
  Navigator.Hints.Add('Go to last record');
  Navigator.Hints.Add('Insert new record');
  Navigator.Hints.Add('Delete current record');
  Navigator.Hints.Add('Edit current record');
  Navigator.Hints.Add('Save changes');
  Navigator.Hints.Add('Cancel changes');
  Navigator.Hints.Add('Refresh data');
end;
```

### Vertical Navigator

```pascal
procedure TForm1.CreateVerticalNavigator;
var
  Navigator: TFMXStyledDbNavigator;
begin
  Navigator := TFMXStyledDbNavigator.Create(Self);
  Navigator.Parent := Self;
  Navigator.Align := TAlignLayout.Left;
  Navigator.Width := 50;
  Navigator.Orientation := TOrientation.Vertical;
  Navigator.ShowCaptions := False;
  Navigator.DataSource := DataSource1;
end;
```

### Custom Visible Buttons

```pascal
procedure TForm1.CreateCustomNavigator;
var
  Navigator: TFMXStyledDbNavigator;
begin
  Navigator := TFMXStyledDbNavigator.Create(Self);
  Navigator.Parent := Self;
  Navigator.DataSource := DataSource1;

  // Show only specific buttons
  Navigator.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbRefresh];

  // Disable delete confirmation
  Navigator.ConfirmDelete := False;
end;
```

---

## Style Families

### Using Different Style Families

```pascal
uses
  FMX.ButtonStyles;

// Material Design
procedure TForm1.CreateMaterialButtons;
var
  Btn: TFMXStyledButton;
begin
  Btn := TFMXStyledButton.Create(Self);
  Btn.Parent := Self;
  Btn.Text := 'Material Primary';
  Btn.StyleFamily := 'Material';
  Btn.StyleClass := 'Primary';
  Btn.StyleAppearance := 'Normal';
end;

// Cupertino (iOS/macOS)
procedure TForm1.CreateCupertinoButtons;
var
  Btn: TFMXStyledButton;
begin
  Btn := TFMXStyledButton.Create(Self);
  Btn.Parent := Self;
  Btn.Text := 'iOS Button';
  Btn.StyleFamily := 'Cupertino';
  Btn.StyleClass := 'Primary';
  Btn.StyleAppearance := 'Normal';
  Btn.StyleDrawType := btRounded;  // iOS uses rounded corners
end;

// Bootstrap
procedure TForm1.CreateBootstrapButtons;
var
  BtnPrimary, BtnSuccess, BtnDanger: TFMXStyledButton;
begin
  BtnPrimary := TFMXStyledButton.Create(Self);
  BtnPrimary.Parent := Self;
  BtnPrimary.Text := 'Primary';
  BtnPrimary.StyleFamily := 'Bootstrap';
  BtnPrimary.StyleClass := 'Primary';
  BtnPrimary.Position.Y := 20;

  BtnSuccess := TFMXStyledButton.Create(Self);
  BtnSuccess.Parent := Self;
  BtnSuccess.Text := 'Success';
  BtnSuccess.StyleFamily := 'Bootstrap';
  BtnSuccess.StyleClass := 'Success';
  BtnSuccess.Position.Y := 70;

  BtnDanger := TFMXStyledButton.Create(Self);
  BtnDanger.Parent := Self;
  BtnDanger.Text := 'Danger';
  BtnDanger.StyleFamily := 'Bootstrap';
  BtnDanger.StyleClass := 'Danger';
  BtnDanger.Position.Y := 120;
end;

// Fluent Design (Windows 11)
procedure TForm1.CreateFluentButtons;
var
  Btn: TFMXStyledButton;
begin
  Btn := TFMXStyledButton.Create(Self);
  Btn.Parent := Self;
  Btn.Text := 'Fluent Button';
  Btn.StyleFamily := 'Fluent';
  Btn.StyleClass := 'Primary';
  Btn.StyleDrawType := btRoundRect;  // Fluent uses subtle rounded corners
end;
```

### Style Appearances

```pascal
// Normal (filled)
BtnNormal := TFMXStyledButton.Create(Self);
BtnNormal.StyleAppearance := 'Normal';
BtnNormal.Text := 'Filled';

// Outlined
BtnOutlined := TFMXStyledButton.Create(Self);
BtnOutlined.StyleAppearance := 'Outlined';
BtnOutlined.Text := 'Outlined';

// Text only
BtnText := TFMXStyledButton.Create(Self);
BtnText.StyleAppearance := 'Text';
BtnText.Text := 'Text Only';
```

---

## Platform-Specific Features

### iOS/Android Optimizations

```pascal
procedure TForm1.CreateMobileButton;
var
  Btn: TFMXStyledButton;
begin
  Btn := TFMXStyledButton.Create(Self);
  Btn.Parent := Self;

  {$IFDEF IOS}
  Btn.StyleFamily := 'Cupertino';
  Btn.StyleDrawType := btRounded;
  Btn.Height := 44;  // iOS Human Interface Guidelines
  {$ENDIF}

  {$IFDEF ANDROID}
  Btn.StyleFamily := 'Material';
  Btn.EnableRipple := True;
  Btn.Height := 48;  // Material Design Guidelines
  {$ENDIF}

  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  Btn.TouchTargetExpansion.Rect := RectF(10, 10, 10, 10);  // Larger touch area
  {$ENDIF}
end;
```

### Platform-Specific Dark Mode

```pascal
procedure TForm1.SetupDarkMode;
begin
  {$IFDEF MSWINDOWS}
  // Windows: Reads from Registry
  Button1.ThemeMode := tmAuto;
  {$ENDIF}

  {$IFDEF MACOS}
  // macOS: Uses NSUserDefaults
  Button1.ThemeMode := tmAuto;
  {$ENDIF}

  {$IFDEF ANDROID}
  // Android: Manual theme switching recommended
  Button1.ThemeMode := tmLight;  // or tmDark based on app settings
  {$ENDIF}

  {$IFDEF IOS}
  // iOS: Manual theme switching recommended
  Button1.ThemeMode := tmLight;  // or tmDark based on app settings
  {$ENDIF}
end;
```

### Responsive Layouts

```pascal
procedure TForm1.CreateResponsiveToolbar;
var
  Toolbar: TFMXStyledToolbar;
begin
  Toolbar := TFMXStyledToolbar.Create(Self);
  Toolbar.Parent := Self;
  Toolbar.Align := TAlignLayout.Top;

  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  // Mobile: Larger buttons, horizontal scrolling
  Toolbar.ButtonWidth := 60;
  Toolbar.ButtonHeight := 60;
  Toolbar.ShowCaptions := False;  // Icons only on mobile
  {$ELSE}
  // Desktop: Smaller buttons, show captions
  Toolbar.ButtonWidth := 80;
  Toolbar.ButtonHeight := 40;
  Toolbar.ShowCaptions := True;
  {$ENDIF}
end;
```

---

## Complete Example Application

```pascal
unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StyledButton, FMX.StyledToolbar, FMX.StyledTaskDialog,
  FMX.StyledButtonGroup, FMX.Layouts;

type
  TFormMain = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FToolbar: TFMXStyledToolbar;
    FButtonGroup: TFMXStyledButtonGroup;
    procedure SetupUI;
    procedure ToolbarButtonClick(Sender: TObject; Button: TFMXStyledToolButton);
    procedure ButtonGroupClick(Sender: TObject; Index: Integer);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  SetupUI;
end;

procedure TFormMain.SetupUI;
var
  Btn: TFMXStyledToolButton;
begin
  // Create toolbar
  FToolbar := TFMXStyledToolbar.Create(Self);
  FToolbar.Parent := Self;
  FToolbar.Align := TAlignLayout.Top;
  FToolbar.Height := 50;
  FToolbar.StyleFamily := 'Material';
  FToolbar.OnButtonClick := ToolbarButtonClick;

  // Add toolbar buttons
  Btn := FToolbar.AddButton;
  Btn.Text := 'New';
  Btn.Tag := 1;

  Btn := FToolbar.AddButton;
  Btn.Text := 'Open';
  Btn.Tag := 2;

  Btn := FToolbar.AddButton;
  Btn.Text := 'Save';
  Btn.Tag := 3;

  // Create button group
  FButtonGroup := TFMXStyledButtonGroup.Create(Self);
  FButtonGroup.Parent := Self;
  FButtonGroup.Align := TAlignLayout.Left;
  FButtonGroup.Width := 150;
  FButtonGroup.OnButtonClick := ButtonGroupClick;

  FButtonGroup.Items.Add.Caption := 'Dashboard';
  FButtonGroup.Items.Add.Caption := 'Projects';
  FButtonGroup.Items.Add.Caption := 'Settings';
  FButtonGroup.ItemIndex := 0;
end;

procedure TFormMain.ToolbarButtonClick(Sender: TObject; Button: TFMXStyledToolButton);
begin
  case Button.Tag of
    1: StyledShowMessage('New', 'Create new document', TMsgDlgType.mtInformation);
    2: StyledShowMessage('Open', 'Open existing document', TMsgDlgType.mtInformation);
    3: StyledShowMessage('Save', 'Save document', TMsgDlgType.mtInformation);
  end;
end;

procedure TFormMain.ButtonGroupClick(Sender: TObject; Index: Integer);
begin
  // Switch view based on selection
  case Index of
    0: ShowDashboard;
    1: ShowProjects;
    2: ShowSettings;
  end;
end;

end.
```

---

## Tips and Best Practices

1. **Performance**: Use `BeginUpdate`/`EndUpdate` when adding multiple items to button groups or toolbars
2. **Mobile**: Enable ripple effects on Android for better UX
3. **Accessibility**: Always set Hint properties for buttons without text
4. **Dark Mode**: Use `tmAuto` on Windows/macOS for automatic theme switching
5. **Responsive**: Adjust button sizes and layouts based on platform
6. **Consistency**: Use the same StyleFamily throughout your application
7. **Touch Targets**: On mobile, ensure buttons are at least 44x44 pixels

---

## Additional Resources

- **FMX Port Guide**: See `FMX_PORT_GUIDE.md` for detailed component documentation
- **Installation**: See `packages_fmx/README_FMX_PACKAGES.md` for package installation
- **VCL Version**: See main `README.md` for VCL component documentation
- **GitHub**: https://github.com/EtheaDev/StyledComponents
