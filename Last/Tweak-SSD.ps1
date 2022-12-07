<# Tweak SSD v2.0.70
===========

Instalación omitida ya que todos los tweaks del programa se puede realizar desde un script
==========================================================================================

$app = get-dbAllData("Tweak-ssd")
installme($app)

Configuraciones por Tweak-SSD (Mejoras de rendimiento) Habilitador = Deshabilitar opcion
    Prefetcher: Habilitado
    Servicio "Sysmain": Habilitado
    Windows Indexing service (Windows Search): Deshabilitado
    Keep System Files in Memory (DisablePagingExecutive): Habilitado
    Use large system cache: Habilitado
    Don´t Limit NTFS memory usage: Habilitado
    Windows Hibernation: Deshabilitado
    File date stamping: Deshabilitado
    Page File (8GB o Mas): Deshabilitado
    Clear Page File on Shutdown: Deshabilitar
    Send delete notifications to SDD: Habilitar
    TRIM: Habilitar
#>

wRun("Optimizando unidades de almacenamiento...")

#Keep System Files in Memory
set-Reg('[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management]
	"DisablePagingExecutive"=dword:00000000
')

if ($ssd) {
	#De ser unidad SSD se habilitarán/deshabilitarán las siguientes funciones
	set-Reg('
	;Habilita prefetcher para archivos de arranque
	[HKEY_LOCAL_MACHINE\System\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters]
	"EnablePrefetcher"=dword:00000000

	;Deshabilita el inicio del servicio "Sysmain" (Relacionado con el Superfetch)
	[HKEY_LOCAL_MACHINE\System\ControlSet001\Services\SysMain]
	"Start"=dword:00000004

	;Deshabilita el inicio del servicio Windows Search (omitido por que si hay uso como tal)
	[HKEY_LOCAL_MACHINE\System\ControlSet001\Services\WSearch]
	"Start"=dword:00000004

	;Keep System Files in Memory
	[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management]
	"DisablePagingExecutive"=dword:00000001

	;Use large system cache
	[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management]
	"LargeSystemCache"=dword:00000001

	;Dont Limit NTFS memory usage (1= Limit 2=Dont Limit)
	[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
	"NtfsMemoryUsage"=dword:00000002

	;Windows Hibernation
	[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power]
	"HiberFileSizePercent"=dword:00000000
	"HibernateEnabled"=dword:00000000

	;File date stamping
	[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
	"NtfsDisableLastAccessUpdate"=dword:00000001

	;Boot time defragmention:
	[HKEY_LOCAL_MACHINE\Software\Microsoft\Dfrg\BootOptimizeFunction]
	"Enable"="N"

	;Clear Page File on Shutdown
	[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management]
	"ClearPageFileAtShutdown"=dword:00000000

	[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
	"DisableDeleteNotification"=dword:00000000
	')
	#verificación si hay mas de 16 GB RAM para deshabilitar Page File en PC con SSD
	if ($ramSize -gt 17) {
		Set-Reg('
			;Page File.
			[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management]
			"PagingFiles"=-
		')
	}
	#habilitar TRIM
	fsutil behavior set disabledeletenotify 0 | Out-Null
	#Optimizar SSD
	Get-PhysicalDisk | ForEach-Object {
		if ($_.MediaType -eq "SSD") {
			(Get-Disk -Number $_.DeviceID | Get-Partition | Get-Volume).DriveLetter
		}
	} | ForEach-Object {
		if ($_) {
			Optimize-Volume -DriveLetter $_ -ReTrim -Verbose
		}
	}
}
wOK("Optimizaciones para unidades SSD terminadas")
