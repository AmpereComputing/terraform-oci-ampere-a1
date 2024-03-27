# This dynamically gets the Oracle Linux 8 images, the first result in the images 
# list (index 0) is the latest patched version.  Filter to specific display name 
# pattern to include the aarch64 images

data "oci_core_images" "oraclelinux-8-aarch64" {
  compartment_id = var.tenancy_ocid

  operating_system         = "Oracle Linux"
  operating_system_version = "8"

  # include Aarch64 specific images
  #filter {
  #  name   = "display_name"
  #   values = ["^.*-aarch64-.*$"]
  #  regex  = true
  #}
}

# Output OCI AlmaLinux 8 Image Name
output "OracleLinux-8-aarch64-latest-name" {
  value = data.oci_core_images.oraclelinux-8-aarch64.images.0.display_name
  sensitive = false
}

# Output OCI AlmaLinux 8 Image ID
output "OracleLinux-8-aarch64-latest_ocid" {
  value = data.oci_core_images.oraclelinux-8-aarch64.images.0.id
  sensitive = false
}
