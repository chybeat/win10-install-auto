<# Java Runtime
=============#>

$app = get-dbAppData('Java Runtime')
$app.name = $app.name + " de 32-bit"
install-App($app)

if ($x64) {
	$app = get-dbAppData('Java Runtime')
	$app.InstFile_x64 = $app.InstFile_x86
	$app.name = $app.name + " de 64-bit"
	install-App($app)
}

Set-reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"SunJavaUpdateSched"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run]
"SunJavaUpdateSched"=-
')
