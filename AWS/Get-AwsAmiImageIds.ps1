#Get the latest Windows AMIs for a specified region

function Get-AWSAmiImageIDs {
  [CmdletBinding()]
  #AWS Regions
  param (
    [ValidateSet("ap-northeast-1","ap-northeast-2","ap-south-1","ap-southeast-1","ap-southeast-2",
    "ca-central-1","eu-central-1","eu-west-1","eu-west-2","sa-east-1","us-east-1","us-east-2","us-west-1","us-west-2")]
    [string]
    $Region = "eu-west-1"
  )
  begin {
    Set-DefaultAWSRegion -Region $Region

    # array list to hold images
    $ec2Images = @()
  }

  process {

    $images = Get-EC2ImageByName | Where-Object {$_ -like "WINDOWS_2016*"} 

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

  end {
  }
}