#---------------------------------------------------------
# Demo : Support - Credentials
#---------------------------------------------------------

#region Credentials
$user = 'user'
$pswd = 'password'
#endregion

$passCred = $pswd | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user,$passCred
