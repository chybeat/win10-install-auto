#Disables Windows Feedback Experience
wInfo("Deshabilitando el programa de experiencia de usuario de Windows...")
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo]
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo]
"Enabled"=dword:00000000
')

#Stops Cortana from being used as part of your Windows Search Function
wInfo("Impidiendo que cortana sea parte de la busqueda de Windows...")
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search]
"AllowCortana"=dword:00000000')

#Disables Web Search in Start Menu
wInfo("Deshabilitando la busqueda de Bing en el menú inicio...")
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search]
"DisableWebSearch"=dword:00000000
"BingSearchEnabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search]
"BingSearchEnabled"=dword:00000000
"CortanaConsent"=dword:00000000
')

#Stops the Windows Feedback Experience from sending anonymous data
wInfo("Deteniendo el programa de experiencia de usuario...")
Set-Reg('[HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules]
"PeriodInNanoSeconds"=dword:00000000
"NumberOfSIUFInPeriod"=dword:00000000
')

###- Disable Clipboard history
wInfo("Deshabilitando la sincronización de los datos del portapapeles...")
Set-Reg('[HKEY_CURRENT_USER\Software\Microsoft\Clipboard]
"EnableClipboardHistory"=dword:00000000')

#Prevents bloatware applications from returning and removes Start Menu suggestions
wInfo("Previniendo la reinstalación de aplicaciones inecesarias...")
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent]
"DisableWindowsConsumerFeatures"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"ContentDeliveryAllowed"=dword:00000000
"OemPreInstalledAppsEnabled"=dword:00000000
"PreInstalledAppsEnabled"=dword:00000000
"PreInstalledAppsEverEnabled"=dword:00000000
"SilentInstalledAppsEnabled"=dword:00000000
"SystemPaneSuggestionsEnabled"=dword:00000000
"SubscribedContent-338389Enabled"=dword:00000000
"SubscribedContent-338388Enabled"=dword:00000000
"SubscribedContent-353698Enabled"=dword:00000000
"SubscribedContent-310093Enabled"=dword:00000000
"SubscribedContent-338393Enabled"=dword:00000000
"SubscribedContent-353694Enabled"=dword:00000000
"SubscribedContent-353696Enabled"=dword:00000000
"SubscribedContent-338387Enabled"=dword:00000000
')

#Disables Wi-fi Sense
wInfo("Deshabilitando Wi-Fi Sense")
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting]
"value"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots]
"value"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config]
"AutoConnectAllowedOEM"=dword:00000000')

###- Disable Timeline history
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System]
"EnableActivityFeed"=dword:00000000
')

#Disables live tiles
wInfo("Deshabilitando las cuadriculas interactivas.....")
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications]
"NoTileApplicationNotification"=dword:00000001')

#Turns off Data Collection via the AllowTelemtry key by changing it to 0
wInfo("Deshabilitando la recolección de datos...")
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection]
"AllowTelemetry"=dword:00000000
"MaxTelemetryAllowed"=dword:00000001
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection]
"AllowTelemetry"=dword:00000000
')
if ($x64) {
	Set-Reg('
    [HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection]
    "AllowTelemetry"=dword:00000000')
}

#Turn off help Microsoft improve typing and writing
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\InputPersonalization]
"AllowInputPersonalization"=dword:00000000
"RestrictImplicitInkCollection"=dword:00000001
"RestrictImplicitTextCollection"=dword:00000001
"PreventHandwritingErrorReports"=dword:00000001
"PreventHandwritingDataSharing"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports]
"PreventHandwritingErrorReports"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\TabletPC]
"PreventHandwritingDataSharing"=dword:00000001
')

#Prevent using diagnostic data ###
wInfo("Previniendo el uso de datos de diagnostico...")
Set-Reg('[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Privacy]
"TailoredExperiencesWithDiagnosticDataEnabled"=dword:00000000

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy]
"TailoredExperiencesWithDiagnosticDataEnabled"=dword:00000000
')

#Disable Location tracking
wInfo("Desactivando Ubicación...")
Set-Reg('
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location]
"Value"="Deny"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}]
"SensorPermissionState"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration]
"Status"=dword:00000000')


#Removing CloudStore from registry if it exists
wInfo("Eliminando 'Cloudstore'...")
Set-Reg('-[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore]')
Start-Sleep -s 2

#Disable Media Player telemetry
wInfo("Deshabilitando la telemetria de Windows Media Player")
Set-Reg('[HKEY_CURRENT_USER\SOFTWARE\Microsoft\MediaPlayer\Preferences]
"UsageTracking"=dword:00000000

[HKEY_CURRENT_USER\Software\Policies\Microsoft\WindowsMediaPlayer]
"PreventCDDVDMetadataRetrieval"=dword:00000001

[HKEY_CURRENT_USER\Software\Policies\Microsoft\WindowsMediaPlayer]
"PreventMusicFileMetadataRetrieval"=dword:00000001

[HKEY_CURRENT_USER\Software\Policies\Microsoft\WindowsMediaPlayer]
"PreventRadioPresetsRetrieval"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WMDRM]
"DisableOnline"=dword:00000001
')

#Disable Customer Experience Improvement Program
wInfo("Deshabilitado la tarea de mejora de experiencia de usuario...")
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" | Disable-ScheduledTask | Out-Null

###- Disable Windows Error Reporting
# The error reporting feature in Windows is what produces those alerts after certain program or operating system errors, prompting you to send the information about the problem to Microsoft.
wInfo("Deshabilitado la tarea de mejora de experiencia de usuario...")
Set-Reg('[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting]
"Disabled"=dword:00000001')

if (Get-ScheduledTask -TaskName "QueueReporting" -ErrorAction SilentlyContinue) {
	Get-ScheduledTask -TaskName "QueueReporting" | Disable-ScheduledTask | Out-Null
}

##################################
# Bloqueando conexion a dominios #
##################################
wRun( "Bloquenado dominios de telemetria")

# Entries related to Akamai have been reported to cause issues with Widevine
# DRM.
$domains = @(
	"184-86-53-99.deploy.static.akamaitechnologies.com"
	"a-0001.a-msedge.net"
	"a-0002.a-msedge.net"
	"a-0003.a-msedge.net"
	"a-0004.a-msedge.net"
	"a-0005.a-msedge.net"
	"a-0006.a-msedge.net"
	"a-0007.a-msedge.net"
	"a-0008.a-msedge.net"
	"a-0009.a-msedge.net"
	"a1621.g.akamai.net"
	"a1856.g2.akamai.net"
	"a1961.g.akamai.net"
	#"a248.e.akamai.net"            # makes iTunes download button disappear (#43)
	"a978.i6g1.akamai.net"
	"a.ads1.msn.com"
	"a.ads2.msads.net"
	"a.ads2.msn.com"
	"ac3.msn.com"
	"ad.doubleclick.net"
	"adnexus.net"
	"adnxs.com"
	"ads1.msads.net"
	"ads1.msn.com"
	"ads.msn.com"
	"aidps.atdmt.com"
	"aka-cdn-ns.adtech.de"
	"a-msedge.net"
	"any.edge.bing.com"
	"a.rad.msn.com"
	"az361816.vo.msecnd.net"
	"az512334.vo.msecnd.net"
	"b.ads1.msn.com"
	"b.ads2.msads.net"
	"bingads.microsoft.com"
	"b.rad.msn.com"
	"bs.serving-sys.com"
	"c.atdmt.com"
	"cdn.atdmt.com"
	"cds26.ams9.msecn.net"
	"choice.microsoft.com"
	"choice.microsoft.com.nsatc.net"
	"compatexchange.cloudapp.net"
	"corpext.msitadfs.glbdns2.microsoft.com"
	"corp.sts.microsoft.com"
	"cs1.wpc.v0cdn.net"
	"db3aqu.atdmt.com"
	"df.telemetry.microsoft.com"
	"diagnostics.support.microsoft.com"
	"e2835.dspb.akamaiedge.net"
	"e7341.g.akamaiedge.net"
	"e7502.ce.akamaiedge.net"
	"e8218.ce.akamaiedge.net"
	"ec.atdmt.com"
	"fe2.update.microsoft.com.akadns.net"
	"feedback.microsoft-hohm.com"
	"feedback.search.microsoft.com"
	"feedback.windows.com"
	"flex.msn.com"
	"g.msn.com"
	"h1.msn.com"
	"h2.msn.com"
	"hostedocsp.globalsign.com"
	"i1.services.social.microsoft.com"
	"i1.services.social.microsoft.com.nsatc.net"
	"ipv6.msftncsi.com"
	"ipv6.msftncsi.com.edgesuite.net"
	"lb1.www.ms.akadns.net"
	"live.rads.msn.com"
	"m.adnxs.com"
	"msedge.net"
	"msftncsi.com"
	"msnbot-65-55-108-23.search.msn.com"
	"msntest.serving-sys.com"
	"oca.telemetry.microsoft.com"
	"oca.telemetry.microsoft.com.nsatc.net"
	"onesettings-db5.metron.live.nsatc.net"
	"pre.footprintpredict.com"
	"preview.msn.com"
	"rad.live.com"
	"rad.msn.com"
	"redir.metaservices.microsoft.com"
	"reports.wes.df.telemetry.microsoft.com"
	"schemas.microsoft.akadns.net"
	"secure.adnxs.com"
	"secure.flashtalking.com"
	"services.wes.df.telemetry.microsoft.com"
	"settings-sandbox.data.microsoft.com"
	#"settings-win.data.microsoft.com"       # may cause issues with Windows Updates
	"sls.update.microsoft.com.akadns.net"
	#"sls.update.microsoft.com.nsatc.net"    # may cause issues with Windows Updates
	"sqm.df.telemetry.microsoft.com"
	"sqm.telemetry.microsoft.com"
	"sqm.telemetry.microsoft.com.nsatc.net"
	"ssw.live.com"
	"static.2mdn.net"
	"statsfe1.ws.microsoft.com"
	"statsfe2.update.microsoft.com.akadns.net"
	"statsfe2.ws.microsoft.com"
	"survey.watson.microsoft.com"
	"telecommand.telemetry.microsoft.com"
	"telecommand.telemetry.microsoft.com.nsatc.net"
	"telemetry.appex.bing.net"
	"telemetry.microsoft.com"
	"telemetry.urs.microsoft.com"
	"vortex-bn2.metron.live.com.nsatc.net"
	"vortex-cy2.metron.live.com.nsatc.net"
	"vortex.data.microsoft.com"
	"vortex-sandbox.data.microsoft.com"
	"vortex-win.data.microsoft.com"
	"cy2.vortex.data.microsoft.com.akadns.net"
	"watson.live.com"
	"watson.microsoft.com"
	"watson.ppe.telemetry.microsoft.com"
	"watson.telemetry.microsoft.com"
	"watson.telemetry.microsoft.com.nsatc.net"
	"wes.df.telemetry.microsoft.com"
	"win10.ipv6.microsoft.com"
	"www.bingads.microsoft.com"
	"www.go.microsoft.akadns.net"
	"www.msftncsi.com"
	"client.wns.windows.com"
	#"wdcp.microsoft.com"                       # may cause issues with Windows Defender Cloud-based protection
	#"dns.msftncsi.com"                         # This causes Windows to think it doesn't have internet
	#"storeedgefd.dsx.mp.microsoft.com"         # breaks Windows Store
	"wdcpalt.microsoft.com"
	"settings-ssl.xboxlive.com"
	"settings-ssl.xboxlive.com-c.edgekey.net"
	"settings-ssl.xboxlive.com-c.edgekey.net.globalredir.akadns.net"
	"e87.dspb.akamaidege.net"
	"insiderservice.microsoft.com"
	"insiderservice.trafficmanager.net"
	"e3843.g.akamaiedge.net"
	"flightingserviceweurope.cloudapp.net"
	#"sls.update.microsoft.com"                 # may cause issues with Windows Updates
	#"static.ads-twitter.com"                    # may cause issues with Twitter login
	"www-google-analytics.l.google.com"
	#"p.static.ads-twitter.com"                  # may cause issues with Twitter login
	"hubspot.net.edge.net"
	"e9483.a.akamaiedge.net"

	#"www.google-analytics.com"
	#"padgead2.googlesyndication.com"
	#"mirror1.malwaredomains.com"
	#"mirror.cedia.org.ec"
	"stats.g.doubleclick.net"
	"stats.l.doubleclick.net"
	"adservice.google.de"
	"adservice.google.com"
	"googleads.g.doubleclick.net"
	"pagead46.l.doubleclick.net"
	"hubspot.net.edgekey.net"
	#"insiderppe.cloudapp.net"                   # Feedback-Hub
	"livetileedge.dsx.mp.microsoft.com"

	# extra
	"fe2.update.microsoft.com.akadns.net"
	"s0.2mdn.net"
	"statsfe2.update.microsoft.com.akadns.net"
	"survey.watson.microsoft.com"
	"view.atdmt.com"
	"watson.microsoft.com"
	"watson.ppe.telemetry.microsoft.com"
	"watson.telemetry.microsoft.com"
	"watson.telemetry.microsoft.com.nsatc.net"
	"wes.df.telemetry.microsoft.com"
	"m.hotmail.com"

	# can cause issues with Skype (#79) or other services (#171)
	#"apps.skype.com"
	#"c.msn.com"
	# "login.live.com"                  # prevents login to outlook and other live apps
	#"pricelist.skype.com"
	#"s.gateway.messenger.live.com"
	#"ui.skype.com"
)

Add-ToHostsFile -ips $domains -comment "Disabling Windows Telemetry"

wRun("Agregando ips de telemetria al firewall")
$ips = @(
	"134.170.30.202"
	"137.116.81.24"
	"157.56.106.189"
	"184.86.53.99"
	"2.22.61.43"
	"2.22.61.66"
	"204.79.197.200"
	"23.218.212.69"
	"65.39.117.230"
	#"65.52.108.33"   # Causes problems with Microsoft Store
	"65.55.108.23"
	"64.4.54.254"
)
Remove-NetFirewallRule -DisplayName "_Block Windows Telemetry IPs" -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "_Block Windows Telemetry IPs" -Direction Outbound -Action Block -RemoteAddress ([string[]]$ips) | Out-Null
