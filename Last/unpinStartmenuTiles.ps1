<#
Posiblemente sea mejor dejar los iconos de la barra de tareas en
${env:AppData}\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
#>


$xml_ini = '<LayoutModificationTemplate xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" Version="1"><LayoutOptions StartTileGroupCellWidth="8" /><DefaultLayoutOverride><StartLayoutCollection><defaultlayout:StartLayout GroupCellWidth="8">'

$xml_Start_TaskbarSeparator = '</defaultlayout:StartLayout></StartLayoutCollection></DefaultLayoutOverride><CustomTaskbarLayoutCollection PinListPlacement="Replace"><defaultlayout:TaskbarLayout><taskbar:TaskbarPinList>'

$xml_end = '<taskbar:DesktopApp DesktopApplicationLinkPath="#leaveempty"/></taskbar:TaskbarPinList></defaultlayout:TaskbarLayout></CustomTaskbarLayoutCollection></LayoutModificationTemplate>'
$global:appId = ""

$StartMenuGroups = @(
	@{
		name_group = "Internet"
		links      = (
			'TeamViewer|2',
			'AnyDesk|2',
			'Google|2',
			'Firefox|2'
		)
	}

	@{
		name_group = "Adobe Creative Suite"
		links      = @(
			#Adobe CC 64-Bit
			"Adobe Illustrator 2022|2",
			"Adobe Photoshop 2022|2",
			"Adobe InDesign 2022|2",
			"Adobe Lightroom Classic|2",

			"Adobe Premiere Pro 2022|2",
			"Adobe After Effects 2022|2",
			"Adobe Audition 2022|2",
			"Adobe Acrobat|2",

			"Adobe Bridge 2022|1",
			"Adobe Media Encoder 2022|1"
			"Adobe Dreamweaver 2021|1",

			#Adobe CC 32-Bit
			"Adobe Photoshop CC 2018 (32 Bit)|2",
			"Adobe Illustrator CC 2018 (32 Bit)|2",
			"Adobe InDesign CC 2018 (32-bit)|2",
			"Adobe Dreamweaver CC 2018|2",

			#enviados al final para una mejor organización
			"Adobe Acrobat Distiller|1",
			"Adobe Bridge CC 2018 (32 Bit)|1"
		)
	}
	@{
		name_group = "CorelDraw"
		links      = @(
			#Corel de 32 bit
			"CorelDRAW 2020|2",
			"Corel PHOTO-PAINT 2020|2"
			"Corel Font Manager 2020|2"

			#Corel de 64 bit
			"CorelDRAW|2"
			"Corel PHOTO-PAINT|2"
			"Corel Font Manager|2"
			"Corel CAPTURE|2"
		)
	}
	@{
		name_group = "Microsoft Office"
		links      = @(
			"Word|2",
			"Excel|2",
			"PowerPoint|2",
			"Publisher|2",
			"Visio|2",
			"Access|2",
			"Project|2"
		)
	}
)

wRun("Mejorando tu experiencia en el menú inicio...")

$xml_groups = ""
foreach ($group in $StartMenuGroups) {
	$name = $group.name_group
	$column = 0
	$row = 0
	$LinksGroup = ""
	$group.links | ForEach-Object {
		$Prog = $_.split("|")[0]
		$size = $_.split('|')[1]
		$app = Get-StartApps -Name "$Prog"
		$global:appId = $app.AppID
		#Arreglar u omitir duplicados
		if (($Prog -eq "Word") -and $app.GetType().Name -eq "Object[]") {
			$app | ForEach-Object {
				if ($_.name -eq "Word") {
					$global:appId = $_.AppID
				}
			}
		} elseif ($app.Name -eq "WordPad") {
			continue
		}
		if ($global:appId) {
			if ($global:appId.GetType().name -ne "string") {
				$global:appId = $app.AppID | Select-Object -First 1
			}
			$LinksGroup += "<start:DesktopApplicationTile Size=`"${size}x${size}`" Column=`"${column}`" Row=`"${row}`" DesktopApplicationID=`"${appId}`" />"
			$column = $column + $size
			if ($column -ge "7") {
				$column = 0
				$row = $row + $size
			}
		}
	}
	if ($LinksGroup -ne "") {
		$xml_groups += '<start:Group Name="' + $name + '">' + $LinksGroup + '</start:Group>'
	}
}

$taskbarIcons = @(
	"Google",
	"Explorador",
	"Word",
	"Excel",
	"Adobe Photoshop CC 2018 (32 Bit)",
	"Adobe Illustrator CC 2018 (32 Bit)",
	"Adobe Illustrator 2022",
	"Adobe Photoshop 2022",
	"CorelDRAW 2020",
	"CorelDRAW"
)

wRun("Mejorando tu barra de tareas...")
$xml_taskBar = ""
foreach ($icon in $taskbarIcons) {
	$app = Get-StartApps -Name "$icon"
	$global:appId = $app.AppID

	#Arreglar u omitir duplicados
	if (($icon -eq "Word") -and $app.GetType().Name -eq "Object[]") {
		$app | ForEach-Object {
			if ($_.name -eq "Word") {
				$global:appId = $_.AppID
			}
		}
	} elseif ($app.Name -eq "WordPad") {
		continue
	}
	if ($global:appid) {
		$xml_taskBar += "<taskbar:DesktopApp DesktopApplicationID=`"${appId}`" />"
	}

}

$layoutFile = "${env:windir}\StartMenuLayout.xml"

#Delete layout file if it already exists
If (Test-Path $layoutFile) {
	Remove-Item $layoutFile -Force
}

#Delete Previous Pinned Items
wRun("Eliminando los iconos anteriores. Espera...")
if (Get-Process -Name explorer -ErrorAction SilentlyContinue) {
	taskkill /im explorer.exe /F | Out-Null
}
Get-ChildItem -Path ("${env:AppData}\Microsoft\Internet Explorer\Quick Launch\") -Filter *.lnk | Remove-Item -Force
Get-ChildItem -Path ("${env:AppData}\Microsoft\Internet Explorer\Quick Launch\") -Filter *.ini | Remove-Item -Force
Get-ChildItem -Path ("${env:AppData}\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar") -Filter *.lnk | Remove-Item -Force
Get-ChildItem -Path ("${env:AppData}\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar") -Filter *.ini | Remove-Item -Force
Get-ChildItem -Path ("${env:SystemDrive}\Users\Default\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch") -Filter *.lnk | Remove-Item -Force

Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -Type Binary -Value ([byte[]](255))
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve" -ErrorAction SilentlyContinue

$key = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current"
$data = $key.Data[0..25] + ([byte[]](202, 50, 0, 226, 44, 1, 1, 0, 0))
Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $data
Stop-Process -Name "StartMenuExperienceHost" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "ShellExperienceHost" -Force -ErrorAction SilentlyContinue

Start-Sleep 2

wRun("Aplicando la configuración. Porfavor no realices ninguna acción hasta que termine!")

$xml_ini + $xml_groups + $xml_Start_TaskbarSeparator + $xml_taskBar + $xml_end | Out-File $layoutFile -Encoding ASCII
#$xml_ini + $xml_Start_TaskbarSeparator + $xml_end | Out-File $layoutFile -Encoding ASCII #Empty!

$regAliases = @("HKLM", "HKCU")

#Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
foreach ($regAlias in $regAliases) {
	$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
	$keyPath = $basePath + "\Explorer"
	IF (-not (Test-Path -Path $keyPath)) {
		New-Item -Path $basePath -Name "Explorer"
	}
	Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
	Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
}


#Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process


Start-Process explorer.exe
Start-Sleep -s 5
$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
Start-Sleep -s 5

#Enable the ability to pin items again by disabling "LockedStartLayout"
foreach ($regAlias in $regAliases) {
	$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
	$keyPath = $basePath + "\Explorer"
	Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
}

#Restart Explorer and delete the layout file
Start-Sleep -s 5

# Uncomment the next line to make clean start menu default for all new users
Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

$wshell = New-Object -ComObject wscript.shell
$wshell.SendKeys('^{ESCAPE}')
Start-Sleep -s 1
$wshell.SendKeys('{ESCAPE}')

wOk("El menú inicio y la barra de tareas ya estan configurados")
