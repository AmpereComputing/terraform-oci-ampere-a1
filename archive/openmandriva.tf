# "OpenMandriva Linux"
resource "oci_marketplace_accepted_agreement" "openmandriva_accepted_agreement" {
  agreement_id    = oci_marketplace_listing_package_agreement.openmandriva_package_agreement.agreement_id
  compartment_id  = var.tenancy_ocid
  listing_id      = data.oci_marketplace_listing.openmandriva.id
  package_version = data.oci_marketplace_listing.openmandriva.default_package_version
  signature       = oci_marketplace_listing_package_agreement.openmandriva_package_agreement.signature
}
resource "oci_marketplace_listing_package_agreement" "openmandriva_package_agreement" {
  agreement_id    = data.oci_marketplace_listing_package_agreements.openmandriva_package_agreements.agreements[0].id
  listing_id      = data.oci_marketplace_listing.openmandriva.id
  package_version = data.oci_marketplace_listing.openmandriva.default_package_version
}
data "oci_marketplace_listings" "openmandriva" {
  pricing        = ["Free"]
  name           = ["OpenMandriva"]
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_package_agreements" "openmandriva_package_agreements" {
  listing_id      = data.oci_marketplace_listing.openmandriva.id
  package_version = data.oci_marketplace_listing.openmandriva.default_package_version
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_package" "openmandriva_package" {
  listing_id      = data.oci_marketplace_listing.openmandriva.id
  package_version = data.oci_marketplace_listing.openmandriva.default_package_version
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_packages" "openmandriva_packages" {
  listing_id     = data.oci_marketplace_listing.openmandriva.id
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing" "openmandriva" {
  listing_id     = data.oci_marketplace_listings.openmandriva.listings[0].id
  compartment_id = var.tenancy_ocid
}
data "oci_core_app_catalog_listing_resource_versions" "openmandriva_app_catalog_listing_resource_versions" {
  listing_id     = data.oci_marketplace_listing_package.openmandriva_package.app_catalog_listing_id
}
data "oci_core_app_catalog_listing_resource_version" "openmandriva_catalog_listing" {
  listing_id       = data.oci_marketplace_listing_package.openmandriva_package.app_catalog_listing_id
  resource_version = data.oci_marketplace_listing_package.openmandriva_package.app_catalog_listing_resource_version
}
resource "oci_core_app_catalog_listing_resource_version_agreement" "openmandriva_app_catalog_listing_resource_version_agreement" {
  listing_id               = data.oci_marketplace_listing_package.openmandriva_package.app_catalog_listing_id
  listing_resource_version = data.oci_core_app_catalog_listing_resource_versions.openmandriva_app_catalog_listing_resource_versions.app_catalog_listing_resource_versions[0].listing_resource_version
}
resource "oci_core_app_catalog_subscription" "openmandriva_app_catalog_subscription" {
  compartment_id           = var.tenancy_ocid
  eula_link                = oci_core_app_catalog_listing_resource_version_agreement.openmandriva_app_catalog_listing_resource_version_agreement.eula_link
  listing_id               = oci_core_app_catalog_listing_resource_version_agreement.openmandriva_app_catalog_listing_resource_version_agreement.listing_id
  listing_resource_version = oci_core_app_catalog_listing_resource_version_agreement.openmandriva_app_catalog_listing_resource_version_agreement.listing_resource_version
  oracle_terms_of_use_link = oci_core_app_catalog_listing_resource_version_agreement.openmandriva_app_catalog_listing_resource_version_agreement.oracle_terms_of_use_link
  signature                = oci_core_app_catalog_listing_resource_version_agreement.openmandriva_app_catalog_listing_resource_version_agreement.signature
  time_retrieved           = oci_core_app_catalog_listing_resource_version_agreement.openmandriva_app_catalog_listing_resource_version_agreement.time_retrieved
}

# Output OCI OpenMandriva Image ID
output OCI_OpenMandriva_Linux_Image_id {
    value   = data.oci_core_app_catalog_listing_resource_version.openmandriva_catalog_listing.listing_resource_id
}
