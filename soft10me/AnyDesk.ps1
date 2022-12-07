<# AnyDesk
=================#>
$app = get-dbAppData("AnyDesk")
install-app($app)

while ((Get-Process -Name "Anydesk" -ErrorAction SilentlyContinue).ProcessName) {
	cmd /c "taskkill.exe /IM Anydesk.exe /f" | Out-Null
	Start-Sleep -s 1
}
wRun("Terminando de configurar AnyDesk")
Start-Sleep -s 5

new-link -dest ("%ProgramData%\Microsoft\Windows\Start Menu\Programs") -name "AnyDesk" -source ("%ProgramFiles%\Anydesk\AnyDesk.exe") -Admin
New-link -dest ("${env:Public}\Desktop") -name "AnyDesk" -source ("%ProgramFiles%\Anydesk\AnyDesk.exe") -Admin

$unnecesaryFiles = @(
	"$env:ProgramData\AnyDesk\ad_svc.trace",
	"$env:ProgramData\AnyDesk\service.conf",
	"$env:ProgramData\AnyDesk\system.conf",
	"$env:ProgramData\AnyDesk\user.conf",

	"$env:AppData\AnyDesk\ad_svc.trace",
	"$env:AppData\AnyDesk\service.conf",
	"$env:AppData\AnyDesk\system.conf",
	"$env:AppData\AnyDesk\user.conf"
)

wRun("Eliminacion de archivos no necesarios")

foreach ($file in $unnecesaryFiles) {
	if (Test-Path -Path $file -PathType Leaf) {
		wInfo("Eliminando $file...")
		Remove-Item -Path $file -Force
	}
}
wOk("Eliminación de archivos no necesarios terminada")


set-prefsFile(@{
		file = $app.appPrefsFileName
		path = $app.appPrefsFilePath
		enc  = $app.appPrefsFileEnc
		data = $app.appPrefsFileData
	})

wOK("AnyDesk Totalmente configurado")
