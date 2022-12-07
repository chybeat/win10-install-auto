<# Skype v8.65.0.78
=================#>

$app = Get-dbAppData('Skype')
Install-App($app)

Start-Sleep -s 5
if ((Get-Process -Name "skype" -ErrorAction SilentlyContinue).ProcessName) {
	cmd /c "taskkill.exe /IM skype.exe /f" | Out-Null
}
#Eliminar de inicio

Set-Reg('
-[HKEY_CLASSES_ROOT\*\shell\ShareWithSkype]
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Skype for Desktop"=-')
