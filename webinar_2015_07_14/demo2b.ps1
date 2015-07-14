#---------------------------------------------------------
# Demo 2 : Service Groups - Creation & Snapshots
#---------------------------------------------------------

$gcName = 'GlobalCenter1'

# If PS autoloading is not active
$tintriModule = 'TintriPSToolkit'
Try{
    Get-Module -Name $tintriModule -ErrorAction Stop | Out-Null
}
Catch{
    Import-Module -Name $tintriModule | Out-Null
}

# Disconnect all open servers
if($global:TintriServers.TintriServers.Count -ne 0){
    Disconnect-TintriServer -All -Confirm:$false -ErrorAction SilentlyContinue
}

# Service Groups exists in the Global Center !
$gc = Connect-TintriServer -Server $gcName -Credential $cred

$srvgrp = Get-TintriServiceGroup -Name 'luc*'
if(!$srvgrp){
    $srvgrp = New-TintriServiceGroup -Name 'luc srvgrp1'
}

# Add members to the service group (rule)
# Name rules are case sensitive !
New-TintriServiceGroupRule -ServiceGroup $srvgrp -VMNameMatches 'Demo2*' | Out-Null
$srvgrp = Get-TintriServiceGroup -ServiceGroup $srvgrp

# Members are dynamic
Get-TintriVM -ServiceGroup $srvgrp | Select @{N='Name';E={$_.VMware.Name}}

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
