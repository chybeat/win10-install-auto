<# QbitTorrent
=================#>
$appData = get-dbAppData('cmaptools')
install-App($appData)

$name = $appData.name
$program = $env:ProgramFiles + "\ihmc cmaptools\jre\bin\javaw.exe"
$action = 'block'  #allow block NotConfigured
$desc = $action.substring(0, 1).toupper() + $action.substring(1).tolower() + $name
$protocol = 'any' #UDP TCP any
$direction = 'Inbound' #Inbound Outbound

New-NetFirewallRule -DisplayName $name -Name $name -Program $program -Description $desc -Profile any -Protocol $protocol -Action $action -Direction $direction | Out-Null
