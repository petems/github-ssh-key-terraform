# github-ssh-key-terraform

A Terraform setup to create an SSH key and upload it to Github, as well as write a local copy of the public and private keys to to to `~.ssh/github_ssh_key_03_Mar_2020` 

It also gives you the config needed to put into your `.ssh/config` file:

```
$ terraform output github_ssh_configfile
Host github.com
  ControlMaster auto
  ControlPath ~/.ssh/ssh-%r@%h:%p
  ControlPersist yes
  User git
  IdentityFile ~/.ssh/github_ssh_key_08_Mar_2020
```

## Pre-requisites

You'll need a Github OAuth token, which you can export to `export GITHUB_TOKEN=abc123`

## Example

```shell
$ terraform apply
data.external.todays_date: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # github_user_ssh_key.macbook_github_date will be created
  + resource "github_user_ssh_key" "macbook_github_date" {
      + etag  = (known after apply)
      + id    = (known after apply)
      + key   = (known after apply)
      + title = "Personal MacBook Air - 03_Mar_2020"
      + url   = (known after apply)
    }

  # local_file.github_private_key_local will be created
  + resource "local_file" "github_private_key_local" {
      + directory_permission = "0777"
      + file_permission      = "0600"
      + filename             = "/Users/petersouter/.ssh/github_ssh_key_03_Mar_2020"
      + id                   = (known after apply)
      + sensitive_content    = (sensitive value)
    }

  # local_file.github_public_key_local will be created
  + resource "local_file" "github_public_key_local" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0600"
      + filename             = "/Users/petersouter/.ssh/github_ssh_key_03_Mar_2020.pub"
      + id                   = (known after apply)
    }

  # tls_private_key.github_key will be created
  + resource "tls_private_key" "github_key" {
      + algorithm                  = "ECDSA"
      + ecdsa_curve                = "P384"
      + id                         = (known after apply)
      + private_key_pem            = (sensitive value)
      + public_key_fingerprint_md5 = (known after apply)
      + public_key_openssh         = (known after apply)
      + public_key_pem             = (known after apply)
      + rsa_bits                   = 2048
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

tls_private_key.github_key: Creating...
tls_private_key.github_key: Creation complete after 0s [id=c845630ce12919a54c1666611e79c8daacf623a6]
local_file.github_private_key_local: Creating...
local_file.github_public_key_local: Creating...
local_file.github_public_key_local: Creation complete after 0s [id=613739f68cb1c2b92b0688e4ce55010ada4ec585]
local_file.github_private_key_local: Creation complete after 0s [id=d5285e4aac7fa2cad5ca8d572228aef07ad118db]
github_user_ssh_key.macbook_github_date: Creating...
github_user_ssh_key.macbook_github_date: Creation complete after 2s [id=41483472]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

github_ssh_configfile = Host github.com
  ControlMaster auto
  ControlPath ~/.ssh/ssh-%r@%h:%p
  ControlPersist yes
  User git
  IdentityFile ~/.ssh/github_ssh_key_03_Mar_2020

ssh_key_path = /Users/petersouter/.ssh/github_ssh_key_03_Mar_2020
test_ssh = You can now run `ssh -T git@github.com` to test the ssh setup is correct
```