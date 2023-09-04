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
  name       = format("test-vm-c-%03d", count.index)
  instance_type = "f1-micro"
  network_interfaces = [{
    network    = module.source-new-vpc.self_link
    subnetwork = module.source-new-vpc.subnet_self_links["${var.source_region}/source-new-s1"]
  }]
  service_account_create = false
  
  boot_disk = {
      name = "hdd"
      image = "projects/debian-cloud/global/images/family/debian-10"
      size = 64
      type = "pd-standard"
    
  }

  # disks: SSD 340G, HDD 64G+42G
  attached_disks = [
    {
      name        = "ssd"
      size        = 340
      source_type = null
      options = {type = "pd-ssd"}
    },
    {
      name        = "hd1"
      size        = 37
      source_type = null
      options = {type = "pd-standard"}
    },
    {
      name        = "hd2"
      size        = 38
      source_type = null
      options = {type = "pd-standard"}
    },
    {
      name        = "hd3"
      size        = 39
      source_type = null
      options = {type = "pd-standard"}
    },
    {
      name        = "hd4"
      size        = 40
      source_type = null
      options = {type = "pd-standard"}
    },
    {
      name        = "hd5"
      size        = 41
      source_type = null
      options = {type = "pd-standard"}
    },
    {
      name        = "hd6"
      size        = 42
      source_type = null
      options = {type = "pd-standard"}
    },
    {
      name        = "hd7"
      size        = 43
      source_type = null
      options = {type = "pd-standard"}
    },
    {
      name        = "hd8"
      size        = 44
      source_type = null
      options = {type = "pd-standard"}
    },
    
  ]
  metadata = {
    startup-script = <<EOF
      #!/bin/bash
      sudo apt-get update && sudo apt-get install iperf
      iperf -s
      export SSD=$(lsblk | grep 340G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      export HD1=$(lsblk | grep 37G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      export HD2=$(lsblk | grep 38G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      export HD3=$(lsblk | grep 39G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      export HD4=$(lsblk | grep 40G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      export HD5=$(lsblk | grep 41G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      export HD6=$(lsblk | grep 42G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      export HD7=$(lsblk | grep 43G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)
      export HD8=$(lsblk | grep 44G | cut -d' ' -f1 | perl -ple 's/(.*)/sudo ls -lh \/dev\/$1/' | sh | cut -d'/' -f3)

      mkfs.ext4 /dev/$SSD
      mkfs.ext4 /dev/$HD1
      mkfs.ext4 /dev/$HD2
      mkfs.ext4 /dev/$HD3
      mkfs.ext4 /dev/$HD4
      mkfs.ext4 /dev/$HD5
      mkfs.ext4 /dev/$HD6
      mkfs.ext4 /dev/$HD7
      mkfs.ext4 /dev/$HD8

      mkdir /mnt/ssd
      mkdir /mnt/hd1
      mkdir /mnt/hd2
      mkdir /mnt/hd3
      mkdir /mnt/hd4
      mkdir /mnt/hd5
      mkdir /mnt/hd6
      mkdir /mnt/hd7
      mkdir /mnt/hd8

      mount /dev/$SSD /mnt/ssd
      mount /dev/$HD1 /mnt/hd1
      mount /dev/$HD2 /mnt/hd2
      mount /dev/$HD3 /mnt/hd3
      mount /dev/$HD4 /mnt/hd4
      mount /dev/$HD5 /mnt/hd5
      mount /dev/$HD6 /mnt/hd6
      mount /dev/$HD7 /mnt/hd7
      mount /dev/$HD8 /mnt/hd8

      touch /bigblob.dat
      touch /mnt/ssd/bigblob.dat
      touch /mnt/hd1/bigblob.dat
      touch /mnt/hd2/bigblob.dat
      touch /mnt/hd3/bigblob.dat
      touch /mnt/hd4/bigblob.dat
      touch /mnt/hd5/bigblob.dat
      touch /mnt/hd6/bigblob.dat
      touch /mnt/hd7/bigblob.dat
      touch /mnt/hd8/bigblob.dat

      dd if=/dev/random of=/mnt/ssd/bigblob.dat bs=1M count=330K &
      dd if=/dev/random of=/bigblob.dat bs=1M count=33K &

      dd if=/dev/random of=/mnt/hd1/bigblob.dat bs=1M count=34K &
      dd if=/dev/random of=/mnt/hd2/bigblob.dat bs=1M count=35K &
      dd if=/dev/random of=/mnt/hd3/bigblob.dat bs=1M count=36K &
      dd if=/dev/random of=/mnt/hd4/bigblob.dat bs=1M count=37K &
      dd if=/dev/random of=/mnt/hd5/bigblob.dat bs=1M count=38K &
      dd if=/dev/random of=/mnt/hd6/bigblob.dat bs=1M count=39K &
      dd if=/dev/random of=/mnt/hd7/bigblob.dat bs=1M count=40K &
      dd if=/dev/random of=/mnt/hd8/bigblob.dat bs=1M count=41K &

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

