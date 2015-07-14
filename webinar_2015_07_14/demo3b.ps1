#---------------------------------------------------------
# Demo 3 : QoS - Lower IOPS on a single VM
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'
$vmName = 'perfVM1'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null

# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

# Get IOPS figures per VM
Get-TintriVM -Name $vmName |
Select @{N='Name';E={$_.Vmware.Name}},
    @{N='IOPS';E={Get-TintriVMStat -VM $_ | %{$_.OperationsReadIops + $_.OperationsWriteIops}}} |
Format-Table -AutoSize

# QoS - Lower max IOPS to 75% of what the VM currently is consuming
Get-TintriVM -Name $vmName | %{
    $iops = Get-TintriVMStat -VM $_ | %{$_.OperationsReadIops + $_.OperationsWriteIops}
    Set-TintriVMQos -VM $_ -MaxNormalizedIops ($iops * 0.75)
}

# Reset QoS
Get-TintriVM -Name $vmName | 
Set-TintriVMQos -ClearMaxNormalizedIops

# Disconnect
Disconnect-TintriServer -TintriServer $tsrv -Confirm:$false
Disconnect-VIServer -Server $vcenterName -Confirm:$false
