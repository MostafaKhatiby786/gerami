resource "vsphere_virtual_machine" "mk-ceph-one" {
  name             = "ceph-one-m"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  host_system_id   = data.vsphere_host.esxi03.id
  datastore_id     = data.vsphere_datastore.esxi3-datastore1.id
  num_cpus         = 8
  memory           = 8196
  guest_id         = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.vm-network.id
  }
  network_interface {
    network_id = data.vsphere_network.vm-network.id
  }
  disk {
    label = "disk0"
    size  = 40
    unit_number = 0
  }
  disk {
    label = "disk1"
    size  = 40
    unit_number = 1
  }
  disk {
    label = "disk2"
    size  = 40
    unit_number = 2
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu-2204-template.id
    linked_clone = false
    customize {
      linux_options {
        host_name = "ceph-one-m"
        domain    = "ceph.local"
        time_zone = "Asia/Tehran"
        # script_text = 
      }
      network_interface {
        ipv4_address = "10.10.200.201"
        ipv4_netmask = 24
        # dns_domain   = "8.8.8.8"
      }
      # network_interface {}
      network_interface {
        ipv4_address = "192.168.200.201"
        ipv4_netmask = 24
      }
      ipv4_gateway = "10.10.200.1"
      dns_server_list = [ "8.8.8.8", "1.1.1.1" ]
    }
  }
  cdrom {
    client_device = true
  }
  vapp {
    properties = {
      "password"     = "123456789"
      "public-keys"  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYdy03Af3agUeN9KCGQ5dnrR3wotMhUVbsfYVTxwYKtThtJj6Lahz5fUuWA+mDIBMvv3kiBVal6sJuymEBL7eJmji1sOVdJmmnBUqrkadR94ikkTL3Rw/fFEinzFAQZ8MU8sNUij6skNI6Gpns2DSATaFp3iHimq88ahYXtjr5bGqUptKGgEQJNpbnxGrK/+y12fcl2wQDpTRL++t8c1LSj/Rm6Ejg68tBQNiu+Gx9MmkH5uorLlcv8wIl1H4XkdeHL+nA0K39+cUISW5/kV7s0S0e4V7j2KmMuXzPcWcugBUbC6ZoB3VPvoDz1AtpBSdBmfGLsnQfFQkLIe9J8ShTDgMtKuG/ZrJqsAxFb22k67NE+Gm9aDscZmWfdjKcy85oBxW2DizD1zjwWMEj7uujNRNKsjy0LzQi0D6lD9GoclN0PYBBmklsSceGaaDGHv8yPr9ok2fOkflBpMSkbDmcrhf9zhcoTMleujDD+4CWZwCzmDhafiRfE+1HmCs05/U= mkh@mkh-System-Product-Name"
    }
  }
  lifecycle {
    ignore_changes = [
      ept_rvi_mode,
      hv_mode
    ]
  }
}

resource "vsphere_virtual_machine" "mk-ceph02" {
  name             = "ceph-two-m"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  host_system_id   = data.vsphere_host.esxi03.id
  datastore_id     = data.vsphere_datastore.esxi3-datastore1.id
  num_cpus         = 8
  memory           = 8196
  guest_id         = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.vm-network.id
  }
  network_interface {
    network_id = data.vsphere_network.vm-network.id
  }
  disk {
    label = "disk0"
    size  = 40
    unit_number = 0
  }
  disk {
    label = "disk1"
    size  = 40
    unit_number = 1
  }
  disk {
    label = "disk2"
    size  = 40
    unit_number = 2
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu-2204-template.id
    linked_clone = false
    customize {
      linux_options {
        host_name = "ceph-two-m"
        domain    = "ceph.local"
        time_zone = "Asia/Tehran"
        # script_text = 
      }
      network_interface {
        ipv4_address = "10.10.200.202"
        ipv4_netmask = 24
        # dns_domain   = "8.8.8.8"
      }
      # network_interface {}
      network_interface {
        ipv4_address = "192.168.200.202"
        ipv4_netmask = 24
      }
      ipv4_gateway = "10.10.200.1"
      dns_server_list = [ "8.8.8.8", "1.1.1.1" ]
    }
  }
  cdrom {
    client_device = true
  }
  vapp {
    properties = {
      "password"     = "123456789"
      "public-keys"  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYdy03Af3agUeN9KCGQ5dnrR3wotMhUVbsfYVTxwYKtThtJj6Lahz5fUuWA+mDIBMvv3kiBVal6sJuymEBL7eJmji1sOVdJmmnBUqrkadR94ikkTL3Rw/fFEinzFAQZ8MU8sNUij6skNI6Gpns2DSATaFp3iHimq88ahYXtjr5bGqUptKGgEQJNpbnxGrK/+y12fcl2wQDpTRL++t8c1LSj/Rm6Ejg68tBQNiu+Gx9MmkH5uorLlcv8wIl1H4XkdeHL+nA0K39+cUISW5/kV7s0S0e4V7j2KmMuXzPcWcugBUbC6ZoB3VPvoDz1AtpBSdBmfGLsnQfFQkLIe9J8ShTDgMtKuG/ZrJqsAxFb22k67NE+Gm9aDscZmWfdjKcy85oBxW2DizD1zjwWMEj7uujNRNKsjy0LzQi0D6lD9GoclN0PYBBmklsSceGaaDGHv8yPr9ok2fOkflBpMSkbDmcrhf9zhcoTMleujDD+4CWZwCzmDhafiRfE+1HmCs05/U= mkh@mkh-System-Product-Name"
    }
  }
  lifecycle {
    ignore_changes = [
      ept_rvi_mode,
      hv_mode
    ]
  }
}

resource "vsphere_virtual_machine" "mk-ceph03" {
  name             = "ceph-three-m"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  host_system_id   = data.vsphere_host.esxi03.id
  datastore_id     = data.vsphere_datastore.esxi3-datastore1.id
  num_cpus         = 8
  memory           = 8196
  guest_id         = "ubuntu64Guest"
  network_interface {
    network_id = data.vsphere_network.vm-network.id
  }
  network_interface {
    network_id = data.vsphere_network.vm-network.id
  }
  disk {
    label = "disk0"
    size  = 40
    unit_number = 0
  }
  disk {
    label = "disk1"
    size  = 40
    unit_number = 1
  }
  disk {
    label = "disk2"
    size  = 40
    unit_number = 2
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu-2204-template.id
    linked_clone = false
    customize {
      linux_options {
        host_name = "ceph-three-m"
        domain    = "ceph.local"
        time_zone = "Asia/Tehran"
        # script_text = 
      }
      network_interface {
        ipv4_address = "10.10.200.203"
        ipv4_netmask = 24
        # dns_domain   = "8.8.8.8"
      }
      # network_interface {}
      network_interface {
        ipv4_address = "192.168.200.203"
        ipv4_netmask = 24
      }
      ipv4_gateway = "10.10.200.1"
      dns_server_list = [ "8.8.8.8", "1.1.1.1" ]
    }
  }
  cdrom {
    client_device = true
  }
  vapp {
    properties = {
      "password"     = "123456789"
      "public-keys"  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYdy03Af3agUeN9KCGQ5dnrR3wotMhUVbsfYVTxwYKtThtJj6Lahz5fUuWA+mDIBMvv3kiBVal6sJuymEBL7eJmji1sOVdJmmnBUqrkadR94ikkTL3Rw/fFEinzFAQZ8MU8sNUij6skNI6Gpns2DSATaFp3iHimq88ahYXtjr5bGqUptKGgEQJNpbnxGrK/+y12fcl2wQDpTRL++t8c1LSj/Rm6Ejg68tBQNiu+Gx9MmkH5uorLlcv8wIl1H4XkdeHL+nA0K39+cUISW5/kV7s0S0e4V7j2KmMuXzPcWcugBUbC6ZoB3VPvoDz1AtpBSdBmfGLsnQfFQkLIe9J8ShTDgMtKuG/ZrJqsAxFb22k67NE+Gm9aDscZmWfdjKcy85oBxW2DizD1zjwWMEj7uujNRNKsjy0LzQi0D6lD9GoclN0PYBBmklsSceGaaDGHv8yPr9ok2fOkflBpMSkbDmcrhf9zhcoTMleujDD+4CWZwCzmDhafiRfE+1HmCs05/U= mkh@mkh-System-Product-Name"
    }
  }
  lifecycle {
    ignore_changes = [
      ept_rvi_mode,
      hv_mode
    ]
  }
}
