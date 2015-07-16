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
