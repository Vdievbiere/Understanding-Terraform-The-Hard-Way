## list workspaces 
```
terraform workspace list 
```

## Create workspace 
```
terraform workspace new sbx
terraform workspace new prod 
terraform workspace new dev
```
## show specif workspace 
```
terraform workspace show
```
## create the tfvars
```sh
touch sbx.tfvars dev.tfvars prod.tfvars
```
## switch workspace
```
terraform workspace select dev
```
how do we run plan in this approach 
# NOTE
```
terraform workspace show 
terraform plan -var-file sbx.tfvars
```

## Unlock state file
```
terraform force-unlock f8ba4a88-0d6a-a275-e56e-781944a64e6d
```

## To Destroy 
```
terraform workspace select sbx 
terraform destroy -var-file sbx.tfvars
```