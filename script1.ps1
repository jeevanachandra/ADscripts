$IP = Read-Host -Prompt "Input IP-Address:"
$MaskBits = 16 # This means subnet mask = 255.255.255.0
$Gateway = Read-Host -Prompt "Input Gateway Address:"
$Dns = Read-Host -Prompt "Input DNS:8.8.8.8,4.4.4.4"
$IPType = "IPv4"
# Retrieve the network adapter that you want to configure
$adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
# Remove any existing IP, gateway from our ipv4 adapter
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
 $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}
If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}
 # Configure the IP address and default gateway
$adapter | New-NetIPAddress `
 -AddressFamily $IPType `
 -IPAddress $IP `
 -PrefixLength $MaskBits `
 -DefaultGateway $Gateway
# Configure the DNS client server IP addresses
$adapter | Set-DnsClientServerAddress -ServerAddresses $DNS
#$ErrorActionPreference='Silentlycontinue'
$value = HOSTNAME.exe
$NewHostName = Read-Host -Prompt "Input new HOSTNAME"
if ($value -eq $NewHostName)
{
  Write-Output "valid HOSTNAME not changing the HOSTNAME"
}
else
{
 Write-Output "Invalid HOSTNAME changing the HOSTNAME now!"
 Write-Host "Press ctrl+c, to stop changing the HOSTNAME"
 Start-Sleep -Seconds 25
 Rename-Computer -NewName "$NewHostName" -Restart
}
