$columns = @(
	'appCrkDestData',
	'appCrkDestDataVars',
	'appCrkDestFileEnc',
	'appCrkDestFileName',
	'appCrkDestPath',
	'appPrefsFileData',
	'appPrefsFileDataVars',
	'appPrefsFileEnc',
	'appPrefsFileName',
	'appPrefsFilePath',
	'instDir',
	'instFile_x64',
	'name',
	'regData',
	'regDataVars',
	'runFileApp',
	'runFileAppPath',
	'ver'
)

$omit = ""
#Estos programas no necesitan cambiar las variables de entorno en algunas columnas, ya que hace muy lento el proceso
$omitEnvVarsPrograms = @(
	"BleachBit",
	"cCleaner"
)
$omitEnvVarsPrograms = $omitEnvVarsPrograms -join ("|")

$data = get-dbquery("SELECT " + ($columns -Join (",")) + " FROM Programas WHERE appPrefsFilePath NOT LIKE '%NULL%' OR regData NOT LIKE '%NULL%' ORDER BY id ASC")

<#
Obtener el bojeto de los programas de la base de datos (Lo que esta en la variable $columns)
$data | ForEach-Object {
	$_.name
}
#>

$data | ForEach-Object {
	#Tratamiento especial para variables de entorno y variables que deben especificarse dependiendo de la arquitectura del sistema operativo y la aplicación
	$installData = $_
	$instOpen = $false
	$prefsFile = $false
	$crkFile = $false

	if (!$x86 -and !$installData.instFile_x64) {
		$installData | Get-Member -Type Properties | ForEach-Object {
			#Cambiar en todas las columnas de instalación la ruta de archivos de programa y common program
			#files a sus equivalentes si el instalador es x86 y se ejecuta en un SO x64
			$name = $_.name
			if ($installData.${name} -and ($installData.${name}).GetType().Name -ne "Boolean" -and ($installData.name -notmatch $omitEnvVarsPrograms)) {
				$installData.${name} = Get-EnvPS($installData.${name} -Replace ("%programfiles%", "%ProgramFiles(x86)%") -Replace ("%commonprogramfiles%", "%CommonProgramFiles(x86)%"))
			} elseif ($installData.${name} -and ($installData.${name}).GetType().Name -ne "Boolean") {
				$installData.runFileAppPath = Get-EnvPS($installData.runFileAppPath -Replace ("%programfiles%", "%ProgramFiles(x86)%") -Replace ("%commonprogramfiles%", "%CommonProgramFiles(x86)%"))
				$installData.appPrefsFilePath = Get-EnvPS($installData.appPrefsFilePath -Replace ("%programfiles%", "%ProgramFiles(x86)%") -Replace ("%commonprogramfiles%", "%CommonProgramFiles(x86)%"))
				$installData.appCrkDestPath = Get-EnvPS($installData.appCrkDestPath -Replace ("%programfiles%", "%ProgramFiles(x86)%") -Replace ("%commonprogramfiles%", "%CommonProgramFiles(x86)%"))
			}
		}
	}

	#cambiar las variables desde columna espcífica para ello
	@(
		'regData', #'regDataVars'
		'appPrefsFileData', #"appPrefsFileDataVars"
		'appCrkDestData' #"appCrkDestDataVars"
	) | ForEach-Object {
		$replace = $_
		$vars = $_ + "vars"
		if ($installData.${replace} -and $installData.${vars}) {
			$installData.${replace} = Set-PassedVar -vars $installData.${vars} -replace $installData.${replace}
		}
	}

	#Asignación de variables de entorno en las columnas de rutas de archivo
	$columnsWithEnv = @(
		'regdata',
		'runFileAppPath',
		'appPrefsFilePath'
		'appCrkDestPath'
	)
	if ($installData.name -notmatch $omitEnvVarsPrograms) {
		$columnsWithEnv += @(
			'appPrefsFileData',
			'appCrkDestData'
		)
	}

	$columnsWithEnv | ForEach-Object {
		$installData.$_ = Get-EnvPS($installData.$_)
	}
	#Encontrar la ruta y archivo ejecutable correctos segun la arquitectura de Windows (x86/x64)
	if ($installData.runFileAppPath -and $installData.runFileApp) {
		$instOpen = $installData.runFileAppPath + "\" + $installData.runFileApp
		if ($instOpen -match "\?") {
			$instOpen = Get-ExecFileByArch($instOpen)
			$installData.runFileAppPath = Split-Path -Path $instOpen -Parent
			$installData.runFileApp = Split-Path -Path $instOpen -Leaf
		}
	}

	#Encontrar la ruta y archivo de preferencias correctos segun la arquitectura de Windows (x86/x64)
	if ($installData.appPrefsFilePath -and $installData.appPrefsFileName) {
		$prefsFile = $installData.appPrefsFilePath + "\" + $installData.appPrefsFileName
		if ($prefsFile -match "\?") {
			$prefsFile = Get-ExecFileByArch($prefsFile)
			$installData.appPrefsFilePath = Split-Path -Path $prefsFile -Parent
			$installData.appPrefsFileName = Split-Path -Path $prefsFile -Leaf

		}
	}
	if ($installData.appCrkDestPath -and $installData.appCrkDestFileName) {
		#Encontrar la ruta y archivo de activación correctos segun la arquitectura de Windows (x86/x64)
		$crkFile = $installData.appCrkDestPath + "\" + $installData.appCrkDestFileName
		if ($crkFile -match "\?") {
			$crkFile = Get-ExecFileByArch($crkFile)
			$installData.appCrkDestPath = Split-Path -Path $crkFile -Parent
			$installData.appCrkDestFileName = Split-Path -Path $crkFile -Leaf
		}
	}

	if (Test-Path -Path $instOpen -PathType Leaf) {
		if ($installData.name -ilike "*powertoys*") {
			#return #Hace lo mismo que 'continue' pero para foreach-object no continúa, cierra, mientras que return
			#por si algún motivo llegan a presentarse más arreglos como este más adelante, es preferible usar else
		} else {

			wRun("Colocando preferencias de " + $installData.name + " v" + $installData.ver + "...")

			#Verificar que existan datos para registro de Windows
			if ($installData.RegData) {
				Set-Reg($installData.RegData)
			}

			#Verificar que existan datos para archivo de preferencias
			if ($installData.appPrefsFileData) {
				#Generación del archivo de preferencias u opciones de la aplicación
				Set-PrefsFile(@{
						file = $installData.appPrefsFileName
						path = $installData.appPrefsFilePath
						enc  = $installData.appPrefsFileEnc
						data = $installData.appPrefsFileData
					})
			}

			#Verificar que existan datos para activación de programas
			if ($installData.appCrkDestData) {
				#Generación del archivo de preferencias u opciones de la aplicación
				set-prefsFile(@{
						file = $installData.appCrkDestFileName
						path = $installData.appCrkDestPath
						enc  = $installData.appCrkDestFileEnc
						data = $installData.appCrkDestData
					})
			}
		}
	} else {
		$omit += "`n(Omitido) " + $installData.name
	}
}

########################
# Apartados especiales #
########################

#Anydesk Creando el acceso directo al escritorio de Windows
if (Test-Path -Path ("$env:ProgramFiles\Anydesk\AnyDesk.exe")) {
	New-link -dest ("%ProgramData%\Microsoft\Windows\Start Menu\Programs") -name "AnyDesk" -source ("%ProgramFiles%\Anydesk\AnyDesk.exe") -Admin
	New-link -dest ("${env:Public}\Desktop") -name "AnyDesk" -source ("%ProgramFiles%\Anydesk\AnyDesk.exe") -Admin
}

#powertoys tiene sus preferencias en el archivo pts.dll
$ptData = $data | Where-Object -Property "name" -Like "powertoys"
$ptZipFileOriginal = "${PSScriptRoot}\bin\pts.dll"
$ptZipFile = $ptZipFileOriginal -replace (".dll", ".zip")
Rename-Item $ptZipFileOriginal -NewName $ptZipFile
$ptRunFile = $ptData.runFileAppPath.trim("\") + "\" + $ptData.runFileApp.trim("\")
if ((Test-Path -Path $ptZipFile) -and (Test-Path -Path $ptRunFile)) {
	wRun("Colocando preferencias de " + $ptData.name + " v" + $ptData.ver + "...")
	Expand-Archive -Path $ptZipFile -DestinationPath $ptData.appPrefsFilePath -Force
	Remove-Item -Path "$env:USERPROFILE\Documents\powertoys" -Recurse -Include * -Force -ErrorAction SilentlyContinue
} else {
	$omit += "(Omitido) " + $ptData.name + "`n"
}
Rename-Item $ptZipFile -NewName $ptZipFileOriginal

if ($omit -ne "") {
	wError("Aplicaciones omitidas:`n`n$omit")
}

#Colocar acceso completo a la carpeta de Esko para que pitstop 2022 funcione correctamente
$path = "$env:SystemDrive\Esko"
if (Test-Path $path) {
	Get-OwnFolder($path) | Out-Null
	Get-OwnFolder($path) | Out-Null
	Get-OwnFolder($path) | Out-Null
	Get-OwnFolder($path) | Out-Null
	Get-OwnFolder($path) | Out-Null
	Get-OwnFolder($path) | Out-Null
	Get-OwnFolder($path) | Out-Null
	Set-FullAccess -Path ($path)
}
