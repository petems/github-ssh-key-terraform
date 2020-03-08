provider "github" {
  individual = true
}

data "external" "todays_date" {
  program = ["sh", "-c", "echo \"{\\\"date\\\" : \\\"$(date +\"%d_%b_%Y\")\\\"}\""]
}

locals {
  current_date = "${data.external.todays_date.result.date}"
  filename     = "github_ssh_key_${local.current_date}"
}

resource "tls_private_key" "github_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "local_file" "github_private_key_local" {
  filename          = "${pathexpand("~/.ssh/")}/${local.filename}"
  sensitive_content = chomp(tls_private_key.github_key.private_key_pem)
  file_permission   = "0600"
}

resource "local_file" "github_public_key_local" {
  filename          = "${pathexpand("~/.ssh/")}/${local.filename}.pub"
  content           = chomp(tls_private_key.github_key.public_key_openssh)
  file_permission   = "0600"
}

resource "github_user_ssh_key" "macbook_github_date" {
  title = "Personal MacBook Air - ${local.current_date}"
  key   = chomp(tls_private_key.github_key.public_key_openssh)
}

output "ssh_key_path" {
  value = local_file.github_private_key_local.filename
}

output "github_ssh_configfile" {
  value = <<EOT
Host github.com
  ControlMaster auto
  ControlPath ~/.ssh/ssh-%r@%h:%p
  ControlPersist yes
  User git
  IdentityFile ~/.ssh/${local.filename}
EOT
}

output "test_ssh" {
  value = "You can now run `ssh -T git@github.com` to test the ssh setup is correct"
}