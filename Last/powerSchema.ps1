wRun("Mejorando el esquema de energía del computador")
<#
    Esquemas de energía para Windows
A tener e cuenta y que hay que cambiar:

            Tiempos                    |||  Portátil ||| Desktop
    ------------------------------------------------------------
    Tiempo de apagado de pantalla       |   Nunca     |   Nunca
    Tiempo de apagado de discos duros   |     10      |   Nunca
    Tiempo de puesta en suspensión      |     20      |     60
    Tiempo de puesta en Hibernación     |     30      |   Nunca
    ------------------------------------------------------------
    *Tiempos en minutos

ac = Conectado a la corriente
dc = Funcionando con bateria
#>

powercfg /hibernate OFF
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change disk-timeout-ac 0
powercfg /change disk-timeout-dc 0
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0

#Activar el apagado "suave" (inicio rápido) tanto para portatil como para PC (terminado en cero lo desactiva)
Set-Reg('[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power]
"HiberbootEnabled"=dword:00000000
')

if (Test-IsLaptop) {
	#En unidades SSD no es necesario activar hibernación, pero es necesario hacerlo despues de un tiempo largo
	if (!(Get-PhysicalDisk).mediatype -contains "SSD") {
		powercfg /hibernate ON
		powercfg /change hibernate-timeout-dc 30
	}
	wInfo ("Configurando esquema de energía para portatil")
	powercfg /change disk-timeout-dc 5
	powercfg /change standby-timeout-dc 10
} else {
	wInfo ("Configurando esquema de energía para Computador de Escritorio")
}
