#Create resource groups
$name = "research-resource-group-Paul"
$location = "northeurope"
$environment = "Research"
$department = "IT"
$user = "Matt Davis"


New-AzureRmResourceGroup -Name $name -Location $location -Tag @{Name="Environment";Value="$environment"},@{Name="Department";Value="$department"},@{Name="User";Value="$user"}

#create virtual network
#https://azure.microsoft.com/en-gb/documentation/articles/virtual-networks-create-vnet-arm-ps/
New-AzureRmVirtualNetwork -Name "research-vnet-Matt" -ResourceGroupName "research-resource-group-Matt" -AddressPrefix "192.168.0.0/16" -Location $location -Tag @{Name="Environment";Value="$environment"},@{Name="Department";Value="$department"},@{Name="User";Value="$user"}
$vnet = Get-AzureRmVirtualNetwork -Name "research-vnet-Matt" -ResourceGroupName "research-resource-group-Matt"
Add-AzureRmVirtualNetworkSubnetConfig -Name "test" -VirtualNetwork $vnet -AddressPrefix "192.168.5.0/24" -Verbose
#set in Azure
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet 

#create storage accounts

#create virtual machine