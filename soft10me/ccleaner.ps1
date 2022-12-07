<# Ccleaner v5.67
===============#>

$app = get-dbAppData("cCleaner")
Install-App($app)

if ($x86) {
	$app.runFileApp = $app.runFileApp.Replace("?", "")
} else {
	$app.runFileApp = $app.runFileApp.Replace("?", "64")
}

while ((Get-Process -Name "CCleaner" -ErrorAction SilentlyContinue).ProcessName) {
	cmd /c "taskkill.exe /IM " + $app.runFileApp + " /f" | Out-Null
	Start-Sleep 1
}

Set-Reg($app.regData)

wRun("Ejecutando Optimización de Ccleaner...")

#eliminación de la tarea progrmada de ccleaner
@(
	"CCleaner Update",
	"CCleanerCrashReporting" #Se crea automáticamente de nuevo cada vez que se abre el programa
) | ForEach-Object {
	Remove-SchdTask -task $_
}

#Eliminación de las opciones del menú contextual en la papelera de reciclaje
(Get-ChildItem "Registry::HKEY_CLASSES_ROOT\CLSID" -Include "*CCleaner*" -Recurse) | ForEach-Object {
	Set-Reg('-[' + $_.Name + ']')
}

#Agregando Ccleaner al firewall
Block-InFirewall -Path (Get-EnvPS "${env:ProgramFiles}\CCleaner") -Extension "exe"
Block-InFirewall -Path (Get-EnvPS "${env:ProgramFiles(x86)}\CCleaner") -Extension "exe"

#Agregar bloqueo al archivo hosts
Add-ToHostsFile -ips @(
	"license.piriform.com",
	"speccy.piriform.com",
	"recuva.piriform.com",
	"defraggler.piriform.com",
	"ccleaner.piriform.com"
)

wRun("Optimización terminada")
