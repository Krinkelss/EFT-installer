:: Ниже небольшой костыль, который запускает наш bat файл от имени администратора
:: За предоставленный код запуска от имени администратора спасибо Skymmer
:: v 1.3.0

@Echo Off
:: Для начала проверим, а не работаем ли мы от имени администратора?
FSUTIL dirty query %SystemDrive% >nul
if %errorlevel% EQU 0 goto START

:: Ну а теперь сам скрипт для запуска от имени администратора
ver |>NUL find /v "5." && if "%~1"=="" (
  Echo CreateObject^("Shell.Application"^).ShellExecute WScript.Arguments^(0^),"1","","runas",1 >"%temp%\Elevating.vbs"
  cscript.exe //nologo "%temp%\Elevating.vbs" "%~f0"& goto :eof
)
:START
cls
cd /d %~dp0

:: Нужно внести изменения в реестр
echo Добавляем запись в реестр
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\EscapeFromTarkov" /f /v "InstallLocation" /t REG_SZ /d "%~dp0Install_EFT"

echo Запись в реестр добавлена, создаём файлы
mkdir "%~dp0Install_EFT"  2>nul
mkdir "%~dp0Install_EFT\BattlEye"  2>nul
mkdir "%~dp0Install_EFT\Logs"  2>nul

type nul > "%~dp0Install_EFT\BattlEye\BEClient_x64.dll"
type nul > "%~dp0Install_EFT\BattlEye\BEService_x64.exe"
type nul > "%~dp0Install_EFT\ConsistencyInfo"
type nul > "%~dp0Install_EFT\EscapeFromTarkov_BE.exe"
type nul > "%~dp0Install_EFT\UnityPlayer.dll"
type nul > "%~dp0Install_EFT\UnityCrashHandler64.exe"
type nul > "%~dp0Install_EFT\WinPixEventRuntime.dll"

echo Файлы созданы, можно пробовать играть

del /f /q "%temp%\Elevating.vbs"

pause