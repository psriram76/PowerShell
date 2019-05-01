$RoleName = 'lambda_volume_tagging'
$RoleDescription = 'Allow lambda to apply tags to volumes'
$PolicyName = 'lambda-volume-tagging'
$PolicyDescription = 'Allow lambdas to log and also tag volumes'

$policy = New-IamPolicy -PolicyName $policyName -Description $PolicyDescription -PolicyDocument (Get-Content -Path lambda-tagging-policy.json -Raw)
New-IamRole -RoleName $RoleName -Description $RoleDescription -AssumeRolePolicyDocument (Get-Content -Path lambda-trust-policy.json -Raw)

Register-IAMRolePolicy -PolicyArn $policy.Arn -RoleName $RoleName
