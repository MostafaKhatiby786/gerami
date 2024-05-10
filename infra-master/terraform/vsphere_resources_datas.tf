data "vsphere_datacenter" "datacenter" {
  name = "DC-Devops"
}


data "vsphere_datastore""esxi3-datastore1" {
  name          = "esxi3-ds1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_compute_cluster" "cluster" {
  name          = "Cluster1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_host" "esxi03" {
  name          = "192.168.8.2"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "vm-network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "internet" {
  name          = "internet"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_host_port_group" "port-OS-VM-NET" {
  name            = "port-OS-VM-NET"
  host_system_id  = data.vsphere_host.esxi03.id
  virtual_switch_name = "vSwitch0"
  allow_promiscuous = true
}

data "vsphere_network" "OS-VM-NET" {
  name          = "OS-VM-NET"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "ubuntu-2204-template" {
  name          = "ubuntu-jammy-22.04-cloudimg"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}