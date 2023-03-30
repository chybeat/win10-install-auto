#######################################
# Variables globales para este modulo #
#######################################

# teclas que se ignoran en Pause y Get-UserAnswer
$global:keyboardPressIgnores = (
	16, # Shift (left or right)
	17, # Ctrl (left or right)
	18, # Alt (left or right)
	20, # Caps lock
	91, # Windows key (left)
	92, # Windows key (right)
	93, # Menu key
	144, # Num lock
	145, # Scroll lock
	166, # Back
	167, # Forward
	168, # Refresh
	169, # Stop
	170, # Search
	171, # Favorites
	172, # Start/Home
	173, # Mute
	174, # Volume Down
	175, # Volume Up
	176, # Next Track
	177, # Previous Track
	178, # Stop Media
	179, # Play
	180, # Mail
	181, # Select Media
	182, # Application 1
	183  # Application 2
)

###################################
# Funciones para modulos externos #
###################################

function Register-Libraries {
	<#
	.SYNOPSIS
		Registrar librerias para uso en un script

	.DESCRIPTION
		Registrar librerias para uso en un script, Su ubucación debe ser la misma en la que se encuentra este archivo de modulo

	.PARAMETER Libs
		Un arreglo listando las librerías que se quieren agregar.
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[array]
		$Libs
	)
	process {
		foreach ($lib in $Libs) {
			$libName = [io.path]::GetFileNameWithoutExtension($lib)
			if ((Get-Module -Name $libName).ModuleType -eq "Script") {
				Unregister-Libraries(@($lib))
			}
			if (Test-Path -Path "$PSScriptRoot\$lib" -PathType Leaf -ErrorAction SilentlyContinue) {
				Import-Module -DisableNameChecking "$PSScriptRoot\$lib" -Global -Force
				Write-Host "Libreria ${lib} cargada"
			} else {
				$Text = "No se encotró el archivo ${lib}."
				Write-Host -ForegroundColor red -BackgroundColor Black $Text
				Write-Host ""
				Pause
				Exit
			}
		}
		Write-Host ""
	}
}

function Unregister-Libraries {
	<#
	.SYNOPSIS
		Desmontar o quitar de memoria librerias o modulos precargados

	.DESCRIPTION
		Eliminar dede memoria librerias o modulos precargados

	.PARAMETER libs
		Un arreglo listando las librerías que se quieren desmontar.

	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[array]
		$Libs
	)
	process {
		foreach ($lib in $Libs) {
			$lib = [io.path]::GetFileNameWithoutExtension($lib)
			Get-Module -Name $lib | Remove-Module
			Write-Host "Libreria ${lib} liberada"
		}
	}
}

#####################################
# Funciones para variables globales #
#####################################

function Get-Architecture {
	<#
	.SYNOPSIS
		Obtener la arquitectura del sistema operativo

	.DESCRIPTION
		Esta función devuelve si la arquitectura pasada corresponde o no la arquitectura actual del sistema operativo

	.PARAMETER Architecture
		Texto que puede contener la arquitectura a comparar (x86 o x64), cualquier otro parametro devuelve false.
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Architecture
	)
	process {
		if ($Architecture -eq "x64") {
			$Architecture = "AMD64"
		} elseif ($Architecture -eq "x86") {
			$Architecture = "x86"
		} else {
			wInfo("No se especificó una arquitectura")
			return $false
		}

		return $env:PROCESSOR_ARCHITECTURE -eq $Architecture
	}
}

function Get-InstallationState {
	<#
	.SYNOPSIS
		Obtener el progreso de instalación

	.DESCRIPTION
		Esta función devuelve un parametro guardado en el registro de software de PCBogotá
	#>
	$state = $False
	$regState = Get-PCBReg -Name "InstallState"
	if ($regState -ne "") {
		$state = $regState
	}
	return $state
}

function Get-InstallOption {
	<#
	.SYNOPSIS
		Resuelve una opcíon/pregunta de si o no para el proceso de instalación

	.DESCRIPTION
		Devuelve falso o verdadero para una opción de instalación y de no haberse guardado el dato previamente
		se realiza la pregunta y se guarda el dato en el registro de Windows
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$option
	)
	process {
		$optionText = $option
		$pattern = "[^a-zA-Z0-9]"
		$optionRegName = $option -replace $pattern, ""
		$optionRegData = Get-PCBReg -Name $optionRegName
		if ("" -eq $optionRegData) {
			$optionRegData = get-UserAnswer("${optionText}")
			Set-PCBReg -Name $optionRegName -Value $optionRegData
		}
		[bool]$option = [System.Convert]::ToBoolean($optionRegData)
		return $option
	}
}

function Set-InstallationState {
	<#
	.SYNOPSIS
	Colocar el estado del proceso de instalación

	.DESCRIPTION
	Esta función guarda el estado o punto de control del proceso de instalación de software
	.PARAMETER Value
	#>
	param(
		[Parameter(Mandatory)]
		[string]
		$value
	)
	process {
		Set-PCBReg -Name "InstallState" -Value $Value
	}
}

#########################################
# Funciones de regisro en área PCBogota #
#########################################
function Get-PCBReg {
	<#
	.SYNOPSIS
		Obtener un dato del registro en el área de PCBogota

	.DESCRIPTION
		Esta función devuelve un parametro guardado en el registro de software de PCBogotá

	.PARAMETER Name
		El parámetro a obtener desde el registro
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Name
	)
	process {
		return [string](Get-ItemProperty -LiteralPath HKLM:\Software\PCBogota -Name $name -ErrorAction SilentlyContinue).$name
	}
}

function Set-PCBReg {
	<#
	.SYNOPSIS
		Guardar un dato en el área de PCBogota del registro

	.DESCRIPTION
		Guarda un dato (solo de tipo string) en el área de PCBogota del registro

	.PARAMETER Name
		El parámetro a guardar desde en el registro

	.PARAMETER Value
		El valor del parametroa guardar en el registro
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Name,
		[Parameter(Mandatory, Position = 1)]
		[string]
		$Value
	)
	process {
		Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\PCBogota]
			"' + $Name + '"="' + $Value + '"
		')
	}
}

######################
# Funciones de fecha #
######################

function Get-CurrentDate {
	<#
	.SYNOPSIS
		Devuelve la fecha actual

	.DESCRIPTION
		Devuelve la fecha actual en el ordenador en formato de Mes (acortado)/Dia/Año Hora
		Ej OCT/20/2022 15:52
	#>
	return (Get-Date -Format "MMM/dd/yyyy HH:mm").Replace(".", "").ToUpper()
}

#########################
# Funciones adicionales #
#########################

function Add-ToHostsFile {
	<#
	.SYNOPSIS
		Agrega IPs y dominios para bloquear acceso a internet en el archivo hosts

	.DESCRIPTION
		Agrega IPs y dominios para bloquear acceso a internet en el archivo hosts

	.PARAMETER ips
		Arreglo que contiene la lista de dominios e IPs que se bloquearan del acceso a internet

	.PARAMETER Backup
		Booleano que especifica si se debe hacer una copia de seguridad del archivo hosts actual

	.PARAMETER comment
		Comentario que se colocará antes de las direcciones IP que se agregarán. el comentario dará la decha y hora
	#>

	param(
		[Parameter(Mandatory, Position = 0)]
		[array]
		$Ips,

		[switch]
		$backup,

		[string]
		$comment

	)
	process {
		$addToHostFile = ""
		$hostsFileContent = ""

		$file = $env:Windir + "\System32\drivers\etc\hosts"
		#Reiniciando atributos del archivo hosts
		Set-ItemProperty -Path $file -Name attributes -Value "Normal"

		#Generando línea de comentario
		if (($comment -ne "")) {
			$comment = "`n#" + $comment + " - " + (Get-Date -Format "MMM/dd/yyyy HH:mm:ss").Replace(".", "").ToUpper()
		} else {
		}

		#generacion de copia de seguridad solicitada
		if ($backup) {
			wRun("Creando copia del archivo Hosts")
			$destBackup = $file + '-backup_' + (Get-Date -Format "MMM-dd-yyyy_HH-mm-ss").replace(".", "")
			Copy-Item $file -Destination $destBackup
		}

		#Lectura del archivo hosts
		#Limpieza de datos incompatbles en archivo hosts
		foreach ($line in ([System.IO.File]::ReadLines($file))) {
			if ($line.startsWith('#') -or $line.startsWith('127') -or $line.startsWith('0')) {
				$hostsFileContent += "`n" + $line
			}
		}

		#generando a $addToHostFile que son las IP que no estan en el archivo hosts
		foreach ($block in $ips) {
			if ($hostsFileContent -notlike "*$block*" ) {
				$addToHostFile += "`n127.0.0.1`t$block"
			}
		}

		#generando nuevo arvhivo hosts
		$hostsFileContent + $comment + $addToHostFile | Out-File -FilePath $file -Force

		Set-ItemProperty -Path $file -Name attributes -Value "ReadOnly"
	}
}

function Block-InFirewall {
	<#
	.SYNOPSIS
		Bloquea la conexión de un programa desde el firewall de Windows

	.DESCRIPTION
		Bloquea la conexión de un programa desde el firewall de Windows

	.PARAMETER ProgramData
		Objeto que debe contener los parametros Name y Path del programa que se va a bloquear

	.PARAMETER Path
		Ruta en la que se bloquearan todos los archivos de una extension dada

	.PARAMETER extension
		Extensión de archivos a bloquear en el firewall de Windows, generalmente son archivos .exe
	#>
	Param(
		<#requires Object with name (Program name) and prog (Executable Path)#>
		[object]
		$ProgramData,
		[string]
		$Path,
		[string]
		$Extension
	)
	begin {
		if ($Path -ne "" -and $Extension -ne "") {
			if ($null -ne $ProgramData.Name -or $null -ne $ProgramData.Path) {
				Block-InFirewall $ProgramData
			}
			if (Test-Path -Path $path -PathType Container) {
				Write-Output "`n`nVerificando archivos para bloqueo en ${path}`n"
					(Get-ChildItem -Path $path -Recurse -Filter ('*.exe') ) | ForEach-Object {
					$file = $_.DirectoryName + "\" + $_.Name
					Write-Host "Bloqueando $file`n"
					$obj = @{
						name = "_Block " + ($_.Name) + " from " + ($_.DirectoryName)
						path = $file
					}
					Block-InFirewall -ProgramData $obj
				}
			}
			$finish = $true
		} elseif ($Path -ne "" -and $Extension -eq "") {
			Write-Error -Message "No se ha especificado la extension de archivo para el bloquear"
			Pause
			Exit
		} elseif ($Path -eq "" -and $Extension -ne "") {
			Write-Error -Message "No se ha especificado la ruta de los archivos a bloquear en el firewall"
			Pause
			Exit
		} elseif ($Path -eq "" -and $Extension -eq "" -and $null -eq $ProgramData) {
			Write-Error -Message "No se ha especificado ningun parametro para la función (-ProgramData o -Path y -Extension)"
			Pause
			Exit
		} elseif ($null -eq $ProgramData.Name -or $null -eq $ProgramData.Path) {
			Write-Error -Message "A la función no se pasó un objeto con las propiedades Name o Path correctamente"
			Pause
			Exit
		}
	}
	process {
		if ($finish) {
			return
		}
		$name = $ProgramData.name + " Inbound"
		$path = $ProgramData.path
		$desc = "Block " + $path
		if (Get-NetFirewallRule -Name $name -ErrorAction SilentlyContinue) {
			Remove-NetFirewallRule -Name $name
		}
		New-NetFirewallRule -DisplayName $name -Name $name -Program $path -Description $desc -Profile public, private, domain, any -Protocol any -Action block -Direction Inbound | Out-Null

		$name = $ProgramData.name + " Outbound"
		$desc = "Block " + $name
		if (Get-NetFirewallRule -Name $name -ErrorAction SilentlyContinue) {
			Remove-NetFirewallRule -Name $name
		}
		New-NetFirewallRule -DisplayName $name -Name $name -Program $path -Description $desc -Profile public, private, domain, any -Protocol any -Action block -Direction Outbound | Out-Null
	}
}

function New-link {
	<#
	.SYNOPSIS
		Crear un acceso directo de una aplicación

	.DESCRIPTION
		Crear un acceso directo de una aplicación

	.PARAMETER Dest
		La carpeta de destino donde se guardará el enlace

	.PARAMETER Name
		El nombre del icono. Será tambien el nombre del archivo .lnk

	.PARAMETER Source
		El programa al que se le creará el acceso directo

	.PARAMETER Arguments
		String de argumentos para la ejecución del programa

	.PARAMETER WorkingDirectory
		String del directorio de trabajo donde se ejecutará el programa.
		De no pasarse se utilizará la ruta de source

	.PARAMETER Icon
		Archivo de icono del programa, de no pasarse se utilizará el icono del
		programa especificado de source

	.PARAMETER Admin
		Switch para activar la ejecución del programa como administrador

	#>
	param(
		[Parameter(Mandatory)]
		[String]$Dest,
		[Parameter(Mandatory)]
		[String]$Name,
		[Parameter(Mandatory)]
		[String]$Source,
		[String]$Arguments = $null,
		[String]$WorkingDirectory = $null,
		[String]$Icon = $null,
		[switch]$Admin = $null
	)

	$Dest = get-EnvPS($Dest).trim("\")
	$Name = $Name.trim()
	$Source = get-EnvPS($Source).trim("\")
	if (!(Test-Path -Path $source -PathType Leaf)) {
		wError("No se encuentra la ubicación para la creación del acceso directo. Porfavor verifiquela: '${source}'")
		Pause
		exit
	}

	if ($WorkingDirectory) {
		if (!(Test-Path -Path $WorkingDirectory -PathType Container)) {
			wError("No se encuentra el directorio de trabajo del acceso directo. Porfavor verifiquelo: '$WorkingDirectory'")
			Pause
			return
		}
		$WorkingDirectory = get-EnvPS($WorkingDirectory).trim("\")
	} else {
		$WorkingDirectory = Split-Path $Source -Parent
	}

	if ($Icon) {
		if (!(Test-Path -Path $Icon -PathType Leaf)) {
			wError("No se encuentra archivo para el icono del acceso directo. Porfavor verifiquelo: '$Icon'")
			Pause
			return
		}
		$Icon = Get-EnvPS($Icon)
	} else {
		$icon = $source
	}
	$Shell = New-Object -ComObject ("WScript.Shell")
	$ShortCut = $Shell.CreateShortcut($Dest + "\" + $Name + ".lnk")
	$ShortCut.TargetPath = "$Source"

	if ($Arguments) {
		$Arguments = Get-EnvPS($Arguments)
		$ShortCut.Arguments = "$Arguments"
	}
	$ShortCut.WorkingDirectory = "$WorkingDirectory"
	$ShortCut.IconLocation = "$icon, 0"
	$ShortCut.Save()

	if ($Admin) {
		$bytes = [System.IO.File]::ReadAllBytes($dest + "\" + $name + ".lnk")
		Start-Sleep -s 1
		$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
		[System.IO.File]::WriteAllBytes($dest + "\" + $name + ".lnk", $bytes)
	}
}

function Get-EnvPS() {
	<#
	.SYNOPSIS
		Obtener el valor como texto de una variable de entorno

	.DESCRIPTION
		Esta función devuelve el valor actual de una variable de entorno en powershell. la variable puede ser pasada como se utiliza en
		la linea de comandos de Windows (CMD) %TEMP% o powershell $env:TEMP

	.PARAMETER Text
		Es el texto o la variable de entorno

	#>
	param(
		[string]$Text
	)
	if ($Text -like "*%*") {
		$value = @()
		$space = "[_spaced_]"
		$changed = "[_changed_]"
		$Text = $Text.Replace(" ", $space)
		$Text.Split("%") | ForEach-Object {
			$found = $false
			$envRes = ""
			foreach ($env in (Invoke-Expression "dir env:")) {
				if ($env.name -eq $_) {
					$envRes = $changed + $env.value + $changed
					$found = $true
					break
				}
			}
			if (!$found) {
				$value += $_
			} else {
				$value += $envRes
			}
		}
		$value = $value -join ("%")
		$value = $value.Replace($space, " ")
		$value = $value.Replace(("%" + $changed), "")
		$value = $value.Replace(($changed + "%"), "")
	} else {
		foreach ($env in (Invoke-Expression "dir env:")) {
			$found = $false
			if ($env.name -eq $Text) {
				$value = $env.value
				$found = $true
				break
			}
		}
		if (!$found) {
			$value = $Text
		}
	}
	return $value
}

function Get-ExecFileByArch {
	<#
	.SYNOPSIS
		Obtener el ejecutable correcto de una aplicación según la arquitectura del sistema operativo

	.DESCRIPTION
		Algunas aplicaciones vienen con ejecutables para distintas arquitecturas (x86, x64). Esta función
		devuelve la ruta archivo ejecutable correcto para el sistema operativo desde donde se ejecuta.

		El parámetro de ruta debe tener un solo simbolo de interrogación ? en donde van los caracteres
		que cambia según la arquitectura. admite variables de entorno de CMD y de Powershell
		ya que hace uso de la funcón Get-EnvPS

		Hay que tener en cuenta que no esta función no hace busqueda de carpetas, la carpeta debe
		enviarse explicitamente a la función

	.PARAMETER Path
		Texto de la ruta completa del archivo a ejecutar (Ruta y archivo)

	.PARAMETER Arch
		La aquitectura en la que se buscará el archivo ejecutable. Si no se pasa este parámetro
		se tomará la arquitectura actual del sistema operativo

	.EXAMPLE
		En un sistema de 64 bits
		get-ExecFileByArch -Path "%Programfiles%\sysinternals\autoruns?.exe"
		Devuelve: "C:\Program Files\Sysinternals Suite\autoruns64.exe"

		En un sistema de 32 bits
		get-ExecFileByArch -Path "%Programfiles%\sysinternals\autoruns?.exe"
		Devuelve: "C:\Program Files\Sysinternals Suite\autoruns.exe"

		En un sistema de 64 bits
		get-ExecFileByArch -Path "%Programfiles%\sysinternals\autoruns?.exe" -Arch "x86"
		Devuelve: "C:\Program Files\Sysinternals Suite\autoruns.exe"
		#>
	param(
		[Parameter(Mandatory)]
		[string]
		$Path,

		[string]
		[ValidateSet("x86", "x64", "current")]
		$Arch = "current"

	)
	process {
		$found = $false
		$fileOpts = @(
			@{x64 = @(
					"64",
					"64-bit",
					"x64",
					""
				)
			},
			@{x86 = @(
					"32",
					"32-bit",
					"x86",
					""
				)
			}
		)
		if ($arch -eq "x86") {
			$fileOpts = $fileOpts.x86
		} elseif ($arch -eq "x64") {
			$fileOpts = $fileOpts.x64
		} else {
			if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
				$arch = "x64"
				$fileOpts = $fileOpts.x64
			} else {
				$arch = "x86"
				$fileOpts = $fileOpts.x86
			}
		}
		$Path = Get-EnvPS($Path)
		if ($Path -match '\?') {
			$filename = Split-Path -Path $Path -Leaf
			$Path = Split-Path -Path $Path -Parent
			$searchPathList = $Path.Split("?")
			$pathFound = ""
			for ($i = 0; $i -le ($searchPathList.Count); $i++) {
				$pathFound += $searchPathList[$i]
				foreach ($opt in $fileOpts) {
					$testPath = $pathFound + $opt
					if (Test-Path -Path ($testPath) -PathType Container) {
						$pathFound += $opt
						break
					}
				}
			}
			$Path = $pathFound
			if (!(Test-Path -Path ($Path) -PathType Container)) {
				Write-Error "No se encontró la carpeta para el archivo ${filename}" -Verbose
				Pause
				exit
			}
			foreach ($opt in $fileOpts) {
				$fileTest = ($filename) -replace ("\?", $opt)
				if (Test-Path -Path ($path + "\" + $fileTest) -PathType Leaf) {
					$filename = $fileTest
					break
				}
			}
			if ($filename -ne (Split-Path -Path $Path -Leaf)) {
				$found = $path + "\" + $Filename
			}
		} else {
			Write-Host "No se especificó una arquitectura a encontrar con '?' en la ruta`n${path}"
			Pause
			exit
		}
		if (!$found) {
			Write-Host "No se encontró un archivo para la arquitectura ${arch} en`n${path}"
			Pause
			exit
		} else {
			return [string]$found
		}
	}
}

function Get-Path {
	<#
	.SYNOPSIS
		Encuentra la ruta donde esta un archivo

	.DESCRIPTION
		Devuelve la ruta donde se encuentra un archivo . La búsqueda se hace en la
		ruta pasada y si no se encuentra se realiza una busqueda en todas las
		unidades activas con la ruta pasada y en última instancia en todas las
		carpetas de la uinidad actual

	.PARAMETER FileName
		El programa o aplicación a ejecutar

	.PARAMETER Path
		- La ruta donde se buscará en primera instancia el archivo
		- Si no se pasa este parámetro, se buscará posibles rutas en filename
		- Si no existe una ruta en filename ni se pasa la ruta se buscará en la
			carpeta actual y en la raiz de las unidades disponibles

	.PARAMETER Drive
		Unidad en la cual buscar. Si no se especifica se tomarán las letras posibles todas para buscar la ruta pasada

	.PARAMETER Force
		Este parametro indica que se debe buscar el archivo en todas las unidades y todas las
		carpetas del computador

	.PARAMETER Full
		Este parámetro devuelve la ruta completa del archivo junto con el nombre de archivo
		cuando no se pasa, solo se devuelve la ruta (path) del archivo

	.PARAMETER Limit
		El limite de rutas a devolver. Si se coloca 1 o no se pasa el parametro, se enviara la primera coincidencia.
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Filename,

		[string]
		$Path,

		[string]
		$Drive,

		[switch]
		$Force = $false,

		[switch]
		$Full = $false,

		[int]
		$Limit = 0
	)
	process {
		$FoundFile = $false
		#Drive
		if (!$Drive -or "" -eq $Drive) {
			if (($Path -and $Path -ne '')) {
				$Drive = Split-Path -Path $Path -Qualifier -ErrorAction SilentlyContinue
			}
			if (!$Drive) {
				$Drive = Split-Path -Path $Filename -Qualifier -ErrorAction SilentlyContinue
			}
			if ("" -eq $Drive) {
				[Boolean]$Drive = $False
			}
		}
		if (!$Drive) {
			[String]$Drive = Split-Path -Path $PSScriptRoot -Qualifier
		}
		$Drive = $Drive.Trim("\")

		#Path
		if (!$Path -or "" -eq $Path) {
			$Path = (Split-Path $Filename -ErrorAction SilentlyContinue -Parent).Trim("\")
			if ($path -ne "") {
				$Path = (Split-Path $Path -ErrorAction SilentlyContinue -NoQualifier).Trim("\")
			}
			if ("" -eq $Path) {
				[Boolean]$Path = $False
			}
		} else {
			$Path = (Split-Path $path -ErrorAction SilentlyContinue -NoQualifier).Trim("\")
		}
		if (!$Path) {
			[String]$Path = (Split-Path -Path $PSScriptRoot -NoQualifier).Trim("\")
		}

		#Filename
		$Filename = Split-Path -Path $Filename -Leaf

		#Buscar el archivo en la ruta enviada a la función.
		$location = ($drive + "\" + $path + "\" + $filename)
		if (Test-Path -Path $location -PathType Leaf) {
			$FoundFile = $location
		} else {
			#Si no se encontró buscar en la ruta que se pasó para todas las unidades activas.
			wInfo("Buscando en todas las unidades `"" + $Path + "\" + $filename + "`" ...")
			if (($drive + "\" + $path) -ne (Split-Path -Path $PSScriptRoot)) {
				$DriveList = ((Get-PSDrive -PSProvider FileSystem).Root).trim("\") | ForEach-Object {
					$location = $_ + "\" + $Path + "\" + $filename
					if (Test-Path -Path $location -PathType Leaf) {
						$location
					}
				}
				if ($null -ne $DriveList) {
					$FoundFile = $DriveList
				} else {
					#Si no esta en la ruta pasada en ninguna unidad buscar el archivo en la carpeta actual
					wInfo("Revisando la carpeta actual: " + $PSScriptRoot)
					$location = $PSScriptRoot + "\" + $filename
					if ((Test-Path -Path $location -PathType Leaf)) {
						$FoundFile = $Location
					} else {
						#Por último Debe buscar el archivo en el disco actual (esto debe ser un proceso muy rápido)
						$location = (Split-Path -Path $PSScriptRoot -Qualifier) + "\"
						WInfo("Realizando una busqueda en " + $location)
						$FoundFile = Get-ChildItem -Path $location -Include ("*${filename}*") -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
							$_.DirectoryName + "\" + $_.Name
						}
						if (!$FoundFile -and $force) {
							WInfo("Realizando una busqueda en " + $Drive)
							$FoundFile = Get-ChildItem -Path $Drive -Include ("*${filename}*") -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
								$_.DirectoryName + "\" + $_.Name
							}
						}
					}
				}
			}
		}


		if ($FoundFile) {
			$Text = ""
			if ($FoundFile.GetType().Name -eq "Object[]") {
				$Text = "`n"
				$FoundFile | ForEach-Object {
					$Text += ("-> " + $_ + "`n")
				}
			} else {
				$Text = $FoundFile
			}
			if (($Limit -eq 1) -and ($FoundFile.GetType().Name -eq "Object[]")) {
				[string]$FoundFile = ($FoundFile[0])
			}
			wOk("Archivo encontrado en: " + $Text)
		} else {
			wError("No se encontró el archivo " + $Filename)
			Pause
		}
		if (!$full -and $FoundFile) {
			$FoundFile = Split-Path -Path $FoundFile -Parent
		}
		return $FoundFile
	}
}

function Get-UserAnswer {
	<#
	.SYNOPSIS
		Funcion que solicita al usuario presionar S o N,

		.DESCRIPTION
		Funcion que solicita al usuario presionar S o N,
		Si se presiona s, S, y, Y o 1 la función devolverá $true
		Si se presiona ene, ENE o cero la función devolverá $false
		Si se presiona cualquier otra tecla la función volverá a preguntar

	.PARAMETER Texto
		Es el texto de la preunta que se hará al usuario
	#>

	<#
	.SYNOPSIS
		Realiza al usuario pregunta de respuesta afirmativa o negativa

	.DESCRIPTION
		Funcion que solicita al usuario presionar S o N,
		Si se presiona s, S, y, Y o 1 la función devolverá $true
		Si se presiona 0 (cero), n o N la función devolverá $false
		Si se presiona cualquier otra tecla la función volverá a preguntar
	#>
	param(
		[Parameter(Mandatory = $true)]
		[String[]]
		$texto
	)
	process {
		if ($psISE) {
			$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Si"
			$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"
			$options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $no)
			$heading = "Responde"
			$rslt = $host.ui.PromptForChoice($heading, $texto, $options, 1)
			$answer = !([System.Convert]::ToBoolean($rslt))
		} else {
			$Ignore = ((Get-Variable -Name keyboardPressIgnores).Value)
			Write-Host -NoNewline -ForegroundColor DarkYellow $texto "[Si, No]: "
			$key = $Host.UI.RawUI.ReadKey("IncludeKeyDown")

			while (($Null -Eq $key.VirtualKeyCode) -Or ($Ignore -Contains $key.VirtualKeyCode)) {
				$key = $Host.UI.RawUI.ReadKey()
			}
			$key = $key.character
			if (($key -eq "y") -or ($key -eq "Y") -or ($key -eq "s") -or ($key -eq "S") -or ($key -eq "1")) {
				Write-Host "`n`n"
				$answer = $true
			} elseif (($key -eq "n") -or ($key -eq "N") -or ($key -eq "0")) {
				Write-Host "`n`n"
				$answer = $False
			} else {
				Write-Host "`nNo se admite '$key' como posible respuesta"
				Write-Host "Solo se admite S o N `n"
				return get-UserAnswer($texto)
			}
		}
		return $answer
	}
}

function Get-UserChoice {
	<#
	.SYNOPSIS
		Funcion que devuelve la tecla presionada por un usuario

		.DESCRIPTION
		Funcion que devuelve la tecla presionada por un usuario

	.PARAMETER Text
		Es el texto de la preunta que se hará al usuario

	.PARAMETER Options
		Las posible opciones que podrá escoger el usuario

		#>
	param(
		[Parameter(Mandatory = $true)]
		[String[]]
		$Text,
		[Parameter(Mandatory = $true)]
		$Options
	)
	$Ignore = ((Get-Variable -Name keyboardPressIgnores).Value)
	Write-Host -NoNewline -ForegroundColor Yellow $text
	$key = $Host.UI.RawUI.ReadKey("IncludeKeyDown")
	while (($Null -Eq $key.VirtualKeyCode) -Or ($Ignore -Contains $key.VirtualKeyCode)) {
		$key = $Host.UI.RawUI.ReadKey()
	}
	$key = $key.character
	if (($Options -ilike $key)) {
		Write-Host ""
		Write-Host ""
		return $key
	} else {
		Write-Host ""
		Write-Host "No se admite '$key' como posible respuesta"
		Write-Host "Solo se admite " $Options
		Write-Host ""
		return get-UserChoice -Text $text -Options $Options
	}
}

function Mount-Iso {
	<#
	.SYNOPSIS
		Función para montar una imagen ISO

	.DESCRIPTION
		Monta una imagen ISO en una unidad del computador y devuelve en la que fue montada

	.PARAMETER IsoPath
		La ruta completa de una imagen ISO
	#>

	param(
		[Parameter (Mandatory = $true)]
		[string]
		$IsoPath
	)

	process {
		#Comprobar que la ruta ($IsoPath) No sea una cadena vac?a"
		if ($IsoPath -eq "") {
			wError("La ruta del archivo .iso es una cadena vacía. No se puede continuar")
			Pause
			exit
		}
		#Si es un archivo .iso y el archivo existe se monta en una unidad virtual
		if (($IsoPath -match ".iso$") -and (Test-Path $IsoPath -PathType Leaf)) {
			#obtener la listade de unidades actuales y guardalo como "arreglo" para comparación
			$DrivesBeforeMount = "[" + ((Get-Volume).DriveLetter -join '') + "]"

			#Comando para montar la imagen .iso
			Mount-DiskImage $isoPath | Out-Null

			#obtener la lista de las unidades luego de montar el archivo .iso
			$DrivesAfterMount = (Get-Volume).DriveLetter -join ''
			#Para obtener la unidad de monetaje del .iso se reemplazan las coincidencias en las listas
			$NewDrivePath = ($DrivesAfterMount -replace $DrivesBeforeMount, "") + ":\"
		} else {
			wError ("No se reconoce $IsoPath como una imagen .iso")
			Pause
			exit
		}
		return $NewDrivePath
	}
}

Function Pause {
	<#
	.SYNOPSIS
		Realiza una pausa en la ejecución del script

	.DESCRIPTION
		Al llamarse la función realiza una pausa en la ejecución del script, si la pausa se realiza desde Powershell ISE,
		se muestra una ventana para continuar. Adicionalmente se puede pasar un mensaje por medio del parámetro -Messsage

	.PARAMETER Message
		Un mensaje que se mostrará antes de la pausa
	#>
	param(
		[string]
		$Message = "UnsetFunctionsw10ByPCBogota"
	)
	process {
		# Check if running in PowerShell ISE
		If ($psISE) {
			# "ReadKey" not supported in PowerShell ISE.
			# Show MessageBox UI
			if ($Message -eq "UnsetFunctionsw10ByPCBogota") {
				$Message = "Presiona Aceptar para continuar."
			} else {
				$Message = $Message + "`n`nPresiona Aceptar para continuar."
			}
			$Shell = New-Object -ComObject "WScript.Shell"
			$Shell.Popup($Message, 0, "Pausa", 0)
			Return
		}
		if ($Message -eq "UnsetFunctionsw10ByPCBogota") {
			$Message = "Presiona una tecla para continuar..."
		} else {
			$Message = $Message + "`n`nPresiona una tecla para continuar..."
		}

		$Ignore = ((Get-Variable -Name keyboardPressIgnores).Value)
		Write-Host -NoNewline $Message
		While ($Null -Eq $KeyInfo.VirtualKeyCode -Or $Ignore -Contains $KeyInfo.VirtualKeyCode) {
			$KeyInfo = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
		}
		Write-Host "`n"
	}
}

function Restart-AndContinue {
	<#
	.SYNOPSIS
	Función Que reinicia el computador y ejecuta un programa por una unica vez

	.DESCRIPTION
	durante la instalación del software es necesario reiniciar el computador varias veces
	apara continuar. Esta función realiza ese proceso guardando el estado o punto de control que puede ser adquirido de nuevo con la función Get-InstallationState

	.PARAMETER checkpoint
	El nombre del punto que se terminó el nombre del valor a checar para continuar
	la ejecución

	.PARAMETER run
	Un programa a ejecutar al reiniciar automáticamente, este parametro está
	predeterminado con el archivo de ejecucuón de instalación, pero puede ser cambiado

	.PARAMETER pause
	Switch. Al activarse se realizará una pausa hasta presionar una tecla para ejecutar
	el reinicio del computador
	#>
	param(
		[Parameter(Mandatory)]
		[string]
		$checkpoint,

		[string]
		$run = "D:\- Instalar\-- iniciar.cmd",

		[switch]
		$pause = $False
	)
	process {
		winfo("Se reiniciará el equipo.")
		if ($pause) {
			Pause
		}
		wRun("Verificando la existencia de ${run}...")
		$run = Get-Path -FileName $run -Full
		wRun("Guardando la ejecución de ${run}...")
		Set-Autorun -KeyName "Setup" -Command $run
		wRun("Colocando el punto de control '${checkpoint}'...")
		Set-InstallationState -Value $checkpoint
		wRun("Comenzando el proceso de reinicio. Espera...")
		Start-Sleep -Seconds 5
		Restart-Computer -Force
	}
}

function Remove-EmptyFolder($path) {
	<#
	.SYNOPSIS
	Elimina las carpetas que no contienen ningun archivo y/o carpeta

	.DESCRIPTION
	Elimina las carpetas que no contienen ningun archivo y/o carpeta

	.PARAMETER path
	La ruta donde se van a borrar las carpetas vacias
	#>

	# Set to true to test the script
	$whatIf = $false
	# Remove hidden files, like thumbs.db
	$removeHiddenFiles = $true
	# Get hidden files or not. Depending on removeHiddenFiles setting
	$getHiddelFiles = !$removeHiddenFiles

	# Go through each subfolder,
	Foreach ($subFolder in Get-ChildItem -Force -Literal $path -Directory) {
		# Call the function recursively
		Remove-EmptyFolder -path $subFolder.FullName
	}
	# Get all child items
	$subItems = Get-ChildItem -Force:$getHiddelFiles -LiteralPath $path
	# If there are no items, then we can delete the folder
	# Exluce folder: If (($subItems -eq $null) -and (-Not($path.contains("DfsrPrivate"))))
	If ($null -eq $subItems) {
		Remove-Item -Force -Recurse:$removeHiddenFiles -LiteralPath $Path -WhatIf:$whatIf
	}
}

function Remove-SchdTask {
	<#
	.SYNOPSIS
	Eliminar una tarea proramada

	.DESCRIPTION
	Esta función sirve para eliminar una tarea programada del sistema. A tener en	cuenta es que no busca
	recursivamente

	.PARAMETER task
	El nombre de la tarea a eliminar

	.PARAMETER folder
	El programador de tareas contiene carpetas, debe sarse la carpeta escífica de la ubicación de la tarea
	#>
	param(
		[Parameter(Mandatory = $true)]
		[string]
		$task,
		[string]
		$folder = "\"

	)
	$TaskToDelete = $task
	# create Task Scheduler COM object
	$TS = New-Object -ComObject Schedule.Service

	# connect to local task scheduler
	$TS.Connect($env:COMPUTERNAME)

	# get tasks folder (in this case, the root of Task Scheduler Library)
	$TaskFolder = $TS.GetFolder($folder)

	# get tasks in folder
	$Tasks = $TaskFolder.GetTasks(1)
	# step through all tasks in the folder

	$Tasks | ForEach-Object {
		if ($_.Name -ilike "*$TaskToDelete*") {
			Write-Host ("La tarea " + $_.Name + " se eliminará")
			$TaskFolder.DeleteTask($_.Name, 0)
		}
	}
}

function Set-Autorun {
	<#
	.SYNOPSIS
	Ejecutar una unica vez o recurrentemente un comando o aplicación

	.DESCRIPTION
	Esta función coloca en el registro (en la clave HKEY_LOCAL_MACHINE) la ejecución automatica de un comando
	o una aplicación ya sea siempre (-recurrent) o por una unica vez al siguiente reinicio

	.PARAMETER KeyName
	El nombre de la clave, el cual se sugiere explicito ya que se peude repetir con otras aplicaciones

	.PARAMETER Command
	El comando o aplicación a ejecutar

	.PARAMETER Recurrent
	Especifica si el comando se ejecutará siempre que se encienda el computador o solo en el siguiente
	reinicio. Hay que tener en cuenta que la ejecución NO recurrente del comando Se ejecuta desde la consola de comandos.
	#>
	[CmdletBinding()]
	param(
		#The Name of the Registry Key in the Autorun-Key.
		[string]
		$KeyName = 'Run',

		#Command to run
		[string]
		$Command = '%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe',

		[switch]
		$Recurrent = $False
	)
	process {
		$regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"

		if (!$recurrent) {
			$regPath += "Once"
			$command = 'cmd /c start "' + ${KeyName} + '" "' + $Command + '"'
		}

		if (!(Test-Path $regPath)) {
			New-Item -Path $regPath | Out-Null
		}

		if ((Get-ItemProperty -Path $regPath).$KeyName ) {
			Set-ItemProperty -Path $regPath -Name $KeyName -Value $Command -Type ExpandString | Out-Null
		} else {
			New-ItemProperty -Path $regPath -Name $KeyName -Value $Command -Type ExpandString | Out-Null
		}
		$text = "Se ejecutará:`n>>> " + $command.Replace('cmd /c start "RunOnce" ', "") + "`n"
		if ($recurrent) {
			$text += "cada vez que se encienda el equipo"
		} else {
			$text += "solamente en el siguiente reinicio (RunOnce)"
		}
		Write-Host $text
	}
}

function Set-PassedVar {
	<#
	.SYNOPSIS
		Funcion para cambiar "%variables%" por el término o resultado de un comando a un texto.

	.DESCRIPTION
		Esta función recibe dos parámetros uno el texto a cambiar y el otro los parametros que se
		deben sobreescribir en ese texto. Los parametros deben especificarse del modo key=data
		donde key es el parámetro a buscar dentro del texto, por otro lado data es el texto
		por el que sustituirá el "Key"

	.PARAMETER Vars
		Son las variables a cambiar dentro de un texto, puede ser funciones de
		powershell, que se se ejecutarán para obtener su resultado

		%var% = ($env:COMPUTERNAME).Replace("algo","X-otro")

	.PARAMETER Replace
		El texto de origen que trae las claves para cambiar desde vars el
		cual puede ser multilinea
		"El dato %var% es el
		que se cambia en un texto"
	#>

	param(
		[Parameter(Mandatory)]
		[string]
		$Vars,
		[string]
		$Replace
	)
	process {
		$result = $Replace
		if ($vars) {
			$lines = $vars.Split("`n")
			foreach ($line in $lines) {
				if ($line -ne "") {
					$data = $line.split("=")
					$data[0] = ($data[0]).trim()
					$data[1] = $data[1].trim()
					$data[1] = Invoke-Expression $data[1]
					$result = $result -replace ($data[0], $data[1])
				}
			}
		}
		return [string] $result
	}
}

function Set-PrefsFile {
	<#
	.SYNOPSIS
		Funcion para guardar un archivo de preferencias de instalación o preferencias de una app.

	.DESCRIPTION
		Esta función genera un archivo preestablecido de preferencias en un formato especifico en una
		ruta específica, la cual debe pasarse en un objeto de preferencias

	.PARAMETER preferences
		Un objeto que debe tener los siguientes parametros:
		.file = Nombre de archivo de preferencias
		.Path = Ruta donde se guardará el archivo de preferencias
		.enc  = Codificación del archivo de preferencias
		.data = La infrmación que se guardará en el archivo de preferencias
#>
	param(
		[Parameter(Mandatory)]
		[object]
		$preferences
	)
	process {
		$PrefsFilePath = $preferences.Path + "\" + $preferences.File
		if (Test-Path $PrefsFilePath -PathType Leaf) {
			Remove-Item -Force -Path $PrefsFilePath
		}
		if (!(Test-Path $preferences.Path -PathType Container)) {
			New-Item -Path ($preferences.Path) -Force -ItemType Directory | Out-Null
		}

		if ($preferences.Enc -eq "utf8") {
			$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
			[System.IO.File]::WriteAllLines($PrefsFilePath, $preferences.Data, $Utf8NoBomEncoding)
		} elseif ($preferences.Enc) {
			$enc = [System.Text.Encoding]::GetEncoding($preferences.Enc)
			[System.IO.File]::WriteAllLines($PrefsFilePath, $preferences.data, $enc)

		} else {
			$preferences.Data | Out-File -FilePath $PrefsFilePath -Force
		}
	}
}

function Start-AsSystem {
	<#
	.SYNOPSIS
		Ejecuta como usuario System un comando

	.DESCRIPTION
		Ejecuta un comnado como el usuario de mas altos privilegios "System".
		Requiere de la utilidad de sysinternals psexec.exe para si ejecución,
		la utilidad debe estar en esta misma carpeta

	.PARAMETER Command
		Es el único parametro recibido y es el comando que se ejecutará como usuario "System"
	#>
	param(
		[Parameter (Mandatory)]
		[String] $Command
	)
	#Agregando EULA de Sysinternals PsExec
	reg add HKEY_CURRENT_USER\SOFTWARE\Sysinternals\PsExec /v "EulaAccepted" /d 1 /f | Out-Null

	$drive = $PSScriptRoot.split("\")[0]

	@"
`"$PSScriptRoot\psexec.exe`" -i -d -s $Command
"@ | Out-File -FilePath $drive\run.bat -Encoding ascii
	wRun("  Ejecutando como usuario de sistema:
  " + $Command)
	Start-Process "$drive\run.bat" -Wait -WindowStyle Hidden
	Remove-Item "$drive\run.bat"
}
function Start-DbApp {
	<#
	.SYNOPSIS
		Ejecuta una aplicación guardada en la Babse de datos

	.DESCRIPTION
		Ejecuta una aplicación guardada en la Babse de datos

	.PARAMETER appName
		El nombre de la apliCACIÓN A EJECUTAR

	.PARAMETER wait
		Si está presente especifíca si el programa espera a terminar la ejecución para continuar

	.PARAMETER Argumentlist
		Argumentos que se le parasarán a la aplicación al ejecutarse
	#>
	param(
		[String] $appName,
		[Switch] $wait = $false,
		[string] $Argumentlist
	)
	$appData = get-dbAppData($appName)
	if (!$x86 -and !$appData.instFile_x64) {
		$appData.runFileAppPath = ($appData.runFileAppPath).Replace("ProgramFiles", "ProgramFiles(x86)")
	}
	$appData.runFileAppPath = Get-EnvPS($appData.runFileAppPath)
	$run = $appData.runFileAppPath + "\" + $appData.runFileApp

	if ($run -match '\?') {
		$run = [string](get-ExecFileByArch -Path $run)
	}
	$appData.runFileAppPath = Split-Path -Path $run -Parent
	$appData.runFileApp = Split-Path -Path $run -Leaf

	$run = $appData.runFileAppPath + "\" + $appData.runFileApp
	if (!(Test-Path -Path $run)) {
		if (!(Test-Path -Path $run)) {
			wError("No se encuentra $appName en $run")
			return
		}
	}

	$command = "Start-Process -FilePath '" + $run + "'"
	if ($Argumentlist -ne "") {
		$command += " -ArgumentList " + $Argumentlist
	}
	Invoke-Expression $command
	if ($wait) {
		Start-Sleep -Seconds 1
		$process = ([io.path]::GetFileNameWithoutExtension($appData.runFileApp))
		wInfo ("Esperando al cierre del proceso `"" + $process + "`" de $appName...")
		while (((Get-Process).Name) -join '|' -like ("*$process*")) { Start-Sleep -s 1 }
	}
}

Function Test-IsLaptop {
	<#
	.SYNOPSIS
		Devuelve el boleano de si el comutador es portátil (laptop) o no

	.DESCRIPTION
		Devuelve el boleano de si el comutador es portátil (laptop) o no

	.PARAMETER computer
		El nombre o dirección del computador al que encontrar el tipo de computador. La opción predetermina es el computador donde se ejecuta la función
	#>

	Param( [string]$computer = "localhost" ) # Se puede pasar el nombre de un equipo en red
	#Estos son los valores posibles de la clase win32_systemenclosure Propiedad chassistypes (en asterisco los que detecta un portatil)
	#Other (1)
	#Unknown (2)
	#Desktop (3)
	#Low Profile Desktop (4)
	#Pizza Box (5)
	#Mini Tower (6)
	#Tower (7)
	#*Portable (8)
	#*Laptop (9)
	#*Notebook (10)
	#*Hand Held (11)
	#Docking Station (12)
	#All in One (13)
	#*Sub Notebook (14)
	#Space-Saving (15)
	#Lunch Box (16)
	#Main System Chassis (17)
	#Expansion Chassis (18)
	#SubChassis (19)
	#Bus Expansion Chassis (20)
	#Peripheral Chassis (21)
	#Storage Chassis (22)
	#Rack Mount Chassis (23)
	#Sealed-Case PC (24)

	$isLaptop = $false
	#The chassis is the physical container that houses the components of a computer. Check if the machine?s chasis type is 9.Laptop 10.Notebook 14.Sub-Notebook
	if ((Get-WmiObject -Class win32_systemenclosure -ComputerName $computer).ChassisTypes | ForEach-Object {
			$_.chassistypes -eq 9 -or $_.chassistypes -eq 10 -or $_.chassistypes -eq 14
		}) {
		$isLaptop = $true
	}
	#Shows battery status , if true then the machine is a laptop.
	if (Get-WmiObject -Class win32_battery -ComputerName $computer) {
		$isLaptop = $true
	}
	return $isLaptop
}

function Test-RegistryValue {
	<#
	.SYNOPSIS
		Verifica que exista un valor en el registro en una ruta específica

	.DESCRIPTION
	 	Función que verifica que en una ruta especificada en el argumento path exista y de ser así
		devolverá verdadero ($true) en caso que exista. Esta funciónm es similar a test-path pero
		para valores en el registro

	.PARAMETER Path
		La ruta en el regsitro donde se buscara en valor

	.PARAMETER Value
		El nombre del valor a buscar
	#>
	param (
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]$Path,
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]$Value
	)
	try {
		Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
		return $true
	} catch {
		return $false
	}
}

function Wait-For {
	<#
	.SYNOPSIS
		Espera hasta que un comando termine su ejecución para continuar

	.DESCRIPTION
		Realiza una espera forzada a que finalice una aplicación, sea pasando solo el programa a
		ejecutar o tambien el nombre del proceso. De no pasar el nombre del proceso se ejecutará
		el programa y se averiguará el nombre del proceso.

	.PARAMETER Run
		El programa o aplicación a ejecutar

	.PARAMETER ProcessName (Opcional)
		El nombre del proceso que ejecuta la aplicación (puede ser distinto al nombre del archivo)
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Run,
		[string]
		$ProcessName
	)
	process {

		if ($ProcessName -eq "") {
			Wait-Process -Id (Start-Process $Run -PassThru).id
		} else {
			Start-Process $Run
			Start-Sleep -s 2
			if (Get-Process $ProcessName -ErrorAction SilentlyContinue) {
				Wait-Process $ProcessName
			}
		}

	}
}

function Wait-ForAdblock {
	<#
	.SYNOPSIS
		Función específica para abrir la página de adblock

	.DESCRIPTION
		Función específica para abrir la página de adblock cuando los navegadores hayan iniciado.
		Se crea una función específica para ello debido que este archivod e modulos debe cargarse en el "job"
		que realiza la tarea

	.PARAMETER Process
		El nombre del proceso del navegador

	.PARAMETER Name
		Nombre del navegador, para mostrar y para busqueda en la base de datos

	#>
	param(
		[string] $Process,
		[string] $Name
	)

	$processWait = $true
	while ($processWait) {
		Write-Output "Esperando por el proceso $Name"
		Start-Sleep -s 1
		$processData = Get-Process -Name $Process -ErrorAction SilentlyContinue
		if ($processData) {
			$path = $processData[0].Path
			$processWait = $false
			foreach ($p in $processData) {
				if ($null -ne $p.Path) {
					$path = $p.Path
					break
				}
			}
			Get-Process $Process | ForEach-Object { $_.CloseMainWindow() | Out-Null } | Stop-Process –Force
			while (Get-Process $Process -ErrorAction SilentlyContinue) {
				Stop-Process -Name $Process -Force
				Start-Sleep -S 1
			}
			Start-Sleep -S 2
			#add preferences
			$app = get-dbAppData($name)
			if ($app.appPrefsFileData) {
				set-prefsFile(@{
						file = $app.appPrefsFileName
						path = get-EnvPS($app.appPrefsFilePath)
						enc  = $app.appPrefsFileEnc
						data = $app.appPrefsFileData
					})
			}
			Start-Process ([string]$path) -ArgumentList "www.adblockplus.org"
		}
	}

}


<#######################
# Ejecución del modulo #
#######################>

$text = "Configurando variables, acceso a carpetas y modulos del instalador"
$global:requiredLibraries = @(
	#'pcb-file-encoding.psm1',
	#'pcb-Force-mkdir.psm1',
	'pcb-Add-To-Reg.psm1',
	'pcb-dbSqlite3.psm1',
	'pcb-install-App.psm1',
	'pcb-Take-own.psm1',
	'pcb-Write-to-user.psm1'
)

Write-Host -ForegroundColor White -BackgroundColor Black "`n" $Text.ToUpper() "`n`n"
Register-Libraries($requiredLibraries)

wOk("Funciones para la instalación cargadas!")

######################
# Variables globales #
######################

$global:x64 = Get-Architecture -Architecture "x64"
$global:x86 = Get-Architecture -Architecture "x86"
$global:ssd = (Get-PhysicalDisk).mediatype -contains "SSD"
