##########
# tweaks #
##########

#cambiando nombre de computador por nombre de usuario
$MaxCN = 12
$name = $env:USERNAME -replace ('[^a-zA-Z0-9]', "")

if ($name.length -lt $MaxCN) {
	$MaxCN = $name.length
}

if (Test-IsLaptop) {
	$name = "LP-" + $name.Substring(0, ($MaxCN))
} else {
	$name = "PC-" + $name.Substring(0, $MaxCN)
}

if ($name -ne $env:COMPUTERNAME) {
	wRun("Cambiando nombre del computador por " + $name)
	Rename-Computer -NewName $name -Force -WarningAction SilentlyContinue
}
wRun("Aplicando datos de teclado e idioma...")
$LanguageList = Get-WinUserLanguageList
Set-WinUserLanguageList $LanguageList -Force


#Ejecución de aplicaciones

#Haciendo pausa por error en explorer.exe
Start-Sleep 2


wTitulo("Ejecutando aplicaciones")
wRun("Abriendo configuración de protector de pantalla")

Start-Process control -ArgumentList 'desk.cpl,,@Screensaver'


if ($x86) {
	$ProgramFilesRun = ${env:ProgramFiles}
} else {
	$ProgramFilesRun = ${env:ProgramFiles(x86)}
}

wRun("Abriendo y esperando por Ultimate Windows Tweaker`nLa ruta del archivo requerido se ha copiado al portapapeles")
Set-Clipboard -Value ($PSScriptRoot + "\uwt_22H2.ini")
Start-Process "$ProgramFilesRun\Ultimate Windows Tweaker\Ultimate Windows Tweaker 4.8.exe" -Wait

set-Reg('[-HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]')

wRun("Colocando la configuracion de 0&0 Shutup para configurar Windows")
$file = ($PSScriptRoot + "\ooShutUp_W1022H2.cfg")
Start-Process "$ProgramFilesRun\O&O ShutUp10\OOSU10.exe" -ArgumentList "/quiet", "$file" -Wait
