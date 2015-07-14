#---------------------------------------------------------
# Demo 4 : SyncVM - SyncVM service group
#---------------------------------------------------------

$gcName = 'GlobalCenter1'

# Service Groups exists in the Global Center !
$gc = Connect-TintriServer -Server $gcName -Credential $cred
$srvgrp = Get-TintriServiceGroup -Name 'Dev*'

# Get the members of the Service Group
$devVM = Get-TintriVM -ServiceGroup $srvgrp

# Use the VM to do the SyncVM
$devVM | %{
    # Get snapshots on VMStore
    $tSrvName = $_.VMStoreName
    $tSrvConnect = Connect-TintriServer -Server $tSrvName -Credential $cred -SetDefaultServer:$false

    # Get the VM on the VMStore
    $vmOnStore = Get-TintriVM -TintriServer $tSrvConnect -Name $_.VMware.Name
    
    # Get the snapshot
    $snap = Get-TintriVMSnapshot -VM $vmOnStore

    # Recycle the VM to the snapshot
    Sync-TintriVDisk -VM $_ -SourceSnapshot $snap -AllButFirstVDisk -Force

    # Drop the VMStore connection
    Disconnect-TintriServer -TintriServer $tSrvConnect
}


Disconnect-TintriServer -TintriServer $gc -Confirm:$false
