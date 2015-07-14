#---------------------------------------------------------
# Demo 4 : SyncVM - Service Group with Snapshots
#---------------------------------------------------------

$gcName = 'GlobalCenter1'

# Service Groups exists in the Global Center !
$gc = Connect-TintriServer -Server $gcName -Credential $cred

$srvgrp = Get-TintriServiceGroup -Name 'Dev*'
if(!$srvgrp){
    $srvgrp = New-TintriServiceGroup -Name 'Dev VMs'
}

# Add members to the service group (rule)
# Name rules are case sensitive !
New-TintriServiceGroupRule -ServiceGroup $srvgrp -VMNameMatches 'Dev-*' | Out-Null
$srvgrp = Get-TintriServiceGroup -ServiceGroup $srvgrp

# Use the Service Group to create a snapshot rule
$sSchedule = @{
    SnapshotScheduleType = 'Hourly'
    SnapshotConsistency = [Tintri.Windows.RA.WinApi.Types.SnapshotConsistency]::CRASH_CONSISTENT
    MinuteOnTheHour = 5
    MinutesBetweenSnapshots = 15
    RetentionHoursLocal = 2
}
$schedule = New-TintriVMSnapshotSchedule @sSchedule
Set-TintriVMSnapshotSchedule -ServiceGroup $srvgrp -SnapshotSchedule $schedule 

Disconnect-TintriServer -TintriServer $gc -Confirm:$false
