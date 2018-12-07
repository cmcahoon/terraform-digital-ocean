variable "digitalocean_ssh_pubkey" {}

resource "digitalocean_ssh_key" "key" {
    name = "cloud-expo"
    public_key = "${file("${var.digitalocean_ssh_pubkey}")}"
}

resource "digitalocean_droplet" "web" {
    image = "ubuntu-18-04-x64"
    name = "web"
    region = "sfo2"
    size = "s-1vcpu-1gb"
    ssh_keys = [
        "${digitalocean_ssh_key.key.id}"
    ]
}