wRun("Mejorando el esquema de energ�a del computador")
<#
    Esquemas de energ�a para Windows
A tener e cuenta y que hay que cambiar:

            Tiempos                    |||  Port�til ||| Desktop
    ------------------------------------------------------------
    Tiempo de apagado de pantalla       |   Nunca     |   Nunca
    Tiempo de apagado de discos duros   |     10      |   Nunca
    Tiempo de puesta en suspensi�n      |     20      |     60
    Tiempo de puesta en Hibernaci�n     |     30      |   Nunca
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

#Activar el apagado "suave" (inicio r�pido) tanto para portatil como para PC (terminado en cero lo desactiva)
Set-Reg('[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power]
"HiberbootEnabled"=dword:00000000
')

if (Test-IsLaptop) {
	#En unidades SSD no es necesario activar hibernaci�n, pero es necesario hacerlo despues de un tiempo largo
	if (!(Get-PhysicalDisk).mediatype -contains "SSD") {
		powercfg /hibernate ON
		powercfg /change hibernate-timeout-dc 30
	}
	wInfo ("Configurando esquema de energ�a para portatil")
	powercfg /change disk-timeout-dc 5
	powercfg /change standby-timeout-dc 10
} else {
	wInfo ("Configurando esquema de energ�a para Computador de Escritorio")
}
