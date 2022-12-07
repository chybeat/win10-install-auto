Clear-Host
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Write-Host "Se ejecutará como administraador."
	Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
	Exit
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


$PackageName = "VSCode_installer"
$InstallerType = "exe"
$InstallInfFileName = "inst.inf"
$urlx64 = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
$urlx86 = "https://code.visualstudio.com/sha/download?build=stable&os=win32"
$url = (& { If ($env:processor_architecture -eq "x86") { $urlx86 } Else { $urlx64 } })


$installerFile = "$PackageName" + "." + "$InstallerType"
$UnattendedArgs = "/SP- /SILENT /MERGETASKS=!runcode /LOADINF=${InstallInfFileName}"
$installPath = "${env:ProgramFiles}\Microsoft VS Code"
$usersPath = "${env:APPDATA}\Code\User"

'[Setup]
Lang=spanish
Dir='+ ${InstallPath} + '
Group=Visual Studio Code
NoIcons=0
Tasks=addcontextmenufiles,associatewithfiles,addtopath
' | Out-File -Force $InstallInfFileName

@(
	"${env:APPDATA}\Code",
	"${env:LOCALAPPDATA}\Code",
	"${env:USERPROFILE}\.vscode",
	"$installPath"
) | ForEach-Object {
	if (Test-Path $_) {
		Remove-Item -Path ($_) -Force -Recurse
	}
}

Set-Location $PSScriptRoot
Write-Verbose "Downloading Vscode" -Verbose
Invoke-WebRequest -Uri $url -OutFile $installerFile

Write-Verbose "Starting Installation of VScode" -Verbose
Start-Process "$installerFile" $UnattendedArgs -Wait -PassThru

Start-Process -FilePath ("${installPath}\code.exe") | Out-Null
Start-Sleep -Seconds 5
While (Get-Process -Name "Code" -ErrorAction SilentlyContinue) {
	Get-Process -Name "Code" -ErrorAction SilentlyContinue | Stop-Process
	Start-Sleep -Seconds 1
}

Write-Verbose "Customization" -Verbose
Write-Verbose "Install extensions" -Verbose
@(
	'ms-vscode.powershell',
	'esbenp.prettier-vscode',
	'PKief.material-icon-theme',
	'shd101wyy.markdown-preview-enhanced',
	'Tyriar.sort-lines',
	'fabianlauer.vs-code-xml-format'
) | ForEach-Object {
	$run = 'code --install-extension ' + $_ + ' --force'
	cmd /c $run | Out-Null
	Write-Verbose "Installing extension ${_}... Please wait" -Verbose
	while (Get-Process -Name "Code" -ErrorAction SilentlyContinue) {
		Start-Sleep -Seconds 3
		Get-Process -Name "Code" -ErrorAction SilentlyContinue | Stop-Process
	}

}

Write-Verbose "Copy configurations" -Verbose

[System.Collections.ArrayList]$settingsFiles = @()
$settingsFiles.Add([PSCustomObject]@{'file' = "settings.json"; "location" = "$usersPath" }) | Out-Null
$settingsFiles.Add([PSCustomObject]@{'file' = "powershell.json"; "location" = ("${usersPath}\snippets") }) | Out-Null

$settingsFiles | ForEach-Object {
	Write-Output ("Copying " + $_.file) -Verbose
	$source = $_.file
	$dest = $_.location + "\" + $_.file
	Copy-Item -Path "${source}" -Destination "${dest}" -Force
}

Remove-Item $installerFile -Force
Remove-Item $InstallInfFileName -Force

new-link -dest ("%ProgramData%\Microsoft\Windows\Start Menu\Programs") -name "Visual Studio Code" -source ("${installPath}\code.exe") -Admin
New-link -dest ("${env:Public}\Desktop") -name "Visual Studio Code" -source ("${installPath}\code.exe") -Admin

Set-Location $PSScriptRoot
Start-Process code -ArgumentList "W10-setup.code-workspace" -NoNewWindow
