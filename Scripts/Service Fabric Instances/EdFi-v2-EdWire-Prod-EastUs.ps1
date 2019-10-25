# cd D:\EdWire\Git\EW.Infrastructure\Scripts\SF Instancing

$sqlServerName = 'eg-sql-prod-eastus.database.windows.net'
$sqlUsername = 'egsqlprod'
$instanceId = '00000000-0000-0000-0000-000000000000'

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
    "app:edgraph:sql:password" = "MIIB0AYJKoZIhvcNAQcDoIIBwTCCAb0CAQAxggFYMIIBVAIBADA8MCgxJjAkBgNVBAMMHWRhdGFlbmNpcGhlcm1lbnQucHJvZC5zZXJ2aWNlAhAbfxP4NaLrj0sIQtmnYOdhMA0GCSqGSIb3DQEBBzAABIIBAKdJ9iMuF+/jCThbXW6GWpwr0tIrzyHFU6SrDRzTMM14caFRh/xR4PstKJbrgF9Qd3KGJL7DRQKs359zpsOXH1tzZdHkCC4AV/0ebvye8pcHhYGbx1AT/Xd91RI8GGSv2pHCGK9KMBHUeDvimF9pRwXhpVwqn7hw54ft+emEVRMLUBS4eBTWnO+1OLxAlzG5eoqYwWUxfbKsbRDt9+ZlEnbOQOIPyVYwigf9K9+JLQTDxpmkBdCntnNis+0mWzL0VWyXvJwVGTQB/w5W5dZkxrCCkwcEXpcK7hU4HWsGa25/7DQYWowKF+A0fyZjG0OrXX5jtuJP+SZz6w6ofkRrPjcwXAYJKoZIhvcNAQcBMB0GCWCGSAFlAwQBKgQQ9PNNISOmj79iQxDL2Bkx74AwtDyToaqKPLyV8jzkTFMITbId9dXSmjIDmLAQhrjgEX/00SQpOiNPeicd+D3XqvWh";
    "log:appinsights:instrumentationkey" = "ea3985df-0811-4963-b1d8-d821bf5af5fd"
};

& '.\SF Instancing.ps1' -PublishPackage `
                        -CreateApplicationInstance  `
                        -SfConnectionEndpoint "sf-eastus.edgraph.com:19000" `
                        -SfServerCertThumbprint "C7D1BE1C290B44FC0094EF1FC4D5080A117C1035" `
                        -AppTypeName "EdGraph.EdFi.Ods.AppType" `
                        -AppTypeVersion "Core.2.6.0.0.20191010.1" `
                        -AppName "fabric:/EdGraph.EdFi/v2.6/$instanceId" `
                        -AppPkgPath "https://eginternaldevwestus.blob.core.windows.net/packages/EdGraph.EdFi.Ods.App/Core.2.6.0.0.20191010.1/EdGraph.EdFi.Ods.App-Core.2.6.0.0.20191010.1.sfpkg?st=2019-10-19T17%3A59%3A00Z&se=2019-10-20T17%3A59%3A00Z&sp=rl&sv=2018-03-28&sr=b&sig=sKlWVciP6pmJ8dymbPWS6BpOw5mNpJv4bXtzPZG7YEM%3D" `
                        -AppParameters $appParameters
