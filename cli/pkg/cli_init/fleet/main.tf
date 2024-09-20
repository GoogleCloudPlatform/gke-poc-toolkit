module "fleet" {
  source                            = "{{.TFModuleRepo}}fleet?ref={{.TFModuleBranch}}"
  project_id                        = var.project_id
  fleet_project                     = var.fleet_project
  config_sync_repo                  = var.config_sync_repo
  config_sync_repo_branch           = var.config_sync_repo_branch
  config_sync_repo_dir              = var.config_sync_repo_dir
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "fleet_project" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "config_sync_repo" {
  description = "Git repo used as the default config sync repo for your fleet."
  type = string
  default = null
}

variable "config_sync_repo_branch" {
  description = "Git repo branch used as the default config sync repo for your fleet."
  type = string
  default = null
}

variable "config_sync_repo_dir" {
  description = "Git repo directory used as the default config sync repo for your fleet."
  type = string
  default = null
}


