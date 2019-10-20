#---------------------------
# Summary
#---------------------------

# Enables APIM Management ApimResourceGroupName
# Override Subscription Primary and Secondary Key

#---------------------------
# Input Parameters
#---------------------------

param(
    [string]$ApimResourceGroupName = "eg-edgraph-dev-eastus",
    [string]$ApimServiceName = "eg-apim-dev-eastus",
    [switch]$EnableApiManagementApi = $true,
    [switch]$OverrideSubscriptionKey = $true,
	[string]$ApimProductId = 'unlimited'
    [string]$ApimUnlimitedPrimaryKey = '07eeae70569b4af3af9b6cea759e7928',
	[string]$ApimUnlimitedSecondaryKey = '0168da4eff0946ecba2d4b7d2e82e7f1'
);

$ApimResourceGroupName = "eg-edgraph-dev-eastus"
$ApimServiceName = "eg-apim-dev-eastus"

$apimContext = New-AzApiManagementContext -ResourceGroupName $ApimResourceGroupName -ServiceName $ApimServiceName

Set-AzApiManagementTenantAccess -Context $apimContext -Enabled $true

if ($OverrideSubscriptionKey -eq $true)
{
	$apimSubscription = Get-AzApiManagementSubscription -Context $apimContext -ProductId $ApimProductId
	$apimSubscription = Set-AzApiManagementSubscription -Context $apimContext -SubscriptionId $apimSubscription[0].SubscriptionId -PrimaryKey $ApimUnlimitedPrimaryKey -SecondaryKey $ApimUnlimitedSecondaryKey -State "Active"
}