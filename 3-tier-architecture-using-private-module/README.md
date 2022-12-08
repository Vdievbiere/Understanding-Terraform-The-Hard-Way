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
## show specific workspace 
```
terraform workspace show
```
## create the tfvars
```sh
touch sbx.tfvars dev.tfvars prod.tfvars
```
## switch workspace
```
terraform workspace select sbx
```
how do we run plan in this approach 
# NOTE
```
terraform workspace show 
terraform validate -var-file sbx.tfvars
terraform plan -var-file sbx.tfvars
terraform apply -var-file sbx.tfvars
terraform destroy -var-file sbx.tfvars

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
## To Connect to app1
familybeyondcloud.com/app1

## To Connect to app2
familybeyondcloud.com/app2

## Connect to Registration app
familybeyondcloud.com

# password
username: kojitechs 
password: password101

# Connect To Database on Registration-app-1 instances via ssm fleet manager
mysql -h enpoint -u kojitechs -p
show databases;
use webappdb;
show schemas;
show user;
select * from user;
