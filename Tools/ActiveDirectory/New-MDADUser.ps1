#Simple script to create an AD user

$name = ''
$surname = ''
$displayName = "$name $surname"
$path = ',OU=Users,DC=example,DC=com'
$description = 'Example of creating a user'
$domain = 'example.com'
$samAcctName = ("$name.$surname").ToLower()
$upn =  "$samAcctName@$domain"


$password = Read-Host -Prompt 'Enter password' -AsSecureString 

$params = @{
    'Name' = $displayName;
    'GivenName' = $name;
    'surname' = $surname;
    'DisplayName' = $displayName;
    'Path' = $path;
    'Description' = $description;
    'UserPrincipalName' = $upn;
    'SamAccountName' = $samAcctName;
    'AccountPassword' = $Password;
    'ChangePasswordAtLogon' = $false;
    'Enabled' = $true
}


New-ADUser @params
