# This variable should be set in one of the following ways:
#   1) Provide the token when prompted by the CLI
#   2) Add CLI flag:  `-var="digital_ocean_token=<token>"`
#   3) Define variable in a *.tfvars file
variable "digitalocean_token" {}

# Enable the Digital Ocean provider
provider "digitalocean" {
    token = "${var.digitalocean_token}"
}

output "public_addrs" {
    value = "${digitalocean_droplet.web.ipv4_address}"
}
