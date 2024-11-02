variable subscription_id {
  type      = string
  sensitive = true
}
variable subnet_address_prefix {}
variable vnet_address_prefix {}
variable env_prefix {}
variable location {}
variable my_ip {}
variable ansible_server_ip {}
variable vm_size {}
variable vm_username {}
variable vm_names {}                #No.of Names = No.of Vms ["vm1", "vm2"]
# variable ssh_private_key {}
# variable vault_password_file {}