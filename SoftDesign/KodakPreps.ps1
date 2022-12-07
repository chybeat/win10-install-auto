<# Kodak Preps v9.0.1.136
===========#>
$app = get-dbAppData("Kodak Preps")
install-app($app)

$zip = $app.instSrcPath + "\fix.zip"
$dest = $app.instDir
$excl = $app.instDir + "\FLCL.dll"

Add-MpPreference -ExclusionPath $excl

Expand-Archive -Path "$zip" -DestinationPath $dest -Force
