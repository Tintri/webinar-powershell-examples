T# The MIT License (MIT)
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
# Demo 1 : Basics - Cloning
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'

$sourceVMName = 'luc01'
$folderName = 'Luc Demos'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null

# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

# Clone VM via vCenter
$sourceVM = Get-VM -Name $sourceVMName
$newName = 'luc02'
$vm02 = New-VM -Name $newName -VM $sourceVM -Datastore $storeName -VMHost $sourceVM.VMHost -Location $folderName -Notes $newName

#clone VM on Tintri datastore
$tStore = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

$tSourceVM = Get-tintriVM -Name $sourceVMName -TintriServer $tStore
$newName = 'luc03'  
$hr = Get-TintriVM -VM $tSourceVM | Get-TintriVirtualHostResource -FilterByPreferredOnly
$task = New-TintriVMClone -SourceVMName $sourceVMName -NewVMCloneName $newName -VMHostResource $hr
while($task.State -eq "Running"){
   $task = Get-TintriTaskStatus -TintriTask $task
   sleep 1
}

Disconnect-VIServer -Server $vcenterName -Confirm:$false
Disconnect-TintriServer -TintriServer $tsrv -Confirm:$false
