Clear-Host

#cerrrar ventana de sysprep
if (Get-Process -Name "sysprep" -ErrorAction SilentlyContinue) {
	Get-Process -Name "sysprep" | Stop-Process
}

#Carga de funciones principales requeridas para le ejecución de todos los scripts
Get-Module -Name "pcb-Win10_install_main_module" | Remove-Module
Import-Module -DisableNameChecking "$PSScriptroot\lib\pcb-win10_install_main_module.psm1" -Global -Force

####################
# área de permisos #
####################

#Verificación de ejecución con privilegios elevados
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Host "Elevando privilegios..."
	Write-Host $PSCommandPath
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	exit
}
do {} until (Get-ElevatedPrivileges SeTakeOwnershipPrivilege)

#obtener estado de ejecución, depende de la variable lo que se ejecuta
$global:state = Get-InstallationState

#Solicitud para modo de instalación del sistema operativo
$global:freeSoft = Get-InstallOption("¿Instalar solo software libre?")
$global:pauses10me = Get-InstallOption("¿Parar luego de terminar soft10me?")
if (-not ($global:pauses10me)) {
	$global:InstallMSO = Get-InstallOption("¿Instalar Microsoft Office?")
	$global:InstallGS = Get-InstallOption("¿Instalar suites de diseño gráfico?")
}

if (!$state) {

	<#	Metodo de instalación de Windows
		1. Configuración general de Windows (Temporales, Nombre de usuario, Registros varios, Redistribuibles de C++, NetFrameWork, y Ajustes Generales)
		2. Instalación de fondos de pantalla
		3. Configuraxiones adicionales de apariencia y metodos de panel de control
	#>
	Set-PCBReg -Name "00-StartInstallationDate" -Value (Get-CurrentDate)
	$script = $PSScriptRoot + "\WinHacks\regHacks.ps1"; #1
	. $script

	$script = $PSScriptRoot + "\Soft10me\Wallpapers.ps1"; #2
	. $script

	$script = $PSScriptRoot + "\WinHacks\regHacks_WinConfig.ps1"; #3
	. $script
	Restart-AndContinue -checkpoint "WinHacked" -run ($PSScriptRoot + "\-- iniciar.cmd")
}

if ($state -eq "WinHacked") {
	<#	Metodo de instalación de Windows
	4. NetFramework
	5. GPEdit
	6. C++ Redistributable Packages
	7. webView
 	#>
	$script = $PSScriptRoot + "\WinHacks\dotNetRuntimes.ps1"; #4
	. $script

	$script = $PSScriptRoot + "\WinHacks\gpedit.ps1"; #5
	. $script

	$script = $PSScriptRoot + "\WinHacks\c++_redist.ps1"; #6
	. $script

	install-app(get-dbAppData("Microsoft Edge Webview")) #7

	Restart-AndContinue -checkpoint "SOUtilsDone" -run ($PSScriptRoot + "\-- iniciar.cmd")
}

if ($state -eq "SOUtilsDone") {
	<#
		9. Instalación de software
			A. Software en general (Sin suites o el llamado 10Me)
	#>
	$script = $PSScriptRoot + "\soft10me.ps1" #9.A
	. $script
	if ($pauses10me) {
		wTitulo("INICIARÁ SUITE OFIMATICA EN EL PROXIMO REINICIO. PUEDES REALIZAR IMAGEN!")
		wError("INICIARÁ SUITE OFIMATICA EN EL PROXIMO REINICIO. PUEDES REALIZAR IMAGEN!")
		Pause
		Pause
	}
	Restart-AndContinue -checkpoint "10meDone" -run ($PSScriptRoot + "\-- iniciar.cmd")
}

if ($global:pauses10me) {
	$global:InstallMSO = Get-InstallOption("¿Instalar Microsoft Office?")
	$global:InstallGS = Get-InstallOption("¿Instalar suites de diseño gráfico?")
}

if ($state -eq "10meDone" -and $InstallMSO) {

	<#
		9. Instalación de software
			B. SUITES
				1. Solo Office + Sumatra
	#>
	$script = $PSScriptRoot + "\softOfficeme.ps1" #9.B.1
	. $script
	Restart-AndContinue -checkpoint "OfficemeDone" -run ($PSScriptRoot + "\-- iniciar.cmd")
} elseif ($state -eq "10meDone") {
	$state = 'OfficemeDone'
	Set-InstallationState -Value $state
}

if ($state -eq "OfficemeDone" -and $InstallGS) {
	<#
		9. Instalación de software
			B. SUITES
				2. Diseño/PDF (Todo)
	#>
	$script = $PSScriptRoot + "\softDesign.ps1" #9.B.2
	. $script
	Restart-AndContinue -checkpoint "StarImageDone" -run ($PSScriptRoot + "\-- iniciar.cmd")
} elseif ($state -eq "OfficemeDone") {
	$state = "StarImageDone"
	Set-InstallationState -Value $state
}

if ($state -eq "StarImageDone") {
	<#
	10. Instalación de actualizaciones mendiante WSUS
	11. Tweaks de Configuración de Windows y Panel de Control
		Esta parte se hace ya que se deben abrir muchos programas y varias configuraciones que harán que Configuración de Windows cambie, en un par de apartados
	#>

	wInfo("Ejecutando actualizacion Fase 1") #10
	$updCommand = Get-Path("D:\Programas\Windows Update\cmd\DoUpdate.cmd") -Full
	Start-Process -FilePath ($updCommand) -ArgumentList '/updatercerts /instdotnet4 /instwmf /showdismprogress /instmsi' -Wait
	Restart-AndContinue -checkpoint "WinupP1" -run ($PSScriptRoot + "\-- iniciar.cmd")
}

if ($state -eq "WinupP1") {
	<#
	10. Instalación de actualizaciones mendiante WSUS
	#>
	$updCommand = Get-Path("D:\Programas\Windows Update\cmd\DoUpdate.cmd") -Full
	wInfo("Ejecutando actualizacion Fase 3") #10
	Start-Process -FilePath $updCommand -ArgumentList "/showdismprogress /instmsi" -Wait

	$logFile = "$env:Windir\wsusofflineupdate.log"
	if (Test-Path $logFile -PathType Leaf ) {
		Remove-Item $logFile -Force
	}
	<#
	11. Tweaks de Configuración de Windows y Panel de Control
		Esta parte se hace ya que se deben abrir muchos programas y varias configuraciones que harán que Configuración de Windows cambie, en un par de apartados
	#>

	$script = $PSScriptRoot + "\WinHacks\regHacks_WinFinish.ps1" #11
	. $script

	<#
	12. Copia de Last
	#>
	$script = $PSScriptRoot + "\WinHacks\CopyLast.ps1" #12
	. $script

	Restart-AndContinue -checkpoint "WinConfigDone" -run ($PSScriptRoot + "\-- iniciar.cmd")
}

if ($state -eq "WinConfigDone") {
	<#
	13. Limpieza final de registro y datos de script de instalación (actual)
	#>
	$script = $PSScriptRoot + "\WinHacks\WinClean.ps1" #13
	. $script
	Restart-AndContinue -checkpoint "WinCleanDone" -run ($PSScriptRoot + "\-- iniciar.cmd")
}

if ($state -eq "WinCleanDone") {
	$run = "D:\Programas\SO\Windows 10\sysprep W10\sysprepme_22H2.cmd"

	if (Get-UserAnswer("Ejecutar Sysprep?")) {
		wRun("Ejecutando sysprep!")
		Start-Process -FilePath $run -Wait
	} else {
		New-Link -Dest "$env:PUBLIC\desktop" -name "sysprepme_22H2.cmd" -Source $run -WorkingDirectory "$env:PUBLIC\desktop" -Admin
	}

	#optimizing installation data
	Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\PCBogota]
	"InstalarMicrosoftOffice"=-
	"Instalarsolosoftwarelibre"=-
	"Instalarsuitesdediseogrfico"=-
	"Pararluegodeterminarsoft10me"=-
	"InstallState"=-
	"01-EndInstallationDate"="' + (Get-CurrentDate) + '"
	')
}
#archivos basura en d:\
@('eula.1028.txt',
	'eula.1031.txt',
	'eula.1033.txt',
	'eula.1036.txt',
	'eula.1040.txt',
	'eula.1041.txt',
	'eula.1042.txt',
	'eula.2052.txt',
	'eula.3082.txt',
	'globdata.ini',
	'install.exe',
	'install.ini',
	'install.res.1028.dll',
	'install.res.1031.dll',
	'install.res.1033.dll',
	'install.res.1036.dll',
	'install.res.1040.dll',
	'install.res.1041.dll',
	'install.res.1042.dll',
	'install.res.2052.dll',
	'install.res.3082.dll',
	'vcredist.bmp',
	'VC_RED.cab',
	'VC_RED.MSI',
	'setup.log' #Instalador de Enfocus
) | ForEach-Object {
	$path = "D:\" + $_
	Get-Item -Path $path -ErrorAction SilentlyContinue | Remove-Item -Force
}

wRun("Quitando los módulos utilizados en script")
Get-Module -Name "pcb-Win10_install_main_module" | Remove-Module
Write-Host ("Modulos liberados")
