#-------------------------------------------------------------
# Demo 3 : QoS - IOPS numbers vSphere/VMStore one VM over time
#-------------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'
$vmName = 'perfVM2'

$startDate = (Get-Date).AddDays(-1)
$stats = 'datastore.numberReadAveraged.average','datastore.numberWriteAveraged.average'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null
# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

Get-TintriVM -Name $vmName | %{
    $vm = Get-VM -Id "VirtualMachine-$($_.VMware.Mor)" -ErrorAction SilentlyContinue
    $vStats = Get-Stat -Entity $vm -Stat $stats -Start $startDate -IntervalMins 10
    $tStats = Get-TintriVMStat -VM $_ -IncludeHistoricStats | where TimeStart -ge $startDate
}

Disconnect-TintriServer -All
Disconnect-VIServer -Server $vcenterName -Confirm:$false
