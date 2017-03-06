<#
.Synopsis
   Stops the New Relic Server Agent Service
.DESCRIPTION
   Long description
.EXAMPLE
   Stop-NewRelicServerAgentService -ComputerName 'localhost'
   Stops the NewRelicServerAgentService on the local computer
.EXAMPLE
   Stop-NewRelicServerAgentService -ComputerName 'server1','server2'
   Stops the NewRelicServerAgentService on the computers call server1 and server2
#>
function Stop-NewRelicServerAgentService
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String[]]           
        $ComputerName
    )

    Process
    {
      foreach ($computer in $ComputerName)
      {
        Get-Service -Name nrsrvmon -ComputerName $computer | Stop-Service -Force
      }
    }#process
}
