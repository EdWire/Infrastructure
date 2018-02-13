#
# sf-vmscaleset-extension.ps1
#

# install chocolatey
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1

# install java
choco install -y -force javaruntime