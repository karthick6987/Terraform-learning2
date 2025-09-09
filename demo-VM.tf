resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.cloud_in_azure_rb.location
  resource_group_name = data.azurerm_resource_group.cloud_in_azure_rb.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = data.azurerm_resource_group.cloud_in_azure_rb.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
} 


module "virtual-machine" {
  source  = "Azure/virtual-machine/azurerm"
  version = "2.0.0"

image_os ="Windows2019Server"
location =data.azurerm_resource_group.cloud_in_azure_rb.location
name = "myappvm"
os_disk = {
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 128
}
resource_group_name=data.azurerm_resource_group.cloud_in_azure_rb.name
size ="Standard_F2"
subnet_id = azurerm_subnet.subnet.id
admin_username       = "adminuser"
admin_password       = "L1feb0@t"

}

