# provider vars
variable "proxmox_api_url"{
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}

# resource vars
variable "proxmox_host" {
  type = string
}

variable "template_name" {
  type =  string
  default = "debian-template"
}

variable "ansible_user"{
  type = string
}

variable "private_key_path"{
  type = string
}

variable "public_key_path"{
  type = string
}

variable "ssh_pub_key" {
  type = string
}

