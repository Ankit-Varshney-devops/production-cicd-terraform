variable "aws_region" {
    description = "Region for the VPC"
}

variable access_key {
    description ="Please provide your AWS access Keys"
    type = string
}
variable secret_key {
    description ="Please provide your AWS secret Keys"
    type = string
}

variable "app_name" {
    description = "Name of the project"
    type = string
}
variable instance_type {
    description ="Please provide instance type"
    type = string
    default = "t2.micro"
}

variable "key_name" {
    description ="Please provide name of pem file"
    type = string
}

variable "env_type" {
    default = "prod"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

# variable "subnet_cidrs_public" {
#   description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
#   default = ["10.0.1.0/24", "10.0.2.0/24"]
#   type = list
# } 

# variable "public_subnet_tags" {
#   description = "AZs in this region to use"
#   default = ["Public Subnet-A", "Public Subnet-B"]
#   type = list
# }

variable "codestarconnections_name" {
  description = "Please provide the name of codestarconnection"
  default = "test"
  type = string
}

variable "reponame" {
  description = "Please provide the name of repo"
  type = string
}

variable "repo-branch" {
  description = "Branch name"
  type = string
}

variable "env_vars" {
  default = {
  }
} 

variable db_instance_type {
    description ="Please provide database instance you want to create like db.t2.micro, db.t3.medium"
    type = string
    default = "db.t2.micro"
}


variable db_username {
    description ="Please provide database Master username"
    default = "postgres"
    type = string
}

variable db_password {
    description ="Please provide database Master password"
    type = string
}

variable db_name {
    description ="Please provide database name"
    type = string
}

variable user {
    description ="Please provide database username"
    type = string
}

variable passwd {
    description ="Please provide database password"
    type = string
}

