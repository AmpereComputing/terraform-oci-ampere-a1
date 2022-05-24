# Output the private and public IPs of the instance

output "ampere_a1_private_ips" {
  value     = ["${oci_core_instance.ampere_a1.*.private_ip}"]
  sensitive = false
}

output "ampere_a1_public_ips" {
  value     = ["${oci_core_instance.ampere_a1.*.public_ip}"]
  sensitive = false
}

# Output the boot volume IDs of the instance
output "ampere_a1_boot_volume_ids" {
  value     = ["${oci_core_instance.ampere_a1.*.boot_volume_id}"]
  sensitive = false
}
