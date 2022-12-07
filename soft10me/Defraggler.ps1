<# Defraggler v2.2.2
==================#>
$app = get-dbAppData('Defraggler')
install-app($app)

#Conversion de variables de entorno
$app.RegData = Get-EnvPS($app.RegData)
$app.appPrefsFileData = Get-EnvPS($app.appPrefsFileData)


#al ser de 64-bit el SO se requiere cambiar un nombre
if ($x64) {
	$app.RegData = $app.RegData.replace("Defraggler.exe", "Defraggler64.exe")
	$app.appPrefsFileData = $app.appPrefsFileData.replace("defraggler.exe", "defraggler64.exe")
}

wRun("Corrigiendo configuración adicional del Defraggler")
Set-Reg($app.RegData)
set-prefsFile(@{
		file = $app.appPrefsFileName
		path = $app.appPrefsFilePath
		enc  = $app.appPrefsFileEnc
		data = $app.appPrefsFileData
	})
wOK("Terminada la instalación de Defraggler")
