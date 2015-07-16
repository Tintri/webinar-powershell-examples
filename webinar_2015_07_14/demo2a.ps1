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
# Demo 2 : Service Groups - Create demo VMs
#---------------------------------------------------------

$vcenterName = 'vCenter'
$storeName = 'VMStore1'

$vmName = 'luc01'
$folderName = 'Luc Demos'

# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

# Mass clone VMs on Tintri datastore
$vm = Get-TintriVM -Name $vmName
$hr = Get-TintriVM -VM $vm | Get-TintriVirtualHostResource -FilterByPreferredOnly
 
$nameSplat = @{
   PrefixText = "Demo2"
   DigitStartValue = 1
   DigitPlaceHolderCount = 2
   VMCount = 3
   IncrementStepValue = 1
}
 
$tnSeq = New-TintriVMNameSequence @nameSplat
 
$cloneSplat = @{
   SourceVMName = $vmName
   VMNameSequence = $tnSeq
   VMHostResource = $hr
   CloneCount = 3
}
 
$task = New-TintriVMCloneMany @cloneSplat

while($task | where State -eq "Running"){
   $task = $task | %{Get-TintriTaskStatus -TintriTask $_}
   sleep 1
}

Disconnect-TintriServer -TintriServer $tsrv -Confirm:$false
