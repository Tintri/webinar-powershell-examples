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
