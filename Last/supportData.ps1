if ($x86) {
	$pfPath = ${env:ProgramFiles}
} else {
	$pfPath = ${env:ProgramFiles(x86)}
}

$dest = ($pfPath + '\3Planesoft 3D Screensavers All in One\Flag 3D Screensaver\colombia.jpg')

#Copiando Bandera
if (Test-Path -Path $dest -PathType Leaf) {
	Remove-Item -Path $dest -Force
}
Copy-Item -Path ($PSScriptRoot + "\bin\flagco_pict.bin") -Destination $dest -Force

#agregando datos de sobre soporte al registro
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\3Planesoft\Flag 3D Screensaver]
    "FlagNum"="2: 0"
    "FlagPath"="3: ' + $dest + '

    [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation]
    "Manufacturer"="CAMILO SALAZAR"
    "SupportHours"="24 Horas"
    "SupportURL"="https://www.pcbogota.com"
    "SupportPhone"="Cel: 313 347 34 40"
    "Model"="Diciembre 2022"
    "Owner"="Usuario"
    "Organization"="PC Bogota"
    "Logo"="'+ $env:Windir + '\oemlogo.bmp"
')

#copiando logo OEM
$dest = $env:Windir + "\oemlogo.bmp"
if (Test-Path -Path $dest -PathType Leaf) {
	Remove-Item -Path $dest -Force
}
Copy-Item -Path ($PSScriptRoot + "\bin\oem_bitmap.bin") -Destination $dest -Force

#Copiando icono
$dest = $env:Windir + "\oemicon.ico"
if (Test-Path -Path $dest -PathType Leaf) {
	Remove-Item -Path $dest -Force
}
Copy-Item -Path ($PSScriptRoot + "\bin\oem_icon.bin") -Destination $dest -Force

#Creando icono de soporte
New-Link -Dest ([Environment]::GetFolderPath("CommonDesktopDirectory")) -Name "Soporte Técnico" -Source ("%windir%\system32\control.exe") -Arguments "system" -Icon ($env:windir + "\oemicon.ico") -Admin
New-Link -Dest ([Environment]::GetFolderPath("CommonStartMenu")) -Name "Soporte Técnico" -Source ("%windir%\system32\control.exe") -Arguments "system" -Icon ($env:windir + "\oemicon.ico") -Admin
