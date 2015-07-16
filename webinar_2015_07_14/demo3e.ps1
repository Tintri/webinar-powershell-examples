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
