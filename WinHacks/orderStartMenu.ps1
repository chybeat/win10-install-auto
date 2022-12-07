$moveFrom = "$env:Appdata\Microsoft\Windows\Start Menu"
$destRoot = "$env:ProgramData\Microsoft\Windows\Start Menu"

#Enlaces a omitir para mover desde la carpeta de usuario (Administrador)
$omitSource = @(
	#Enlaces de Windows (omitir)
	"$moveFrom\Programs\Accessibility\Magnify.lnk", #Accesibilidad de Windows
	"$moveFrom\Programs\Accessibility\Narrator.lnk", #Accesibilidad de Windows
	"$moveFrom\Programs\Accessibility\On-Screen Keyboard.lnk", #Accesibilidad de Windows
	"$moveFrom\Programs\Accessories\Internet Explorer.lnk", #Accesorios de Windows
	"$moveFrom\Programs\System Tools\Administrative Tools.lnk",
	"$moveFrom\Programs\System Tools\Command Prompt.lnk",
	"$moveFrom\Programs\System Tools\computer.lnk",
	"$moveFrom\Programs\System Tools\Control Panel.lnk",
	"$moveFrom\Programs\System Tools\File Explorer.lnk",
	"$moveFrom\Programs\System Tools\Run.lnk",
	"$moveFrom\Programs\Windows PowerShell\Windows PowerShell.lnk",
	"$moveFrom\Programs\Windows PowerShell\Windows PowerShell (x86).lnk",
	"$moveFrom\Programs\OneDrive.lnk",

	#offce web (posiblemnte existan)
	"$moveFrom\Programs\Excel.lnk",
	"$moveFrom\Programs\Outlook.lnk",
	"$moveFrom\Programs\PowerPoint.lnk",
	"$moveFrom\Programs\Word.lnk"
	<#
        Carpetas sin .lnk
        Herramientas administrativas de Windows
        Inicio
        Maintenance
#>
)
$omitSource = $omitSource -join "|"

#orden y jerarquización de arbol de destino
$destOrder = @(
	#Programs
	"$destRoot\Programs\7-Zip File Manager.lnk",
	"$destRoot\Programs\AnyDesk.lnk",
	"$destRoot\Programs\CmapTools.lnk",
	"$destRoot\Programs\Dia.lnk",
	"$destRoot\Programs\Markdown Viewer.lnk",
	"$destRoot\Programs\Preps 9.lnk",
	"$destRoot\Programs\PowerToys (Preview).lnk",
	"$destRoot\Programs\qBittorrent.lnk",
	"$destRoot\Programs\Skype.lnk",
	"$destRoot\Programs\Suamtra.lnk",
	"$destRoot\Programs\TeamViewer.lnk",
	"$destRoot\Programs\UltraSearch.lnk",
	"$destRoot\Programs\Visual Studio Code.lnk",
	"$destRoot\Programs\Winamp.lnk",
	"$destRoot\Programs\WinRAR.lnk",

	#3Planesoft
	"$destRoot\Programs\3Planesoft\Open 3Planesoft Screensaver Manager.lnk",
	"$destRoot\Programs\3Planesoft\Animal World 3D Animated Wallpaper.lnk",
	"$destRoot\Programs\3Planesoft\Animal World 3D Screensaver.lnk",
	"$destRoot\Programs\3Planesoft\Earth 3D Animated Wallpaper.lnk",
	"$destRoot\Programs\3Planesoft\Earth 3D Screensaver.lnk",
	"$destRoot\Programs\3Planesoft\Flag 3D Animated Wallpaper.lnk",
	"$destRoot\Programs\3Planesoft\Flag 3D Screensaver.lnk",
	"$destRoot\Programs\3Planesoft\Human World 3D Animated Wallpaper.lnk",
	"$destRoot\Programs\3Planesoft\Human World 3D Screensaver.lnk",
	"$destRoot\Programs\3Planesoft\Mechanical Clock 3D Animated Wallpaper.lnk",
	"$destRoot\Programs\3Planesoft\Mechanical Clock 3D Screensaver.lnk",
	"$destRoot\Programs\3Planesoft\Plant World 3D Animated Wallpaper.lnk",
	"$destRoot\Programs\3Planesoft\Plant World 3D Screensaver.lnk",
	"$destRoot\Programs\3Planesoft\The Lost Watch 3D Animated Wallpaper.lnk",
	"$destRoot\Programs\3Planesoft\The Lost Watch 3D Screensaver.lnk",

	#Adobe Creative Suite 32-Bit
	"$destRoot\Programs\Adobe Creative Suite\Adobe Acrobat DC.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Acrobat Distiller DC.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Bridge CC 2018 (32 Bit).lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Creative Cloud.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Dreamweaver CC 2018.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Illustrator CC 2018 (32 Bit).lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe InDesign CC 2018 (32-bit).lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Photoshop CC 2018 (32 Bit).lnk",

	#Adobe Creative Suite 64-Bit
	"$destRoot\Programs\Adobe Creative Suite\Adobe Acrobat Distiller.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Acrobat.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe InCopy 2022.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe After Effects 2022.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Audition 2022.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Bridge 2022.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Dreamweaver 2021.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Illustrator 2022.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe InDesign 2022.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Lightroom Classic.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Media Encoder 2022.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Photoshop 2022.lnk",
	"$destRoot\Programs\Adobe Creative Suite\Adobe Premiere Pro 2022.lnk",

	#Microsoft Office
	"$destRoot\Programs\Access.lnk",
	"$destRoot\Programs\Excel.lnk",
	"$destRoot\Programs\OneNote.lnk",
	"$destRoot\Programs\Outlook.lnk",
	"$destRoot\Programs\PowerPoint.lnk",
	"$destRoot\Programs\Project.lnk",
	"$destRoot\Programs\Publisher.lnk",
	"$destRoot\Programs\Visio.lnk",
	"$destRoot\Programs\Word.lnk",
	#"$destRoot\Programs\Herramientas de Microsoft Office\Centro de carga de Office.lnk", # ya no existe
	"$destRoot\Programs\Herramientas de Microsoft Office\Database Compare.lnk",
	"$destRoot\Programs\Herramientas de Microsoft Office\Panel de telemetría para Office.lnk",
	"$destRoot\Programs\Herramientas de Microsoft Office\Preferencias de idioma de Office.lnk",
	"$destRoot\Programs\Herramientas de Microsoft Office\Project Server Accounts.lnk",
	"$destRoot\Programs\Herramientas de Microsoft Office\Registro de telemetría para Office.lnk",
	"$destRoot\Programs\Herramientas de Microsoft Office\Spreadsheet Compare.lnk",

	#Utilidades de mantenimiento
	"$destRoot\Programs\Utilidades de Mantenimiento\Advanced IP Scanner.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\Auslogics Registry Defrag.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\Autoruns.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\BleachBit.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\CCleaner.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\CPU-Z.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\CrystalDiskInfo (32bit).lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\CrystalDiskInfo (64bit).lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\Defraggler.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\Dism++.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\HWiNFO32.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\HWiNFO64.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\HWMonitor.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\O&O ShutUp10.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\powerMAX.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\Process Explorer.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\Process Monitor.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\RAMMap.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\Recuva.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\RW-Everything.lnk",
	"$destRoot\Programs\Utilidades de Mantenimiento\Ultimate Windows Tweaker.lnk",

	#Otros
	"$destRoot\Programs\LibreOffice 7.4\Kleopatra.lnk"
)

#Enlaces y carpetas a eliminar del menu de inicio
$removeFromStartMenu = @(
	"$destRoot\Programs\Enfocus Local License Manager 21.3.0 (64-bit).lnk",
	"$destRoot\Programs\Enfocus PitStop Workgroup Manager 22.lnk",
	"$destRoot\Programs\3Planesoft 3D Screensavers All in One",
	"$destRoot\Programs\3Planesoft\Screensaver Manager",
	"$destRoot\Programs\7-Zip",
	"$destRoot\Programs\AnyDesk",
	"$destRoot\Programs\AnyDesk.lnk", #Se vuelve a crear al final para ejecución como administrador
	"$destRoot\Programs\Advanced IP Scanner v2",
	"$destRoot\Programs\Auslogics",
	"$destRoot\Programs\BleachBit",
	"$destRoot\Programs\CCleaner",
	"$destRoot\Programs\CPUID",
	"$destRoot\Programs\CrystalDiskInfo",
	"$destRoot\Programs\Defraggler",
	"$destRoot\Programs\Dia",
	"$destRoot\Programs\Dism++",
	"$destRoot\Programs\Esko",
	#"$destRoot\Programs\Herramientas de Microsoft Office"
	"$destRoot\Programs\HWiNFO32",
	"$destRoot\Programs\HWiNFO64",
	"$destRoot\Programs\IHMC CmapTools",
	"$destRoot\Programs\Kodak",
	"$destRoot\Programs\PowerToys (Preview)",
	"$destRoot\Programs\qBittorrent",
	"$destRoot\Programs\Recuva",
	"$destRoot\Programs\RW-Everything",
	"$destRoot\Programs\Skype",
	"$destRoot\Programs\Sysinternals Suite",
	"$destRoot\Programs\UltraSearch",
	"$destRoot\Programs\Visual Studio Code",
	"$destRoot\Programs\Winamp",
	"$destRoot\Programs\WinRAR",

	#offce web (posiblemente existan)
	"$moveFrom\Excel.lnk",
	"$moveFrom\Outlook.lnk",
	"$moveFrom\PowerPoint.lnk",
	"$moveFrom\Word.lnk"

)
$renameLinksList = @(
	[pscustomobject]@{
		source  = "Open 3Planesoft Screensaver Manager.lnk"
		newName = "3Planesoft Screensaver Manager.lnk"
	},
	[pscustomobject]@{
		source  = "PowerToys (Preview).lnk"
		newName = "PowerToys.lnk"
	}

)

WTitulo('Organizando los accesos directos del menú inicio')

###############################################################
# Moving Links from $env:Appdata\Microsoft\Windows\Start Menu #
###############################################################

# Mover desde menú inicio de usuario (Administrador)
wInfo("Moviendo accesos desde carpeta de usuario a carpeta global...")

$removeFolderList = @()
Get-ChildItem -Path $moveFrom -Filter "*.lnk" -Recurse | ForEach-Object {
	$folder = $_.DirectoryName.trim()
	$link = $_.Name
	if ($omitSource -notlike "*${link}*") {
		$sourceLnk = ("$folder\$link")
		$SourceFolder = $sourceLnk.Replace($moveFrom, "")
		$destination = "$destRoot$SourceFolder"

		if (!(Test-Path -Path (Split-Path -Path $destination -Parent) -PathType Container)) {
			New-Item (Split-Path -Path $destination -Parent) -ItemType Directory | Out-Null
		}
		Move-Item -LiteralPath $sourceLnk -Destination $destination -Force
		if ($removeFolderList -notcontains $folder) {
			$removeFolderList += , $folder
		}
	}
}
$removeFolderList | ForEach-Object {
	if (!(Get-ChildItem -Path $_ -Filter "*.lnk" -Recurse)) {
		Remove-Item -Path $_ -Force -Recurse -Confirm:$False
	}

}

#Organizar enlaces en nuevas carpetas
wInfo("Organizando enlaces al arbol final...")

foreach ($lnk in $destOrder) {
	$path = Split-Path $lnk -Parent
	$file = Split-Path $lnk -Leaf
	$source = (Get-ChildItem -Path $destRoot -Filter "$File" -Recurse).FullName
	if ($source) {
		#verificacion del arbol necesario
		$tree = (($path.Replace("$destRoot\", ""))).Split("\")
		$newPathToVerif = $destRoot
		foreach ($dir in $tree) {
			$newPathToVerif = "$newPathToVerif\$dir"
			if (!(Test-Path -Path $newPathToVerif -PathType Container)) {
				New-Item -Path (Split-Path $newPathToVerif -Parent) -Name $dir -ItemType Directory | Out-Null
			}
		}
		if ($source -ne $lnk) {
			Move-Item -Path $source -Destination $lnk -Force
		}
	}
}

#############################
# Removing Folders and Link #
#############################
foreach ($el in $removeFromStartMenu) {
	Remove-Item -Path $el -Recurse -Force -ErrorAction SilentlyContinue
}


#Recreando el acceso directo de Anydesk
New-link -dest ("${env:ProgramData}\Microsoft\Windows\Start Menu\Programs") -name "AnyDesk" -source ("${env:ProgramFiles}\Anydesk\AnyDesk.exe") -Admin
New-link -dest ("${env:Public}\Desktop") -name "AnyDesk" -source ("${env:ProgramFiles}\Anydesk\AnyDesk.exe") -Admin

#renombrado enlaces
$renameLinksList | ForEach-Object {
	Get-ChildItem -Path $destRoot -Recurse | Where-Object -Property Name -Like $_.source | Rename-Item -NewName $_.newName
}

#Permisos en todos los enlaces para permitir ejecución de cualquier usuario

#Enlace de muestra para obtener el objeto
$NewAcl = Get-Acl -Path "${destRoot}\Programs\Immersive Control Panel.lnk"

# Propiedades de seguridad
$identity = "EveryOne"
$fileSystemRights = "FullControl"
$type = "Allow"

# Crear una nueva regla (objeto) de ACL
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
$NewAcl.SetAccessRule($fileSystemAccessRule)

#Colocando permisos a todos los enlaces en la $ruta
((Get-ChildItem -Path $destRoot -Filter "*.lnk" -Recurse).fullname) | ForEach-Object {
	Set-Acl -Path $_ -AclObject $NewAcl
}

wOK("Accesos directos del menú inicio arreglados")
