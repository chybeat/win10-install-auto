wTitulo("Optimizando Configuración de Windows")
wInfo("Cierre temporal de explorer.exe por cambios en el registro")
taskkill /im explorer.exe /F | Out-Null

<#
============================
= Configuración de Windows =
============================

Sistema
=======
	-> Pantalla
		-> Configuración avanzada de ajuste de escala
			-> Dejar que Windows intente corregir las aplicaciones...: Activado
[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001
#>
wRun("Sistema")
wInfo("Configurando el escalado de aplicaciones")

Set-Reg('[HKEY_CURRENT_USER\Control Panel\Desktop]
"EnablePerProcessSystemDPI"=dword:00000001'
)

<#
Sistema
=======
	-> Notificaciones y acciones
		-Acciones Rápidas
			->Editar las acciones rapidas
				Quitar: Todas las opciones
				Quitar: Ubicación
				Quitar: Proyectar
-[HKEY_CURRENT_USER\Control Panel\Quick Actions\Control Center\Unpinned]

[HKEY_CURRENT_USER\Control Panel\Quick Actions\Control Center\Unpinned]
"Microsoft.QuickAction.AllSettings"=hex(0):
"Microsoft.QuickAction.Location"=hex(0):
"Microsoft.QuickAction.Project"=hex(0):
#>
wInfo("Configurando las acciones rapidas del centro de acciones")

Set-Reg('-[HKEY_CURRENT_USER\Control Panel\Quick Actions\Control Center\Unpinned]

[HKEY_CURRENT_USER\Control Panel\Quick Actions\Control Center\Unpinned]
"Microsoft.QuickAction.AllSettings"=hex(0):
"Microsoft.QuickAction.Location"=hex(0):
"Microsoft.QuickAction.Project"=hex(0):
"Microsoft.QuickAction.Vpn"=hex(0):

[HKEY_CURRENT_USER\Control Panel\Quick Actions\Control Center]
AppliedDefaultPins=dword:00000001
')

<#
		-Notificaciones
			Mostrar notificaciones en la pantalla de bloqueo: Desactivar
			Mostrar recordatorios y llamadas VOIP...: Desactivar
			Sugerir maneras en las que puedo terminar de conf...: Desactivar

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications]
"LockScreenToastEnabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings]
"NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK"=dword:00000000
"NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement]
"ScoobeSystemSettingEnabled"=dword:00000000

#>
wInfo("Configurando las notificaciones")

Set-Reg('
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications]
"LockScreenToastEnabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings]
"NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK"=dword:00000000
"NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement]
"ScoobeSystemSettingEnabled"=dword:00000000
')


<#
	-> Asistente de concentración
		Elige las notificaciones que quieres ver y escuchar para no distraerte...
			-> Solo Aalarmas
#>
wInfo("Configurando Asistente de concentración")
wOk("Omitido...")
#omitido ya que al iniciar Windows despues de OOBE toca volver a hacerlo
#wInfo("Reanudación de explorer.exe")
#Start-Process explorer.exe
#Start-Sleep -Seconds 2
#WTitulo('Seleccionar "Solo Alarmas"')
#Wait-For -Run "ms-settings:quiethours" -ProcessName "systemSettings"
#
#wInfo("Cierre temporal de explorer.exe por cambios en el registro")
#taskkill /im explorer.exe /F | Out-Null

<#
	-> Almacenamiento
		-Almacenamiento
			*Sensor de almacenamiento puede liberar espacio automáticamente...: Activado
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy]
"StoragePoliciesNotified"=dword:00000001
"01"=dword:00000001
#>
wInfo("Configurando el almacenamiento")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy]
"StoragePoliciesNotified"=dword:00000001
"01"=dword:00000001
')

<#
			-> Configurar el sensor de almac o ejecutarlo ahora
				-Sensor de almacenamiento
					-> Ejecutar sensor de almacenamiento: Cada mes
				-> Archivos temporales
					-> Eliminar archivos temporales de la papelera de reciclaje...: 14 dí­as
					-> Eliminar archivos de la carpeta Mis descargas...: 14 dí­as
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy]
"08"=dword:00000001
"32"=dword:00000001
"256"=dword:0000000e
"512"=dword:0000000e
"1024"=dword:00000001
"2048"=dword:0000001e
#>

wInfo("Configurando el sensor de almacenamiento")

Set-Reg('
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy]
"08"=dword:00000001
"32"=dword:00000001
"256"=dword:0000000e
"512"=dword:0000000e
"1024"=dword:00000001
"2048"=dword:0000001e
')

<#
	-> Tableta
		-> Cambiar la configuración adicional de tableta
			-Cuando uso el modo tableta
				(· )ocultar los iconos de la aplicación en la barra de tareas: Desactivado
				( ·)Muestra el teclado táctil cuando no hay un teclado conectado: Activar

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarAppsVisibleInTabletMode"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\TabletTip\1.7]
"EnableDesktopModeAutoInvoke"=dword:00000001

#>
wInfo("Configurando el modo tableta")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarAppsVisibleInTabletMode"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\TabletTip\1.7]
"EnableDesktopModeAutoInvoke"=dword:00000001
')

<#
	-> Multitareas
		-Escala de tiempo
			(· ) Mostrar sugerencias en la lí­nea de tiempo: Desactivar
#>
wInfo("Configurando multitareas")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-353698Enabled"=dword:00000000
')

<#
		-Alt + Tabulador
			^Al presionar Alt + Tab se muestra: Ventanas abiertas solamente

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"MultiTaskingAltTabFilter"=dword:00000003
#>

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"MultiTaskingAltTabFilter"=dword:00000003
')

<#
	->Portapapeles
		*Historial del Portapapeles: Desactivado
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Clipboard]
"EnableClipboardHistory"=dword:00000000
#>
wInfo("Configurando Portapapeles")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Clipboard]
"EnableClipboardHistory"=dword:00000000
')

wRun("Dispositivos")

<#
Dispositivos
============
	->Impresoras y escáneres
		->Impresoras y escáneres
			Dejar que Windows administre mi imp. predet.: Desactivar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows]
"LegacyDefaultPrinterMode"=dword:00000001
#>
wInfo("Configurando Impresoras y escáneres")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows]
"LegacyDefaultPrinterMode"=dword:00000001
')

<#
	-> Escritura
		-> Ortografí­a
			Corregir automáticamente las palabras mal escritas: Desactivar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\TabletTip\1.7]
"EnableAutocorrection"=dword:00000000

		-> Escritura
			Agregar un espacio cuando acepte una sugerencia de texto: Desactivar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\TabletTip\1.7]
"EnablePredictionSpaceInsertion"=dword:00000000
#>
wInfo("Configurando Ortografía y Escritura")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\TabletTip\1.7]
"EnableAutocorrection"=dword:00000000
"EnablePredictionSpaceInsertion"=dword:00000000
')

<#
		-Teclado de hardware
			Mostrar sugerencias de texto mientras escribo : Activar
		-Sugerencias de texto multilingüe
			Mostrar sugerencias de texto en función de los idiomas...: Activar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input\Settings]
"EnableHwkbTextPrediction"=dword:00000001
"MultilingualEnabled"=dword:00000001
#>

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input\Settings]
"EnableHwkbTextPrediction"=dword:00000001
"MultilingualEnabled"=dword:00000001
')

<#
	-> Reproduccion automática
		->Elegir valores predeterminados de reproducción automática
			^ Unidad extraible: Abrir carpeta para ver los archivos (explorador de archivos)
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival]
@="MSOpenFolder"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival]
@="MSOpenFolder"

;			^ Tarjeta de memoria: Abrir carpeta para ver los archivos (explorador de archivos)
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival]
@="MSOpenFolder"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival]
@="MSOpenFolder"

#>
wInfo("Configurando Reproduccion automática")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival]
@="MSOpenFolder"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival]
@="MSOpenFolder"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival]
@="MSOpenFolder"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival]
@="MSOpenFolder"')


wRun("Personalización")
<#
Personalizacion
===============
	-> Fondo
		!!Configurado en wallpapers.ps1
#>

wInfo("Configurando Color")
<#
	-> Colores
		^elige tu color: Personalizado
		(·)Elige tu modo predeterminado de Windows: Oscuro

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"SystemUsesLightTheme"=dword:00000000
#>
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"SystemUsesLightTheme"=dword:00000000
')

<#
		Seleccionar color azul de la segunda columna en la 3ra fila
		Mostrar color de énfasis en las siguientes superficies
		[X] Inicio, barra de tareas y centro de acciones
		[X] Barras de título y bordes de ventana

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM]
"ColorPrevalence"=dword:00000001
"ColorizationAfterglow"=dword:c40063b1
"ColorizationColor"=dword:c40063b1
"AccentColor"=dword:ffb16300
"Composition"=dword:00000001
"ColorizationColorBalance"=dword:00000059
"ColorizationAfterglowBalance"=dword:0000000a
"ColorizationBlurBalance"=dword:00000001
"EnableWindowColorization"=dword:00000001
"ColorizationGlassAttribute"=dword:00000001
"EnableAeroPeek"=dword:00000001
"AlwaysHibernateThumbnails"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent]
"AccentPalette"=hex(3):86,CA,FF,00,5F,B2,F2,00,1E,91,EA,00,00,63,B1,00,00,\
42,75,00,00,2D,4F,00,00,20,38,00,00,CC,6A,00
"StartColorMenu"=dword:ff754200
"AccentColorMenu"=dword:ffb16300

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"ColorPrevalence"=dword:00000001
')
#>
WInfo('Elegir Color')
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM]
"AccentColor"=dword:ffb16300
"AlwaysHibernateThumbnails"=dword:00000000
"ColorizationAfterglow"=dword:c40063b1
"ColorizationAfterglowBalance"=dword:0000000a
"ColorizationBlurBalance"=dword:00000001
"ColorizationColor"=dword:c40063b1
"ColorizationColorBalance"=dword:00000059
"ColorizationGlassAttribute"=dword:00000001
"ColorPrevalence"=dword:00000001
"Composition"=dword:00000001
"EnableAeroPeek"=dword:00000001
"EnableWindowColorization"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent]
"AccentPalette"=hex(3):86,CA,FF,00,5F,B2,F2,00,1E,91,EA,00,00,63,B1,00,00,\
42,75,00,00,2D,4F,00,00,20,38,00,00,CC,6A,00
"StartColorMenu"=dword:ff754200
"AccentColorMenu"=dword:ffb16300

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"ColorPrevalence"=dword:00000001
')

wInfo("Configurando Pantalla de bloqueo")
<#
	-> Pantalla de bloqueo
		Fondo: Presentación
		Elegir albumes para la presentación: Quitar imagenes y colocar (ruta) C:\Windows\Web\Wallpaper
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen]
"SlideshowSourceDirectoriesSet"=dword:00000001
"SlideshowEnabled"=dword:00000001
"SlideshowDirectoryPath1"="+GAFA8BUg/E0gouOpBhoYjAArADMdmBAvMkOcBAAAAAAAAAAAAAAAAAAAAAAAAgVAEDAAAAAAcMUinCEAcVauR2b3NHAABQCAQAAv77hPdHSIDFJN5CAAAQLGAAAAAQAAAAAAAAAAAAAAAAAAAAADBr7AcFApBgbAQGAvBwdAMHAAAgFAoEAxAAAAAAAH+04LBBAXVmYAgDAJAABA8uvH+02JhMU7vkLAAAAzVBAAAAABAAAAAAAAAAAAAAAAAAAAIEEmDwVAUGAiBAAAIBAvDQMAAAAAAwhPtdSQAwVhxGbwFGclJHAEBQCAQAAv77hPtdSIDlDM5CAAAAeVAAAAAQAAAAAAAAAAAAAAAAAAAAANwztAcFAhBAbAwGAwBQYAAHAlBgcAAAAYAwkAAAAnAw7+WIAAAQMTB1U32pr/3IH/PUgMSIQ6M6ctkGAAAAZAAAAA8BAAAALAAAA3BQaA4GAkBwbAcHAzBgLAkGAtBQbAUGAyBwcAkGA2BQZAMGAvBgbAQHAyBwbAwGAwBQYA4GAlBAbA8FAjBwdAUDAuBQMAgGAyAAdAgHA5BQZAcHA5BAAAAAAAAAAAAAAYAAAAA"
#>
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen]
"SlideshowDirectoryPath1"="+GAFA8BUg/E0gouOpBhoYjAArADMdmBAvMkOcBAAAAAAAAAAAAAAAAAAAAAAAAgVAEDAAAAAAcMUinCEAcVauR2b3NHAABQCAQAAv77hPdHSIDFJN5CAAAQLGAAAAAQAAAAAAAAAAAAAAAAAAAAADBr7AcFApBgbAQGAvBwdAMHAAAgFAoEAxAAAAAAAH+04LBBAXVmYAgDAJAABA8uvH+02JhMU7vkLAAAAzVBAAAAABAAAAAAAAAAAAAAAAAAAAIEEmDwVAUGAiBAAAIBAvDQMAAAAAAwhPtdSQAwVhxGbwFGclJHAEBQCAQAAv77hPtdSIDlDM5CAAAAeVAAAAAQAAAAAAAAAAAAAAAAAAAAANwztAcFAhBAbAwGAwBQYAAHAlBgcAAAAYAwkAAAAnAw7+WIAAAQMTB1U32pr/3IH/PUgMSIQ6M6ctkGAAAAZAAAAA8BAAAALAAAA3BQaA4GAkBwbAcHAzBgLAkGAtBQbAUGAyBwcAkGA2BQZAMGAvBgbAQHAyBwbAwGAwBQYA4GAlBAbA8FAjBwdAUDAuBQMAgGAyAAdAgHA5BQZAcHA5BAAAAAAAAAAAAAAYAAAAA"
"SlideshowEnabled"=dword:00000001
"SlideshowSourceDirectoriesSet"=dword:00000001
')

<#
		-> Configuración de presentacion avanzada
			Usa solo imágnes que quepan en la pantalla: Desactivar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen]
"SlideshowOptimizePhotoSelection"=dword:00000000

#>
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen]
"SlideshowOptimizePhotoSelection"=dword:00000000
')

<#
		-> Configuración del protector de pantalla
			-> Esperar: 5 minutos
#>
Set-Reg('[HKEY_CURRENT_USER\Control Panel\Desktop]
"ScreenSaveTimeOut"="300"
')

<#
	-> Inicio
		-> Mostrar sugerencias ocacionalmente en inicio: Desactivado
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338388Enabled"=dword:00000000
#>
wInfo("Configurando Inicio")
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338388Enabled"=dword:00000000
')

wRun("Aplicaciones")
<#
Aplicaciones
============
	-> Mapas sin conexión
		- Actualizaciones de mapa
			* Actualiza mapas automáticamente: Desactivar
[HKEY_LOCAL_MACHINE\System\Maps]
"AutoUpdateEnabled"=dword:00000000
#>
wInfo("Configurando Mapas sin conexión")

Set-Reg('[HKEY_LOCAL_MACHINE\System\Maps]
"AutoUpdateEnabled"=dword:00000000
')

wRun("Cuentas")
<#
Cuentas
=======
	-> Opciones de inicio de sesion
		- Reiniciar las aplicaciones (* ): Desactivado
#>
wInfo("Configurando Reiniciar las aplicaciones")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
"RestartApps"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
"RestartApps"=dword:00000000
')


wRun("Accesibilidad")
<#
Accesibilidad
=============
	-> Cursor de texto
		-Cambiar la apariencia del cursor de texto
			-__Cambia el grosor del cursor: 2
[HKEY_CURRENT_USER\Control Panel\Desktop]
"CaretWidth"=dword:00000002
#>
wInfo("Configurando Cursor de texto")
Set-Reg('[HKEY_CURRENT_USER\Control Panel\Desktop]
"CaretWidth"=dword:00000002
')

<#
	-> (interaccion) Teclado
		-Usar las teclas especiales
			[] Permitir que la tecla de metodo abreviado...: Desactivar
		-Usar las teclas de alternancia
			-> Reproducir un sonido cuando se presiona la tecla bloq mayus...: *activar
			-> Permitir que la tecla de míétodo abreviado...:desactivar
[HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys]
"Flags"="506"
#>
wInfo("Configurando Teclado")

Set-Reg('[HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys]
"Flags"="506"

[HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys]
"Flags"="59"
')


<#
		-Cambiar el funcionamiento de los métodos abreviados de teclado
			* Subrayar las teclas de acceso cuando estén disponibles: Activar
[HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Preference]
"On"="1"
#>
Set-Reg('[HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Preference]
"On"="1"
')

wRun("Búsqueda")
<#
Búsqueda
========
	-> Permisos e historial
		-Historial
		* Historial de busqueda en este dipositivo: Desactivar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings]
"IsDeviceSearchHistoryEnabled"=dword:00000000
#>
wInfo("Configurando Permisos e historial")
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings]
"IsDeviceSearchHistoryEnabled"=dword:00000000
')

wRun("Privacidad")
<#
Privacidad
==========
	-> General
		-Cambiar opciones de privacidad
			* Dejar que los sitios web ofrezcan contenido...: Desactivar
[HKEY_CURRENT_USER\Control Panel\International\User Profile]
"HttpAcceptLanguageOptOut"=dword:00000001
#>
wInfo("Configurando opciones de privacidad")

Set-Reg('[HKEY_CURRENT_USER\Control Panel\International\User Profile]
"HttpAcceptLanguageOptOut"=dword:00000001
')

<#
			* Permitir que Windows realice un seguimiento de los inicios...: Desactivar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_TrackProgs"=dword:00000000
#>
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_TrackProgs"=dword:00000000
')

<#
	-> (Permisos de aplicación) Activación por voz
		-Activación por voz
			* Permitir que las aplicaciones usen la activación por voz: Desactivado
		-Elije la aplicación predeterminada para la pulsación del boton del casco: Desactivado

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps]
"AgentActivationEnabled"=dword:00000000
"AgentActivationLastUsed"=dword:00000000
#>
wInfo("Configurando Activación por voz")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps]
"AgentActivationEnabled"=dword:00000000
"AgentActivationLastUsed"=dword:00000000
')

<#
	-> (Permisos de aplicación) Información de cuenta
		-> El acceso a la información de cuenta para... (Boton cambiar): Desactivar
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation]
"Value"="Deny"
#>
wInfo("Configurando Información de cuenta")
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation]
"Value"="Deny"
')

<#
	-> Historial de llamadas
		-Permitir el acceso al historial de llamadas de este dispoitivo
			[boton] Cambiar: Desactivar
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory]
"Value"="Deny"
#>
wInfo("Configurando Historial de llamadas")
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory]
"Value"="Deny"
')

<#
	-> Otros dispositivos
		-Comunicarse con dispositivos sin emparejar: Desactivar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync]
"Value"="Deny"
#>
wInfo("Configurando Otros dispositivos")
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync]
"Value"="Deny"
')

wInfo("Configurando Aplicaciones en segundo plano")
<#
	-> Aplicaciones en segundo plano
		-Aplicaciones en segundo plano
			* Permitir que las aplicaciones se enecuten en segundo plano: Desactivar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications]
"GlobalUserDisabled"=dword:00000001
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search]
"BackgroundAppGlobalToggle"=dword:00000000
#>
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications]
"GlobalUserDisabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search]
"BackgroundAppGlobalToggle"=dword:00000000
')

wInfo("Configurando Diagnosticos de la aplicación")
<#
	-> Diagnosticos de la aplicación
		-Permitir el acceso a la información de diagnostico...
			[boton] Cambiar: Desactivar
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics]
"Value"="Deny"
#>
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics]
"Value"="Deny"
')

wRun("Actualización y seguridad")

<#
Actualización y seguridad
=========================
	-> Optimización de distribución
		-Permitir descargas de otros equipos
			(* ) Permitir descargas de otros equipos: Desactivar
[HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings]
"DownloadMode"=dword:00000000
"DownloadModeProvider"=dword:00000008
#>
wInfo("Configurando Optimización de distribución")

Set-Reg('[HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings]
"DownloadMode"=dword:00000000
"DownloadModeProvider"=dword:00000008
')

<#
	-> Para programadores
		->Powershell
			[] Cambiar la directiva de ejecución para permitir...: Activar -> [boton mas abajo] Aplicar
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell]
"ExecutionPolicy"="RemoteSigned"

¡¡¡¡OMITIDO PORQUE MIENTRAS SE EJECUTE POWERSHELL NO SE DEBERÍA CAMBIAR!!!!
wInfo("Configurando Powershell")
Set-Reg('
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell]
"ExecutionPolicy"="RemoteSigned"
')
#>
wTitulo("Optimizando Panel de control")
<#
====================
= Panel de control =
====================
Mostrar iconos grandes

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel]
"AllItemsIconView"=dword:00000000
"StartupPage"=dword:00000001
#>

wInfo("Configurando Mostrar iconos grandes")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel]
"AllItemsIconView"=dword:00000000
"StartupPage"=dword:00000001
')

<#
Opciones de energia
	-> Elegir la opción del botón de inicio apagado
		-> Cambiar la configuración no disponible actualmente
			-> [] Activar inicio rápido (recomendado): Desactivar
#>

wInfo("Configurando Activar inicio rápido")

Set-Reg('[HKEY_LOCAL_MACHINE\System\ControlSet001\Control\Session Manager\Power]
"HiberbootEnabled"=dword:00000000
')

<#
Opciones de internet
	-> General
		-> página principal: https://www.google.com.co
		-> inicio
			Comenzar con pestañas de ultima sesion
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\ContinuousBrowsing]
"Enabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Main]
"Start Page"="https://www.google.com.co/"
#>
wInfo("Configurando Opciones de internet")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\ContinuousBrowsing]
"Enabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Main]
"Start Page"="https://www.google.com.co/"
')

<#
	-> Programas
		-> Edición de HTML
			-> Editor de HTML : Bloc de notas

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Default HTML Editor]
"Description"="Bloc de notas"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Default HTML Editor\shell\edit\command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6D,00,52,00,6F,00,6F,00,74,00,\
25,00,5C,00,73,00,79,00,73,00,74,00,65,00,6D,00,33,00,32,00,5C,00,4E,00,4F,\
00,54,00,45,00,50,00,41,00,44,00,2E,00,45,00,58,00,45,00,20,00,25,00,31,00,\
00,00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\View Source Editor\Editor Name]
@="C:\Windows\system32\NOTEPAD.EXE"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Shared\HTML\Default Editor\shell\edit\command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6D,00,52,00,6F,00,6F,00,74,00,\
25,00,5C,00,73,00,79,00,73,00,74,00,65,00,6D,00,33,00,32,00,5C,00,4E,00,4F,\
00,54,00,45,00,50,00,41,00,44,00,2E,00,45,00,58,00,45,00,20,00,25,00,31,00,\
00,00
#>

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Default HTML Editor]
"Description"="Bloc de notas"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Default HTML Editor\shell\edit\command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6D,00,52,00,6F,00,6F,00,74,00,\
25,00,5C,00,73,00,79,00,73,00,74,00,65,00,6D,00,33,00,32,00,5C,00,4E,00,4F,\
00,54,00,45,00,50,00,41,00,44,00,2E,00,45,00,58,00,45,00,20,00,25,00,31,00,\
00,00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\View Source Editor\Editor Name]
@="C:\Windows\system32\NOTEPAD.EXE"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Shared\HTML\Default Editor\shell\edit\command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6D,00,52,00,6F,00,6F,00,74,00,\
25,00,5C,00,73,00,79,00,73,00,74,00,65,00,6D,00,33,00,32,00,5C,00,4E,00,4F,\
00,54,00,45,00,50,00,41,00,44,00,2E,00,45,00,58,00,45,00,20,00,25,00,31,00,\
00,00
')

<#################################
    TERMINADA LA CONFIGURACIÓn
#################################>

WTitulo('Realizando Configuraciones adicionales')

<#
Configuración -> personalización -> inicio
	-> Mostrar más iconos en inicio: Activado
#>
#### MOVIDO AL FINAL PARA EVITAR REINICIOES DE EXPLORER.EXE NO NECESARIOS!

<#===============
= OTRAS CONFIGS =
===============#>
<#
    ARCHIVO DumpStack.log.tmp

    El archivo "c:\DumpStack.log.tmp" se crea por un proceso de guardado de datos por errores de ejecución de Windows
    Se deshabilita desde el registro
#>
wInfo("Deshabilitar log de errores de ejecución en DumpStack.log.tmp")
Set-Reg('[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl]
"EnableLogFile"=dword:00000000
')

<# Eliminar el prefijo " - acceso directo" al realizar una copia como "acceso directo"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer]
"Link"=hex:00,00,00,00

#>
wInfo("Eliminar el prefijo ' - acceso directo'")

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer]
"Link"=hex:00,00,00,00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer]
"Link"=hex:00,00,00,00
')

<#
Caracterìstica de seleccion en toda la fila
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"FullRowSelect"=1dword:00000001
#>
wInfo("Seleccionar toda la fila en explorador de Windows")
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"FullRowSelect"=dword:00000001
')

<#
Activar el visualizador de fotos de Windows
addToReg('addtoreg([HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations]
".tga"="PhotoViewer.FileAssoc.Tiff"
".jfif"="PhotoViewer.FileAssoc.Tiff"
".gif"="PhotoViewer.FileAssoc.Tiff"
".ico"="PhotoViewer.FileAssoc.Tiff"
".jpg"="PhotoViewer.FileAssoc.Tiff"
".png"="PhotoViewer.FileAssoc.Tiff"
".jpeg"="PhotoViewer.FileAssoc.Tiff"
".bmp"="PhotoViewer.FileAssoc.Tiff"
".jpe"="PhotoViewer.FileAssoc.Tiff"
".dib"="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.tga]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.jfif]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.gif]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.ico]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.jpg]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.png]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.jpeg]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.bmp]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.jpe]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.dib]
@="PhotoViewer.FileAssoc.Tiff"
');

#>
wInfo("Activar el visualizador de fotos de Windows")

Set-Reg('[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations]
".bmp"="PhotoViewer.FileAssoc.Tiff"
".dib"="PhotoViewer.FileAssoc.Tiff"
".gif"="PhotoViewer.FileAssoc.Tiff"
".ico"="PhotoViewer.FileAssoc.Tiff"
".jfif"="PhotoViewer.FileAssoc.Tiff"
".jpe"="PhotoViewer.FileAssoc.Tiff"
".jpeg"="PhotoViewer.FileAssoc.Tiff"
".jpg"="PhotoViewer.FileAssoc.Tiff"
".png"="PhotoViewer.FileAssoc.Tiff"
".tga"="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.tga]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.jfif]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.gif]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.ico]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.jpg]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.png]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.jpeg]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.bmp]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.jpe]
@="PhotoViewer.FileAssoc.Tiff"

[HKEY_CURRENT_USER\Software\Classes\.dib]
@="PhotoViewer.FileAssoc.Tiff"
')

<#
Eliminar el icono de reunirse de la barra de tareas
#>
wInfo("Eliminar el icono de reunion en la barra de tareas")

Set-Reg('[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"HideSCAMeetNow"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"HideSCAMeetNow"=dword:00000001
')

<#
Mostrar notificación cuando se use la camara
#>
wInfo("Mostrar notificación de uso de camara")

Set-Reg('[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"NoPhysicalCameraLED"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"NoPhysicalCameraLED"=dword:00000001
')

<#
Desavtivar Noticias e intereses en la barra de tareas
#>
wInfo("Desacrtivar noticias e intereses en la barra de tareas")
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Feeds]
"EnableFeeds"=dword:00000000
')

<#
Cambiar la calidad del fondo de escritorio a alto
[HKEY_CURRENT_USER\Control Panel\Desktop]
"JPEGImportQuality"=dword:00000256 > alto
"JPEGImportQuality"=dword:00000096 > bajo
#>
wInfo("Cambiar la calidad del fondo de escritorio")
Set-Reg('[HKEY_CURRENT_USER\Control Panel\Desktop]
"JPEGImportQuality"=dword:00000256')

<#
Desactivar la búsqueda de aplicaciones asociadas a Windows Store
[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer]
"NoUseStoreOpenWith"=dword:00000001
#>
wInfo("Desactivar la busqueda de aplicaciones asociadas en Windows Store")
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer]
"NoUseStoreOpenWith"=dword:00000001')

wInfo('Desactivar "Obtener consejos/ayuda al utilizar Windows"')
<#
Desactivar "Obtener consejos/ayuda al utilizar Windows"
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SoftLandingEnabled"=dword:00000000
#>
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SoftLandingEnabled"=dword:00000000
')

wInfo('Desactivar Grabador de juegos')
<#
Desactivar Grabador de juegos
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR]
"AppCaptureEnabled"=dword:00000000

[HKEY_CURRENT_USER\System\GameConfigStore]
"GameDVR_Enabled"=dword:00000000
#>
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR]
"AppCaptureEnabled"=dword:00000000

[HKEY_CURRENT_USER\System\GameConfigStore]
"GameDVR_Enabled"=dword:00000000')

wInfo('Desactivar Çortana')
<#
Desactivar Çortana
[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search]
"AllowCortana"=dword:00000000
#>
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search]
"AllowCortana"=dword:00000000')

wInfo('Activar abrir con Powershell presionando SHIFT')
<#
Activar abrir con CMD (Por error de ejeCUCIÓN SE CAMBIA A POWERSHELL)
CMD
[HKEY_LOCAL_MACHINE\Software\Classes\Directory\background\shell\cmd]
"ShowBasedOnVelocityId"=dword:00639bc8
"HideBasedOnVelocityId"=-

[HKEY_LOCAL_MACHINE\Software\Classes\Directory\shell\cmd]
"ShowBasedOnVelocityId"=dword:00639bc8
"HideBasedOnVelocityId"=-

#>
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Classes\Directory\background\shell\cmd]
"ShowBasedOnVelocityId"=dword:00639bc8
"HideBasedOnVelocityId"=-

[HKEY_LOCAL_MACHINE\Software\Classes\Directory\shell\cmd]
"ShowBasedOnVelocityId"=dword:00639bc8
"HideBasedOnVelocityId"=-')

wInfo('Cambiar "Ajustar volumen" a modo Windows 7')
<#
Cambiar "Ajustar volumen" a modo Windows 7
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC]
"EnableMtcUvc"=dword:00000000
#>
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC]
"EnableMtcUvc"=dword:00000000')

wInfo('Ocultar one drive del explorador de Windows')
<#
Ocultar one drive del explorador de Windows
[HKEY_CURRENT_USER\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder]
"Attributes"=dword:f090004d

[HKEY_CURRENT_USER\Software\Classes\WOW6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder]
"Attributes"=dword:f090004d
#>
Set-Reg('[HKEY_CURRENT_USER\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder]
"Attributes"=dword:f090004d

[HKEY_CURRENT_USER\Software\Classes\WOW6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder]
"Attributes"=dword:f090004d
')

wInfo('Prevenir que Edge abra "Bienvenido"')
<#
Prevenir que Edge abra "Bienvenido"
[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\MicrosoftEdge]
"PreventFirstRunPage"=dword:00000000
#>
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\MicrosoftEdge]
"PreventFirstRunPage"=dword:00000000
')

wInfo('Prevenir Actualizaciones de Windows')
<#
Prevenir Actualizaciones de Windows
[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU]
"AutoInstallMinorUpdates"=dword:00000001
"NoAutoRebootWithLoggedOnUsers"=dword:00000001
"NoAutoUpdate"=dword:00000001
"AUOptions"=dword:00000001
#>
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU]
"AUOptions"=dword:00000001
"AutoInstallMinorUpdates"=dword:00000000
"NoAutoRebootWithLoggedOnUsers"=dword:00000001
"NoAutoUpdate"=dword:00000001
')

wInfo('Deshabilitar Windows Error reporting')
<#
Deshabilitar Windows Error reporting
addtoreg('[HKEY_LOCAL_MACHINE\System\ControlSet001\Services\WerSvc]
"Start"=dword:00000004

[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Error Reporting]
"Disabled"=dword:00000001
');
#>
Set-Reg('[HKEY_LOCAL_MACHINE\System\ControlSet001\Services\WerSvc]
"Start"=dword:00000004

[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Error Reporting]
"Disabled"=dword:00000001
')

wInfo('Deshabilitar el programa de mejora de experiencia al cliente')
<#
Deshabilitar el programa de mejora de experiencia al cliente
addtoreg('[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\SQMClient\Windows]
"CEIPEnable"=dword:00000000');
#>
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\SQMClient\Windows]
"CEIPEnable"=dword:00000000')

wInfo('Deshabilitar reinicio automatico en BSOD')

<#
Deshabilitar reinicio automatico en BSOD
[HKEY_LOCAL_MACHINE\System\ControlSet001\Control\CrashControl]
"AutoReboot"=dword:00000000
#>
Set-Reg('[HKEY_LOCAL_MACHINE\System\ControlSet001\Control\CrashControl]
"AutoReboot"=dword:00000000')


wInfo("reanudación de explorer.exe")
Start-Process explorer.exe
Start-Sleep -Seconds 2

#CONFIGURACIONES FINALES QUE REQUIEREN DE MS-SETTINGS

WTitulo('Activar "Mostrar más iconos en inicio"')
WRun('Activar en Configuración -> personalización -> inicio')
Wait-For -Run "ms-settings:personalization-start" -ProcessName "systemSettings"


WTitulo("Es necesario configurar 'Fondo' en 'Presentación' para la pantalla de bloqueo")
WRun('Activar en Configuración -> personalización -> inicio')
Wait-For -Run "ms-settings:lockscreen" -ProcessName "systemSettings"


WOk('Configuraciones adicionales terminadas')
