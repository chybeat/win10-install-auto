<# LibreOffice v7.3.0.3
======================#>
$app = get-dbAppData('LibreOffice')

WTitulo("Instalación de " + $app.name + " " + $app.ver)
$arch = if ($x64) { "x64" } else { "x86" }
$instFile = "instFile_" + $arch
$instFile = $app.$instFile
#Si la instalación es softwarelibre se registran los programas de office para apertura
if ($freeSoft) {
	$app.InstArgs = $app.InstArgs + " REGISTER_ALL_MSO_TYPES=1 SELECT_WORD=1 SELECT_EXCEL=1 SELECT_POWERPOINT=1"
}

#Instalación del programa
$path = ((get-Path -Filename $instFile -Limit 1 -path $app.instSrcPath))
$arguments = '/i "' + $path + "\" + $instFile + '" /passive /norestart ' + $app.InstArgs

wRun("Ejecutando el instalador de " + $app.name)
Start-Process "msiexec.exe" -ArgumentList $arguments -Wait

#Archivos de ayuda offline de libreoffice
$instFile = $app.appCrkSrc.Replace("?", $arch)
$path = ((get-Path -Filename $instFile -Limit 1 -path $app.instSrcPath))
wRun("Instalando ayuda de " + $app.name)
$arguments = '/i "' + $path + "\" + $instFile + '" /passive /norestart'
Start-Process "msiexec.exe" -ArgumentList $arguments -Wait

#complemento de seguridad gpg4win
wRun("Instalando complemento " + $app.appCrkDestFileName)
Start-Process ($path + "\" + $app.appCrkDestFileName) -ArgumentList "/S" -Wait

wRun("Copiando archivo de preferencias de " + $app.name)
set-prefsFile(@{
		file = $app.appPrefsFileName
		path = (get-EnvPS($app.appPrefsFilePath))
		enc  = $app.appPrefsFileEnc
		data = $app.appPrefsFileData
	})

wRun("Ejecutando limpieza")
Set-Reg('
-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\GpgEX]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\GpgEX]
')
