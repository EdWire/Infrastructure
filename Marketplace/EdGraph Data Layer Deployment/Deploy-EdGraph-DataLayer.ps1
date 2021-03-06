﻿#---------------------------
# Summary
#---------------------------


#---------------------------
# Notes
#---------------------------

# cd 'D:\EdWire\Git\EG.Deploy\EdGraph.Deploy\Marketplace\EdGraph Data Layer Deployment'

# Alachua Prod 
# .\Deploy-EdGraph-DataLayer.ps1 -AzureSubscriptionName "ACPS (Production)" -ResourceGroupName "edgraph-prod-eastus" -ResourceGroupLocation "EastUS" -ParameterFileUri "\dataLayerTemplate.parameters.acps.prod.eastus.json"

# EdWire Prod
# .\Deploy-EdGraph-DataLayer.ps1 -AzureSubscriptionName "Development" -ResourceGroupName "eg-edgraph-dev-eastus" -ResourceGroupLocation "EastUS" -ParameterFileUri "\dataLayerTemplate.parameters.edwire.dev.eastus.json"

#---------------------------
# Input Parameters
#---------------------------

Param (
    [String] $AzureTenantId,
    [String] $AzureSubscriptionName,
    [String] $ResourceGroupName,
    [String] $ResourceGroupLocation,
    [String] $ParameterFileUri,
    [Switch] $ValidateOnly = $false
)

# Stop the script on first error
$ErrorActionPreference = "Stop"

#---------------------------
# Login and Select Azure Subscription
#---------------------------

# TODO Switch to certificate-based authentication?
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-2.5.0

# Establish connection to Azure
if ([string]::IsNullOrWhiteSpace($AzureTenantId)) {
    #Connect-AzAccount
}
else {
    Connect-AzAccount -TenantId $AzureTenantId
}

# Select Subscription
$sfSubscription = Set-AzContext -Subscription $AzureSubscriptionName


#---------------------------
# Create Resource Group
#---------------------------

# Create Resource Group, if one does not exists already
if ((Get-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -ErrorAction SilentlyContinue) -eq $null) {
    New-AzResourceGroup -ResourceGroupName $ResourceGroupName -Location $ResourceGroupLocation -Tag @{Scope="EdGraph"} -Verbose -Force -ErrorAction Stop
}


#---------------------------
# Deploy Policies & RBAC to subscription
#---------------------------

# TODO Deploy Policies & RBAC to subscription
#New-AzDeployment -Location <location> -TemplateFile <path-to-template>


#---------------------------
# Deploy Template
#---------------------------
Write-Output "New-AzResourceGroupDeployment - Start"

$deploymentTestResult = Test-AzResourceGroupDeployment  -ResourceGroupName $ResourceGroupName `
                                                        -TemplateFile "$PSScriptRoot\dataLayerTemplate.json" `
                                                        -TemplateParameterFile "$PSScriptRoot$ParameterFileUri" `
                                                        -Debug

if ([string]::IsNullOrEmpty($deploymentTestResult) -and $ValidateOnly -eq $false)
{
    Write-Output "Test-AzResourceGroupDeployment - Template is Valid"

    Write-Output "New-AzResourceGroupDeployment - Starting deployment in $ResourceGroupName"

#    $sqlResourceProvider = Get-AzResourceProvider -ListAvailable | Where-Object ProviderNamespace -eq "Microsoft.Sql"

#    if ($sqlResourceProvider.RegistrationState -eq "NotRegistered")
#    {
#        Write-Output "Registering Microsoft.Sql Azure Provider for this subscription"
#        Register-AzResourceProvider -ProviderNamespace Microsoft.Sql
#    }
#    else
#    {
#        Write-Output "Microsoft.Sql Azure Provider already registered for this subscription"
#    }    

    New-AzResourceGroupDeployment   -ResourceGroupName $ResourceGroupName `
                                    -TemplateFile "$PSScriptRoot\dataLayerTemplate.json" `
                                    -TemplateParameterFile "$PSScriptRoot$ParameterFileUri"
}
else
{
    Write-Output "Test-AzResourceGroupDeployment - Template is NOT Valid"

    Write-Output $deploymentTestResult | Format-List

    Exit
}

Write-Output "New-AzResourceGroupDeployment - End"