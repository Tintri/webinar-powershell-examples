# The MIT License (MIT)
#
# Copyright (c) 2015 Tintri, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
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
