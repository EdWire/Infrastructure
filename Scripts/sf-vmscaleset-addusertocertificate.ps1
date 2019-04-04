param(
    [string]$userName = "Network Service",
    [string]$permission = "full",
    [string]$certStoreLocation = "\LocalMachine\My",
    [string]$certThumbprint = "51CEBE8EFD2BF6AC2227A7AD49E77E47DCF78441"
);
# check if certificate is already installed
$certificateInstalled = Get-ChildItem cert:$certStoreLocation | Where thumbprint -eq $certThumbprint

# download & install only if certificate is not already installed on machine
if ($certificateInstalled -eq $null)
{
    $message="Certificate with thumbprint:"+$certThumbprint+" does not exist at "+$certStoreLocation
    Write-Host $message -ForegroundColor Red
    exit 1;
}else
{
    try
    {
        $rule = new-object security.accesscontrol.filesystemaccessrule $userName, $permission, allow
        $root = "c:\programdata\microsoft\crypto\rsa\machinekeys"
        $l = ls Cert:$certStoreLocation
        $l = $l |? {$_.thumbprint -like $certThumbprint}
        $l |%{
            $keyname = $_.privatekey.cspkeycontainerinfo.uniquekeycontainername
            $p = [io.path]::combine($root, $keyname)
            if ([io.file]::exists($p))
            {
                $acl = get-acl -path $p
                $acl.addaccessrule($rule)
                echo $p
                set-acl $p $acl
            }
        }
    }
    catch 
    {
        Write-Host "Caught an exception:" -ForegroundColor Red
        Write-Host "$($_.Exception)" -ForegroundColor Red
        exit 1;
    }    
}

exit $LASTEXITCODE
