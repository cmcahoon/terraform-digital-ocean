# partlycloudy / terraform

## Overview
Bootstrap Digital Ocean with Terraform! When complete the following Digital Ocean resources will be created:
1. An SSH key for connecting to Droplets
1. A small ($5/mo) droplet with a publically accessible IP address.

## Prerequisites
### Digital Ocean Personal Access Token
For Terraform to provision Digital Ocean you need to create an account and personal access token with **write** access. Digital Ocean, being awesome, provides [documentation](https://www.digitalocean.com/docs/api/create-personal-access-token/) for creating access tokens.

### Install Terraform
You can download Terraform 11.10 from [here](https://www.terraform.io/downloads.html).

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
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + digitalocean_droplet.web
      id:                   <computed>
      backups:              "false"
      disk:                 <computed>
      image:                "ubuntu-18-04-x64"
      ipv4_address:         <computed>
      ipv4_address_private: <computed>
      ipv6:                 "false"
      ipv6_address:         <computed>
      ipv6_address_private: <computed>
      locked:               <computed>
      memory:               <computed>
      monitoring:           "false"
      name:                 "web"
      price_hourly:         <computed>
      price_monthly:        <computed>
      private_networking:   "false"
      region:               "sfo2"
      resize_disk:          "true"
      size:                 "s-1vcpu-1gb"
      ssh_keys.#:           <computed>
      status:               <computed>
      vcpus:                <computed>
      volume_ids.#:         <computed>

  + digitalocean_ssh_key.key
      id:                   <computed>
      fingerprint:          <computed>
      name:                 "cloud-expo"
      public_key:           "<public_key>"


Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

This plan was saved to: /tmp/tf.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "/tmp/tf.plan"
```

Take a look at the plan and make sure it makes sense. It should show that it will be adding two resources to Digital Ocean, a SSH key and a Droplet. To apply:
```bash
$ terraform apply /tmp/tf.plan
digitalocean_ssh_key.key: Creating...
  fingerprint: "" => "<computed>"
  name:        "" => "cloud-expo"
  public_key:  "" => "<public_key>"
digitalocean_ssh_key.key: Creation complete after 1s (ID: 23667833)
digitalocean_droplet.web: Creating...
  backups:              "" => "false"
  disk:                 "" => "<computed>"
  image:                "" => "ubuntu-18-04-x64"
  ipv4_address:         "" => "<computed>"
  ipv4_address_private: "" => "<computed>"
  ipv6:                 "" => "false"
  ipv6_address:         "" => "<computed>"
  ipv6_address_private: "" => "<computed>"
  locked:               "" => "<computed>"
  memory:               "" => "<computed>"
  monitoring:           "" => "false"
  name:                 "" => "web"
  price_hourly:         "" => "<computed>"
  price_monthly:        "" => "<computed>"
  private_networking:   "" => "false"
  region:               "" => "sfo2"
  resize_disk:          "" => "true"
  size:                 "" => "s-1vcpu-1gb"
  ssh_keys.#:           "" => "1"
  ssh_keys.2983182265:  "" => "23667833"
  status:               "" => "<computed>"
  vcpus:                "" => "<computed>"
  volume_ids.#:         "" => "<computed>"
digitalocean_droplet.web: Still creating... (10s elapsed)
digitalocean_droplet.web: Still creating... (20s elapsed)
digitalocean_droplet.web: Still creating... (30s elapsed)
digitalocean_droplet.web: Creation complete after 35s (ID: 122159481)

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

public_addrs = 142.93.84.192
```

Notice the outputs at the end. You can ask Terraform to provide information about what has been provisioned. In this output you will see the IP address of the new droplet with the key `public_addrs`.

### Login
Use the IP from the provisioning output to SSH to your new Droplet:
```bash
$ ssh -i <home_dir>/.ssh/digitalocean root@<droplet_ip>
Welcome to Ubuntu 18.04.1 LTS (GNU/Linux 4.15.0-38-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri Dec  7 00:19:02 UTC 2018

  System load:  0.0               Processes:           80
  Usage of /:   3.9% of 24.06GB   Users logged in:     0
  Memory usage: 12%               IP address for eth0: 142.93.84.192
  Swap usage:   0%

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.



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
