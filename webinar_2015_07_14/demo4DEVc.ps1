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
# Demo 4 : SyncVM - SyncVM service group
#---------------------------------------------------------

$gcName = 'GlobalCenter1'

# Service Groups exists in the Global Center !
$gc = Connect-TintriServer -Server $gcName -Credential $cred
$srvgrp = Get-TintriServiceGroup -Name 'Dev*'

# Get the members of the Service Group
$devVM = Get-TintriVM -ServiceGroup $srvgrp

# Use the VM to do the SyncVM
$devVM | %{
    # Get snapshots on VMStore
    $tSrvName = $_.VMStoreName
    $tSrvConnect = Connect-TintriServer -Server $tSrvName -Credential $cred -SetDefaultServer:$false

    # Get the VM on the VMStore
    $vmOnStore = Get-TintriVM -TintriServer $tSrvConnect -Name $_.VMware.Name
    
    # Get the snapshot
    $snap = Get-TintriVMSnapshot -VM $vmOnStore

    # Recycle the VM to the snapshot
    Sync-TintriVDisk -VM $_ -SourceSnapshot $snap -AllButFirstVDisk -Force

    # Drop the VMStore connection
    Disconnect-TintriServer -TintriServer $tSrvConnect
}


Disconnect-TintriServer -TintriServer $gc -Confirm:$false
