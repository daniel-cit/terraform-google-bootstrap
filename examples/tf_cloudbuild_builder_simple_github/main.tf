/**
 * Copyright 2024 Google LLC
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

locals {
  # GitHub repo url of form "github.com/owner/name"
  repoURL              = endswith(var.repository_uri, ".git") ? var.repository_uri : "${var.repository_uri}.git"
  repoURLWithoutSuffix = trimsuffix(local.repoURL, ".git")
  gh_repo_url_split    = split("/", local.repoURLWithoutSuffix)
  gh_name              = local.gh_repo_url_split[length(local.gh_repo_url_split) - 1]

  location = "us-central1"
}

module "cloudbuilder" {
  # source  = "terraform-google-modules/bootstrap/google//modules/tf_cloudbuild_builder"
  # version = "~> 8.0"
  source = "../../modules/tf_cloudbuild_builder"

  project_id                  = module.enabled_google_apis.project_id
  dockerfile_repo_uri         = module.github_connection.cloud_build_repositories_2nd_gen_connection
  dockerfile_repo_type        = "GITHUB"
  use_cloudbuildv2_repository = true
  trigger_location            = local.location
  gar_repo_location           = local.location
  bucket_name                 = "tf-cloudbuilder-build-logs-${var.project_id}-gh"
  gar_repo_name               = "tf-runners-gh"
  workflow_name               = "terraform-runner-workflow-gh"
  trigger_name                = "tf-cloud-builder-build-gh"

  # allow logs bucket to be destroyed
  cb_logs_bucket_force_destroy = true
}

module "github_connection" {
  source = "../../modules/cloudbuild_repo_connection"

  project_id = var.project_id
  connection_config = {
    connection_type         = "GITHUBv2"
    github_secret_id        = var.github_pat_secret_id
    github_app_id_secret_id = var.github_app_id_secret_id
  }

  cloud_build_repositories = {
    "test_repo" = {
      repository_name = local.gh_name
      repository_url  = var.repository_uri
    },
  }
}

data "google_secret_manager_secret_version_access" "github_pat" {
  secret = var.github_pat_secret_id
}

# Bootstrap GitHub with Dockerfile
module "bootstrap_github_repo" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.1"
  upgrade = false

  create_cmd_entrypoint = "${path.module}/scripts/push-to-repo.sh"
  create_cmd_body       = "${data.google_secret_manager_secret_version_access.github_pat.secret_data} ${var.repository_uri} ${path.module}/Dockerfile"
}