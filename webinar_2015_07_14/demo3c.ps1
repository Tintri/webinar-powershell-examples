#---------------------------------------------------------
# Demo 3 : QoS - Set for Service Group
#---------------------------------------------------------

$gcName = 'GlobalCenter1'

# Service Groups exists in the Global Center !
$gc = Connect-TintriServer -Server $gcName -Credential $cred
$srvgrp = Get-TintriServiceGroup -Name 'luc*'

# Get the "live" members of the Service Group
$liveVM = Get-TintriVM -ServiceGroup $srvgrp | where IsLive

# Use the VM to set up QoS
$liveVM | %{
    # QoS is done on the VMStore
    $tSrvName = $_.VMStoreName
    $tSrvConnect = Connect-TintriServer -Server $tSrvName -Credential $cred -SetDefaultServer:$false

    # Get the VM on the VMStore
    $vmOnStore = Get-TintriVM -TintriServer $tSrvConnect -Name $_.VMware.Name

    # Set the Max IOPS 
    Set-TintriVMQos -VM $vmOnStore -MaxNormalizedIops 750

    # Drop the VMStore connection
    Disconnect-TintriServer -TintriServer $tSrvConnect
}


Disconnect-TintriServer -TintriServer $gc -Confirm:$false
