# Get a list of Availability Domains

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Output Availability Domain Results
output "OCI_Availability_Domains" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}
