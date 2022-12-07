<# WSUS Windows 10 Updater (Sep-12-2020)
===========#>

$logFile = "$env:Windir\wsusofflineupdate.log"

$updCommand = Search-Source("D:\Programas\Windows Update\cmd\DoUpdate.cmd")

wInfo("Ejecutando actualizacion Fase 1")
start-process -FilePath $updCommand -ArgumentList "/updatecpp /updatercerts /instdotnet4 /instwmf /showdismprogress /instmsi" -wait


RestartAndRun -RunAfterRestart "StarImageDone" -executeFile ($PSScriptRoot + "\-- iniciar.cmd")

wInfo("Ejecutando actualizacion Fase 2")
start-process -FilePath $updCommand -ArgumentList "/showdismprogress" -wait

wInfo("Ejecutando actualizacion Fase 3")
start-process -FilePath $updCommand -ArgumentList "/showdismprogress" -wait

if(Test-path $logFile -PathType Leaf ){
    remove-item $logFile
}


<#
/updatecpp
/instdotnet35
/updatercerts
/instdotnet4
/instwmf
/skipieinst
/skipdefs
/skipdynamic
/all
/excludestatics
/seconly
/verify
/autoreboot
/shutdown
/showlog
/showdismprogress
/monitoron
/instmsi
#>