#---------------------------------------------------------
# Demo 4 : SyncVM - 3 flavours
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null

# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

# Get the snapshot
$vmName = 'luc02'
$vm = Get-TintriVM -Name $vmName
$snap = Get-TintriVMSnapshot -VM $vm | where Description -match 'SyncVM Demo'
$disks = Get-TintriVDisk -Snapshot $snap

# Sync the VM
Sync-TintriVDisk -VM $vm -SourceSnapshot $snap -AllButFirstVDisk

Sync-TintriVDisk -VM $vm -SourceSnapshot $snap -VDiskMap @($null,$disks[1])

Sync-TintriVDisk -VM $vm -SourceSnapshot $snap -VDiskRange '1' -Force


Disconnect-VIServer -Server $vcenterName -Confirm:$false
Disconnect-TintriServer -TintriServer $tsrv -Confirm:$false
