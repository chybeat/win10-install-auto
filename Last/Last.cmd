@echo off
color 02
CLS
ECHO.
ECHO =================================
ECHO CONFIGURACIàN FINAL DE WINDOWS 10
ECHO =================================
:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%USERPROFILE%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion
icacls %temp% /grant Everyone:(OI)(CI)F /T > nul

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO ***************************************
ECHO Solicitando ejecutar como administrador
ECHO ***************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::Inicio
::::::::::::::::::::::::::::
REM Permitir ejecucion de los scripts de powershell de modo interno

echo Habilitando la ejecuci¢n del script requerido...
echo.
PowerShell.exe Set-ExecutionPolicy -Scope CurrentUser Unrestricted -force
powershell.exe Set-ExecutionPolicy -Scope LocalMachine Unrestricted -force

echo Ejecutando el archivo requerido....
echo.
echo.
echo.
echo             NO CIERRES ESTA VENTANA
echo.
echo.
echo.
start /wait powershell.exe "& '.\run_last.ps1' "

echo "Apartir de aqui se deshabilita la ejecucion de scripts en powershell"
timeout /t 2 /nobreak
REM Eliminando la ejecuci¢n de archivos ps1 de modo interno
powershell.exe Set-ExecutionPolicy -Scope LocalMachine Undefined -force
PowerShell.exe Set-ExecutionPolicy -Scope CurrentUser Undefined -force
