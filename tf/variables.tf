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

variable "project_id" {
  description = "Project ID"
  type = string
}

variable "source_region" {
  description = "Source region"
  type = string
  default = "europe-west5"
}

variable "target_region" {
  description = "Target region"
  type = string
  default = "europe-west3"
}

variable "source_zone" { # TODO
  description = "Source zone"
  type = string
  default = "europe-west5-a"
}

variable "instances" {
  description = "Number of instances to create"
  type = number
  default = 1
}