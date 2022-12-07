$global:Bloatware = @(
	"microsoft.windowscommunicationsapps" #Eliminar primero pues tiene dependencias
	"Microsoft.BingNews" #No en 22H2
	"Microsoft.BingWeather"
	"Microsoft.GetHelp"
	"Microsoft.Getstarted"
	"Microsoft.Messaging" #No en 22H2
	"Microsoft.Microsoft3DViewer"
	"Microsoft.MicrosoftOfficeHub"
	"Microsoft.MixedReality.Portal"
	"Microsoft.NetworkSpeedTest" #No en 22H2
	"Microsoft.News" #No en 22H2
	"Microsoft.Office.Lens" #No en 22H2
	"Microsoft.Office.OneNote"
	"Microsoft.Office.Sway" #No en 22H2
	"Microsoft.Office.Todo.List" #No en 22H2
	"Microsoft.OneConnect" #No en 22H2
	"Microsoft.PPIProjection" #No en 22H2
	"Microsoft.People"
	"Microsoft.Print3D" #No en 22H2
	"Microsoft.RemoteDesktop" #No en 22H2
	"Microsoft.SkypeApp" #No en 22H2
	"Microsoft.StorePurchaseApp"
	"Microsoft.Wallet"
	"Microsoft.Whiteboard" #No en 22H2
	"Microsoft.Windows.Photos"
	"Microsoft.WindowsAlarms"
	"Microsoft.WindowsFeedbackHub"
	"Microsoft.WindowsMaps"
	"Microsoft.WindowsSoundRecorder"

	"Microsoft.ZuneMusic"
	"Microsoft.ZuneVideo"
	"AdobeSystemsIncorporated.AdobePhotoshopExpress" #No en 22H2
	"ActiproSoftwareLLC" #No en 22H2
	"BubbleWitch3Saga" #No en 22H2
	"CandyCrush" #No en 22H2
	"Dolby" #No en 22H2
	"Duolingo-LearnLanguagesforFree" #No en 22H2
	"Facebook" #No en 22H2
	"Flipboard" #No en 22H2
	"EclipseManager" #No en 22H2
	"Minecraft" #No en 22H2
	"PandoraMediaInc" #No en 22H2
	"Royal Revolt" #No en 22H2
	"Spotify" #No en 22H2
	"Sway" #No en 22H2
	"Twitter" #No en 22H2
	"Wunderlist" #No en 22H2

	#"Microsoft.Services.Store.Engagement" #Omitido por ser requerido para sticky notes
	"Microsoft.549981C3F5F10"# Omitir ya que genera un error al eliminar
)

$xboxBloatware = @(
	"Microsoft.Xbox.TCUI"
	"Microsoft.XboxApp"
	"Microsoft.XboxGameOverlay"
	"Microsoft.XboxGamingOverlay"
	"Microsoft.XboxIdentityProvider"
	"Microsoft.XboxSpeechToTextOverlay"
)

#For reference whitelist Apps
$global:WhiteListedApps = @(
	"Microsoft.Advertising.Xaml" #No en 22H2
	"Microsoft.HEIFImageExtension"
	"Microsoft.LanguageExperiencePackes-MX"
	"Microsoft.MSPaint"
	"Microsoft.MicrosoftSolitaireCollection"
	"Microsoft.MicrosoftStickyNotes"
	"Microsoft.NET.Native.Framework.1.7"
	"Microsoft.NET.Native.Framework.2.2"
	"Microsoft.NET.Native.Runtime.1.7"
	"Microsoft.NET.Native.Runtime.2.2"
	"Microsoft.ScreenSketch"
	"Microsoft.Services.Store.Engagement"
	"Microsoft.UI.Xaml.2.0"
	"Microsoft.UI.Xaml.2.1"
	"Microsoft.UI.Xaml.2.3"
	"Microsoft.UI.Xaml.2.4"
	"Microsoft.UI.Xaml.2.7"
	"Microsoft.UI.Xaml.2.8"
	"Microsoft.VCLibs.140.00"
	"Microsoft.VCLibs.140.00.UWPDesktop"
	"Microsoft.VP9VideoExtensions"
	"Microsoft.WebMediaExtensions"
	"Microsoft.WebpImageExtension"
	"Microsoft.WindowsCalculator"
	"Microsoft.WindowsStore"
	"Microsoft.WindowsCamera"
	"Microsoft.YourPhone"

	"*Nvidia*" #No en 22H2
	"CanonicalGroupLimited.UbuntuonWindows" #No en 22H2
	"MIDIBerry" #No en 22H2
	"Microsoft.DesktopAppInstaller" #No en 22H2
	"Microsoft.StorePurchaseApp" #No en 22H2
	"Microsoft.WebMediaExtensions" #No en 22H2
	"Slack" #No en 22H2
	"WindSynthBerry" #No en 22H2
	"\.NET" #No en 22H2
)

#Creates a PSDrive to be able to access the 'HKCR' tree #>
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

#Solicitudes realizadas a usuario
$xboxDebloat = get-PcbReg -name "xboxDebloat"
$wstoreDebloat = get-PcbReg -name 'wstoreDebloat'
$oneDriveDebloat = get-PcbReg -name "oneDriveDebloat"

#Agregar Xbox al bloatware a eliminar
if ($xboxDebloat) {
	$Bloatware += $xboxBloatware
}

$NonRemovables = Get-AppxPackage -AllUsers | Where-Object { $_.NonRemovable -eq $true } | ForEach-Object { $_.Name }
$NonRemovables += Get-AppxPackage | Where-Object { $_.NonRemovable -eq $true } | ForEach-Object { $_.Name }
$NonRemovables += Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.NonRemovable -eq $true } | ForEach-Object { $_.DisplayName }
$NonRemovables = $NonRemovables | Sort-Object -Unique

#convert to regular expression to allow for the super-useful -match operator
$global:BloatwareRegex = $global:Bloatware -join '|'
$global:WhiteListedAppsRegex = $global:WhiteListedApps -join '|'

<#########################################
# Comandos para eliminacion de bloatware #
#########################################>
wTitulo("Eliminando aplicaciones inecesarias")

#Eliminando enlace a Microsoft Egde en el escritorio
$DesktopPath = @(
	[Environment]::GetFolderPath("Desktop")
	$env:PUBLIC + "\Desktop"
)
$DesktopPath | ForEach-Object {
	Get-ChildItem -Path $_ -Include "*edge*.lnk" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force
}
WRun("Solicitando la eliminacion de $global:BloatwareRegex")
WInfo("Esto puede tomar un tiempo. Espere...")

Get-AppxPackage -AllUsers | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxPackage -Verbose -ErrorAction SilentlyContinue
Get-AppxPackage | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxPackage -Verbose -ErrorAction SilentlyContinue
Get-AppxPackage | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxPackage -Verbose -AllUsers -ErrorAction SilentlyContinue
Get-AppxPackage -AllUsers | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxPackage -Verbose -AllUsers -ErrorAction SilentlyContinue | Out-Null

wRun("Eliminando las aplicaciones silenciosas de 'ProvisionedPackage'...")

Get-AppxProvisionedPackage -Online | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object DisplayName -CMatch $global:BloatwareRegex | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null

wRun("Eliminación final...")
Get-AppxPackage -AllUsers | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxPackage -Verbose -ErrorAction SilentlyContinue
Get-AppxPackage | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxPackage -Verbose -ErrorAction SilentlyContinue
Get-AppxPackage | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxPackage -Verbose -AllUsers -ErrorAction SilentlyContinue
Get-AppxPackage -AllUsers | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxPackage -Verbose -AllUsers -ErrorAction SilentlyContinue
Get-AppxProvisionedPackage -Online | Where-Object Name -CMatch $global:BloatwareRegex | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
Get-AppxProvisionedPackage -Online | Where-Object DisplayName -CMatch $global:BloatwareRegex | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null

wOk("Limpieza de aplicaciones terminada")

###########################################################
# Desactivar Actualizaciones automaticas de Windows Store #
###########################################################
wTitulo("Aplicando configuracion de Windows Store")

if ($wstoreDebloat) {
	$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
	If (!(Test-Path $registryPath)) {
		mkdir $registryPath | Out-Null
		New-ItemProperty $registryPath AutoDownload -Value 2  | Out-Null
	}
	Set-ItemProperty $registryPath AutoDownload -Value 2 | Out-Null

	#Stop WindowsStore Installer Service and set to Disabled
	wRun("Desactivando actualizaciones automáticas de Windows Store")
	Stop-Service InstallService | Out-Null
	Set-Service InstallService -StartupType Disabled | Out-Null

	wRun("Habilitando el servicio WAP Push")
	If (Get-Service dmwappushservice | Where-Object { $_.StartType -eq "Disabled" }) {
		Set-Service dmwappushservice -StartupType Automatic
	}

	If (Get-Service dmwappushservice | Where-Object { $_.Status -eq "Stopped" }) {
		Start-Service dmwappushservice
	}

	#These are the registry keys that it will delete.
	wRun ("Eliminando claves de registro no usadas...")
	$Keys = @(

		#Remove Background Tasks
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"

		#Windows File
		"HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"

		#Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"

		#Scheduled Tasks to delete
		"HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"

		#Windows Protocol Keys
		"HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
		"HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
		"HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"

		#Windows Share Target
		"HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
	)

	#This writes the output of each key it is removing and also removes the keys listed above.
	ForEach ($Key in $Keys) {
		Remove-Item $Key -Recurse -ErrorAction SilentlyContinue
	}
	wOk("Claves de registro eliminadas")

	#Loads the registry keys/values below into the NTUSER.DAT file which prevents the apps from redownloading. Credit to a60wattfish
	wInfo("Evitando reactivación de aplicaciones desactivadas")
	Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
		"ContentDeliveryAllowed"=dword:00000000
		"FeatureManagementEnabled"=dword:00000000
		"OemPreInstalledAppsEnabled"=dword:00000000
		"PreInstalledAppsEnabled"=dword:00000000
		"PreInstalledAppsEverEnabled"=dword:00000000
		"RotatingLockScreenEnabled"=dword:00000000
		"RotatingLockScreenOverlayEnabled"=dword:00000000
		"SilentInstalledAppsEnabled"=dword:00000000
		"SoftLandingEnabled"=dword:00000000
		"SystemPaneSuggestionsEnabled"=dword:00000000
		"SlideshowEnabled"=dword:00000000
		"SubscribedContent-310093Enabled"=dword:00000000
		"SubscribedContent-338387Enabled"=dword:00000000
		"SubscribedContent-338388Enabled"=dword:00000000
		"SubscribedContent-338389Enabled"=dword:00000000
		"SubscribedContent-338393Enabled"=dword:00000000
		"SubscribedContent-353698Enabled"=dword:00000000
		"SubscribedContent-353694Enabled"=dword:00000000
		"SubscribedContent-353696Enabled"=dword:00000000
	')
	reg load HKU\Default_User C:\Users\Default\NTUSER.DAT
	Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name ContentDeliveryAllowed -Value 0
	Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name OemPreInstalledAppsEnabled -Value 0
	Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name PreInstalledAppsEnabled -Value 0
	Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SystemPaneSuggestionsEnabled -Value 0
	reg unload HKU\Default_User

}#Fin de eliminación de Windows Store

#Disables scheduled tasks that are considered unnecessary
wInfo ("Deshabilitando tareas programadas no necesarias...")

if ($xboxDebloat) {
	#Get-ScheduledTask -TaskName XblGameSaveTaskLogon | Disable-ScheduledTask | Out-Null # Omitido ya que no existe
	Get-ScheduledTask -TaskName XblGameSaveTask | Disable-ScheduledTask | Out-Null
}
Get-ScheduledTask -TaskName Consolidator | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName UsbCeip | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName DmClient | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName DmClientOnScenarioDownload | Disable-ScheduledTask | Out-Null

wInfo("Eliminando 'Objetos 3D del submenú de 'Mi Equipo'")
Set-Reg('
-[HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}]"
-[HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}]'
)
Remove-Item "${env:USERPROFILE}\3D Objects" -Recurse -Force -ErrorAction SilentlyContinue

wInfo("Reiniciando el servicio 'Servicio de instalación de Microsoft Store'...")
If (Get-Service dmwappushservice | Where-Object { $_.StartType -eq "Disabled" }) {
	Set-Service dmwappushservice -StartupType Automatic
}

If (Get-Service dmwappushservice | Where-Object { $_.Status -eq "Stopped" }) {
	Start-Service dmwappushservice
}

If (Get-Service InstallService | Where-Object { $_.Status -eq "Stopped" }) {
	Set-Service InstallService -StartupType Automatic
	Start-Service InstallService
}
wInfo("Deshabilitando Cortana...")

Set-Reg('
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Personalization\Settings]
"AcceptedPrivacyPolicy"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputPersonalization]
"RestrictImplicitInkCollection"=dword:00000001
"RestrictImplicitTextCollection"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore]
"HarvestContacts"=dword:00000000
')

#########################################################
#Stops edge from taking over as the default .PDF viewer #
#########################################################

wTitulo ("Evitando que Edge se convierta en el visor de PDF")
$NoPDF = "HKCR:\.pdf"
$NoProgids = "HKCR:\.pdf\OpenWithProgids"
$NoWithList = "HKCR:\.pdf\OpenWithList"

If (-not (Get-Item $NoPDF -ErrorAction SilentlyContinue)) {
	New-Item $NoPDF | Out-Null
}

If (-not (Get-Item $NoProgids -ErrorAction SilentlyContinue)) {
	New-Item $NoProgids | Out-Null
}

If (-not (Get-Item $NoWithList -ErrorAction SilentlyContinue)) {
	New-Item $NoWithList | Out-Null
}

If (-not (Get-ItemProperty $NoPDF NoOpenWith -ErrorAction SilentlyContinue)) {
	New-ItemProperty $NoPDF NoOpenWith | Out-Null
}
If (-not (Get-ItemProperty $NoPDF NoStaticDefaultVerb -ErrorAction SilentlyContinue)) {
	New-ItemProperty $NoPDF NoStaticDefaultVerb | Out-Null
}
If (-not (Get-ItemProperty $NoProgids NoOpenWith -ErrorAction SilentlyContinue)) {
	New-ItemProperty $NoProgids NoOpenWith | Out-Null
}
If (-not (Get-ItemProperty $NoProgids NoStaticDefaultVerb -ErrorAction SilentlyContinue)) {
	New-ItemProperty $NoProgids NoStaticDefaultVerb | Out-Null
}
If (-not (Get-ItemProperty $NoWithList NoOpenWith -ErrorAction SilentlyContinue)) {
	New-ItemProperty $NoWithList NoOpenWith | Out-Null
}
If (-not (Get-ItemProperty $NoWithList NoStaticDefaultVerb -ErrorAction SilentlyContinue)) {
	New-ItemProperty $NoWithList NoStaticDefaultVerb | Out-Null
}

#Appends an underscore '_' to the Registry key for Edge
$Edge = "HKCR:\AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723"
If (Test-Path $Edge) {
	Set-Item $Edge AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_ | Out-Null
	Rename-Item $Edge AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_ | Out-Null
}
######################
# Removing One Drive #
######################
if ($oneDriveDebloat) {
	wTitulo("Desinstalado OneDrive")
	If (Test-Path "$env:USERPROFILE\OneDrive\*") {
		Remove-Item -Path "$env:USERPROFILE\OneDrive\*" -Recurse
	}
	if (Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue) {
		taskkill.exe /F /IM "OneDrive.exe" | Out-Null
	}
	Start-Sleep 2

	$oneDriveSetup = "$env:systemroot\System32\OneDriveSetup.exe"
	if (Test-Path $oneDriveSetup) {
		wRun("Desinstalando Onedrive x86")
		Start-Process -FilePath $oneDriveSetup -ArgumentList "/uninstall" -Wait
	}
	$oneDriveSetup = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
	if (Test-Path $oneDriveSetup) {
		wRun("Desinstalando Onedrive x64")
		Start-Process -FilePath $oneDriveSetup -ArgumentList "/uninstall" -Wait
	}
	Start-Sleep 5

	WRun("Eliminando carpetas residuales de OneDrive")
	If (Test-Path "$env:USERPROFILE\OneDrive") {
		Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse
	}
	If (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive") {
		Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
	}
	If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive") {
		Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
	}
	If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
		Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse
	}

	WRun("Eliminando preferencias y configuraciones residuales de OneDrive")
	Set-Reg('-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive1]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive2]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive3]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive4]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive5]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive6]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive7]

	-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive1]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive2]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive3]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive4]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive5]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive6]
	-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellIconOverlayIdentifiers\ OneDrive7]

	[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive]
	"DisableFileSyncNGSC"=dword:00000001
	"OneDrive"="DisableFileSyncNGSC"

	-[HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]
	-[HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]

	[HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]
	"System.IsPinnedToNameSpaceTree"=dword:00000000

	[HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]
	"System.IsPinnedToNameSpaceTree"=dword:00000000

	')
	reg load "hku\Default" "C:\Users\Default\NTUSER.DAT" | Out-Null

	if (Test-RegistryValue -Path "Registry::HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -value "OneDriveSetup") {
		set-reg('[HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
		"OneDriveSetup"=-')
	}
	reg unload "hku\Default" | Out-Null -ErrorAction SilentlyContinue

	#quitando icono de onedrive
	Remove-Item -Force "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -ErrorAction SilentlyContinue | Out-Null

	#Quitando tarea programada de onedrive
	Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

	#Quitando Archivos adicionales de onedrive
	foreach ($item in (Get-ChildItem "$env:WinDir\WinSxS\*onedrive*")) {
		get-OwnFolder $item.FullName
		Remove-Item -Recurse -Force $item.FullName
	}

	Remove-PSDrive -Name HKCR | Out-Null
	Remove-Item env:OneDrive -ErrorAction SilentlyContinue
	[Environment]::SetEnvironmentVariable("onedrive", "", "Machine")
	[Environment]::SetEnvironmentVariable("onedrive", "", "User")

	wOk ("OneDrive desinstalado!")
}
