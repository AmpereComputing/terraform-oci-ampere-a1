# This dynamically gets the Oracle Linux 9 images, the first result in the images 
# list (index 0) is the latest patched version.  Filter to specific display name 
# pattern to include the aarch64 images

data "oci_core_images" "oraclelinux-9-aarch64" {
  compartment_id = var.tenancy_ocid

  operating_system         = "Oracle Linux"
  operating_system_version = "9"

  # include Aarch64 specific images
  filter {
    name   = "display_name"
     values = ["^.*-aarch64-.*$"]
    regex  = true
  }
}

# Output OCI AlmaLinux 9 Image ID
output "OracleLinux-9-aarch64-latest-name" {
  value = data.oci_core_images.oraclelinux-9-aarch64.images.0.display_name
  sensitive = false
}

# Output OCI AlmaLinux 9 Image ID
output "OracleLinux-9-aarch64-latest_ocid" {
  value = data.oci_core_images.oraclelinux-9-aarch64.images.0.id
  sensitive = false
}
