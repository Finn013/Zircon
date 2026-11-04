Unicode true
SetCompressor zlib
Name "Zircon"
OutFile "Zircon-Portable.exe"
Icon "icon.ico"
RequestExecutionLevel user
SilentInstall silent
AutoCloseWindow true
VIProductVersion "1.0.0.0"
VIAddVersionKey "ProductName" "Zircon Portable"
VIAddVersionKey "FileDescription" "Zircon Portable"
VIAddVersionKey "CompanyName" "Finn013"
VIAddVersionKey "FileVersion" "1.0.0"
VIAddVersionKey "ProductVersion" "1.0.0"
VIAddVersionKey "LegalCopyright" "Finn013"
Section
  StrCpy $0 "$TEMP\ZirconPortable-1.0.0"
  IfFileExists "$0\Zircon.exe" run
  SetOutPath "$0"
  File /r "/workspace/projects/7a91fa13-8e48-457f-a4e4-a91de8b0fd36/work/zircon/wbuild/unpacked/*"
  run:
  System::Call 'Kernel32::SetEnvironmentVariable(t "PORTABLE_EXECUTABLE_DIR", t "$EXEDIR")i'
  SetOutPath "$EXEDIR"
  ExecWait '"$0\Zircon.exe"'
SectionEnd
