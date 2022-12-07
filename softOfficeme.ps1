<#========================================
= Instación de los programas Para Office =
=========================================#>

$scriptsFolder = $PSScriptRoot + "\softOfficeme"

$programs = @(
	"MSOffice.ps1"
)
foreach ($app in $programs) {
	$script = $scriptsFolder + "\" + $app
	. $script
}
