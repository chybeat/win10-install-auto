wrun("Seleccionar el programa con el cual abrir los siguientes tipos de archivo:")
$fileExt = @(
	#'7z',
	#'Mpg',
	#'RMVB',
	#'VOB',
	#'ani',
	#'avi',
	#'bmp',
	#'cur',
	#'gif',
	#'ico',
	#'ifo',
	#'iso',
	#'jpeg',
	#'jpg',
	#'m2v',
	#'mkv',
	#'mov',
	#'mp4',
	#'mpeg',
	#'ogg',
	#'png',
	#'rar',
	#'tga',
	#'tif',
	#'tiff',
	#'txt',
	#'wmv',
	#'zip',
	[PSCustomObject]@{
		extension = 'aac'
		program   = "Winamp"
	},
	[PSCustomObject]@{
		extension = 'flac'
		program   = "Winamp"
	},
	[PSCustomObject]@{
		extension = 'html'
		program   = "Google Chrome"
	},
	[PSCustomObject]@{
		extension = 'm3u'
		program   = "Winamp"
	},
	[PSCustomObject]@{
		extension = 'mp3'
		program   = "Winamp"
	},
	[PSCustomObject]@{
		extension = 'pdf'
		program   = "Sumatra PDF / Acrobat"
	},
	[PSCustomObject]@{
		extension = 'pls'
		program   = "Media Player Classic"
	},
	[PSCustomObject]@{
		extension = 'stml'
		program   = "FireFox"
	},
	[PSCustomObject]@{
		extension = 'svg'
		program   = "Google Chrome"
	},
	[PSCustomObject]@{
		extension = 'wav'
		program   = "Winamp"
	},
	[PSCustomObject]@{
		extension = 'webp'
		program   = "Google Chrome"
	},
	[PSCustomObject]@{
		extension = 'wma'
		program   = "Winamp"
	},
	[PSCustomObject]@{
		extension = 'xml'
		program   = "Firefox"
	}
)
$fileExt | Sort-Object -Property program | ForEach-Object {
	$text = $_.extension + " -> " + $_.program
	wInfo($text)
}
$fileNameCreteBaseText = "__test_file_pcb_temporal." #No olvidar el punto al final


$destFolder = "${env:PUBLIC}\desktop"
$fileExt | Sort-Object -Property program | ForEach-Object {
	$fileName = "zzzz_" + $_.extension + $fileNameCreteBaseText + $_.extension
	"test" | Out-File -Force -FilePath "${destFolder}\${fileName}" -Encoding utf8
	$o = New-Object -com Shell.Application
	$folder = $o.NameSpace($destFolder)
	$file = $folder.ParseName($fileName)
	# Folder:
	#$folder.Self.InvokeVerb("Properties")

	# File:
	$file.InvokeVerb("Properties")
	Start-Sleep -Milliseconds 200
}

#Verificar ubicacion de Winamp.exe
$winampPath = "winamp\winamp.exe"
$testWA = $False
if ($x64) {
	$winampPath = "${env:ProgramFiles(x86)}\$winampPath"
} else {
	$winampPath = "${env:ProgramFiles}\$winampPath"
}

if (-not (Test-Path -Path $winampPath -PathType Leaf)) {
	$testWA = (Get-ChildItem -Path "$env:SystemDrive\" -Filter "winamp.exe" -Recurse -ErrorAction SilentlyContinue).FullName
	if (!$testWA) {
		$WinampPath = $False
	}
}

if ($WinampPath) {
	wInfo("Se colocó la ubicación $WinampPath en el portapapeles")
	Set-Clipboard -Value $WinampPath
	$WinampPath
}
for ($i = 0; $i -lt ($fileExt.Length * 3); $i++) {
	Start-Sleep -Milliseconds 100
}
Pause

$fileExt | ForEach-Object {
	$fileName = $destFolder + "\zzzz_" + $_.extension + $fileNameCreteBaseText + $_.extension
	$fileExist = Test-Path $fileName
	while ($fileExist) {
		Remove-Item -Path $fileName -Force -ErrorAction SilentlyContinue
		$fileExist = Test-Path $fileName
		Start-Sleep -Milliseconds 100
	}
}
