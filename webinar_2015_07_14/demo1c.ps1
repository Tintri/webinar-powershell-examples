#---------------------------------------------------------
# Demo 1 : Basics - Snapshot
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null

# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

# Classic snapshot
$vmName = 'luc01'
$vm = Get-VM -Name $vmName
New-Snapshot -VM $vm -Name 'Demo1' -Description 'Tintri Webinar Demo 1' -Memory:$false -Quiesce

# VMStore snapshot
# Manual
$vmName = 'luc02'
$vm = Get-TintriVM -Name $vmName
New-TintriVMSnapshot -VM $vm -SnapshotDescription 'Tintri Webinar Demo 1' -SnapshotConsistency VM_CONSISTENT

# Scheduled
$vmName = 'luc03'
$vm = Get-TintriVM -Name $vmName
$minute = (Get-Date).Minute + 1
$sSched = @{
    SnapshotScheduleType = 'Hourly'
    SnapshotConsistency = 'CRASH_CONSISTENT'
    RetentionHoursLocal = 3
    MinuteOnTheHour = $minute
}
$schedule = New-TintriVMSnapshotSchedule -SnapshotScheduleType Hourly -SnapshotConsistency CRASH_CONSISTENT -RetentionHoursLocal 3 -MinuteOnTheHour $minute
Set-TintriVMSnapshotSchedule -VM $vm -SnapshotSchedule $schedule


Disconnect-VIServer -Server $vcenterName -Confirm:$false
Disconnect-TintriServer -TintriServer $tsrv -Confirm:$false
