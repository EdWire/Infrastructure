#---------------------------
# Input Parameters
#---------------------------

Param (
    [switch] $IsLocalDeployment = $false, 
    [string] $SfConnectionEndpoint = "sf-eastus.writescore-dev.com:19000",   # localhost:19000
    [string] $SfServerCertThumbprint = "ef 57 18 42 36 e3 00 49 a1 4f 6d 8d 77 ce 19 c8 d8 54 dd f5",
    [string] $AppTypeName = "EdGraph.EdFi.Ods.AppType",
    [string] $AppTypeVersion = "Core-2.5.0.1.20190419.1",
    [string] $AppName = "fabric:/EdGraph.EdFi/Target/v2.5",
    [string] $serviceTypeName = "EdGraph.EdFi.Ods.WebApiType",
    [string] $AppServiceName = "fabric:/EdGraph.EdFi/Target/v2.5/WebApi",
    [string] $AppPkgPath = "https://eginternaldevwestus.blob.core.windows.net/packages/EdGraph.EdFi.Ods.AppType.Core-2.5.0.1.20190419.1.sfpkg?st=2019-05-03T17%3A41%3A22Z&se=2019-05-04T17%3A41%3A22Z&sp=rl&sv=2018-03-28&sr=b&sig=tkIVDwVG6C%2B%2BYvfW3M553DC0EWY6IdjPcDWoS0qWXzg%3D",
    [switch] $PublishPackage = $false,
    [switch] $CreateApplicationInstance = $false,
    [switch] $UpgradeApplicationInstance = $false,
    [switch] $CreateServiceInstance = $false,
    [hashtable] $AppParameters = @{}
)

# Stop the script on first error
$ErrorActionPreference = "Stop"

#--------------------------------
# Cluster Connection
#--------------------------------

Connect-ServiceFabricCluster -ConnectionEndpoint $SfConnectionEndpoint -AzureActiveDirectory -ServerCertThumbprint $SfServerCertThumbprint

If ($IsLocalDeployment -eq $true)
{
    $imageStoreConnectionString = "file:c:\sfDevCluster\Data\ImageStoreShare"
}
Else
{
    $imageStoreConnectionString = "fabric:ImageStore"
}

#--------------------------------
# Deploy Packages
#--------------------------------

If ($PublishPackage)
{
    # Old way (Local Folder)
    #Copy-ServiceFabricApplicationPackage -ApplicationPackagePath $AppPkgPath -ImageStoreConnectionString $imageStoreConnectionString -ApplicationPackagePathInImageStore $AppTypeName
    #Register-ServiceFabricApplicationType -ApplicationPathInImageStore $AppTypeName
    
    # New way (Storage Account Blob Container)
    Register-ServiceFabricApplicationType -ApplicationPackageDownloadUri $AppPkgPath -ApplicationTypeName $AppTypeName -ApplicationTypeVersion $AppTypeVersion -TimeoutSec 600
    #Get-ServiceFabricApplicationType

    Remove-ServiceFabricApplicationPackage -ImageStoreConnectionString $imageStoreConnectionString -ApplicationPackagePathInImageStore $AppTypeName
}

If ($CreateApplicationInstance -eq $true) 
{
    New-ServiceFabricApplication -ApplicationTypeName $AppTypeName -ApplicationName $AppName -ApplicationTypeVersion $AppTypeVersion -ApplicationParameter $AppParameters
}

If ($UpgradeApplicationInstance -eq $true) 
{
    Start-ServiceFabricApplicationUpgrade -ApplicationName $AppName -ApplicationTypeVersion $AppTypeVersion -UnmonitoredAuto -ForceRestart -UpgradeReplicaSetCheckTimeoutSec 100 -ApplicationParameter $AppParameters
}

If ($CreateServiceInstance -eq $true) {

    New-ServiceFabricService -ApplicationName $AppName -ServiceTypeName $ServiceTypeName -ServiceName $serviceName -Stateless -PartitionSchemeSingleton -InstanceCount "-1"
}


#Update-ServiceFabricService -ServiceName $service1Name -Stateless -InstanceCount "1" -Force
#Update-ServiceFabricService -ServiceName $service2Name -Stateful -TargetReplicaSetSize 1 -MinReplicaSetSize 1
#Remove-ServiceFabricApplication -ApplicationName $AppName
#Unregister-ServiceFabricApplicationType -ApplicationTypeName $AppTypeName -ApplicationTypeVersion "1.0.0"

#Get-ServiceFabricApplicationUpgrade -ApplicationName $AppName
#Start-ServiceFabricApplicationUpgrade -ApplicationName $AppName -ApplicationTypeVersion $AppTypeVersion -UnmonitoredAuto -UpgradeReplicaSetCheckTimeoutSec 100
#Resume-ServiceFabricApplicationUpgrade -ApplicationName $AppName -UpgradeDomainName "1"

