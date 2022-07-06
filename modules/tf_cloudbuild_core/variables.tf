/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_labels" {
  description = "Labels to apply to the project."
  type        = map(string)
  default     = {}
}

variable "storage_bucket_labels" {
  description = "Labels to apply to the storage bucket."
  type        = map(string)
  default     = {}
}

variable "project_prefix" {
  description = "Name prefix to use for projects created."
  type        = string
  default     = "cft"
}

variable "project_id" {
  description = "Custom project ID to use for project created."
  default     = ""
  type        = string
}

variable "random_suffix" {
  description = "Appends a 4 character random suffix to project ID and GCS bucket name."
  type        = bool
  default     = true
}

variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "folder_id" {
  description = "The ID of a folder to host this project"
  type        = string
  default     = ""
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "group_org_admins" {
  description = "Google Group for GCP Organization Administrators"
  type        = string
}

variable "location" {
  description = "Location for build artifacts bucket"
  type        = string
  default     = "us-central1"
}

variable "buckets_force_destroy" {
  description = "When deleting CloudBuild buckets, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects."
  type        = bool
  default     = false
}

variable "activate_apis" {
  description = "List of APIs to enable in the Cloudbuild project."
  type        = list(string)

  default = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com"
  ]
}

variable "create_cloud_source_repos" {
  description = "If shared Cloud Source Repos should be created."
  type        = bool
  default     = true
}

variable "cloud_source_repos" {
  description = "List of Cloud Source Repos to create with CloudBuild triggers."
  type        = list(string)

  default = [
    "gcp-policies",
    "gcp-org",
    "gcp-envs",
    "gcp-networks",
    "gcp-projects",
  ]
}

variable "create_worker_pool" {
  description = "Create a private worker pool."
  type        = bool
  default     = false
}

variable "worker_pool_disk_size_gb" {
  description = "Size of the disk attached to the worker, in GB."
  type        = number
  default     = 100
}

variable "worker_pool_machine_type" {
  description = "Machine type of a worker."
  type        = string
  default     = "e2-medium"
}

variable "worker_pool_no_external_ip" {
  description = "If true, workers are created without any public address, which prevents network egress to public IPs."
  type        = bool
  default     = false
}
