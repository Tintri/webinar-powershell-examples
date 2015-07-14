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
