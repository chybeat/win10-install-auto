<#
function Takeown-Registry($key) {
    # TODO does not work for all root keys yet
    switch ($key.split('\')[0]) {
        "HKEY_CLASSES_ROOT" {
            $reg = [Microsoft.Win32.Registry]::ClassesRoot
            $key = $key.substring(18)
        }
        "HKEY_CURRENT_USER" {
            $reg = [Microsoft.Win32.Registry]::CurrentUser
            $key = $key.substring(18)
        }
        "HKEY_LOCAL_MACHINE" {
            $reg = [Microsoft.Win32.Registry]::LocalMachine
            $key = $key.substring(19)
        }
    }

    # get administraor group
    $admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $admins = $admins.Translate([System.Security.Principal.NTAccount])

    # set owner
    $key = $reg.OpenSubKey($key, "ReadWriteSubTree", "TakeOwnership")
    $acl = $key.GetAccessControl()
    $acl.SetOwner($admins)
    $key.SetAccessControl($acl)

    # set FullControl
    $acl = $key.GetAccessControl()
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule($admins, "FullControl", "Allow")
    $acl.SetAccessRule($rule)
    $key.SetAccessControl($acl)
}
function Takeown-Folder{} #renamed to get-OwnFolder
function Takeown-File{} #renamed to get-OwnFile

#>
function Get-OwnFile($path) {
	takeown.exe /A /F $path
	$acl = Get-Acl $path

	# get administraor group
	$admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
	$admins = $admins.Translate([System.Security.Principal.NTAccount])

	# add NT Authority\SYSTEM
	$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($admins, "FullControl", "None", "None", "Allow")
	$acl.AddAccessRule($rule)

	Set-Acl -Path $path -AclObject $acl
}

function Get-OwnFolder($path) {
	Get-OwnFile $path
	foreach ($item in Get-ChildItem $path) {
		if (Test-Path $item -PathType Container) {
			Get-OwnFolder $item.FullName
		} else {
			Get-OwnFile $item.FullName
		}
	}
}

function Get-ElevatedPrivileges {
	<#
	.SYNOPSIS
		Eleva los privilegios de ejecucin del script

	.DESCRIPTION
		realiza la ejecucin del script con privilegios de administrador

	.PARAMETER Privilege
		Tipo de privilegio que se asignar al script. 'SeTakeOwnershipPrivilege' es el mas alto

	#>
	param($Privilege)
	$Definition = @"
    using System;
    using System.Runtime.InteropServices;

    public class AdjPriv {
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr rele);

        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);

        [DllImport("advapi32.dll", SetLastError = true)]
            internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
            internal struct TokPriv1Luid {
                public int Count;
                public long Luid;
                public int Attr;
            }

        internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
        internal const int TOKEN_QUERY = 0x00000008;
        internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;

        public static bool EnablePrivilege(long processHandle, string privilege) {
            bool retVal;
            TokPriv1Luid tp;
            IntPtr hproc = new IntPtr(processHandle);
            IntPtr htok = IntPtr.Zero;
            retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
            tp.Count = 1;
            tp.Luid = 0;
            tp.Attr = SE_PRIVILEGE_ENABLED;
            retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
            retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
            return retVal;
        }
    }
"@
	$ProcessHandle = (Get-Process -Id $pid).Handle
	$type = Add-Type $definition -PassThru
	$type[0]::EnablePrivilege($processHandle, $Privilege)
}

function Set-FullAccess {
	<#
	.SYNOPSIS
		Dar acceso completo a cualquier usuario en una ruta o archivo

	.DESCRIPTION
		Al parametro path se debe pasar el archivo o ruta al que se le desea dar todos los permisos de acceso o esritura

	.PARAMETER Path
		La ruta (archivo o carpeta) que se quiere colocar sin restriccin de acceso a cualquier usuario

	#>
	param(
		[Parameter(Mandatory, Position = 0)]
		[string]
		$Path
	)
	process {
		$items = @()
		Get-ChildItem -Path $path -Recurse | ForEach-Object {
			$items += $_.DirectoryName
			$items += $_.FullName
		}

		$items = $items | Sort-Object -Unique
		$items | ForEach-Object {

			$acl = Get-Acl -Path $_
			if (Test-Path -Path $_ -PathType Container) {
				#for directory
				$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ("Everyone", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
				$acl.SetAccessRuleProtection($false, $true)
				$object = New-Object System.Security.Principal.Ntaccount("Everyone")
				$acl.SetOwner($object)
			} else {
				#for file
				$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "Allow")
				$acl.SetAccessRule($accessRule)
			}
			$acl | Set-Acl -Path $_
		}
	}
}
