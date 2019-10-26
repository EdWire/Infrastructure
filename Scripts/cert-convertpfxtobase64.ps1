$fileContentBytes = get-content 'D:\EdWire\Certificates\Prod\wildcard.edgraph.com.pfx' -Encoding Byte

[System.Convert]::ToBase64String($fileContentBytes) | Out-File 'D:\EdWire\Certificates\Prod\wildcard.edgraph.com.txt'