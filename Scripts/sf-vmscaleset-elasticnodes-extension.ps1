#
# sf-vmscaleset-elasticnodes-extension.ps1
#

#---------------------------
# Input Parameters
#---------------------------

Param (
    [Switch] $sfEsStorageAccountName = $false,
    [Switch] $sfEsStorageAccountKey = $false,
    [Switch] $sfEsStorageAccountShareName = $true,
    [Switch] $driveLetter = "e"
)

#---------------------------
# Mount File Share 
#---------------------------

$acctKey = ConvertTo-SecureString -String "$sfEsStorageAccountKey" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$sfEsStorageAccountName", $acctKey
New-PSDrive -Name $driveLetter -PSProvider FileSystem -Root "\\$sfEsStorageAccountName.file.core.windows.net\$sfEsStorageAccountShareName" -Credential $credential

#---------------------------
# Install Java SDK
#---------------------------

# install chocolatey
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1

# install java
choco install -y -force javaruntime