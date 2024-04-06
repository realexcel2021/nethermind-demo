# Run Nethermind on Docker using EC2 Instance

This repo creates networking for an EC2 instance on AWS with internet access to demo how to spin up nethermind node on docker. The EC2 instance has scripts that Installs docker and creates a single contaier with nethermind running on it. 

## How to Use
To use this repo, ensure you have the following configured and installed
 - AWS CLI
 - AWS Access Keys configured
 - Terraform Installed
 - Git installed

First clone repo and change directory into the repo's directory

```
git clone https://github.com/realexcel2021/nethermind-demo
```

Change directory into the cloned folder

```
cd nethermind-demo
```

Spin up resources on AWS using terraform, first initialize terraform 
```
terraform init
```

validate configurations
```
terraform validate
```

Create resources
```
terraform apply --auto-approve
```

Interact with Nethermind using JSON-RPC
```
curl <instance public ip>:8545 \
  -X POST \
  -H "Content-Type: application/json" \
  --data '{
      "jsonrpc": "2.0",
      "id": 0,
      "method": "admin_nodeInfo",
      "params": []
    }'
```

## Clean up

Destroy all resources

```
terraform destroy --auto-approve
```