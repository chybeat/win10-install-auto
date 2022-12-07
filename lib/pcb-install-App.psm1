function install-App {
	param(
		[CmdletBinding()]
		[Parameter(Mandatory)]
		[object]
		$installData
	)process {
		<#
	El objeto que se envia debe obtener los siguientes parametros
	id                   = id indetificador unico de la aplicación
	name                 = el nombre
	ver                  = version
	web                  = pagina web o de descarga
	comments             = comentarios
	isoFile              = nombre de archivo iso
	isoSrcPath           = la ruta y nombre del archivo iso
	instSrcPath          = ruta del archivo de instalacion (no el nombre del archivo)
	instFile_x86         = nombre del archivo de instalacion para sistemas de 32-bit
	InstFile_x64         = nombre del archivo de instalacion para sistemas de 64-bit
	InstArgs             = argumentos para instalación silenciosa. Si requiere archivo de preferencias se debe guardar el texto %prefsFile% en el argumento que lee el archivo
	instInfFileEnc       = codificacion requerida para el archivo de información para la instalación
	InstInfFileData      = datos del archivo de información para la instalación de una app (se debe alojar en una ubicacion temporal)
	InstInfFileDataVars  = Varibales para cambiar en los datos del archivo de información para la instalación de una app (se debe alojar en una ubicacion temporal)
	instDir              = ruta de instalación final
	regData              = datos para almacenar en el registro de windows
	regDataVars          = Varibales para cambiar en los datos para almacenar en el registro de windows
	commRunAfterInst     = comando que se debe ejecutar luego de la instalación
	commRunBeforeOpen    = comando a ejecutar antes abrirla app automáticamente
	runFileApp           = nombre del archivo para abrir
	runFileAppPath       = ruta para abrir la app
	openApp              = si debe o no abrir luego finalizada la instalación
	waitForApp           = si debe o no esperar a que se cierre una app luego de la instalación
	appPrefsFilePath     = la ruta donde se guarda el archivo de preferencias
	appPrefsFileName     = el nombre del archivo de preferencias
	appPrefsFileEnc      = la codificacion del archivo de preferencias
	appPrefsFileData     = los datos del archivo de preferencias
	appPrefsFileDataVars = variables para cambiar en los datos del archivo de preferencias
	appCrkSrc            = ruta donde se encuentra el archivo de crack
	appCrkDestPath       = ruta de destino donde se coloca el archivo de crack
	appCrkDestFileName   = nombre de archivo de destino para el crack
	appCrkDestFileEnc    = los datos del archivo de crack
	appCrkDestData       = datos del archivo de crack
	appCrkDestData       = variables para cambiar en datos del archivo de crack
	freeSoft             = Booleano que denota si es software libre de uso libre
	#>
		$isofile = $false

		#Si la instalación propuesta es software libre se omitirá en caso que desde la DB se indique que no es software libre
		if ($global:freesoft -and !$installData.freeSoft) {
			wRun(">> " + $installData.Name + "no se instalará por no ser Software Libre")
			return
		}

		#Verificación que exista un nombre de aplicacion (Por si se pasa un dato incorrecto o nulo)
		if (!$installData.name -or $installData.name -eq "") {
			wError("No es posible continuar con la instalación. No se encuetra el nombre del programa")
			Pause
			exit
		}

		wTitulo("Instalación de " + $installData.name + " " + $installData.ver)
		#Verificación de un archivo iso en caso de ser especificado
		if ($installData.isoFile) {
			if ($null -eq $installData.isoSrcPath) {
				wError("Es imposible continuar sin la ruta en la que se encuentra el archivo ISO de " + $installData.name + "`nSolo está el nombre del archivo: " + $installData.isoFile)
				Pause
				exit
			}
			$isoFile = $installData.isoSrcPath.Trim("\") + "\" + $installData.isoFile.Trim("\")
			if (-not (Test-Path -Path $isoFile -PathType Leaf)) {
				$fileName = $installData.isoSrcPath.Trim('\') + "\" + $installData.isoFile.Trim('\')
				$path = Get-Path -Filename $fileName -Limit 1 -Force
				if (!$path -or ($null -eq $path) -or ($path -eq "")) {
					wError("No se encuentra el archivo ISO '" + $installData.isoFile + "' en la ruta: " + $installData.isoSrcPath)
					Pause
					exit
				}
				$installData.isoSrcPath = $path
				$isoFile = $installData.isoSrcPath.Trim("\") + "\" + $installData.isoFile.Trim("\")
			}

			#variable $isfoFile que se utiliza para montar y desmontar la imagen ISO

			#al existir una imagen iso es altamente posible que la ruta de instalación del archivo cambie,
			#este apartado deja la ruta de instalación corregida a la imagen ISO ya montada en el objeto
			#pasado a la función
			$instSrcDrive = Mount-Iso -IsoPath $IsoFile
			$installData.instSrcPath = $instSrcDrive.trim("\") + "\" + (Split-Path $installData.instSrcPath -NoQualifier).trim("\")
		}

		#verificación que almenos se haya pasado un archivo de instalación
		if (!$installData.instFile_x86 -and !$installData.instFile_x64) {
			wError($installData.name + " no se puede instalar ya que no se pasó información del instalador alguno ni x86 ni x64 ")
			Pause
			exit
		}

		#verificación de la ruta de origen del archivo de instalación
		if (-not (Test-Path -Path $installData.instSrcPath -PathType Container)) {
			#Si no existe la ruta de instalación se necesita un archivo para realizar la
			#busqueda de la ruta, se tomará $installData.instFile_x86 y en caso de ser
			#nulo se tomará $installData.instFile_x64 como referencia
			if ($installData.instFile_x86) {
				$filename = $installData.instFile_x86
			} elseif ($installData.instFile_x64) {
				$filename = $installData.instFile_x64
			} else {
				wError("ERROR GRAVE: No se especificó un archivo de instalación x86 ni x64, ni la ruta de la carpeta donde se localiza en archivo de instalación!")
				Pause
				exit
			}
			$path = Get-Path -Filename $filename -Path $installData.instSrcPath -Limit 1 -Force
			if (!$path -or $path -eq '', $null -eq $path) {
				wError("La ruta de instalación " + $installData.instSrcPath + " no existe y no se puedo hallar el archivo " + $filename + ". Verifica los datos!")
				Pause
				exit
			}
			$installData.instSrcPath = $path
		}

		#verificación del origen para el archivo de activación
		if ($installData.appCrkSrc) {
			$path = Get-Path -Filename $installData.appCrkSrc -Limit 1 -Force
			if (!$path -or $path -eq '', $null -eq $path) {
				wError("No se encuentra el archivo de activación '" + $installData.appCrkSrc + "'")
				Pause
				exit
			}
			$installData.appCrkSrc = $path + "\" + $fileName
		}

		#Verificación de arquitectura del archivo de instalación
		if ($x86) {
			if (!$installData.instFile_x86) {
				wError($installData.name + " no se puede instalar ya que su sistema es de 32-bit y no hay un instalador x86")
				Pause
				return
			}
			$installerFile = $installData.instSrcPath.Trim("\") + "\" + $installData.instFile_x86
		} elseif (!$installData.instFile_x64 -and !$installData.instFile_x86) {
			wError($installData.name + " no se puede instalar ya que su sistema es de 64-bit y no se ha especificado un archivo instalador x86 o x64")
			Pause
			exit
		} else {
			if (!$installData.instFile_x64) {
				$installerFile = $installData.instSrcPath.Trim("\") + "\" + $installData.instFile_x86
			} else {
				$installerFile = $installData.instSrcPath.Trim("\") + "\" + $installData.instFile_x64
			}
		}

		#Verificación que exista el archivo de instalación
		if (!(Test-Path -Path $installerFile -PathType Leaf)) {
			$result = Get-Path -Filename $installerFile -Force -Full
			if (!$result) {
				wError($installerFile + " no se ha encontrado. Se debe verificar el nombre del archivo de instalación")
				Pause
				exit
			} else {
				$installData.instSrcPath = Split-Path -Path $result -Parent
				$installerFile = $result
			}
		}

		#Verificación de las variables de entorno dependiendo de la arquitectura del instalador
		if (!$x86 -and !$installData.instFile_x64) {
			$installData | Get-Member -Type Properties | ForEach-Object {
				#Cambiar en todas las columnas de instalación la ruta de archivos de programa y common program
				#files a sus equivalentes si el instalador es x86 y se ejecuta en un SO x64
				$name = $_.name
				if ($installData.${name} -and ($installData.${name}).GetType().Name -ne "Boolean") {
					$installData.${name} = Get-EnvPS($installData.${name} -Replace ("%programfiles%", "%ProgramFiles(x86)%") -Replace ("%commonprogramfiles%", "%CommonProgramFiles(x86)%"))
				}
			}
		}

		#Columnas que puede llegar a tener un cambio de datos variables
		@(
			'instInfFileData', #'instInfFileDataVars'
			'regData', #'regDataVars'
			'appPrefsFileData', #"appPrefsFileDataVars"
			'appCrkDestData' #'appCrkDestDataVars'
		) | ForEach-Object {
			$replace = $_
			$vars = $_ + "vars"
			if ($installData.${replace} -and $installData.${vars}) {
				$installData.${replace} = Set-PassedVar -vars $installData.${vars} -replace $installData.${replace}
			}
		}

		#Asignación de variables de entorno en las siguientes columnas:
		@(
			'InstArgs',
			'InstInfFileData',
			'appCrkDestPath',
			'appPrefsFilePath',
			'commRunAfterInst',
			'commRunBeforeOpen',
			'instDir',
			'regData'
			'runFileAppPath'
		) | ForEach-Object {
			if ($installData.${_}) {
				$installData.${_} = Get-EnvPS($installData.${_})
			}
		}

		#Generación de archivo de preferencias de instalacion
		if ($installData.InstInfFileData) {
			wRun("Generando archivo de preferencias de instalación")
			$pattern = '[^a-zA-Z0-9]'
			$prefsFileName = (($installData.name) -replace $pattern, "_") + "_inst.inf"
			$pathPrefsFileName = (Split-Path $PSScriptRoot -Qualifier) + "\"
			Set-PrefsFile(@{
					File = $prefsFileName
					Path = $pathPrefsFileName
					Enc  = $installData.instInfFileEnc
					Data = $installData.instInfFileData
				})

			#generación de variable para de la ruta del archivo de preferencias de instalación
			$destInfFile = $pathPrefsFileName + $prefsFileName
			wOk("Se ha generado el archivo de preferencias de instalación ")
			$installData.InstArgs = ($installData.InstArgs).replace("%prefsFile%", $destInfFile)
		}

		#Visualización de los comentarios de la instalación
		if ($installData.comments) {
			wError ("Recuerde:")
			Write-Output $installData.comments
			Write-Host "`n`n"
		}

		#Correcion del archivo de instalacion por posible doble '\\'
		$installerFile = ($installerFile).Replace("\\", "\")

		#Ejecución del programa de instalación
		wRun("Ejecutando el instalador de " + $installData.name)
		if (($installerFile).EndsWith("ps1")) {

			$installData.InstArgs = "-Command & ${installerFile} " + $installData.InstArgs
			Wait-Process -Id (Start-Process powershell -PassThru -ArgumentList $installData.InstArgs).id
		} elseif ($installData.InstArgs) {
			Wait-Process -Id (Start-Process $installerFile -PassThru -ArgumentList $installData.InstArgs).id
		} else {
			Wait-Process -Id (Start-Process $installerFile -PassThru).id
		}

		#Ejecución del comando para despues de la instalación
		if ($installData.commRunAfterInst) {
			wRun("Ejecutando '" + $installData.commRunAfterInst + "' después de la instalación")
			$afterInst = "& cmd /c start /wait " + $installData.commRunAfterInst
			Invoke-Expression $afterInst
		}

		#Agregando datos de registro
		if ($installData.regData) {
			Start-Sleep -s 2
			wRun("Ingresando datos para el registro")
			Set-Reg($installData.regData)
		}

		#Generación del archivo de preferencias u opciones de la aplicación
		if ($installData.appPrefsFileName) {
			if ($installData.appPrefsFileData) {
			} elseif (!$installData.appPrefsFileData -and $installData.appPrefsFileData) {
				$installData.appPrefsFileName
			}
			wRun("Copiando archivo de preferencias de " + $installData.name)
			Set-PrefsFile(@{
					file = $installData.appPrefsFileName
					path = $installData.appPrefsFilePath
					enc  = $installData.appPrefsFileEnc
					data = $installData.appPrefsFileData
				})
		}
		#Generación o copia del archivo de activación (Crack)
		if ($installData.appCrkDestData -or $installData.appCrkSrc) {
			wRun("Copiando datos de activación")
			$destCrk = $installData.appCrkDestPath.trim("\") + "\" + $installData.appCrkDestFileName
			#Si el crack tiene una fuente se copia el archivo,
			if ($installData.appCrkSrc) {
				if (Test-Path -Path $destCrk -PathType Leaf) {
					Rename-Item $destCrk -NewName ($installData.CrkDestFileName + ".bak") -Force
				}
				Copy-Item -Path $installData.appCrkSrc -Destination $destCrk -Force
			} elseif ($installData.appCrkDestData) {
				#Si existen datos appCrkDestData la activación se genera por medio de un archivo
				Set-PrefsFile(@{
						file = $installData.appCrkDestFileName
						path = $installData.appCrkDestPath
						enc  = $installData.appCrkDestFileEnc
						data = $installData.appCrkDestData
					})
			}
		}
		#ejecución (y espera en caso tal) de la aplicación ya instalada
		if ($installData.openApp) {
			#ejecución de un comando antes de abrir la app
			if ($installData.commRunBeforeOpen) {
				wRun("Ejecutando '" + $installData.commRunBeforeOpen + "' antes de abrir " + $installData.name)
				$beforeOpen = "& " + $installData.commRunBeforeOpen
				Invoke-Expression $beforeOpen
			}

			$instOpen = ($installData.RunFileAppPath + '\' + $installData.RunFileApp)
			if ($instOpen -match "\?") {
				$instOpen = Get-ExecFileByArch($instOpen)
			}

			if ($installData.waitForApp) {
				#Verificación de si se debe o no esperar al cierre de la ejecución
				wRun("Ejecutando y esperando a que cierre " + $installData.name)
				Start-Process -FilePath $instOpen -Wait
			} else {
				wInfo("Abriendo " + $installData.name + " (La ejecucón del script continúa) ")
				Start-Process -FilePath $instOpen
			}
		}

		#Limpieza y restauración de los archivos y unidades temporales utilizadas
		#Eliminación del archivo de información de instalación
		if ($installData.InstInfFileData) {
			wInfo("Eliminando el archivo de preferencias de instalación")
			Remove-Item -Path $destInfFile -Force
		}

		#Desmonte de la unidad utilizada por la imagen ISO
		if ($isoFile) {
			wInfo("Desmontando Imagen ISO")
			Dismount-DiskImage -InformationAction:Ignore -ImagePath $isofile | Out-Null
		}

		wOk("Terminada la instalación de " + $installData.name)
	}
}
