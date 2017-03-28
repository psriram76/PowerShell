cd C:\
Get-Date
Import-Module azureext
function pro {notepad $profile.CurrentUserAllHosts}

function prompt 
           {
              "PS " + $env:username + "~" + (Get-Date -format t) + " " + (get-location) + "> "
           }

New-Alias -Name sub -Value Select-AzureRmSubscription
New-Alias -Name add -Value Add-AzureRmAccount