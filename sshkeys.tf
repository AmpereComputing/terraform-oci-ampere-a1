# Create SSH Keys to USE w/ This instance

resource "tls_private_key" "oci" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "oci-ssh-privkey" {
    content = tls_private_key.oci.private_key_pem
    filename = "${path.module}/oci_ampere_a1-id_rsa"
    file_permission = "0600"
}

resource "local_file" "oci-ssh-pubkey" {
    content  = tls_private_key.oci.public_key_openssh
    filename = "${path.module}/oci_ampere_a1-id_rsa.pub"
    file_permission = "0644"
}

output "oci_ssh_pubic_key" {
  value = tls_private_key.oci.public_key_openssh
}

output "oci_ssh_private_key" {
  value = tls_private_key.oci.private_key_pem
  sensitive = true
}

locals {
  ssh_public_key = "${file("${path.module}/oci_ampere_a1-id_rsa.pub")}"
}
