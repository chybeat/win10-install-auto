<#===============================================
= Instaci�n de los programas requeridos b�sicos =
===============================================#>

#Listado de aplicaciones o archivos a ejecutar. Si la instalaci�n no requiere de configuraciones especiales no debe llevar la extensi�n de un archivo ps1.
$instApps = @(
	#'DAMNNfoviewer', Jubilado, markdown es la ostia!!!!
	'javaRuntime.ps1', #requiere eliminado de autoejecucion e instalaci�n tanto para 32 y 64 bits forzada
	'cmaptools.ps1', #Requiere permisos en el firewall
	'Winrar',
	'7-zip',
	'3Planesoft',
	'Dia Diagram Editor',
	'Visual Studio Code',
	'SVG Explorer Extension',
	'AnyDesk.ps1', #requiere crear un enlace en el menu inicio
	'skype.ps1', #requiere eliminado de inicio y de menu contextual
	'teamviewer',
	'qbittorrent.ps1', #require configurtacion en firewall de Windows
	'BleachBit', #requiere eliminado del menu contextual
	'ccleaner.ps1', #requiere de eliminaci�n de datos en el registro en tareas programas y configuraciones de archivo .ini
	'DISM++',
	'AuslogicRegDefrag.ps1', #requiere de eliminaci�n de datos en el registro
	'Defraggler.ps1', #requiere de eliminaci�n de datos en el registro
	'cpu-z',
	'CrystalDiskinfo',
	'HwInfo.ps1', #requiere de eliminaci�n de datos en el registro y cambios al instalar por 32/64-bit
	'HWMonitor',
	'Powermax',
	'recuva.ps1', #Requier Cambios en el registro de la papelera de deciclaje
	'O&O ShutUp',
	'Ultimate Windows tweaker',
	'Read Write Everything'
	'sysinternals',
	'Advanced IP Scanner.ps1', #Requere cambios en el registro y que la app se cierre al terminar instalacion
	'Sumatra PDF',
	'mdview',
	'powertoys.ps1', #requiere expandir uno archivos de configuraciones (.zip)
	'ultrasearch',
	'k-lite.ps1', #Requiere cambios en la instalaci�n dependendo de la arquitetura del Sistemaa (x86-x64)
	'libreoffice.ps1', #requiere argumentos especiales en la instalaci�n al ser un archivo .MSI
	'Winamp'
)

foreach ($app in $instApps) {
	if (($app).EndsWith(".ps1")) {
		#Aplicaciones que para su correcta instalaci�n, requieren de una instalaci�n explicita y metodica
		#Algunos datos pueden venir de la base de datos o no, igualmente el tratamiento se hace desde un script
		$script = $PSScriptRoot + "\soft10me\" + $app
		. $script
	} else {
		#listado de aplicaciones que no requieren interacci�n o una instalacion especial
		#Datos de la app que se obtienen de la base de datos
		$appData = Get-DbAppData($app)
		install-app($appData)
	}
}

#########
# hacks #
#########


set-reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager]
"Preferences"=hex:0d,00,00,00,60,00,00,00,60,00,00,00,71,02,00,00,8d,01,00,00,\
  ec,03,00,00,01,03,00,00,00,00,00,00,00,00,00,80,00,00,00,80,d8,01,00,80,df,\
  01,00,80,00,01,00,01,fd,01,00,00,db,00,00,00,14,05,00,00,33,03,00,00,f4,01,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,0f,00,00,00,01,00,00,00,00,00,00,\
  00,68,aa,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,00,00,00,00,ea,00,00,00,\
  1e,00,00,00,89,90,00,00,00,00,00,00,ff,00,00,00,01,01,50,02,00,00,00,00,0d,\
  00,00,00,00,00,00,00,a8,aa,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,\
  ff,ff,96,00,00,00,1e,00,00,00,8b,90,00,00,01,00,00,00,00,00,00,00,00,10,10,\
  01,00,00,00,00,03,00,00,00,00,00,00,00,c0,aa,55,71,f6,7f,00,00,00,00,00,00,\
  00,00,00,00,ff,ff,ff,ff,78,00,00,00,1e,00,00,00,8c,90,00,00,02,00,00,00,00,\
  00,00,00,01,02,12,00,00,00,00,00,04,00,00,00,00,00,00,00,d8,aa,55,71,f6,7f,\
  00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,96,00,00,00,1e,00,00,00,8d,90,00,\
  00,03,00,00,00,00,00,00,00,00,01,10,01,00,00,00,00,02,00,00,00,00,00,00,00,\
  f8,aa,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,32,00,00,00,1e,\
  00,00,00,8a,90,00,00,04,00,00,00,00,00,00,00,00,08,20,01,00,00,00,00,05,00,\
  00,00,00,00,00,00,10,ab,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,\
  ff,c8,00,00,00,1e,00,00,00,8e,90,00,00,05,00,00,00,00,00,00,00,00,01,10,01,\
  00,00,00,00,06,00,00,00,00,00,00,00,38,ab,55,71,f6,7f,00,00,00,00,00,00,00,\
  00,00,00,ff,ff,ff,ff,04,01,00,00,1e,00,00,00,8f,90,00,00,06,00,00,00,00,00,\
  00,00,00,01,10,01,00,00,00,00,07,00,00,00,00,00,00,00,60,ab,55,71,f6,7f,00,\
  00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,49,00,00,00,49,00,00,00,90,90,00,00,\
  07,00,00,00,00,00,00,00,00,04,25,00,00,00,00,00,08,00,00,00,00,00,00,00,90,\
  aa,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,49,00,00,00,49,00,\
  00,00,91,90,00,00,08,00,00,00,00,00,00,00,00,04,25,00,00,00,00,00,09,00,00,\
  00,00,00,00,00,80,ab,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,\
  49,00,00,00,49,00,00,00,92,90,00,00,09,00,00,00,00,00,00,00,00,04,25,08,00,\
  00,00,00,0a,00,00,00,00,00,00,00,98,ab,55,71,f6,7f,00,00,00,00,00,00,00,00,\
  00,00,ff,ff,ff,ff,49,00,00,00,49,00,00,00,93,90,00,00,0a,00,00,00,00,00,00,\
  00,00,04,25,08,00,00,00,00,0b,00,00,00,00,00,00,00,b8,ab,55,71,f6,7f,00,00,\
  00,00,00,00,00,00,00,00,ff,ff,ff,ff,49,00,00,00,49,00,00,00,39,a0,00,00,0b,\
  00,00,00,00,00,00,00,00,04,25,08,00,00,00,00,1c,00,00,00,00,00,00,00,d8,ab,\
  55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,c8,00,00,00,49,00,00,\
  00,3a,a0,00,00,0c,00,00,00,00,00,00,00,00,01,10,08,00,00,00,00,1d,00,00,00,\
  00,00,00,00,00,ac,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,64,\
  00,00,00,49,00,00,00,4c,a0,00,00,0d,00,00,00,00,00,00,00,00,02,15,08,00,00,\
  00,00,1e,00,00,00,00,00,00,00,20,ac,55,71,f6,7f,00,00,00,00,00,00,00,00,00,\
  00,ff,ff,ff,ff,64,00,00,00,49,00,00,00,4d,a0,00,00,0e,00,00,00,00,00,00,00,\
  00,02,15,08,00,00,00,00,03,00,00,00,0a,00,00,00,01,00,00,00,00,00,00,00,68,\
  aa,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,00,00,00,00,d7,00,00,00,00,00,\
  00,00,89,90,00,00,00,00,00,00,ff,00,00,00,01,01,50,02,00,00,00,00,04,00,00,\
  00,00,00,00,00,d8,aa,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,01,00,00,00,\
  96,00,00,00,00,00,00,00,8d,90,00,00,01,00,00,00,00,00,00,00,01,01,10,00,00,\
  00,00,00,03,00,00,00,00,00,00,00,c0,aa,55,71,f6,7f,00,00,00,00,00,00,00,00,\
  00,00,ff,ff,ff,ff,64,00,00,00,00,00,00,00,8c,90,00,00,02,00,00,00,00,00,00,\
  00,00,02,10,00,00,00,00,00,0c,00,00,00,00,00,00,00,50,ac,55,71,f6,7f,00,00,\
  00,00,00,00,00,00,00,00,03,00,00,00,64,00,00,00,00,00,00,00,94,90,00,00,03,\
  00,00,00,00,00,00,00,01,02,10,00,00,00,00,00,0d,00,00,00,00,00,00,00,78,ac,\
  55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,64,00,00,00,00,00,00,\
  00,95,90,00,00,04,00,00,00,00,00,00,00,00,01,10,01,00,00,00,00,0e,00,00,00,\
  00,00,00,00,a0,ac,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,05,00,00,00,32,\
  00,00,00,00,00,00,00,96,90,00,00,05,00,00,00,00,00,00,00,01,04,20,01,00,00,\
  00,00,0f,00,00,00,00,00,00,00,c8,ac,55,71,f6,7f,00,00,00,00,00,00,00,00,00,\
  00,06,00,00,00,32,00,00,00,00,00,00,00,97,90,00,00,06,00,00,00,00,00,00,00,\
  01,04,20,01,00,00,00,00,10,00,00,00,00,00,00,00,e8,ac,55,71,f6,7f,00,00,00,\
  00,00,00,00,00,00,00,07,00,00,00,46,00,00,00,00,00,00,00,98,90,00,00,07,00,\
  00,00,00,00,00,00,01,01,10,01,00,00,00,00,11,00,00,00,00,00,00,00,08,ad,55,\
  71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,64,00,00,00,00,00,00,00,\
  99,90,00,00,08,00,00,00,00,00,00,00,00,01,10,01,00,00,00,00,06,00,00,00,00,\
  00,00,00,38,ab,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,09,00,00,00,04,01,\
  00,00,00,00,00,00,8f,90,00,00,09,00,00,00,00,00,00,00,01,01,10,01,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,04,00,00,00,0b,00,00,00,01,00,00,00,00,00,00,00,68,aa,55,\
  71,f6,7f,00,00,00,00,00,00,00,00,00,00,00,00,00,00,d7,00,00,00,00,00,00,00,\
  9e,90,00,00,00,00,00,00,ff,00,00,00,01,01,50,02,00,00,00,00,12,00,00,00,00,\
  00,00,00,30,ad,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,2d,00,\
  00,00,00,00,00,00,9b,90,00,00,01,00,00,00,00,00,00,00,00,04,20,01,00,00,00,\
  00,14,00,00,00,00,00,00,00,50,ad,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,\
  ff,ff,ff,ff,64,00,00,00,00,00,00,00,9d,90,00,00,02,00,00,00,00,00,00,00,00,\
  01,10,01,00,00,00,00,13,00,00,00,00,00,00,00,78,ad,55,71,f6,7f,00,00,00,00,\
  00,00,00,00,00,00,ff,ff,ff,ff,64,00,00,00,00,00,00,00,9c,90,00,00,03,00,00,\
  00,00,00,00,00,00,01,10,01,00,00,00,00,03,00,00,00,00,00,00,00,c0,aa,55,71,\
  f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,64,00,00,00,00,00,00,00,8c,\
  90,00,00,04,00,00,00,00,00,00,00,01,02,10,00,00,00,00,00,07,00,00,00,00,00,\
  00,00,60,ab,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,05,00,00,00,49,00,00,\
  00,49,00,00,00,90,90,00,00,05,00,00,00,00,00,00,00,01,04,21,00,00,00,00,00,\
  08,00,00,00,00,00,00,00,90,aa,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,06,\
  00,00,00,49,00,00,00,49,00,00,00,91,90,00,00,06,00,00,00,00,00,00,00,01,04,\
  21,00,00,00,00,00,09,00,00,00,00,00,00,00,80,ab,55,71,f6,7f,00,00,00,00,00,\
  00,00,00,00,00,07,00,00,00,49,00,00,00,49,00,00,00,92,90,00,00,07,00,00,00,\
  00,00,00,00,01,04,21,08,00,00,00,00,0a,00,00,00,00,00,00,00,98,ab,55,71,f6,\
  7f,00,00,00,00,00,00,00,00,00,00,08,00,00,00,49,00,00,00,49,00,00,00,93,90,\
  00,00,08,00,00,00,00,00,00,00,01,04,21,08,00,00,00,00,0b,00,00,00,00,00,00,\
  00,b8,ab,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,09,00,00,00,49,00,00,00,\
  49,00,00,00,39,a0,00,00,09,00,00,00,00,00,00,00,01,04,21,08,00,00,00,00,1c,\
  00,00,00,00,00,00,00,d8,ab,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,0a,00,\
  00,00,64,00,00,00,00,00,00,00,3a,a0,00,00,0a,00,00,00,00,00,00,00,00,01,10,\
  08,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,02,00,00,00,08,00,00,00,01,00,00,00,00,00,00,00,68,aa,55,71,f6,\
  7f,00,00,00,00,00,00,00,00,00,00,00,00,00,00,c6,00,00,00,00,00,00,00,b0,90,\
  00,00,00,00,00,00,ff,00,00,00,01,01,50,02,00,00,00,00,15,00,00,00,00,00,00,\
  00,98,ad,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,6b,00,00,00,\
  00,00,00,00,b1,90,00,00,01,00,00,00,00,00,00,00,00,04,25,00,00,00,00,00,16,\
  00,00,00,00,00,00,00,c8,ad,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,\
  ff,ff,6b,00,00,00,00,00,00,00,b2,90,00,00,02,00,00,00,00,00,00,00,00,04,25,\
  00,00,00,00,00,18,00,00,00,00,00,00,00,f0,ad,55,71,f6,7f,00,00,00,00,00,00,\
  00,00,00,00,ff,ff,ff,ff,6b,00,00,00,00,00,00,00,b4,90,00,00,03,00,00,00,00,\
  00,00,00,00,04,25,00,00,00,00,00,17,00,00,00,00,00,00,00,18,ae,55,71,f6,7f,\
  00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,6b,00,00,00,00,00,00,00,b3,90,00,\
  00,04,00,00,00,00,00,00,00,00,04,25,00,00,00,00,00,19,00,00,00,00,00,00,00,\
  50,ae,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,ff,a0,00,00,00,00,\
  00,00,00,b5,90,00,00,05,00,00,00,00,00,00,00,00,04,20,01,00,00,00,00,1a,00,\
  00,00,00,00,00,00,80,ae,55,71,f6,7f,00,00,00,00,00,00,00,00,00,00,ff,ff,ff,\
  ff,7d,00,00,00,00,00,00,00,b6,90,00,00,06,00,00,00,00,00,00,00,00,04,20,01,\
  00,00,00,00,1b,00,00,00,00,00,00,00,b0,ae,55,71,f6,7f,00,00,00,00,00,00,00,\
  00,00,00,ff,ff,ff,ff,7d,00,00,00,00,00,00,00,b7,90,00,00,07,00,00,00,00,00,\
  00,00,00,04,20,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,01,00,00,00,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,01,00,da,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,9d,20,00,00,20,00,00,00,64,00,00,00,64,00,00,00,32,00,00,00,50,\
  00,00,00,50,00,00,00,32,00,00,00,32,00,00,00,28,00,00,00,50,00,00,00,3c,00,\
  00,00,50,00,00,00,50,00,00,00,32,00,00,00,50,00,00,00,50,00,00,00,50,00,00,\
  00,50,00,00,00,50,00,00,00,50,00,00,00,50,00,00,00,28,00,00,00,50,00,00,00,\
  23,00,00,00,23,00,00,00,23,00,00,00,23,00,00,00,50,00,00,00,50,00,00,00,50,\
  00,00,00,32,00,00,00,32,00,00,00,32,00,00,00,78,00,00,00,78,00,00,00,50,00,\
  00,00,3c,00,00,00,50,00,00,00,50,00,00,00,78,00,00,00,32,00,00,00,78,00,00,\
  00,78,00,00,00,32,00,00,00,50,00,00,00,50,00,00,00,50,00,00,00,50,00,00,00,\
  c8,00,00,00,00,00,00,00,01,00,00,00,02,00,00,00,03,00,00,00,04,00,00,00,05,\
  00,00,00,06,00,00,00,07,00,00,00,08,00,00,00,09,00,00,00,0a,00,00,00,0b,00,\
  00,00,0c,00,00,00,0d,00,00,00,0e,00,00,00,0f,00,00,00,10,00,00,00,11,00,00,\
  00,12,00,00,00,13,00,00,00,14,00,00,00,15,00,00,00,16,00,00,00,17,00,00,00,\
  18,00,00,00,19,00,00,00,1a,00,00,00,1b,00,00,00,1c,00,00,00,1d,00,00,00,1e,\
  00,00,00,1f,00,00,00,20,00,00,00,21,00,00,00,22,00,00,00,23,00,00,00,24,00,\
  00,00,25,00,00,00,26,00,00,00,27,00,00,00,28,00,00,00,29,00,00,00,2a,00,00,\
  00,2b,00,00,00,2c,00,00,00,2d,00,00,00,2e,00,00,00,2f,00,00,00,00,00,00,00,\
  00,00,00,00,1f,00,00,00,00,00,00,00,64,00,00,00,32,00,00,00,78,00,00,00,50,\
  00,00,00,50,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,01,00,00,00,02,00,00,00,03,00,00,00,04,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
')