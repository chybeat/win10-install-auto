#Colocando memoria virtual en unidad C al minimo de ram y maximo del doble de la RAM instalada
wInfo("Asignando memoria virtual")
$systemDriveSize = [int]((Get-Partition -DriveLetter (($env:SystemDrive).trim(":")) | Measure-Object -Property size -Sum).sum / 1gb)
$ramSize = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum / 1mb
$minDriveSize = 256

if ($systemDriveSize -le $minDriveSize -and $SSD) {
	$PagefileMaxSize = $ramSize / 2
} elseif ($minDriveSize -and $SSD) {
	$PagefileMaxSize = $ramSize
} else {
	$PagefileMaxSize = $ramSize * 2
}
$PagefileMinSize = $PagefileMaxSize / 2

if ($null -eq (Get-WmiObject Win32_Pagefile)) {
	$sys = Get-WmiObject Win32_Computersystem -EnableAllPrivileges
	$sys.AutomaticManagedPagefile = $false
	$sys.put() | Out-Null
}
$Pagefile = Get-WmiObject Win32_PagefileSetting | Where-Object { $_.name -like “*pagefile.sys*” }

$Pagefile.InitialSize = $PagefileMinSize
$Pagefile.MaximumSize = $PagefileMaxSize
$Pagefile.put() | Out-Null

Write-Host "Memoria virtual asignada:`n"
Write-Host "Tamaño mínimo:"($PagefileMinSize / 1024)"GB"
Write-Host "Tamaño máximo:"($PagefileMaxSize / 1024)"GB"
