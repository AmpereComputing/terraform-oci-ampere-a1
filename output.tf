# Output the private and public IPs of the instance

output "AmpereA1_PrivateIPs" {
  value     = ["${oci_core_instance.ampere_a1.*.private_ip}"]
  sensitive = false
}

output "AmpereA1_PublicIPs" {
  value     = ["${oci_core_instance.ampere_a1.*.public_ip}"]
  sensitive = false
}

# Output the boot volume IDs of the instance
output "AmpereA1_BootVolumeIDs" {
  value     = ["${oci_core_instance.ampere_a1.*.boot_volume_id}"]
  sensitive = false
}
