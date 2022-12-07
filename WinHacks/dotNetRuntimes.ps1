<######################
# .net FrameWork 3.5  #
######################>
WTitulo("Instalación de .Net Runtimes")
WRun("Instalando .Net Frameworks 3.5")
$app = Get-dbAppData(".Net FrameWorks 3.5")

if ($x86) {
	$file = $app.isoSrcPath.Trim('\') + "\" + $app.InstFile_x86.Trim('\')
} else {
	$file = $app.isoSrcPath.Trim('\') + "\" + $app.InstFile_x64.Trim('\')
}
$isopath = Get-Path $file -Limit 1 -full
wRun("Montando archivo ${file}")
$Drive = Mount-Iso($isoPath) #Montar la imagen de disco

#Obtener la arquitectura del sistema operativo
if ($x64) {
	[string]$fileArch = "amd64"
} else {
	[string]$fileArch = "x86"
}
#nombre general del archivo que contiene NetFX3
[string]$cabFile = $app.instInfFileData
[bool]$installed = $false
$cabFile = $cabFile + "*" + $fileArch + "??.cab"

wRun("Buscando posibles ubicaciones de ${cabFile}")
#Obtener posibles unidades donde pueda estar el archivo e instalar
foreach ($p in (Get-Path -Filename $cabFile -Drive $Drive -Force -full)) {
	if (!$installed) {
		$p = Split-Path -Path $p -Parent
		wRun("Intentando instalar desde $p...")
		#Enable-WindowsOptionalFeature -Online -FeatureName "NetFX3" | Out-Null
		Enable-WindowsOptionalFeature -Online -FeatureName "NetFX3" -All -Source "${p}" -LimitAccess | Out-Null
		$installed = $?
	}
}

#manejo de errores de instalación deNet FrameWorks 3.5
if (!$installed) {
	wError(".Net FrameWorks 3.5 NO se ha podido instalar")
	wInfo("Verifique que tiene los medios de instalación de Windows 10 en el equipo`n o que montó un archivo ISO de instalación de Windows 10")

} else {
	wOk(".Net FrameWorks 3.5 ha sido instalado!.")
}

Dismount-DiskImage -InformationAction:Ignore -ImagePath $isoPath | Out-Null

WRun("Instalando .Net FrameWorks 4.8")
$app = Get-dbAppData(".Net FrameWorks 4.8")
install-App($app)

WRun("Instalando .Net Desktop Runtimes 6.0")
$dotnetData = get-dbAppData(".NetRuntime")
install-App($dotnetData)

if ($x64) {
	$dotnetData.InstFile_x64 = $dotnetData.InstFile_x86
	install-App($dotnetData)
}
