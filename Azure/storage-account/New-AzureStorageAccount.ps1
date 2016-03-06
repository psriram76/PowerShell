#To get resource groups run> Get-AzureRmResourceGroup 
#Use raw files fron github
$deployname = "storageAcctTemplate"
$rgname = "research-resource-group-Matt"
$TemplateUri = "https://raw.githubusercontent.com/MatthewJDavis/PowerShell/azure-storage-accounts/Azure/storage-account/storage-account-template/azuredeploy.json"
$TemplateParameterUri = "https://raw.githubusercontent.com/MatthewJDavis/PowerShell/azure-storage-accounts/Azure/storage-account/storage-account-template/azuredeploy.parameters.json"


New-AzureRmResourceGroupDeployment -Name $deployname -ResourceGroupName $rgname -TemplateUri $TemplateUri -TemplateParameterUri $TemplateParameterUri




