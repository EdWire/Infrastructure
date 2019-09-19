#---------------------------
# Input Parameters
#---------------------------

$ResourceGroupName = "edgraph-prod-eastus"
$ResourceGroupLocation = "eastus"
$LighthouseTemplateFileUri = "https://raw.githubusercontent.com/EdWire/Infrastructure/master/Scripts/Lighthouse/lighthouseTemplate.json"
$LighthouseTemplateParameterFileUri = "https://raw.githubusercontent.com/EdWire/Infrastructure/master/Scripts/Lighthouse/lighthouseTemplate.edwire.parameters.json"
$ValidateOnly = $true

# Stop the script on first error
$ErrorActionPreference = "Stop"

#---------------------------
# Enable Azure Lighthouse (Delegated Resource Management)
#---------------------------

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
