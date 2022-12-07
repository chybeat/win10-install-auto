@echo off
color 02
CLS
ECHO.
ECHO =========================
ECHO INSTALACIàN DE WINDOWS 10
ECHO =========================
:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion
icacls %temp% /grant Everyone:(OI)(CI)F /T >nul

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

echo Habilitando la ejecucion del script requerido.
echo.
echo No cierre esta ventana hasta que termine...
echo.
PowerShell.exe Set-ExecutionPolicy -Scope CurrentUser Unrestricted -force
powershell.exe Set-ExecutionPolicy -Scope LocalMachine Unrestricted -force

REM Ejecutando el archivo ps1 que realiza el llamado de todas las funciones
start /wait powershell.exe "& '.\get-vscode.ps1' "
REM Eliminando la ejecucion de archivos ps1 de modo interno
echo.
echo Terminando, porfavor espere un momento...
echo.
