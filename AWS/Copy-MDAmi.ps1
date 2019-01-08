
function Copy-JEAmi {
  [CmdletBinding()]
  param (
    # Source AMI ID
    [Parameter(Mandatory=$true)]
    [string]
    $SourceAmiId,
    # Source Region
    [Parameter(Mandatory=$true)]
    [string]
    $SourceRegion,
    # Destination Region
    [Parameter(Mandatory=$true)]
    [string]
    $DestinationRegion,
    # Name of copied AMI
    [Parameter(Mandatory=$true)]
    [string]
    $AmiName,
    # Description of created AMI
    [Parameter(Mandatory=$true)]
    [string]
    $AmiDescription
    
  )
  
  begin {
    #Tag helper function
    Function New-MDEC2Tag ($Key, $Value) {
      $tag = New-Object -TypeName Amazon.EC2.Model.Tag
      $tag.Key = $key 
      $tag.Value = $value
  
      return $tag
    }
  }
  
  process {
    $NewAmi = Copy-EC2Image -SourceImageId $SourceAmiId -SourceRegion $SourceRegion -Name $AmiName -Region $DestinationRegion -Description $AmiDescription
    $tag = New-MDEC2Tag -key 'Name' -value $AmiName
    New-EC2Tag -Resource $NewAmi -Tag $tag
    Return $NewAmi
  }
  
  end {
    Remove-Variable NewAMi 
    Remove-Variable tag
  }
}









