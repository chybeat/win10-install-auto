<# Microsoft Office 2019
======================#>
if (!$freeSoft) {
	$app = get-dbAppData('Microsoft Office')

	#Generación de variables según Arquitectura
	if ($x86) {
		$arch = 'x86'
		$app.isoFile = $app.instFile_x86
        $channel = "Current (Retail/RTM)"
        $version = "2019-2021"
        $exactVersion = "2021"
        werror("SI SE BLOQUEA AL 50% DE LA INSTALACIÓN, CERRAR LOS PROCESOS 'officeclicktorun' CUANDO SUCEDA!")
	} else {
		$arch = 'x64'
		$app.isoFile = $app.instFile_x64
        $channel = "Current (Retail/RTM)"
        $version = "2019-2021"
        $exactVersion = "2021"
	}

	#Se debe cambiar este nombre de archivo ya que en la base de datos instFile_x??
	#pertenece al nombre del archivo iso
	$app.instFile_x86 = "oInstall.exe"
	$app.instFile_x64 = "oInstall.exe"

	$app.comments = $app.comments.replace("%arch%", $arch)
	$app.comments = $app.comments.replace("%channel%", $channel)
	$app.comments = $app.comments.replace("%version%", $version)
	$app.comments = $app.comments.replace("%exactVersion%", $exactVersion)
	$app.instDir = Get-EnvPS($app.instDir)
	$app.runFileAppPath = Get-EnvPS($app.runFileAppPath)

    get-service -name "Spooler" | stop-service

	install-app($app)
	@(
		"Office Automatic Updates 2.0"
		"Office Feature Updates"
		"Office Feature Updates Logon"
		"Office Performance Monitor"
		"OfficeTelemetryAgentFallBack2016"
		"OfficeTelemetryAgentLogOn2016"
	) | ForEach-Object {
		Remove-SchdTask -task $_ -Folder "\Microsoft\Office"
	}
	Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Common]
        "PrivacyNoticeShown"=dword:00000002
        "SplashScreenLicense"=dword:00000002
        "UI Theme"=dword:00000003
	')
}
