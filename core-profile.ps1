Import-Module AWSPowerShell.NetCore
Set-DefaultAWSRegion -Region eu-west-1

Set-Alias -Name c -Value Clear-Host

function prompt
{
   "PS" + " " + (Get-Date -format t) + "> "
     $Host.UI.RawUI.WindowTitle = Get-Location
}
