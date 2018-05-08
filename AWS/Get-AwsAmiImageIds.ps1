#Get the latest Windows AMIs for a specified region

#Region options here
$region = 'eu-west-1'

Set-DefaultAWSRegion -Region $region

# array list to hold images
$ec2Images = @()

# EC2 image object

Write-Output $ec2Image

$images = Get-EC2ImageByName | Where-Object {$_ -like "WINDOWS_2016*"} 

foreach($image in $images){
  $imageDetails = Get-EC2ImageByName -Name $image

  
  $ec2Image = New-Object -TypeName psobject
  $ec2Image | Add-Member -MemberType NoteProperty -Name ImageName -Value $imageDetails.name 
  $ec2Image | Add-Member -MemberType NoteProperty -Name AmiID -Value $imageDetails.imageid 
  $ec2Image | Add-Member -MemberType NoteProperty -Name Region -Value $region

  $ec2Images += $ec2Image
}

Write-Output $ec2Images