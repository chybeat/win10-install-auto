<#==============
= HWiNFO v6.26 =
==============#>

$app = get-dbAppData('hwinfo')

#al ser de 64-bit el SO se requiere cambiar datos
$infoUpdate = (
	"InstInfFileData",
	"instDir",
	"runFileApp",
	"appPrefsFilePath",
	"appPrefsFileName"
)
foreach ($info in $infoUpdate) {
	$arch = "32"
	if ($x64) {
		$arch = "64"
	}
	$app.$info = $app.$info.replace("?", $arch)
}

install-app($app)

while (Get-Process -Name HWiNFO*) {
	Wait-Process -Id (Start-Process "taskkill.exe" -PassThru -ArgumentList "/FI `"IMAGENAME eq HWiNFO*`"").id
	Start-Sleep -s 1
}

#Conversion de variables de entorno
$app.appPrefsFileData = get-EnvPs($app.appPrefsFileData)

wRun("Corrigiendo configuración adicional de HWiNFO")


set-Reg($app.regData)

set-prefsFile(@{
		file = $app.appPrefsFileName
		path = $app.appPrefsFilePath
		enc  = $app.appPrefsFileEnc
		data = $app.appPrefsFileData
	})
wOK("Terminada la configuración de HWiNFO")
