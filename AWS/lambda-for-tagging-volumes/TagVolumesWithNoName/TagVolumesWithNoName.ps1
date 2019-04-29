<#
.SYNOPSIS
    The purpose of this script is to tag any EC2 Volumes without a Name tag in AWS
.DESCRIPTION
    The script is run via a lambda in AWS and checks for all volumes that do not have a name tag.
    If a volume is found not to have a name tag, the name of the EC2 instance is used to create the volume tag.
    If the EC2 instance does not have a name tag, then use the instance id value as the name.
    The new tag is applied to the volume
.EXAMPLE
    Runs as an AWS Lambda
    https://docs.aws.amazon.com/lambda/latest/dg/powershell-programming-model.html
#>
#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.485.0'}

$VolumeList = Get-EC2Volume

# Get the volumes that do not have a name tag and add them to a list
$NoNameTagVolumeList = New-Object 'collections.generic.list[object]'

$VolumeList | ForEach-Object {
    if (-not ($_.tag.Key -contains 'Name')) {
        $props = @{
            'InstanceId' = $_.Attachment.InstanceId
            'VolumeId' = $_.VolumeId
        }
        $NoNameTagVolumeList.Add($props)
    }
}

$NoNameTagVolumeList | ForEach-Object {
    # Get the instance name tag value
    $TagValue = ((Get-EC2Instance -InstanceId $_.InstanceId).Instances.tag | Where-Object -Property 'Key' -eq 'Name').value

    # If the instance does not have a name tag, tag with the instance id
    if($null -eq $TagValue){
        $TagValue = $_.InstanceId
    }

    # Create the name tag for the volume
    $tag = New-Object Amazon.EC2.Model.Tag
    $tag.Key = "Name"
    $tag.Value = "$TagValue-Volume"
    # Apply tag to volume
    New-EC2Tag -Resource $_.VolumeId -Tag $tag
}
