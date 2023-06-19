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
  name       = format("test-vm-%03d", count.index)
  instance_type = "f1-micro"
  network_interfaces = [{
    network    = module.source-vpc.self_link
    subnetwork = module.source-vpc.subnet_self_links["${var.source_region}/source-s1"]
  }]
  service_account_create = false
  
  boot_disk = {
      name = "hdd"
      image = "projects/debian-cloud/global/images/family/debian-10"
      size = 300
      type = "pd-standard"
    
  }

  # disks: SSD 400G, HDD 300G
  attached_disks = [
    {
      name        = "ssd"
      size        = 400
      source_type = null
      options = {
        type = "pd-ssd"
      }
    }
  ]
  metadata = {
    startup-script = <<EOF
      #!/bin/bash
      sudo apt-get update && sudo apt-get install iperf
      iperf -s
      export SSD=$(lsblk | grep 400G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      mkfs.ext4 /dev/$SSD
      mkdir /mnt/ssd
      mount /dev/$SSD /mnt/ssd
      touch /bigblob.dat
      touch /mnt/ssd/bigblob.dat
      dd if=/dev/random of=/mnt/ssd/bigblob.dat bs=1M count=300K &
      dd if=/dev/random of=/bigblob.dat bs=1M count=200K &
    EOF
  }
}



/*
module "test-vm-external" {
  source = "../modules/compute-vm"
  project_id = var.project_id
  zone       = var.source_zone # TODO
  name       = "test-vm-external"
  instance_type = "f1-micro"
  network_interfaces = [{
    network    = module.source-vpc.self_link
    subnetwork = module.source-vpc.subnet_self_links["${var.source_region}/source-s1"]
    addresses = { external = "34.133.142.59", internal = "10.0.0.10" }
  }]
  service_account_create = true
  boot_disk = {
    image = "projects/debian-cloud/global/images/family/debian-10"
  }
  # disks: SSD 400G, HDD 300G
  attached_disks = [
    {
      name        = "hdd"
      size        = "300"
      source_type = null
      options = {
        type = "pd-standard"
      }
    },
    {
      name        = "ssd"
      size        = "400"
      source_type = null
      options = {
        type = "pd-ssd"
      }
    }
  ]
  metadata = {
    startup-script = <<EOF
      #!/bin/bash
      sudo apt-get update && sudo apt-get install iperf
      iperf -s
      export HDD=$(lsblk | grep 300G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      export SSD=$(lsblk | grep 400G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      mkfs.ext4 /dev/$HDD
      mkfs.ext4 /dev/$SSD
      mkdir /mnt/hdd
      mkdir /mnt/ssd
      mount /dev/$HDD /mnt/hdd
      mount /dev/$SSD /mnt/ssd
      touch /mnt/hdd/bigblob.dat
      touch /mnt/ssd/bigblob.dat
      dd if=/dev/random of=/mnt/ssd/bigblob.dat bs=1M count=383K &
      dd if=/dev/random of=/mnt/hdd/bigblob.dat bs=1M count=287K &
    EOF
  }
}
*/

