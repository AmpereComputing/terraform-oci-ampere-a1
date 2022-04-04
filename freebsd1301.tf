# gets the FreeBSD images, the first result in the images list
# (index 0) is the latest patched version filter to specific display
# name pattern to include the aarch64 images

data "oci_core_images" "freebsd-13_1-aarch64" {
  compartment_id = var.tenancy_ocid

  operating_system         = "FreeBSD"
  operating_system_version = "13.1-RC1"

  # include Aarch64 specific images
  filter {
    name   = "display_name"
     values = ["^.*-aarch64-.*$"]
    regex  = true
  }
}

output "FreeBSD-13_1-aarch64-latest_name" {
  value = data.oci_core_images.freebsd-13_1-aarch64.images.0.display_name
}

output "FreeBSD-13_1-aarch64-latest_ocid" {
  value = data.oci_core_images.freebsd-13_1-aarch64.images.0.id
}
