if($x64){
    $app = "powertoys"
    $app = get-dbAppData($app)
    Install-App($app)
    wRun("Optimizando ${app.Name}")
    Start-Sleep -Seconds 3
    while (Get-Process | Where-Object -Property Name -iLike "powertoys") {
	    Get-Process | Where-Object -Property Name -iLike "powertoys" | Stop-Process
	    Start-Sleep -Seconds 1
    }

    Remove-Item -Path (Get-EnvPs($app.appPrefsFilePath)) -Recurse -Include *

    Expand-Archive -Path ($app.instSrcPath + "\PowerToysSetup-0.64.1-x64-settings.zip") -DestinationPath (get-EnvPs($app.appPrefsFilePath)) -Force

    Remove-Item -Path "$env:USERPROFILE\Documents\powertoys" -Recurse -Include * -Force
    wOk("Optimización terminada")
}