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
