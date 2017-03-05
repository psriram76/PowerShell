function Get-MDComputerInfo
{
    Param(
        [Parameter(Mandatory)]
        [String]
        $ComputerName
    )
    # Parameter help description
    
    if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet)
    {
        throw "The computer $_ could not be reached"
    } else {
        $true
    }

   # $cimSession = New-CimSession -ComputerName $ComputerName

  #  Get-CimInstance -ClassName CIM_OperatingSystem | Select-Object -Property Name, Description
}
