#---------------------------
# Input Parameters
#---------------------------

param(
    [switch]$PrepElasticSearch = $false,
    [switch]$SetPermissionToCertificate = $false,
    [string]$UserName = "Network Service",
    [string]$Permission = "full",
    [string]$CertStoreLocation = "\LocalMachine\My",
    [string]$CertThumbprint
);


function SetPermissionToCertificate($userName, $permission, $certStoreLocation, $certThumbprint) {

    # check if certificate is already installed
    $certificateInstalled = Get-ChildItem cert:$certStoreLocation | Where thumbprint -eq $certThumbprint

    # download & install only if certificate is not already installed on machine
    if ($certificateInstalled -eq $null)
    {
        $message="Certificate with thumbprint: " + $certThumbprint + " does not exist at " + $certStoreLocation
        Write-Host $message -ForegroundColor Red
        exit 1;
    }
    else
    {
        try
        {
            $rule = new-object security.accesscontrol.filesystemaccessrule $userName, $permission, allow
            $root = "c:\programdata\microsoft\crypto\rsa\machinekeys"
            $l = ls Cert:$certStoreLocation
            $l = $l |? {$_.thumbprint -like $certThumbprint}
            $l |%{
                $keyname = $_.privatekey.cspkeycontainerinfo.uniquekeycontainername
                $p = [io.path]::combine($root, $keyname)
                if ([io.file]::exists($p))
                {
                    $acl = get-acl -path $p
                    $acl.addaccessrule($rule)
                    echo $p
                    set-acl $p $acl
                }
            }
        }
        catch 
        {
            Write-Host "Caught an exception:" -ForegroundColor Red
            Write-Host "$($_.Exception)" -ForegroundColor Red
            exit 1;
        }    
    }
}


function PrepElasticSearch() {

    #---------------------------
    # Mount Data Drive (lun = 0)
    #---------------------------

    Write-Output "-------------------------"
    Write-Output "Mounting Data Drive"
    Write-Output "-------------------------"

    Write-Output "Get Raw Disk"

    $dataDisk0 = Get-Disk | Where-Object {$_.PartitionStyle -eq 'raw' -and ($_.Number -eq 2) }

    Write-Output $dataDisk0

    Write-Output "Initialize Raw Disk"

    $dataDisk0 | 
    Initialize-Disk -PartitionStyle MBR -PassThru |
    New-Partition -UseMaximumSize -DriveLetter "G" |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel "DataDisk0" -Confirm:$false -Force

    Write-Output "Completed Mounting Data Drive"

    if ($dataDisk0)
    {
        #---------------------------
        # Install Java SDK
        #---------------------------

        Write-Output "-------------------------"
        Write-Output "Installing Java SDK"
        Write-Output "-------------------------"

        # install chocolatey
        Write-Output "Installing Chocolatey"

        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

        # install java
        Write-Output "Installing Java Runtime"

        choco install -y -force jre8 --version 8.0.161

        Write-Output "Completed Installing Java SDK"
    }
}


if ($PrepElasticSearch -eq $true)
{
    PrepElasticSearch
}

if ($SetPermissionToCertificate -eq $true)
{
    SetPermissionToCertificate -userName $UserName -permission $Permission -certStoreLocation $CertStoreLocation -certThumbprint $CertThumbprint
}
