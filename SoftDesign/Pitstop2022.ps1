<#Enfocus PitStop Pro 22 Build 1248659
==========================#>

#Verificar version de instalación pitsop
if ($x64 -and (Test-Path -Path (${env:ProgramFiles} + "\Adobe\Acrobat DC\Acrobat"))) {
	$app = "Enfocus Pitstop Pro 2022"
} elseif ($x64 -and (Test-Path -Path (${env:ProgramFiles(x86)} + "\Adobe\Acrobat DC\Acrobat"))) {
	$app = "Enfocus Pitstop Pro 2021"
} elseif ($x86 -and (Test-Path -Path (${env:ProgramFiles} + "\Adobe\Acrobat DC\Acrobat"))) {
	$app = "Enfocus Pitstop Pro 2021"
} else {
	wError("No se ha encontrado adobe Acrobat para poder instalar PitStop!")
	Pause
	Exit
}

if ($app -eq "Enfocus Pitstop Pro 2021") {
	$script = $PSSCriptRoot + "\Pitstop2021.ps1"
	. $script
} else {
	#Generar primero archivo de isntalación para installShield
	# .\Enfocus_PP_22_64bit.exe -r -f1D:\setup_ps.iss
	# .\"Esko Network License Manager 22.07.exe" -r -f1D:\setup_enlm.iss
	# .\Enfocus_PWM_22.exe -r -f1D:\setup_pwm.iss

	#Instalación de PitStop 2022
	#Eliminación de reglas del firewall de Acrobat requerida para acrobat x64

	#Get-NetFirewallRule | Where-Object -Property "DisplayName" -ilike "*acrobat.exe*out*" | Remove-NetFirewallRule

	# 1. Install Enfocus_PP_22_64bit.exe replace PitStop Pro.dll extract ps.zip file to C:\Program Files\Adobe\Acrobat DC\Acrobat\plug_ins\Enfocus\PitStop Pro Resources and rewrite

	$app = get-dbAppData($app)
	Install-app($app)

	#Activación de PitStop
	$destFilename = "PitStop Pro.dll"
	$destPath = (get-envPS($app.instDir)) + "\PitStop Pro Resources"
	$destFile = $destPath.trim("\") + "\" + $destFilename
	$zipFile = $app.instSrcPath + "\ps.zip"

	if (Test-Path -LiteralPath $destFile -PathType Leaf ) {
		Rename-Item -LiteralPath $destFile -NewName ($destFilename + ".bak") -ErrorAction SilentlyContinue
	}
	Expand-Archive -Path $zipFile -DestinationPath $destPath -Force

	#blocking exe files in firewall
	@(
		"${env:ProgramFiles}\Adobe\Acrobat DC\Acrobat\plug_ins\Enfocus"
		"${env:ProgramFiles}\enfocus"
	) | ForEach-Object {
		Block-InFirewall -Path $_ -Extension "exe"
	}


	#Instalación de Esko Network License Manager
	# 2. Install Esko Network License Manager 21.11 stop FlexNet Licensing Service, replace esko.exe from ek.zip

	$EskoDestFileName = "esko.exe"
	$EskoDestPath = "C:\Esko\bg_prog_system_v010\bin_ix86"
	$services = "*Flexnet*"
	$app.name = "Esko Network License Manager"
	$app.ver = "22.07"
	$app.instFile_x64 = "Esko Network License Manager 22.07.exe"
	$app.InstInfFileData = $ENSLPrefsFile
	$app.instDir = $EskoDestPath
	$app.runFileApp = $EskoDestFileName
	$app.InstArgs = ""
	$app.appPrefsFileData = ""
	$app.appPrefsFileDataVars = ""
	Install-app($app)
	Start-Sleep -s 5

	get-OwnFolder ("${env:SystemDrive}\Esko")
	Set-FullAccess ("${env:SystemDrive}\Esko")

	#stoping flexnet Services
	wRun("Deteniendo servicios de Flexnet...")
	Get-Service | Where-Object -Property Name -iLike $services | Stop-Service -Force

	#copying ekco.exe
	wInfo("Activando " + $app.name)
	$destFile = (get-envPS($app.instDir)) + "\" + $EskoDestFileName
	$zipFile = $app.instSrcPath + "\ek.zip"
	if (Test-Path -LiteralPath $destFile -PathType Leaf ) {
		Rename-Item -LiteralPath $destFile -NewName ($EskoDestFileName + ".bak") -ErrorAction SilentlyContinue
	}
	Expand-Archive -Path $zipFile -DestinationPath (get-envPS($app.instDir)) -Force

	#Instalación Pitstop Workgroup Manager
	# 3. Install Enfocus_PWM_22.exe skip update NLM (It has older version), first run PitStopWorkgroupManager.exe give access to the network

	$app.name = "Pitstop Workgroup Manager"
	$app.ver = "22"
	$app.comments = "No sobreescriba la versión del programa cuando se le pregunte"
	$app.instFile_x64 = "Enfocus_PWM_22.exe"
	$app.InstInfFileData = $ENSLPrefsFile
	$app.instDir = "C:\Program Files\Enfocus\Enfocus PitStop Workgroup Manager 22"
	$app.runFileApp = "PitStopWorkgroupManager.exe"
	Install-app($app)

	#Wait-For -Run ($app.instDir + "\" + $app.runFileApp)

	# 4. copy replace file licenses_e.dat in default directory C:\Esko\bg_data_system_v010\
	wRun("Activando  " + $app.name)

	$destFilename = "licenses_e.dat"
	$destPath = "${env:SystemDrive}\Enfocus\bg_data_system_v010"
	$destFile = $destPath.trim("\") + "\" + $destFilename
	$zipFile = $app.instSrcPath + "\lic.zip"

	if (Test-Path -LiteralPath $destFile -PathType Leaf ) {
		Rename-Item -LiteralPath $destFile -NewName ($destFilename + ".bak") -ErrorAction SilentlyContinue
	}
	Expand-Archive -Path $zipFile -DestinationPath $destPath -Force

	wRun("Activando el firewall de " + $app.name)
	New-NetFirewallRule -DisplayName ($app.name + " Inbound") -Name ($app.name + " Inbound") -Program ($app.instDir + "\" + $app.runFileApp) -Description ($app.name + " Inbound") -Profile public, private, domain, any -Protocol any -Action Allow -Direction Inbound | Out-Null

	New-NetFirewallRule -DisplayName ($app.name + " Outbound") -Name ($app.name + " Outbound") -Program ($app.instDir + "\" + $app.runFileApp) -Description ($app.name + " Outbound") -Profile public, private, domain, any -Protocol any -Action Allow -Direction Outbound | Out-Null

	wRun("Deteniendo serivicios de Flexnet")
	Get-Service | Where-Object -Property Name -iLike "*flex*" | Stop-Service -Force

	# 5. Run flexnet_cl_config.exe in directory C:\Esko\bg_prog_system_v010\bin_ix86\ set any Computer name of the License Server, click apply, exit
	wRun("Configurando el servidor...")

	#Wait-For -run ("${env:systemDrive}\Esko\bg_prog_system_v010\bin_ix86\flexnet_cl_config.exe")
	set-Reg(
		'[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment]
		"LM_LICENSE_FILE"="@COMPUTER"'
	)

	# 6. Run flexnet_lm_admin.exe in the same directory, make sure that stopped FLEXlm LM FLEXnet LS sservices, in the tab: Handle license files select Load a new license file C:\Enfocus\bg_data_system_v010\licenses_e.dat
	Werror("Relice:")
	Winfo("1. Pase a la pestaña `"Handle license files`"
2. Click en `"Load new license file`"
3. Click en `"Execute`"
4. Cargue la licencia desde ${destFile} (copiado al portapales)
5. Espere a que el servicio se reanude para salir!!
")

	Set-Clipboard -Value "${destFile}"
	Get-Service | Where-Object -Property Name -iLike "*flex*" | Stop-Service -Force
	Wait-For -Run "${env:systemDrive}\Esko\bg_prog_system_v010\bin_ix86\flexnet_lm_admin.exe"

	# 7. Run FlexNet Licensing Service
	wRun("Deteniendo servicios de Flexnet")

	Get-Service | Where-Object -Property Name -iLike "*flex*" | Start-Service
	Start-Sleep -s 5

	# 8. Open Acrobat, Alt+Ctrl+K => Licensing => Select Server, everything else by default
	# Licensing = Renuncia
	wRun("Abriendo Acrobat...")
	wInfo("Acrobat necesita reconocer pitstop, se abrirá y cerrará Acrobat. Espere..")
	$acrobat = Get-dbAppData('Acrobat DC')
	$acrobatRunFile = ((get-envPS($acrobat.runFileAppPath.trim("\"))) + "\" + $acrobat.runFileApp)
	Start-Process -FilePath $acrobatRunFile -WindowStyle Minimized
	Start-Sleep -s 5
	Get-Process | Where-Object -Property ProcessName -iLike "*acrobat*" | Stop-Process -Force
	Start-Process -FilePath $acrobatRunFile -WindowStyle Minimized
	Start-Sleep -s 3
	Get-Process | Where-Object -Property ProcessName -iLike "*acrobat*" | Stop-Process -Force

	Werror("Relice:")
	Winfo("1.  Presione Alt+Ctrl+K
2. Vaya a Renuncia y en dirección de servidor coloque localhost (copiado al portapapeles)
")
	Set-Clipboard -Value "localhost"
	Wait-For -run $acrobatRunFile

	wTitulo("Iniciando limpieza de Pitstop")
	Wrun("Deteniendo procesos de enfocus...")
	while (Get-Process | Where-Object -Property ProcessName -iLike "*enfocus*") {
		Get-Process | Where-Object -Property ProcessName -iLike "*enfocus*" | Stop-Process -Force
		Start-Sleep -s 5
	}
	Get-Process | Where-Object -Property ProcessName -iLike "*enfocus*" | Stop-Process -Force
	Wrun("Eliminando archivos inecesarios")
	$file = (Split-Path $PSScriptroot -Qualifier) + "\setup.log"
	if (Test-Path $file) {
		Remove-Item $file -Force
	}
	Wrun("Eliminando datos del registro de Windows")

	Set-Reg('
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Enfocus Subscription Notifier"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run]
"Enfocus Subscription Notifier"=-

')
}
