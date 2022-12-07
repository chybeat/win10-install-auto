<# Advanced IP Scanner
====================#>

$app = get-dbAppData('Advanced IP Scanner')
install-app($app)

while (Get-Process -Name "advanced_ip_scanner" -ErrorAction SilentlyContinue) {
	taskkill /IM $app.runFileApp /F | Out-Null
	Start-Sleep -Seconds 2
}

if ($app.RegDataVars) {
	$app.RegData = Set-PassedVar -vars $app.RegDataVars -replace $app.RegData
}
set-Reg($app.RegData)
