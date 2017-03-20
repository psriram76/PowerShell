function Get-TMMachineInfo {
    
    [string[]]
    $ComputerName,
    [string]
    $LogFailuresToPath,
    [string]
    $Protocol,
    [switch]
    $ProtocolFallback

    foreach($computer in $ComputerName){
        #Establish session protocol 
        if($Protocol -eq 'DCOM'){
            $option = New-CimSessionOption -Protocol Dcom  
        } else {
            $option = New-CimSessionOption -Protocol Wsman     
        }
        #connect session
        $session = New-CimSession -ComputerName $computer -SessionOption $option

        # query data
        $os = Get-CimInstance -ClassName win32_OperatingSystem -CimSession $session

        #close session
        $session | Remove-CimSession

        # output data
        $os | Select-Object -Property @{n='ComputerName';e={$computer}},
                                        Version,ServicePackMajorVersion
    }#foreach
}#function