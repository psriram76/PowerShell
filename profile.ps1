$majorVersion = $Host.Version.Major.ToString()
$minorVersion = $Host.Version.Minor.ToString()
$version = "$majorVersion.$minorVersion"

#module Imports
Import-Module azureext
Import-Module AWSPowerShell

#aliases
New-Alias -Name sub -Value Select-AzureRmSubscription
New-Alias -Name add -Value Add-AzureRmAccount

Set-Location -Path C:\git
Write-Output "PowerShell version" $version 
Get-Date

function Prompt {
    $location = Get-Location
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity

    if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
         $Host.UI.RawUI.WindowTitle = "[ADMIN]: " + $location
    } else {
        $Host.UI.RawUI.WindowTitle = $location
    }
    "PS " + $env:username + "~" + (Get-Date -format t) + "> "
}#prompt


			

              



