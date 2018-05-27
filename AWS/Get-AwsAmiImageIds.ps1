<#
.SYNOPSIS
  Get the latest AWS Windows AMIs for a specified region
.DESCRIPTION
  Returns an arrays of custom objects with the details of the latest Windows server images for a specified AWS region.
  The default Windows server version is 2016. This can be changed via the WindowsVersion parameter
.EXAMPLE
  PS C:\> Get-AWSAmiImageIDs -Region eu-west-1

  ImageName                                                       AmiID        Region
  ---------                                                       -----        ------
  Windows_Server-2016-English-Full-Base-2018.05.09                ami-894c7bf0 eu-west-1
  Windows_Server-2016-English-Nano-Base-2018.04.11                ami-310e2848 eu-west-1
  Windows_Server-2016-English-Core-Base-2018.05.09                ami-ebcafe92 eu-west-1
  Windows_Server-2016-English-Full-Containers-2018.05.09          ami-8d4c7bf4 eu-west-1
  Windows_Server-2016-English-Full-SQL_2016_Enterprise-2017.11.29 ami-a63e83df eu-west-1
  Windows_Server-2016-English-Full-SQL_2016_Standard-2017.11.29   ami-cf3c81b6 eu-west-1
  Windows_Server-2016-English-Full-SQL_2016_Web-2017.11.29        ami-dd3d80a4 eu-west-1
  Windows_Server-2016-English-Full-SQL_2016_Express-2017.11.29    ami-ab3e83d2 eu-west-1

  Returns the latest ImageName, AmiID and Region for Windows Server 2016 in eu-west-1 region
.EXAMPLE
  PS C:\> Get-AWSAmiImageIDs -Region us-east-1 -WindowsVersion 2012R2

  ImageName                                                                 AmiID        Region
  ---------                                                                 -----        ------
  Windows_Server-2012-R2_RTM-English-64Bit-Base-2018.05.09                  ami-2a9a1655 us-east-1
  Windows_Server-2012-R2_RTM-English-64Bit-Core-2018.05.09                  ami-09800c76 us-east-1
  Windows_Server-2012-R2_RTM-English-64Bit-SQL_2016_Express-2017.11.29      ami-a40699de us-east-1
  Windows_Server-2012-R2_RTM-English-64Bit-SQL_2016_Standard-2017.11.29     ami-1c029d66 us-east-1
  Windows_Server-2012-R2_RTM-English-64Bit-SQL_2016_Web-2017.11.29          ami-7b059a01 us-east-1
  Windows_Server-2012-R2_RTM-English-64Bit-SQL_2014_SP1_Express-2017.11.29  ami-3007984a us-east-1
  Windows_Server-2012-R2_RTM-English-64Bit-SQL_2014_SP1_Standard-2017.11.29 ami-a8039cd2 us-east-1
  Windows_Server-2012-R2_RTM-English-64Bit-SQL_2014_SP1_Web-2017.11.29      ami-38049b42 us-east-1

  Returns the latest ImageName, AmiID and Region for Windows Server 2012R2 in us-east-1 region
#>
function Get-AWSAmiImageIDs {
  [CmdletBinding()]
  #AWS Regions
  param (
    [ValidateSet("ap-northeast-1","ap-northeast-2","ap-south-1","ap-southeast-1","ap-southeast-2",
    "ca-central-1","eu-central-1","eu-west-1","eu-west-2","sa-east-1","us-east-1","us-east-2","us-west-1","us-west-2")]
    [string]
    $Region = "eu-west-1",

    #Windows Version
    [ValidateSet('2016', '2012R2', '2012', '2008R2')]
    [string]
    $WindowsVersion = '2016'
    )

  begin {
    Set-DefaultAWSRegion -Region $Region

    # array to hold images
    $ec2Images = @()
  }

  process {
    try {
        $images = Get-EC2ImageByName | Where-Object {$_ -like "WINDOWS_$WindowsVersion*"} 

        foreach($image in $images){
        $imageDetails = Get-EC2ImageByName -Name $image

        $ec2Image = New-Object -TypeName psobject
        $ec2Image | Add-Member -MemberType NoteProperty -Name ImageName -Value $imageDetails.name 
        $ec2Image | Add-Member -MemberType NoteProperty -Name AmiID -Value $imageDetails.imageid 
        $ec2Image | Add-Member -MemberType NoteProperty -Name Region -Value $Region

        $ec2Images += $ec2Image
      }

      Write-Output $ec2Images
    }
    catch {
      Write-Error $_
    }
  }

  end {
    Clear-DefaultAWSRegion
  }
} 