<# Adobe CC 2022 / 2018
==============#>
#revisar si en x64 tambien va el bloqueo de internet (firewall, Hosts, etc)!!!
function set-AdobeSoftware {
	param(
		[object]$app
	)
	$drive = ($PSScriptRoot.split('`\'))[0]
	wTitulo("Instalando " + $app.name + "...")

	#es necesario cambiar a la ruta donde se encuentra el archivo de instalación para iniciar el proceso
	Set-Location (get-Path -Filename ($app.instSrcPath + "\" + $app.instFile_x86))
	Start-Process $app.instFile_x86

	#espera a que el programa de instalación se cierre
	$wait = $true
	while ($wait) {
		Start-Sleep -s 3
		$wait = [bool]((Get-Process).Path -match $app.instFile_x86)
	}
	#Terminando el programa o inicio del programa
	if ([bool]((Get-Process).Path -match $app.runFileApp)) {
		wRun("Terminando el proceso de" + $app.name + "...")
		taskkill /IM $app.runFileApp /F | Out-Null
	}
	if ([bool]((Get-Process).Path -match "PDapp.exe")) {
		wRun("Terminando el proceso de " + $app.name + "...")
		taskkill /IM "PDapp.exe" /F | Out-Null
	}

	#Agregar datos del registro
	if ($app.regData) {
		wRun("Colocando datos de registro...")
		set-reg(Get-EnvPS($app.regData))
	}

	#Colocando archivo de crak
	if ($app.appCrkSrc) {
		$app.appCrkDestPath = Get-EnvPS($app.appCrkDestPath)
		if (!(Test-Path -Path $app.appCrkSrc -type Leaf ) ) {
			$srcPath = (Split-Path (Split-Path $app.appCrkSrc -Parent) -NoQualifier).Trim("\")
			$fileName = (Split-Path $app.appCrkSrc -Leaf).trim("\")
			$path = Get-Path -Filename $filename -Drive $drive -path $srcPath -Limit 1
			if ($path -eq '' -or $null -eq $path) {
				wError("No se encuentra el archivo de activación '" + $app.appCrkSrc + "'")
				Pause
				exit
			} else {
				$app.appCrkSrc = $path + "\" + $fileName
			}
		}

		$destCrk = $app.appCrkDestPath.trim("\") + "\" + $app.appCrkDestFileName
		if (Test-Path -Path $destCrk -PathType Leaf) {
			Rename-Item $destCrk -NewName ($app.CrkDestFileName + ".bak") -Force -ErrorAction SilentlyContinue
		}
		Copy-Item -Path $app.appCrkSrc -Destination $destCrk -Force
	}
	wOk($app.name + " instalado!")
}

wRun("Bloqueando acceso de Adobe hacia y desde internet...")

Add-ToHostsFile -ips @(
	"192.150.14.69",
	"192.150.18.101",
	"192.150.18.108",
	"192.150.22.40",
	"192.150.8.100",
	"192.150.8.118",
	"199.7.52.190",
	"199.7.52.190:80",
	"199.7.54.72",
	"199.7.54.72:80",
	"209-34-83-73.ood.opsource.net",
	"209.34.83.67",
	"209.34.83.67:43",
	"209.34.83.67:443",
	"209.34.83.73",
	"209.34.83.73:43",
	"209.34.83.73:443",
	"23.9.57.92",
	"3dns-1.adobe.com",
	"3dns-2.adobe.com",
	"3dns-3.adobe.com",
	"3dns-4.adobe.com",
	"3dns-5.adobe.com",
	"3dns.adobe.com",
	"54.86.200.32",
	"54.86.87.194",
	"57.87.40.9",
	"CRL.VERISIGN.NET.*",
	"OCSP.SPO1.VERISIGN.COM",
	"activate-sea.adobe.com",
	"activate-sjc0.adobe.com",
	"activate.adobe.com",
	"activate.wip.adobe.com",
	"activate.wip1.adobe.com",
	"activate.wip2.adobe.com",
	"activate.wip3.adobe.com",
	"activate.wip4.adobe.com",
	"adobe-dns-1.adobe.com",
	"adobe-dns-2.adobe.com",
	"adobe-dns-3.adobe.com",
	"adobe-dns-4.adobe.com",
	"adobe-dns.adobe.com",
	"adobe.activate.com",
	"adobeereg.com",
	"adobeid-na1.services.adobe.com",
	"crl.verisign.net",
	"ereg.adobe.com",
	"ereg.wip.adobe.com",
	"ereg.wip1.adobe.com",
	"ereg.wip2.adobe.com",
	"ereg.wip3.adobe.com",
	"ereg.wip4.adobe.com",
	"genuine.adobe.com",
	"hl2rcv.adobe.com",
	"hlrcv.stage.adobe.com",
	"ims-prod06.adobelogin.com",
	"labsdownload.adobe.com",
	"lm.licenses.adobe.com",
	"lmlicenses.wip4.adobe.com",
	"na1e-acc.services.adobe.com",
	"na1r.services.adobe.com",
	"oobe.adobe.com",
	"ood.opsource.net",
	"practivate.adobe.*",
	"practivate.adobe.com",
	"practivate.adobe.ipp",
	"practivate.adobe.newoa",
	"practivate.adobe.ntp",
	"prod.adobegenuine.com",
	"secure.tune-up.com",
	"server-52-85-142-80.iad12.r.cloudfront.ney",
	"swupmf.adobe.com",
	"tss-geotrust-crl.thawte.com",
	"wip.adobe.com",
	"wip1.adobe.com",
	"wip2.adobe.com",
	"wip3.adobe.com",
	"wip4.adobe.com",
	"wwis-dubc1-vip100.adobe.com",
	"wwis-dubc1-vip101.adobe.com",
	"wwis-dubc1-vip102.adobe.com",
	"wwis-dubc1-vip103.adobe.com",
	"wwis-dubc1-vip104.adobe.com",
	"wwis-dubc1-vip105.adobe.com",
	"wwis-dubc1-vip106.adobe.com",
	"wwis-dubc1-vip107.adobe.com",
	"wwis-dubc1-vip108.adobe.com",
	"wwis-dubc1-vip109.adobe.com",
	"wwis-dubc1-vip110.adobe.com",
	"wwis-dubc1-vip111.adobe.com",
	"wwis-dubc1-vip112.adobe.com",
	"wwis-dubc1-vip113.adobe.com",
	"wwis-dubc1-vip114.adobe.com",
	"wwis-dubc1-vip115.adobe.com",
	"wwis-dubc1-vip116.adobe.com",
	"wwis-dubc1-vip117.adobe.com",
	"wwis-dubc1-vip118.adobe.com",
	"wwis-dubc1-vip119.adobe.com",
	"wwis-dubc1-vip120.adobe.com",
	"wwis-dubc1-vip121.adobe.com",
	"wwis-dubc1-vip122.adobe.com",
	"wwis-dubc1-vip123.adobe.com",
	"wwis-dubc1-vip124.adobe.com",
	"wwis-dubc1-vip125.adobe.com",
	"wwis-dubc1-vip30.adobe.com",
	"wwis-dubc1-vip31.adobe.com",
	"wwis-dubc1-vip32.adobe.com",
	"wwis-dubc1-vip33.adobe.com",
	"wwis-dubc1-vip34.adobe.com",
	"wwis-dubc1-vip35.adobe.com",
	"wwis-dubc1-vip36.adobe.com",
	"wwis-dubc1-vip37.adobe.com",
	"wwis-dubc1-vip38.adobe.com",
	"wwis-dubc1-vip39.adobe.com",
	"wwis-dubc1-vip40.adobe.com",
	"wwis-dubc1-vip41.adobe.com",
	"wwis-dubc1-vip42.adobe.com",
	"wwis-dubc1-vip43.adobe.com",
	"wwis-dubc1-vip44.adobe.com",
	"wwis-dubc1-vip45.adobe.com",
	"wwis-dubc1-vip46.adobe.com",
	"wwis-dubc1-vip47.adobe.com",
	"wwis-dubc1-vip48.adobe.com",
	"wwis-dubc1-vip49.adobe.com",
	"wwis-dubc1-vip50.adobe.com",
	"wwis-dubc1-vip51.adobe.com",
	"wwis-dubc1-vip52.adobe.com",
	"wwis-dubc1-vip53.adobe.com",
	"wwis-dubc1-vip54.adobe.com",
	"wwis-dubc1-vip55.adobe.com",
	"wwis-dubc1-vip56.adobe.com",
	"wwis-dubc1-vip57.adobe.com",
	"wwis-dubc1-vip58.adobe.com",
	"wwis-dubc1-vip59.adobe.com",
	"wwis-dubc1-vip60.adobe.com",
	"wwis-dubc1-vip61.adobe.com",
	"wwis-dubc1-vip62.adobe.com",
	"wwis-dubc1-vip63.adobe.com",
	"wwis-dubc1-vip64.adobe.com",
	"wwis-dubc1-vip65.adobe.com",
	"wwis-dubc1-vip66.adobe.com",
	"wwis-dubc1-vip67.adobe.com",
	"wwis-dubc1-vip68.adobe.com",
	"wwis-dubc1-vip69.adobe.com",
	"wwis-dubc1-vip70.adobe.com",
	"wwis-dubc1-vip71.adobe.com",
	"wwis-dubc1-vip72.adobe.com",
	"wwis-dubc1-vip73.adobe.com",
	"wwis-dubc1-vip74.adobe.com",
	"wwis-dubc1-vip75.adobe.com",
	"wwis-dubc1-vip76.adobe.com",
	"wwis-dubc1-vip77.adobe.com",
	"wwis-dubc1-vip78.adobe.com",
	"wwis-dubc1-vip79.adobe.com",
	"wwis-dubc1-vip80.adobe.com",
	"wwis-dubc1-vip81.adobe.com",
	"wwis-dubc1-vip82.adobe.com",
	"wwis-dubc1-vip83.adobe.com",
	"wwis-dubc1-vip84.adobe.com",
	"wwis-dubc1-vip85.adobe.com",
	"wwis-dubc1-vip86.adobe.com",
	"wwis-dubc1-vip87.adobe.com",
	"wwis-dubc1-vip88.adobe.com",
	"wwis-dubc1-vip89.adobe.com",
	"wwis-dubc1-vip90.adobe.com",
	"wwis-dubc1-vip91.adobe.com",
	"wwis-dubc1-vip92.adobe.com",
	"wwis-dubc1-vip93.adobe.com",
	"wwis-dubc1-vip94.adobe.com",
	"wwis-dubc1-vip95.adobe.com",
	"wwis-dubc1-vip96.adobe.com",
	"wwis-dubc1-vip97.adobe.com",
	"wwis-dubc1-vip98.adobe.com",
	"wwis-dubc1-vip99.adobe.com",
	"www.adobeereg.com",
	"www.wip.adobe.com",
	"www.wip1.adobe.com",
	"www.wip2.adobe.com",
	"www.wip3.adobe.com"
) -comment "Adobe CC"

wOk("Acceso bloqueado!. Terminado.")

if ($x86) {
	<#===================
= Adobe CC 2018 X86 =
===================#>
	wTitulo("Instalación de La suite de diseño de Adobe CC 2018 para Windows de 32-Bit")

	#Adobe Bridge
	$app = get-dbAppData("Adobe bridge CC 2018")
	set-AdobeSoftware($app)

	#Adobe Dreamweaver
	$app = get-dbAppData("Adobe Dreamweaver CC 2018")
	set-AdobeSoftware($app)

	#Adobe Illustrator
	$app = get-dbAppData("Adobe Illustrator CC 2018")
	set-AdobeSoftware($app)

	#Adobe InDesign
	$app = get-dbAppData("Adobe InDesign CC 2018")
	set-AdobeSoftware($app)

	#Adobe Photoshop
	$app = get-dbAppData("Adobe Photoshop CC 2018")
	set-AdobeSoftware($app)

	Start-Sleep -s 2
	wRun("Ejecutando la limpieza de los programas de Adobe")
	while ((Get-Service -Name AdobeUpdateService -ErrorAction SilentlyContinue).Status -eq "Running") {
		Stop-Service -Name 'AdobeUpdateService' -Force
		Start-Sleep -s 2
	}

	$process = @(
		"Adobe CEF Helper.exe",
		"Creative Cloud.exe",
		"AdobeIPCBroker.exe",
		"CCLibrary.exe",
		"CCXProcess.exe",
		"Adobe Desktop Service.exe",
		"Adobe Genuine Helper.exe",
		"AdobeGCClient.exe"
		"armsvc.exe"
	)

	$services = @(
		'AdobeUpdateService',
		'AGMService',
		'AGSService'
	)

	$tasks = @(
		'AdobeGCInvoker-1.0'
	)

	foreach ($proc in $process) {
		wRun("Terminando el proceso " + $proc + "...")
		while ([bool]((Get-Process).Path -match $proc)) {
			taskkill /IM $proc /F | Out-Null
			Start-Sleep -s 1
		}
	}

	foreach ($serv in $services) {
		wRun("Terminando el servicio " + $serv + "...")
		if (Get-Service -Name $serv -ErrorAction SilentlyContinue) {
			while ((Get-Service -Name $serv).Status -eq "Running") {
				Stop-Service -Name $serv -Force
				Start-Sleep -s 1
			}
		}
	}

	foreach ($task in $tasks) {
    (Get-ScheduledTask).TaskName | ForEach-Object {
			if ($_ -match $task) {
				Unregister-ScheduledTask -TaskName $_ -Confirm:$false
			}
		}
	}

	set-reg('
;Eliminar Bridge del menú contextual
-[HKEY_CLASSES_ROOT\Directory\shell\Bridge]

;Eliminar ejecución de programas al iniciar Windows
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Adobe Creative Cloud"=-
"AdobeAAMUpdater-1.0"=-
"AdobeGCInvoker-1.0"=-
"AdobeBridge"=-

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Adobe Creative Cloud"=-
"AdobeAAMUpdater-1.0"=-
"AdobeGCInvoker-1.0"=-
"AdobeBridge"=-


;Eliminando servicios de Adobe
-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AdobeUpdateService]
-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AGMService]
-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AGSService]
')

} else {
	<#===============
= Adobe CC X64 =
===============#>

	$app = get-dbAppData("Adobe CC 2022")
	install-app($app)

	<#After Effects
#Datos en el registro de After Effects

set-reg('
-[HKEY_CURRENT_USER\SOFTWARE\Adobe\Common 15.0\Media Cache]
[HKEY_CURRENT_USER\SOFTWARE\Adobe\Common 15.0\Media Cache]
"DatabasePath"="C:\\Windows\\Temp"
"FolderPath"="C:\\Windows\\Temp"
"InsertDocIDsOnImport2"=dword:00000000

#Datos en archivo de preferencias de After Effects
$prefs_data = @{
    path = "$env:APPDATA\Adobe\After Effects\22.0"
    file = "Adobe After Effects 22.0 MC Prefs"
    encoding = 'default'
    data = '??????????????????????????'
}
Set-PrefsFile($prefs_data)
#>
	wRun("Aplicando configuraciones para After Effects")
	set-reg('-[HKEY_CURRENT_USER\SOFTWARE\Adobe\Common 22.0]')


	<#Audition
wRun("Aplicando configuraciones para Audition")
$prefs_data = @{
    path = "$env:APPDATA\Adobe\Audition\22.0"
    file = "ApplicationSettings.xml"
    encoding = 'default'
    data = '????????????????'
}
Set-PrefsFile($prefs_data)
#>

	<# Adobe Bridge 2021 guarda el dato de carpeta temporal en el registro
#>
	wRun("Aplicando configuraciones para Bridge 2022")
	set-reg('-[HKEY_CURRENT_USER\SOFTWARE\Adobe\Common 15.0]
-[HKEY_CURRENT_USER\SOFTWARE\Adobe\Bridge 2022]
')

	#Lightroom
	#Cambia En el registro, en el arhchivo de preferencias de camera raw y en el archivo de preferencias de lightroom
	#Adicional Elimina la carpeta de lightroom en la carpeta de imágenes
	wRun("Aplicando configuraciones para Lightroom")

	set-reg('-[HKEY_CURRENT_USER\SOFTWARE\Adobe\Lightroom]
[HKEY_CURRENT_USER\SOFTWARE\Adobe\Lightroom]
"language"="es"
"Locale"="es_MX"')

	@(
		"${env:APPDATA}\Adobe\Lightroom\Preferences\Lightroom Classic CC 7 Preferences.agprefs",
		"${env:APPDATA}\Adobe\Lightroom\Preferences\Lightroom Classic CC 7 Startup Preferences.agprefs"
	) | ForEach-Object {
		if (Test-Path $_ -PathType Leaf) {
			Remove-Item -Path $_ -Force
		}
	}

	<# ARCHIVO DE PREFERENCIAS DE CAMERARAW OMITIDO
$prefs_data = @{
    path = "$env:APPDATA\Adobe\CameraRaw\Defaults"
    file = "Preferences.xmp"
    encoding = 'utf8'
    data = '????????????????????'
}
Set-PrefsFile($prefs_data)

#####ARCHIVO DE PREFERENCIAS DE LIGHTROOM OMITIDO

$prefs_data = @{
    path = "$env:APPDATA\Adobe\Lightroom\Preferences"
    file = "Lightroom Classic CC 7 Preferences.agprefs"
    encoding = 'utf8'
    data = 'prefs = {
    AgDevelopDefaults_showSerialNumber = false,
    AgDocument_moduleHost_firstPanelShowing = false,
    AgTemplateBrowser_storePresetsWithCatalog = false,
	PreventSystemSleepDuringSync = true,
	ShowAutoSyncNotifications = true,
    doNotShowPrompts = "exitDialog,lrupdate_doNotShowKeyFor_9.2,",
    exitDialog = "exit",
    ["lrupdate_doNotShowKeyFor_9.2"] = "ok",
    noAutomaticallyCheckUpdates = true,
    recentLibraryBehavior20 = "AlwaysPromptForLibrary"
    useTestUpdateSite = false,
}'
}
Set-PrefsFile($prefs_data)
#>
	wRun("Colocando Archivos de preferencias de LightRoom")
	$prefs_data = @{
		path     = "$env:APPDATA\Adobe\Lightroom\Preferences"
		file     = "Lightroom Classic CC 7 Startup Preferences.agprefs"
		encoding = 'utf8'
		data     = 'prefs = {
	libraryToLoad20 = "",
	recentLibraries20 = "recentLibraries = {\
}\
",
	recentLibraries20_missing = "recentMissingLibraries = {\
}\
",
	recentLibraryBehavior20 = "AlwaysPromptForLibrary",
}
'
	}

	Set-PrefsFile($prefs_data)

	$catalog_folder = [Environment]::GetFolderPath("MyPictures")
	$catalog_folder = "$catalog_folder\Lightroom"

	if (Test-Path $catalog_folder) {
		Remove-Item $catalog_folder -Force -Recurse
	}

	wRun("Deteniendo aplicaiones...")
	@(
		'AdobeIPCBroker',
		'CCLibrary',
		'CCXProcess',
		'CoreSync',
		'node',
		'Adobe Genuine Helper.exe',
		'AdobeGCClient.exe',
		'armsvc.exe'
	) | ForEach-Object {
		while (Get-Process -Name $_ -ErrorAction SilentlyContinue) {
			Write-Output "Intentando cerrar el proceso: $_"
			Stop-Process -Name $_ -Force
			Start-Sleep -s 1
		}
	}

	wRun("Ingresando configuraciones de la suite de Adobe en el registro")
	set-reg('
;Eliminar Bridge del menú contextual
-[HKEY_CLASSES_ROOT\Directory\shell\Bridge 12]

;Eliminar ejecución de programas al iniciar Windows
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Adobe Creative Cloud"=-
"AdobeAAMUpdater-1.0"=-
"AdobeGCInvoker-1.0"=-
"AdobeBridge"=-
"CCXProcess"=-

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Adobe Creative Cloud"=-
"AdobeAAMUpdater-1.0"=-
"AdobeGCInvoker-1.0"=-
"AdobeBridge"=-
"CCXProcess"=-

;Eliminando servicios de Adobe
-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AdobeUpdateService]
-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AGMService]
-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AGSService]
')
	<# Limpieza #>
} #Fin de x64

wrun("Agregando al firewall las aplicaciones de Adobe")
#Adobe CC Firewall block x64
@(
	"${Env:ProgramFiles}\Adobe",
	"${Env:CommonProgramFiles}\Adobe",
	"${Env:ProgramFiles(x86)}\Adobe",
	"${Env:CommonProgramFiles(x86)}\Adobe",
	"${Env:CommonProgramFiles(x86)}\Enfocus",
	"${Env:CommonProgramFiles(x86)}\Enfocus Software",
	"${Env:ProgramData}\Adobe",
	"${Env:LOCALAPPDATA}\Adobe",
	"${Env:APPDATA}\Adobe"
) | ForEach-Object {
	Block-InFirewall -Path (Get-envPS($_)) -Extension "exe"
}

#Verificando Pitstop y eliminando del firewall acrobat ya que requiere conexion
$pitstop = get-dbAppData("Enfocus Pitstop Pro 2022")
if (Test-Path -Path (Get-EnvPS($pitstop.instDir))) {
	Get-NetFirewallRule | Where-Object -Property "DisplayName" -ilike "*acrobat.exe*out*" | Remove-NetFirewallRule
}
