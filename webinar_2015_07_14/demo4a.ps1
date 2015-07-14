#---------------------------------------------------------
# Demo 4 : SyncVM - Create snapshot
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null

# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

# VMStore snapshot
$vmName = 'luc02'
$vm = Get-TintriVM -Name $vmName
New-TintriVMSnapshot -VM $vm -SnapshotDescription 'Tintri Webinar SyncVM Demo' -SnapshotConsistency VM_CONSISTENT

Disconnect-VIServer -Server $vcenterName -Confirm:$false
Disconnect-TintriServer -TintriServer $tsrv -Confirm:$false
