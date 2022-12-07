<#======================================
= Instación de los programas de diseño =
======================================#>
$scriptsFolder = $PSScriptRoot + "\SoftDesign"
$instApps = @(
	'AcrobatDC2022.ps1', # Es necesario eliminar registro de inicio, servicios y tareas programadas
	'Pitstop2022.ps1', #Requerido por limpieza de autoejecutables
	'KodakPreps.ps1', #Se requiere acción para activación!
	'Adobe CC.ps1', #Se requiere acciones dependiendo de la arquitectura
	'corelDraw.ps1' #Se requieren acciones de limpieza
)

foreach ($app in $instApps) {
	if (($app).EndsWith(".ps1")) {
		#Aplicaciones que para su correcta instalación, requieren de una instalación explicita y metodica
		#Algunos datos pueden venir de la base de datos o no, igualmente el tratamiento se hace desde un script

		$script = $scriptsFolder + "\" + $app
		. $script
	} else {
		#listado de aplicaciones que no requieren interacción o una instalacion especial
		#Datos de la app que se obtienen de la base de datos
		$appData = get-dbAppData($app)
		install-app($appData)
	}
}
