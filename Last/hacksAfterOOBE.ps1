#Hacks que no quedaron despues de OOBE!
wInfo("Configurando el teclado, región e idioma de entrada predeterminado")
set-reg('[HKEY_CURRENT_USER\Control Panel\International]
"iFirstDayOfWeek"="0"
"s1159"="am"
"s2359"="pm"

[HKEY_CURRENT_USER\Control Panel\International\Geo]
"Name"="CO"
"Nation"="51"
')

wInfo("Configurando Color")
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent]
"AccentPalette" = hex(3):86, CA, FF, 00, 5F, B2, F2, 00, 1E, 91, EA, 00, 00, 63, B1, 00, 00, \
  42, 75, 00, 00, 2D, 4F, 00, 00, 20, 38, 00, 00, CC, 6A, 00
')

wInfo("Configurando opciones de privacidad")
Set-Reg('[HKEY_CURRENT_USER\Control Panel\International\User Profile]
"HttpAcceptLanguageOptOut"=dword:00000001
')

wInfo("Configurando Aplicaciones en segundo plano")
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications]
"GlobalUserDisabled"=dword:00000001
')
wInfo("Seleccionar toda la fila en explorador de Windows")
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"FullRowSelect"=dword:00000001
')

wInfo("Activar el visualizador de fotos de Windows")
Set-Reg('[HKEY_CURRENT_USER\Software\Classes\.tga]
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

wInfo("Mostrar notificación de uso de camara")
Set-Reg('[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"NoPhysicalCameraLED"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"NoPhysicalCameraLED"=dword:00000001
')

Set-Reg('[HKEY_LOCAL_MACHINE\Software\Classes\Directory\background\shell\cmd]
"ShowBasedOnVelocityId"=dword:00639bc8
"HideBasedOnVelocityId"=-

[HKEY_LOCAL_MACHINE\Software\Classes\Directory\shell\cmd]
"ShowBasedOnVelocityId"=dword:00639bc8
"HideBasedOnVelocityId"=-')
