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

# tfdoc:file:description temporary instances for testing

module "source-new-vpc" {
  source     = "../modules/net-vpc"
  project_id = var.project_id
  name       = "source-new-0"
  mtu        = 1460
  dns_policy = {
    inbound = false
    logging = false
  }
  subnets = [
    {
      ip_cidr_range = "10.11.0.0/18"
      name          = "source-new-s1"
      region        = var.source_region
    },
    {
      ip_cidr_range = "10.12.0.0/18"
      name          = "source-new-s2"
      region        = var.source_region
    }
  ]
}

module "target-vpc" {
  source     = "../modules/net-vpc"
  project_id = var.project_id
  name       = "target-new-0"
  mtu        = 1460
  dns_policy = {
    inbound = false
    logging = false
  }
  subnets = [
    {
      ip_cidr_range = "10.13.0.0/18"
      name          = "target-new-s1"
      region        = var.target_region
    },
    {
      ip_cidr_range = "10.14.0.0/18"
      name          = "target-new-s2"
      region        = var.target_region
    }
  ]
}

resource "google_compute_firewall" "allow_iap_ssh" {
  project  = var.project_id
  name = "allow-iap-ssh-new"
  network = "source-new-0"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]

}

resource "google_compute_firewall" "allow_iap_ssh_t0" {
  project  = var.project_id
  name = "allow-iap-ssh-new-t0"
  network = "target-new-0"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]

}

