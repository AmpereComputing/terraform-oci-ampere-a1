# gets the Ubuntu 20.04 images, the first result in the images list (index 0) is the latest patched version
# filter to specific display name pattern to include the aarch64 images

data "oci_core_images" "ubuntu-20_04-aarch64" {
  compartment_id = var.tenancy_ocid

  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.04"

  # include Aarch64 specific images
  filter {
    name   = "display_name"
     values = ["^.*-aarch64-.*$"]
    regex  = true
  }
}

output "Ubuntu-20_04-aarch64-latest_name" {
  value = data.oci_core_images.ubuntu-20_04-aarch64.images.0.display_name
}

output "Ubuntu-20_04-aarch64-latest_ocid" {
  value = data.oci_core_images.ubuntu-20_04-aarch64.images.0.id
}
