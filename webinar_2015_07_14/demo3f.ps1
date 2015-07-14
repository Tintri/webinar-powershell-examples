#---------------------------------------------------------
# Demo 3 : QoS - IOPS numbers vSphere/VMStore all VM
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null
# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

Get-TintriVM | %{
    $vm = Get-VM -Id "VirtualMachine-$($_.VMware.Mor)" -ErrorAction SilentlyContinue
    $vIOPS = 0
    if($vm){
        $stats = 'datastore.numberReadAveraged.average','datastore.numberWriteAveraged.average'
        $vIOPS = Get-Stat -Entity $vm -Stat $stats -Realtime -MaxSamples 1 -ErrorAction SilentlyContinue | 
            Measure-Object -Property Value -Sum | Select -ExpandProperty Sum
    }

    $tStats = Get-TintriVMStat -VM $_ -IncludeRealtimeStats  
    $tIOPS = $tStats.OperationsReadIops + $tStats.OperationsWriteIops
    $_ | Select @{N='Name';E={$_.VMware.Name}},
        @{N='vSphere IOPS';E={$vIOPS}},
        @{N='VMStore IOPS';E={$tIOPS}}
}

Disconnect-TintriServer -All
Disconnect-VIServer -Server $vcenterName -Confirm:$false
