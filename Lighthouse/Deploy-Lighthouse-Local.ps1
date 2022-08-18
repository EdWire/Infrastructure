#---------------------------
# Instructions
# - This must be run in a local PowerShell window.
# - The user must log in with an account that has Azure Global Administrator permissions
# - The resource group(s) that are part being given access to in the customer's Azure subscription must be created ahead of time
# - Replace the $AzureTenantId variable with the customer's Azure Tenant Id where the resource being given access are located
# - Replace the $AzureSubscriptionName variable with the customer's Azure Subscription Name where the resource being given access are located
# - Create or Update the parameters file in Github that will be used by this script to create the permissions between the Partner and Customer's Azure Subscriptions 
# - In the parameters file, make sure that the values are accurate
# - Confirm that the parameter file URI is correct in $LighthouseTemplateParameterFileUri variable below
#---------------------------

#---------------------------
# Input Parameters
#---------------------------

Param (
    [String] $AzureTenantId,
    [String] $AzureSubscriptionName,
    [String] $LighthouseTemplateFileUri = "$PSScriptRoot\lighthouseTemplate.json",
    [String] $LighthouseTemplateParameterFileUri = "$PSScriptRoot\lighthouseTemplate.volusia-edwire.parameters.json",
    [Switch] $ValidateOnly
)

# Stop the script on first error
$ErrorActionPreference = "Stop"

#---------------------------
# Login and Select Azure Subscription
#---------------------------

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

Write-Output "Connected to Subscription $AzureSubscriptionName"
Write-Output $azureSubscription

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
