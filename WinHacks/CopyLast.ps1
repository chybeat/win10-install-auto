<################
# COPIA DE LAST #
################>

wTitulo("Copiando Last")
$dest = "$env:SystemDrive\Last"

If (!(Test-Path $dest -PathType Container)) {
	New-Item -Path $dest -Force -ItemType Directory | Out-Null
} else {
	Remove-Item -Path $dest\* -Recurse -Force
}
wRun("Comprimiendo los archivos")

#Archivos que se deben copiar a la carpeta last puesto que posiblemente son actualizados fuera de last (lib en general)
$updateList = @(
	#\lib
	#'lib\force-mkdir.psm1', Posiblemente no se requiere
	'lib\PsExec.exe',
	'lib\PsExec64.exe',
	'lib\instalar.sqlite3',
	'lib\sqlite3.exe',
	'lib\pcb-Add-To-Reg.psm1',
	'lib\pcb-Take-own.psm1',
	'lib\pcb-Write-to-user.psm1',
	'lib\pcb-dbSqlite3.psm1',
	'lib\pcb-install-App.psm1',
	'lib\pcb-win10_install_main_module.psm1' # Archivo principal de funciones
)
#pcb-file-encoding.psm1 Omitido


foreach ($file in $updateList) {
	$sourceFile = "${PSSCriptRoot}\..\${file}"
	$destFile = "${PSSCriptRoot}\..\Last\${file}"

	if (Test-Path -Path $destFile -PathType Leaf) {
		Remove-Item $destFile -Force
	}
	Copy-Item -Path $sourceFile -Destination $destFile -Force
}
#Archivos requeridos para iniciar la ejecución mínima de last antes de descomprimir
$excludeZip = @(
	#'force-mkdir.psm1,'
	'last.cmd',
	'run_last.ps1',
	'wInstall.7z',
	'pcb-Add-To-Reg.psm1',
	'pcb-Take-own.psm1',
	'pcb-Write-to-user.psm1',
	'pcb-dbSqlite3.psm1',
	'pcb-install-App.psm1',
	'pcb-win10_install_main_module.psm1'
)

#Destino de archivo y argumentos de 7-zip

$zipFile = "$env:SystemDrive\Last\wInstall.7z"
$arguments = "a -t7z `"$zipFile`" `"$PSSCriptRoot\..\Last\*`" -pwInstall -r -y -mx9 -mhe=on -mtm=off -mtc=off -mta=off -mtr=off -xr!`"" + ($excludeZip -join ("`" -xr!`"")) + "`""

#Copresión del archivo
if (Test-Path -Path $zipFile -PathType Leaf) {
	Remove-Item -Path $zipFile -Force
}

Start-Process ("${env:ProgramFiles}\7-Zip\7z.exe") -ArgumentList $arguments -Wait -WindowStyle Hidden

wRun("Copiando los archivos excluidos")
$excludeZip | ForEach-Object {
	$filename = $_
	(Get-ChildItem -Path ($PSSCriptRoot + "\..\Last\") -Recurse) | ForEach-Object {
		if ($_.name -eq $filename) {
			$destFile = $dest + "\"
			$destFile += (($_.DirectoryName).Substring(($_.DirectoryName).LastIndexOf("\Last") + 5) + "\" + $filename).Trim("\")
			$path = Split-Path -Path $destFile -Parent
			if (!(Test-Path -Path $path -PathType Container)) {
				New-Item -Path $path -Force -ItemType Directory | Out-Null
			}
			Copy-Item ($_.DirectoryName + "\" + $_.name) -Force -Destination $destFile -Recurse
		}
	}
}

wOk("Copia terminada")
