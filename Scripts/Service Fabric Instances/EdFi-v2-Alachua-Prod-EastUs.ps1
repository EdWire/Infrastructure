# cd 'D:\GitHub\EdWire\Infrastructure\Scripts\Service Fabric Instances'

$sqlServerName = 'acps-sql-prod-eastus.database.windows.net'
$sqlUsername = 'acpssqlprod'
$instanceId = 'ba484f65-0485-4b61-866f-0b74c9ddc2a0'

$appParameters = @{
    "app:secretcert" = "329A3F8BD5D09FB85FAF70BE164DD8FAB7255CFA";
    "app:edgraph:api:descriptorNamespacePrefix" = "http://ed-fi.org";
    "app:edgraph:api:bearerTokenTimeoutMinutes" = "30";
    "app:edgraph:sql:edfiods:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_{0};User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=180;MultipleActiveResultSets=True;Max Pool Size=200;Persist Security Info=True;";
    "app:edgraph:sql:edfiodsbulk:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_{0};User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=180;MultipleActiveResultSets=True;Max Pool Size=200;Persist Security Info=True;";
    "app:edgraph:sql:edfiadmin:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_Admin_$instanceId;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:edfisecurity:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_Security_$instanceId;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:edfimaster:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=master;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:edfibulk:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_Bulk_$instanceId;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:password" = "MIIB0AYJKoZIhvcNAQcDoIIBwTCCAb0CAQAxggFYMIIBVAIBADA8MCgxJjAkBgNVBAMMHWRhdGFlbmNpcGhlcm1lbnQucHJvZC5zZXJ2aWNlAhAbfxP4NaLrj0sIQtmnYOdhMA0GCSqGSIb3DQEBBzAABIIBAKi8IJ8tOVyeWOOB7JbC2h/cG4T3F/nBGsVxI8bGcXp3K7hDlB+ZA4N1qoq5vhDMjf9MvKs1V9X0EDkxd2fIaYj7zb5jwyvlleQoSAchNNyt3OQSc03dqycAZ9oGOKej3G5XY6es6xvWp9hj3Gm9s/v4e6o952+dJvb050NYCJKZXOg6eDaFE7SwKL5LqO7HmNLkOX6i0a5p3crWa6s85xbzNklcZKxHluOV1TE06sVNggUbf2Pb4k4maeRfHeQxRp+4r+yDlEo1quLMh+xXeVHSxlKRToG0OdUq8jBJ0g4WaEmEXk5O3wHjuVc03rvF52k7cCGnKdjsvvBwKXtP2xkwXAYJKoZIhvcNAQcBMB0GCWCGSAFlAwQBKgQQhPgS0xR0m6VflKlpTx0hyIAwdASkQ7qCmF6S5eAb/w4tHRA1wkLg+Z9v1m6dXhNilzkAbLd11r/bpKtKCeiBZ6iw";
    "log:appinsights:instrumentationkey" = "ea3985df-0811-4963-b1d8-d821bf5af5fd"
};

& '.\SF Instancing.ps1' -CreateApplicationInstance  `
                        -SfConnectionEndpoint "sf-eastus.edgraph.com:19000" `
                        -SfServerCertThumbprint "C7D1BE1C290B44FC0094EF1FC4D5080A117C1035" `
                        -AppTypeName "EdGraph.EdFi.Ods.AppType" `
                        -AppTypeVersion "Core.2.6.0.0.20191010.1" `
                        -AppName "fabric:/EdGraph.EdFi/v2.6/$instanceId" `
                        -AppPkgPath "https://eginternaldevwestus.blob.core.windows.net/packages/EdGraph.EdFi.Ods.App/Core.2.6.0.0.20191010.1/EdGraph.EdFi.Ods.App-Core.2.6.0.0.20191010.1.sfpkg?st=2019-10-24T16%3A46%3A07Z&se=2019-10-25T16%3A46%3A07Z&sp=rl&sv=2018-03-28&sr=b&sig=ZcUzYot%2Bhd0Ti7d%2Bbcyw1RewuRCxNFaI07YlLH5TrqY%3D" `
                        -AppParameters $appParameters
