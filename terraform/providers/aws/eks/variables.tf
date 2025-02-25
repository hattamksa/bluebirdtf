variable "organization" {
  type        = string
  description = "Organization name"
  default     = "Organization company"
}

variable "product" {
  type        = string
  description = "Product name"
  default     = "learning"
}

variable "division" {
  type        = string
  description = "Division name"
  default     = "Devops"
}

variable "k8s_version" {
  type        = map(string)
  description = "Kubernetes version"
  default = {
    stg = "1.28"
  }
}


variable "ng_rest_instance_type" {
  type        = map(string)
  description = "Node worker instance type"
  default = {
    stg = "t3.medium"
  }
}
variable "sa_autoscaler_namespace" {
  type        = string
  description = "Kube system namespace for autoscaler"
  default     = "kube-system"
}

variable "sa_autoscaler_name" {
  type        = string
  description = "Service account name for autoscaler"
  default     = "cluster-autoscaler"
}
variable "sa_storage_s3_namespace" {
  type        = string
  description = "Kube system namespace for autoscaler"
  default     = "default"
}

variable "sa_storage_s3_name" {
  type        = string
  description = "Service account name for autoscaler"
  default     = "access-s3"
}
variable "rest_taints" {
  type        = list(any)
  description = "Service account name for autoscaler"
  default = [
    {
      key    = "rest"
      value  = "true"
      effect = "NO_SCHEDULE"
    },
    {
      key    = "rest"
      value  = "true"
      effect = "NO_EXECUTE"
    }
  ]
}
