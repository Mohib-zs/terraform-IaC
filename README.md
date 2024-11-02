### initialize

    terraform init

### preview terraform actions

    terraform plan

### apply configuration with variables

    terraform apply

### destroy a single resource

    terraform destroy -target azurerm_network_security_group.my-app

### destroy everything from tf files

    terraform destroy

### show resources and components from current state

    terraform state list

### show current state of a specific resource/data

    terraform state show azurerm_network_security_group.my-app    

### set location as custom tf environment variable - before apply

    export TF_VAR_location="centralus"