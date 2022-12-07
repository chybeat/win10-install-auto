wRun("Eliminando enlaces en escritorio")

@(
	"${env:Public}\Desktop",
	"${env:USERPROFILE}\Desktop"
) | ForEach-Object {
	Get-ChildItem -Path $_ -Filter "*.lnk" | Remove-Item -Force
}

<#
Organizar los accesos directos del Menú Inicio. Pasarlos todos a "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
#>

$script = $PSScriptRoot + "\orderStartMenu.ps1" #12
. $script
<#
========================
= Limpieza del sistema =
=======================#>

#Eliminación del historial de actividades
wRun("Eliminacion del historial de actividades...")
wInfo("Borrar historial de actividades (Boton borrar)
Continuara después de cerrar la ventana
")

Wait-For -Run "ms-settings:privacy-activityhistory" -ProcessName "systemSettings"

wOk("Terminado en el historial de actividades")

#Eliminar Archivos de Windows Update
wRun("Eliminacion de Archivos de Windows Update...")
dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
wOk("Archivos de Windows update eliminados")

wRun("Eliminacion de Archivos de ServicePacks anteriores")
Dism.exe /online /Cleanup-Image /SPSuperseded
wOk("Archivos de Windows update eliminados")

wTitulo("Limpieza del sistema")

wInfo("Se cerrará el proceso 'Explorador de Windows'")
taskkill /IM explorer.exe /f | Out-Null
Start-Sleep 2


<#================================================
Eliminación de impresoras no requeridas
================================================#>


wRun("Eliminacion de impresoras no necesarias")

$RemovePrinters = @(
	'OneNote',
	"OneNote (Desktop)",
	'Generic'
)

Get-Printer | ForEach-Object {
	$printer = $_.Name
	$RemovePrinters | ForEach-Object {
		if ($printer -like "*${_}*") {
			wInfo("Eliminando " + $printer)
			Remove-PrinterDriver -Name $printer -ErrorAction SilentlyContinue | Out-Null
			Remove-Printer -Name $printer -ErrorAction SilentlyContinue | Out-Null
		}
	}
}

<#================================================
Eliminación de servicios y programas no necesarios
================================================#>
#Eliminar inicio automático
wRun("Eliminando aplicaciones de inicio automatico")
set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]

"Acrobat Assistant 8.0"=-
"AdobeAAMUpdater-1.0"=-
"AdobeGCInvoker-1.0"=-
"Enfocus Subscription Notifier"=-
"SunJavaUpdateSched"=-

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"AdobeBridge"=-
"CCXProcess"=-
"OneDrive"=-
"Skype for Desktop"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run]
"Acrobat Assistant 8.0"=-
"Enfocus Subscription Notifier"=-
"Opera Browser Assistant"=-
"SunJavaUpdateSched"=-
')

wRun("Eliminando tareas programadas no necesarias")
#tareas programadas en Root
$SchudeledTasks = @(
	'Adobe Acrobat Update Task',
	'CCleaner Update',
	'klcp_update',
	'QueueReporting', #tarea de windows error reporting
	'UpdateLibrary', #tarea de windows media sharing
	'Show Registry Defrag Report on Administrador Logon',
	'UninstallSMB1ClientTask',
	'UninstallSMB1ServerTask',
	'Opera scheduled*',
	'MicrosoftEdge*',
	'OneDrive*',
	'Autorun for Administrador' #powertoys
)

foreach ($task in $SchudeledTasks) {
	Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false
}

wRun("Desactivando y limpiando servicios no necesarios")

$servicesList = @(
	'AGSService',
	'Enfocus Subscription Service',
	'Microsoft Edge Update Service (edgeupdate)',
	'Microsoft Edge Update Service (edgeupdatem)',
	'WMPNetworkSvc'
)
foreach ($service in $servicesList) {
	Get-Service -Name $service -ErrorAction SilentlyContinue | ForEach-Object {
		wInfo("`tDeteniendo ${service}...")
		$_ | Stop-Service
		wInfo("`tIntentando desactivar $service")
		$_ | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue
		wInfo("`tEliminando el servicio '" + $_.DisplayName + "'")
		$regSrvcName = "-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" + $_.name + "]"
		Set-Reg($regSrvcName)
	}
}

<#Eliminar elementos no necesarios del menu contextual para carpetas y archivos
    Lanzar UltraSearch
    Compartir con Skype
    Combine archivos con acrobat
    Defraggler
    Shred with BleachBit
#>
wRun("Eliminando elementos no necesarios del menu contextual")
<# Las lcaves del registro a revisar son:

HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\
HKEY_CLASSES_ROOT\AllFilesystemObjects\shell
HKEY_CLASSES_ROOT\Directory\shell
HKEY_CLASSES_ROOT\Drive\shell
HKEY_CLASSES_ROOT\Folder\shellex\

HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AllFilesystemObjects\shell
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Drive\shell
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shellex\
#>

set-Reg('-[HKEY_CLASSES_ROOT\Directory\shell\Bridge 12]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\Bridge 12]

-[HKEY_CLASSES_ROOT\Directory\shell\UltraSearch1]
-[HKEY_CLASSES_ROOT\Drive\shell\UltraSearch1]

-[HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\shred.bleachbit]

-[HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu]
-[HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\DefragglerShellExtension]


-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AllFilesystemObjects\shell\shred.bleachbit]

-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\DefragglerShellExtension]

-[HKEY_CURRENT_USER\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\ FileSyncEx]
-[HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\ FileSyncEx]
-[HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\Background\shellex\ContextMenuHandlers\ FileSyncEx]
')

<#
Las siguientes claves se deben eliminar de un modo forzado y se realiza desde CMD

HKEY_CLASSES_ROOT\*\shell\ShareWithSkype
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shell\ShareWithSkype

HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu
HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\DefragglerShellExtension

HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu
HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\DefragglerShellExtension
#>

wInfo("Eliminando elementos forzadamente...")
$keys = @(
	'HKEY_CLASSES_ROOT\*\shell\ShareWithSkype',
	'HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shell\ShareWithSkype',
	'HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu',
	'HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\DefragglerShellExtension',
	'HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu',
	'HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\DefragglerShellExtension'
)

foreach ($key in $keys) {
	if (Test-Path -LiteralPath "Registry::$key") {
		cmd /c 'REG DELETE "$key" /f'
	}
}

<#=================
= Limpieza Total! =
=================#>

#Limpieza con el liberador de espacio en disco de Windows

#Colcoar al liberador de disco todas las opciones posible para eliminación de datos
$VolumeCachesRegDir = "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
Get-ItemProperty "$VolumeCachesRegDir\*" | ForEach-Object {
	$dir = ($VolumeCachesRegDir + "\" + $_.PSChildName)
	if (Get-ItemProperty $dir -Name "StateFlags0048" -ErrorAction SilentlyContinue) {
		Set-ItemProperty -Path $dir -Name "StateFlags0048" -Value 2 | Out-Null
	} else {
		New-ItemProperty -Path $dir -Name "StateFlags0048" -Value 2 -PropertyType DWord | Out-Null
	}
}

wRun("Limpieza desde liberador de espacio en disco de Windows...")
Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:48' -Wait
Remove-Item -LiteralPath ("${env:SystemRoot}\System32\LogFiles\setupcln") -Filter *	-Recurse -Force
wOk("Limpieza desde liberador de espacio terminada")


<#====================================
= Eliminacion de carpetas y archivos =
====================================#>

#desactivando servicios
wRun("Eliminado carpetas temporales e incecesarias...")
@(
	'ClickToRunSvc',
	'AdobeUpdateService'
) | ForEach-Object {
	wInfo("Parando servicio " + $_ + "...")
	Get-Service -Name $_ -ErrorAction SilentlyContinue | Stop-Service | Out-Null
}

#Eliminacion de archivos de cache

#Reconstrucción del caché de iconos
WRun('Reconstruccion del cache de iconos')

if (Test-Path -Path "$env:LOCALAPPDATA\IconCache.db" -PathType Leaf) {
	Remove-Item "$env:LOCALAPPDATA\IconCache.db" -Force
}

if (Test-Path -Path "$env:LOCALAPPDATA\Microsoft\Windows\Explorer" -PathType Container) {
	Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\iconcache*.*" -ErrorAction SilentlyContinue -Force
	Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache*.db" -ErrorAction SilentlyContinue -Force
	Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\*.tmp" -ErrorAction SilentlyContinue -Force -Recurse
}
wOk("Cache eliminada")

$unnecesaryFiles = @(
	"$env:LOCALAPPDATA\oobelibMkey.log" ###?
	"$env:systemDrive\autoexec.bat",
	"$env:systemDrive\config.sys",
	"$env:systemDrive\DumpStack.log.tmp",
	"$env:systemDrive\26746547A118",
	"$env:systemDrive\swapfile.sys",
	"$env:systemDrive\hiberfil.sys",
	"$env:systemDrive\pagefile.sys",
	"$env:systemDrive\winpepge.sys",
	"$env:windir\DirectX.log",
	"$env:windir\DtcInstall.log",
	"$env:windir\eguninstall.bat",
	"$env:windir\lsasetup.log",
	"$env:windir\PFRO.log",
	"$env:windir\setupact.log",
	"$env:windir\setuperr.log",
	"$env:windir\WindowsUpdate.log",
	"$env:windir\wsusofflineupdate.log"
)
wRun("Eliminacion de archivos no necesarios")

ie4uinit.exe -ClearIconCache
foreach ($file in $unnecesaryFiles) {
	if (Test-Path -Path $file -PathType Leaf) {
		wInfo("Eliminando $file...")
		Remove-Item -Path $file -Force
	}
}
wOk("Eliminación de archivos no necesarios terminada")

$folders = @(
	"$env:systemDrive\`$Recycle.Bin",
	"$env:systemDrive\`$Windows.~BT",
	"$env:systemDrive\`$Windows.~BT",
	"$env:systemDrive\`$Windows.~WS",
	"$env:systemDrive\`$Windows.~LS",
	"$env:systemDrive\Recycler",
	"$env:systemDrive\Recycled",
	"$env:systemDrive\PerfLogs",
	"$env:systemDrive\System Volume Information",
	"$env:windir\CSC",
	"$env:windir\CbsTemp",
	"$env:windir\Panther",
	"$env:windir\Prefetch",
	"$env:windir\SoftwareDistribution",
	"$env:windir\system32\LogFiles",
	"$env:windir\Temp",
	"$env:ProgramFiles\WindowsApps\Deleted\",
	"$env:ProgramFiles\WindowsApps\DeletedAllUserPackages\",
	"$env:ProgramData\Microsoft\Windows\Caches\",
	"$env:ProgramData\Microsoft\Windows\WER\",
	"$env:ProgramData\USOShared\Logs",
	"$env:LOCALAPPDATA\Microsoft\Office\16.0\WebServiceCache",
	"$env:LOCALAPPDATA\Microsoft\Office\OTele\",
	"$env:LOCALAPPDATA\Microsoft\Windows\Explorer\",
	"$env:LOCALAPPDATA\Microsoft\Windows\INetCache\",
	"$env:LOCALAPPDATA\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs\",
	"$env:LOCALAPPDATA\Temp\",
	"$env:LOCALAPPDATA\lxss",
	"$env:APPdata\Microsoft\Skype for Desktop\",
	"$env:APPdata\Microsoft\Skype\",
	"$env:APPdata\TeamViewer\",
	"$env:USERPROFILE\OneDrive",
	"$env:USERPROFILE\OneDrive - business"
	"$env:USERPROFILE\Documents\powertoys"
)

foreach ($folder in $folders) {
	$folder = $folder.trim("\")
	Winfo ("Intentando eliminar $folder...")
	if (Test-Path -Path $folder -PathType Container) {
		Get-OwnFolder($folder) | Out-Null
		Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
	}
}
#Restaurando configuración de archivos de sistema y ocultos
wRun ("Restaurando confgiracion de archivos de sistema y ocultos")
set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowSuperHidden"=dword:00000000
"Hidden"=dword:00000000

[HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowSuperHidden"=dword:00000000
"Hidden"=dword:00000000'
)

Start-Process "explorer.exe"

<#===========================================================
= Limpieza de carpetas de programa y ubicaciones de archivo =
===========================================================#>
#Corel Draw

if ($x86) {
	Set-Reg("-[HKEY_CURRENT_USER\SOFTWARE\Corel\CorelDRAW\22.0\Box Preferences\File Locations]")
} else {
	Set-Reg("-[HKEY_CURRENT_USER\SOFTWARE\Corel\CorelDRAW\24.0\Box Preferences\File Locations]")
}

$clean_path = [Environment]::GetFolderPath("MyDocuments") + "\Corel\"

if ((Test-Path -Path $clean_path -PathType Container)) {
	Remove-Item -Path "$clean_path" -Recurse -Force
}

#Adobe
$clean_path = [Environment]::GetFolderPath("MyDocuments") + "\Adobe\"
if ((Test-Path -Path $clean_path -PathType Container)) {
	Remove-Item -Path "$clean_path" -Recurse -Force
}

#Cmaptools
$clean_path = [Environment]::GetFolderPath("MyDocuments") + "\My Cmaps\"
if ((Test-Path -Path $clean_path -PathType Container)) {
	Remove-Item -Path "$clean_path" -Recurse -Force
}

<#=====================================
= Limpieza de Windows desde programas =
=====================================#>

#Ccleaner limpieza del registro
wRun("Limpieza del registro desde CCleaner")
wInfo("Continuará al terminar el proceso")

start-DbApp -appName "ccleaner" -ArgumentList "/REGISTRY" -wait

wRun("Ejecutando AuslogicsRegistry Defrag")
Winfo("Realizar la defragmentación en el siguiente reinicio")
start-DbApp -appName "Auslogic Registry Defrag" -wait

wOk("Limpieza del registro terminada")

#Dism++ Limpieza de archivos
wRun("Limpieza completa desde Dism++")
wInfo('Activar todo pero...:
	Sistema:
		Desactivar CompactOS
		Desactivar Hot Links (unir enlaces)
')
start-DbApp -appName "dism++" -wait
wOk("Limpieza desde Dism++ terminada")

#Ccleaner Limpieza de archivos
wRun("Limpieza completa desde CCleaner...")
start-DbApp -appName "ccleaner" -ArgumentList "/AUTO" -wait
wOk("Limpieza desde CCleaner terminada")


#BleachBit Limpieza de archivos
wOk("Limpieza desde BleachBit")

$appData = get-dbAppData('bleachbit')
if (!$x86 -and !$_.instFile_x64) {
	$appData.runFileAppPath = ($appData.runFileAppPath).Replace("ProgramFiles", "ProgramFiles(x86)")
}
$run = $appData.runFileAppPath + "?\" + $appData.runFileApp + "?"
$run = [string](get-ExecFileByArch -Path $run) -Replace (".exe", "_console.exe")
Start-Process -FilePath $run -ArgumentList "--preset -c" -Wait -NoNewWindow
wOk("Limpieza desde BleachBit terminada...")
