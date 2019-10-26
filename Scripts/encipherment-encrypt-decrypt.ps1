function Get-EncryptedValue($rawValue, $dataEnciphermentThumbprint) {

    Write-Output "Get-EncryptedValue - Start"

    $encryptedValue = Invoke-ServiceFabricEncryptText -CertStore -CertThumbprint $dataEnciphermentThumbprint -Text $rawValue -StoreLocation LocalMachine -StoreName My

    return $encryptedValue

    Write-Output "Get-EncryptedValue - End"
}

function Get-DecryptedValue($encryptedValue) {

    Write-Output "Get-DecryptedValue - Start"

    $decryptedValue = Invoke-ServiceFabricDecryptText -CipherText $encryptedValue -StoreLocation LocalMachine

    return $decryptedValue

    Write-Output "Get-DecryptedValue - End"
}

# Thumbprint of certificate to use to encrypt
$dataEnciphermentThumbprint = "329A3F8BD5D09FB85FAF70BE164DD8FAB7255CFA"

# Database Value to Encrypt
$value = ''

# SQL Server Administrator Password
$encryptedValue = Invoke-ServiceFabricEncryptText -CertStore -CertThumbprint $dataEnciphermentThumbprint -Text $value -StoreLocation LocalMachine -StoreName My

$decryptedValue = Invoke-ServiceFabricDecryptText -CipherText $encryptedValue -StoreLocation LocalMachine


Write-Output $encryptedValue
Write-Output $decryptedValue
