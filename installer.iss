; ============================================================
;  Universal POS System — Inno Setup Script
;  Flutter Desktop (Windows x64)
;  Generated for: universal_pos_system_v1 v1.0.0
; ============================================================

#define AppName      "Universal POS System"
#define AppVersion   "1.0.0"
#define AppPublisher "Universal POS"
#define AppExeName   "universal_pos_system_v1.exe"
#define AppId        "{{A3F2C1D4-8B5E-4F7A-9C2D-1E6B0A3F4D8C}"
#define BuildDir     "build\windows\x64\runner\Release"
#define AppURL       "https://universalpos.uz"

[Setup]
; ----- Identity -----
AppId={#AppId}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} v{#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}

; ----- Install paths -----
; Default install dir: C:\Program Files\Universal POS System
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
; Allow changing install dir
DisableDirPage=no
DisableProgramGroupPage=yes

; ----- Output -----
OutputDir=installer_output
OutputBaseFilename=UniversalPOS_Setup_v{#AppVersion}
SetupIconFile=windows\runner\resources\app_icon.ico

; ----- Compression -----
Compression=lzma2/ultra64
SolidCompression=yes
LZMAUseSeparateProcess=yes

; ----- UI & appearance -----
WizardStyle=modern
WizardResizable=yes
; Show license if you have one (optional — comment out if not needed)
; LicenseFile=LICENSE

; ----- Architecture -----
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

; ----- Privileges -----
; Use "lowest" to install per-user without admin rights
; Use "admin" to install for all users (writes to Program Files)
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog

; ----- Uninstall -----
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\{#AppExeName}
CreateUninstallRegKey=yes

; ----- Misc -----
; Prevent running multiple instances of the installer
AppMutex=Global\UniversalPOSInstaller

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
; Optional: desktop shortcut (checked by default)
Name: "desktopicon";    Description: "Create a &desktop shortcut";        GroupDescription: "Additional Icons:"; Flags: checkedonce
; Optional: startup shortcut (unchecked by default)
Name: "startupicon";   Description: "Launch automatically at &Windows startup"; GroupDescription: "Additional Icons:"; Flags: unchecked

[Files]
; ---- Main executable ----
Source: "{#BuildDir}\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; ---- Flutter engine & Dart runtime DLLs ----
Source: "{#BuildDir}\flutter_windows.dll";       DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\*.dll";                     DestDir: "{app}"; Flags: ignoreversion recursesubdirs

; ---- App data folder (assets, fonts, shaders, etc.) ----
Source: "{#BuildDir}\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

; ---- Visual C++ runtime (redistribute if you bundle it) ----
; Uncomment the lines below if you ship vcredist alongside the installer:
Source: "redist\vcredist_x64.exe"; DestDir: "{tmp}";

[Icons]
; Start Menu
Name: "{group}\{#AppName}";              Filename: "{app}\{#AppExeName}"
Name: "{group}\Uninstall {#AppName}";    Filename: "{uninstallexe}"

; Desktop shortcut (only if task is selected)
Name: "{autodesktop}\{#AppName}";        Filename: "{app}\{#AppExeName}"; Tasks: desktopicon

; Windows Startup folder (only if task is selected)
Name: "{autostartup}\{#AppName}";        Filename: "{app}\{#AppExeName}"; Tasks: startupicon

[Run]
; Launch app after installation finishes (optional checkbox)
Filename: "{app}\{#AppExeName}"; \
  Description: "Launch {#AppName} now"; \
  Flags: nowait postinstall skipifsilent

; ---- Uncomment to run VC++ redist silently before main install ----
; Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/quiet /norestart"; \
;   StatusMsg: "Installing Visual C++ Runtime..."; \
;   Flags: waituntilterminated runascurrentuser; \
;   Check: VCRedistNeedsInstall

[UninstallRun]
; Kill the process if it is running when uninstalling
Filename: "taskkill.exe"; Parameters: "/F /IM {#AppExeName}"; Flags: runhidden; RunOnceId: "KillApp"

[UninstallDelete]
; Remove the user-data folder created by the app at runtime
; The app stores its SQLite DB in %APPDATA%\upossystem — remove on uninstall
Type: filesandordirs; Name: "{userappdata}\upossystem"

[Registry]
; Register the app so Windows "Add/Remove Programs" shows publisher info
Root: HKLM; Subkey: "Software\{#AppPublisher}\{#AppName}"; \
  ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; \
  Flags: uninsdeletekey

[Code]
// ---------------------------------------------------------------
//  Helper: Check whether VC++ 2019 x64 Redist is already present
// ---------------------------------------------------------------
function VCRedistNeedsInstall: Boolean;
var
  installed: Cardinal;
begin
  // VC++ 2015-2022 x64 redist sets this registry value when installed
  Result := not RegQueryDWordValue(
    HKLM,
    'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\X64',
    'Installed',
    installed
  ) or (installed = 0);
end;

// ---------------------------------------------------------------
//  Prevent downgrade: block install if a newer version is present
// ---------------------------------------------------------------
function InitializeSetup: Boolean;
var
  existingVersion: String;
begin
  Result := True;
  if RegQueryStringValue(
    HKLM,
    'Software\{#AppPublisher}\{#AppName}',
    'Version',
    existingVersion
  ) then begin
    if CompareStr(existingVersion, '{#AppVersion}') > 0 then begin
      MsgBox(
        'A newer version (' + existingVersion + ') of {#AppName} is already installed.' #13#10 +
        'Installation will be cancelled.',
        mbInformation,
        MB_OK
      );
      Result := False;
    end;
  end;
end;

// ---------------------------------------------------------------
//  Kill running instance before upgrading/reinstalling
// ---------------------------------------------------------------
function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Result := '';
  Exec('taskkill.exe', '/F /IM {#AppExeName}', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Sleep(800); // short pause to let the process fully exit
end;
