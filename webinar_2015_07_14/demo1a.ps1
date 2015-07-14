#---------------------------------------------------------
# Demo 1 : Basics - Connecting & Integration with PowerCLI
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'

$vmName = 'luc01'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null

# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

# PowerCLI -> Tintri
Get-VM -Name $vmName | Get-TintriVM

# Tintri -> PowerCLI
$tvm = Get-TintriVM -Name $vmName

# Easy way
Get-VM -Name $tvm.Vmware.Name

# Always correct way
Get-VM -Id "VirtualMachine-$($tvm.Vmware.Mor)"


Disconnect-VIServer -Server $vcenterName -Confirm:$false
Disconnect-TintriServer -TintriServer $tsrv -Confirm:$false
