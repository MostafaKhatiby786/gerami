terraform {
  required_version = ">= 0.13"
  required_providers {
        vsphere = {
      source = "hashicorp/vsphere"
      version = "2.6.1"
    }

  }
}

provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "Root!123"
  vsphere_server       = "192.168.8.150"
  allow_unverified_ssl = true
}
