# Terraform Script to create VPC and EKS

## What resources are created 

- VPC
- Internet Gateway (IGW)
- 2 NAT Gateway for High Availability
- Public and Private Subnets
- Security Groups, Route Tables and Route Table Associations
- IAM roles, instance profiles and policies
- An EKS Cluster in public subnet
- EKS Managed Node group in private subnet
- Autoscaling group and Launch Configuration
- The ConfigMap required to register Nodes with EKS
- Kubeconfig file to access the cluster.

##Prerequisite 

###IAM 

The AWS credentials must be associated with a user having at least the following AWS managed IAM policies

- IAMFullAccess
- AutoScalingFullAccess
- AmazonEKSClusterPolicy
- AmazonEKSWorkerNodePolicy
- AmazonVPCFullAccess
- AmazonEKSServicePolicy
- AmazonEKS_CNI_Policy
- AmazonEC2FullAccess

** In addition, you will need to create the following managed policies **

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        }
    ]
}
```
### Details about repo 

- This repo contains code to create a Hybrid VPC and eks cluster with terraform. 
- All the variables are defined in vars.tf if you want to pass your variable add them in terraform.tfvars file. 
- To access the AWS you can add your access and secret key in terraform.tfvars file. Or the other way around is you can create the env variable with the name "TF_VAR_AWS_ACCESS_KEY" and "TF_VAR_AWS_SECRET_KEY" and this automation script will automatically fetch the variables during execution. 
- This script will create A VPC with public and private subnet and the cluster will get deployed in public subnet and nodes will be in private subnet.
- You need to chnage the bucket name and the region name in "remoteBackend.tf" file according to your need. 
- In file "terraform.tf" version of "Terraform" is defined which has been used to create this chart. You can change the version of the according to your installation.

## Terraform 

To create infra run the below mention command

```sh
    - terraform init
    - terraform plan
    - terraform apply
```

|TIP: you should save the plan state terraform plan -out eks-state or even better yet, setup remote storage for [Terraform state](https://www.terraform.io/language/state/remote). You can store state in an [S3 backend](https://www.terraform.io/language/settings/backends/s3), with locking via DynamoDB | 

### Setup Kubectl
- Setup your <mark>KUBECONFIG</mark>
- terraform output kubeconfig > ~/.kube/eks-cluster
- export KUBECONFIG=~/.kube/eks-cluster
- Edit '~/.kube/eks-cluster' file and remove EOT from begining and end of the file.

## Authorize users to access the cluster 


Initially, only the system that deployed the cluster will be able to access the cluster. To authorize other users for accessing the cluster, aws-auth config needs to be modified by using the steps given below: 

 - Open the aws-auth file in the edit mode on the machine that has been used to deploy EKS cluster:
 
```sh
sudo kubectl edit -n kube-system configmap/aws-auth
```
 - Add the following configuration in that file by changing the placeholders:

 ```yaml
mapUsers: |
  - userarn: arn:aws:iam::111122223333:user/<username>
    username: <username>
    groups:
      - system:masters
 ```

So, the final configuration would look like this:

```yaml
apiVersion: v1
data:
  mapRoles: |
    - rolearn: arn:aws:iam::555555555555:role/devel-worker-nodes-NodeInstanceRole-74RF4UBDUKL6
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::111122223333:user/<username>
      username: <username>
      groups:
        - system:masters
```
 - Once the user map is added in the configuration we need to create cluster role binding for that user:

```sh 
kubectl create clusterrolebinding ops-user-cluster-admin-binding-<username> --clusterrole=cluster-admin --user=<username>
```
Replace the placeholder with proper values

## Cleaning up

Before deleting make sure you have removed all the deployments , service, Ingress etc. 

You can destroy this cluster entirely by running:

```sh
terraform plan -destroy
terraform destroy  
```
