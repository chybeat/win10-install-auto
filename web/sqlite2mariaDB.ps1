# RUN THIS FROM test.ps1
# RUN THIS FROM test.ps1
# RUN THIS FROM test.ps1
# RUN THIS FROM test.ps1
# RUN THIS FROM test.ps1

function Get-DBProgramData($programName) {
	$query = ("SELECT * FROM Programas WHERE Programas.name = '" + $programName + "'")
	return Get-DbQuery -query $query

}

function Get-ParsedMariaDBData {
	param(
		[Parameter(Mandatory)]
		[object]
		$programData
	)process {
		$values = "("
		$id = $programData.id
		$keyList = "("
		foreach ($key in $programData.PSObject.Properties.name) {
			$key = $Key.substring(0, 1).toLower() + $Key.substring(1)
			$KeyList += '`' + $key + '`,'
			if ($null -eq $programData.$key) {
				$values += "'" + "NULL_PCB" + "',"
			} else {
				if ($programData.$key -eq $True) {
					$values += "'" + 1 + "',"
				} elseif ($programData.$key -eq $False) {
					$values += "'" + 0 + "',"
				} else {
					$val = $programData.$key
					$val = [regex]::replace($val, "\\", "\\")
					$val = [regex]::replace($val, "'", "\'")
					$val = [regex]::replace($val, "`"", "\`"")
					$values += "'" + $val + "',"
				}

			}
		}

		$keyList = ($keyList.trim(",")) + ")"
		$values = ($values.trim(",")) + ")"
		$SQL = 'DELETE FROM `program` WHERE `id`=' + $id + "; " + "`n"
		$SQL += 'INSERT INTO `program` ' + $keyList + " VALUES " + $values + ";`n "
		return $SQL
	}
}

# DELETE FROM `program` WHERE `id`=1
# INSERT INTO `program` (`id`, `name`, `ver`, `freeSoft`, `web`, `comments`, `isoFile`, `isoSrcPath`, `instSrcPath`, `instFile_x86`, `instFile_x64`, `instArgs`, `instInfFileEnc`, `instInfFileDataVars`, `instInfFileData`, `instDir`, `regData`, `regDataVars`, `commRunAfterInst`, `commRunBeforeOpen`, `runFileApp`, `runFileAppPath`, `openApp`, `waitForApp`, `appPrefsFilePath`, `appPrefsFileName`, `appPrefsFileEnc`, `appPrefsFileData`, `appPrefsFileDataVars`, `appCrkSrc`, `appCrkDestPath`, `appCrkFileName`, `appCrkDestFileEnc`, `appCrkDestData`, `appCrkDestDataVars`) VALUES (1, '1', '', 3, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', '', '', '', '', '', '', '', '', '', '')

#$DeleteCommand = 'DELETE FROM PROGRAM;' + "`n"
$AlterTable = 'ALTER TABLE `program` AUTO_INCREMENT=1;' + "`n"
$date = Get-Date -Format "MMM-dd-yyyy"

#Getting SQLite Data
$ProgramNameList = Get-DbQuery -query "SELECT name FROM Programas" | Sort-Object -Property name
#$ProgramNameList = @{name = "WinRAR" }
$MariaDBData = ""
$ProgramNameList | ForEach-Object {
	$ProgramData = get-DBProgramData($_.name)
	$MariaDBData += Get-ParsedMariaDBData ($ProgramData)
}
$DestFile = $PSScriptRoot + "\query\sql_" + $date + ".sql"
$AlterTable + $MariaDBData | Out-File $DestFile -Encoding utf8

#$MariaDBData



exit








#Writing the mariqDB SQL File
$useCommand
$AlterTable
# ALTER TABLE `program` AUTO_INCREMENT=1;

# get all program names then use this structure:

# INSERT INTO `pcbogcom_main`.`program` (`name`) VALUES ('winrar')
