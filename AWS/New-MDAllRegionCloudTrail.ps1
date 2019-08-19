$AccountName = Get-IAMAccountAlias
$AccountNumber = (Get-STSCallerIdentity).account
$BucketName = "cloudtrail-$AccountNumber"
$CloudTrailName = 'matt-cloudtrail'
$CloudTrailName = 'matt-cloudtrail'

# create bucket for cloudtrail

$S3CloudTrailPolicy = @"
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::$BucketName"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::$BucketName/AWSLogs/$AccountNumber/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
"@


# Create S3 bucket
New-S3Bucket -BucketName $BucketName

Write-S3BucketPolicy -BucketName $BucketName -Policy $S3CloudTrailPolicy

$s3PublicParams = @{
    BucketName = $BucketName
    PublicAccessBlockConfiguration_BlockPublicAcl = $true
    PublicAccessBlockConfiguration_BlockPublicPolicy = $true
    PublicAccessBlockConfiguration_IgnorePublicAcl =  $true
    PublicAccessBlockConfiguration_RestrictPublicBucket = $true
}

Add-S3PublicAccessBlock @s3PublicParams


# Create cloudtrail

$params = @{
    Name=$CloudTrailName
    S3BucketName=$BucketName
    EnableLogFileValidation = $true
    IsMultiRegionTrail = $true
    IncludeGlobalServiceEvent = $true
}

New-CTTrail @params

$tag = New-Object -TypeName Amazon.CloudTrail.Model.Tag
$tag.Key = 'Description'
$tag.Value = 'All region Cloudtrail logging all data events for S3 and Lambda.'

Add-CTTag -ResourceId  (Get-CTTrail -TrailNameList $CloudTrailName).TrailARN -TagsList $tag

# create event selector

$EventSelector = New-Object -TypeName Amazon.CloudTrail.Model.EventSelector

$EventSelector.IncludeManagementEvents = $true
$EventSelector.ReadWriteType = 'All'


$S3DataResource = New-Object -TypeName Amazon.CloudTrail.Model.DataResource 
$S3DataResource.Type = 'AWS::S3::Object'
$S3DataResource.Values = 'arn:aws:s3'

$LambdaDataResource = New-Object -TypeName Amazon.CloudTrail.Model.DataResource 
$LambdaDataResource.Type = 'AWS::Lambda::Function'
$LambdaDataResource.Values = 'arn:aws:lambda'

$EventSelector.DataResources = $S3DataResource, $LambdaDataResource

Write-CTEventSelector -TrailName $CloudTrailName -EventSelector $EventSelector


Start-CTLogging -Name $CloudTrailName


Set-ClipboardText $AccountName

