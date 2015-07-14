#---------------------------------------------------------
# Demo 3 : QoS - IOPS numbers vSphere/VMStore
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'
$vmName = 'Demo2-01'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null
# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

$vm = Get-VM -Name $vmName
$tvm = Get-TintriVM -VM $vm
Set-TintriVMQos -VM $tvm -ClearMaxNormalizedIops

$stats = 'datastore.numberReadAveraged.average','datastore.numberWriteAveraged.average'

$i = 0
Write-Output "VM`t`t`tvSphere IOPS`tTintri IOPS"
while($true){
    $vIOPS = Get-Stat -Entity $vm -Stat $stats -Realtime -MaxSamples 1 | 
        Measure-Object -Property Value -Sum | Select -ExpandProperty Sum
    $tStats = Get-TintriVMStat -VM $tvm -IncludeRealtimeStats  
    $tIOPS = $tStats.OperationsReadIops + $tStats.OperationsWriteIops
    
    Write-Output "$($vm.Name)`t$($vIOPS)`t`t`t$($tIOPS)"
    $i++
    if($i -eq 5){
        Set-TintriVMQos -VM $tvm -MaxNormalizedIops 750
    }
}

Disconnect-VIServer -Server $vcenterName -Confirm:$false
