# Get a list of Availability Domains

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Output Availability DOmain Results
output "show-ads" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}
