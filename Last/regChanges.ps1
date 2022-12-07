#Hacks que no se guardan despues de sysprep
#Ejecutar antes de ejecutar los tweaks de Ultimate Windows Tweaker y 0&0

wRun("Aplicando configuraciones de Windows adicionales")
#International Primer día de la semana
Set-Reg('[HKEY_CURRENT_USER\Control Panel\International]

;Posiblemente no se guarda por el cambio de idioma que se realiza
"iFirstDayOfWeek"="0"

[HKEY_LOCAL_MACHINE\System\ControlSet001\Control\TimeZoneInformation]
"DaylightBias"=dword:00000000
')

#Configuración de bloc de notas
Set-Reg('-[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Notepad]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Notepad]
"StatusBar"=dword:00000001'
)

#Configuración de fondos de pantalla
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers]
"BackgroundType"=dword:00000002
"BackgroundHistoryPath0"=-
"BackgroundHistoryPath1"=-
"BackgroundHistoryPath2"=-
"BackgroundHistoryPath3"=-
"BackgroundHistoryPath4"=-
')

#Conficuración de acciones rápidas del centro de acciones
Set-Reg('[HKEY_CURRENT_USER\Control Panel\Quick Actions\Control Center\Unpinned]
"Microsoft.QuickAction.AllSettings"=hex(0):
"Microsoft.QuickAction.Location"=hex(0):
"Microsoft.QuickAction.Project"=hex(0):
"Microsoft.QuickAction.Vpn"=hex(0):

[HKEY_CURRENT_USER\Control Panel\Quick Actions\Control Center]
AppliedDefaultPins=dword:00000001
')

#Configuración de color
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM]
"AccentColor"=dword:ffb16300
"ColorizationAfterglow"=dword:c40063b1
"ColorizationColor"=dword:c40063b1

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent]
"AccentPalette"=hex(3):86,CA,FF,00,5F,B2,F2,00,1E,91,EA,00,00,63,B1,00,00,\
42,75,00,00,2D,4F,00,00,20,38,00,00,CC,6A,00
"StartColorMenu"=dword:ff754200
"AccentColorMenu"=dword:ffb16300

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"ColorPrevalence"=dword:00000001
')

#Pantalla de bloqueo
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen]
"SlideshowEnabled"=dword:00000001
')

#Configuración de presentacion avanzada
Set-Reg('
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen]
"SlideshowOptimizePhotoSelection"=dword:00000000
')

#           -> [] Activar inicio rápido (recomendado): Desactivar
Set-Reg('[HKEY_LOCAL_MACHINE\System\ControlSet001\Control\Session Manager\Power]
"HiberbootEnabled"=dword:00000000
')

Set-Reg('[HKEY_CURRENT_USER\Software\Classes\.bmp]
@="PhotoViewer.FileAssoc.Tiff"
')
#########################
# OTRAS CONFIGURACIONES #
#########################


#Eliminar el icono de reunirse de la barra de tareas
Set-Reg('[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"HideSCAMeetNow"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"HideSCAMeetNow"=dword:00000001
')
WOk('Configuraciones adicionales terminadas')

<#
Mostrar notificación cuando se use la camara
#>

Set-Reg('[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"NoPhysicalCameraLED"=dword:00000001
')
