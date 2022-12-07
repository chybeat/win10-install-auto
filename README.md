# Instalación automatizada de Windows 10

Esta colección de scripts está pensada para realizar una instalación desatendida y configurada de Windows 10 con algunas utilidades y mejoras. El proceso se dá en 2 partes, desde el modo de auditoría y en el primer inicio de sesion luego de OOBE, y su correcta ejecución se basa en el archvo de repuesta generado con el kit de evaluación e implementación de Windows ([Windows ADK](https://learn.microsoft.com/es-es/windows-hardware/get-started/adk-install)).

## Contenido del repositorio

En este repositorio están exclusivamente los archivos de script para ejecución en Powershell el archivo binario de la base de datos de los programas a instalar, además de unos binarios con información personal para soporte técnico y `pts.dll` que es la información de configuración para powertoys (un zip renombrado por mis gusto... 🥚🥚).

⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠

**En este repositorio no existe ningún script para descargar programas,**
**o los ejecutables de alguno de los programas que se instalan!**

⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠ ⚠

## Recuperación de archivos omitidos

En el archivo `.gitignore` hay un listado de los archivos que fueron omitidos y que pueden ser requeridos para realizar una instalación. Algunos otros que son utilizados pueden conseguirse en internet y otros simplemente son privativos, de uso promocional o de indole personal.

#### Enlaces de descarga:

<ins>Navegadores web:</ins>
Ejecutables ubicados en `\last\lib`
[ChromeSetup.exe](https://www.google.com/intl/es-419/chrome/)
[Firefox Installer.exe](https://www.mozilla.org/es-ES/firefox/new/)
[OperaSetup.exe](https://www.opera.com/es-419/download)

<ins>PsExec:</ins>
Estos deben estar ubicados en `\lib`
[PsExec.exe / PsExec64.exe](https://learn.microsoft.com/en-us/sysinternals/downloads/psexec)

<ins>SQLite command-line shell: (sqlite-tools)</ins>
Debe ubicarse en `\lib` [sqlite.exe](https://sqlite.org/download.html)

_Los enlaces pueden cambiar con el tiempo, depende de cada desarrollador._

## Desarrollo y modificación

Para modificar los scripts se recomienda utilizar Windows Powershell ISE o Visual Studio Code, para este último en la carpeta `\vscode` (no confundir con `\.vscode`) se puede descargar la version más reciente para la arquitecutra del sistema operativo donde se va a trabajar ejecutando el archivo `instalar.cmd`.

#### Configuración de Visual Studio Code

El archivo `instalar.cmd` activa la ejecución de scripts ya que existe una restricción de ejecución de los mismos desde Windows. **Tener muy en cuenta** que este script se proporciona con el fin de instalar Visual Studio Code en sistemas que no lo tengan o que por algún motivo se requiera reconfigurar por completo ya que se eliminan todas las configuraciones y extensiones instaladas previamente.

<ins>Proceso del script</ins>

1. Verifica y requiere ejecución como usuario administrador
1. Activa ejecución de scripts en powershell
1. Lanza un script en powershell (`\vscode\get-vscode.ps1`)
1. Realiza la descarga de Visual Studio Code en su versión más reciente para la correspondiente arquitectura del sistema operativo (x86 / x64)
1. Genera un archivo de instalación automatizado (`inst.inf`)
1. Elimina (no realiza la desinstalación) de Visual Studio Cod y también de todas sus carpetas de configuración
1. Inicia y cierra visual studio code para proceder con la instalación de algunas extensiones(powershell, prettier, material icon theme, markdown preview enhanced, sort lines y vs code xml format)
1. Copia los archivos de configuración Visual Studio Code `powershell.json`(snippets) y `settings.json`(configuración global de vscode) a las carpetas donde son requeridas
1. Genera un enlace con ejecución como administrador activada en el escritorio de Windows y en el menú inicio
1. Por último ejecuta el espacio de trabajo del proyecto en Visual Studio Code, donde la ejecución predeterminada siempre es el archivo `\test.ps1` y puede ser cambiada desde el archivo `.vscode\launch.json`

## Consideraciones

-  La idea principal de este proyecto es automatizar tareas, en ningun momento se incita a la piratería de software.
-  La ejecución del instalador de Visual Studio Code se propone para una instalación de Windows donde se realicen cambios y/o ejecución de estos scripts, no como método de actualización del mismo, pero puede servir de guía para realizar una instalación automatizada del programa.
-  Cualquier archivo, configuración o script aqui expuesto puede ser utilizado para uso de quien lo quiera utilizar, no hay restricción de ningún modo, aunque un `gracias` es bien recibido :).
-  Usarlo bajo su propio riesgo, hay scripts que modifican demasiado Windows y puede no ser del agrado/gusto de cualquier usuario.
-  **ESTE PROYECTO NO ESTA DIRIGIDO A USUARIOS FINALES DE WINDOWS NI DEBE SER USADO SIN HABER LEIDO TODOS LOS COMENTARIOS DENTRO DE CADA SCRIPT. HAY SCRIPTS QUE HACEN LOCURAS AL SISTEMA OPERATICO Y QUE PARA SU CORRECTO FUNCIONAMIENTO DEBEN SER EJECUTADOS SECUENCIALMENTE COMO ESTÁ PROPUESTO**.
-  Para iniciar la ejecución solo se debe dar doble click en `\-- iniciar.cmd`.

Creado por ChyBeat para uso de PCBogota.com ©2022

![This license lets others remix, adapt, and build upon your work non-commercially, and although their new works must also acknowledge you and be non-commercial, they don’t have to license their derivative works on the same terms.](https://licensebuttons.net/l/by-nc/3.0/88x31.png)
Creado bajo [licencia creative commons CC BY-NC](https://creativecommons.org/licenses/by-nc/4.0/legalcode) para que lo modifiquen usen o lo tomen como guía, pero no para su venta.
