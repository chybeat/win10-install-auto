Clear-Host

#importación de funciones y variables principales
Import-Module -DisableNameChecking "$PSScriptroot\lib\pcb-win10_install_main_module.psm1" -Global -Force

#Administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Host "Elevando privilegios..."
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	exit
}
do {} until (Get-ElevatedPrivileges SeTakeOwnershipPrivilege)


<#============================
= INICIO DE CODIGO DE PRUEBA =
============================#>

#$app = Get-dbAppData("winamp")
#install-App($app)

$script = $PSScriptRoot + "\web\sqlite2mariaDB.ps1"
. $script
exit


#Recuperando el last mas reciente
$script = $PSScriptRoot + "\winhacks\CopyLast.ps1"
. $script
exit


#Recuperando el last mas reciente
$script = $PSScriptRoot + "\winhacks\CopyLast.ps1"
. $script
exit

#ejecutando last
$script = $env:SystemDrive + "\last\last.cmd"
. $script
exit

<#=========================
=========================#>
Unregister-Libraries($requiredLibraries)
