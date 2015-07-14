#---------------------------------------------------------
# Demo 4 : SyncVM - Clone a number of VMs
#---------------------------------------------------------

$storeName = 'VMStore1'

$vmName = 'luc01'
$folderName = 'Luc Demos'

# Tintri VMStore
$tsrv = Connect-TintriServer -Server $storeName -Credential $cred -SetDefaultServer

# Mass clone VMs on Tintri datastore
$vm = Get-TintriVM -Name $vmName
$hr = Get-TintriVM -VM $vm | Get-TintriVirtualHostResource -FilterByPreferredOnly
 
$nameSplat = @{
   PrefixText = "Dev"
   DigitStartValue = 1
   DigitPlaceHolderCount = 2
   VMCount = 4
   IncrementStepValue = 1
}
 
$tnSeq = New-TintriVMNameSequence @nameSplat
 
$cloneSplat = @{
   SourceVMName = $vmName
   VMNameSequence = $tnSeq
   VMHostResource = $hr
   CloneCount = 4
}
 
$task = New-TintriVMCloneMany @cloneSplat

while($task | where State -eq "Running"){
   $task = $task | %{Get-TintriTaskStatus -TintriTask $_}
   sleep 1
}

Disconnect-TintriServer -TintriServer $tsrv -Confirm:$false
