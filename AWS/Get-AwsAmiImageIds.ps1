<#
.SYNOPSIS
  Get the latest AWS Windows AMIs for a specified region
.DESCRIPTION
  Returns an arrays of custom objects with the details of the latest Windows server images for a specified AWS region.
  The default Windows server version is 2016. This can be changed via the WindowsVersion parameter
.EXAMPLE
  PS C:\> Get-AWSAmiImageIDs -Region eu-west-1

  ImageName    : Windows_Server-2016-English-Full-Base-2018.05.09
  AmiID        : ami-894c7bf0
  CreationDate : 2018-05-09T19:33:56.000Z
  Region       : eu-west-1
  DESCRIPTION  : Microsoft Windows Server 2016 with Desktop Experience Locale English AMI provided by Amazon

  ImageName    : Windows_Server-2016-English-Nano-Base-2018.04.11
  AmiID        : ami-310e2848
  CreationDate : 2018-04-17T00:08:36.000Z
  Region       : eu-west-1
  DESCRIPTION  : Microsoft Windows Server 2016 Nano Locale English AMI provided by Amazon

  Returns the latest ImageName, AmiID and Region for Windows Server 2016 in eu-west-1 region
.EXAMPLE
  PS C:\> Get-AWSAmiImageIDs -Region us-east-1 -WindowsVersion 2012R2

  ImageName    : Windows_Server-2012-R2_RTM-English-64Bit-Base-2018.05.09
  AmiID        : ami-2a9a1655
  CreationDate : 2018-05-09T10:11:49.000Z
  Region       : us-east-1
  DESCRIPTION  : Microsoft Windows Server 2012 R2 RTM 64-bit Locale English AMI provided by Amazon

  ImageName    : Windows_Server-2012-R2_RTM-English-64Bit-Core-2018.05.09
  AmiID        : ami-09800c76
  CreationDate : 2018-05-09T09:34:18.000Z
  Region       : us-east-1
  DESCRIPTION  : Microsoft Windows Server 2012 R2 RTM 64-bit Locale English Core AMI provided by Amazon

  Returns the latest ImageName, AmiID and Region for Windows Server 2012R2 in us-east-1 region
#>
function Get-AWSAmiImageIDs {
  [CmdletBinding()]
  #AWS Regions
  param (
    [ValidateSet("ap-northeast-1", "ap-northeast-2", "ap-south-1", "ap-southeast-1", "ap-southeast-2",
      "ca-central-1", "eu-central-1", "eu-west-1", "eu-west-2", "sa-east-1", "us-east-1", "us-east-2", "us-west-1", "us-west-2")]
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

      foreach ($image in $images) {
        $imageDetails = Get-EC2ImageByName -Name $image

        $ec2Image = New-Object -TypeName psobject
        $ec2Image | Add-Member -MemberType NoteProperty -Name ImageName -Value $imageDetails.name 
        $ec2Image | Add-Member -MemberType NoteProperty -Name AmiID -Value $imageDetails.imageid 
        $ec2Image | Add-Member -MemberType NoteProperty -Name CreationDate -Value $imageDetails.CreationDate
        $ec2Image | Add-Member -MemberType NoteProperty -Name Region -Value $Region
        $ec2Image | Add-Member -MemberType NoteProperty -Name DESCRIPTION -Value $imageDetails.Description

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