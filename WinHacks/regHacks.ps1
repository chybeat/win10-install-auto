<#
Instrucciones de instalacion de software

TODO DEBE HACERSE DESDE MODO AUDITORIA (SHIFT CTRL F3)!!!

Usar RegistryChanges View y sysinternals process monitor para verificar cambios en el registro!

POR AHORA NO SE DEBE ELIMINAR EL ARCHIVO DE TEXTO "Hacks ALL MY W10.TXT"
El archivo tiene la mayoría de procedimientos y ejemplos.

La idea final es ejecutar la mayor cantidad de comandos desde este script y que lo haga
automaticamente para casi todo, pero hay cosas que no se podrán hacer (como configurar parametros
específicoss en algunos programas).

En este archivo deben estar todas las instrucciones a seguir, y debe estar como hacer los cambios
de modo manual, si existe el cambio desde el registro, y/o el cmdlet/script para quie se ejecute.

=================
= IMPORTANTE!!! =
=================
Ejecutar este archivo desde el Windows Powershell ISE, para poder realizar el seguimiento

#>

wTitulo("Personalización de Windows")
wRun("Inicializando parametros y configuraciones del sistema")

wInfo("Cierre temporal de explorer.exe por cambios en el registro")
taskkill /im explorer.exe /F | Out-Null


<#=======================================================
= Cambiar el teclado e idioma de entrada predeterminado =
=======================================================#>

wInfo("Configurando el teclado, región e idioma de entrada predeterminado")

#Colocamdo pais o Region y todos los parametros de idioma a Español Colombia
Set-Reg('
[HKEY_CURRENT_USER\Control Panel\International]
"iCountry"="57"
"iCurrency"="2"
"iFirstDayOfWeek"="0"
"iNegCurr"="9"
"iTLZero"="0"
"Locale"="0000240A"
"LocaleName"="es-CO"
"s1159"="am"
"s2359"="pm"
"sDecimal"=","
"sLanguage"="ESO"
"sList"=";"
"sLongDate"="dddd, d ''de'' MMMM ''de'' yyyy"
"sMonDecimalSep"=","
"sMonThousandSep"="."
"sShortDate"="d/MM/yyyy"
"sShortTime"="h:mm tt"
"sThousand"="."
"sTimeFormat"="h:mm:ss tt"
"sYearMonth"="MMMM ''de'' yyyy"

[HKEY_CURRENT_USER\Control Panel\International\Geo]
"Name"="CO"
"Nation"="51"

[-HKEY_CURRENT_USER\Control Panel\International\User Profile\es-CO]
[HKEY_CURRENT_USER\Control Panel\International\User Profile\es-CO]
"240A:0000040A"=dword:00000002
"CachedLanguageName"="@Winlangdb.dll,-1130"

[-HKEY_CURRENT_USER\Control Panel\International\User Profile\es-MX]

[-HKEY_CURRENT_USER\Keyboard Layout\Preload]
[HKEY_CURRENT_USER\Keyboard Layout\Preload]
"1"="0000240a"

[-HKEY_CURRENT_USER\Keyboard Layout\Substitutes]
[HKEY_CURRENT_USER\Keyboard Layout\Substitutes]
"0000240a"="0000040a"

[-HKEY_CURRENT_USER\SOFTWARE\Microsoft\CTF\Assemblies\0x0000080a]
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\CTF\Assemblies\0x0000240a\{34745C63-B2F0-4784-8B67-5E12C8701A31}]
"Default"="{00000000-0000-0000-0000-000000000000}"
"KeyboardLayout"=dword:080a240a
"Profile"="{00000000-0000-0000-0000-000000000000}"

[-HKEY_CURRENT_USER\SOFTWARE\Microsoft\CTF\SortOrder\AssemblyItem\0x0000240a\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000]
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\CTF\SortOrder\AssemblyItem\0x0000240a\{34745C63-B2F0-4784-8B67-5E12C8701A31}\00000000]
"CLSID"="{00000000-0000-0000-0000-000000000000}"
"KeyboardLayout"=dword:080a240a
"Profile"="{00000000-0000-0000-0000-000000000000}"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\CTF\SortOrder\Language]
"00000000"="0000240a"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\International]
"AcceptLanguage"="es-CO,es;q=0.5"

[-HKEY_CURRENT_USER\SOFTWARE\Microsoft\Speech_OneCore\Isolated\19doMlW-AksKoLowG5I4Dxuzg9Gc9yEbRXrf_3fnBxE]

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Locales]
"InputLocale"=dword:0011240a

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Locales\loc_080A\InputMethods\1]
"Enabled"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Locales\loc_240A\InputMethods\1]
"Enabled"=dword:00000001

[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech_OneCore\Voices]

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\WP\TaskScheduler\Parameters]
"TimeZoneInfo"=hex:2c,01,00,00,48,00,6f,00,72,00,61,00,20,00,65,00,73,00,74,00,\
2e,00,20,00,50,00,61,00,63,00,ed,00,66,00,69,00,63,00,6f,00,2c,00,20,00,53,\
00,75,00,64,00,61,00,6d,00,e9,00,72,00,69,00,63,00,61,00,00,00,00,00,00,00,\
00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,48,00,6f,00,72,00,61,\
00,20,00,76,00,65,00,72,00,61,00,6e,00,6f,00,20,00,50,00,61,00,63,00,ed,00,\
66,00,69,00,63,00,6f,00,20,00,53,00,75,00,64,00,61,00,6d,00,e9,00,72,00,69,\
00,63,00,61,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,c4,ff,\
ff,ff,00,00,00,00

[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\DriverOperations\1]

[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackageIndex\Microsoft-Windows-LanguageFeatures-Speech-es-mx-Package~31bf3856ad364e35~wow64~~0.0.0.0]
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackageIndex\Microsoft-Windows-LanguageFeatures-Speech-es-mx-Package~31bf3856ad364e35~x86~~0.0.0.0]
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackageIndex\Microsoft-Windows-LanguageFeatures-TextToSpeech-es-mx-Package~31bf3856ad364e35~wow64~~0.0.0.0]
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackageIndex\Microsoft-Windows-LanguageFeatures-TextToSpeech-es-mx-Package~31bf3856ad364e35~x86~~0.0.0.0]
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\Microsoft-Windows-LanguageFeatures-Speech-es-mx-Package~31bf3856ad364e35~wow64~~10.0.19041.1]
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\Microsoft-Windows-LanguageFeatures-Speech-es-mx-Package~31bf3856ad364e35~x86~~10.0.19041.1]
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\Microsoft-Windows-LanguageFeatures-TextToSpeech-es-mx-Package~31bf3856ad364e35~wow64~~10.0.19041.1]
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\Microsoft-Windows-LanguageFeatures-TextToSpeech-es-mx-Package~31bf3856ad364e35~x86~~10.0.19041.1]

[HKEY_LOCAL_MACHINE\System\ControlSet001\Control\TimeZoneInformation]
"ActiveTimeBias"=dword:0000012c
"Bias"=dword:0000012c
"DaylightBias"=dword:00000000
"DaylightStart"=hex:00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
"StandardName"="@tzres.dll,-122"
"StandardStart"=hex:00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
"TimeZoneKeyName"="SA Pacific Standard Time"
')

<#
#Activar y dejar BloqNum Activo!
>>>>>> Desactivado por configuracion en portatiles

wInfo("Acivando 'Bloq Num'")
$keyBoardObject = New-Object -ComObject WScript.Shell
$numLockKeySatus = [System.Windows.Forms.Control]::IsKeyLocked('NumLock')
if ($numLockKeySatus -eq $false ){
	$keyBoardObject.SendKeys("{NUMLOCK}")
}
#>

<#==========================================
= Explorador de Windows y barra de tareas =
===========================================#>
wInfo("Configurando el Explorador de Archivos")

#Cambiar el nombre de la unidad C a Windows
Set-Volume -DriveLetter ($env:SystemDrive).replace(":", "") -NewFileSystemLabel "Windows 10"

<#Activar la cinta de opciones en el explorador debajo del boton cerrar (CTRL+F1)
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon]
"MinimizedStateTabletModeOff"=dword:00000000
#>

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon]
"MinimizedStateTabletModeOff"=dword:00000000')

<#
Opciones de carpeta
===================
Menú vista -> opciones

Abrir explorador de archivos para: Este equipo

En ver...
	Al escribir en la vista de lista (*)Seleccionar el elemento escrito en la vista
	Archivos y carpetas ocultos -> Mostrar archivos, carpetas y unidades ocultos
	mostrar siempre menus: activar
	ocultar archivos protegidos...: Desactivar
	ocultar las extensiones en archivos conocidos: desactivar
	ocutar unidades vacias: Desactivar
	usar las casillas para seleccionar elementos: activar
	expandir a carpeta abierta: activar
	mostrar todas las carpetas: activar

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"AlwaysShowMenus"=dword:00000001
"AutoCheckSelect"=dword:00000001
"HideDrivesWithNoMedia" =dword:00000000
"Hidden"=dword:00000001
"HideFileExt"=dword:00000000
"LaunchTo"=dword:00000001
"NavPaneExpandToCurrentFolder"=dword:00000001
"NavPaneShowAllFolders"=dword:00000001
"ShowSuperHidden"=dword:00000001
"TypeAhead"=dword:00000000


[HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"AlwaysShowMenus"=dword:00000001
"AutoCheckSelect"=dword:00000001
"Hidden"=dword:00000001
"HideDrivesWithNoMedia"=dword:00000000
"HideFileExt"=dword:00000000
"LaunchTo"=dword:00000001
"NavPaneExpandToCurrentFolder"=dword:00000001
"NavPaneShowAllFolders"=dword:00000001
"ShowSuperHidden"=dword:00000001
"TypeAhead"=dword:00000000
#>


wInfo("Configurando opciones de carpeta")
set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"AlwaysShowMenus"=dword:00000001
"AutoCheckSelect"=dword:00000001
"Hidden"=dword:00000001
"HideDrivesWithNoMedia"=dword:00000000
"HideFileExt"=dword:00000000
"LaunchTo"=dword:00000001
"NavPaneExpandToCurrentFolder"=dword:00000001
"NavPaneShowAllFolders"=dword:00000001
"ShowSuperHidden"=dword:00000001
"TypeAhead"=dword:00000000

[HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"AlwaysShowMenus"=dword:00000001
"AutoCheckSelect"=dword:00000001
"Hidden"=dword:00000001
"HideDrivesWithNoMedia"=dword:00000000
"HideFileExt"=dword:00000000
"LaunchTo"=dword:00000001
"NavPaneExpandToCurrentFolder"=dword:00000001
"NavPaneShowAllFolders"=dword:00000001
"ShowSuperHidden"=dword:00000001
"TypeAhead"=dword:00000000
')


<#
Propiedades de barra de tareas
==============================
#>
wInfo("Configurando la barra de tareas")

<#
Click derecho -> Búsqueda -> mostrar icono de búsqueda
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search]
"SearchboxTaskbarMode"=dword:00000001 > Solo icono
>> "SearchboxTaskbarMode"=dword:00000000 > Oculto
#>


Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search]
"SearchboxTaskbarMode"=dword:00000001')
<#
Click derecho -> Mostrar botón de cortana (desactivar)

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowCortanaButton"=dword:00000000
#>

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowCortanaButton"=dword:00000000')

<#
Inicio -> Configuración -> Personalización -> Barra de tareas
	Reemplazar simbolo de sistema por Windows PowerShell...
        ( *) Activado

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"DontUsePowerShellOnWinX"=dword:00000000

#>
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"DontUsePowerShellOnWinX"=dword:00000000')

<#
Inicio -> Configuración -> Personalización -> Barra de tareas
    Combinar los botones de la barra de tareas:
        ^ Si la barra de tareas esta llena
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarGlomLevel"=dword:00000001
#>

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarGlomLevel"=dword:00000001')

<#
Inicio -> Configuración -> Personalización -> Barra de tareas
	- Contactos
		Mostrar contactos en la barra de tareas: Desactivado
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People]
"PeopleBand"=dword:00000000
#>

Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People]
"PeopleBand"=dword:00000000')

<#===========================
= CMD - Ventana de comandos =
===========================#>
wInfo("Configurando la consola de comandos")

<#
Abrir ventana de comnandos como administrador y cambiar predeterminados
    -> Opciones
        Modalidad de edición rápida: Desactivado
	-> Fuente
		- Negrita: activado

    -> Diseño
	    -> Tamaño de ventana
		    -Ancho: 120
		    - Alto: 42
    ->
[HKEY_USERS\.DEFAULT\Console]
"FontWeight"=dword:000002bc
"WindowSize"=dword:002a0078

[HKEY_CURRENT_USER\Console]
"FontWeight"=dword:000002bc
"WindowSize"=dword:002a0078
#>

Set-Reg('[HKEY_USERS\.DEFAULT\Console]
"ColorTable01"=dword:00562401
"FontWeight"=dword:000002bc
"QuickEdit"=dword:00000000
"WindowSize"=dword:002a0078

[HKEY_CURRENT_USER\Console]
"ColorTable01"=dword:00562401
"FontWeight"=dword:000002bc
"QuickEdit"=dword:00000000
"WindowSize"=dword:002a0078

')


<#===============
= Bloc de notas =
===============#>
wInfo("Configurando el bloc de notas")

<#
Acomodar bloc de notas para que ocupe gran porción de la pantalla
(no maximizar, no garda el tamaño)
ver -> barra de estado

-[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Notepad]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Notepad]
"StatusBar"=dword:00000001'
"fWrap"=dword:00000000
#>
Set-Reg('-[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Notepad]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Notepad]
"fWrap"=dword:00000001
"StatusBar"=dword:00000001'
)

<#===============================
= Cambios varios en el registro =
===============================#>
wInfo("Colocar 'Abrir con PowerShell' como administrador en el menú contextual de carpetas")

Set-Reg('
[HKEY_CLASSES_ROOT\Directory\shell\powershellmenu]
@="Abrir con PowerShell"
"icon"="C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe,1"

[HKEY_CLASSES_ROOT\Directory\shell\powershellmenu\command]
@="powershell.exe -WindowStyle Hidden -Command \"Write-output ''Ejecutando como administrador...'' ; Start-Process PowerShell -Verb RunAs -ArgumentList ''-NoExit -Command \"Set-Location -LiteralPath \\\\\\\"%V\\\\\\\"\"''\""

[HKEY_CLASSES_ROOT\Folder\shell\powershellmenu]
@="Abrir con PowerShell"
"icon"="C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe,1"

[HKEY_CLASSES_ROOT\Folder\shell\powershellmenu\command]
@="powershell.exe -WindowStyle Hidden -Command \"Write-output ''Ejecutando como administrador...'' ; Start-Process PowerShell -Verb RunAs -ArgumentList ''-NoExit -Command \"Set-Location -LiteralPath \\\\\\\"%V\\\\\\\"\"''\""
')


wInfo("Configurando el usuario registrado de Windows por 'Usuario'")

<#
Nombre registrado del computador como Usuario
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion]
"RegisteredOrganization"="Usuario"
"RegisteredOwner"="Usuario"

x64
[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion]
"RegisteredOrganization"="Usuario"
"RegisteredOwner"=Usuario
#>

Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion]
	"RegisteredOrganization"="Usuario"
	"RegisteredOwner"="Usuario"
')

if ($x64) {
	Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion]
		"RegisteredOrganization"="Usuario"
		"RegisteredOwner"="Usuario"
	')
}



######################
# Carpeta temporales #
######################

wInfo("Configurando la carpeta temporal global")

#Permitiendo el acceso completo a la carpeta TEMP
wRun("Dando acceso completo a la carpeta temporal de Windows")
Set-FullAccess("${env:windir}\temp")

<#
Ambos (x86 & x64) Carpeta Temporal: %windir%\temp

[HKEY_CURRENT_USER\Environment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00

[HKEY_LOCAL_MACHINE\SOFTWARE\DefaultUserEnvironment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00

[HKEY_USERS\.DEFAULT\Environment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00

[HKEY_USERS\S-1-5-19\Environment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00

[HKEY_USERS\S-1-5-20\Environment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00
#>
Set-Reg('[HKEY_CURRENT_USER\Environment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00

[HKEY_LOCAL_MACHINE\SOFTWARE\DefaultUserEnvironment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00

[HKEY_USERS\.DEFAULT\Environment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00

[HKEY_USERS\S-1-5-19\Environment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00

[HKEY_USERS\S-1-5-20\Environment]
"TEMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,\
  00,6d,00,70,00,00,00
"TMP"=hex(2):25,00,77,00,69,00,6e,00,64,00,69,00,72,00,25,00,5c,00,74,00,65,00,\
  6d,00,70,00,00,00'
)

<#=====
= UAC =
=====#>
wInfo("Configurando el control de cuentas de usuario")

<#
cmd -> control userpasswords
	-> Cambiar configuración de Control de cuentas de usuario
		-> Elegir el valor más bajo
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]
"ConsentPromptBehaviorAdmin"=dword:00000000
"ConsentPromptBehaviorUser"=dword:00000000
"EnableLUA"=dword:00000001
"PromptOnSecureDesktop"=dword:00000000
#>

Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]
"ConsentPromptBehaviorAdmin"=dword:00000000
"ConsentPromptBehaviorUser"=dword:00000000
"EnableLUA"=dword:00000001
"PromptOnSecureDesktop"=dword:00000000
')

<#=========================
= Administrador de tareas =
=========================#>
wInfo("Configurando el administrador de tareas")
<#
	:::::::En el registro el dato preferences es distinto entre x86 y x64
	Mas detalles (activar)
	Opciones -> Minimizar al abrir (Desactivar)
	Vista -> Velocidad de actualizacion -> alta
	Vista -> Agrupar por tipo (Desactivar)

	Pestaña Rendimiento
	Cambiar grafico a -> Procesadores lógicos
	Mostrar tiempos de kernel



[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager]
"UseStatusSetting"=dword:00000001
"Preferences"="Es distinto entre x86 y x64"
#>

$x64_Prefs = '-[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager]
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager]
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
  00,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00'

$x86_Prefs ='-[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager]
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager]
"Preferences"=hex:0d,00,00,00,60,00,00,00,60,00,00,00,4e,01,00,00,a4,00,00,00,\
  c9,02,00,00,18,02,00,00,00,00,00,00,00,00,00,80,00,00,00,80,d8,01,00,80,df,\
  01,00,80,00,01,00,01,07,00,00,00,12,00,00,00,f0,02,00,00,94,02,00,00,f4,01,\
  00,00,00,00,00,00,00,00,00,00,0f,00,00,00,01,00,00,00,b4,de,ed,00,00,00,00,\
  00,00,00,00,00,ea,00,00,00,1e,00,00,00,89,90,00,00,00,00,00,00,ff,00,00,00,\
  01,01,50,02,0d,00,00,00,f0,de,ed,00,00,00,00,00,ff,ff,ff,ff,96,00,00,00,1e,\
  00,00,00,8b,90,00,00,01,00,00,00,00,00,00,00,00,10,10,01,03,00,00,00,04,df,\
  ed,00,00,00,00,00,ff,ff,ff,ff,78,00,00,00,1e,00,00,00,8c,90,00,00,02,00,00,\
  00,00,00,00,00,01,02,12,00,04,00,00,00,1c,df,ed,00,00,00,00,00,ff,ff,ff,ff,\
  96,00,00,00,1e,00,00,00,8d,90,00,00,03,00,00,00,00,00,00,00,00,01,10,01,02,\
  00,00,00,3c,df,ed,00,00,00,00,00,ff,ff,ff,ff,32,00,00,00,1e,00,00,00,8a,90,\
  00,00,04,00,00,00,00,00,00,00,00,08,20,01,05,00,00,00,50,df,ed,00,00,00,00,\
  00,ff,ff,ff,ff,c8,00,00,00,1e,00,00,00,8e,90,00,00,05,00,00,00,00,00,00,00,\
  00,01,10,01,06,00,00,00,74,df,ed,00,00,00,00,00,ff,ff,ff,ff,04,01,00,00,1e,\
  00,00,00,8f,90,00,00,06,00,00,00,00,00,00,00,00,01,10,01,07,00,00,00,98,df,\
  ed,00,00,00,00,00,ff,ff,ff,ff,49,00,00,00,49,00,00,00,90,90,00,00,07,00,00,\
  00,00,00,00,00,00,04,25,00,08,00,00,00,d8,de,ed,00,00,00,00,00,ff,ff,ff,ff,\
  49,00,00,00,49,00,00,00,91,90,00,00,08,00,00,00,00,00,00,00,00,04,25,00,09,\
  00,00,00,b8,df,ed,00,00,00,00,00,ff,ff,ff,ff,49,00,00,00,49,00,00,00,92,90,\
  00,00,09,00,00,00,00,00,00,00,00,04,25,08,0a,00,00,00,cc,df,ed,00,00,00,00,\
  00,ff,ff,ff,ff,49,00,00,00,49,00,00,00,93,90,00,00,0a,00,00,00,00,00,00,00,\
  00,04,25,08,0b,00,00,00,e8,df,ed,00,00,00,00,00,ff,ff,ff,ff,49,00,00,00,49,\
  00,00,00,39,a0,00,00,0b,00,00,00,00,00,00,00,00,04,25,09,1c,00,00,00,08,e0,\
  ed,00,00,00,00,00,ff,ff,ff,ff,c8,00,00,00,49,00,00,00,3a,a0,00,00,0c,00,00,\
  00,00,00,00,00,00,01,10,09,1d,00,00,00,30,e0,ed,00,00,00,00,00,ff,ff,ff,ff,\
  64,00,00,00,49,00,00,00,4c,a0,00,00,0d,00,00,00,00,00,00,00,00,02,15,08,1e,\
  00,00,00,50,e0,ed,00,00,00,00,00,ff,ff,ff,ff,64,00,00,00,49,00,00,00,4d,a0,\
  00,00,0e,00,00,00,00,00,00,00,00,02,15,08,03,00,00,00,0a,00,00,00,01,00,00,\
  00,b4,de,ed,00,00,00,00,00,00,00,00,00,d7,00,00,00,1e,00,00,00,89,90,00,00,\
  00,00,00,00,ff,00,00,00,01,01,50,02,04,00,00,00,1c,df,ed,00,00,00,00,00,01,\
  00,00,00,96,00,00,00,1e,00,00,00,8d,90,00,00,01,00,00,00,00,00,00,00,01,01,\
  10,00,03,00,00,00,04,df,ed,00,00,00,00,00,ff,ff,ff,ff,64,00,00,00,1e,00,00,\
  00,8c,90,00,00,02,00,00,00,00,00,00,00,00,02,10,00,0c,00,00,00,7c,e0,ed,00,\
  00,00,00,00,03,00,00,00,64,00,00,00,1e,00,00,00,94,90,00,00,03,00,00,00,00,\
  00,00,00,01,02,10,00,0d,00,00,00,a4,e0,ed,00,00,00,00,00,ff,ff,ff,ff,64,00,\
  00,00,1e,00,00,00,95,90,00,00,04,00,00,00,00,00,00,00,00,01,10,01,0e,00,00,\
  00,c8,e0,ed,00,00,00,00,00,05,00,00,00,32,00,00,00,1e,00,00,00,96,90,00,00,\
  05,00,00,00,00,00,00,00,01,04,20,01,0f,00,00,00,f0,e0,ed,00,00,00,00,00,06,\
  00,00,00,32,00,00,00,1e,00,00,00,97,90,00,00,06,00,00,00,00,00,00,00,01,04,\
  20,01,10,00,00,00,10,e1,ed,00,00,00,00,00,07,00,00,00,46,00,00,00,1e,00,00,\
  00,98,90,00,00,07,00,00,00,00,00,00,00,01,01,10,01,11,00,00,00,30,e1,ed,00,\
  00,00,00,00,ff,ff,ff,ff,64,00,00,00,1e,00,00,00,99,90,00,00,08,00,00,00,00,\
  00,00,00,00,01,10,01,06,00,00,00,74,df,ed,00,00,00,00,00,09,00,00,00,04,01,\
  00,00,1e,00,00,00,8f,90,00,00,09,00,00,00,00,00,00,00,01,01,10,01,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,04,00,00,\
  00,0b,00,00,00,01,00,00,00,b4,de,ed,00,00,00,00,00,00,00,00,00,d7,00,00,00,\
  1e,00,00,00,9e,90,00,00,00,00,00,00,ff,00,00,00,01,01,50,02,12,00,00,00,54,\
  e1,ed,00,00,00,00,00,ff,ff,ff,ff,2d,00,00,00,1e,00,00,00,9b,90,00,00,01,00,\
  00,00,00,00,00,00,00,04,20,01,14,00,00,00,74,e1,ed,00,00,00,00,00,ff,ff,ff,\
  ff,64,00,00,00,1e,00,00,00,9d,90,00,00,02,00,00,00,00,00,00,00,00,01,10,01,\
  13,00,00,00,98,e1,ed,00,00,00,00,00,ff,ff,ff,ff,64,00,00,00,1e,00,00,00,9c,\
  90,00,00,03,00,00,00,00,00,00,00,00,01,10,01,03,00,00,00,04,df,ed,00,00,00,\
  00,00,ff,ff,ff,ff,64,00,00,00,1e,00,00,00,8c,90,00,00,04,00,00,00,00,00,00,\
  00,01,02,10,00,07,00,00,00,98,df,ed,00,00,00,00,00,05,00,00,00,49,00,00,00,\
  49,00,00,00,90,90,00,00,05,00,00,00,00,00,00,00,01,04,21,00,08,00,00,00,d8,\
  de,ed,00,00,00,00,00,06,00,00,00,49,00,00,00,49,00,00,00,91,90,00,00,06,00,\
  00,00,00,00,00,00,01,04,21,00,09,00,00,00,b8,df,ed,00,00,00,00,00,07,00,00,\
  00,49,00,00,00,49,00,00,00,92,90,00,00,07,00,00,00,00,00,00,00,01,04,21,08,\
  0a,00,00,00,cc,df,ed,00,00,00,00,00,08,00,00,00,49,00,00,00,49,00,00,00,93,\
  90,00,00,08,00,00,00,00,00,00,00,01,04,21,08,0b,00,00,00,e8,df,ed,00,00,00,\
  00,00,09,00,00,00,49,00,00,00,49,00,00,00,39,a0,00,00,09,00,00,00,00,00,00,\
  00,01,04,21,09,1c,00,00,00,08,e0,ed,00,00,00,00,00,0a,00,00,00,64,00,00,00,\
  49,00,00,00,3a,a0,00,00,0a,00,00,00,00,00,00,00,00,01,10,09,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,02,00,00,00,08,00,00,00,01,00,00,00,b4,de,ed,00,00,00,00,00,\
  00,00,00,00,c6,00,00,00,1e,00,00,00,b0,90,00,00,00,00,00,00,ff,00,00,00,01,\
  01,50,02,15,00,00,00,b8,e1,ed,00,00,00,00,00,ff,ff,ff,ff,6b,00,00,00,1e,00,\
  00,00,b1,90,00,00,01,00,00,00,00,00,00,00,00,04,25,00,16,00,00,00,e4,e1,ed,\
  00,00,00,00,00,ff,ff,ff,ff,6b,00,00,00,1e,00,00,00,b2,90,00,00,02,00,00,00,\
  00,00,00,00,00,04,25,00,18,00,00,00,08,e2,ed,00,00,00,00,00,ff,ff,ff,ff,6b,\
  00,00,00,1e,00,00,00,b4,90,00,00,03,00,00,00,00,00,00,00,00,04,25,00,17,00,\
  00,00,30,e2,ed,00,00,00,00,00,ff,ff,ff,ff,6b,00,00,00,1e,00,00,00,b3,90,00,\
  00,04,00,00,00,00,00,00,00,00,04,25,00,19,00,00,00,64,e2,ed,00,00,00,00,00,\
  ff,ff,ff,ff,a0,00,00,00,1e,00,00,00,b5,90,00,00,05,00,00,00,00,00,00,00,00,\
  04,20,01,1a,00,00,00,90,e2,ed,00,00,00,00,00,ff,ff,ff,ff,7d,00,00,00,1e,00,\
  00,00,b6,90,00,00,06,00,00,00,00,00,00,00,00,04,20,01,1b,00,00,00,c0,e2,ed,\
  00,00,00,00,00,ff,ff,ff,ff,7d,00,00,00,1e,00,00,00,b7,90,00,00,07,00,00,00,\
  00,00,00,00,00,04,20,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
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
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,01,00,00,00,00,00,00,01,00,00,00,\
  00,00,00,00,00,00,5c,00,3f,00,5c,00,53,00,43,00,53,00,49,00,23,00,44,00,69,\
  00,73,00,6b,00,26,00,56,00,65,00,6e,00,5f,00,54,00,4f,00,53,00,48,00,49,00,\
  42,00,41,00,26,00,50,00,72,00,6f,00,64,00,5f,00,44,00,54,00,30,00,31,00,41,\
  00,43,00,41,00,31,00,30,00,30,00,23,00,34,00,26,00,32,00,36,00,38,00,63,00,\
  35,00,39,00,35,00,61,00,26,00,30,00,26,00,30,00,32,00,30,00,30,00,30,00,30,\
  00,23,00,7b,00,35,00,33,00,66,00,35,00,36,00,33,00,30,00,37,00,2d,00,62,00,\
  36,00,62,00,66,00,2d,00,31,00,31,00,64,00,30,00,2d,00,39,00,34,00,66,00,32,\
  00,2d,00,30,00,30,00,61,00,30,00,63,00,39,00,31,00,65,00,66,00,62,00,38,00,\
  62,00,7d,00,00,00,62,00,38,00,62,00,7d,00,00,00,00,00,00,00,00,00,00,00,00,\
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
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01,00,da,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,9d,20,00,00,20,00,\
  00,00,91,00,00,00,64,00,00,00,32,00,00,00,97,00,00,00,50,00,00,00,32,00,00,\
  00,32,00,00,00,28,00,00,00,50,00,00,00,3c,00,00,00,50,00,00,00,50,00,00,00,\
  32,00,00,00,50,00,00,00,50,00,00,00,50,00,00,00,50,00,00,00,50,00,00,00,50,\
  00,00,00,50,00,00,00,28,00,00,00,50,00,00,00,23,00,00,00,23,00,00,00,23,00,\
  00,00,23,00,00,00,50,00,00,00,50,00,00,00,50,00,00,00,32,00,00,00,32,00,00,\
  00,32,00,00,00,78,00,00,00,78,00,00,00,50,00,00,00,3c,00,00,00,50,00,00,00,\
  64,00,00,00,78,00,00,00,32,00,00,00,78,00,00,00,78,00,00,00,32,00,00,00,50,\
  00,00,00,50,00,00,00,50,00,00,00,50,00,00,00,c8,00,00,00,00,00,00,00,01,00,\
  00,00,02,00,00,00,03,00,00,00,04,00,00,00,05,00,00,00,06,00,00,00,07,00,00,\
  00,08,00,00,00,09,00,00,00,0a,00,00,00,0b,00,00,00,0c,00,00,00,0d,00,00,00,\
  0e,00,00,00,0f,00,00,00,10,00,00,00,11,00,00,00,12,00,00,00,13,00,00,00,14,\
  00,00,00,15,00,00,00,16,00,00,00,17,00,00,00,18,00,00,00,19,00,00,00,1a,00,\
  00,00,1b,00,00,00,1c,00,00,00,1d,00,00,00,1e,00,00,00,1f,00,00,00,20,00,00,\
  00,21,00,00,00,22,00,00,00,23,00,00,00,24,00,00,00,25,00,00,00,26,00,00,00,\
  27,00,00,00,28,00,00,00,29,00,00,00,2a,00,00,00,2b,00,00,00,2c,00,00,00,2d,\
  00,00,00,2e,00,00,00,2f,00,00,00,00,00,00,00,00,00,00,00,1f,00,00,00,00,00,\
  00,00,b4,00,00,00,32,00,00,00,d8,00,00,00,64,00,00,00,64,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01,00,\
  00,00,02,00,00,00,03,00,00,00,04,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01,00,00,00,00,00,\
  00,00,00,00,00,00,00,00,00,00'

if ($x86) {
	Set-Reg($x86_Prefs)
} else {
	Set-Reg($x64_Prefs)
}

bcdedit /set `{default`} bootmenupolicy legacy

#OMITIDA LA REANUDACION PARA AGILIZACION
#wInfo("Reanudando explorer.exe")
#Start-Process explorer.exe
#Start-Sleep 2
