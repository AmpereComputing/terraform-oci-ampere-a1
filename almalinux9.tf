# "AlmaLinux 9 OS"
resource "oci_marketplace_accepted_agreement" "almalinux_9_accepted_agreement" {
  agreement_id    = oci_marketplace_listing_package_agreement.almalinux_9_package_agreement.agreement_id
  compartment_id  = var.tenancy_ocid
  listing_id      = data.oci_marketplace_listing.almalinux_9.id
  package_version = data.oci_marketplace_listing.almalinux_9.default_package_version
  signature       = oci_marketplace_listing_package_agreement.almalinux_9_package_agreement.signature
}
resource "oci_marketplace_listing_package_agreement" "almalinux_9_package_agreement" {
  agreement_id    = data.oci_marketplace_listing_package_agreements.almalinux_9_package_agreements.agreements[0].id
  listing_id      = data.oci_marketplace_listing.almalinux_9.id
  package_version = data.oci_marketplace_listing.almalinux_9.default_package_version
}
data "oci_marketplace_listings" "almalinux_9" {
  pricing        = ["Free"]
  name           = ["AlmaLinux OS 9 (AArch64)"]
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_package_agreements" "almalinux_9_package_agreements" {
  listing_id      = data.oci_marketplace_listing.almalinux_9.id
  package_version = data.oci_marketplace_listing.almalinux_9.default_package_version
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_package" "almalinux_9_package" {
  listing_id      = data.oci_marketplace_listing.almalinux_9.id
  package_version = data.oci_marketplace_listing.almalinux_9.default_package_version
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_packages" "almalinux_9_packages" {
  listing_id     = data.oci_marketplace_listing.almalinux_9.id
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing" "almalinux_9" {
  listing_id     = data.oci_marketplace_listings.almalinux_9.listings[0].id
  compartment_id = var.tenancy_ocid
}
data "oci_core_app_catalog_listing_resource_versions" "almalinux_9_app_catalog_listing_resource_versions" {
  listing_id     = data.oci_marketplace_listing_package.almalinux_9_package.app_catalog_listing_id
}
data "oci_core_app_catalog_listing_resource_version" "almalinux_9_catalog_listing" {
  listing_id       = data.oci_marketplace_listing_package.almalinux_9_package.app_catalog_listing_id
  resource_version = data.oci_marketplace_listing_package.almalinux_9_package.app_catalog_listing_resource_version
}
resource "oci_core_app_catalog_listing_resource_version_agreement" "almalinux_9_app_catalog_listing_resource_version_agreement" {
  listing_id               = data.oci_marketplace_listing_package.almalinux_9_package.app_catalog_listing_id
  listing_resource_version = data.oci_core_app_catalog_listing_resource_versions.almalinux_9_app_catalog_listing_resource_versions.app_catalog_listing_resource_versions[0].listing_resource_version
}
resource "oci_core_app_catalog_subscription" "almalinux_9_app_catalog_subscription" {
  compartment_id           = var.tenancy_ocid
  eula_link                = oci_core_app_catalog_listing_resource_version_agreement.almalinux_9_app_catalog_listing_resource_version_agreement.eula_link
  listing_id               = oci_core_app_catalog_listing_resource_version_agreement.almalinux_9_app_catalog_listing_resource_version_agreement.listing_id
  listing_resource_version = oci_core_app_catalog_listing_resource_version_agreement.almalinux_9_app_catalog_listing_resource_version_agreement.listing_resource_version
  oracle_terms_of_use_link = oci_core_app_catalog_listing_resource_version_agreement.almalinux_9_app_catalog_listing_resource_version_agreement.oracle_terms_of_use_link
  signature                = oci_core_app_catalog_listing_resource_version_agreement.almalinux_9_app_catalog_listing_resource_version_agreement.signature
  time_retrieved           = oci_core_app_catalog_listing_resource_version_agreement.almalinux_9_app_catalog_listing_resource_version_agreement.time_retrieved
}
output OCI_AlmaLinux_OS_Image_id {
    sensitive = false
    value   = data.oci_core_app_catalog_listing_resource_version.almalinux_9_catalog_listing.listing_resource_id
}
