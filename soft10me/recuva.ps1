<# Recuva v1.53
=============#>
$app = get-dbAppData('Recuva')
install-app($app)


#Obtener el ID de la opción de Shell re recuva
$ShellExtIDPath = "HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\RecuvaShellExt"
$idShell = $null

if (Test-Path -Path "Registry::$ShellExtIDPath") {
	$idShell = Get-ItemPropertyValue -Path ("Registry::$ShellExtIDPath") -Name '(Default)'
	$pattern = '[^A-Z0-9{}-]'
	$idShell = $idShell -replace $pattern, ""
}

set-reg("
-[$ShellExtIDPath]
-[HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\RecuvaShellExt]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\RecuvaShellExt]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\RecuvaShellExt]
")
