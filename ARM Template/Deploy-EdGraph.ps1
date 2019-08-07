#---------------------------
# Input Parameters
#---------------------------

Param (
    [String] $AzureTenantId,
    [String] $AzureSubscriptionName = "Pay-As-You-Go",
    [String] $ResourceGroupName = "ws-edgraph-prod-eastus",
    [String] $ResourceGroupLocation = "EastUS",
    [String] $ParameterFileUri = "$PSScriptRoot\mainTemplate.parameters.writescore.prod.eastus.json",
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
                                                        -TemplateFile "$PSScriptRoot\mainTemplate.json" `
                                                        -TemplateParameterFile "$ParameterFileUri" `
                                                        -Debug

If ([string]::IsNullOrEmpty($deploymentTestResult) -and $ValidateOnly -eq $false)
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
