<#
.Synopsis
   Start the New Relic Server Agent Service
.DESCRIPTION
   Starts the New Relic Server Agent Service on a target computer(s)
.EXAMPLE
   Start-NewRelicServerAgentService -ComputerName 'localhost'
   Starts the NewRelicServerAgentService on the local computer
.EXAMPLE
   Start-NewRelicServerAgentService -ComputerName 'server1','server2'
   Starts the NewRelicServerAgentService on the computers call server1 and server2
#>
function Start-NewRelicServerAgentService
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
          Get-Service -Name nrsrvmon -ComputerName $computer | Start-Service 
      }
    }#process
}