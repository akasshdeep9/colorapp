#__________________________________________________________
#
# Terraform Cloud Organization
#__________________________________________________________

variable "tfc_organization" {
  default     = "Netnology-MINT"
  description = "Terraform Cloud Organization."
  type        = string
}


#______________________________________________
#
# Terraform Cloud kubeconfig Workspace
#______________________________________________

variable "tfc_workspace" {
  default     = "kubeconfig"
  description = "Terraform Cloud Workspace Name."
  type        = string
}
