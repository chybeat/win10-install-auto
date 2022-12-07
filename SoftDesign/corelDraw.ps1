<# CorelDraw 2020/2022
===========#>

if ($x86) {
	$app = get-dbAppData('CorelDraw 2020')
} else {
	$app = get-dbAppData('CorelDraw 2022')
}

install-app($app)

#Al terminar la instalación se deshabilita la ejecución de scripts. Los siguientes comandos lo reactivan
Set-ExecutionPolicy -Scope CurrentUser Unrestricted -Force
Set-ExecutionPolicy -Scope LocalMachine Unrestricted -Force

$clean_path = [Environment]::GetFolderPath("MyDocuments") + "\Corel\"
if (Test-Path -Path $clean_path -PathType Container) {
	Remove-Item -Path $clean_path -Recurse -Force
}
