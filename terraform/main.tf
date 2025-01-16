resource "proxmox_vm_qemu" "k8s-master" {

  name = "arpa-k8s-master-01" # Name to call the VM
  desc = "Kubernetes Master" # Description for the VM
  target_node = var.proxmox_host # Proxmox target node

  clone = var.template_name  # The name of the template that this resource will be created from

  agent = 1 # is the qemu agent installed?

  cores = 2 # number of CPU cores
  sockets = 1 # number of CPU sockets
  cpu = "host" # The CPU type
  memory = 2048 # Amount of memory to allocate
  onboot = false # start the VM on host startup

  # if you want two NICs, just copy this whole network section and duplicate it
  network {
    model = "virtio"
    bridge = "vmbr1"
    tag = 2003
  }

  ipconfig0 = "ip=10.0.3.2,gw=10.0.3.1"
  nameserver = "10.0.2.2"
  searchdomain = "lab.arpa"

  serial {
    id = 0
    type = "socket"
  }

  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

  # Terraform has provisioners that allow the execution of commands / scripts on a local or remote machine.
  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt upgrade -y", "echo Done!"]

    connection {
      host        = "10.0.3.2"
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
    }
  }
}
