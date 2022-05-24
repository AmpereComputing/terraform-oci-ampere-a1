# Cloud Init Metadata


locals {
  # return var.cloud_init_template_path if it's not null
  # otherwise return "${path.module}/templates/cloud-init.yaml.tpl"
  cloud_init_template_file = coalesce(var.cloud_init_template_file, "${path.module}/templates/cloud-init.yaml.tpl")
}

data "template_file" "cloud_config" {
# template = file("${path.module}/templates/cloud-init.yaml.tpl")
  template = file("${local.cloud_init_template_file}")
}

output "cloud_init" {
  value = data.template_file.cloud_config.rendered
  sensitive = false
}
