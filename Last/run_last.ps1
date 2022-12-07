Clear-Host

#Carga de funciones requeridas para ejecución

#importación de modulo de funciones
Import-Module -DisableNameChecking "$PSScriptroot\lib\pcb-win10_install_main_module.psm1"

####################
# Área de permisos #
####################

#Verificación de ejecución con privilegios elevados
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Host "Elevando privilegios..."
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	exit
}
do {} until (Get-ElevatedPrivileges SeTakeOwnershipPrivilege)
#Colocar la carpeta temporal de Windows accesible para todos los usuarios

Set-FullAccess("${env:temp}")

$global:state = Get-InstallationState

#Obtener lista de archivos requeridos
$global:LastSurplusfileList = [array]@()  #Variable global
$ziplistFile = "$PSScriptRoot\ziplist.txt"
$list = $false
$attrStart = 0
& ("$env:ProgramFiles\7-Zip\7z.exe") l $PSScriptRoot\wInstall.7z -pwInstall | Out-File -FilePath $ziplistFile -Encoding ASCII
$zipFileContent = Get-Content -Path $ziplistFile

$lines = $zipFileContent -split ("`n", "")
foreach ($line in $lines) {
	if ($line.StartsWith("-") -or $line -like "*files,*" -or ($line.Substring($attrStart)).StartsWith("D")) {
		continue
	}
	if ($list) {
		$File = $PSScriptRoot + "\" + $line.Substring($nameStart)

		$LastSurplusfileList += $file
		if (Test-Path -Path $file -PathType Leaf) {
			Remove-Item -Path $File
		}
	}
	if ($line -like "*Date*" -and !$list) {
		$list = $true
		$nameStart = $line.IndexOf("Name")
		$attrStart = $line.IndexOf("Attr") - 1
	}
}

Remove-Item -Path $ziplistFile -Force

& ("$env:ProgramFiles\7-Zip\7z.exe") x "$PSScriptRoot\wInstall.7z" -o"$PSScriptRoot" -pwInstall -aoa | Out-Null

WTitulo("Configuración final de Windows")


if (!$state) {
	#Agregar autoejecución de Last
	Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
	"Last"=' + $PSScriptRoot + '\last.cmd')

	#Desactivando adaptadores de red
	wRun("Desactivando adaptadores de red")
	Disable-NetAdapter -Name "*" -IncludeHidden -Confirm:$False -ErrorAction SilentlyContinue
	Start-Sleep -S 2

	<#######################################
	# Ejecución de la primera fase de Last #
	#######################################>
	wTitulo("Recuerde mover las carpetas de usuario e instalar controladores")
	Pause
	#cambio de la distribución de teclado
	$kbLayout = @(
		[pscustomobject]@{
			Letra           = 'A'
			Distribución    = "España"
			Verificación    = "La arroba está en la tecla del número 2"
			Nombre          = "Español"
			InputMethodTips = "240A:0000040A"
		},
		[pscustomobject]@{
			Letra           = "B"
			Distribución    = "Latinoamérica"
			Verificación    = "La arroba esta en la tecla Q"
			Nombre          = "Latinoamericano"
			InputMethodTips = "240A:0000080A"
		},
		[pscustomobject]@{
			Letra           = "C"
			Distribución    = "Ingles EEUU"
			Verificación    = "Sin `"Ñ`""
			Nombre          = "Estados Unidos"
			InputMethodTips = "240A:00000409"
		},
		[pscustomobject]@{
			Letra           = "D"
			Distribución    = "Ingles EEUU - Internacional"
			Verificación    = "Sin `"Ñ`" con ALT GR escribe tildes"
			Nombre          = "Estados Unidos Internacional"
			InputMethodTips = "240A:00020409"
		},
		[pscustomobject]@{
			Letra           = "E"
			Distribución    = "UK (British)"
			Verificación    = "La arroba esta a la izq de la virgulilla"
			Nombre          = "Reino Unido (Extendido)"
			InputMethodTips = "240A:00000809"
		}
	)

	$kbLayout | Select-Object Letra, Distribución, Verificación, Nombre | Out-Host
	$options = ($kbLayout | ForEach-Object { $_.Letra })
	$kbSel = Get-UserChoice -text ("Selecciona la configuración de teclado del computador: ") -Options $options

	$kbLayout | ForEach-Object {
		if ($_.Letra -iLike $kbSel) {
			$kbSel = $_.InputMethodTips
		}
	}

	$LanguageList = New-WinUserLanguageList es-CO
	$LanguageList[0].InputMethodTips.Clear()
	$LanguageList[0].InputMethodTips.Add($kbSel)

	Set-WinUserLanguageList $LanguageList -Force

	#Area de preguntas
	$global:xboxDebloat = Get-UserAnswer("¿Usas la app de Xbox?")
	$global:wstoreUp = Get-UserAnswer("¿Usas apps de Windows Store?")
	$global:oneDriveDebloat = Get-UserAnswer("¿Dejar One Drive?")
	$global:OwnWinKey = Get-UserAnswer("¿Tienes alguna licencia de Windows?")

	set-PcbReg -name 'xboxDebloat' -Value (-not $xboxDebloat)
	set-PcbReg -name 'wstoreDebloat' -Value (-not $wstoreUp)
	set-PcbReg -name 'oneDriveDebloat' -Value (-not $oneDriveDebloat)
	set-PcbReg -name 'OwnWinKey' -Value ($OwnWinKey)

	#Configuraciones finales de programas
	wTitulo("Terminando de configurar programas")

	taskkill.exe /F /IM "explorer.exe" | Out-Null
	$script = $PSScriptRoot + "\firstRunClean.ps1"
	. $script

	$script = $PSScriptRoot + "\hacksAfterOOBE.ps1"
	. $script

	$script = $PSScriptRoot + "\softwarePrefs.ps1"
	. $script

	#Configurar Memoria virtual
	$script = $PSScriptRoot + "\virtualMemory.ps1"
	. $script

	#Mejorando unidades SSD
	$script = $PSScriptRoot + "\Tweak-SSD.ps1"
	. $script

	#Colocando esquema de enería
	$script = $PSScriptRoot + "\powerSchema.ps1"
	. $script

	#Eliminación de Bloatware
	wTitulo("Eliminando aplicaciones inecesarias de Microsoft Windows...")
	$script = $PSScriptRoot + "\Windows10Debloater.ps1"
	. $script

	#Desactivación de servicios no necesarios y que relentizan el computador (Incluye de telemetria y de bloatware)
	wTitulo("Desactivando servicions no necesarios")
	$script = $PSScriptRoot + "\unwantedServices.ps1"
	. $script
	wOk("Servicios Desactivados")

	#Bloqueo de telemetria
	wTitulo("Bloqueando Telemetría")
	$script = $PSScriptRoot + "\disableTelemetry.ps1"
	. $script

	wTitulo("Configuraciones adicionales de Windows")
	$script = $PSScriptRoot + "\regChanges.ps1"
	. $script

	wTitulo("Configurando protección del sistema")
	wRun("Activando para la unidad $env:SystemDrive")
	Enable-ComputerRestore -Drive $env:SystemDrive
	vssadmin resize shadowstorage /for=$env:SystemDrive /on=$env:SystemDrive /maxsize=7% | Out-Null

	wTitulo("Ejecutando programas de mejoramiento de Windows")
	$script = $PSScriptRoot + "\Tweaks_1.ps1"
	. $script

	Start-Process explorer.exe -NoNewWindow

	wOk("¡Es necesario reiniciar!")

	Restart-AndContinue -checkpoint "Winok" -run ($PSScriptRoot + "\last.cmd")
	exit
}

if ($state -eq "Winok") {
	<#######################################
	# Ejecución de la segunda fase de Last #
	#######################################>

	# Datos de soporte
	wRun("Colocando datos de soporte")
	$script = $PSScriptRoot + "\supportData.ps1"
	. $script
	wOk("Datos de soporte listos")

	#Verificancion de conexión a internet
	wRun("Activando los adaptadores de red. Espera...")

	Enable-NetAdapter -Name * -Confirm:$false
	Start-Sleep -Seconds 15

	wRun("Realizando verificación de Internet...")
	$connected = Test-Connection "8.8.8.8" -Quiet -Count 4 -ErrorAction SilentlyContinue
	$continueWitouthInternet = $false
	$i = 1
	while (!$connected) {
		Start-Sleep 1
		if ($i -gt 1) {
			wInfo ("Intento de conexión " + $i)
			$connected = Test-Connection "8.8.8.8" -Quiet -Count 8 -ErrorAction SilentlyContinue
		}

		if (!$connected) {
			wInfo ("No se ha establecido una conexión a internet.`nVerifica la conexión, se reintetará de nuevo si presionas 'n'")
			$continueWitouthInternet = get-UserAnswer("¿Deseas continuar sin internet?")
		}

		if ($continueWitouthInternet) {
			$connected = $true
		} else {
			$i++
		}

		if ($i -gt 5) {
			wInfo("No se pudo establecer una conexión a internet. Continuarás sin realizar importantes actualizaciones.")
			Pause
			$connected = $true
		}
	}

	#Instalación de programas de internet
	if (-not $continueWitouthInternet) {
		#Programas que requiere internet para instalarse y/o ejecutarse
		wTitulo("Herramienta de activación de Windows")
		#Licencia y activación de Windows
		$script = $PSScriptRoot + "\Licensing.ps1"
		. $script

		#Instalación de navegadores
		wTitulo("Instalando navegadores")
		#Chrome
		wRun("Lanzando el instalador de Google Chrome...")
		$dest = ($PSScriptRoot + "\bin\ChromeSetup.exe")
		Start-Process -FilePath $dest
		Start-Job -Name "Adblock_Chrome" -ScriptBlock { Import-Module -DisableNameChecking ($args[0] + "\lib\pcb-win10_install_main_module.psm1"); Wait-ForAdblock -Process "chrome" -Name "Google Chrome" } -ArgumentList @($PSScriptroot) | Out-Null #| Receive-Job -Force -Wait #


		#Mozilla
		wRun("Lanzando el instalador de Mozilla Firefox...")
		$dest = ($PSScriptRoot + "\bin\Firefox Installer.exe")
		Start-Process -FilePath $dest
		Start-Job -Name "Adblock_Firefox" -ScriptBlock { Import-Module -DisableNameChecking ($args[0] + "\lib\pcb-win10_install_main_module.psm1"); Wait-ForAdblock -Process "firefox" -Name "Mozilla Firefox" } -ArgumentList @($PSScriptroot) | Out-Null #| Receive-Job -Force -Wait #


		#Opera
		wRun("Lanzando el instalador de Opera...")
		$dest = ($PSScriptRoot + "\bin\OperaSetup.exe")
		Start-Process -FilePath $dest -ArgumentList "/runimmediately /allusers=1 /setdefaultbrowser=0 /desktopshortcut=0 /pintotaskbar=0  /pin-additional-shortcuts=0 /import-browser-data=0 /launchbrowser=1"
		Start-Job -Name "Adblock_Opera" -ScriptBlock { Import-Module -DisableNameChecking ($args[0] + "\lib\pcb-win10_install_main_module.psm1"); Wait-ForAdblock -Process "opera" -Name "Opera" } -ArgumentList @($PSScriptroot)  | Out-Null # | Receive-Job -Force -Wait #

		$dest = ($PSScriptRoot + "\bin\OperaSetup.exe")

		wRun("Copiando archivos de preferencias")

		wRun ("Configurando Microsoft Edge")
		$app = get-dbAppData("Microsoft Edge")
		set-prefsFile(@{
				file = $app.appPrefsFileName
				path = Get-EnvPS($app.appPrefsFilePath)
				enc  = $app.appPrefsFileEnc
				data = $app.appPrefsFileData
			})

		Winfo("Configurando AnyDesk")

		$unnecesaryFiles = @(
			"$env:ProgramData\AnyDesk\ad_svc.trace",
			"$env:ProgramData\AnyDesk\service.conf",
			"$env:ProgramData\AnyDesk\system.conf",
			"$env:ProgramData\AnyDesk\user.conf",

			"$env:AppData\AnyDesk\ad_svc.trace",
			"$env:AppData\AnyDesk\service.conf",
			"$env:AppData\AnyDesk\system.conf",
			"$env:AppData\AnyDesk\user.conf"
		)

		foreach ($file in $unnecesaryFiles) {
			if (Test-Path -Path $file -PathType Leaf) {
				wInfo("Eliminando $file...")
				Remove-Item -Path $file -Force
			}
		}

		$app = get-dbAppData("AnyDesk")
		set-prefsFile(@{
				file = $app.appPrefsFileName
				path = Get-EnvPS($app.appPrefsFilePath)
				enc  = $app.appPrefsFileEnc
				data = $app.appPrefsFileData
			})

		wOk("AnyDesk Configurado!")

		wTitulo("Ejecutando aplicaciones que requieren procesos adicionales")
		#Pitstop
		#requiere ejecutar de nuevo el instalador de licencia y reiniciar el servicio FlexLM
		#Configuración de pitstiop 2022
		$path = "$env:SystemDrive\Esko"
		if (Test-Path -Path $path -PathType Container) {
			$destFilename = "licenses_e.dat"
			$destPath = "${env:SystemDrive}\Enfocus\bg_data_system_v010"
			$destFile = $destPath.trim("\") + "\" + $destFilename

			Get-OwnFolder($path) | Out-Null
			Get-OwnFolder($path) | Out-Null
			Get-OwnFolder($path) | Out-Null
			Get-OwnFolder($path) | Out-Null
			Get-OwnFolder($path) | Out-Null
			Get-OwnFolder($path) | Out-Null
			Get-OwnFolder($path) | Out-Null
			Set-FullAccess -Path ($path)
			Werror("Realice:")
			Write-Output "1. Vaya a la pestaña 'Handle license files'"
			Write-Output "2. Seleccione 'Remove the Barco based license file...'"
			Write-Output "3. Click en 'Execute'"
			Write-Output "4. Seleccione 'Remove the Esco based license file...'"
			Write-Output "5. Click en 'Execute'"
			Write-Output "6. Seleccione 'Load a new license'"
			Write-Output "7. Click en 'Execute' y agregue una nueva licencia"
			Write-Output "8. El archivo a utilizar se encuentra en $licFile (copiado al portapapeles)"
			Write-Output "9. Espere a que el servicio se reanude para salir!!"
			Set-Clipboard -Value "${destFile}"
			Get-Service | Where-Object -Property Name -iLike "*flex*" | Stop-Service -Force
			Start-Process "${env:systemDrive}\Esko\bg_prog_system_v010\bin_ix86\flexnet_lm_admin.exe"
		}

		Winfo(' Tenga en cuenta estos datos para configurar los navegadores:

Navegador Opera:
  "public"   -> Bloquear publicidad y navegar por la Web... -> ( ·) (Activado)
  "rastre"   -> Bloquear rastreadores -> ( ·) (Activado)
  "dar cada" -> Preguntar donde guardar cada archivo... -> ( ·) (Activado)
  "tar ac"   -> Ocultar Acceso Rápido
  "trar pri" -> Mostrar Primero la p;agina de inicio


Navegador Mozilla:
  "as ante"  -> [X]Abrir ventanas y pestañas anteriores
  "bar si"   -> [ ]Comprobar siempre si Firefox es su navegador predeterminado
  "a usa"    -> Oscuro
  "tar si"   -> [X]Preguntar siempre dónde guardar los archivos
  "si abri"  -> O Preguntar si abrir o guardar archivos
  "ando que" -> O Siempre
  Extensiones y temas -> temas -> Oscuro

Navegador Google Chrome:
  "de favo"  -> Mostrar barra de favoritos -> ( ·) (Activado)
  "dor pre"  -> haga de Google Chrome su navegador predet... -> [Elegir como predeteminado]
  "nuar la"  -> (O) Continuar la sesión desde donde la dejaste
  "tar ubi"  -> Preguntar ubicación antes de descargar ( ·) (Activado)
  "ir eje"   -> Seguir ejecutando aplicaciones en segundo plano... -> (· ) (Desctivado)
')

		wInfo("Abriendo navegadores. Continuará al cerrarlos todos...`nPuede demorar un poco el detectar que todos los Navegadores estén cerrados. Espere...")
		Start-Job -Name "Update_Powershell" -ScriptBlock { Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; Update-Module; Update-Help } | Out-Null
		while (((Get-Process).Name) -join '|' -cmatch ("chrome|firefox|opera|ChromeSetup|Firefox Installer|OperaSetup")) { Start-Sleep -s 1 }

	}

	wRun("Eliminando aplicaciones de inicio automatico después de instalación y actualización de programas")
	set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
	"Opera Browser Assistant"=-

	[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
	"Opera Browser Assistant"=-

	[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run]
	"Opera Browser Assistant"=-
	')
	Remove-Job -Name * -Force -ErrorAction SilentlyContinue

	wOk("Para continuar es necesario que ya no se esté realizando acción alguna.`nPorfavor presiona varias teclas hasta que continúe!")
	Pause
	Pause
	Pause
	wTitulo("Configurando Menú inicio y Barra de tareas")

	$script = $PSScriptRoot + "\unpinStartmenuTiles.ps1"
	. $script
	wOk("¡Es necesario reiniciar!")
	Restart-AndContinue -checkpoint "WinUpdated" -run ($PSScriptRoot + "\last.cmd")
}

if ($state -eq "WinUpdated") {

	<###################################
    # Ejecución de la fase de limpieza #
    ###################################>

	wInfo("Espera...")
	#Configuraciones adicionales requeridas para Windows 10
	wInfo("Configurando Fondo")
	WTitulo("Es necesario configurar 'Fondo' en 'Presentación'")
	Wait-For -Run "ms-settings:personalization-background" -ProcessName "systemSettings"
	Start-Sleep -Seconds 2
	wInfo("Configurando Asistente de concentración")
	WTitulo('Seleccionar "Solo Alarmas"')
	Wait-For -Run "ms-settings:quiethours" -ProcessName "systemSettings"

	Wtitulo("Ejecutando Aplicaciones y scripts para limpieza Final")

	###Agregar exclusiones a Windows defender
	wRun("Optimizando archivos en Windows Defender")
	@(
		"$env:windir\system32\drivers\etc\hosts",
		"$env:ProgramData\Online_KMS_Activation\Activate.cmd",
		"$env:ProgramFiles\Kodak\Preps 9\Preps\FLCL.dll",
		"$env:Windir\Oinstall.exe"
	) | ForEach-Object {
		if (Test-Path $_ -PathType Leaf) {
			Add-MpPreference -ExclusionPath $_
		}
	}

	wRun("Eliminando tareas programadas residuales")
	$SchudeledTasks = @(
		'Adobe Acrobat Update Task',
		'CCleaner Update',
		'klcp_update',
		'QueueReporting',
		'UpdateLibrary',
		'Show Registry Defrag Report on Administrador Logon',
		'UninstallSMB1ClientTask',
		'UninstallSMB1ServerTask',
		'Opera scheduled*'
	)

	foreach ($task in $SchudeledTasks) {
		Get-ScheduledTask -TaskName $task -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false
	}


	#Limpiando CorelDraw Folders Location (error al abrir corel)
	Set-Reg('-[HKEY_CURRENT_USER\SOFTWARE\Corel\CorelDRAW\24.0\Box Preferences\File Locations]
	[HKEY_CURRENT_USER\SOFTWARE\Corel\CorelDRAW\24.0\Box Preferences\File Locations]
	@=""

	[HKEY_CURRENT_USER\SOFTWARE\Corel\CorelDRAW\24.0\Draw\Application Preferences\Directories]
	"DrawDocsDir"=-
	"DrawStylesDir"=-
	"PrintDir"=-
	"TextImportDir"=-

	;Eliminación de datos para corel de 32-bits
	-[HKEY_CURRENT_USER\SOFTWARE\Corel\CorelDRAW\22.0\Box Preferences\File Locations]
	[HKEY_CURRENT_USER\SOFTWARE\Corel\CorelDRAW\22.0\Box Preferences\File Locations]
	@=""

	[HKEY_CURRENT_USER\SOFTWARE\Corel\CorelDRAW\22.0\Draw\Application Preferences\Directories]
	"DrawDocsDir"=-
	"DrawStylesDir"=-
	"PrintDir"=-
	"TextImportDir"=-
	')

	#eliminando rastro de PSexec
	Get-Process -Name *psexe* | Stop-Process -Force | Out-Null
	set-reg('-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PSEXESVC]')

	wRun("Limpiando Autoejecutables...")
	#Limpiando Carpetas de autoinicio
	Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
		"MicrosoftEdge*"=-
		"AdobeBridge"=-
		"Last"=-

		[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
		"Opera Browser Assistant"=-
		"Last"=-

	')
	wRun("Eliminando accesos directos no necesarios...")

	$links = @(
		'Access.lnk'
		'Excel.lnk',
		'OneNote.lnk',
		'Outlook.lnk',
		'PowerPoint.lnk',
		'Project.lnk',
		'Publisher.lnk',
		'Visio.lnk',
		'Word.lnk'
	)
	#eliminación de accesos directos de Office Web
	$path = get-EnvPS("%appdata%\Microsoft\Windows\Start Menu\Programs")
	foreach ($lnk in $links) {
		$filePath = $path + "\" + $lnk
		if (Test-Path -Path $filePath -PathType Leaf) {
			Remove-Item -Path $filePath -Force
		}
	}

	$links = @(
		'Microsoft Edge.lnk'
	)

	#eliminación de accesos directos no necesarios en el escritorio
	$path = get-EnvPS("%USERPROFILE%\Desktop")
	foreach ($lnk in $links) {
		$filePath = $path + "\" + $lnk
		if (Test-Path -Path $filePath -PathType Leaf) {
			Remove-Item -Path $filePath -Force
		}
	}

	$path = get-EnvPS("%Public%\Desktop")
	foreach ($lnk in $links) {
		$filePath = $path + "\" + $lnk
		if (Test-Path -Path $filePath -PathType Leaf) {
			Remove-Item -Path $filePath -Force
		}
	}

	wInfo("Eliminando impresoras no necesarias")
	Get-Printer | ForEach-Object {
		Remove-Printer -Name $_.Name
	}

	#Dism++
	Start-Job -Name "Dism++" -ScriptBlock { Import-Module -DisableNameChecking ($args[0] + "\lib\pcb-win10_install_main_module.psm1"); start-DbApp -appName "dism++" } -ArgumentList @($PSScriptroot) | Out-Null #| Receive-Job -Force -Wait #
	wInfo("Al cerrar Dism++ Continuará la configuración")
	Start-Sleep -s 5
	while (((Get-Process).Name) -join '|' -cmatch ("Dism")) { Start-Sleep -s 1 }

	Pause

	#requerido porque se cierra Dism++ y continua el script, pero se re ejecuta luego de aceptar los acuerdos de licencia
	while (((Get-Process).Name) -join '|' -cmatch ("Dism")) { Start-Sleep -s 1 }

	wRun("Limpiando con CCleaner. Espera...")
	$dest = get-ExecFileByArch -Path "${env:ProgramFiles}\CCleaner?\CCleaner?.exe"
	Start-Process -FilePath $dest -ArgumentList "/AUTO" -Wait

	#Eliminando Log de restauración
	(Get-Volume).DriveLetter | ForEach-Object {
		$file = $_ + ":\rescuepe.log"
		if (Test-Path -Path $file -PathType Leaf) {
			Remove-Item -Path $file -Force
		}
	}

	#elimminado archivos conocidos ya no necesarios
	@(
		"$env:windir\system32\sysprep\customize.xml"
	) | ForEach-Object {
		if (Test-Path -Path $_ -PathType Leaf -ErrorAction SilentlyContinue) {
			Remove-Item -Path $_ -Force
		}
	}

	#requerido porque se cierra Dism++ y continua el script, pero se re ejecuta luego de aceptar los acuerdos de licencia
	while (((Get-Process).Name) -join '|' -cmatch ("Dism")) { Start-Sleep -s 1 }

	#BleachBit Limpieza de archivos

	wOk("Limpieza desde BleachBit")

	$appData = get-dbAppData('bleachbit')

	if (!$x86 -and !$_.instFile_x64) {
		$appData.runFileAppPath = ($appData.runFileAppPath).Replace("ProgramFiles", "ProgramFiles(x86)")
	}

	$run = (Get-ExecFileByArch -Path ($appData.runFileAppPath + "?\" + $appData.runFileApp + "?") ).Replace(".exe", "_console.exe")
	. $run --preset -c

	wOk("Limpieza desde BleachBit terminada...")

	if ($x86) {
		$ProgramFilesRun = ${env:ProgramFiles}
	} else {
		$ProgramFilesRun = ${env:ProgramFiles(x86)}
	}

	wRun("Colocando la configuracion de 0&0 Shutup para configurar Windows")
	$file = ($PSScriptRoot + "\ooShutUp_W1021H2.cfg")
	Start-Process "$ProgramFilesRun\O&O ShutUp10\OOSU10.exe" -ArgumentList "/quiet", "$file" -Wait

	wOk("¡Es necesario reiniciar!")
	Restart-AndContinue -checkpoint "WinCleaned" -run ($PSScriptRoot + "\last.cmd")
}

if ($state -eq "WinCleaned") {
	$script = $PSScriptRoot + "\testfileExt.ps1"
	. $script

	#requerido porque se cierra Dism++ y continua el script, pero se re ejecuta luego de aceptar los acuerdos de licencia
	while (((Get-Process).Name) -join '|' -cmatch ("Dism")) { Start-Sleep -s 1 }


	if (Test-Path "${env:SystemDrive}\setup.txt" -PathType Leaf) {
		Remove-Item -Path "${env:SystemDrive}\setup.txt" -Force | Out-Null
	}

	wTitulo("Terminada la configuración final de Windows")

	#Eliminando datos de instalación y dejando datos de confiruación actual
	set-reg('[HKEY_LOCAL_MACHINE\SOFTWARE\PCBogota]
		"InstallState"=-
	')
	set-PcbReg -name "02-Installed Windows 10" -value ((Get-Date -Format "dd-MMM-yyyy HH:mm:ss").Replace(".", "").ToUpper())

	Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, InstallDate | Sort-Object -Property DisplayName | ForEach-Object {
		if ($_.DisplayName) {
			$name = "_" + $_.DisplayName + " v" + $_.DisplayVersion

			if ($_.InstallDate -match "^[0-9]") {
				$year = ($_.InstallDate).Substring(0, 4)
				$month = ($_.InstallDate).Substring(4, 2)
				$day = ($_.InstallDate).Substring(6, 2)
				$value = (Get-Date -Year $year -Month $month -Day $day -Format dd-MMM-yyyy).Replace(".", "").ToUpper()
				set-PcbReg -name $name -value $value
			}
		}
	}

	#eliminando ejecución automática del script
	Set-Reg('
    [HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
    "setup"=-
    "Last"=-
    [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
    "setup"=-
    "Last"=-
    ')

	#Habilitando la edicion rápida de Powershell (click derecho para pegar y otros)
	Set-Reg('[HKEY_USERS\.DEFAULT\Console]
		"QuickEdit"=dword:00000001

		[HKEY_CURRENT_USER\Console]
		"QuickEdit"=dword:00000001
	')

	foreach ($file in $LastSurplusfileList) {
		Remove-Item -Path $file -Force -ErrorAction SilentlyContinue
	}
	Remove-EmptyFolder(($PSScriptRoot))

	#requerido porque se cierra Dism++ y continua el script, pero se re ejecuta luego de aceptar los acuerdos de licencia
	while (((Get-Process).Name) -join '|' -cmatch ("Dism")) { Start-Sleep -s 1 }

	wRun("Creando un punto de restauración para $env:SystemDrive")
	#primero se elimnan todos los puntos de restauración
	Start-Process -FilePath "$env:Windir\system32\vssadmin" -ArgumentList "delete shadows /all /quiet" -NoNewWindow -Wait

	#Se crea el punto de restauración
	Checkpoint-Computer -Description "Primera Ejecución PCBogotá" -RestorePointType MODIFY_SETTINGS

	wOk("¡Terminado!. Igualmente es recomendable reiniciar por última vez")
	wInfo ("¡¡¡NO CIERRRES NINGUNA VENTANA!!!`n`nTerminado!`nPresiona tres teclas para terminar")

	Pause ("Asegurate de no tener ningun proceso o programa activo....")
	Pause (" ")
	Pause (" `n")

}
