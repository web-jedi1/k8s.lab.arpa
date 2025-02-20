resource "proxmox_vm_qemu" "k8s-master" {
  count = 2
  name = "arpa-k8s-master-${count.index + 1}"
  desc = "Kubernetes Master -> ${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template_name  
  full_clone = true
  vmid = "200${count.index + 1}"
  tags = "terraform,kubernetes,ubuntu-jammy,master"

  agent = 1
  cores = 1
  sockets = 1
  memory = 2048 
  onboot = false
  os_type = "cloud-init"
  bootdisk = "scsi0"
  scsihw = "virtio-scsi-pci"

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr1"
    tag = 2003
  }

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size = 50
          storage = "local-lvm"
        }
      }
    }
  }

  ipconfig0 = "ip=10.0.3.${count.index + 2}/24,gw=10.0.3.1"
  nameserver = "10.0.2.2"
  searchdomain = "lab.arpa"

  serial {
    id = 0
    type = "socket"
  }

  ciuser = var.ciuser
  cipassword = var.cipassword
  sshkeys = <<EOF
  ${var.terraform_pub_key}
  EOF

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt upgrade -y", "sudo apt -y autoremove"]

    connection {
      host        = "10.0.3.${count.index + 2}"
      type        = "ssh"
      user        = var.ciuser
      private_key    = file("/var/lib/jenkins/.ssh/terraform")
    }
  }
}

resource "proxmox_vm_qemu" "k8s-worker" {
  count = 2
  name = "arpa-k8s-worker-${count.index + 1}"
  desc = "Kubernetes Worker -> ${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template_name  
  full_clone = true
  vmid = "201${count.index + 1}"
  tags = "terraform,kubernetes,ubuntu-jammy,worker"

  agent = 1
  cores = 2
  sockets = 1
  memory = 4096 
  onboot = false
  os_type = "cloud-init"
  bootdisk = "scsi0"
  scsihw = "virtio-scsi-pci"

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr1"
    tag = 2003
  }

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size = 50
          storage = "local-lvm"
        }
      }
    }
  }

  ipconfig0 = "ip=10.0.3.${count.index + 11}/24,gw=10.0.3.1"
  nameserver = "10.0.2.2"
  searchdomain = "lab.arpa"

  serial {
    id = 0
    type = "socket"
  }

  ciuser = var.ciuser
  cipassword = var.cipassword
  sshkeys = <<EOF
  ${var.terraform_pub_key}
  EOF

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt upgrade -y", "sudo apt -y autoremove"]

    connection {
      host        = "10.0.3.${count.index + 11}"
      type        = "ssh"
      user        = var.ciuser
      private_key    = file("/var/lib/jenkins/.ssh/terraform")
    }
  }
}