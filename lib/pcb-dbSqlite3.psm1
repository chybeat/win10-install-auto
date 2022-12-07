function Get-DbQuery {
	<#
	.SYNOPSIS
		Realiza una consulta y devuelve un objeto con la información de la consulta

	.DESCRIPTION
		Esta función utiliza SQLite3 como gestor de base de datos y revuelve un objeto con la información encontrada.

	.PARAMETER Query
		La consulta SQL a la base de datos

	.PARAMETER Commands (Opcional)
		Comandos adicionales a pasar al gestor de la base de datos
		Para información de los comandos usados en SQLite3 visita https://www.sqlite.org/cli.html
	.EXAMPLE
	Ejemplo de uso con una busqueda escrita desde el script
		$data = Get-DbQuery -query "SELECT * FROM Programas WHRE name LIKE '%7-zip%'"

	Ejemplo de uso para ejecutar comandos dentro de sqlite3.exe
	(Es requerido pasar la primera variable sea sin o con contenido.)
		$query = "SELECT * FROM Programas WHERE name LIKE '%$appName%'"
		$commands = @"
	.headers on
	.separator ;
	$query;
	.quit
	"@
	#>
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true, Position = 0)]
		[string]$query,

		[Parameter(Mandatory = $false, Position = 1)]
		[string]$commands = ''
	)
	Process {

		$exeFile = $PSScriptRoot + "\sqlite3.exe"
		$dbFile = $PSScriptRoot + "\instalar.sqlite3"
		#Ubicación de un archivo temporal que obtiene la consulta desde SQLite
		#(se hace por problemas con caracteres especiales)
		$AnswerFile = ([string]$pwd).Split(":")[0] + ":/dbSQLiteTempData.txt"
		$exeFile = $PSScriptRoot + "\sqlite3.exe"

		$separator = "__chySep__" #Separador de columnas en la db
		$newLine = "__chyLn__" #Separador de entradas (lineas) en la db

		if (Test-Path -Path $AnswerFile -PathType Leaf) {
			#Verificación para eliminar el archivo temporal anterior si existe
			Remove-Item -Path $AnswerFile -Force
		}

		if ($commands -eq '') {
			#de no enviarse -command a la función, se devolverán los datos lo más limpias posibles como lo entrega la base de datos
			$commands = @"
.headers on
.output $AnswerFile
.separator $separator $newLine
$query;
.quit
"@
		}

		#Comando para ejecución
		$commands | & $exeFile $dbFile

		#botener datos
		$data = (Get-Content -Encoding UTF8 -Path $AnswerFile -Raw)
		#Separar las lineas
		$dataList = $data -split $newLine

		#obtener los nombres de los cabezotes
		$headers = $dataList[0] -split $separator

		$iLn = 0
		$data = @()
		#Columnas que se convertiran de TinyInt a boleano
		$tinyInt = @("openApp", "waitForApp", "freeSoft")
		#Columnas que de estar vacias, en cero o con valor nulo, pasan a ser $false
		$specialFalse = @("isoFile")

		#iteracion para obtener los datos de cada linea
		foreach ($row in $dataList) {
			#Omitir el primer contenido debido a que son los nombres de cada columna
			if (($iLn -eq 0) -or $row -eq "") {
				$iLn++
				continue
			}
			$iHdr = 0

			#Separar los datos de cada columna
			$colRowData = $row -split $separator
			$value = New-Object -TypeName psobject

			#generar los datos
			foreach ($header in $headers) {
				$header = $header.trim()
				$content = $null
				if ($colRowData[$iHdr] -ne "CHYNULL") {
					$content = $colRowData[$iHdr]
				}

				if ($tinyInt -Contains $header) {
					$content = [bool]([int]$content)
				}

				if ( ($specialFalse -Contains ($header)) -and ($null -eq $content -or $content -eq 0 -or $content -eq "0" -or $content -eq '')) {
					$content = $false
				}
				$value | Add-Member -MemberType NoteProperty -Name $header -Value $content
				$iHdr++
			}
			$data += $value
			$iLn++
		}

		if (Test-Path -Path $AnswerFile -PathType Leaf) {
			Remove-Item -Path $AnswerFile -Force
		}

		if ($data[$iLn] -eq '') {
			$data.remove($data[$iLn])
		}
		return $data
	}
}

function Get-dbAppData {
	Param(
		[Parameter(Mandatory = $false)]
		[string]$app = ''
	)
	#si se desean ver las aplicaciones en la base de datos escribir get-dbAllData sin ningún parametro

	if ($appName -eq '') {
		#Verificación de envío del nombre de la app para obtener datos
		Write-Host "`nNo se puede ejecutar este comando sin un nombre de aplicacion dentro de la DB `n`nEstas son las aplicaciones diponibles:`n"
		$sql = "SELECT name FROM programas"
		Get-DBq
		$apps = Get-DbQuery -query $sql
		Write-Output $apps.name
		Write-Output "`n"
		Pause
		exit
	}

	#Continuación luego de verificar el envío de datos
	$query = "SELECT * FROM Programas WHERE name like '%$app%'" #Consulta para obtener los todos los datos de las app

	#Si se solicita una app se debe devolver solo el objeto que contiene los datos, no un arreglo con los mismos
	$data = Get-DbQuery($query)
	if ($null -eq $data) {
		wError("No se encontró ningun dato en la base de datos para $app")
		Pause
		exit
	}
	if ($app -ne '') {
		return $data[0]
	} else {
		return $data
	}
}

#obtener el id (indetificador único)de una app
function get-db-id([string]$app) {
	$query = "SELECT id FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener el nombre de una app (redundante pero posible
function get-db-name([string]$app) {
	$query = "SELECT name FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener la version de una app
function get-db-ver([string]$app) {
	$query = "SELECT ver FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}


#obtener la pagina web de una app
function get-db-web([string]$app) {
	$query = "SELECT web FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener los comentarios de una app
function get-db-comments([string]$app) {
	$query = "SELECT comments FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener el nombre de archivo iso de una app
function get-db-isoFile([string]$app) {
	$query = "SELECT isoFile FROM Programas WHERE name like '%$app%'"
	$data = Get-DbQuery($query)
	if ($data.isoFile -eq 0) {
		$data.isoFile = $false
	} else {
		$data.isoFile = $true
	}
	return $data
}

#obtener la ruta y nombre del archivo iso de una app
function get-db-isoSrcPath([string]$app) {
	$query = "SELECT isoSrcPath FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener la ruta del archivo de instalacion (no el nombre del archivo) de una app
function get-db-instSrcPath([string]$app) {
	$query = "SELECT instSrcPath FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener el nombre del archivo de instalacion para aplicaciones de 32-bit de una app
function get-db-instFile_x86([string]$app) {
	$query = "SELECT instFile_x86 FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener el nombre del archivo de instalacion para sistemas de 64-bit de una app
function get-db-InstFile_x64([string]$app) {
	$query = "SELECT InstFile_x64 FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener argumentos para instalación silenciona de una app
function get-db-InstArgs([string]$app) {
	$query = "SELECT InstArgs FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener la codificacion requerida para el archivo de información para la instalación de una app (el archivo de información se debe colocar en una ubicación temporal para su uso)
function get-db-instInfFileEnc([string]$app) {
	$query = "SELECT instInfFileEnc FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener las variables (arreglo powershell en texto para ser procesador por iex) para cambiar en el archivo de información para la instalación de una app
function get-db-InstInfFileDataVars([string]$app) {
	$query = "SELECT InstInfFileDataVars FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}


#obtener los datos del archivo de información para la instalación de una app (el archivo de información se debe colocar en una ubicación temporal para su uso)
function get-db-InstInfFileData([string]$app) {
	$query = "SELECT InstInfFileData FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener la ruta de instalación final de una app
function get-db-instDir([string]$app) {
	$query = "SELECT instDir FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener los datos para almacenar en el registro de windows de una app
function get-db-regData([string]$app) {
	$query = "SELECT regData FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener las variales (arreglo powershell en texto para ser procesador por iex) a cambiar en de los datos para almacenar en el registro de windows de una app
function get-db-regDataVars([string]$app) {
	$query = "SELECT regDataVars FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}


#obtener un comando que se debe ejecutar luego de la instalación de una app
function get-db-commRunAfterInst([string]$app) {
	$query = "SELECT commRunAfterInst FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener un comando a ejecutar antes abrirla automáticamente para una app
function get-db-commRunBeforeOpen([string]$app) {
	$query = "SELECT commRunBeforeOpen FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener el nombre del archivo para abrir de una app luego de instalarla
function get-db-runFileApp([string]$app) {
	$query = "SELECT runFileApp FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener la ruta para abrir de una app luego de instalarla
function get-db-runFileAppPath([string]$app) {
	$query = "SELECT runFileAppPath FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener si debe o no abrir luego finalizada la instalación de la app
function get-db-openApp([string]$app) {
	$query = "SELECT openApp FROM Programas WHERE name like '%$app%'"
	$data = Get-DbQuery($query)
	if ($data.openApp -eq 0) {
		$data.openApp = $false
	} else {
		$data.openApp = $true
	}
	return $data
}

#obtener si debe o no esperar a que se cierre una app luego de la instalación
function get-db-waitForApp([string]$app) {
	$query = "SELECT waitForApp FROM Programas WHERE name like '%$app%'"
	$data = Get-DbQuery($query)
	if ($data.waitForApp -eq 0) {
		$data.waitForApp = $false
	} else {
		$data.waitForApp = $true
	}
	return $data
}

#obtener la ruta donde se guarda el archivo de preferencias de una app
function get-db-appPrefsFilePath([string]$app) {
	$query = "SELECT appPrefsFilePath FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener el nombre del archivo de preferencias de una app
function get-db-appPrefsFileName([string]$app) {
	$query = "SELECT appPrefsFileName FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener la codificacion del archivo de preferencias de una app
function get-db-appPrefsFileEnc([string]$app) {
	$query = "SELECT appPrefsFileEnc FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener los datos del archivo de preferencias de una app
function get-db-appPrefsFileData([string]$app) {
	$query = "SELECT appPrefsFileData FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}
#obtener las variables (arreglo powershell en texto para ser procesador por iex) para cambiar en el archivo de preferencias de una app
function get-db-appPrefsFileDataVars([string]$app) {
	$query = "SELECT appPrefsFileDataVars FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}


#obtener la ruta donde se encuentra el archivo de crack de una app
function get-db-appCrkSrc([string]$app) {
	$query = "SELECT appCrkSrc FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener la ruta de destino donde se coloca el archivo de crack de una app
function get-db-appCrkDestPath([string]$app) {
	$query = "SELECT appCrkDestPath FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener el nombre de archivo de destino para el crack de una app
function get-db-appCrkDestFileName([string]$app) {
	$query = "SELECT appCrkDestFileName FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener la codificación del archivo de destino para el crack de una app
function get-db-appCrkDestFileEnc([string]$app) {
	$query = "SELECT appCrkDestFileEnc FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener los datos del archivo de crack de una app
function get-db-appCrkDestData([string]$app) {
	$query = "SELECT appCrkDestData FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

#obtener las variables (arreglo powershell en texto para ser procesador por iex) para cambiar en el archivo de crack de una app
function get-db-appCrkDestDataVars([string]$app) {
	$query = "SELECT appCrkDestDataVars FROM Programas WHERE name like '%$app%'"
	return Get-DbQuery($query)
}

function get-db-freeSoft([string]$app) {
	$query = "SELECT freeSoft FROM Programas WHERE name like '%$app%'"
	$data = Get-DbQuery($query)
	if ($data.openApp -eq 0) {
		$data.openApp = $false
	} else {
		$data.openApp = $true
	}
	return Get-DbQuery($data)
}
