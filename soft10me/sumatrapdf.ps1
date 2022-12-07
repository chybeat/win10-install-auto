<# SumatraPDF v3.2
=================#>
$app = get-dbAllData('Sumatra PDF')
installme($app)

exit

<#
$x64 = x64("Test")
$path = "D:\Programas\Utilidades\PDF"
$file_x64 = "SumatraPDF-3.2-64-install.exe"
$file_x86 = "SumatraPDF-3.2-install.exe"

if(!$x64){
    if(!$file_x86){
        wInfo("$path\$file_x64 No se puede instalar")
        Pause
        exit
    }
    $installer = $path + "\" +$file_x86
    $Program_Files = $env:ProgramFiles
}else{
    if(!$file_x64){
        $installer =$path + "\" +$file_x86
        $Program_Files = ${env:ProgramFiles(x86)}
    }else{
        $installer =$path + "\" +$file_x64
        $Program_Files = $env:ProgramFiles
    }
}

installme(@{
    installer   = $installer
    name        = 'SumatraPDF v3.2'
    params      = '-s -d "%ProgramFiles%\SumatraPDF" -with-filter -with-preview'
    dest        = "$Program_Files\SumatraPDF"
    exe         = 'SumatraPDF.exe'
})

$sumatra_setings_file_data = "# For documentation, see https://www.sumatrapdfreader.org/settings/settings3.2.html

MainWindowBackground = #80fff200
EscToExit = false
ReuseInstance = false
UseSysColors = false
RestoreSession = true
TabWidth = 300

FixedPageUI [
	TextColor = #000000
	BackgroundColor = #ffffff
	SelectionColor = #f5fc0c
	WindowMargin = 2 4 2 4
	PageSpacing = 4 4
]
EbookUI [
	FontName = Georgia
	FontSize = 12.5
	TextColor = #5f4b32
	BackgroundColor = #fbf0d9
	UseFixedPageUI = false
]
ComicBookUI [
	WindowMargin = 0 0 0 0
	PageSpacing = 4 4
	CbxMangaMode = false
]
ChmUI [
	UseFixedPageUI = false
]
ExternalViewers [
]
ShowMenubar = true
ReloadModifiedDocuments = true
FullPathInTitle = false
ZoomLevels = 8.33 12.5 18 25 33.33 50 66.67 75 100 125 150 200 300 400 600 800 1000 1200 1600 2000 2400 3200 4800 6400
ZoomIncrement = 0

PrinterDefaults [
	PrintScale = shrink
]
ForwardSearch [
	HighlightOffset = 0
	HighlightWidth = 15
	HighlightColor = #6581ff
	HighlightPermanent = false
]
CustomScreenDPI = 0

RememberStatePerDocument = true
UiLanguage = es
ShowToolbar = true
ShowFavorites = false
AssociateSilently = true
CheckForUpdates = false
RememberOpenedFiles = false
EnableTeXEnhancements = false
DefaultDisplayMode = automatic
DefaultZoom = fit width
WindowState = 1
WindowPos = 512 0 896 1160
ShowToc = false
SidebarDx = 0
TocDy = 0
ShowStartPage = true
UseTabs = true

FileStates [
]
SessionData [
]
TimeOfLastUpdateCheck = 0 0
OpenCountWeek = 500

# Settings after this line have not been recognized by the current version"

wInfo("Copiando archivo settings")

$sumatra_setings_file_path = $env:LOCALAPPDATA + "\SumatraPDF"

if(!(Test-path $sumatra_setings_file_path)){
    New-Item -Path $sumatra_setings_file_path -Force -ItemType "directory" | Out-Null
}

$sumatra_setings_file_path = $env:LOCALAPPDATA + "\SumatraPDF\SumatraPDF-settings.txt"
$sumatra_setings_file_data | Out-File -FilePath $sumatra_setings_file_path -Encoding utf8
#>