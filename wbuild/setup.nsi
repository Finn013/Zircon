Unicode true
SetCompressor /SOLID lzma
!include "MUI2.nsh"
Name "Zircon"
OutFile "Zircon-Setup.exe"
InstallDir "$LOCALAPPDATA\Programs\Zircon"
InstallDirRegKey HKCU "Software\Zircon" "InstallDir"
RequestExecutionLevel user
VIProductVersion "1.0.0.0"
VIAddVersionKey "ProductName" "Zircon"
VIAddVersionKey "FileDescription" "Zircon Setup"
VIAddVersionKey "CompanyName" "Finn013"
VIAddVersionKey "FileVersion" "1.0.0"
VIAddVersionKey "ProductVersion" "1.0.0"
VIAddVersionKey "LegalCopyright" "Finn013"
!define MUI_ICON "icon.ico"
!define MUI_UNICON "icon.ico"
!define MUI_FINISHPAGE_RUN "$INSTDIR\Zircon.exe"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "English"
Section "Zircon"
  nsExec::Exec 'taskkill /IM Zircon.exe /F'
  SetOutPath "$INSTDIR"
  File /r "/workspace/projects/7a91fa13-8e48-457f-a4e4-a91de8b0fd36/work/zircon/wbuild/unpacked/*"
  WriteUninstaller "$INSTDIR\Uninstall Zircon.exe"
  CreateShortcut "$DESKTOP\Zircon.lnk" "$INSTDIR\Zircon.exe"
  CreateDirectory "$SMPROGRAMS\Zircon"
  CreateShortcut "$SMPROGRAMS\Zircon\Zircon.lnk" "$INSTDIR\Zircon.exe"
  CreateShortcut "$SMPROGRAMS\Zircon\Удалить Zircon.lnk" "$INSTDIR\Uninstall Zircon.exe"
  WriteRegStr HKCU "Software\Zircon" "InstallDir" "$INSTDIR"
  !define UK "Software\Microsoft\Windows\CurrentVersion\Uninstall\Zircon"
  WriteRegStr HKCU "${UK}" "DisplayName" "Zircon"
  WriteRegStr HKCU "${UK}" "DisplayVersion" "1.0.0"
  WriteRegStr HKCU "${UK}" "Publisher" "Finn013"
  WriteRegStr HKCU "${UK}" "DisplayIcon" "$INSTDIR\Zircon.exe"
  WriteRegStr HKCU "${UK}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${UK}" "UninstallString" '"$INSTDIR\Uninstall Zircon.exe"'
  WriteRegDWORD HKCU "${UK}" "NoModify" 1
  WriteRegDWORD HKCU "${UK}" "NoRepair" 1
SectionEnd
Section "Uninstall"
  nsExec::Exec 'taskkill /IM Zircon.exe /F'
  Delete "$DESKTOP\Zircon.lnk"
  RMDir /r "$SMPROGRAMS\Zircon"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Zircon"
  DeleteRegKey HKCU "Software\Zircon"
SectionEnd
