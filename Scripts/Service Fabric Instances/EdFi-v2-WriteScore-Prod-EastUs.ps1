$sqlServerName = 'ws-edgraph-sql-prod-eastus.database.windows.net'
$sqlUsername = 'wsedgraphsqlprod'
$instanceId = '00000000-0000-0000-0000-000000000260'

$appParameters = @{
    "app:secretcert" = "857EA5F4BB71949DE6011DD7817039DDF0E5D0CF";
    "app:edgraph:api:descriptorNamespacePrefix" = "http://ed-fi.org";
    "app:edgraph:api:bearerTokenTimeoutMinutes" = "30";
    "app:edgraph:sql:edfiods:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_{0};User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=180;MultipleActiveResultSets=True;Max Pool Size=200;Persist Security Info=True;";
    "app:edgraph:sql:edfiodsbulk:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_{0};User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=180;MultipleActiveResultSets=True;Max Pool Size=200;Persist Security Info=True;";
    "app:edgraph:sql:edfiadmin:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_Admin_$instanceId;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:edfisecurity:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_Security_$instanceId;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:edfimaster:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=master;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:edfibulk:connection" = "Data Source=tcp:$sqlServerName,1433;Initial Catalog=EdFi_Bulk_$instanceId;User Id=$sqlUsername;Password={password};Application Name=EdGraph.Connectors.EdFi.Api;Integrated Security=false;Encrypt=yes;Connection Timeout=30;MultipleActiveResultSets=True;Max Pool Size=200";
    "app:edgraph:sql:password" = "MIIB0wYJKoZIhvcNAQcDoIIBxDCCAcACAQAxggFbMIIBVwIBADA/MCsxKTAnBgNVBAMMIGRhdGFlbmNpcGhlcm1lbnQucHJvZC5zZXJ2aWNlLndzAhAUEWBdH+lMvE6TcUnQxBFeMA0GCSqGSIb3DQEBBzAABIIBAATWS0oyTeGDuduhIDSmFs0kcV/RGY47GVdt56mXr1coV2TzLxrZkugyPPYxHl/3RwWdvb7s758pWWjy9yFyQS9GBBalYrSA6EF+Gljq39UVPcKauvDgkbW4PXr3pnLOthWgOCP7AekyFVanyVXrDOPUIsPbvNhp6nyEykXvNFnSWhpyc0N9IDKzqWlU7JfRprTcTWrf36nyyK9c+MMtHWbchE97PWv+OLHmTpKm85mwUew7C86YtrzkWG1mgP0eDUnsDc98j61JVNRoVTwcCMEqL1XR6t8uPlPBjWs5+8PwOec+wxxpuNyCuqYsd2tt6Bpz1VL8SKvyazy6QMyx02AwXAYJKoZIhvcNAQcBMB0GCWCGSAFlAwQBKgQQHBexqTXQp5r0ZDhi7UORKYAwBvdzOKxNYEMTvixuluG/Zyk13nEBrnqgM07JzXbHUEafxP1axXKWAjqI0yy9k/6e";
    "log:appinsights:instrumentationkey" = ""
};

#& "$PsScriptRoot\SF Instancing.ps1" `
& "$PsScriptRoot\SF Instancing.ps1" -PublishPackage `
                                    -CreateApplicationInstance  `
                                    -SfConnectionEndpoint "sf-eastus.writescore.com:19000" `
                                    -SfServerCertThumbprint "58F2B0C0A093F7AF91003942AA64E081EEE55893" `
                                    -AppTypeName "EdGraph.EdFi.Ods.AppType" `
                                    -AppTypeVersion "Core.2.6.0.0.20191010.1" `
                                    -AppName "fabric:/EdGraph.EdFi/v2.6/$instanceId" `
                                    -AppPkgPath "https://eginternaldevwestus.blob.core.windows.net/packages/EdGraph.EdFi.Ods.App/Core.2.6.0.0.20191010.1/EdGraph.EdFi.Ods.App-Core.2.6.0.0.20191010.1.sfpkg?st=2019-10-27T01%3A28%3A08Z&se=2019-10-28T01%3A28%3A08Z&sp=rl&sv=2018-03-28&sr=b&sig=hLXxila6ZpD1AA5jVrwS%2Fe9ASBZvCL1t7E%2FaLLEmm7I%3D" `
                                    -AppParameters $appParameters

#Connect-ServiceFabricCluster -ConnectionEndpoint sf-eastus.writescore.com:19000 -AzureActiveDirectory -ServerCertThumbprint "58F2B0C0A093F7AF91003942AA64E081EEE55893"
#Update-ServiceFabricService -Stateless -ServiceName "fabric:/EdGraph.EdFi/v2.6/$instanceId/WebApi" -PlacementConstraints "((type==backend) || (type==elastic))"
