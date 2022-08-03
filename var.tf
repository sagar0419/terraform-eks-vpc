##access key and secret var
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

##Region
variable "aws-region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region where you want to create your cluster"
}

##VPC variable
variable "vpc-cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "IP and CIDR value of VPC"
}

#I am using us-west-2 in this example which have following AZ "us-west-2a, us-west-2b, us-west-2c, us-west-2d". Change your AZ according to your region.
variable "zone-1" {
  type        = string
  default     = "us-west-2a"
  description = "public subnet-1"
}
variable "zone-2" {
  type        = string
  default     = "us-west-2b"
  description = "public subnet-2"
}

variable "zone-3" {
  type        = string
  default     = "us-west-2c"
  description = "private subnet-3"
}
variable "zone-4" {
  type        = string
  default     = "us-west-2d"
  description = "private subnet-4"
}

variable "public-cidr-1" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Public subnet-1"
}
variable "public-cidr-2" {
  type        = string
  default     = "10.0.2.0/24"
  description = "Public subnet-2"
}
variable "public-cidr-3" {
  type        = string
  default     = "10.0.3.0/24"
  description = "Public subnet-3"
}
variable "public-cidr-4" {
  type        = string
  default     = "10.0.4.0/24"
  description = "Public subnet-4"
}
variable "private-cidr-5" {
  type        = string
  default     = "10.0.5.0/24"
  description = "Private subnet-5"
}
variable "private-cidr-6" {
  type        = string
  default     = "10.0.6.0/24"
  description = "Private subnet-6"
}
variable "private-cidr-7" {
  type        = string
  default     = "10.0.7.0/24"
  description = "Private subnet-7"
}
variable "private-cidr-8" {
  type        = string
  default     = "10.0.8.0/24"
  description = "Private subnet-8"
}
##Cluster Variabels
variable "cluster-name" {
  type        = string
  default     = "sagar"
  description = "eks cluster name"
}
variable "eks-role" {
  type        = string
  default     = "sagar-eks-role"
  description = "eks-role name"
}
variable "eks-version" {
  type        = string
  default     = "1.22"
  description = "version of kubernetes on eks cluster"
}

##Node Variables
variable "nodegroup-name" {
  type        = string
  default     = "sagar"
  description = "Name of the nodegroup"
}

variable "desired_size" {
  type        = number
  default     = 2
  description = "Number of nodes need to run"
}

variable "max_size" {
  type        = number
  default     = 3
  description = "Max number of nodes to be added in cluster"
}
variable "min_size" {
  type        = number
  default     = 1
  description = "Minimum number of nodes runing at any given time"
}
variable "max_unavailable" {
  type        = number
  default     = 2
  description = "Maximum number of node that can be unavailable during cluster update"
}
variable "node_instance_type" {
  type        = any
  default     = ["t3.medium"]
  description = "Type of instance that can be added as nodes in eks cluster"
}

variable "ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Other valid values are ( AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 | BOTTLEROCKET_x86_64)"
}
variable "capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "Type of capacity associated with the EKS Node Group. Valid values (ON_DEMAND, SPOT)"
}
variable "disk_size" {
  type        = number
  default     = 20
  description = "Size of volume attach to a node"
}