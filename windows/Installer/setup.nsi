Unicode true
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"
!include "WinVer.nsh"
!ifndef APP_VERSION
  !error "APP_VERSION must be provided by build-windows.ps1"
!endif
!ifndef PAYLOAD
  !error "PAYLOAD must point to the published Windows application"
!endif
!ifndef OUTPUT
  !error "OUTPUT must point to the Setup.exe output"
!endif
Name "Виды Школы Империи"
OutFile "${OUTPUT}"
InstallDir "$LOCALAPPDATA\Programs\Imperial School Views"
InstallDirRegKey HKCU "Software\ImperialSchool\ViewsWindows" "InstallDir"
RequestExecutionLevel user
SetCompressor /SOLID lzma
SetCompressorDictSize 8
ShowInstDetails show
ShowUninstDetails show
VIProductVersion "${APP_VERSION}.${APP_BUILD}"
VIAddVersionKey /LANG=1049 "ProductName" "Виды Школы Империи"
VIAddVersionKey /LANG=1049 "CompanyName" "Школа Империи"
VIAddVersionKey /LANG=1049 "FileDescription" "Установка приложения Виды Школы Империи"
VIAddVersionKey /LANG=1049 "FileVersion" "${APP_VERSION}.${APP_BUILD}"
VIAddVersionKey /LANG=1049 "ProductVersion" "${APP_VERSION}"
VIAddVersionKey /LANG=1049 "LegalCopyright" "Школа Империи"
!define MUI_ICON "../Desktop/Assets/app.ico"
!define MUI_UNICON "../Desktop/Assets/app.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "welcome.bmp"
!define MUI_BGCOLOR "FBF8EC"
!define MUI_TEXTCOLOR "272635"
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE "Виды Школы Империи"
!define MUI_WELCOMEPAGE_TEXT "Пейзажи из мира Школы Империи. Места, к которым хочется возвращаться.$\r$\n$\r$\nОбои дня, погодные обои, коллекции с сайта и собственные ZIP-пакеты.$\r$\n$\r$\nПриложение будет установлено для текущего пользователя."
!define MUI_FINISHPAGE_RUN "$INSTDIR\ImperialSchoolViews.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Открыть Виды Школы Империи"
!define MUI_FINISHPAGE_LINK "Аркадный зал Школы Империи"
!define MUI_FINISHPAGE_LINK_LOCATION "https://games.oopssre.ru/gremlin.html#views"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
!insertmacro MUI_LANGUAGE "Russian"

Function .onInit
  ${IfNot} ${RunningX64}
    MessageBox MB_ICONSTOP "Эта версия предназначена для 64-разрядной Windows."
    Abort
  ${EndIf}
  ${IfNot} ${AtLeastWin10}
    MessageBox MB_ICONSTOP "Для приложения требуется Windows 10 или новее."
    Abort
  ${EndIf}
  ${IfNot} ${AtLeastBuild} 14393
    MessageBox MB_ICONSTOP "Требуется Windows 10 версии 1607 или новее."
    Abort
  ${EndIf}
  System::Call 'kernel32::CreateMutexW(p 0, i 0, w "Local\ImperialSchoolViews.Windows.Setup") p .r0 ?e'
  Pop $1
  ${If} $1 == 183
    MessageBox MB_ICONEXCLAMATION "Другой установщик уже запущен."
    Abort
  ${EndIf}
FunctionEnd

!macro CloseRunningApp prefix
Function ${prefix}CloseRunningApp
  ReadRegStr $3 HKCU "Software\ImperialSchool\ViewsWindows" "InstallDir"
  ${If} $3 == ""
    StrCpy $3 "$INSTDIR"
  ${EndIf}
  IfFileExists "$3\ImperialSchoolViews.exe" 0 no_exec
  ExecWait '"$3\ImperialSchoolViews.exe" --quit'
no_exec:
  StrCpy $2 0
retry:
  System::Call 'kernel32::OpenMutexW(i 0x00100000, i 0, w "Local\ImperialSchoolViews.Windows") p .r0'
  ${If} $0 != 0
    System::Call 'kernel32::CloseHandle(p r0)'
    IntOp $2 $2 + 1
    ${If} $2 > 50
      MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "Завершите работу приложения через значок в трее и повторите." IDRETRY retry IDCANCEL cancel
    ${EndIf}
    Sleep 200
    Goto retry
  ${EndIf}
  Goto done
cancel:
  Abort
done:
FunctionEnd
!macroend
!insertmacro CloseRunningApp ""
!insertmacro CloseRunningApp "un."

Section "Виды Школы Империи"
  SetShellVarContext current
  Call CloseRunningApp
  SetOutPath "$INSTDIR"
  File /r "${PAYLOAD}/*"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  CreateDirectory "$SMPROGRAMS\Школа Империи"
  CreateShortcut "$SMPROGRAMS\Школа Империи\Виды и обои.lnk" "$INSTDIR\ImperialSchoolViews.exe" "" "$INSTDIR\ImperialSchoolViews.exe" 0
  WriteRegStr HKCU "Software\ImperialSchool\ViewsWindows" "InstallDir" "$INSTDIR"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "DisplayName" "Виды Школы Империи"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "Publisher" "Школа Империи"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "URLInfoAbout" "https://games.oopssre.ru/gremlin.html#views"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "DisplayIcon" "$INSTDIR\ImperialSchoolViews.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "UninstallString" '$\"$INSTDIR\Uninstall.exe$\"'
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "QuietUninstallString" '$\"$INSTDIR\Uninstall.exe$\" /S'
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "NoModify" 1
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews" "NoRepair" 1
SectionEnd

Section "Uninstall"
  SetShellVarContext current
  Call un.CloseRunningApp
  ReadRegStr $0 HKCU "Control Panel\Desktop" "SCRNSAVE.EXE"
  StrCmp $0 "$INSTDIR\ImperialSchoolViews.scr" 0 +2
  DeleteRegValue HKCU "Control Panel\Desktop" "SCRNSAVE.EXE"
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "ImperialSchoolViews"
  DeleteRegKey HKCU "Software\ImperialSchool\ViewsWindows"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ImperialSchoolViews"
  Delete "$SMPROGRAMS\Школа Империи\Виды и обои.lnk"
  RMDir "$SMPROGRAMS\Школа Империи"
  !include "${UNINSTALL_FILES}"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"
  IfSilent keep_data
  MessageBox MB_YESNO|MB_DEFBUTTON2 "Удалить также настройки и сохранённые коллекции обоев?" IDNO keep_data
  RMDir /r "$LOCALAPPDATA\Imperial School\Views"
keep_data:
SectionEnd
