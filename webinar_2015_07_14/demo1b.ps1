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
