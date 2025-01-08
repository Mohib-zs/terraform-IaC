# Description: Create a Key Vault and a Key for use with Azure Kubernetes Service (AKS)

$resource_group_name    = 'my-app-resources'
$location               = 'centralus'
$key_vault_name         = 'hashicorp-vault-5120'
$aks_cluster_name       = 'my-app-aks'

az keyvault create --name $key_vault_name --resource-group $resource_group_name --location $location
$AKS_IDENTITY = az aks show --resource-group $resource_group_name --name $aks_cluster_name --query identityProfile.kubeletidentity.clientId -o tsv
az keyvault set-policy --name $key_vault_name --spn $AKS_IDENTITY --key-permissions get unwrapKey wrapKey
az keyvault key create --vault-name $key_vault_name --name 'vault-key' --kty RSA --size 2048