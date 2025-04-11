module "vnet" {
  source              = "git::https://github.com/avinashsumanmakka/avinashproject.git?ref=main"
  vnet_name           = "dev-eastus-vnet"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
  subnets = {
    default = {
      address_prefixes = ["10.0.1.0/24"]
    }
  }
  tags = var.tags
  create_nsg = true
}

resource "azurerm_windows_virtual_machine" "dev_vm" {
  name                = "dev-vm-eastus"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.this.name
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!"
  network_interface_ids = [azurerm_network_interface.dev.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  tags = var.tags
}

resource "azurerm_network_interface" "dev" {
  name                = "dev-nic"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.this.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["default"]
    private_ip_address_allocation = "Dynamic"
  }
}
