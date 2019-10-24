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

# cd D:\GitHub\EdWire\Infrastructure\Marketplace\Shared\KeyVault

# Alachua Prod
# .\Deploy-EdGraph-KeyVault.ps1 -AzureSubscriptionName "ACPS (Production)" -ResourceGroupName "edgraph-prod-eastus" -ResourceGroupLocation "EastUS" -ParameterFileUri "\keyvault.parameters.acps.prod.eastus.json"

# EdWire Prod
# .\Deploy-EdGraph-KeyVault.ps1 -AzureSubscriptionName "Development" -ResourceGroupName "eg-edgraph-dev-eastus" -ResourceGroupLocation "EastUS" -ParameterFileUri "keyvault.parameters.edwire.prod.eastus.json"

#---------------------------
# Input Parameters
#---------------------------

Param (
    [String] $AzureTenantId,
    [String] $AzureSubscriptionName,
    [String] $ResourceGroupName,
    [String] $ResourceGroupLocation,
    [String] $RepositoryBaseUrl = 'https://raw.githubusercontent.com/EdWire/Infrastructure/Development_LinkedTemplates/Marketplace/Shared/KeyVault',
    [String] $ParameterFileUri,
    [Switch] $ValidateOnly = $true
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
Write-Output "Test-AzResourceGroupDeployment - Start"


$deploymentTestResult = Test-AzResourceGroupDeployment  -ResourceGroupName $ResourceGroupName `
                                                        -TemplateUri "$RepositoryBaseUrl/keyvault.master.template.json" `
                                                        -TemplateParameterUri "$RepositoryBaseUrl/$ParameterFileUri" `
                                                        -Debug

if ([string]::IsNullOrEmpty($deploymentTestResult))
{
    Write-Output "Test-AzResourceGroupDeployment - Template is Valid"

    Write-Output "New-AzResourceGroupDeployment - Starting deployment in $ResourceGroupName"

    New-AzResourceGroupDeployment   -ResourceGroupName $ResourceGroupName `
                                    -TemplateUri "$RepositoryBaseUrl/keyvault.master.template.json" `
                                    -TemplateParameterUri "$RepositoryBaseUrl/$ParameterFileUri" `
                                    -Debug
}
else
{
    Write-Output "Test-AzResourceGroupDeployment - Template is NOT Valid"

    Write-Output $deploymentTestResult | Format-List

    Exit
}

Write-Output "New-AzResourceGroupDeployment - End"