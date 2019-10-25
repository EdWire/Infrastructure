#---------------------------
# Summary
#---------------------------


#---------------------------
# Notes
#---------------------------

# Prior to running this script, you must...
#   - Upload SSL and DataEncipherment Certificate to KeyVault
#     - Use the KeyVault Resource ID and Certificate's Secret Url in the parameters file
#   - Create Azure AD Application for access to the SF Cluster Management Endpoint
#     - Use the Application IDs in the parameters file

# cd 'D:\GitHub\EdWire\Infrastructure\Marketplace\EdGraph Full Deployment'

# EdWire Prod
# .\Deploy-EdGraph-ServiceLayer.ps1 -AzureSubscriptionName "Development" -ResourceGroupName "eg-edgraph-dev-eastus" -ResourceGroupLocation "EastUS" -ParameterFileUri "\mainTemplate.parameters.edwire.dev.eastus.json"

# Write Score Prod
# .\Deploy-EdGraph-ServiceLayer.ps1 -AzureSubscriptionName "Pay-As-You-Go" -ResourceGroupName "ws-edgraph-prod-eastus" -ResourceGroupLocation "EastUS" -ParameterFileUri "\mainTemplate.parameters.writescore.prod.eastus.json"


#---------------------------
# Input Parameters
#---------------------------

Param (
    [String] $AzureTenantId,
    [String] $AzureSubscriptionName,
    [String] $ResourceGroupName,
    [String] $ResourceGroupLocation,
    [String] $ParameterFileUri,
    [Switch] $ValidateOnly = $true
)

# Stop the script on first error
$ErrorActionPreference = "Stop"

#---------------------------
# Login and Select Azure Subscription
#---------------------------

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
# Deploy Template
#---------------------------
Write-Output "New-AzResourceGroupDeployment - Start"

$deploymentTestResult = Test-AzResourceGroupDeployment  -ResourceGroupName $ResourceGroupName `
                                                        -TemplateFile "$PSScriptRoot\mainTemplate.json" `
                                                        -TemplateParameterFile "$PSScriptRoot\$ParameterFileUri" `
                                                        -Debug

if ([string]::IsNullOrEmpty($deploymentTestResult) -and $ValidateOnly -eq $false)
{
    Write-Output "Test-AzResourceGroupDeployment - Template is Valid"

    Write-Output "New-AzResourceGroupDeployment - Starting deployment in $ResourceGroupName"

    New-AzResourceGroupDeployment   -ResourceGroupName $ResourceGroupName `
                                    -TemplateFile "$PSScriptRoot\mainTemplate.json" `
                                    -TemplateParameterFile "$ParameterFileUri"
}
else
{
    Write-Output "Test-AzResourceGroupDeployment - Template is NOT Valid"

    Write-Output $deploymentTestResult | Format-List

    Exit
}

Write-Output "New-AzResourceGroupDeployment - End"