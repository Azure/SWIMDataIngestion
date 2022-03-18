variable "suffix" {
  type        = string
  default     = "MZV"
  description = "To be added at the beginning of each resource."
}

variable "rgName" {
  type        = string
  default     = "AfG2021"
  description = "Resource Group Name."
}

variable "workspaceName" {
  type        = string
  default     = "DBWokspaceSingleNode"
  description = "DataBricks Workspace name."
}
