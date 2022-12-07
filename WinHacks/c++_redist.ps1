<################################
# C++ Redistributable Packages  #
#################################
Es posible que exita un cmd o un listado de archivos. Colocar la ruta en ($path)

#>

wTitulo("Instalación de Visual C++ Redistributable Packages")

$versions = @('2005', '2008', '2010', '2012', '2013', '2022')

$versions | ForEach-Object {
	$query = get-dbAppData("cpp $_")
	wRun("Visual C++ Redistributable $_")

	$filePath = Get-Path -filename ($query.InstSrcPath.trim("\") + "\" + $query.instFile_x86) -Full
	wInfo("Instalando arquitectura de 32-bit...")

	Start-Process -FilePath $filePath -ArgumentList $query.InstArgs -Wait
	if ($x64) {
		$filePath = Get-Path -filename ($query.InstSrcPath.trim("\") + "\" + $query.instFile_x64) -full
		wInfo("Instalando arquitectura de 64-bit...")
		Start-Process -FilePath $filePath -ArgumentList $query.InstArgs -Wait
	}
}

wOk("Terminada la instalación de C++ Redistributable Packages")
