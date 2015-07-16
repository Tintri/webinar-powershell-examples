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
