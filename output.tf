# Output the private and public IPs of the instance
# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

#output "InstancePrivateIPs" {
#value = ["${oci_core_instance.TFInstance.*.private_ip}"]
#}

#output "InstancePublicIPs" {
#value = ["${oci_core_instance.TFInstance.*.public_ip}"]
#}

# Output the boot volume IDs of the instance
#output "BootVolumeIDs" {
#  value = ["${oci_core_instance.TFInstance.*.boot_volume_id}"]
#}
