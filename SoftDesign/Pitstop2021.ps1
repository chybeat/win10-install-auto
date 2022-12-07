<#Enfocus PitStop Pro 21 Build 1248659
==========================#>
$app = get-dbAppData('Enfocus Pitstop Pro')
install-app($app)

wRun("Iniciando limpieza de Pitstop")


Stop-Service -Force 'Enfocus Subscription Service' -ErrorAction SilentlyContinue
while ((Get-Service -Name 'Enfocus Subscription Service' -ErrorAction SilentlyContinue).Status -eq "Running") {
	Start-Sleep -s 1
}

set-Reg('
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Enfocus Subscription Notifier"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run]
"Enfocus Subscription Notifier"=-

-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Enfocus Subscription Service]
')
<#CRKSrc
======#>

if (!$x86 -and !$_.instFile_x64) {
	if ($app.runFileAppPath) {
		$app.runFileAppPath = get-EnvPS(($app.runFileAppPath.ToLower()).Replace("%programfiles%", "%ProgramFiles(x86)%").Replace("%commonprogramfiles%", "%CommonProgramFiles(x86)%"))
	}
} else {
	$app.runFileAppPath = get-EnvPS($app.runFileAppPath)
}
if ($x64) {
	$app.instDir = get-EnvPS(($app.instDir.ToLower()).Replace("%programfiles%", "%ProgramFiles(x86)%"))
}

$destCrk = $app.instDir

$file = $app.instSrcPath.Trim('\') + "\fix.zip"
if (!(Test-Path -Path $file -type Leaf ) ) {
	$srcPath = (Split-Path (Split-Path $file -Parent) -NoQualifier).Trim("\")
	$fileName = (Split-Path $file -Leaf).trim("\")
	$path = getPath -Filename $fileName -Drive $drive -path $srcPath
	$file = $path + "\" + $fileName
}

@(
	"${env:ProgramFiles}\Adobe\Acrobat DC\Acrobat\plug_ins\Enfocus"
	"${env:ProgramFiles}\enfocus"
) | ForEach-Object {
	Block-InFirewall -Path $_ -Extension "exe"
}

Expand-Archive -Path $file -DestinationPath $destCrk -Force
