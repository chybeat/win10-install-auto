<#

ESTA FUNCION NO ES POSIBLE REALIZARLA ES MUY COMPLEJO!

function Get-Encoding {
	param
	(
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]
		$Path
	)

	process {
		if (-not (Test-Path -Path $path -PathType Leaf)) {
			Write-Error "No se ha encontrado el archivo `"${path}`"" -CategoryReason "Invalid File path" -CategoryTargetName "Path" -CategoryTargetType " File not found " -Category InvalidData -CategoryActivity "Searching"
			exit
		}
		$reader = [System.IO.StreamReader]::new(
			$path, [System.Text.Encoding]::default, $true)
		#		$reader.Peek() | Out-Null

		while (!$reader.EndOfStream) {
			$null = $reader.ReadLine()
		}
		$data = $reader.CurrentEncoding | Select-Object CodePage, bodyname, encodingname
		$data
		$reader.close()
		#		$data = Get-TextFileEncodings -Encoding $data.CodePage -by CodePage -FullAnswer
		#		preprint($data)
		#us-ascii = utf8 no bom
		#	$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
		#	[System.IO.File]::WriteAllLines($Destino, $Datos, $Utf8NoBomEncoding)

		#	$enc = [System.Text.Encoding]::GetEncoding($_)
		#	[System.IO.File]::WriteAllLines($Destino, $Datos, $enc)

		#iso-8859-1 = Windows 1252

		#salidas admitidas por Out-File
		#ascii
		#bigendianunicode
		#oem
		#string
		#unicode
		#utf32
		#utf7
		#utf8
	}
}
#>


function Get-TextFileEncodings {
	<#
	.SYNOPSIS
	Función que devuelve un objeto con los datos de una codificación enviada

	.DESCRIPTION
	Función que devuelve un arreglo de objetos de una o varias codificaciones, esto depende de lo que se pase en el parámetro "-Encoding" (Ej: -Encoding "UTF8"), ya que cualquier coincidencia en el Code Page, Name o DisplayName se devolverá. Esos tres parametros (Code Page, Name y DisplayName) serán devueltos en un arreglo de objetos.

	Al no pasarse ningún nombre de codificación ($Encoding) se devuelve un bojeto con la lista de todas las codificaciones existentes para Windows

	[System.Text.Encoding]::GetEncodings()
	Función de .Net que se utiliza para obtener el listado de las codificaciones
	soportadas por Windows

	.PARAMETER Encoding
	La codificación a buscar, Se buscará en Name Displayname y CodePage si no se especifica ninguno en cual buscar en By

	.PARAMETER By
	Criterio de busqueda de la codificación, admite uno de los 3 elementos por los cuales se buscará la codificación pasada en -Encoding. Se admite: CodePage, Name y Displayname

	.PARAMETER FullAnswer
	Al activarse este switch, se devolverá un arreglo de objetos que contendrán todas las coincidencias con los tres atributos (Code Page, Name y DisplayName). De no colocarse, se devolverá un arreglo con todas las coincidencias o un string si solo se encuentra una.

	#>
	param(
		[string]
		$Encoding = "",

		[string]
		[ValidateSet("CodePage", "Name", "Displayname")]
		$By = $False,

		[switch]
		$FullAnswer = $false
	)

	process {
		$EncodingFound = @()

		$EncodingList = [System.Text.Encoding]::GetEncodings()
		if ($Encoding -eq "") {
			return $EncodingList
		}

		$EncodingList | ForEach-Object {

			#Comparacion con $by = CodePage
			if ($By -eq "CodePage") {
				if ($_.CodePage -eq $Encoding) {
					$EncodingFound += , $_
				}
			} elseif ($By -eq "Name") {
				if (($_.Name -like $Encoding) -or (($_.Name -replace ('[^a-zA-Z0-9]', '')) -match ($Encoding -replace ('[^a-zA-Z0-9]', '')))) {
					$EncodingFound += , $_
				}
			} elseif ($By -eq "Displayname") {
				if (($_.DisplayName -like $Encoding) -or ($_.DisplayName -replace ('[^a-zA-Z0-9]', '') -match ($Encoding -replace ('[^a-zA-Z0-9]', '')))) {
					$EncodingFound += , $_
				}
			}
		}

		if ($EncodingFound.length -eq 0) {
			if ($By -eq "False") {
				[string]$By = "By not present and required"
			}
			Write-Error "No se ha encontrado ninguna coincidencia para `"${enc}`"" -CategoryReason "Invalid Encoding information" -CategoryTargetName "${by}" -CategoryTargetType " not found ${Encoding}" -Category InvalidData -CategoryActivity "Searching"
			exit
		}

		if (!$FullAnswer) {
			return $EncodingFound.${By}
		}
		return $EncodingFound
	}
}
