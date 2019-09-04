#Needs New-MDADUser imported from my AD tools module

$UserList = Import-Csv -Path .\users.csv

$UserListSecure = foreach($user in $UserList){
    [pscustomobject]@{
        FirstName = $user.firstname
        Surname = $user.surname
        Password = ConvertTo-SecureString -String $user.Password -AsPlainText -Force
    }
}

foreach($user in $UserListSecure){
    New-MDADUser -FirstName $user.firstname -Surname $user.surname -Password $user.password
}

<#
Example csv

firstname,surname,password
will,smith,agjl23821jkfd&32£
keith,richards,fjdasa*£421ds234324
#>
