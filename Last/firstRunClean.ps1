#MicrosoftEdgeAutoLaunch_4473ADDAFFF2985A45FA0E357286A61D -> "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --no-startup-window --win-session-start /prefetch:5

#eliminación de posibles autoejecutables residuales
wRun("Eliminando aplicaciones de inicio automatico")
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Last"=-
"Acrobat Assistant 8.0"=-
"AdobeAAMUpdater-1.0"=-
"AdobeGCInvoker-1.0"=-
"Enfocus Subscription Notifier"=-
"SunJavaUpdateSched"=-

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Last"=-
"AdobeBridge"=-
"CCXProcess"=-
"OneDrive"=-
"Skype for Desktop"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run]
"Last"=-
"Acrobat Assistant 8.0"=-
"Enfocus Subscription Notifier"=-
"Opera Browser Assistant"=-
"SunJavaUpdateSched"=-

')

#Cerrando y eliminando ejecución automática de Microsoft Edge
wInfo("Eliminando ejecución automática de Microsoft Edge")
$run = $true
while ($run) {
	if (Get-Process | Where-Object -Property processName -ilike "*edge*") {
		Get-Process | Where-Object -Property processName -ilike "*edge*" | Stop-Process
		Start-Sleep -Seconds 2
	} else {
		$run = $false
	}
}

$regPath = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\run"
Get-Item -LiteralPath "Registry::${regpath}" | Select-Object -ExpandProperty Property | ForEach-Object {
	if ($_ -ilike "*edge*") {
		set-reg('[' + $regPath + ']
		'+ $_ + '=-
		')
	}
}

#Eliminado tareas automáticas de cCleaner
<#
>>>>> Estas tareas se crean automáticamente cada vez que se abre el programa
tareas programadas
Ccleaner crasj reporting
#>
