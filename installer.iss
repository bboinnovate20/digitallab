[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName=AlbarikaDigital
AppVersion=1.0
DefaultDirName={autopf}\AlbarikaDigital
DefaultGroupName=AlbarikaDigital
OutputDir=.
OutputBaseFilename=AlbarikaDigital
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"

[Files]
; Include all files from the Release folder
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Create Start Menu shortcut
Name: "{group}\My Flutter App"; Filename: "{app}\your_app.exe"
; Create Desktop shortcut (if user selected it)
Name: "{autodesktop}\My Flutter App"; Filename: "{app}\your_app.exe"; Tasks: desktopicon

[Run]
; Optionally launch the app after installation
Filename: "{app}\your_app.exe"; Description: "Launch My Flutter App"; Flags: nowait postinstall skipifsilent