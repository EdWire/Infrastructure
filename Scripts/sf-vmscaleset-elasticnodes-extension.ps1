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

$dataDisk0 = Get-Disk | Where-Object {$_.PartitionStyle -eq 'raw' -and ($_.Number -eq 3) }

$dataDisk0 | 
Initialize-Disk -PartitionStyle MBR -PassThru |
New-Partition -UseMaximumSize -DriveLetter "G" |
Format-Volume -FileSystem NTFS -NewFileSystemLabel "DataDisk0" -Confirm:$false -Force

#---------------------------
# Install Java SDK
#---------------------------

# install chocolatey
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1

# install java
choco install -y -force javaruntime
