#---------------------------
# Instructions
# - This must be run in the Azure Cloud Shell of the customer while logged in Azure Portal as a Azure Global Administrator
# - The resource group(s) that are part being given access to in the customer's Azure subscription must be created ahead of time
# - Replace the $AzureSubscriptionName variable with the customer's Azure Subscription Name where the resource being given access are located
# - Create or Update the parameters file in Github that will be used by this script to create the permissions between the Partner and Customer's Azure Subscriptions 
# - In the parameters file, make sure that the values are accurate
# - Confirm that the parameter file URI is correct in $LighthouseTemplateParameterFileUri variable below
#---------------------------

#---------------------------
# Input Parameters
#---------------------------

$AzureSubscriptionName = "[Customer's Azure Subscription Name]"
$LighthouseTemplateFileUri = "https://raw.githubusercontent.com/EdWire/Infrastructure/master/Lighthouse/lighthouseTemplate.json"
$LighthouseTemplateParameterFileUri = "https://raw.githubusercontent.com/EdWire/Infrastructure/master/Lighthouse/lighthouseTemplate.volusia-edwire.parameters.json"
$ValidateOnly = $true

# Stop the script on first error
$ErrorActionPreference = "Stop"

#---------------------------
# Login and Select Azure Subscription
#---------------------------

# Select Subscription
$azureSubscription = Set-AzContext -Subscription $AzureSubscriptionName

Write-Output "Connected to Subscription $AzureSubscriptionName"
Write-Output $azureSubscription

#---------------------------
# Enable Azure Lighthouse (Delegated Resource Management)
#---------------------------

Test-AzDeployment -Location $ResourceGroupLocation `
				  -TemplateUri $LighthouseTemplateFileUri `
				  -TemplateParameterUri $LighthouseTemplateParameterFileUri `
				  -Verbose

if ($ValidateOnly -eq $false)
{
	Write-Output "New-AzDeployment - Start"
	
	New-AzDeployment -Name 'EdWire-Lighthouse-Deployment' `
					 -Location $ResourceGroupLocation `
					 -TemplateUri $LighthouseTemplateFileUri `
					 -TemplateParameterUri $LighthouseTemplateParameterFileUri `
					 -Verbose

	Write-Output "New-AzDeployment - End"
}
