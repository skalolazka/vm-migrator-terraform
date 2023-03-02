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

# # Untrusted (Landing)

module "test-vms" {
  source = "../modules/compute-vm"
  count = var.instances
  project_id = var.project_id
  zone       = var.source_zone # TODO
  name       = "test-vm-${count.index}"
  instance_type = "f1-micro"
  network_interfaces = [{
    network    = module.source-vpc.self_link
    subnetwork = module.source-vpc.subnet_self_links["${var.source_region}/source-s1"]
  }]
  service_account_create = true
  boot_disk = {
    image = "projects/debian-cloud/global/images/family/debian-10"
  }
}

