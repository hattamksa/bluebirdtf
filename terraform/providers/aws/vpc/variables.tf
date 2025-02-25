variable "organization" {
  type        = string
  description = "Organization name"
  default     = "Organization company"
}

variable "product" {
  type        = string
  description = "Product name"
  default     = "bluebird"
}

variable "division" {
  type        = string
  description = "Division name"
  default     = "Devops"
}

variable "vpc_cidr" {
  type        = map(string)
  description = "Public Subnet CIDR values"
  default     = {
    stg  = "10.0.0.0/16" 
  }
}

variable "public_subnet_cidrs" {
  type        = map(list(string))
  description = "Public Subnet CIDR values"
  default     = {
    stg  = ["10.0.1.0/24", "10.0.2.0/24"] 
  }
}
 
variable "private_subnet_cidrs" {
  type        = map(list(string))
  description = "Private Subnet CIDR values"
  default     = {
    stg  = ["10.0.4.0/24", "10.0.5.0/24"] 
  }
}

variable "subnet_azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

 
 