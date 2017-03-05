<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Install-NewRelicServerAgent
{
  [CmdletBinding()]
  [Alias()]
  [OutputType([int])]
  Param
  (
    # Param1 help description
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
    Position=0)]
    [String[]]           
    $ComputerName,
    [String]
    $DirectoryName = 'newrelic',
    [Parameter(Mandatroy=$true)]
    [String]
    $FileName,
    [String]
    $SoftwareDrive = '\\fileshare\software\newrelic'			

  )

  Begin
  {
    #test path
    New-PSDrive -Name software -Root $SoftwareDrive -PSProvider FileSystem
    
    #test for file
    
  }# begin
  Process
  {
    foreach ($computer in $ComputerName)
    {
      #install New-relic
      #If the new-relic folder doesn't exist, create a folder on the server at the root of the C drive
      New-NewRelicDirectory -ComputerName $computer 
        
        #Copy install file to the new-relic folder
        Copy-Item -Path software:$FileName -Destination \\$computer\c$\$DirectoryName 
        Start-Sleep -Seconds 10
        
        #Create a session and run the installer on the server via msiexec
        $session = New-PSSession -ComputerName $computer
        
        #stop IIS
        Invoke-Command -Session $session -ScriptBlock {iisreset /stop}
        Start-Sleep -Seconds 20

        #Remove existing .NET app
        $query = "Name LIKE 'New Relic .NET Agent (64-bit)'"
        Invoke-Command -Session $session -ScriptBlock {$app = Get-WmiObject -Class win32_product -Filter $query}
        Invoke-Command -Session $session -ScriptBlock {$app.uninstall()}
        Start-Sleep -Seconds 10
        
        #Install updated NewRelic Agent
        Invoke-Command -Session $session -ScriptBlock {msiexec.exe /i C:\$Using:Path\$Using:FileName /L*v install.log /qn NR_LICENSE_KEY=0fd3769cff89b798e56175b463e25b6865289852 INSTALLLEVEL=1}
        Start-Sleep -Seconds 30
        
        #Start IIS
        Invoke-Command -Session $session -ScriptBlock {iisreset /start}
        
        #Remove PowerShell session and the new relic folder and install file from the server.
        Remove-PSSession $session
        Remove-Item -Path \\$computer\c$\$DirectoryName -Recurse 
    }
      
  }# process
  End
  {
    Remove-PSDrive software
  }# 
}# function
