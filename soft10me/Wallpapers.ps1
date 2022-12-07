<# WALLPAPERS
===========#>
wRun("Instalando fondos de pantalla")

$wpSrcPath = Get-Path -Filename "wallpapers_PCBOG.exe" -path "Programas\Apariencia\wallpapers" -Limit 1 -Full
Start-Process $wpSrcPath -Wait

#CONFIGURACION DE FONDO OMITIDO YA QUE DESPUES DE OOBE SE DEBE REINICIAR IGUALMENTE
#wInfo("Configurando Fondo")
#WTitulo("Es necesario configurar 'Fondo' en 'Presentación'")
#Wait-For -Run "ms-settings:personalization-background" -ProcessName "systemSettings"
#
#wInfo("Cierre temporal de explorer.exe por cambios en el registro")
#taskkill /im explorer.exe /F | Out-Null

<# Configuración -> Personalizacion -> Fondo
Fondo: Presentacion
elegir álbumes para la presentación: (ruta) c:\windows\web\wallpaper
cambiar imagen cada: 1 dia
orden aleatorio: activado

Set-Reg(
-[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers]
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers]
"BackgroundType"=dword:00000002
"SlideshowSourceDirectoriesSet"=dword:00000001
"CurrentWallpaperPath"="C:\\Windows\\web\\wallpaper\\Windows\\img0.jpg"
"SlideshowDirectoryPath1"="+GAFA8BUg/E0gouOpBhoYjAArADMdmBAvMkOcBAAAAAAAAAAAAAAAAAAAAAAAAgVAEDAAAAAAcMUinCEAcVauR2b3NHAABQCAQAAv77hPdHSIDFJN5CAAAQLGAAAAAQAAAAAAAAAAAAAAAAAAAAADBr7AcFApBgbAQGAvBwdAMHAAAgFAoEAxAAAAAAAH+04LBBAXVmYAgDAJAABA8uvH+02JhMU7vkLAAAAzVBAAAAABAAAAAAAAAAAAAAAAAAAAIEEmDwVAUGAiBAAAIBAvDQMAAAAAAwhPtdSQAwVhxGbwFGclJHAEBQCAQAAv77hPtdSIDlDM5CAAAAeVAAAAAQAAAAAAAAAAAAAAAAAAAAANwztAcFAhBAbAwGAwBQYAAHAlBgcAAAAYAwkAAAAnAw7+WIAAAQMTB1U32pr/3IH/PUgMSIQ6M6ctkGAAAAZAAAAA8BAAAALAAAA3BQaA4GAkBwbAcHAzBgLAkGAtBQbAUGAyBwcAkGA2BQZAMGAvBgbAQHAyBwbAwGAwBQYA4GAlBAbA8FAjBwdAUDAuBQMAgGAyAAdAgHA5BQZAcHA5BAAAAAAAAAAAAAAYAAAAA"

[HKEY_CURRENT_USER\Control Panel\Personalization\Desktop Slideshow]
"Interval"=dword:05265c00
"Shuffle"=dword:00000001)
#>

Set-Reg('-[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers]
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers]
"BackgroundType"=dword:00000002
"CurrentWallpaperPath"="%WinDir%\web\wallpaper\wallpaper (819).jpg"
"SlideshowSourceDirectoriesSet"=dword:00000001
"SlideshowDirectoryPath1"="+GAFA8BUg/E0gouOpBhoYjAArADMdmBAvMkOcBAAAAAAAAAAAAAAAAAAAAAAAAgVAEDAAAAAAcMUinCEAcVauR2b3NHAABQCAQAAv77hPdHSIDFJN5CAAAQLGAAAAAQAAAAAAAAAAAAAAAAAAAAADBr7AcFApBgbAQGAvBwdAMHAAAgFAoEAxAAAAAAAH+04LBBAXVmYAgDAJAABA8uvH+02JhMU7vkLAAAAzVBAAAAABAAAAAAAAAAAAAAAAAAAAIEEmDwVAUGAiBAAAIBAvDQMAAAAAAwhPtdSQAwVhxGbwFGclJHAEBQCAQAAv77hPtdSIDlDM5CAAAAeVAAAAAQAAAAAAAAAAAAAAAAAAAAANwztAcFAhBAbAwGAwBQYAAHAlBgcAAAAYAwkAAAAnAw7+WIAAAQMTB1U32pr/3IH/PUgMSIQ6M6ctkGAAAAZAAAAA8BAAAALAAAA3BQaA4GAkBwbAcHAzBgLAkGAtBQbAUGAyBwcAkGA2BQZAMGAvBgbAQHAyBwbAwGAwBQYA4GAlBAbA8FAjBwdAUDAuBQMAgGAyAAdAgHA5BQZAcHA5BAAAAAAAAAAAAAAYAAAAA"

[HKEY_CURRENT_USER\Control Panel\Personalization\Desktop Slideshow]
"Interval"=dword:05265c00
"Shuffle"=dword:00000001')

Remove-Item -Path "$env:appdata\microsoft\windows\themes\*" -Force -Recurse
Copy-Item "$env:windir\web\wallpaper\wallpaper (819).jpg" -Destination "$env:appdata\microsoft\windows\themes\transcodedwallpaper" -Force -Recurse

#OMITIDA LA REANUDACION PARA AGILIZACION
#Start-Sleep 2
#wInfo("Reanudando explorer.exe")
#Start-Process explorer.exe
#wOk("Fondos de pantalla instalados")
