$majorVersion = $Host.Version.Major.ToString()
$minorVersion = $Host.Version.Minor.ToString()
$version = "$majorVersion.$minorVersion"

#module Imports
Import-Module azureext
Import-Module AWSPowerShell

#aliases
New-Alias -Name sub -Value Select-AzureRmSubscription
New-Alias -Name add -Value Add-AzureRmAccount

# add alias to find accelerators
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")
$TAType::Add('accelerators', $TAType) 
# [accelerators]::Get

Set-Location -Path C:\git
Write-Output "PowerShell version" $version 
Get-Date

$Host.PrivateData.ErrorForegroundColor = 'Cyan'
Set-PSReadlineKeyHandler -Key Tab -Function Complete

function Prompt {
  $location = Get-Location
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity

  if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $Host.UI.RawUI.WindowTitle = "[ADMIN]: " + $location
  }
  else {
    $Host.UI.RawUI.WindowTitle = $location
  }

  if ($env:ConEmuANSI -eq "ON") {
    "PS >"
  }
  else {
    $env:username + " :: " + (Get-Date -format t) + "> " 
  }
}#prompt


			

              



