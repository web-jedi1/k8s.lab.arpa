resource "proxmox_vm_qemu" "k8s-master" {

  name = "arpa-k8s-master-01"
  desc = "Kubernetes Master"
  target_node = var.proxmox_host
  clone = var.template_name  
  count = 1
  vmid = "200${count.index + 1}"
  tags = "terraform,kubernetes,jammy,master"

  agent = 1
  cores = 1
  sockets = 1
  memory = 2048 
  onboot = false
  os_type = "cloud-init"
  bootdisk = "ide0"
  scsihw = "virtio-scsi-pci"

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr1"
    tag = 2003
  }

#  disk {
#    slot = "scsi0"
#    size = "50G"
#    type = "virtio"
#    storage = "local-lvm"
#  }

  ipconfig0 = "ip=10.0.3.10/24,gw=10.0.3.1"
  nameserver = "10.0.2.2"
  searchdomain = "lab.arpa"

  serial {
    id = 0
    type = "socket"
  }

  ciuser = var.ciuser
  cipassword = var.cipassword
  sshkeys = <<EOF
  ${var.ssh_pub_key}
  EOF

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt upgrade -y", "sudo apt -y autoremove"]

    connection {
      host        = "10.0.3.10"
      type        = "ssh"
      user        = var.ciuser
      password    = var.cipassword
    }
  }
}
