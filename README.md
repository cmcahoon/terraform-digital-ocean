# terraform-digital-ocean

## Overview
Bootstrap Digital Ocean with Terraform! When complete the following Digital Ocean resources will be created:
1. An SSH key for connecting to Droplets
1. A small ($5/mo) droplet with a publically accessible IP address.

## Prerequisites
### Digital Ocean Personal Access Token
For Terraform to provision Digital Ocean you need to create an account and personal access token with **write** access. Digital Ocean, being awesome, provides [documentation](https://www.digitalocean.com/docs/api/create-personal-access-token/) for creating access tokens.

### Install Terraform
You can download Terraform >= 1.0.0 from [here](https://www.terraform.io/downloads.html).

### Create an SSH key
To connect to your droplets you will need an SSH key. To create use `ssh-keygen` and answer the questions:

```bash
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key: <home_dir>/.ssh/digitalocean
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in <home_dir>/.ssh/digitalocean.
Your public key has been saved in <home_dir>/.ssh/digitalocean.pub.
The key fingerprint is:
...
```

## Configuration
Create a file in the root project directory called `secrets.auto.tfvars` with the following variables declared:

```
digitalocean_token="<access_token>"
digitalocean_ssh_pubkey="<home_dir>/.ssh/digitalocean.pub"
```

Terraform will automatically load variables from `terraform.tfvars` and `*.auto.tfvars`. In this repo, `secrets.auto.tfvars` is ignored by git. If you create your own make sure you don't commit it.

## Provision
Use the `terraform` CLI to provision Digital Ocean.

Initialize the project:
```
$ terraform init

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "digitalocean" (1.0.2)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.digitalocean: version = "~> 1.0"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Ask terraform to make a provision plan:
```bash
$ terraform plan -out /tmp/tf.plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # digitalocean_droplet.web will be created
  + resource "digitalocean_droplet" "web" {
      + backups              = false
      + created_at           = (known after apply)
      + disk                 = (known after apply)
      + id                   = (known after apply)
      + image                = "ubuntu-24-04-x64"
      + ipv4_address         = (known after apply)
      + ipv4_address_private = (known after apply)
      + ipv6                 = false
      + ipv6_address         = (known after apply)
      + locked               = (known after apply)
      + memory               = (known after apply)
      + monitoring           = false
      + name                 = "web"
      + price_hourly         = (known after apply)
      + price_monthly        = (known after apply)
      + private_networking   = (known after apply)
      + region               = "sfo2"
      + resize_disk          = true
      + size                 = "s-1vcpu-1gb"
      + ssh_keys             = [
          + (known after apply),
        ]
      + status               = (known after apply)
      + urn                  = (known after apply)
      + vcpus                = (known after apply)
      + volume_ids           = (known after apply)
      + vpc_uuid             = (known after apply)
    }

  # digitalocean_ssh_key.key will be created
  + resource "digitalocean_ssh_key" "key" {
      + fingerprint = (known after apply)
      + id          = (known after apply)
      + name        = "cloud-expo"
      + public_key  = "<public_key>"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: /tmp/tf.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "/tmp/tf.plan"
```

Take a look at the plan and make sure it makes sense. It should show that it will be adding two resources to Digital Ocean, a SSH key and a Droplet. To apply:
```bash
$ terraform apply /tmp/tf.plan
digitalocean_ssh_key.key: Creating...
digitalocean_ssh_key.key: Creation complete after 1s [id=44463378]
digitalocean_droplet.web: Creating...
digitalocean_droplet.web: Still creating... [10s elapsed]
digitalocean_droplet.web: Still creating... [20s elapsed]
digitalocean_droplet.web: Still creating... [30s elapsed]
digitalocean_droplet.web: Creation complete after 38s [id=461718872]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

public_addrs = 142.93.84.192
```

Notice the outputs at the end. You can ask Terraform to provide information about what has been provisioned. In this output you will see the IP address of the new droplet with the key `public_addrs`.

### Login
Use the IP from the provisioning output to SSH to your new Droplet:
```bash
$ ssh -i <home_dir>/.ssh/digitalocean root@<droplet_ip>
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.8.0-31-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of ...

  System load:  0.0               Processes:           95
  Usage of /:   4.5% of 24.05GB   Users logged in:     0
  Memory usage: 15%               IP address for eth0: ...
  Swap usage:   0%



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

root@web:~$
```

Congratulations! You have an Ubuntu droplet running in Digital Ocean.

### Teardown
If you want to remove everything you provisioned, and save money, run:
```bash
$ terraform destroy
digitalocean_ssh_key.key: Refreshing state... (ID: 23667833)
digitalocean_droplet.web: Refreshing state... (ID: 122159481)

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  - digitalocean_droplet.web

  - digitalocean_ssh_key.key


Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

digitalocean_droplet.web: Destroying... (ID: 122159481)
digitalocean_droplet.web: Still destroying... (ID: 122159481, 10s elapsed)
digitalocean_droplet.web: Destruction complete after 12s
digitalocean_ssh_key.key: Destroying... (ID: 23667833)
digitalocean_ssh_key.key: Destruction complete after 1s

Destroy complete! Resources: 2 destroyed.
```

## State Management
Terraform keeps track of what it has provisioned in what it calls **state**. When you make a provision plan it compares this state to what the cloud provider has provisioned. Point being, it's important.

In this repo, the state is writen to `terraform.tfstate`. This file is ignored by git. If you want to share the state between multiple machines or users you should read the Terraform docs on [backends](https://www.terraform.io/docs/backends/index.html).
