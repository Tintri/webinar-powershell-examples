#---------------------------------------------------------
# Demo 3 : QoS - Generating some load
#---------------------------------------------------------

$vcenterName = 'vCenter'
$vmName = 'Demo2-*'
$user = 'user'
$pswd = 'password'

# vCenter
Connect-VIServer -Server $vcenterName -Credential $cred | Out-Null

$vm = Get-VM -Name $vmName

$cmd = @"
nohup /usr/local/bin/dperf --range 50g --statInterval 2 --loop --compression 4 --dupePercent 50 --work b-1k-20 --readPercent 50 /dev/sdb &
"@

Invoke-VMScript -VM $vm -ScriptType Bash -ScriptText $cmd -GuestUser $user -GuestPassword $pswd |
Select -ExpandProperty ScriptOutput

Disconnect-VIServer -Server $vcenterName -Confirm:$false
