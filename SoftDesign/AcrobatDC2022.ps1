<# Acrobat DC
===========#>
$app = get-dbAppData('Acrobat DC')

if ($x86) {
	$app.isoFile = $app.instfile_x86

} else {
	$app.isoFile = $app.instfile_x64
}

$app.instfile_x86 = "setup.exe"
$app.instfile_x64 = "setup.exe"

install-app($app)

<#crkArea
=======#>

$isofile = $app.isoSrcPath + "\" + $app.isoFile
$app.appCrkSrc = (Mount-Iso -IsoPath $isofile)
wInfo("Bloqueando conexión a internet")

@(
	"Acrobat.dll",
	"acrodistdll.dll",
	"acrotray.exe"
) | ForEach-Object {
	$destfile = (get-EnvPs($app.runFileAppPath)) + "\" + $_
	$originFile = $app.appCrkSrc.trim("\") + "\crack\" + $_
	if (Test-Path -Path ($destFile) -PathType Leaf) {
		Rename-Item ($destFile) -NewName ($_ + ".bak") -Force
	}
	Copy-Item -Path $originFile -Destination $destfile -Force
}

$ips = @(
	"192.150.14.69",
	"192.150.18.101",
	"192.150.18.108",
	"192.150.22.40",
	"192.150.8.100",
	"192.150.8.118",
	"199.7.52.190",
	"199.7.52.190:80",
	"199.7.54.72",
	"199.7.54.72:80",
	"209-34-83-73.ood.opsource.net",
	"209.34.83.67",
	"209.34.83.67:43",
	"209.34.83.67:443",
	"209.34.83.73",
	"209.34.83.73:43",
	"209.34.83.73:443",
	"23.9.57.92",
	"3dns-1.adobe.com",
	"3dns-2.adobe.com",
	"3dns-3.adobe.com",
	"3dns-4.adobe.com",
	"3dns-5.adobe.com",
	"3dns.adobe.com",
	"54.86.200.32",
	"54.86.87.194",
	"57.87.40.9",
	"CRL.VERISIGN.NET.*",
	"OCSP.SPO1.VERISIGN.COM",
	"activate-sea.adobe.com",
	"activate-sjc0.adobe.com",
	"activate.adobe.com",
	"activate.wip.adobe.com",
	"activate.wip1.adobe.com",
	"activate.wip2.adobe.com",
	"activate.wip3.adobe.com",
	"activate.wip4.adobe.com",
	"adobe-dns-1.adobe.com",
	"adobe-dns-2.adobe.com",
	"adobe-dns-3.adobe.com",
	"adobe-dns-4.adobe.com",
	"adobe-dns.adobe.com",
	"adobe.activate.com",
	"adobeereg.com",
	"adobeid-na1.services.adobe.com",
	"crl.verisign.net",
	"ereg.adobe.com",
	"ereg.wip.adobe.com",
	"ereg.wip1.adobe.com",
	"ereg.wip2.adobe.com",
	"ereg.wip3.adobe.com",
	"ereg.wip4.adobe.com",
	"genuine.adobe.com",
	"hl2rcv.adobe.com",
	"hlrcv.stage.adobe.com",
	"ims-prod06.adobelogin.com",
	"labsdownload.adobe.com",
	"lm.licenses.adobe.com",
	"lmlicenses.wip4.adobe.com",
	"na1e-acc.services.adobe.com",
	"na1r.services.adobe.com",
	"oobe.adobe.com",
	"ood.opsource.net",
	"practivate.adobe.*",
	"practivate.adobe.com",
	"practivate.adobe.ipp",
	"practivate.adobe.newoa",
	"practivate.adobe.ntp",
	"prod.adobegenuine.com",
	"secure.tune-up.com",
	"server-52-85-142-80.iad12.r.cloudfront.ney",
	"swupmf.adobe.com",
	"tss-geotrust-crl.thawte.com",
	"wip.adobe.com",
	"wip1.adobe.com",
	"wip2.adobe.com",
	"wip3.adobe.com",
	"wip4.adobe.com",
	"wwis-dubc1-vip100.adobe.com",
	"wwis-dubc1-vip101.adobe.com",
	"wwis-dubc1-vip102.adobe.com",
	"wwis-dubc1-vip103.adobe.com",
	"wwis-dubc1-vip104.adobe.com",
	"wwis-dubc1-vip105.adobe.com",
	"wwis-dubc1-vip106.adobe.com",
	"wwis-dubc1-vip107.adobe.com",
	"wwis-dubc1-vip108.adobe.com",
	"wwis-dubc1-vip109.adobe.com",
	"wwis-dubc1-vip110.adobe.com",
	"wwis-dubc1-vip111.adobe.com",
	"wwis-dubc1-vip112.adobe.com",
	"wwis-dubc1-vip113.adobe.com",
	"wwis-dubc1-vip114.adobe.com",
	"wwis-dubc1-vip115.adobe.com",
	"wwis-dubc1-vip116.adobe.com",
	"wwis-dubc1-vip117.adobe.com",
	"wwis-dubc1-vip118.adobe.com",
	"wwis-dubc1-vip119.adobe.com",
	"wwis-dubc1-vip120.adobe.com",
	"wwis-dubc1-vip121.adobe.com",
	"wwis-dubc1-vip122.adobe.com",
	"wwis-dubc1-vip123.adobe.com",
	"wwis-dubc1-vip124.adobe.com",
	"wwis-dubc1-vip125.adobe.com",
	"wwis-dubc1-vip30.adobe.com",
	"wwis-dubc1-vip31.adobe.com",
	"wwis-dubc1-vip32.adobe.com",
	"wwis-dubc1-vip33.adobe.com",
	"wwis-dubc1-vip34.adobe.com",
	"wwis-dubc1-vip35.adobe.com",
	"wwis-dubc1-vip36.adobe.com",
	"wwis-dubc1-vip37.adobe.com",
	"wwis-dubc1-vip38.adobe.com",
	"wwis-dubc1-vip39.adobe.com",
	"wwis-dubc1-vip40.adobe.com",
	"wwis-dubc1-vip41.adobe.com",
	"wwis-dubc1-vip42.adobe.com",
	"wwis-dubc1-vip43.adobe.com",
	"wwis-dubc1-vip44.adobe.com",
	"wwis-dubc1-vip45.adobe.com",
	"wwis-dubc1-vip46.adobe.com",
	"wwis-dubc1-vip47.adobe.com",
	"wwis-dubc1-vip48.adobe.com",
	"wwis-dubc1-vip49.adobe.com",
	"wwis-dubc1-vip50.adobe.com",
	"wwis-dubc1-vip51.adobe.com",
	"wwis-dubc1-vip52.adobe.com",
	"wwis-dubc1-vip53.adobe.com",
	"wwis-dubc1-vip54.adobe.com",
	"wwis-dubc1-vip55.adobe.com",
	"wwis-dubc1-vip56.adobe.com",
	"wwis-dubc1-vip57.adobe.com",
	"wwis-dubc1-vip58.adobe.com",
	"wwis-dubc1-vip59.adobe.com",
	"wwis-dubc1-vip60.adobe.com",
	"wwis-dubc1-vip61.adobe.com",
	"wwis-dubc1-vip62.adobe.com",
	"wwis-dubc1-vip63.adobe.com",
	"wwis-dubc1-vip64.adobe.com",
	"wwis-dubc1-vip65.adobe.com",
	"wwis-dubc1-vip66.adobe.com",
	"wwis-dubc1-vip67.adobe.com",
	"wwis-dubc1-vip68.adobe.com",
	"wwis-dubc1-vip69.adobe.com",
	"wwis-dubc1-vip70.adobe.com",
	"wwis-dubc1-vip71.adobe.com",
	"wwis-dubc1-vip72.adobe.com",
	"wwis-dubc1-vip73.adobe.com",
	"wwis-dubc1-vip74.adobe.com",
	"wwis-dubc1-vip75.adobe.com",
	"wwis-dubc1-vip76.adobe.com",
	"wwis-dubc1-vip77.adobe.com",
	"wwis-dubc1-vip78.adobe.com",
	"wwis-dubc1-vip79.adobe.com",
	"wwis-dubc1-vip80.adobe.com",
	"wwis-dubc1-vip81.adobe.com",
	"wwis-dubc1-vip82.adobe.com",
	"wwis-dubc1-vip83.adobe.com",
	"wwis-dubc1-vip84.adobe.com",
	"wwis-dubc1-vip85.adobe.com",
	"wwis-dubc1-vip86.adobe.com",
	"wwis-dubc1-vip87.adobe.com",
	"wwis-dubc1-vip88.adobe.com",
	"wwis-dubc1-vip89.adobe.com",
	"wwis-dubc1-vip90.adobe.com",
	"wwis-dubc1-vip91.adobe.com",
	"wwis-dubc1-vip92.adobe.com",
	"wwis-dubc1-vip93.adobe.com",
	"wwis-dubc1-vip94.adobe.com",
	"wwis-dubc1-vip95.adobe.com",
	"wwis-dubc1-vip96.adobe.com",
	"wwis-dubc1-vip97.adobe.com",
	"wwis-dubc1-vip98.adobe.com",
	"wwis-dubc1-vip99.adobe.com",
	"www.adobeereg.com",
	"www.wip.adobe.com",
	"www.wip1.adobe.com",
	"www.wip2.adobe.com",
	"www.wip3.adobe.com"
)

Add-ToHostsFile -ips $ips -comment "Adobe CC"

#blocking exe files in firewall (esto se realiza al instalar adobe CC)
@(
	"${env:ProgramFiles}\Adobe\Acrobat DC"
	"${env:CommonProgramFiles}\Adobe\"
	"${env:CommonProgramFiles(x86)}\Adobe\Acrobat DC"
	"${env:CommonProgramFiles(x86)}\Adobe\"
	"${env:AppData}\Adobe"
	"${env:LOCALAPPDATA}\Adobe"
	"${env:USERPROFILE}\AppData\LocalLow"

) | ForEach-Object {
	Block-InFirewall -Path $_ -Extension "exe"
}
$instOpen = '"' + (get-EnvPS($app.RunFileAppPath)) + '\' + $app.RunFileApp + '"'
wInfo("Abriendo y cerrando " + $app.name + " para continuar. Espera... ")
Invoke-Expression "start $instOpen"
Start-Sleep -s 7
if (Get-Process -Name Acrobat -ErrorAction SilentlyContinue) {
	taskkill /IM "Acrobat.exe" /F | Out-Null
}

wRun("Ejecutando limpieza del sistema para Acrobat DC")

if (Get-Process -Name acrotray -ErrorAction SilentlyContinue) {
	taskkill /IM "acrotray.exe" /F | Out-Null
}

if (Get-Process -Name armsvc -ErrorAction SilentlyContinue) {
	taskkill /IM "armsvc.exe" /F | Out-Null
}

if (Get-Process -Name AdobeIPCBroker -ErrorAction SilentlyContinue) {
	taskkill /IM "AdobeIPCBroker.exe" /F | Out-Null
}

Stop-Service -Force AGMService -ErrorAction SilentlyContinue
while ((Get-Service -Name AGMService -ErrorAction SilentlyContinue).Status -eq "Running") {
	Start-Sleep -s 1
}

Stop-Service -Force AGSService -ErrorAction SilentlyContinue
while ((Get-Service -Name AGMService -ErrorAction SilentlyContinue).Status -eq "Running") {
	Start-Sleep -s 1
}

Set-Reg('
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run]
"Acrobat Assistant 8.0"=-
"AdobeAAMUpdater-1.0"=-
"AdobeGCInvoker-1.0"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run]
"Acrobat Assistant 8.0"=-

-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{AE7CD045-E861-484f-8273-0445EE161910}]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{F4971EE7-DAA0-4053-9964-665D8EE6A077}]

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Toolbar]
"{47833539-D0C5-4125-9FA8-0819E2EAAC93}"=-

-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AGMService]
-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AGSService]
-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AdobeARMservice]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\Adobe.Acrobat.ContextMenu]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\Outlook\Addins\AdobeAcroOutlook.SendAsLink]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\Outlook\Addins\PDFMOutlook.PDFMOutlook]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\Excel\Addins\PDFMaker.OfficeAddin]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\PowerPoint\Addins\PDFMaker.OfficeAddin]
-[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\Word\Addins\PDFMaker.OfficeAddin]
-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Office\Outlook\Addins\AdobeAcroOutlook.SendAsLink]
-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Office\Outlook\Addins\PDFMOutlook.PDFMOutlook]
-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Office\Excel\Addins\PDFMaker.OfficeAddin]
-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Office\PowerPoint\Addins\PDFMaker.OfficeAddin]
-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Office\Word\Addins\PDFMaker.OfficeAddin]
-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{AE7CD045-E861-484f-8273-0445EE161910}]
-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{F4971EE7-DAA0-4053-9964-665D8EE6A077}]
-[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Monitors\Adobe PDF Port Monitor]
-[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Active Setup\Installed Components\{AC76BA86-0000-0000-7760-7E8A45000000}]
')

#{A6595CD1-BF77-430A-A452-18696685F7C7}
#
#

#Task to delete
@(
	"Adobe Acrobat Update Task"
) | ForEach-Object {
	Remove-SchdTask -task $_
}

wRun("Limpieza terminada")
