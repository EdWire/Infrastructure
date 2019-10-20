#---------------------------
# Input Parameters
#---------------------------

Param (
    [String] $AzureTenantId,
    [String] $AzureSubscriptionName,
    [String] $ResourceGroupName,
    [String] $ResourceGroupLocation,
    [String] $LighthouseTemplateFileUri = "$PSScriptRoot\lighthouseTemplate.json",
    [String] $LighthouseTemplateParameterFileUri = "$PSScriptRoot\lighthouseTemplate.edwire.parameters.json",
    [Switch] $ValidateOnly
)

# Stop the script on first error
$ErrorActionPreference = "Stop"

#---------------------------
# Login and Select Azure Subscription
#---------------------------

# TODO Switch to certificate-based authentication?
# https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-2.5.0

# Establish connection to Azure
Write-Output "Connecting to Azure..."

if ([string]::IsNullOrWhiteSpace($AzureTenantId)) 
{
    Connect-AzAccount
}
else 
{
    Connect-AzAccount -TenantId $AzureTenantId
}

# Select Subscription
$azureSubscription = Set-AzContext -Subscription $AzureSubscriptionName

Write-Output "Connected to Subscription"
Write-Output $azureSubscription

# Create Resource Gorup if it does not already exist
$resourceGroup = Get-AzResourceGroup -Name  $ResourceGroupName -ErrorAction SilentlyContinue

if ($resourceGroup -eq $null)
{
	Write-Output "Creating resource group $ResourceGroupName"

	$resourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation

	Write-Output "Created resource group $ResourceGroupName"
}

Write-Output "Selected resource group"
Write-Output $resourceGroup

#---------------------------
# Enable Azure Lighthouse (Delegated Resource Management)
#---------------------------

Test-AzDeployment -Location $ResourceGroupLocation `
				  -TemplateFile $LighthouseTemplateFileUri `
				  -TemplateParameterFile $LighthouseTemplateParameterFileUri `
				  -Verbose

if ($ValidateOnly -eq $false)
{
	Write-Output "New-AzDeployment - Start"
	
	New-AzDeployment -Name 'EdWire-Lighthouse-Deployment' `
					 -Location $ResourceGroupLocation `
					 -TemplateFile $LighthouseTemplateFileUri `
					 -TemplateParameterFile $LighthouseTemplateParameterFileUri `
					 -Verbose

	Write-Output "New-AzDeployment - End"
}
