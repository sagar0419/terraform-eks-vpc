# Terraform Script to create VPC and EKS

## What resources are created 

- VPC
- Internet Gateway (IGW)
- Public and Private Subnets
- Security Groups, Route Tables and Route Table Associations
- IAM roles, instance profiles and policies
- An EKS Cluster in public subnet
- EKS Managed Node group
- Autoscaling group and Launch Configuration
- Worker Nodes in a private Subnet
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
### Details about repo \

[![N|Solid](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzEzIiBoZWlnaHQ9Ijg4IiB2aWV3Qm94PSIwIDAgMzEzIDg4IiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIGQ9Ik05OC40NiAzMC40Nkg4Ny4yMXYtNi43MmgzMC4xMjF2Ni43MmgtMTEuMjV2MzMuNmgtNy42MnYtMzMuNnoiIGZpbGw9IiNmZmYiLz48cGF0aCBkPSJNMTI1LjI5MSA1OC41OWEzMC43NyAzMC43NyAwIDAwOS0xLjM5bDEuMTUgNS41NmEzMS42NSAzMS42NSAwIDAxLTEwLjg2IDEuODhjLTkuMjUgMC0xMi40Ni00LjMtMTIuNDYtMTEuMzh2LTcuOGMwLTYuMjMgMi43OC0xMS40OSAxMi4yMi0xMS40OSA5LjQ0IDAgMTEuNTYgNS41IDExLjU2IDExLjg1djYuM2gtMTYuMzJ2MS41MWMwIDMuNTcgMS4yMyA0Ljk2IDUuNzEgNC45NnptLTUuNzEtMTIuNGg5LjM4di0xLjQ2YzAtMi43OC0uODUtNC43MS00LjQ4LTQuNzEtMy42MyAwLTQuOSAxLjkzLTQuOSA0LjcxdjEuNDZ6bTM2LjA4LTUuNDVhNTYuNjAzIDU2LjYwMyAwIDAwLTcuODEgNC4zdjE5LjAyaC03LjM4VjM0LjU3aDYuMjNsLjQ5IDMuMjdhMzIuNjQ4IDMyLjY0OCAwIDAxNy43NC0zLjg3bC43MyA2Ljc3em0xOC4wMTkgMGE1Ny4xMjUgNTcuMTI1IDAgMDAtNy44IDQuM3YxOS4wMmgtNy4zOFYzNC41N2g2LjIzbC40OCAzLjI3YTMyLjc2NCAzMi43NjQgMCAwMTcuNzUtMy44N2wuNzIgNi43N3ptMjQuNjgxIDIzLjMyaC02LjA1bC0uNTQtMmExNi4xNTMgMTYuMTUzIDAgMDEtOC43NyAyLjZjLTUuMzkgMC03LjY5LTMuNjktNy42OS04Ljc3IDAtNiAyLjYxLTguMjkgOC41OS04LjI5aDcuMDh2LTMuMTFjMC0zLjI2LS45LTQuNDEtNS42Mi00LjQxLTIuNzQ3LjAzLTUuNDg0LjMzLTguMTcuOWwtLjkxLTUuNjJhMzguMzE0IDM4LjMxNCAwIDAxMTAuMS0xLjM5YzkuMjYgMCAxMiAzLjI2IDEyIDEwLjY0bC0uMDIgMTkuNDV6bS03LjM4LTExLjE2aC01LjRjLTIuNDIgMC0zLjA5LjY3LTMuMDkgMi45MSAwIDIgLjY3IDMgMyAzIDEuOTUtLjAzIDMuODYxLS41NSA1LjU2LTEuNTFsLS4wNy00LjR6bTMwLjA2OS0yNS4wNGEyMS4xNTQgMjEuMTU0IDAgMDAtNC4yNC0uNDljLTIuOSAwLTMuMzIgMS4yNy0zLjMyIDMuNTF2My42OWg3LjVsLS40MSA1Ljg3aC03LjA3djIzLjYyaC03LjM4VjQwLjQ0aC00Ljcydi01Ljg3aDQuNzJ2LTQuMTFjMC02LjExIDIuODQtOS4xNCA5LjM3LTkuMTRhMjMuNDk2IDIzLjQ5NiAwIDAxNi4zNS44NWwtLjggNS42OXptMTQuMzkgMzYuNzhjLTEwLjEgMC0xMi44Ni01LjU4LTEyLjg2LTExLjU4di03LjQ4YzAtNiAyLjcyLTExLjYxIDEyLjgyLTExLjYxczEyLjgzIDUuNTYgMTIuODMgMTEuNjF2Ny40OGMuMDQgNi0yLjY1IDExLjU4LTEyLjc5IDExLjU4em0wLTI0LjM4Yy0zLjkzIDAtNS40NCAxLjc1LTUuNDQgNS4wOHY3LjkyYzAgMy4zMyAxLjUxIDUuMDkgNS40NCA1LjA5IDMuOTMgMCA1LjQ1LTEuNzYgNS40NS01LjA5di03LjkyYzAtMy4yOC0xLjUxLTUuMDgtNS40NS01LjA4em0zMS44Mi40OGE1Ny4xMjUgNTcuMTI1IDAgMDAtNy44IDQuM3YxOS4wMmgtNy4zOFYzNC41N2g2LjIzbC40OCAzLjI3YTMyLjk0MyAzMi45NDMgMCAwMTcuNzktMy44N2wuNjggNi43N3ptMjAuMzIgMjMuMzJ2LTIwLjZjMC0xLjU3LS42Ny0yLjM2LTIuMzYtMi4zNnMtNSAxLjA5LTcuNjggMi40OXYyMC40N2gtNy4zOVYzNC41N2g1LjYzbC43MyAyLjQ4YTI5LjU5MyAyOS41OTMgMCAwMTExLjc5LTMuMDhjMi44NSAwIDQuNiAxLjE1IDUuNTcgMy4xNGEyOS4wMDQgMjkuMDA0IDAgMDExMS44Ni0zLjE0YzQuOSAwIDYuNjUgMy40NCA2LjY1IDguNzF2MjEuMzhIMzA1di0yMC42YzAtMS41Ny0uNjctMi4zNi0yLjM2LTIuMzZhMTkuNDI1IDE5LjQyNSAwIDAwLTcuNjggMi40OXYyMC40N2gtNy4zOHoiIGZpbGw9IiNmZmYiLz48cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGNsaXAtcnVsZT0iZXZlbm9kZCIgZD0iTTIxLjIgMTYuNTVsMTkuMSAxMS4wM3YyMi4wNkwyMS4yIDM4LjYxVjE2LjU1em0yMS4xOSAxMS4wM3YyMi4wNkw2MS41IDM4LjYxVjE2LjU1TDQyLjM5IDI3LjU4ek0wIDQuMjRWMjYuM2wxOS4xIDExLjAzVjE1LjI3TDAgNC4yNHptMjEuMiA1OC44NWwxOS4xIDExLjAzVjUyLjA2TDIxLjIgNDEuMDN2MjIuMDZ6IiBmaWxsPSIjN0I0MkJDIi8+PC9zdmc+)

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
