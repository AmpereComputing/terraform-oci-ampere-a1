# This dynamically gets the AlmaLinux 8.5 images, the first result in the images 
# list (index 0) is the latest patched version.  Filter to specific display name 
# pattern to include the aarch64 images

data "oci_core_images" "almalinux-8_5-aarch64" {
  compartment_id = var.tenancy_ocid

  operating_system         = "AlmaLinux"
  operating_system_version = "8"

  # include Aarch64 specific images
  filter {
    name   = "display_name"
     values = ["^.*-aarch64-.*$"]
    regex  = true
  }
}

output "AlmaLinux-8_5-aarch64-latest-name" {
  value = data.oci_core_images.almalinux-8_5-aarch64.images.0.display_name
}

output "AlmaLinux-8_5-aarch64-latest_ocid" {
  value = data.oci_core_images.almalinux-8_5-aarch64.images.0.id
}
