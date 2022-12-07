wRun("Comprobando estado de activación. Espera...")

#Verificacion de estado de licencia (Omitido ya que siempre debe esta no activado...)
#$activatedWin = (Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | where { $_.PartialProductKey } | select LicenseStatus).LicenseStatus

$service = Get-WmiObject -Class SoftwareLicensingService -ComputerName $env:computername
$winKey = $service.OA3xOriginalProductKey

if ("" -ne $winKey) {
	WRun ("Intentando la activación en línea... `n`n")
	cscript /b "$env:Windir\System32\slmgr.vbs" /ato

	###Intento de activación automática con licencia digital en hardware#
	Start-Process -FilePath "$PSScriptRoot\HWID_Activation.cmd" -ArgumentList '/HWID /S'

	wInfo('Se ha encontrado una licencia digital terminada en: ' + ($winKey.split("-")[-1]))

	#Si no se ha activado se pasará a la activación manual
	wInfo("Al abrirse la ventana de activación pega la licencia (ya se ha copiado al portapapeles),`nluego da click en 'Siguiente' y luego en 'Activar'")
	Pause
	Set-Clipboard -Value $winKey
} else {
	$winKey = get-pcbReg -name 'OwnWinKey'
}

if (($winKey -eq $true) -or ($winKey.length -gt 24)) {
	slui
	Start-Sleep -s 5
	Wait-Process -Name SystemSettings
}
#Activación en linea de Windows y office de modo automático, si Windows ya está activado se omite y solo activa office
$Status = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object PartialProductKey).licensestatus

if ($Status -eq "1") {
	#Si Windows esta activado NO debe realizar la activación desde tarea automatica en el programador de tareas.
	$argsRenewal = '/KMS-Windows'
} else {
	$argsRenewal = '/KMS-WindowsOffice'
}
$argsRenewal += ' /KMS-RenewalTask'

wRun('Verificando activación. Espera...')
<#
Con Export-ScheduledTask Activation-Renewal | out-file D:\task.xml
se extrae la tarea programada y se puede colcoar esa información dentro del archivo Activate.cmd, verificar siempre que se actualice MAS

La ultima version colocada es la 1.7
#>
wRun('Activando y aplicando un temporizador de verificación. Espera...')
Start-Process -FilePath "$PSScriptRoot\Activate.cmd" -WindowStyle Hidden -ArgumentList $argsRenewal -Wait

wOk("Herramienta de activación finalzada.")
