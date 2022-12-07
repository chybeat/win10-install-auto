<# K-Lite Codec Pack v15.5.0
==========================#>

$app = get-dbAppData("k-lite")

if ($x86) {
	$app.runFileAppPath = "${env:ProgramFiles}\K-Lite Codec Pack\MPC-HC"
	$app.runFileApp = 'MPC-HC\mpc-hc.exe'
	$app.appPrefsFileName = 'mpc-hc.ini'
	$app.appPrefsFilePath = "${env:ProgramFiles}\K-Lite Codec Pack\MPC-HC"
} else {
	$app.runFileAppPath = "${env:ProgramFiles(x86)}\K-Lite Codec Pack\MPC-HC64"
	$app.runFileApp = 'MPC-HC64\mpc-hc64.exe'
	$app.appPrefsFileName = 'mpc-hc64.ini'
	$app.appPrefsFilePath = "${env:ProgramFiles(x86)}\K-Lite Codec Pack\MPC-HC64"
}
install-app($app)
