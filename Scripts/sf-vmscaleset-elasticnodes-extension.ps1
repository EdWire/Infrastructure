#
# sf-vmscaleset-elasticnodes-extension.ps1
#

#---------------------------
# Input Parameters
#---------------------------

Param (
)

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
