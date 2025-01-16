terraform {
    required_version = ">= 1.1.0"
    required_providers {
        proxmox = {
            source  = "telmate/proxmox"
            version = "2.9.5"
        }
    }
}

provider "proxmox" {
    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_api_token_id
    pm_api_token_secret = var.proxmox_api_token_secret

    pm_tls_insecure = true
    pm_parallel     = 2
    pm_timeout      = 1200
}
