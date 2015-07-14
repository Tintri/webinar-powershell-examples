#---------------------------------------------------------
# Demo 1 : Basics - Replication
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null

# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

# Check scheduled snapshots
$vmName = 'luc03'
$vm = Get-TintriVM -Name $vmName
Get-TintriVMSnapshotSchedule -VM $vm | where{$_.Type -eq 'HOURLY'}

# Set up the replication
$replicationStore = 'VMStore2'
$path = Get-TintriDatastore | Get-TintriDatastoreReplPath | where {$_.DisplayName -match "^$($replicationStore).*10"}
New-TintriVMReplConfiguration -VM $vm -DatastoreReplPath $path

# Check replication
Get-TintriVMReplConfiguration -VM $vm

Disconnect-VIServer -Server $vcenterName -Confirm:$false
Disconnect-TintriServer -TintriServer $tsrv -Confirm:$false
