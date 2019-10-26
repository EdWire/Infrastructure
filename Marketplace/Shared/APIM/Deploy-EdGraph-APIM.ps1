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

# cd D:\GitHub\EdWire\Infrastructure\Marketplace\Shared\APIM

# EdWire Dev East Us
# .\Deploy-EdGraph-APIM.ps1 -AzureSubscriptionName "Development" -ResourceGroupName "eg-edgraph-dev-eastus" -ResourceGroupLocation "EastUS" -ParameterFileUri "apim.parameters.edwire.dev.eastus.json"

# EdWire Prod East Us
# .\Deploy-EdGraph-APIM.ps1 -AzureSubscriptionName "Production" -ResourceGroupName "eg-sf-prod-eastus" -ResourceGroupLocation "EastUS" -ParameterFileUri "apim.parameters.edwire.prod.eastus.json"

#---------------------------
# Input Parameters
#---------------------------

Param (
    [String] $AzureTenantId,
    [String] $AzureSubscriptionName,
    [String] $ResourceGroupName,
    [String] $ResourceGroupLocation,
    [String] $RepositoryBaseUrl = 'https://raw.githubusercontent.com/EdWire/Infrastructure/Development_LinkedTemplates/Marketplace/Shared/APIM',
    [String] $ParameterFileUri,
    [Switch] $ValidateOnly = $false
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

Write-Output "Test-AzResourceGroupDeployment - Start"

$deploymentTestResult = Test-AzResourceGroupDeployment  -ResourceGroupName $ResourceGroupName `
                                                        -TemplateUri "$RepositoryBaseUrl/apim.master.template.json" `
                                                        -TemplateParameterUri "$RepositoryBaseUrl/$ParameterFileUri"

if ([string]::IsNullOrEmpty($deploymentTestResult) -and $ValidateOnly -eq $false)
{
    Write-Output "Test-AzResourceGroupDeployment - Template is Valid"

    Write-Output "New-AzResourceGroupDeployment - Starting deployment in $ResourceGroupName"

    New-AzResourceGroupDeployment   -ResourceGroupName $ResourceGroupName `
                                    -TemplateUri "$RepositoryBaseUrl/apim.master.template.json" `
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