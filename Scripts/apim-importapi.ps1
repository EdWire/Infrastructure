#Import the Module
Import-Module Az

#Connect to Azure
Connect-AzAccount

#Create the context
$context = New-AzApiManagementContext -ResourceGroupName "eg-edgraph-dev-eastus" -ServiceName "eg-apim-dev-eastus"

#Import swagger using a link
#Import-AzApiManagementApi -Context $context -ApiId "ed-fi-api-v2-6" -ApiType Http -SpecificationUrl "https://eginternaldevwestus.blob.core.windows.net/packages/EdGraph.EdFi.Ods.App/Core.2.6.0.0.20191010.1/edfi-core-oauth-descriptors-resources-types-enrollment.json?st=2019-10-25T21%3A23%3A51Z&se=2019-10-26T21%3A23%3A51Z&sp=rl&sv=2018-03-28&sr=b&sig=69REitTess2R5qyrn0Qbl%2Fv3rFjPXXRlz3Rtnasy1%2Fk%3D" -SpecificationFormat Swagger -Path "edfi" -ApiVersionSetId "versionset-edfi-api" -ApiVersion "v2.6"
#Import-AzApiManagementApi -Context $context -ApiId "ed-fi-api-v3-2" -ApiType Http -SpecificationUrl "https://eginternaldevwestus.blob.core.windows.net/packages/EdGraph.EdFi.Ods.App/Core.2.6.0.0.20191010.1/edfi-core-oauth-descriptors-resources-types-enrollment.json?st=2019-10-25T21%3A23%3A51Z&se=2019-10-26T21%3A23%3A51Z&sp=rl&sv=2018-03-28&sr=b&sig=69REitTess2R5qyrn0Qbl%2Fv3rFjPXXRlz3Rtnasy1%2Fk%3D" -SpecificationFormat Swagger -Path "edfi" -ApiVersionSetId "versionset-edfi-api" -ApiVersion "v3.2" 

#Get APIs
$apis = Get-AzApiManagementApi -Context $context

#Remove APIs
#$removeEdFiv26 = Remove-AzApiManagementApi -Context $context -ApiId "ed-fi-api-v2-6" -Confirm
#$removeEdFiv32 = Remove-AzApiManagementApi -Context $context -ApiId "ed-fi-api-v3-2" -Confirm

#Get Version Set
$versionSets = Get-AzApiManagementApiVersionSet -Context $context

#Remove Version Set
#Remove-AzApiManagementApiVersionSet -Context $context -ApiVersionSetId versionset-edfi-api -Confirm
