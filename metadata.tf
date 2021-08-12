# Cloud Init Metadata

data "template_file" "cloud_config" {
  template = file("${path.module}/templates/cloud-init.yaml.tpl")
  vars = {
    tf_ssh_privkey = tls_private_key.oci.private_key_pem
    tf_ssh_pubkey = tls_private_key.oci.public_key_openssh
    tf_random_id = random_uuid.random_id.result
  }
}

output "cloud_init" {
  value = data.template_file.cloud_config.rendered
}
