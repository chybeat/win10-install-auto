<#========
= gpedit =
==========
Solo necesario para versiones home
Posibles ediciones:

Comandos para obtener el tipo de edición:
Get-WindowsEdition -online

Comando para obtener posibles ediciones
Dism /Online /Get-TargetEditions

Edition: CoreSingleLanguage             > Windows 10 Home Single Language
Edition: Core                           > Windows 10 Home
Edition: Professional                   > Windows 10 Pro
Edition: Enterprise                     > Windows 10 Enterprise

Edition: ProfessionalEducation          > Windows 10
Edition: ProfessionalWorkstation        > Windows 10
Edition: Education                      > Windows 10
Edition: ProfessionalCountrySpecific    > Windows 10
Edition: ProfessionalSingleLanguage     > Windows 10
Edition: ServerRdsh                     > Windows 10
Edition: IoTEnterprise                  > Windows 10
#>


# Version desde el registro de Windows
#$WinEd = (Get-ItemProperty -Path "registry::HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName

#Version menos "hackeada"
wTitulo("Configurando gpedit.msc")
$WinEd = (Get-WindowsEdition -Online).Edition
$mscExists = (Test-Path -Path "$env:windir\system32\gpedit.msc" -PathType Leaf)
if (($WinEd -like "*core*") -and (!$mscExists)) {
	Get-ChildItem -Path "$env:SystemRoot\servicing\Packages\*" -Include "Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum", "Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum" | ForEach-Object {
		$file = "$env:SystemRoot\servicing\Packages\" + $_.Name
		wRun("Instalando " + $_.Name)
		cmd /q /c "dism /online /norestart /add-package:$file" | Out-Null
	}
	wOk("GPEdit.msc Activado")
} else {
	wOK("GPEdit no es necesario instalar en Esta versión de Windows")
}
