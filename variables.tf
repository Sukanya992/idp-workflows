# variables.tf

variable "gcp_project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "gcp_region" {
  description = "The GCP region to deploy resources into."
  type        = string
  default     = "us-central1"
}

variable "environment_name" {
  description = "A unique name for the environment (e.g., dev, staging, prod)."
  type        = string
}

variable "instance_machine_type" {
  description = "The machine type for the Compute Engine instance."
  type        = string
  default     = "e2-medium"
}
