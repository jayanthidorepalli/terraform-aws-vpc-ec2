# Terraform AWS VPC with Public and Private EC2

This Terraform project creates AWS infrastructure:

- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups (22, 80)
- Public EC2
- Private EC2

## Requirements
- Terraform installed
- AWS CLI configured

## Run Steps

terraform init
terraform validate
terraform plan
terraform apply
## Architecture Diagram

![Terraform Architecture] (terraform-architecture.png)

## Destroy

terraform destroy
