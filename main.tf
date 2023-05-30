# Cloud-Init file
locals {
  # return var.cloud_init_template_path if it's not null
  # otherwise return "${path.module}/templates/cloud-init.yaml.tpl"
  cloud_init_template_file = coalesce(var.cloud_init_template_file, "${path.module}/templates/cloud-init.yaml.tpl")
}

# ssh keys
resource "tls_private_key" "oci" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "oci-ssh-privkey" {
    content = tls_private_key.oci.private_key_pem
    filename = "${path.cwd}/oci-id_rsa"
    file_permission = "0600"
}

resource "local_file" "oci-ssh-pubkey" {
    content  = tls_private_key.oci.public_key_openssh
    filename = "${path.cwd}/oci-id_rsa.pub"
    file_permission = "0644"
}

# Output: The dynamically created openssh public key
output "oci_ssh_public_key" {
  value = tls_private_key.oci.public_key_openssh
  sensitive = false
}

# Output: The dynamically created openssh private key
output "oci_ssh_private_key" {
  value = tls_private_key.oci.private_key_pem
  sensitive = true
}

resource "random_uuid" "random_id" { }

# Output: A randomly generated uuid
output "random_uuid" {
  value = random_uuid.random_id.result
  sensitive = false
}
