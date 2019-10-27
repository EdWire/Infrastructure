$sqlServerName = 'eg-sql-dev-eastus.database.windows.net'
$sqlUsername = 'egsqldev'
$instanceId = '00000000-0000-0000-0000-000000000260'

$appParameters = @{
    "app:secretcert" = "51CEBE8EFD2BF6AC2227A7AD49E77E47DCF78441";
    "app:edgraph:api:descriptorNamespacePrefix" = "http://ed-fi.org";
    "app:edgraph:api:bearerTokenTimeoutMinutes" = "30";
    "app:edgraph:sql:edfiods:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_{0};User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=180;MultipleActiveResultSets=True;Max Pool Size=200;Persist Security Info=True;";
    "app:edgraph:sql:edfiodsbulk:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_{0};User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=180;MultipleActiveResultSets=True;Max Pool Size=200;Persist Security Info=True;";
    "app:edgraph:sql:edfiadmin:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_Admin_$instanceId;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:edfisecurity:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_Security_$instanceId;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:edfimaster:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=master;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:edfibulk:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_Bulk_$instanceId;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:password" = "MIIBzwYJKoZIhvcNAQcDoIIBwDCCAbwCAQAxggFXMIIBUwIBADA7MCcxJTAjBgNVBAMMHGRhdGFlbmNpcGhlcm1lbnQuZGV2LnNlcnZpY2UCEDrOfenbKMSTTkAZ8HonX84wDQYJKoZIhvcNAQEHMAAEggEAhfNCEkSccb5JLrmtp/WowyCUAiAZjo316fsAAx08bcQOZD3SFewPCEHkFA2f8oG93/9p6A8OpQymFLGJJ4ysh8h8byQx/kXRmQapbcsPOSh71o5hiOuUILhKWS/gQlOlNs+AXXYq/hCTL9M0ogEIIXSX9+YJVaHkBkC+z5L07YSPDuoVrx4mN0qN4Uqrj4mBCtVbZsclgstOX8MTDtaJ7iapqgOIHuS7ZqGOJRh5Ub1OyfF0pfZlNHYbNd/cOOHKXau/PT5AeMUzQSh6y1ycK30/JtHievTc+K+4WkBRx6tzWNIQ4xB6VP/tmkCBdL+6I8Aw/ntgDxGMGMJfLxtqyzBcBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBD+6b8iwLHZhkVvfWwsQZD4gDD3+rDqBIOQy6lEZQz0LHKcSnONsOKNjubi2QkONcSwk3vGKSK1DJqk0d5i6qBg9go=";
    "log:appinsights:instrumentationkey" = "661dd0bb-1e02-4d20-b0b1-058ae410242d"
};

#& "$PsScriptRoot\SF Instancing.ps1" -PublishPackage `
& "$PsScriptRoot\SF Instancing.ps1" `
                                    -CreateApplicationInstance  `
                                    -SfConnectionEndpoint "sf-eastus.edgraph.dev:19000" `
                                    -SfServerCertThumbprint "2A9B72F736BCECCD30A29763A6946C4D26E19835" `
                                    -AppTypeName "EdGraph.EdFi.Ods.AppType" `
                                    -AppTypeVersion "Core.2.6.0.0.20191010.1" `
                                    -AppName "fabric:/EdGraph.EdFi/v2.6/$instanceId" `
                                    -AppPkgPath "https://eginternaldevwestus.blob.core.windows.net/packages/EdGraph.EdFi.Ods.App/Core.2.6.0.0.20191010.1/EdGraph.EdFi.Ods.App-Core.2.6.0.0.20191010.1.sfpkg?st=2019-10-27T01%3A28%3A08Z&se=2019-10-28T01%3A28%3A08Z&sp=rl&sv=2018-03-28&sr=b&sig=hLXxila6ZpD1AA5jVrwS%2Fe9ASBZvCL1t7E%2FaLLEmm7I%3D" `
                                    -AppParameters $appParameters

Connect-ServiceFabricCluster -ConnectionEndpoint sf-eastus.edgraph.dev:19000 -AzureActiveDirectory -ServerCertThumbprint "2A9B72F736BCECCD30A29763A6946C4D26E19835"
Update-ServiceFabricService -Stateless -ServiceName "fabric:/EdGraph.EdFi/v2.6/$instanceId/WebApi" -PlacementConstraints "((type==backend) || (type==elastic))"
