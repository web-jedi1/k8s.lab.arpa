resource "proxmox_vm_qemu" "k8s-master" {

  name = "arpa-k8s-master-01"
  desc = "Kubernetes Master"
  target_node = var.proxmox_host 

  clone = var.template_name 

  tags = "terraform,kubernetes,jammy,master"

  agent = 1

  cores = 1
  sockets = 1
  memory = 2048 
  onboot = false
  os_type = "cloud-init"

  network {
    model = "virtio"
    bridge = "vmbr1"
    tag = 2003
  }

  ipconfig0 = "ip=10.0.3.10,gw=10.0.3.1"
  nameserver = "10.0.2.2"
  searchdomain = "lab.arpa"

  serial {
    id = 0
    type = "socket"
  }
  ssh_user = "manfred"
  ssh_private_key = <<EOF
  ${var.ssh_pub_key}
  EOF

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt upgrade -y", "sudo apt -y autoremove"]

    connection {
      host        = "10.0.3.10"
      type        = "ssh"
      user        = "manfred"
      private_key = file(var.private_key_path)
    }
  }
}
