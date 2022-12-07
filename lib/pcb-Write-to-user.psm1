#Funciones para mostrar mensajes en colores
function wError {
	<#
	.SYNOPSIS
		Mostar un texto de error

	.DESCRIPTION
		Muestra un texto con fondo negro y letras rojas simbolizando un error

	.PARAMETER Text
		El texto a mostrar en formato de error
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Text
	)
	process {
		Write-Host -ForegroundColor red -BackgroundColor Black $Text
		Write-Host ""
	}
}

function wInfo {
	<#
	.SYNOPSIS
		Mostar un texto informativo

	.DESCRIPTION
		Muestra un texto normal, sin formato

	.PARAMETER Text
		El texto a mostrar en formato de información
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Text
	)
	process {
		Write-Host $Text
		Write-Host ""
	}
}

function wOk {
	<#
	.SYNOPSIS
		Mostar un texto en formato de ejecución exitosa

	.DESCRIPTION
		Muestra un texto con letras verdes indicando una ejecución exitosa

	.PARAMETER Text
		El texto a mostrar en formato de ejecución
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Text
	)
	process {
		Write-Host -ForegroundColor Green $Text
		Write-Host ""
	}
}

function wRun {
	<#
	.SYNOPSIS
		Mostar un texto en formato de ejecución

	.DESCRIPTION
		Muestra un texto con letras amarillas indicando una ejecución

	.PARAMETER Text
		El texto a mostrar en formato de ejecución
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Text
	)
	process {
		Write-Host -ForegroundColor Yellow $Text
		Write-Host ""
	}
}

function WTitulo {
	<#
	.SYNOPSIS
		Mostar un texto en formato relevante

	.DESCRIPTION
		Muestra un texto con fondo negro y letras blancas indicando relevancia

	.PARAMETER Text
		El texto a mostrar en formato relevante
	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Text
	)
	process {
		Write-Host ""
		Write-Host -ForegroundColor White -BackgroundColor Black $Text.ToUpper()
		Write-Host ""
		Write-Host ""
	}
}
function Preprint {
	<#
	.SYNOPSIS
		Mostrar el elemento e información de ejecución

	.DESCRIPTION
		Muestra un elemento enviado y la ubicación donde se solicitó la ejecución de la función

	.PARAMETER Text
		Un texto o resultado que se mostrará en la ejecución
	#>
	param(
		$Data
	)
	process {
		#write-host ($MyInvocation | Format-List | Out-String)
		$file = Split-Path $MyInvocation.ScriptName -Leaf
		$line = $MyInvocation.ScriptLineNumber
		if ($null -ne $Data) {
			$type = $Data.GetType().Name
		} else {
			$type = "NULL"
		}
		#$test = $data.GetType() | Format-List | Out-String;
		#write-host ${type};

		$command = $MyInvocation.Line.Trim()
		$width = (Get-Host).UI.RawUI.MaxWindowSize.Width
		$separatorBlock = '_' * $width
		$separatorLine = '*' * $width

		if (($type -eq "String") -or ($type -eq "Char")) {
			$Data = $Data.Trim()
			if ('' -eq $Data) {
				$Data = "(EMPTY)"
			}
		}

		if (($type -ne 'Single', 'Double', 'Decimal', 'Char', 'Boolean', 'String', 'Int32', 'Int64')) {
			$Data = ($Data | Format-List | Out-String)
		}

		Write-Host -ForegroundColor Cyan ${separatorBlock}
		Write-Host -ForegroundColor Cyan "File: ${file} (ln ${line}) - ${type}"
		Write-Host -ForegroundColor Cyan "Command: ${command}"
		Write-Host -ForegroundColor Cyan ${separatorLine}
		Write-Host -ForegroundColor Red $Data `n
		Write-Host -ForegroundColor Cyan ${separatorLine}
	}
}
