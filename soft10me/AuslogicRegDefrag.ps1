<# Auslogic Registry Defrag v12.4.0.2
===================================#>
$app = get-dbAppData("Auslogic Registry Defrag")
install-app($app)

while ((Get-Process -Name "integrator" -ErrorAction SilentlyContinue).ProcessName) {
	cmd /c "taskkill.exe /IM integrator.exe /f" | Out-Null
	Start-Sleep -s 3
}
Wrun("Ejecutando limpieza de " + $app.Name)
Set-Reg($app.regData)

$SchedulePathTree = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree"
$SchedulePathTask = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks"

$user = [System.Environment]::UserName

if (Test-Path -LiteralPath "Registry::$SchedulePathTree") {
	$idTask = Get-ItemPropertyValue -Path ("Registry::$SchedulePathTree\Auslogics\Registry Defrag\Start Registry Defrag on " + $user + " logon") -Name id
	$pattern = '[^A-Z0-9{}-]'
	$idTask = $idTask -replace $pattern, ""
}

set-reg("
-[${SchedulePathTask}\${idTask}]
-[${SchedulePathTree}\Auslogics]
")
